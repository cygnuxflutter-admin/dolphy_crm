import 'dart:convert';
import 'dart:io';

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

import '../../config/app_colors.dart';
import '../../../config/app_shared_pref.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../../../widget/toast_message.dart';
import '../../config/app_routes.dart';
import 'model/box_config_model.dart';
import 'model/packing_counts_response_model.dart';
import 'model/packing_detail_responce_model.dart';
import 'model/packing_list_detail_response_model.dart';
import 'model/packing_list_response_model.dart';
import 'model/physical_box_status_model.dart';
import 'model/shipping_label_model.dart';
import 'model/box_suggestion_response_model.dart';

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
  RxInt limit = 50.obs;

  int get totalPages => (totalRecords.value / limit.value).ceil();

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

  var isInvoiceExpanded = false.obs;

  RxInt selectedAttachmentTab = 0.obs;

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
    if (isRefresh) {
      currentPage.value = 1;
    }
    packingList.clear();
    isLoading.value = true;
    error.value = "";

    try {
      if (selectedTabIndex.value == 0) {
        // "ALL" tab: Combined data from both APIs
        await fetchAllData();
      } else if (selectedTabIndex.value == 1) {
        // "NEW ORDER" tab: picking-list with status=PICKED
        await fetchNewOrders();
      } else {
        // Other tabs: Use packing-list API with status
        await fetchStatusData();
      }
    } catch (e) {
      debugPrint("Error fetching packing data: $e");
      error.value = "Failed to load data";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllData() async {
    final pickingUrl =
        "${ApiEndPoint.pickingList}?page=${currentPage.value}&limit=50&search=${searchController.value.text}&status=PICKED&company_id=${Pref.getCompanyId()}";
    final packingUrl =
        "${ApiEndPoint.packingList}?page=${currentPage.value}&limit=50&search=${searchController.value.text}&status=&company_id=${Pref.getCompanyId()}";

    final responses = await Future.wait([ApiHandler.getRequest(pickingUrl), ApiHandler.getRequest(packingUrl)]);

    List<PackingList> combinedData = [];
    int total = 0;

    for (var response in responses) {
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        PickingListResponseModel res = PickingListResponseModel.fromJson(data);
        if (res.data != null) {
          combinedData.addAll(res.data!);
        }
        total += res.pagination?.totalRecords ?? 0;
      }
    }

    // Sort by date or something? For now just add
    packingList.addAll(combinedData);
    totalRecords.value = total;
  }

  Future<void> fetchNewOrders() async {
    final url =
        "${ApiEndPoint.pickingList}?page=${currentPage.value}&limit=100&search=${searchController.value.text}&status=PICKED&company_id=${Pref.getCompanyId()}";
    final response = await ApiHandler.getRequest(url);
    final data = json.decode(response.data);

    if (response.statusCode == 200 && data['status'] == 200) {
      PickingListResponseModel res = PickingListResponseModel.fromJson(data);
      if (res.data != null) {
        packingList.addAll(res.data!);
      }
      totalRecords.value = res.pagination?.totalRecords ?? 0;
    }
  }

  Future<void> fetchStatusData() async {
    String status = getStatusFromTabIndex(selectedTabIndex.value);
    final url =
        "${ApiEndPoint.packingList}?page=${currentPage.value}&limit=100&search=${searchController.value.text}&status=$status&company_id=${Pref.getCompanyId()}";

    final response = await ApiHandler.getRequest(url);
    final data = json.decode(response.data);

    if (response.statusCode == 200 && data['status'] == 200) {
      PickingListResponseModel res = PickingListResponseModel.fromJson(data);
      if (res.data != null) {
        packingList.addAll(res.data!);
      }
      totalRecords.value = res.pagination?.totalRecords ?? 0;
    } else {
      error.value = data['message'] ?? "Something went wrong";
    }
  }

  String getStatusFromTabIndex(int index) {
    switch (index) {
      case 1:
        return "PICKED"; // NEW ORDER
      case 2:
        return "PENDING"; // IN PROGRESS
      case 3:
        return "INVOICE_PROCESS"; // INVOICED
      case 4:
        return "READY_FOR_DISPATCH"; // DISPATCH
      case 5:
        return "REJECTED"; // REJECTED
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

  Future<void> getPackingDetail(String id) async {
    isDetailLoading.value = true;
    detailError.value = "";
    packingDetail.value = null;
    updateDetailStatus();

    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.packingDetail}$id");
      final data = json.decode(response.data);

      if (response.statusCode == 200 && data['status'] == 200) {
        PackingDetailResponseModel res = PackingDetailResponseModel.fromJson(data);
        packingDetail.value = res.data;
        updateDetailStatus();
      } else {
        detailError.value = data['message'] ?? "Failed to load details";
      }
    } catch (e) {
      debugPrint("Error fetching packing detail: $e");
      detailError.value = "Something went wrong";
    } finally {
      isDetailLoading.value = false;
    }
  }

  void updateDetailStatus() {
    final item = packingDetail.value;
    if (item == null) {
      detailStatusLabel.value = "-";
      detailStatusColor.value = AppColors.gray500;
      return;
    }
    detailStatusLabel.value = getStatusLabel(item);
    detailStatusColor.value = getBadgeColor(item, detailStatusLabel.value);
  }

  String getStatusLabel(dynamic item) {
    final status = (item.status ?? "").trim().toUpperCase();

    // Check dispatch_status first
    if (item.dispatchStatus != null && item.dispatchStatus.toString().toUpperCase() != "DRAFT") {
      return formatStatus(item.dispatchStatus.toString());
    }

    if (status == "INVOICED") {
      return (item.isRegularInvoiceApproved == true) ? "Ready For Dispatch" : "Invoiced";
    }

    if (status == "PACKED") {
      final hasLrNo = item.lrNo != null && item.lrNo.toString().trim().isNotEmpty;
      final hasTransportMode = item.transportMode != null && item.transportMode.toString().trim().isNotEmpty;
      return (hasLrNo && hasTransportMode) ? "Packed" : "In packing";
    }

    return status.isNotEmpty ? formatStatus(status) : "-";
  }

  Color getBadgeColor(dynamic item, String label) {
    if (label == "In packing" || label == "Ready For Dispatch") {
      return AppColors.orangeColor;
    }
    if (label.startsWith("Ready")) {
      return AppColors.blue500;
    }
    if (label.startsWith("Dispatched") || label.startsWith("Delivered")) {
      return AppColors.green500Normal;
    }

    final status = (item.status ?? "").trim().toUpperCase();
    switch (status) {
      case "DRAFT":
        return AppColors.gray500;
      case "PACKING":
        return AppColors.orangeColor;
      case "PACKED":
        return AppColors.green500Normal;
      case "REJECTED":
        return AppColors.red500;
      case "INVOICED":
        return AppColors.indigo600Main;
      case "CANCELLED":
        return AppColors.red500;
      default:
        return AppColors.gray500;
    }
  }

  String formatStatus(String str) {
    return str.toLowerCase()
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ')
        .trim();
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
          autoFillWithAI(res.data!);
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

  Future<void> createPackingFromPicking({required String pickingId, required bool isShrinkWrapped, String? remarks}) async {
    isLoading.value = true;
    try {
      final body = {
        "picking_id": pickingId,
        "is_shrink_wrapped": isShrinkWrapped,
        "remarks": remarks ?? "",
        "location_id": Pref.getLocationId(),
        "company_id": Pref.getCompanyId(),
        "fin_year": Pref.getFinancialYears(),
      };

      final response = await ApiHandler.postRequest(url: ApiEndPoint.createFromPicking, body: body);

      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        Get.snackbar("Success", "Packing created successfully", backgroundColor: Colors.green, colorText: Colors.white);
        fetchData(); // Refresh list
        getPackingCounts(); // Refresh counts
      } else {
        Get.snackbar("Error", data['message'] ?? "Failed to create packing", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error creating packing: $e");
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startPacking(String id, {String? remarks}) async {
    isLoading.value = true;
    try {
      final response = await ApiHandler.postRequest(
        url: ApiEndPoint.startPacking,
        body: {"picking_id": id, if (remarks != null && remarks.isNotEmpty) "remarks": remarks},
      );
      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        Get.snackbar("Success", "Packing started successfully", backgroundColor: Colors.green, colorText: Colors.white);
        getPackingDetail(id); // Refresh detail
        getPackingCounts(); // Refresh counts
      } else {
        Get.snackbar("Error", data['message'] ?? "Failed to start packing", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error starting packing: $e");
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePackedQty(String pickingId, String itemId, String packedQty) async {
    isLoading.value = true;
    try {
      final response = await ApiHandler.postRequest(
        url: ApiEndPoint.updatePackedQty,
        body: {
          "picking_id": pickingId,
          "items": [
            {"picking_item_id": itemId, "packed_qty": packedQty},
          ],
        },
      );
      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        getPackingDetail(pickingId);
      } else {
        Get.snackbar("Error", data['message'] ?? "Failed to update quantity", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error updating packed quantity: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completePacking(String id) async {
    // Check for partial packing
    if (packingDetail.value != null) {
      bool isPartiallyPacked = false;
      for (var item in packingDetail.value!.items ?? []) {
        double picked = double.tryParse(item.pickedQty ?? "0") ?? 0;
        double packed = double.tryParse(item.packedQty ?? "0") ?? 0;
        if (packed < picked) {
          isPartiallyPacked = true;
          break;
        }
      }

      if (isPartiallyPacked) {
        bool? confirm = await Get.dialog<bool>(
          AlertDialog(
            title: const Text("Partial Packing"),
            content: const Text("Some items are not fully packed. Do you want to complete packing anyway?"),
            actions: [
              TextButton(onPressed: () => Get.back(result: false), child: const Text("CANCEL")),
              TextButton(onPressed: () => Get.back(result: true), child: const Text("COMPLETE")),
            ],
          ),
        );
        if (confirm != true) return;
      }
    }

    isLoading.value = true;
    try {
      final response = await ApiHandler.postRequest(url: ApiEndPoint.completePacking, body: {"picking_id": id});
      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        Get.snackbar("Success", "Packing completed successfully", backgroundColor: Colors.green, colorText: Colors.white);
        Navigator.of(Get.context!).pop();
        fetchData();
        getPackingCounts();
      } else {
        Get.snackbar("Error", data['message'] ?? "Failed to complete packing", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error completing packing: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejectPacking(String id, {String? reason}) async {
    isLoading.value = true;
    try {
      final response = await ApiHandler.postRequest(
        url: "${ApiEndPoint.packingReject}$id",
        body: {if (reason != null && reason.isNotEmpty) "rejection_reason": reason},
      );
      final data = response.data;

      if (response.statusCode == 200 && data['status'] == 200) {
        Get.snackbar("Success", "Packing rejected successfully", backgroundColor: Colors.green, colorText: Colors.white);
        fetchData();
        getPackingCounts();
      } else {
        Get.snackbar("Error", data['message'] ?? "Failed to reject packing", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error rejecting packing: $e");
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestForInvoice(String id) async {
    isLoading.value = true;
    try {
      final response = await ApiHandler.postRequest(url: ApiEndPoint.requestInvoice, body: {"packing_id": id, "flow_type": "regular"});
      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        Get.snackbar("Success", data['message'] ?? "Invoice requested successfully", backgroundColor: Colors.green, colorText: Colors.white);
        fetchData();
        Navigator.of(Get.context!).pop(); // Close detail screen if open
      } else {
        Get.snackbar("Error", data['message'] ?? "Failed to request invoice", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error requesting invoice: $e");
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestForEWayBill(String id) async {
    isLoading.value = true;
    try {
      final body = {
        "picking_id": id,
        "transport_mode": selectedTransportMode.value?.id,
        "vendor_id": selectedVendorId.value?.id,
        "transporter_gstin": transporterGstinController.text,
        "vehicle_no": vehicleNoController.text,
        "lr_awb_no": lrAwbController.text,
        "eway_bill_no": eWayBillNoController.text,
        "driver_name": driverNameController.text,
        "driver_contact": driverContactController.text,
        "remarks": remarksController.text,
      };
      final response = await ApiHandler.postRequest(url: ApiEndPoint.requestEWayBill, body: body);
      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        Get.snackbar("Success", "E-Way Bill requested successfully", backgroundColor: Colors.green, colorText: Colors.white);
        fetchData();
        Navigator.of(Get.context!).pop(); // Close bottom sheet
      } else {
        Get.snackbar("Error", data['message'] ?? "Failed to request E-Way Bill", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("Error requesting E-Way Bill: $e");
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEWayBillRequiredData() async {
    if (transportModes.isNotEmpty && vendors.isNotEmpty) return;

    try {
      final transportModesFuture = ApiHandler.getRequest(ApiEndPoint.transportMode);
      final vendorsFuture = ApiHandler.getRequest(ApiEndPoint.transporters);

      final responses = await Future.wait([transportModesFuture, vendorsFuture]);

      if (responses[0].statusCode == 200) {
        TransportModeResponseModel transportModeResponseModel = transportModeResponseModelFromJson(responses[0].data);
        if (transportModeResponseModel.status == 200 && (transportModeResponseModel.data?.isNotEmpty ?? false)) {
          transportModes.value = transportModeResponseModel.data!.first.items ?? [];
        }
      }

      if (responses[1].statusCode == 200) {
        VendorResponce vendorResponse = vendorResponceFromJson(responses[1].data);
        vendors.value = vendorResponse.data ?? [];
      }
    } catch (e) {
      debugPrint("Error fetching E-Way Bill data: $e");
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
    final url = Uri.parse("${ApiEndPoint.viewPackingList}$id");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not launch PDF viewer", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> viewBoxWisePackingList(String id) async {
    try {
      isLoading.value = true;
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      final response = await ApiHandler.getRequest(
        "${ApiEndPoint.packingPhysicalBoxStatus}?packing_id=$id&location_id=${Pref.getLocationId()}&company_id=${Pref.getCompanyId()}",
      );
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        final physicalBoxData = PhysicalBoxStatusResponse.fromJson(data).data;
        if (physicalBoxData != null) {
          await _generateAndSaveBoxWisePdf(physicalBoxData);
        } else {
          if (Get.isDialogOpen ?? false) Navigator.of(Get.context!).pop();
        }
      } else {
        if (Get.isDialogOpen ?? false) Navigator.of(Get.context!).pop();
        Get.snackbar("Error", data['message'] ?? "Failed to fetch physical box status", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Navigator.of(Get.context!).pop();
      debugPrint("Error fetching physical box status: $e");
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _generateAndSaveBoxWisePdf(PhysicalBoxData data) async {
    final pdf = pw.Document();
    final ByteData logoData = await rootBundle.load('assets/icon/dolphy_logo.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final pw.MemoryImage logoImage = pw.MemoryImage(logoBytes);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            pw.Container(
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, width: 1)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Image(logoImage, width: 100),
                        pw.Expanded(
                          child: pw.Center(
                            child: pw.Text("PACKING LIST (BOX WISE)", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                        pw.SizedBox(width: 100), // To balance the logo
                      ],
                    ),
                  ),
                  pw.Divider(height: 1, color: PdfColors.black),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "DATE: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
                          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text("Packing No : ${data.packingNo ?? '-'}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                  pw.Divider(height: 1, color: PdfColors.black),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: pw.Text("PI Number : ${data.piNumber ?? '-'}", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Divider(height: 1, color: PdfColors.black),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: pw.Text(
                      "Client Name : ${data.customerName?.toUpperCase() ?? '-'}",
                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Divider(height: 1, color: PdfColors.black),
                  // Table
                  pw.Table(
                    border: const pw.TableBorder(
                      verticalInside: pw.BorderSide(color: PdfColors.black, width: 1),
                      horizontalInside: pw.BorderSide(color: PdfColors.black, width: 1),
                      bottom: pw.BorderSide(color: PdfColors.black, width: 1),
                    ),
                    columnWidths: {
                      0: const pw.FixedColumnWidth(60),
                      1: const pw.FixedColumnWidth(80),
                      2: const pw.FlexColumnWidth(),
                      3: const pw.FixedColumnWidth(60),
                      4: const pw.FixedColumnWidth(60),
                      5: const pw.FixedColumnWidth(60),
                    },
                    children: [
                      // Table Header
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                        children: [
                          _buildTableCell("BOX NO", isHeader: true),
                          _buildTableCell("ITEM CODE", isHeader: true),
                          _buildTableCell("PRODUCT", isHeader: true),
                          _buildTableCell("QTY/BOX", isHeader: true),
                          _buildTableCell("TOTAL QTY", isHeader: true),
                          _buildTableCell("BOXES", isHeader: true),
                        ],
                      ),
                      // Table Data
                      ..._buildTableRows(data),
                      // Total Row
                      pw.TableRow(
                        children: [
                          pw.SizedBox(),
                          pw.SizedBox(),
                          pw.Container(
                            alignment: pw.Alignment.center,
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text("TOTAL", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                          ),
                          _buildTableCell("-", isHeader: true),
                          _buildTableCell("${_calculateTotalQty(data)}", isHeader: true),
                          _buildTableCell("${_calculateTotalBoxes(data)}", isHeader: true),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 40),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 16, bottom: 16),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 120,
                          decoration: pw.BoxDecoration(
                            border: const pw.Border(bottom: pw.BorderSide(color: PdfColors.black, width: 1)),
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text("CHECK BY", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    // Save and View PDF
    try {
      final Uint8List bytes = await pdf.save();
      String fileName = "PackingList_BoxWise_${data.packingNo?.replaceAll('/', '_')}.pdf";

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

      Get.snackbar("Success", "PDF saved in Dolphy folder", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      debugPrint("Error saving PDF: $e");
      Get.snackbar("Error", "Could not save PDF", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontSize: 9, fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal),
      ),
    );
  }

  List<pw.TableRow> _buildTableRows(PhysicalBoxData data) {
    List<pw.TableRow> rows = [];
    if (data.configs == null) return rows;

    for (var config in data.configs!) {
      if (config.items == null) continue;

      String boxRange = config.boxRangeStart == config.boxRangeEnd ? "${config.boxRangeStart}" : "${config.boxRangeStart}-${config.boxRangeEnd}";

      for (int i = 0; i < config.items!.length; i++) {
        var item = config.items![i];
        rows.add(
          pw.TableRow(
            children: [
              i == 0 ? _buildTableCell(boxRange) : pw.SizedBox(),
              _buildTableCell(item.productCode ?? "-"),
              pw.Container(
                alignment: pw.Alignment.centerLeft,
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(item.productName ?? "-", style: const pw.TextStyle(fontSize: 9)),
              ),
              _buildTableCell("${item.qtyPerBox ?? 0}"),
              _buildTableCell("${item.totalQty ?? 0}"),
              i == 0 ? _buildTableCell("${config.boxCount ?? 0}") : pw.SizedBox(),
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
        if (config.items != null) {
          for (var item in config.items!) {
            total += (item.totalQty ?? 0);
          }
        }
      }
    }
    return total;
  }

  int _calculateTotalBoxes(PhysicalBoxData data) {
    int total = 0;
    if (data.configs != null) {
      for (var config in data.configs!) {
        total += (config.boxCount ?? 0);
      }
    }
    return total;
  }

  Future<void> printShippingLabel(String id) async {
    try {
      isLoading.value = true;
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      final response = await ApiHandler.getRequest(
        "${ApiEndPoint.shippingLabel}?packing_id=$id&location_id=${Pref.getLocationId()}&company_id=${Pref.getCompanyId()}",
      );
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        final labelData = ShippingLabelResponse.fromJson(data).data;
        if (labelData != null) {
          await _generateAndSaveShippingLabels(labelData);
        } else {
          if (Get.isDialogOpen ?? false) Navigator.of(Get.context!).pop();
        }
      } else {
        if (Get.isDialogOpen ?? false) Navigator.of(Get.context!).pop();
        Get.snackbar("Error", data['message'] ?? "Failed to fetch shipping label data", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Navigator.of(Get.context!).pop();
      debugPrint("Error fetching shipping label: $e");
      Get.snackbar("Error", "Something went wrong", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _generateAndSaveShippingLabels(ShippingLabelData data) async {
    final pdf = pw.Document();

    int totalBoxes = data.totalBoxes ?? 1;

    for (int i = 1; i <= totalBoxes; i++) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a5,
          orientation: pw.PageOrientation.portrait,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, width: 1)),
              child: pw.Stack(
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("To:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                      pw.SizedBox(height: 8),
                      pw.Text(data.to?.companyName?.toUpperCase() ?? "", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
                      pw.Text("${data.to?.address ?? ''} - ${data.to?.pincode ?? ''}", style: const pw.TextStyle(fontSize: 16)),
                      pw.Text(data.to?.city?.toUpperCase() ?? "", style: const pw.TextStyle(fontSize: 16)),
                      pw.Text("Contact no - ${data.to?.contact ?? ''}", style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 40),
                      pw.Text("FROM:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                      pw.SizedBox(height: 8),
                      pw.Text(data.from?.companyName?.toUpperCase() ?? "", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
                      if (data.from?.addressLines != null)
                        ...data.from!.addressLines!.map((line) => pw.Text(line.toUpperCase(), style: const pw.TextStyle(fontSize: 16))),
                      pw.Text(data.from?.cityCode?.toUpperCase() ?? "", style: const pw.TextStyle(fontSize: 16)),
                      pw.Text("Mob: ${data.from?.mobile ?? ''}", style: const pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 40),
                      pw.Container(
                        width: double.infinity,
                        height: 1,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(color: PdfColors.black, width: 1, style: pw.BorderStyle.dashed),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(data.packingNo ?? "", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                      pw.SizedBox(height: 10),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: "Transporter: ",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                            ),
                            pw.TextSpan(text: data.to?.transporterName ?? "-", style: const pw.TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: "Receiver Name: ",
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                            ),
                            pw.TextSpan(text: data.to?.receiverName ?? "-", style: const pw.TextStyle(fontSize: 14)),
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

      Get.snackbar("Success", "Labels saved in Dolphy folder", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      debugPrint("Error saving Shipping Labels: $e");
      Get.snackbar("Error", "Could not save Shipping Labels", backgroundColor: Colors.red, colorText: Colors.white);
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
            while (remainingQty > 0) {
              int qtyForThisBox = remainingQty > basePerBox ? basePerBox : remainingQty;

              tempConfigs.add(
                BoxConfiguration(
                  id: item.boxSuggestionItemId ?? "${DateTime.now().millisecondsSinceEpoch}_$boxIndex",
                  boxName: "Box $boxIndex",
                  weight: 0.0,
                  items: [
                    BoxConfigItem(
                      productId: item.productId ?? "",
                      productName: item.productName ?? "Product",
                      qty: qtyForThisBox,
                    )
                  ],
                ),
              );
              remainingQty -= qtyForThisBox;
              boxIndex++;
            }
          }
          boxConfigs.addAll(tempConfigs);
          toastMessage(
            text: "Box configurations generated successfully!",
            color: AppColors.green500Success,
          );
        } else {
          toastMessage(
            text: responseData['message'] ?? "Failed to get AI suggestion",
            color: AppColors.redColor,
          );
        }
      } else {
        toastMessage(
          text: responseData['message'] ?? "Failed to connect to AI server",
          color: AppColors.redColor,
        );
      }
    } catch (e) {
      debugPrint("Error fetching AI suggestions: $e");
      toastMessage(
        text: "Something went wrong",
        color: AppColors.redColor,
      );
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
        "items": config.items.map((item) => {
          "product_id": item.productId,
          "quantity_per_box": item.qty,
        }).toList(),
      };

      final response = await ApiHandler.patchRequest(
        url: "${ApiEndPoint.updateBoxConfig}${config.id}",
        body: body,
      );

      final data = response.data;
      if (response.statusCode == 200 && data['status'] == 200) {
        toastMessage(
          text: data['message'] ?? "Box Configuration Updated",
          color: AppColors.greenColor,
        );
        return true;
      } else {
        toastMessage(
          text: data['message'] ?? "Failed to update Box Configuration",
          color: AppColors.redColor,
        );
        return false;
      }
    } catch (e) {
      debugPrint("Error updating box config: $e");
      toastMessage(
        text: "Something went wrong while updating Box Configuration",
        color: AppColors.redColor,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  int getPhysicallyPackedQty(String productId) {
    int sum = 0;
    for (var config in boxConfigs) {
      for (var item in config.items) {
        if (item.productId == productId) {
          sum += item.qty;
        }
      }
    }
    return sum;
  }

  int getActualBoxesForProduct(String productId) {
    int count = 0;
    for (var config in boxConfigs) {
      bool contains = false;
      for (var item in config.items) {
        if (item.productId == productId && item.qty > 0) {
          contains = true;
          break;
        }
      }
      if (contains) count++;
    }
    return count;
  }

  Future<void> saveBoxConfigs() async {
    final detail = packingListDetail.value;
    if (detail == null) {
      toastMessage(
        text: "No packing details found to save.",
        color: AppColors.redColor,
      );
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
        "company_id": detail.companyId ?? Pref.getCompanyId() ?? "",
        "fin_year": detail.finYear ?? Pref.getFinancialYears() ?? "",
        "items": itemsList,
      };

      final response = await ApiHandler.patchRequest(
        url: ApiEndPoint.updateBoxSuggestion,
        body: body,
      );

      if (response == null) {
        toastMessage(
          text: "Failed to receive response from server.",
          color: AppColors.redColor,
        );
        return;
      }

      final responseData = response.data;
      if (responseData == null) {
        toastMessage(
          text: "Server returned empty data.",
          color: AppColors.redColor,
        );
        return;
      }

      final Map<String, dynamic> dataMap;
      if (responseData is String) {
        dataMap = json.decode(responseData) as Map<String, dynamic>;
      } else if (responseData is Map) {
        dataMap = Map<String, dynamic>.from(responseData);
      } else {
        toastMessage(
          text: "Invalid response format from server.",
          color: AppColors.redColor,
        );
        return;
      }

      final bool isSuccess = dataMap['success'] == true;
      final int? status = dataMap['status'] as int?;
      final String message = dataMap['message']?.toString() ?? "Box suggestion updated successfully";

      if (isSuccess || status == 200) {
        Get.back();
        toastMessage(
          text: message,
          color: AppColors.greenColor,
        );
        if (detail.id != null) {
          getPackingListDetail(detail.id!);
        }
      } else {
        toastMessage(
          text: message,
          color: AppColors.redColor,
        );
      }
    } catch (e) {
      debugPrint("Error saving box configurations: $e");
      toastMessage(
        text: "Something went wrong while saving: $e",
        color: AppColors.redColor,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
