import 'dart:convert';

import 'package:crm/widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_shared_pref.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../../config/app_routes.dart';
import 'model/picking_counts_response.dart';
import 'model/picking_detail_response.dart';
import 'model/picking_list_response.dart';
import 'model/picking_suggestions_response.dart';

class PickingListController extends GetxController {
  RxBool isLoading = false.obs;
  RxString error = "".obs;
  RxBool isCountsLoading = false.obs;
  Rx<PickingCounts?> pickingCounts = Rx<PickingCounts?>(null);

  RxList<PickingListDatum> pickingList = <PickingListDatum>[].obs;
  RxInt totalCount = 0.obs;
  RxInt pageCount = 1.obs;
  RxInt selectedFilterIndex = 0.obs;
  RxInt selectedInputTabIndex = 0.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  RxBool isDetailLoading = false.obs;
  RxString detailError = "".obs;
  RxBool isSuggestionsLoading = false.obs;
  RxString suggestionsError = "".obs;

  Rx<PickingDetailData?> pickingDetail = Rx<PickingDetailData?>(null);
  Rx<SuggestionsData?> pickingSuggestions = Rx<SuggestionsData?>(null);
  Rx<RackSuggestion?> selectedRack = Rx<RackSuggestion?>(null);

  final RxBool isInvoiceExpanded = false.obs;
  final RxInt selectedAttachmentTab = 0.obs;
  final quantityController = TextEditingController();
  final barcodeController = TextEditingController();
  final startRangeController = TextEditingController();
  final endRangeController = TextEditingController();
  RxString pickQuantity = "".obs;
  RxList<Serial> selectedSerials = <Serial>[].obs;
  RxString rangeError = "".obs;

  @override
  void onInit() {
    super.onInit();
    getPickingCounts();
    fetchData();
  }

  Future<void> getPickingCounts() async {
    isCountsLoading.value = true;
    try {
      String url = "${ApiEndPoint.pickingCounts}?company_id=${Pref.getCompanyId()}";
      if (selectedDate.value != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
        url += "&from_date=$formattedDate&to_date=$formattedDate";
      }
      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        pickingCounts.value = PickingCounts.fromJson(data['data']);
      }
    } catch (e) {
      debugPrint("Error fetching picking counts: $e");
    } finally {
      isCountsLoading.value = false;
    }
  }

  Future<void> fetchData({bool isFirstTime = true, int? page, String? search, String? status}) async {
    if (isFirstTime) {
      isLoading.value = true;
      error.value = "";
    }

    int pageToFetch = page ?? pageCount.value;
    if (pageToFetch == 1) {
      pickingList.clear();
    }

    try {
      String effectiveStatus = status ?? _getStatusFromTabIndex(selectedFilterIndex.value);
      String url =
          "${ApiEndPoint.pickingList}?page=$pageToFetch&limit=50&search=${search ?? searchController.value.text}&company_id=${Pref.getCompanyId()}&location_id=${Pref.getLocationId()}";

      if (effectiveStatus.isNotEmpty) {
        url += "&status=$effectiveStatus";
      }

      if (selectedDate.value != null) {
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
        url += "&from_date=$formattedDate&to_date=$formattedDate";
      }

      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          PickingListResponse pickingListResponse = PickingListResponse.fromJson(data);
          totalCount.value = pickingListResponse.pagination!.totalRecords!;
          pickingList.addAll(pickingListResponse.data!);
        } else {
          error.value = data['message'] ?? "Something went wrong";
        }
      } else if (response.statusCode == 401) {
        if (data['title'] == "unauthorized") {
          toastMessage(text: "Session Expired");
          Get.offAllNamed(AppRoutes.loginScreen);
        } else {
          error.value = "Unauthorized";
        }
      } else {
        error.value = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      debugPrint("Error fetching picking list: $e");
      error.value = "Failed to load data";
    } finally {
      isLoading.value = false;
    }
  }

  String _getStatusFromTabIndex(int index) {
    switch (index) {
      case 1:
        return "DRAFT";
      case 2:
        return "PICKING";
      case 3:
        return "PICKED";
      case 4:
        return "PACKING_REJECTED";
      case 5:
        return "REJECTED";
      default:
        return "";
    }
  }

  void searchPickingList(String query) {
    pageCount.value = 1;
    fetchData(page: 1, search: query);
  }

  void loadMore() {
    if (pickingList.length < totalCount.value) {
      pageCount.value++;
      fetchData(isFirstTime: false, page: pageCount.value);
    }
  }

  void onTabChanged(int index) {
    selectedFilterIndex.value = index;
    pageCount.value = 1;
    String status = _getStatusFromTabIndex(selectedFilterIndex.value);
    fetchData(status: status == "" ? null : status, page: pageCount.value);
  }

  Future<void> getPickingDetail(String id) async {
    isDetailLoading.value = true;
    detailError.value = "";
    pickingDetail.value = null;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.pickingDetail}$id");
      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          PickingDetailResponse pickingDetailResponse = PickingDetailResponse.fromJson(data);
          pickingDetail.value = pickingDetailResponse.data;
        } else {
          detailError.value = data['message'] ?? "Failed to load details";
        }
      } else {
        detailError.value = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      debugPrint("Error fetching picking detail: $e");
      detailError.value = "An error occurred while fetching details";
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> getPickingSuggestions({required String productId, required String requiredQty, String? priorityRackId}) async {
    isSuggestionsLoading.value = true;
    suggestionsError.value = "";
    pickingSuggestions.value = null;
    if (priorityRackId == null) {
      selectedRack.value = null;
      quantityController.text = "";
      pickQuantity.value = "";
      selectedInputTabIndex.value = 0;
      rangeError.value = "";
      selectedSerials.clear();
    }
    try {
      String url = "${ApiEndPoint.pickingSuggestions}?product_id=$productId&limit=1000&required_qty=$requiredQty&company_id=${Pref.getCompanyId()}";
      if (priorityRackId != null && priorityRackId.isNotEmpty) {
        url += "&priority_rack_id=$priorityRackId";
      }

      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          PickingSuggestionsResponse suggestionsResponse = PickingSuggestionsResponse.fromJson(data);
          pickingSuggestions.value = suggestionsResponse.data;
          if (pickingSuggestions.value == null) {
            suggestionsError.value = "No suggestions found";
          }
        } else {
          suggestionsError.value = data['message'] ?? "Failed to load suggestions";
        }
      } else {
        suggestionsError.value = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      debugPrint("Error fetching picking suggestions: $e");
      suggestionsError.value = "An error occurred while fetching suggestions";
    } finally {
      isSuggestionsLoading.value = false;
    }
  }

  Future<void> submitPick({
    required String pickingId,
    required String pickingItemId,
    required String productId,
    required String locationId,
    required String companyId,
    required String finYear,
    String? rackId,
    double? quantity,
    List<String>? serialNumbers,
  }) async {
    isLoading.value = true;
    // try {
    final Map<String, dynamic> item = {"picking_item_id": pickingItemId, "product_id": productId};

    if (quantity != null) {
      item["quantity"] = quantity;
    }

    if (rackId != null) {
      item["rack_id"] = rackId;
    }

    if (serialNumbers != null) {
      item["serial_numbers"] = serialNumbers;
    }

    final body = {
      "picking_id": pickingId,
      "items": [item],
      "location_id": locationId,
      "company_id": companyId,
      "fin_year": finYear,
    };

    try {
      final response = await ApiHandler.postRequest(url: ApiEndPoint.pickingSubmitPick, body: body);
      final data = response.data;

      if (response.statusCode == 200 && data['status'] == 200) {
        toastMessage(text: "Pick submitted successfully");
        isLoading.value = false;
        // Refresh detail
        if (pickingDetail.value != null) {
          getPickingDetail(pickingDetail.value!.id!);
        }
        Get.back();
      } else {
        isLoading.value = false;
        toastMessage(text: data['message'] ?? "Failed to submit pick");
      }
    } catch (e) {
      debugPrint("Error submitting pick: $e");
      isLoading.value = false;
      toastMessage(text: "An error occurred while submitting pick");
    }
  }

  Future<void> rejectPicking({required String pickingId, required String reason}) async {
    isLoading.value = true;
    try {
      final body = {
        "rejection_reason": reason,
        "location_id": Pref.getLocationId(),
        "company_id": Pref.getCompanyId(),
        "fin_year": Pref.getFinYear(),
      };

      final response = await ApiHandler.postRequest(url: "${ApiEndPoint.pickingReject}$pickingId", body: body);
      final data = response.data;

      if (response.statusCode == 200 && data['status'] == 200) {
        toastMessage(text: data['message'] ?? "Picking rejected successfully");
        getPickingCounts();
        fetchData(page: 1); // Refresh the list
        Get.back(); // Close dialog if open
      } else {
        toastMessage(text: data['message'] ?? "Failed to reject picking");
      }
    } catch (e) {
      debugPrint("Error rejecting picking: $e");
      toastMessage(text: "An error occurred while rejecting picking");
    } finally {
      isLoading.value = false;
    }
  }
}
