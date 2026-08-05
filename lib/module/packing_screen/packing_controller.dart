import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crm/config/app_routes.dart';
import 'package:crm/module/packing_screen/model/transport_mode_responce_model.dart';
import 'package:crm/module/packing_screen/model/vendor_responce_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/app_shared_pref.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../../../widget/toast_message.dart';
import '../../config/app_colors.dart';
import 'model/box_config_model.dart';
import 'model/box_suggestion_response_model.dart';
import 'model/packing_counts_response_model.dart';
import 'model/packing_detail_responce_model.dart';
import 'model/packing_list_detail_response_model.dart';
import 'model/packing_list_response_model.dart';
import 'model/physical_box_status_model.dart';
import 'model/shipping_label_model.dart';

class PackingController extends GetxController {
  RxBool isLoading = false.obs;
  RxString error = "".obs;

  Rx<PackingCounts?> packingCounts = Rx<PackingCounts?>(null);
  RxList<PackingList> packingList = <PackingList>[].obs;

  RxInt selectedTabIndex = 0.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  // Pagination
  RxInt currentPage = 1.obs;
  RxInt totalRecords = 0.obs;
  RxInt limit = 100.obs;

  int get totalPages => (totalRecords.value / limit.value).ceil();

  Timer? _searchDebounce;

  // Detail State
  RxBool isDetailLoading = false.obs;
  RxString detailError = "".obs;
  Rx<PackingDetailData?> packingDetail = Rx<PackingDetailData?>(null);

  // Status logic variables
  RxString detailStatusLabel = "-".obs;
  Rx<Color> detailStatusColor = AppColors.gray500.obs;

  // Packing List Detail State
  RxBool isListDetailLoading = false.obs;
  RxString listDetailError = "".obs;
  Rx<PackingListDetailData?> packingListDetail = Rx<PackingListDetailData?>(null);
  Rx<BoxSuggestionData?> boxSuggestionData = Rx<BoxSuggestionData?>(null);
  RxList<ProductSummary> productSummary = <ProductSummary>[].obs;

  var isInvoiceExpanded = false.obs;

  RxInt selectedAttachmentTab = 0.obs;

  // Log Note state
  RxBool isLogNoteOpen = false.obs;
  final logNoteController = TextEditingController();
  Rx<DateTime?> reminderDate = Rx<DateTime?>(null);
  RxList<File> selectedLogFiles = <File>[].obs;

  // Box configurations reactive state
  RxList<BoxConfiguration> boxConfigs = <BoxConfiguration>[].obs;

  // E-Way Bill Form State
  RxList<Item> transportModes = <Item>[].obs;
  RxList<Vendor> vendors = <Vendor>[].obs;
  List a = [];

  Rx<Item?> selectedTransportMode = Rx(null);
  Rx<Vendor?> selectedVendorId = Rx(null);
  final transporterGstinController = TextEditingController();

  final vehicleNoController = TextEditingController();
  final lrAwbController = TextEditingController();
  final eWayBillNoController = TextEditingController();
  final driverNameController = TextEditingController();
  final driverContactController = TextEditingController();
  final remarksController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    clearEWayBillForm();
    fetchEWayBillRequiredData();
    getPackingCounts();
    fetchData();
  }

  Future<void> getPackingCounts() async {
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.packingCounts}?company_id=${Pref.getCompanyId()}");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        packingCounts.value = PackingCounts.fromJson(data['data']);
      }
    } catch (e) {
      debugPrint("Error fetching packing counts: $e");
    }
  }

  Future<void> fetchData({bool isRefresh = true}) async {
    isLoading.value = true;
    if (isRefresh) {
      currentPage.value = 1;
    }
    packingList.clear();
    error.value = "";

    try {
      String status = getStatusFromTabIndex(selectedTabIndex.value);
      String baseUrl = ApiEndPoint.packingList;
      String readyForPacking = "";

      if (status == "NEW") {
        baseUrl = ApiEndPoint.pickingList;
        status = "PICKED";
        readyForPacking = "&ready_for_packing=true";
      }

      String url =
          "$baseUrl?page=${currentPage.value}&limit=${limit.value}&status=$status&company_id=${Pref.getCompanyId()}$readyForPacking&search=${Uri.encodeComponent(searchController.value.text)}";

      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);

      if (response.statusCode == 200 && data['status'] == 200) {
        final res = PickingListResponseModel.fromJson(data);
        packingList.assignAll(res.data ?? []);
        totalRecords.value = res.pagination?.totalRecords ?? 0;
      } else {
        error.value = data['message'] ?? "Failed to fetch data";
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllData() async {
    isLoading.value = true;
    try {
      await Future.wait([getPackingCounts(), fetchData()]);
    } catch (e) {
      debugPrint("Error fetching all data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String getStatusFromTabIndex(int index) {
    switch (index) {
      case 0:
        return "ALL";
      case 1:
        return "NEW";
      case 2:
        return "IN_PACKING";
      case 3:
        return "INVOICE_PROCESS";
      case 4:
        return "READY_FOR_DISPATCH";
      case 5:
        return "REJECTED";
      default:
        return "ALL";
    }
  }

  void onTabChanged(int index) {
    selectedTabIndex.value = index;
    fetchData();
  }

  void onSearch(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();

    if (query.isEmpty || query.length % 3 == 0) {
      _searchDebounce = Timer(const Duration(milliseconds: 500), () {
        fetchData();
      });
    }
  }

  void onPageChanged(int page) {
    if (page > 0 && page <= totalPages) {
      currentPage.value = page;
      fetchData(isRefresh: false);
    }
  }

  Future<void> getPackingDetail(String id) async {
    isDetailLoading.value = true;
    detailError.value = "";
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.packingDetail}$id");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        packingDetail.value = PackingDetailData.fromJson(data['data']);
        updateDetailStatus();
      } else {
        detailError.value = data['message'] ?? "Failed to load details";
      }
    } catch (e) {
      detailError.value = e.toString();
    } finally {
      isDetailLoading.value = false;
    }
  }

  void updateDetailStatus() {
    if (packingDetail.value != null) {
      detailStatusLabel.value = getStatusLabel(packingDetail.value!.status);
      detailStatusColor.value = getBadgeColor(packingDetail.value!.status, detailStatusLabel.value);
    }
  }

  String getStatusLabel(dynamic item) {
    if (item is PackingList) {
      if (item.status?.toUpperCase() == "DRAFT") {
        return "Start Packing";
      }
      return getStatusLabel(item.status);
    }
    String status = "";
    if (item is String) {
      status = item;
    } else if (item != null) {
      status = item.toString();
    }

    switch (status.toUpperCase()) {
      case "NEW":
        return "New Order";
      case "PACKING":
      case "PACKED":
      case "IN_PACKING":
        return "In Packing";
      case "INVOICED":
        return "Invoiced";
      case "REJECTED":
        return "Rejected";
      case "COMPLETED":
        return "Completed";
      case "PENDING":
        return "Pending";
      case "CANCELLED":
        return "Cancelled";
      case "DRAFT":
        return "Start Packing";
      default:
        return status.isNotEmpty ? status : "-";
    }
  }

  Color getBadgeColor(dynamic item, String label) {
    if (item is PackingList) {
      return getBadgeColor(item.status, label);
    }
    String status = "";
    if (item is String) {
      status = item;
    } else if (item != null) {
      status = item.toString();
    }

    switch (status.toUpperCase()) {
      case "NEW":
        return AppColors.indigo600Main;
      case "PACKING":
      case "PACKED":
      case "IN PACKING":
      case "IN_PACKING":
      case "DRAFT":
        return AppColors.orangeColor;
      case "COMPLETED":
        return AppColors.green500Success;
      case "INVOICED":
        return AppColors.blue500;
      case "REJECTED":
      case "CANCELLED":
        return AppColors.red500;
      default:
        return AppColors.gray500;
    }
  }

  String formatStatus(String str) {
    if (str.isEmpty) return "-";
    return str
        .split('_')
        .map((word) {
          if (word.isEmpty) return "";
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  Future<void> getPackingListDetail(String id) async {
    isListDetailLoading.value = true;
    listDetailError.value = "";
    packingListDetail.value = null;
    boxConfigs.clear();

    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.packingDetail}$id");
      final data = json.decode(response.data);

      if (response.statusCode == 200 && data['status'] == 200) {
        PackingListDetailResponse res = PackingListDetailResponse.fromJson(data);
        packingListDetail.value = res.data;
        if (res.data != null) {
          // First try to fetch actual saved physical boxes
          await fetchPhysicalBoxStatus(id);

          // If no physical boxes saved, then show AI suggestions
          // if (boxConfigs.isEmpty) {
          await autoFillWithAI(res.data!);
          // }
        }
      } else {
        listDetailError.value = data['message'] ?? "Failed to load details";
      }
    } catch (e) {
      debugPrint("Error fetching packing list detail: $e");
      listDetailError.value = e.toString();
    } finally {
      isListDetailLoading.value = false;
    }
  }

  Future<void> fetchPhysicalBoxStatus(String packingId) async {
    try {
      final response = await ApiHandler.getRequest(
        "${ApiEndPoint.packingPhysicalBoxStatus}?packing_id=$packingId&location_id=${Pref.getLocationId()}&company_id=${Pref.getCompanyId()}",
      );
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        final physicalBoxData = PhysicalBoxStatusResponse.fromJson(data).data;
        if (physicalBoxData != null) {
          if (physicalBoxData.configs != null) {
            final rawConfigs = physicalBoxData.configs!.map((config) => _mapConfigToBoxConfig(config)).toList();
            boxConfigs.value = _groupConfigs(rawConfigs);
          }
          if (physicalBoxData.productSummary != null) {
            productSummary.value = physicalBoxData.productSummary!;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching physical box status: $e");
    }
  }

  BoxConfiguration _mapConfigToBoxConfig(Config config) {
    int from = config.boxRangeStart ?? config.rangeStart ?? 0;
    int to = config.boxRangeEnd ?? config.rangeEnd ?? 0;

    // If to is 0 but boxCount is set, try to calculate to
    if (to == 0 && from != 0 && config.boxCount != null && config.boxCount! > 0) {
      to = from + config.boxCount! - 1;
    }

    return BoxConfiguration(
      id: config.id ?? "",
      boxName: "Box $from${from != to ? "-$to" : ""}",
      weight: double.tryParse(config.grossWeight ?? "0") ?? 0.0,
      fromBox: from,
      toBox: to,
      length: config.length ?? 0.0,
      width: config.width ?? 0.0,
      height: config.height ?? 0.0,
      dimUom: config.dimensionUom ?? "cm",
      netWeight: double.tryParse(config.netWeight ?? "0") ?? 0.0,
      grossWeight: double.tryParse(config.grossWeight ?? "0") ?? 0.0,
      weightUom: config.weightUom ?? "kg",
      remarks: config.remarks ?? "",
      items: (config.items ?? []).map((item) {
        return BoxConfigItem(
          productId: item.productId ?? "",
          productName: item.productName ?? "Product",
          qty: item.quantityPerBox ?? item.qtyPerBox ?? 0,
        );
      }).toList(),
    );
  }

  Future<void> createPackingFromPicking({
    required String pickingId,
    required bool isShrinkWrapped,
    String? remarks,
    String? transportMode,
    String? vendorId,
    String? transporterName,
  }) async {
    isLoading.value = true;
    try {
      final body = {
        "picking_id": pickingId,
        "is_shrink_wrapped": isShrinkWrapped,
        "remarks": remarks ?? "",
        "transport_mode": transportMode ?? "",
        "transporter_id": vendorId ?? "",
        "transporter_name": transporterName ?? "",
        "company_id": Pref.getCompanyId(),
        "fin_year": Pref.getFinancialYears(),
        "location_id": Pref.getLocationId(),
      };

      final response = await ApiHandler.postRequest(url: ApiEndPoint.createFromPicking, body: body);
      final data = response.data;
      if (response.statusCode == 201 && data['status'] == 201) {
        toastMessage(text: data['message'] ?? "Packing created successfully", color: Colors.green);
        Get.back();
        fetchData();
      } else {
        toastMessage(text: data['message'] ?? "Failed to create packing", color: Colors.red);
      }
    } catch (e) {
      debugPrint("Error creating packing: $e");
      toastMessage(text: "Something went wrong", color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> startPacking(String id) async {
    isLoading.value = true;
    try {
      final body = {"picking_id": id, "company_id": Pref.getCompanyId(), "fin_year": Pref.getFinancialYears(), "location_id": Pref.getLocationId()};
      final response = await ApiHandler.postRequest(url: ApiEndPoint.startPacking, body: body);
      final data = response.data;
      if (response.statusCode == 201 && data['status'] == 201) {
        toastMessage(text: data['message'] ?? "Packing started", color: Colors.green);
        fetchData();
        return true;
      } else {
        toastMessage(text: data['message'] ?? "Failed to start packing", color: Colors.red);
        return false;
      }
    } catch (e) {
      debugPrint("Error starting packing: $e");
      toastMessage(text: "Something went wrong", color: Colors.red);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePackedQty(String pickingId, String itemId, String packedQty) async {
    isLoading.value = true;
    try {
      final body = {
        "packing_id": pickingId,
        "item_id": itemId,
        "packed_qty": packedQty,
        "company_id": Pref.getCompanyId(),
        "fin_year": Pref.getFinancialYears(),
        "location_id": Pref.getLocationId(),
      };
      final response = await ApiHandler.patchRequest(url: ApiEndPoint.updatePackedQty, body: body);
      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        getPackingDetail(pickingId);
      } else {
        toastMessage(text: data['message'] ?? "Failed to update quantity", color: Colors.red);
      }
    } catch (e) {
      debugPrint("Error updating quantity: $e");
      toastMessage(text: "Something went wrong", color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completePacking(String id) async {
    // Check if everything is packed
    bool isPartial = false;
    if (packingDetail.value != null && packingDetail.value!.items != null) {
      for (var item in packingDetail.value!.items!) {
        double ordered = double.tryParse(item.pickedQty ?? "0") ?? 0;
        double packed = double.tryParse(item.packedQty ?? "0") ?? 0;
        if (packed < ordered) {
          isPartial = true;
          break;
        }
      }
    }

    if (isPartial) {
      Get.dialog(
        AlertDialog(
          title: const Text("Partial Packing"),
          content: const Text("Some items are not fully packed. Do you want to complete packing anyway?"),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("CANCEL")),
            TextButton(
              onPressed: () {
                Get.back();
                _executeCompletePacking(id);
              },
              child: const Text("COMPLETE"),
            ),
          ],
        ),
      );
    } else {
      _executeCompletePacking(id);
    }
  }

  Future<void> _executeCompletePacking(String id) async {
    isLoading.value = true;
    try {
      final body = {"packing_id": id, "company_id": Pref.getCompanyId(), "fin_year": Pref.getFinancialYears(), "location_id": Pref.getLocationId()};
      final response = await ApiHandler.patchRequest(url: ApiEndPoint.completePacking, body: body);
      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        toastMessage(text: data['message'] ?? "Packing completed successfully", color: Colors.green);
        Get.back();
        fetchData();
      } else {
        toastMessage(text: data['message'] ?? "Failed to complete packing", color: Colors.red);
      }
    } catch (e) {
      debugPrint("Error completing packing: $e");
      toastMessage(text: "Something went wrong", color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectPacking(String id, {String? reason}) async {
    isLoading.value = true;
    try {
      final body = {
        "rejection_reason": reason ?? "Rejected from mobile app",
        "company_id": Pref.getCompanyId(),
        "fin_year": Pref.getFinancialYears(),
        "location_id": Pref.getLocationId(),
      };
      final response = await ApiHandler.patchRequest(url: "${ApiEndPoint.packingReject}$id", body: body);
      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        toastMessage(text: data['message'] ?? "Packing rejected", color: Colors.green);
        Get.back();
        fetchData();
      } else {
        toastMessage(text: data['message'] ?? "Failed to reject packing", color: Colors.red);
      }
    } catch (e) {
      debugPrint("Error rejecting packing: $e");
      toastMessage(text: "Something went wrong", color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePacking(String id) async {
    isLoading.value = true;
    try {
      final response = await ApiHandler.deleteRequest("${ApiEndPoint.deletePacking}$id");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        toastMessage(text: data['message'] ?? "Packing deleted", color: Colors.green);
        if (Get.currentRoute == AppRoutes.packingDetailScreen) {
          Get.back();
        }
        fetchData();
      } else {
        toastMessage(text: data['message'] ?? "Failed to delete packing", color: Colors.red);
      }
    } catch (e) {
      debugPrint("Error deleting packing: $e");
      toastMessage(text: "Something went wrong", color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestForInvoice(String id) async {
    isLoading.value = true;
    try {
      final response = await ApiHandler.postRequest(url: ApiEndPoint.requestInvoice, body: {"packing_id": id, "flow_type": "regular"});
      final data = response.data;
      if (response.statusCode == 201 && data['status'] == 201) {
        toastMessage(text: data['message'] ?? "Invoice requested successfully", color: Colors.green);
        fetchData();
      } else {
        toastMessage(text: data['message'] ?? "Failed to request invoice", color: Colors.red);
      }
    } catch (e) {
      debugPrint("Error requesting invoice: $e");
      toastMessage(text: "Something went wrong", color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> postLogNote() async {
    if (logNoteController.text.isEmpty) {
      toastMessage(text: "Please enter some notes", color: Colors.red);
      return;
    }

    isLoading.value = true;
    try {
      final body = {
        "notes": logNoteController.text,
        "entity_id": packingDetail.value?.id,
        "entity_type": "packing_list",
        "reminder_date": reminderDate.value?.toIso8601String(),
        "company_id": Pref.getCompanyId(),
        "fin_year": Pref.getFinancialYears(),
        "location_id": Pref.getLocationId(),
      };

      final response = await ApiHandler.postRequest(url: ApiEndPoint.addLog, body: body);
      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        toastMessage(text: "Log note added successfully", color: Colors.green);
        logNoteController.clear();
        reminderDate.value = null;
        isLogNoteOpen.value = false;
        getPackingDetail(packingDetail.value!.id!);
      } else {
        toastMessage(text: data['message'] ?? "Failed to add log note", color: Colors.red);
      }
    } catch (e) {
      debugPrint("Error adding log note: $e");
      toastMessage(text: "Something went wrong", color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestForEWayBill(String id) async {
    if (selectedTransportMode.value == null) {
      toastMessage(text: "Please select transport mode", color: Colors.red);
      return;
    }

    isLoading.value = true;
    try {
      final body = {
        "packing_id": id,
        "is_required_ewaybill": true,
        "transporter_id": selectedVendorId.value?.id,
        "transporter_gstin": transporterGstinController.text,
        "vehicle_no": vehicleNoController.text,
        "transport_mode": selectedTransportMode.value?.name,
        "transporter_name": selectedVendorId.value?.name,
        "driver_name": driverNameController.text,
        "driver_contact": driverContactController.text,
        "lr_no": lrAwbController.text,
        "eway_bill_no": eWayBillNoController.text,
        "remarks": remarksController.text,
      };

      final response = await ApiHandler.patchRequest(url: ApiEndPoint.updateEWayBill, body: body);
      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        toastMessage(text: data['message'] ?? "E-Way Bill details updated successfully", color: Colors.green);
        Get.back();
        getPackingDetail(id);
        fetchData();
      } else {
        toastMessage(text: data['message'] ?? "Failed to update E-Way Bill details", color: Colors.red);
      }
    } catch (e) {
      debugPrint("Error updating E-Way Bill: $e");
      toastMessage(text: "Something went wrong", color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEWayBillRequiredData() async {
    try {
      final responses = await Future.wait([ApiHandler.getRequest(ApiEndPoint.transportMode), ApiHandler.getRequest(ApiEndPoint.transporters)]);

      final modeData = json.decode(responses[0].data);
      if (responses[0].statusCode == 200 && modeData['status'] == 200) {
        transportModes.assignAll(TransportModeResponseModel.fromJson(modeData).data?.expand((m) => m.items ?? <Item>[]).toList() ?? <Item>[]);
      }

      final vendorData = json.decode(responses[1].data);
      if (responses[1].statusCode == 200 && vendorData['status'] == 200) {
        vendors.assignAll(VendorResponce.fromJson(vendorData).data ?? <Vendor>[]);
      }
    } catch (e) {
      debugPrint("Error fetching E-Way Bill required data: $e");
    }
  }

  void clearEWayBillForm() {
    selectedTransportMode.value = null;
    selectedVendorId.value = null;
    transporterGstinController.clear();
    vehicleNoController.clear();
    lrAwbController.clear();
    eWayBillNoController.clear();
    driverNameController.clear();
    driverContactController.clear();
    remarksController.clear();
  }

  Future<void> viewPackingList(String id) async {
    final url = "${ApiEndPoint.viewPackingList}$id?company_id=${Pref.getCompanyId()}&location_id=${Pref.getLocationId()}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      toastMessage(text: "Could not launch packing list", color: Colors.red);
    }
  }

  Future<void> viewBoxWisePackingList(String packingId) async {
    isLoading.value = true;
    try {
      final response = await ApiHandler.getRequest(
        "${ApiEndPoint.packingPhysicalBoxStatus}?packing_id=$packingId&location_id=${Pref.getLocationId()}&company_id=${Pref.getCompanyId()}",
      );

      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        final physicalBoxData = PhysicalBoxStatusResponse.fromJson(data).data;
        if (physicalBoxData != null) {
          await _generateAndSaveBoxWisePdf(physicalBoxData);
        } else {
          toastMessage(text: "No box data found", color: Colors.red);
        }
      } else {
        toastMessage(text: data['message'] ?? "Failed to fetch box details", color: Colors.red);
      }
    } catch (e) {
      debugPrint("Error fetching box details: $e");
      toastMessage(text: "Something went wrong", color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _generateAndSaveBoxWisePdf(PhysicalBoxData data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("BOX WISE PACKING LIST", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
                  pw.Text("Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}"),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Packing No: ${data.packingNo ?? "-"}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text("Customer: ${data.customerName ?? "-"}"),
                      pw.Text("PI No: ${data.piNumber ?? "-"}"),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _buildTableCell("Box No", isHeader: true),
                    _buildTableCell("Dimensions (L x W x H)", isHeader: true),
                    _buildTableCell("Gross Wt", isHeader: true),
                    _buildTableCell("Product Details", isHeader: true),
                    _buildTableCell("Qty", isHeader: true),
                  ],
                ),
                ..._buildTableRows(data),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Total Qty: ${_calculateTotalQty(data)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text("Total Boxes: ${_calculateTotalBoxes(data)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    try {
      final Uint8List bytes = await pdf.save();
      String fileName = "BoxWisePackingList_${data.packingNo?.replaceAll('/', '_')}.pdf";

      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final String dolphyPath = "${directory!.path}/Dolphy";
      final Directory dolphyDir = Directory(dolphyPath);
      if (!await dolphyDir.exists()) {
        await dolphyDir.create(recursive: true);
      }

      final File file = File("$dolphyPath/$fileName");
      await file.writeAsBytes(bytes);

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);

      toastMessage(text: "PDF saved in Dolphy folder", color: Colors.green);
    } catch (e) {
      debugPrint("Error saving PDF: $e");
      toastMessage(text: "Could not save PDF", color: Colors.red);
    }
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: 10),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  List<pw.TableRow> _buildTableRows(PhysicalBoxData data) {
    List<pw.TableRow> rows = [];
    if (data.configs != null) {
      for (var config in data.configs!) {
        final boxRange = config.boxRangeStart != config.boxRangeEnd ? "${config.boxRangeStart} - ${config.boxRangeEnd}" : "${config.boxRangeStart}";

        final dims = "${config.length} x ${config.width} x ${config.height} ${config.dimensionUom}";

        String productDetails = "";
        String qtyDetails = "";
        if (config.items != null) {
          productDetails = config.items!.map((i) => "${i.productCode}\n${i.productName}").join("\n\n");
          qtyDetails = config.items!.map((i) => "${i.quantityPerBox ?? i.qtyPerBox}").join("\n\n");
        }

        rows.add(
          pw.TableRow(
            children: [
              _buildTableCell(boxRange),
              _buildTableCell(dims),
              _buildTableCell("${config.grossWeight} ${config.weightUom}"),
              _buildTableCell(productDetails),
              _buildTableCell(qtyDetails),
            ],
          ),
        );
      }
    }
    return rows;
  }

  int _calculateTotalQty(PhysicalBoxData data) {
    int total = 0;
    if (data.configs != null) {
      for (var config in data.configs!) {
        int boxes = (config.boxRangeEnd ?? 0) - (config.boxRangeStart ?? 0) + 1;
        if (config.items != null) {
          for (var item in config.items!) {
            total += (item.quantityPerBox ?? item.qtyPerBox ?? 0) * boxes;
          }
        }
      }
    }
    return total;
  }

  int _calculateTotalBoxes(PhysicalBoxData data) {
    if (data.configs == null || data.configs!.isEmpty) return 0;
    return data.configs!.last.boxRangeEnd ?? 0;
  }

  Future<void> printShippingLabel(String id) async {
    isLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.shippingLabel}?packing_id=$id");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        final shippingLabelData = ShippingLabelResponse.fromJson(data).data;
        if (shippingLabelData != null) {
          await _generateAndSaveShippingLabels(shippingLabelData);
        }
      } else {
        toastMessage(text: data['message'] ?? "Failed to fetch label data", color: Colors.red);
      }
    } catch (e) {
      debugPrint("Error printing label: $e");
      toastMessage(text: "Something went wrong", color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _generateAndSaveShippingLabels(ShippingLabelData data) async {
    final pdf = pw.Document();
    final int totalBoxes = data.totalBoxes ?? 1;

    for (int i = 1; i <= totalBoxes; i++) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a6,
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black)),
              ),
              child: pw.Stack(
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Center(
                        child: pw.Text("SHIPPING LABEL", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                      ),
                      pw.Divider(),
                      pw.Text("FROM:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      pw.Text(data.from?.companyName ?? "-", style: const pw.TextStyle(fontSize: 12)),
                      pw.Text(data.from?.addressLines?.join(", ") ?? "-", style: const pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 10),
                      pw.Text("TO:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      pw.Text(
                        data.to?.companyName ?? data.to?.receiverName ?? "-",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                      ),
                      pw.Text(data.to?.address ?? "-", style: const pw.TextStyle(fontSize: 12)),
                      pw.SizedBox(height: 10),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: "Packing No: ",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                            ),
                            pw.TextSpan(text: data.packingNo ?? "-", style: const pw.TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: "Mobile: ",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                            ),
                            pw.TextSpan(text: data.to?.receiverMobile ?? "-", style: const pw.TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.Positioned(bottom: 0, right: 0, child: pw.Text("$i/$totalBoxes", style: pw.TextStyle(fontSize: 12))),
                ],
              ),
            );
          },
        ),
      );
    }

    // Save and View PDF
    try {
      final Uint8List bytes = await pdf.save();
      String fileName = "ShippingLabel_${data.packingNo?.replaceAll('/', '_')}.pdf";

      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final String dolphyPath = "${directory!.path}/Dolphy";
      final Directory dolphyDir = Directory(dolphyPath);
      if (!await dolphyDir.exists()) {
        await dolphyDir.create(recursive: true);
      }

      final File file = File("$dolphyPath/$fileName");
      await file.writeAsBytes(bytes);

      if (Get.isDialogOpen ?? false) Navigator.of(Get.context!).pop();

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);

      toastMessage(text: "Labels saved in Dolphy folder", color: Colors.green);
    } catch (e) {
      debugPrint("Error saving Shipping Labels: $e");
      toastMessage(text: "Could not save Shipping Labels", color: Colors.red);
    }
  }

  // Box configurations helper methods
  Future<void> autoFillWithAI(PackingListDetailData data) async {
    isLoading.value = true;
    try {
      final response = await ApiHandler.getRequest(
        "${ApiEndPoint.boxSuggestion}?packing_no=${Uri.encodeComponent(data.packingNo ?? "")}&packing_id=${data.id ?? ""}",
      );
      final responseData = json.decode(response.data);

      if (response.statusCode == 200 && responseData['status'] == 200) {
        final boxSuggestionResponseModel = BoxSuggestionResponseModel.fromJson(responseData);
        if (boxSuggestionResponseModel.success == true && boxSuggestionResponseModel.data != null) {
          boxSuggestionData.value = boxSuggestionResponseModel.data;
          boxConfigs.clear();
          final items = boxSuggestionResponseModel.data!.items ?? [];
          List<BoxConfiguration> tempConfigs = [];
          int boxIndex = 1;

          for (var item in items) {
            final int packedQty = item.packedQty ?? 0;
            if (packedQty <= 0) continue;

            final int perBoxCount = item.perBoxCount ?? 1;
            final int basePerBox = perBoxCount > 0 ? perBoxCount : 1;

            int remainingQty = packedQty;

            // Full boxes
            int fullBoxesCount = remainingQty ~/ basePerBox;
            if (fullBoxesCount > 0) {
              tempConfigs.add(
                BoxConfiguration(
                  id: "${DateTime.now().millisecondsSinceEpoch}_${boxIndex}_full",
                  boxName: fullBoxesCount > 1 ? "Boxes $boxIndex - ${boxIndex + fullBoxesCount - 1}" : "Box $boxIndex",
                  weight: 0.0,
                  fromBox: boxIndex,
                  toBox: boxIndex + fullBoxesCount - 1,
                  items: [BoxConfigItem(productId: item.productId ?? "", productName: item.productName ?? "Product", qty: basePerBox)],
                ),
              );
              boxIndex += fullBoxesCount;
              remainingQty %= basePerBox;
            }

            if (remainingQty > 0) {
              tempConfigs.add(
                BoxConfiguration(
                  id: "${DateTime.now().millisecondsSinceEpoch}_${boxIndex}_rem",
                  boxName: "Box $boxIndex",
                  weight: 0.0,
                  fromBox: boxIndex,
                  toBox: boxIndex,
                  items: [BoxConfigItem(productId: item.productId ?? "", productName: item.productName ?? "Product", qty: remainingQty)],
                ),
              );
              boxIndex++;
            }
          }
          boxConfigs.addAll(tempConfigs);
          toastMessage(text: "Box configurations generated successfully!", color: AppColors.green500Success);
        } else {
          toastMessage(text: responseData['message'] ?? "Failed to get AI suggestion", color: AppColors.redColor);
        }
      } else {
        toastMessage(text: responseData['message'] ?? "Failed to connect to AI server", color: AppColors.redColor);
      }
    } catch (e) {
      debugPrint("Error fetching AI suggestions: $e");
      toastMessage(text: "Something went wrong", color: AppColors.redColor);
    } finally {
      isLoading.value = false;
    }
  }

  void addBoxConfig(BoxConfiguration config) {
    boxConfigs.add(config);
  }

  void editBoxConfig(String id, BoxConfiguration newConfig) {
    int idx = boxConfigs.indexWhere((c) => c.id == id);
    if (idx != -1) {
      boxConfigs[idx] = newConfig;
    }
  }

  void deleteBoxConfig(String id) {
    boxConfigs.removeWhere((c) => c.id == id);
  }

  Future<bool> updatePhysicalBoxConfig({required String packingId, required BoxConfiguration config}) async {
    isLoading.value = true;
    try {
      final body = {
        "packing_id": packingId,
        "company_id": Pref.getCompanyId(),
        "fin_year": Pref.getFinancialYears(),
        "box_range_start": config.fromBox,
        "box_range_end": config.toBox,
        "length": config.length,
        "width": config.width,
        "height": config.height,
        "dimension_uom": config.dimUom,
        "net_weight": config.netWeight,
        "gross_weight": config.grossWeight,
        "weight_uom": config.weightUom,
        "remarks": config.remarks.isEmpty ? "Auto filled with AI" : config.remarks,
        "items": config.items.map((item) => {"product_id": item.productId, "quantity_per_box": item.qty}).toList(),
      };

      final response = await ApiHandler.patchRequest(url: "${ApiEndPoint.updateBoxConfig}${config.id}", body: body);

      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        toastMessage(text: data['message'] ?? "Box Configuration Updated", color: AppColors.greenColor);
        await fetchPhysicalBoxStatus(packingId);
        return true;
      } else {
        toastMessage(text: data['message'] ?? "Failed to update Box Configuration", color: AppColors.redColor);
        return false;
      }
    } catch (e) {
      debugPrint("Error updating box config: $e");
      toastMessage(text: "Something went wrong while updating Box Configuration", color: AppColors.redColor);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  int getPhysicallyPackedQty(String productId) {
    int sum = 0;
    for (var config in boxConfigs) {
      final int numBoxes = (config.toBox - config.fromBox + 1).clamp(1, 99999);
      for (var item in config.items) {
        if (item.productId == productId) {
          sum += (item.qty * numBoxes);
        }
      }
    }
    return sum;
  }

  int getActualBoxesForProduct(String productId) {
    int count = 0;
    for (var config in boxConfigs) {
      final int numBoxes = (config.toBox - config.fromBox + 1).clamp(1, 99999);
      bool contains = false;
      for (var item in config.items) {
        if (item.productId == productId && item.qty > 0) {
          contains = true;
          break;
        }
      }
      if (contains) count += numBoxes;
    }
    return count;
  }

  Future<void> saveBoxConfigs() async {
    final detail = packingListDetail.value;
    if (detail == null) {
      toastMessage(text: "No packing details found to save.", color: AppColors.redColor);
      return;
    }

    isLoading.value = true;
    try {
      final List<Map<String, dynamic>> itemsList = [];
      if (detail.items != null) {
        for (var item in detail.items!) {
          if (item.productId != null) {
            itemsList.add({
              "product_id": item.productId,
              "actual_boxes": getActualBoxesForProduct(item.productId!),
              "item_remarks": item.remarks?.toString() ?? "",
            });
          }
        }
      }

      final body = {
        "packing_no": detail.packingNo ?? "",
        "packing_id": detail.id ?? "",
        "company_id": detail.companyId ?? Pref.getCompanyId(),
        "fin_year": detail.finYear ?? Pref.getFinancialYears(),
        "location_id": detail.locationId ?? Pref.getLocationId(),
        "items": itemsList,
      };

      final response = await ApiHandler.patchRequest(url: ApiEndPoint.updateBoxSuggestion, body: body);

      final responseData = response.data;
      if (responseData == null) {
        toastMessage(text: "Server returned empty data.", color: AppColors.redColor);
        return;
      }

      final Map<String, dynamic> dataMap;
      if (responseData is String) {
        dataMap = json.decode(responseData) as Map<String, dynamic>;
      } else if (responseData is Map) {
        dataMap = Map<String, dynamic>.from(responseData);
      } else {
        toastMessage(text: "Invalid response format from server.", color: AppColors.redColor);
        return;
      }

      final bool isSuccess = dataMap['success'] == true;
      final int? status = dataMap['status'] as int?;
      final String message = dataMap['message']?.toString() ?? "Box suggestion updated successfully";

      if (isSuccess || status == 200) {
        Get.back();
        toastMessage(text: message, color: AppColors.greenColor);
        if (detail.id != null) {
          getPackingListDetail(detail.id!);
        }
      } else {
        toastMessage(text: message, color: AppColors.redColor);
      }
    } catch (e) {
      debugPrint("Error saving box configurations: $e");
      toastMessage(text: "Something went wrong while saving: $e", color: AppColors.redColor);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestForInvoiceFromDetail(String id) async {
    isLoading.value = true;
    try {
      final response = await ApiHandler.postRequest(url: ApiEndPoint.requestInvoice, body: {"packing_id": id, "flow_type": "regular"});
      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        toastMessage(text: data['message'] ?? "Invoice requested successfully", color: Colors.green);
        getPackingDetail(id);
      } else {
        toastMessage(text: data['message'] ?? "Failed to request invoice", color: Colors.red);
      }
    } catch (e) {
      debugPrint("Error requesting invoice: $e");
      toastMessage(text: "Something went wrong", color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  List<BoxConfiguration> _groupConfigs(List<BoxConfiguration> configs) {
    if (configs.isEmpty) return [];

    // Sort by fromBox to ensure consecutive checking
    configs.sort((a, b) => a.fromBox.compareTo(b.fromBox));

    List<BoxConfiguration> grouped = [];
    BoxConfiguration? current;

    for (var config in configs) {
      if (current == null) {
        current = config;
      } else if (_areConfigsGroupable(current, config)) {
        current = current.copyWith(toBox: config.toBox, boxName: "Boxes ${current.fromBox} - ${config.toBox}");
      } else {
        grouped.add(current);
        current = config;
      }
    }
    if (current != null) grouped.add(current);
    return grouped;
  }

  bool _areConfigsGroupable(BoxConfiguration a, BoxConfiguration b) {
    // If box numbers are not set or not consecutive, we can't group them into a single range card
    if (a.fromBox == 0 || b.fromBox == 0) return false;
    if (a.toBox + 1 != b.fromBox) return false;

    // Compare dimensions
    if ((a.length - b.length).abs() > 0.01 || (a.width - b.width).abs() > 0.01 || (a.height - b.height).abs() > 0.01 || a.dimUom != b.dimUom) {
      return false;
    }

    // Compare weights
    if ((a.netWeight - b.netWeight).abs() > 0.001 || (a.grossWeight - b.grossWeight).abs() > 0.001 || a.weightUom != b.weightUom) {
      return false;
    }

    // Compare items
    if (a.items.length != b.items.length) return false;

    // Sort items by productId to ensure order-independent comparison
    var itemsA = List<BoxConfigItem>.from(a.items)..sort((x, y) => x.productId.compareTo(y.productId));
    var itemsB = List<BoxConfigItem>.from(b.items)..sort((x, y) => x.productId.compareTo(y.productId));

    for (int i = 0; i < itemsA.length; i++) {
      if (itemsA[i].productId != itemsB[i].productId || itemsA[i].qty != itemsB[i].qty) return false;
    }

    return true;
  }
}
