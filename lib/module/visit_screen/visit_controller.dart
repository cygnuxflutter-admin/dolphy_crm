import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_shared_pref.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../../../widget/toast_message.dart';
import 'model/field_report_model.dart';
import 'model/visit_counts_model.dart';
import 'model/visit_model.dart';
import 'model/visit_view_model.dart';

class VisitController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isCountsLoading = false.obs;
  RxString error = "".obs;

  Rx<VisitCounts?> visitCounts = Rx<VisitCounts?>(null);
  RxList<VisitDatum> visitList = <VisitDatum>[].obs;

  RxInt selectedTabIndex = 0.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  // Pagination
  RxInt currentPage = 1.obs;
  RxInt totalRecords = 0.obs;
  RxInt rowsPerPage = 50.obs;

  int get totalPages => (totalRecords.value / rowsPerPage.value).ceil();

  // View Details
  RxBool isDetailLoading = false.obs;
  RxString detailError = "".obs;
  Rx<VisitViewData?> visitDetail = Rx<VisitViewData?>(null);

  // Field Report Details
  RxBool isFieldReportLoading = false.obs;
  RxString fieldReportError = "".obs;
  Rx<FieldReportData?> fieldReportDetail = Rx<FieldReportData?>(null);
  RxMap<String, bool> expandedProducts = <String, bool>{}.obs;
  RxMap<String, bool> expandedTechLogs = <String, bool>{}.obs;

  void toggleProductExpansion(String productId) {
    if (expandedProducts.containsKey(productId)) {
      expandedProducts[productId] = !expandedProducts[productId]!;
    } else {
      expandedProducts[productId] = true;
    }
  }

  void toggleTechLogExpansion(String techId) {
    if (expandedTechLogs.containsKey(techId)) {
      expandedTechLogs[techId] = !expandedTechLogs[techId]!;
    } else {
      expandedTechLogs[techId] = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getVisitCounts();
    fetchData();
  }

  Future<void> getVisitCounts() async {
    isCountsLoading.value = true;
    try {
      final response = await ApiHandler.getRequest(
        "${ApiEndPoint.serviceVisitCounts}?company_id=${Pref.getCompanyId()}&location_id=${Pref.getLocationId()}&fin_year=${Pref.getFinancialYears()}",
      );
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        visitCounts.value = VisitCounts.fromJson(data['data']);
        visitCounts.refresh();
      }
    } catch (e) {
      debugPrint("Error fetching visit counts: $e");
    } finally {
      isCountsLoading.value = false;
    }
  }

  Future<void> fetchData({bool isRefresh = true}) async {
    if (isRefresh) {
      currentPage.value = 1;
      visitList.clear();
    }
    isLoading.value = true;
    error.value = "";

    try {
      String status = getStatusFromTabIndex(selectedTabIndex.value);
      final url =
          "${ApiEndPoint.serviceVisitList}?page=${currentPage.value}&rowsPerPage=${rowsPerPage.value}&search=${searchController.value.text}&status=$status&company_id=${Pref.getCompanyId()}&location_id=${Pref.getLocationId()}&fin_year=${Pref.getFinancialYears()}";

      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);

      if (response.statusCode == 200 && data['status'] == 200) {
        VisitModel res = VisitModel.fromJson(data);
        if (res.data != null) {
          if (isRefresh) {
            visitList.assignAll(res.data!);
          } else {
            visitList.addAll(res.data!);
          }
        }
        totalRecords.value = res.pagination?.totalRecords ?? 0;
      } else {
        error.value = data['message'] ?? "Something went wrong";
      }
    } catch (e) {
      debugPrint("Error fetching visit data: $e");
      error.value = "Failed to load data";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getVisitDetail(String id) async {
    isDetailLoading.value = true;
    detailError.value = "";
    visitDetail.value = null;

    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}service-visit/find/$id");
      final data = json.decode(response.data);

      if (response.statusCode == 200 && data['status'] == 200) {
        VisitViewModel res = VisitViewModel.fromJson(data);
        visitDetail.value = res.data;
      } else {
        detailError.value = data['message'] ?? "Failed to load details";
      }
    } catch (e) {
      debugPrint("Error fetching visit detail: $e");
      detailError.value = "Something went wrong";
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<void> getFieldReport(String id) async {
    isFieldReportLoading.value = true;
    fieldReportError.value = "";
    fieldReportDetail.value = null;

    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}service-visit/$id/field-report");
      final data = json.decode(response.data);

      if (response.statusCode == 200 && data['status'] == 200) {
        FieldReportModel res = FieldReportModel.fromJson(data);
        fieldReportDetail.value = res.data;
      } else {
        fieldReportError.value = data['message'] ?? "Failed to load field report";
      }
    } catch (e) {
      debugPrint("Error fetching field report: $e");
      fieldReportError.value = "Something went wrong";
    } finally {
      isFieldReportLoading.value = false;
    }
  }

  String getStatusFromTabIndex(int index) {
    switch (index) {
      case 1:
        return "PENDING";
      case 2:
        return "IN_PROGRESS";
      case 3:
        return "COMPLETED";
      case 4:
        return "CANCELLED";
      default:
        return "";
    }
  }

  void onTabChanged(int index) {
    selectedTabIndex.value = index;
    fetchData();
  }

  void onSearch(String query) {
    fetchData();
  }

  void onPageChanged(int page) {
    if (page >= 1 && page <= totalPages) {
      currentPage.value = page;
      fetchData(isRefresh: false);
    }
  }

  Future<void> cancelVisit(String visitId, String remarks) async {
    isLoading.value = true;
    try {
      final body = {"cancel_remarks": remarks};
      final response = await ApiHandler.postRequest(url: "${ApiEndPoint.baseUrl}service-visit/$visitId/cancel", body: body);

      final data = response.data;
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        toastMessage(text: data['message'] ?? "Visit cancelled successfully");
        fetchData();
        getVisitCounts();
      } else {
        toastMessage(text: data['message'] ?? "Failed to cancel visit");
      }
    } catch (e) {
      debugPrint("Error cancelling visit: $e");
      toastMessage(text: "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
