import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;

import '../../../config/app_shared_pref.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../../../widget/toast_message.dart';
import '../../config/app_colors.dart';
import '../expense_screen/model/technician_expense_model.dart';
import '../lead_screen/model/lead_type.dart';
import 'model/dispatched_serial_model.dart';
import 'model/field_report_model.dart';
import 'model/sync_preview_model.dart';
import 'model/visit_counts_model.dart';
import 'model/visit_model.dart' hide Technician, VisitTechnician, TrackingLog;
import 'model/visit_view_model.dart' hide Technician, VisitTechnician, TrackingLog, Product;

class VisitController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isActionLoading = false.obs;
  RxBool isCountsLoading = false.obs;
  RxBool isLocationChecking = false.obs;
  RxString error = "".obs;

  final GlobalKey endTrackingKey = GlobalKey();
  final ScrollController fieldReportScrollController = ScrollController();

  void scrollToEndTracking() {
    try {
      final context = endTrackingKey.currentContext;
      if (context != null && context.mounted) {
        Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut, alignment: 0.05);
        return;
      }
    } catch (e) {
      debugPrint("Error scrolling to end tracking: $e");
    }

    if (fieldReportScrollController.hasClients) {
      fieldReportScrollController.animateTo(
        fieldReportScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

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

  // Technician Expenses
  RxBool isExpenseLoading = false.obs;
  RxList<TechnicianExpense> technicianExpenses = <TechnicianExpense>[].obs;

  double get totalExpenseRequestAmount => technicianExpenses.fold(0.0, (sum, item) => sum + (double.tryParse(item.totalRequestAmount) ?? 0.0));
  double get totalExpenseApproveAmount => technicianExpenses.fold(0.0, (sum, item) => sum + (double.tryParse(item.totalApproveAmount) ?? 0.0));

  // Field Report Details
  RxBool isFieldReportLoading = false.obs;
  RxString fieldReportError = "".obs;
  Rx<FieldReportData?> fieldReportDetail = Rx<FieldReportData?>(null);
  RxMap<String, bool> expandedProducts = <String, bool>{}.obs;
  RxMap<String, bool> expandedTechLogs = <String, bool>{}.obs;
  RxMap<String, bool> expandedSerialSections = <String, bool>{}.obs;
  RxMap<String, bool> expandedPartsSections = <String, bool>{}.obs;

  // Add Product to Visit Form
  Rx<TextEditingController> taxInvoiceNoController = TextEditingController().obs;
  Rx<TextEditingController> complaintQtyController = TextEditingController(text: "1").obs;
  Rx<TextEditingController> installedQtyController = TextEditingController(text: "0").obs;
  Rx<TextEditingController> clientSideQtyController = TextEditingController(text: "0").obs;
  Rx<TextEditingController> issueDescriptionController = TextEditingController().obs;
  Rx<TextEditingController> usageCrowdNoteController = TextEditingController().obs;

  RxList<dynamic> taxInvoices = <dynamic>[].obs;
  Rxn<dynamic> selectedTaxInvoice = Rxn<dynamic>();
  RxList<dynamic> productList = <dynamic>[].obs;
  RxList<dynamic> invoiceProducts = <dynamic>[].obs; // Original items from invoice
  Rxn<dynamic> selectedProduct = Rxn<dynamic>();

  RxBool isTaxInvoiceLoading = false.obs;
  RxBool isProductSearchLoading = false.obs;
  RxBool isAddProductLoading = false.obs;

  // End Tracking / Final Report Form
  final serviceReceivedByController = TextEditingController().obs;
  final contactNumberController = TextEditingController().obs;
  final siteReceiverMobileCountryCode = "+91".obs;
  final visitOutcome = "".obs; // "closed" or "next_visit_required"
  final overallRemarkController = TextEditingController().obs;
  final finalUsageNoteController = TextEditingController().obs;
  RxList<File> finalAttachments = <File>[].obs;
  RxList<String> finalAttachmentUrls = <String>[].obs;

  // Attachment Upload Statuses
  RxMap<String, bool> isUploadingProductAttachments = <String, bool>{}.obs;
  RxMap<String, String> productAttachmentUploadProgress = <String, String>{}.obs;

  RxMap<String, bool> isUploadingPartAttachments = <String, bool>{}.obs;
  RxMap<String, String> partAttachmentUploadProgress = <String, String>{}.obs;

  RxBool isUploadingFinalAttachments = false.obs;
  RxString finalAttachmentUploadProgress = "".obs;

  RxBool isUploadingSiteArrivalAttachments = false.obs;
  RxString siteArrivalUploadProgress = "".obs;

  // Site Arrival
  RxList<String> siteArrivalAttachmentUrls = <String>[].obs;
  final siteArrivalRemarkController = TextEditingController().obs;
  final kilometerController = TextEditingController().obs;
  RxList<String> expenseTypes = <String>["Travel", "Food", "Accommodation", "Local Conveyance", "Other"].obs;
  RxList<String> travelTypes = <String>["Auto", "Bike", "Bus", "Cab", "Flight", "Local Train", "Rapido", "Train"].obs;
  Rxn<String> selectedExpenseType = Rxn<String>("Travel");
  Rxn<String> selectedTravelType = Rxn<String>();

  // Validation Errors
  RxString serviceReceivedByError = "".obs;
  RxString contactNumberError = "".obs;
  RxString visitOutcomeError = "".obs;
  RxString overallRemarkError = "".obs;
  RxString finalUsageNoteError = "".obs;

  Future<void> uploadFinalAttachments(List<File> files) async {
    if (files.isEmpty) return;
    isUploadingFinalAttachments.value = true;
    int total = files.length;
    int successCount = 0;

    try {
      for (int i = 0; i < total; i++) {
        finalAttachmentUploadProgress.value = total == 1 ? "Uploading..." : "Uploading ${i + 1}/$total...";
        final file = files[i];
        try {
          final response = await ApiHandler.uploadFile(file, folderName: 'service-visit-attachments');
          final data = response.data;
          if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
            String? fileUrl = data['data'] != null ? data['data']['url'] : null;
            if (fileUrl != null) {
              finalAttachmentUrls.add(fileUrl);
              successCount++;
            }
          }
        } catch (e) {
          debugPrint("Error uploading final attachment: $e");
        }
      }
      if (successCount > 0) {
        toastMessage(text: total == 1 ? "File uploaded successfully" : "$successCount of $total files uploaded successfully");
      } else {
        toastMessage(text: "File upload failed", color: AppColors.redColor);
      }
    } finally {
      isUploadingFinalAttachments.value = false;
      finalAttachmentUploadProgress.value = "";
    }
  }

  Future<void> uploadFinalAttachment(File file) async {
    await uploadFinalAttachments([file]);
  }

  Future<void> uploadSiteArrivalAttachments(List<File> files) async {
    if (files.isEmpty) return;
    isUploadingSiteArrivalAttachments.value = true;
    int total = files.length;
    int successCount = 0;

    try {
      for (int i = 0; i < total; i++) {
        siteArrivalUploadProgress.value = total == 1 ? "Uploading..." : "Uploading ${i + 1}/$total...";
        final file = files[i];
        try {
          final response = await ApiHandler.uploadFile(file, folderName: 'service-visit-reached-attachments');
          final data = response.data;
          if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
            String? fileUrl = data['data'] != null ? data['data']['url'] : null;
            if (fileUrl != null) {
              siteArrivalAttachmentUrls.add(fileUrl);
              successCount++;
            }
          }
        } catch (e) {
          debugPrint("Error uploading site arrival attachment: $e");
        }
      }
      if (successCount > 0) {
        toastMessage(text: total == 1 ? "File uploaded successfully" : "$successCount of $total files uploaded successfully");
      } else {
        toastMessage(text: "File upload failed", color: AppColors.redColor);
      }
    } finally {
      isUploadingSiteArrivalAttachments.value = false;
      siteArrivalUploadProgress.value = "";
    }
  }

  Future<void> uploadSiteArrivalAttachment(File file) async {
    await uploadSiteArrivalAttachments([file]);
  }

  void removeSiteArrivalAttachment(int index) {
    if (index < siteArrivalAttachmentUrls.length) {
      siteArrivalAttachmentUrls.removeAt(index);
    }
  }

  void removeFinalAttachment(int index) {
    if (index < finalAttachmentUrls.length) {
      finalAttachmentUrls.removeAt(index);
    }
  }

  // Sync to Complaint
  RxBool isSyncPreviewLoading = false.obs;
  Rxn<SyncPreviewData> syncPreviewData = Rxn<SyncPreviewData>();
  RxList<LeadItem> warrantyTypeList = <LeadItem>[].obs;
  final RxList<Map<String, String>> repeatServiceStatusList = [
    {"id": "first_service", "name": "First Service"},
    {"id": "second_service", "name": "Second Service"},
    {"id": "third_service", "name": "Third Service"},
    {"id": "fourth_service", "name": "Fourth Service"},
    {"id": "fifth_service", "name": "Fifth Service"},
    {"id": "sixth_service", "name": "Sixth Service"},
  ].obs;
  RxBool isSyncing = false.obs;

  Rxn<Map<String, String>> selectedRepeatServiceStatus = Rxn<Map<String, String>>();

  // Real-time Timer
  Timer? _timer;
  RxInt currentTimerSeconds = 0.obs;

  void startTimer(List<TrackingLog>? logs) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTimerSeconds.value = _calculateTotalSeconds(logs);
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  int _calculateTotalSeconds(List<TrackingLog>? logs) {
    if (logs == null || logs.isEmpty) return 0;
    int totalSeconds = 0;
    DateTime? startTime;

    for (var log in logs) {
      final action = log.action.toLowerCase();
      final time = log.createdAt;

      if (action == 'start' || action == 'resume') {
        startTime = time;
      } else if (action == 'pause' || action == 'stop' || action == 'end') {
        if (startTime != null) {
          totalSeconds += time.difference(startTime).inSeconds;
          startTime = null;
        }
      }
    }

    if (startTime != null) {
      totalSeconds += DateTime.now().toUtc().difference(startTime).inSeconds;
    }

    return totalSeconds;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void clearAddProductForm() {
    taxInvoiceNoController.value.clear();
    complaintQtyController.value.text = "1";
    installedQtyController.value.text = "0";
    clientSideQtyController.value.text = "0";
    issueDescriptionController.value.clear();
    usageCrowdNoteController.value.clear();
    selectedTaxInvoice.value = null;
    selectedProduct.value = null;
    selectedRepeatServiceStatus.value = null;
    taxInvoices.clear();
    productList.clear();
    invoiceProducts.clear();
  }

  Future<void> getWarrantyTypes() async {
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}commonMaster/findByGroup?type=Warranty+Type");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        LeadType res = LeadType.fromJson(data);
        if (res.data.isNotEmpty) {
          warrantyTypeList.assignAll(res.data.first.items);
        }
      }
    } catch (e) {
      debugPrint("Error fetching warranty types: $e");
    }
  }

  Future<void> getSyncPreview(String visitId, String serviceQueryId) async {
    isSyncPreviewLoading.value = true;
    syncPreviewData.value = null; // Clear previous data
    try {
      await getWarrantyTypes();
      final url = "${ApiEndPoint.syncToComplaintPreview.replaceAll("{visit_id}", visitId)}?service_query_id=$serviceQueryId";

      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        SyncPreviewModel res = SyncPreviewModel.fromJson(data);
        syncPreviewData.value = res.data;
      } else {
        toastMessage(text: data['message'] ?? "Failed to fetch sync preview");
      }
    } catch (e, stack) {
      debugPrint("Error fetching sync preview: $e");
      debugPrint(stack.toString());
      toastMessage(text: "Something went wrong while fetching preview");
    } finally {
      isSyncPreviewLoading.value = false;
    }
  }

  Future<void> performSync(String visitId) async {
    if (syncPreviewData.value == null) return;

    isSyncing.value = true;
    try {
      final body = {
        "service_query_id": syncPreviewData.value!.complaint.id,
        "items": syncPreviewData.value!.products.map((p) {
          return {
            "visit_item_id": p.id,
            "product_id": p.productId,
            "tax_invoice_id": p.taxInvoiceId,
            "tax_invoice_no": p.taxInvoiceNo,
            "complaint_qty": p.complaintQty,
            "installed_qty": p.installedQty,
            "issue_description": p.issueDescription,
            "usage_note": p.usageNote,
            "warranty_type": p.warrantyType,
            "warranty_type_other": null,
            "repeat_service_status": p.repeatServiceStatus,
          };
        }).toList(),
      };

      final url = ApiEndPoint.syncToComplaint.replaceAll("{visit_id}", visitId);
      final response = await ApiHandler.postRequest(url: url, body: body);
      final data = response.data;

      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        toastMessage(text: data['message'] ?? "Synced to complaint successfully");
        Get.back(); // Close dialog
        getVisitDetail(visitId); // Refresh details
      } else {
        toastMessage(text: data['message'] ?? "Failed to sync");
      }
    } catch (e) {
      debugPrint("Error performing sync: $e");
      toastMessage(text: "Something went wrong");
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> searchTaxInvoices(String query) async {
    isTaxInvoiceLoading.value = true;
    try {
      final customerId = fieldReportDetail.value?.customerId ?? "";
      final customerName = Uri.encodeComponent(fieldReportDetail.value?.customerName ?? "");

      final url =
          "${ApiEndPoint.baseUrl}invoice/find?search=$query&page=1&limit=20&exportData=false&invoice_type=regular&customer_id=$customerId&customer_name=$customerName";

      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        taxInvoices.assignAll(data['data'] ?? []);
      }
    } catch (e) {
      debugPrint("Error searching tax invoices: $e");
    } finally {
      isTaxInvoiceLoading.value = false;
    }
  }

  Future<List<dynamic>> searchProducts(String query, {int page = 1, int limit = 20}) async {
    // If a tax invoice is selected, we filter the products belonging to that invoice locally
    if (selectedTaxInvoice.value != null) {
      if (query.isEmpty) {
        productList.assignAll(invoiceProducts);
        return invoiceProducts;
      }
      final filtered = invoiceProducts.where((p) {
        final name = (p['product_name'] ?? "").toString().toLowerCase();
        final code = (p['product_code'] ?? "").toString().toLowerCase();
        return name.contains(query.toLowerCase()) || code.contains(query.toLowerCase());
      }).toList();
      productList.assignAll(filtered);
      return filtered;
    }

    isProductSearchLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.opportunityProduct}?page=$page&limit=$limit&search=$query&exportData=false");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        final List results = data['data'] ?? [];
        if (page == 1) {
          productList.assignAll(results);
        } else {
          productList.addAll(results);
        }
        return results;
      }
    } catch (e) {
      debugPrint("Error searching products: $e");
    } finally {
      isProductSearchLoading.value = false;
    }
    return [];
  }

  Future<void> getInvoiceItems(String invoiceId) async {
    isProductSearchLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}invoice/find/$invoiceId");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        final List items = data['data']['items'] ?? [];
        final List mappedItems = items.map((item) {
          return {'id': item['product_id'], 'product_name': item['product_name'], 'product_code': item['product_code']};
        }).toList();

        invoiceProducts.assignAll(mappedItems);
        productList.assignAll(mappedItems);
      }
    } catch (e) {
      debugPrint("Error fetching invoice items: $e");
    } finally {
      isProductSearchLoading.value = false;
    }
  }

  Future<void> addProductToVisit(String visitId) async {
    if (selectedProduct.value == null) {
      toastMessage(text: "Please select a product");
      return;
    }
    if (issueDescriptionController.value.text.isEmpty) {
      toastMessage(text: "Please enter issue description");
      return;
    }

    isAddProductLoading.value = true;
    try {
      final body = {
        "product_id": selectedProduct.value['id'],
        "tax_invoice_id": selectedTaxInvoice.value?['id'],
        "tax_invoice_no": taxInvoiceNoController.value.text,
        "complaint_qty": int.tryParse(complaintQtyController.value.text) ?? 1,
        "installed_qty": int.tryParse(installedQtyController.value.text) ?? 0,
        "client_side_qty": int.tryParse(clientSideQtyController.value.text) ?? 0,
        "repeat_service_status": selectedRepeatServiceStatus.value?['id'],
        "issue_description": issueDescriptionController.value.text,
        "usage_note": usageCrowdNoteController.value.text,
      };

      final response = await ApiHandler.postRequest(url: "${ApiEndPoint.baseUrl}service-visit/$visitId/items", body: body);
      final data = response.data;

      if (response.statusCode == 201 || response.statusCode == 200) {
        toastMessage(text: "Product added to visit successfully");
        Get.back(); // Close dialog
        getFieldReport(visitId, isRefresh: true); // Refresh report
      } else {
        toastMessage(text: data['message'] ?? "Failed to add product");
      }
    } catch (e) {
      debugPrint("Error adding product to visit: $e");
      toastMessage(text: "Something went wrong");
    } finally {
      isAddProductLoading.value = false;
    }
  }

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

  void toggleSerialSectionExpansion(String productId) {
    if (expandedSerialSections.containsKey(productId)) {
      expandedSerialSections[productId] = !expandedSerialSections[productId]!;
    } else {
      expandedSerialSections[productId] = true;
    }
  }

  void togglePartsSectionExpansion(String productId) {
    if (expandedPartsSections.containsKey(productId)) {
      expandedPartsSections[productId] = !expandedPartsSections[productId]!;
    } else {
      expandedPartsSections[productId] = true;
    }
  }

  void updateSolveQty(String productId, String value) {
    if (fieldReportDetail.value == null) return;
    int? newQty = int.tryParse(value);
    if (newQty == null) return;

    final productIndex = fieldReportDetail.value!.products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      final product = fieldReportDetail.value!.products[productIndex];

      if (newQty > product.clientSideQty) {
        toastMessage(text: "Solve Qty cannot be greater than Client Side Qty (${product.clientSideQty})");
        fieldReportDetail.refresh(); // Refresh to revert UI value if needed
        return;
      }

      product.solveQty = newQty;

      // Adjust serial numbers list size
      List<String> currentSerials = List<String>.from(product.serialNumbers);
      if (currentSerials.length < newQty) {
        // Add empty strings
        currentSerials.addAll(List.generate(newQty - currentSerials.length, (_) => ""));
      } else if (currentSerials.length > newQty) {
        // Remove from end
        currentSerials = currentSerials.sublist(0, newQty);
      }
      product.serialNumbers = currentSerials;
      fieldReportDetail.refresh();
    }
  }

  void updateSerialNumber(String productId, int index, String value) {
    if (fieldReportDetail.value == null) return;
    final productIndex = fieldReportDetail.value!.products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      final product = fieldReportDetail.value!.products[productIndex];
      if (index < product.serialNumbers.length) {
        product.serialNumbers[index] = value;
        fieldReportDetail.refresh();
      }
    }
  }

  void addSerialNumber(String productId, [String value = ""]) {
    if (fieldReportDetail.value == null) return;
    final productIndex = fieldReportDetail.value!.products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      final product = fieldReportDetail.value!.products[productIndex];
      product.serialNumbers.add(value);
      expandedSerialSections[productId] = true;
      fieldReportDetail.refresh();
    }
  }

  void removeSerialNumber(String productId, int index) {
    if (fieldReportDetail.value == null) return;
    final productIndex = fieldReportDetail.value!.products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      final product = fieldReportDetail.value!.products[productIndex];
      if (index < product.serialNumbers.length) {
        product.serialNumbers.removeAt(index);
        fieldReportDetail.refresh();
      }
    }
  }

  void updateWorkRemark(String productId, String value) {
    if (fieldReportDetail.value == null) return;
    final productIndex = fieldReportDetail.value!.products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      fieldReportDetail.value!.products[productIndex].workRemark = value;
    }
  }

  Future<List<DispatchedSerialData>> getDispatchedSerialSuggestions({
    required String visitId,
    required String visitItemId,
    required String productId,
    required String query,
  }) async {
    try {
      final url =
          "${ApiEndPoint.dispatchedSerialSuggestions.replaceAll("{visit_id}", visitId)}?visit_item_id=$visitItemId&product_id=$productId&q=$query&limit=25";
      debugPrint("Fetching serial suggestions from: $url");

      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);

      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        final model = DispatchedSerialModel.fromJson(data);
        return model.data ?? [];
      }
    } catch (e) {
      debugPrint("Error fetching serial suggestions: $e");
    }
    return [];
  }

  Future<void> uploadProductAttachments(String productId, List<File> files) async {
    if (files.isEmpty) return;
    isUploadingProductAttachments[productId] = true;
    int total = files.length;
    int successCount = 0;

    try {
      for (int i = 0; i < total; i++) {
        productAttachmentUploadProgress[productId] = total == 1 ? "Uploading..." : "Uploading ${i + 1}/$total...";
        final file = files[i];
        try {
          debugPrint("Uploading file for product $productId: ${file.path}");
          final response = await ApiHandler.uploadFile(file, folderName: 'service-visit-product-attachments');
          final data = response.data;

          if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
            String? fileUrl = data['data'] != null ? data['data']['url'] : null;
            if (fileUrl != null) {
              final productIndex = fieldReportDetail.value?.products.indexWhere((p) => p.id == productId) ?? -1;
              if (productIndex != -1) {
                final product = fieldReportDetail.value!.products[productIndex];
                product.attachments.add(fileUrl);
                fieldReportDetail.refresh();
                successCount++;
              }
            }
          }
        } catch (e) {
          debugPrint("Error uploading product attachment: $e");
        }
      }
      if (successCount > 0) {
        toastMessage(text: total == 1 ? "File uploaded successfully" : "$successCount of $total files uploaded successfully");
      } else {
        toastMessage(text: "File upload failed", color: AppColors.redColor);
      }
    } finally {
      isUploadingProductAttachments[productId] = false;
      productAttachmentUploadProgress.remove(productId);
    }
  }

  Future<void> uploadProductAttachment(String productId, File file) async {
    await uploadProductAttachments(productId, [file]);
  }

  void removeProductAttachment(String productId, int index) {
    if (fieldReportDetail.value == null) return;
    final productIndex = fieldReportDetail.value!.products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      final product = fieldReportDetail.value!.products[productIndex];
      if (index < product.attachments.length) {
        product.attachments.removeAt(index);
        fieldReportDetail.refresh();
      }
    }
  }

  void addPartRequest(String productId) {
    if (fieldReportDetail.value == null) return;
    final productIndex = fieldReportDetail.value!.products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      final product = fieldReportDetail.value!.products![productIndex];
      product.partRequests.add(
        PartRequest(id: "", partName: "", qty: 1, remark: "", attachments: [], status: "requested", createdAt: DateTime.now()),
      );
      expandedPartsSections[productId] = true;
      fieldReportDetail.refresh();
    }
  }

  Future<void> uploadPartAttachments(String productId, int partIndex, List<File> files) async {
    if (files.isEmpty) return;
    final String key = "${productId}_$partIndex";
    isUploadingPartAttachments[key] = true;
    int total = files.length;
    int successCount = 0;

    try {
      for (int i = 0; i < total; i++) {
        partAttachmentUploadProgress[key] = total == 1 ? "Uploading..." : "Uploading ${i + 1}/$total...";
        final file = files[i];
        try {
          final response = await ApiHandler.uploadFile(file, folderName: 'service-visit-part-attachments');
          final data = response.data;
          if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
            String? fileUrl = data['data'] != null ? data['data']['url'] : null;
            if (fileUrl != null) {
              final productIndex = fieldReportDetail.value?.products?.indexWhere((p) => p.id == productId) ?? -1;
              if (productIndex != -1) {
                final product = fieldReportDetail.value!.products![productIndex];
                if (partIndex < product.partRequests.length) {
                  product.partRequests[partIndex].attachments.add(fileUrl);
                  fieldReportDetail.refresh();
                  successCount++;
                }
              }
            }
          }
        } catch (e) {
          debugPrint("Error uploading part attachment: $e");
        }
      }
      if (successCount > 0) {
        toastMessage(text: total == 1 ? "File uploaded successfully" : "$successCount of $total files uploaded successfully");
      } else {
        toastMessage(text: "File upload failed", color: AppColors.redColor);
      }
    } finally {
      isUploadingPartAttachments[key] = false;
      partAttachmentUploadProgress.remove(key);
    }
  }

  Future<void> uploadPartAttachment(String productId, int partIndex, File file) async {
    await uploadPartAttachments(productId, partIndex, [file]);
  }

  void removePartAttachment(String productId, int partIndex, int attachmentIndex) {
    if (fieldReportDetail.value == null || fieldReportDetail.value!.products == null) return;
    final productIndex = fieldReportDetail.value!.products!.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      final product = fieldReportDetail.value!.products![productIndex];
      if (partIndex < product.partRequests.length) {
        if (attachmentIndex < product.partRequests[partIndex].attachments.length) {
          product.partRequests[partIndex].attachments.removeAt(attachmentIndex);
          fieldReportDetail.refresh();
        }
      }
    }
  }

  void updatePartRequest(String productId, int index, String key, dynamic value) {
    if (fieldReportDetail.value == null || fieldReportDetail.value!.products == null) return;
    final productIndex = fieldReportDetail.value!.products!.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      final product = fieldReportDetail.value!.products![productIndex];
      if (index < product.partRequests.length) {
        final part = product.partRequests[index];
        if (key == 'product') {
          part.partName = "[${value['product_code'] ?? ''}] ${value['product_name'] ?? '-'}";
        } else if (key == 'qty') {
          part.qty = value as int;
        } else if (key == 'remark') {
          part.remark = value as String;
        }
        fieldReportDetail.refresh();
      }
    }
  }

  void removePartRequest(String productId, int index) {
    if (fieldReportDetail.value == null || fieldReportDetail.value!.products == null) return;
    final productIndex = fieldReportDetail.value!.products!.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      final product = fieldReportDetail.value!.products![productIndex];
      if (index < product.partRequests.length) {
        product.partRequests.removeAt(index);
        fieldReportDetail.refresh();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getVisitCounts();
    fetchData();
    getExpenseTypes();
    getTravelTypes();

    // End Tracking form listeners to clear errors
    serviceReceivedByController.value.addListener(() {
      if (serviceReceivedByError.isNotEmpty) serviceReceivedByError.value = "";
    });
    contactNumberController.value.addListener(() {
      if (contactNumberError.isNotEmpty) contactNumberError.value = "";
    });
    overallRemarkController.value.addListener(() {
      if (overallRemarkError.isNotEmpty) overallRemarkError.value = "";
    });
    finalUsageNoteController.value.addListener(() {
      if (finalUsageNoteError.isNotEmpty) finalUsageNoteError.value = "";
    });
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
      String filter = "";

      if (selectedTabIndex.value == 5) {
        // TODAY VISIT
        filter = jsonEncode([
          {
            "logic": "AND",
            "conditions": [
              {"field": "today_task", "operator": "eq", "value": true},
            ],
          },
        ]);
      } else if (status.isNotEmpty) {
        filter = jsonEncode([
          {
            "logic": "AND",
            "conditions": [
              {"field": "status", "operator": "eq", "value": status},
            ],
          },
        ]);
      }

      String url = "${ApiEndPoint.serviceVisitList}?page=${currentPage.value}&rowsPerPage=${rowsPerPage.value}&search=${searchController.value.text}";

      if (filter.isNotEmpty) {
        url += "&filterGroups=${Uri.encodeComponent(filter)}";
      }

      url += "&company_id=${Pref.getCompanyId()}&location_id=${Pref.getLocationId()}&fin_year=${Pref.getFinancialYears()}";

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
        getTechnicianExpenses(id); // Fetch expenses along with details
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

  Future<void> getTechnicianExpenses(String visitId) async {
    isExpenseLoading.value = true;
    technicianExpenses.clear();
    try {
      final url = "${ApiEndPoint.technicianExpenseList}?page=1&rowsPerPage=100&service_visit_id=$visitId";
      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);

      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        TechnicianExpenseModel res = TechnicianExpenseModel.fromJson(data);
        technicianExpenses.assignAll(res.data);
      }
    } catch (e) {
      debugPrint("Error fetching technician expenses: $e");
    } finally {
      isExpenseLoading.value = false;
    }
  }

  Future<void> getFieldReport(String id, {bool isRefresh = false}) async {
    if (!isRefresh && fieldReportDetail.value?.id == id && !isFieldReportLoading.value) return;

    isFieldReportLoading.value = true;
    fieldReportError.value = "";

    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}service-visit/$id/field-report");
      final data = json.decode(response.data);

      if (response.statusCode == 200 && data['status'] == 200) {
        FieldReportModel res = FieldReportModel.fromJson(data);
        fieldReportDetail.value = res.data;

        // Pre-fill End Tracking Form
        serviceReceivedByController.value.text = res.data.contactPerson ?? res.data.siteReceiverName ?? "";
        contactNumberController.value.text = res.data.mobile ?? res.data.siteReceiverMobile ?? "";
        siteReceiverMobileCountryCode.value = res.data.mobileCountryCode ?? res.data.siteReceiverMobileCountryCode ?? "+91";
        visitOutcome.value = res.data.visitOutcome ?? "";
        overallRemarkController.value.text = res.data.overallRemark ?? "";
        finalUsageNoteController.value.text = res.data.crowdNote ?? "";
        finalAttachmentUrls.assignAll(List<String>.from(res.data.attachments ?? []));

        final currentUserTech = res.data.visitTechnicians.firstWhereOrNull((t) => t.isCurrentUser == true);
        if (currentUserTech != null) {
          siteArrivalAttachmentUrls.assignAll(currentUserTech.reachedAttachments ?? []);
          siteArrivalRemarkController.value.text = currentUserTech.remark ?? "";
        }

        // Manage Timer
        if (currentUserTech != null && currentUserTech.fieldStatus.toLowerCase() == "started") {
          startTimer(currentUserTech.trackingLogs);
        } else {
          stopTimer();
          currentTimerSeconds.value = _calculateTotalSeconds(currentUserTech?.trackingLogs);
        }
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
        return "pending";
      case 2:
        return "in_progress";
      case 3:
        return "completed";
      case 4:
        return "cancelled";
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
    isActionLoading.value = true;
    try {
      final body = {"cancel_remarks": remarks};
      final response = await ApiHandler.postRequest(url: "${ApiEndPoint.baseUrl}service-visit/$visitId/cancel", body: body);

      final data = response.data;
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        Get.back();
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
      isActionLoading.value = false;
    }
  }

  Future<bool> checkAndRequestLocation() async {
    isLocationChecking.value = true;
    try {
      final loc.Location location = loc.Location();

      // 1. Check and request location permission (shows system default dialog)
      loc.PermissionStatus permission = await location.hasPermission();
      if (permission == loc.PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission != loc.PermissionStatus.granted && permission != loc.PermissionStatus.grantedLimited) {
          toastMessage(text: "Location permission is required");
          return false;
        }
      } else if (permission == loc.PermissionStatus.deniedForever) {
        toastMessage(text: "Location permission is permanently denied. Please enable it in Settings.");
        await Geolocator.openAppSettings();
        return false;
      }

      // 2. Check and request location service (shows system default turn-on dialog)
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          toastMessage(text: "Location service must be enabled");
          return false;
        }
      }

      return true;
    } catch (e) {
      debugPrint("Error checking location: $e");
      toastMessage(text: "Failed to verify location settings");
      return false;
    } finally {
      isLocationChecking.value = false;
    }
  }

  Future<Position?> _handleLocation() async {
    final bool isReady = await checkAndRequestLocation();
    if (!isReady) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint("Error getting position via Geolocator: $e");
      try {
        final loc.Location location = loc.Location();
        final locData = await location.getLocation();
        if (locData.latitude != null && locData.longitude != null) {
          return Position(
            latitude: locData.latitude!,
            longitude: locData.longitude!,
            timestamp: DateTime.now(),
            accuracy: locData.accuracy ?? 0.0,
            altitude: locData.altitude ?? 0.0,
            altitudeAccuracy: 0.0,
            heading: locData.heading ?? 0.0,
            headingAccuracy: 0.0,
            speed: locData.speed ?? 0.0,
            speedAccuracy: locData.speedAccuracy ?? 0.0,
          );
        }
      } catch (e2) {
        debugPrint("Error getting position via Location fallback: $e2");
      }
      toastMessage(text: "Failed to get current location");
      return null;
    }
  }

  Future<void> _updateVisitStatus(String visitId, String action, String successMsg, {Map<String, dynamic>? extraBody}) async {
    isLoading.value = true;
    try {
      Position? position = await _handleLocation();
      if (position == null) {
        isLoading.value = false;
        return;
      }

      final body = {"latitude": position.latitude, "longitude": position.longitude, if (extraBody != null) ...extraBody};
      final url = "${ApiEndPoint.baseUrl}service-visit/$visitId/$action";
      final response = await ApiHandler.postRequest(url: url, body: body);

      final data = response.data;
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        toastMessage(text: data['message'] ?? successMsg);

        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        if (action == "end") {
          Get.back(); // Close screen
        }

        getFieldReport(visitId, isRefresh: true);
        fetchData();
        getVisitCounts();
      } else {
        toastMessage(text: data['message'] ?? "Failed to $action visit");
      }
    } catch (e) {
      debugPrint("Error during $action visit: $e");
      toastMessage(text: "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startVisit(String visitId) async {
    await _updateVisitStatus(visitId, "start", "Visit started successfully");
  }

  Future<void> getExpenseTypes() async {
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}commonMaster/findByGroup?type=Technician+Expense+Type");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        if (data['data'] != null && data['data'].isNotEmpty) {
          List<dynamic> items = data['data'][0]['items'] ?? [];
          expenseTypes.assignAll(items.map((e) => e['name'].toString()).toList());
        }
      }
    } catch (e) {
      debugPrint("Error fetching expense types: $e");
    }
  }

  Future<void> getTravelTypes() async {
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}commonMaster/findByGroup?type=Technician+Expense+travel+Type");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        if (data['data'] != null && data['data'].isNotEmpty) {
          List<dynamic> items = data['data'][0]['items'] ?? [];
          travelTypes.assignAll(items.map((e) => e['name'].toString()).toList());
        }
      }
    } catch (e) {
      debugPrint("Error fetching travel types: $e");
    }
  }

  Future<void> reachVisit(String visitId) async {
    final extraBody = {"attachments": siteArrivalAttachmentUrls};
    await _updateVisitStatus(visitId, "reached-at-site", "Reached at site successfully", extraBody: extraBody);
  }

  Future<void> pauseVisit(String visitId, {String? remark}) async {
    await _updateVisitStatus(visitId, "pause", "Visit paused successfully", extraBody: {"remark": remark ?? ""});
  }

  Future<void> resumeVisit(String visitId) async {
    await _updateVisitStatus(visitId, "resume", "Visit resumed successfully");
  }

  bool validateEndTrackingForm() {
    // Reset errors
    serviceReceivedByError.value = "";
    contactNumberError.value = "";
    visitOutcomeError.value = "";
    overallRemarkError.value = "";
    finalUsageNoteError.value = "";

    bool hasError = false;

    if (serviceReceivedByController.value.text.trim().isEmpty) {
      serviceReceivedByError.value = "Service received by is required";
      hasError = true;
    }
    if (contactNumberController.value.text.trim().isEmpty) {
      contactNumberError.value = "Contact number is required";
      hasError = true;
    }
    if (visitOutcome.value.isEmpty) {
      visitOutcomeError.value = "Please select a visit outcome";
      hasError = true;
    }
    if (overallRemarkController.value.text.trim().isEmpty) {
      overallRemarkError.value = "Overall remark is required";
      hasError = true;
    }
    if (finalUsageNoteController.value.text.trim().isEmpty) {
      finalUsageNoteError.value = "Usage / Crowd Note is required";
      hasError = true;
    }
    if (finalAttachmentUrls.isEmpty) {
      toastMessage(text: "At least one attachment is required");
      hasError = true;
    } else if (hasError) {
      toastMessage(text: "Please fill all required fields");
    }

    return !hasError;
  }

  Future<void> stopVisit(String visitId) async {
    if (!validateEndTrackingForm()) return;

    final extraBody = {
      "site_receiver_name": serviceReceivedByController.value.text.trim(),
      "site_receiver_mobile_country_code": siteReceiverMobileCountryCode.value,
      "site_receiver_mobile": contactNumberController.value.text.trim(),
      "visit_outcome": visitOutcome.value,
      "overall_remark": overallRemarkController.value.text.trim(),
      "crowd_note": finalUsageNoteController.value.text.trim(),
      "attachments": finalAttachmentUrls,
      "products":
          fieldReportDetail.value!.products
              .map(
                (p) => {
                  "id": p.id,
                  "product_id": p.productId,
                  "tax_invoice_id": p.taxInvoiceId,
                  "tax_invoice_no": p.taxInvoiceNo,
                  "complaint_qty": p.complaintQty,
                  "installed_qty": p.installedQty,
                  "client_side_qty": p.clientSideQty,
                  "solve_qty": p.solveQty,
                  "issue_description": p.issueDescription,
                  "usage_note": p.usageNote ?? "",
                  "work_remark": p.workRemark ?? "",
                  "attachments": p.attachments ?? [],
                  "serial_numbers": (p.serialNumbers).where((s) => s.trim().isNotEmpty).toList(),
                  "part_requests": (p.partRequests).map((pr) {
                    return {"part_name": pr.partName, "qty": pr.qty, "remark": pr.remark, "attachments": pr.attachments};
                  }).toList(),
                },
              )
              .toList() ??
          [],
    };

    await _updateVisitStatus(visitId, "end", "Visit stopped successfully", extraBody: extraBody);
  }

  Future<void> saveFieldReport(String visitId) async {
    isLoading.value = true;
    try {
      final body = {
        "products":
            fieldReportDetail.value?.products
                ?.map(
                  (p) => {
                    "id": p.id,
                    "product_id": p.productId,
                    "tax_invoice_id": p.taxInvoiceId,
                    "tax_invoice_no": p.taxInvoiceNo,
                    "complaint_qty": p.complaintQty,
                    "installed_qty": p.installedQty,
                    "client_side_qty": p.clientSideQty,
                    "solve_qty": p.solveQty,
                    "issue_description": p.issueDescription,
                    "usage_note": p.usageNote ?? "",
                    "work_remark": p.workRemark ?? "",
                    "attachments": p.attachments ?? [],
                    "serial_numbers": (p.serialNumbers).where((s) => s.trim().isNotEmpty).toList(),
                    "part_requests": (p.partRequests).map((pr) {
                      return {"part_name": pr.partName, "qty": pr.qty, "remark": pr.remark, "attachments": pr.attachments};
                    }).toList(),
                  },
                )
                .toList() ??
            [],
      };

      final response = await ApiHandler.putRequest(url: "${ApiEndPoint.baseUrl}service-visit/$visitId/field-report", body: body);

      final data = response.data;
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        toastMessage(text: data['message'] ?? "Report saved successfully");
        getFieldReport(visitId, isRefresh: true);
      } else {
        toastMessage(text: data['message'] ?? "Failed to save report");
      }
    } catch (e) {
      debugPrint("Error saving field report: $e");
      toastMessage(text: "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
