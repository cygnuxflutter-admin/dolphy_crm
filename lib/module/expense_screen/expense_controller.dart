import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_shared_pref.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../../../widget/toast_message.dart';
import '../visit_screen/model/visit_model.dart';

class ExpenseLine {
  Rxn<String> expenseType = Rxn<String>();
  TextEditingController otherDetailController = TextEditingController();
  TextEditingController requestAmountController = TextEditingController(text: "0.00");
  RxBool paidByClient = false.obs;
  TextEditingController clientAmountController = TextEditingController(text: "0.00");
  TextEditingController descriptionController = TextEditingController();
  RxList<File> attachments = <File>[].obs;
  RxList<String> attachmentUrls = <String>[].obs;

  ExpenseLine();

  void dispose() {
    otherDetailController.dispose();
    requestAmountController.dispose();
    clientAmountController.dispose();
    descriptionController.dispose();
  }
}

class ExpenseController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isVisitLoading = false.obs;

  RxList<VisitDatum> selectedVisits = <VisitDatum>[].obs;
  Rx<DateTime> expenseDate = DateTime.now().obs;
  TextEditingController remarksController = TextEditingController();
  RxList<File> overallAttachments = <File>[].obs;
  RxList<String> overallAttachmentUrls = <String>[].obs;

  RxList<ExpenseLine> expenseLines = <ExpenseLine>[ExpenseLine()].obs;

  RxList<String> expenseTypes = <String>["Travel", "Food", "Accommodation", "Local Conveyance", "Other"].obs;

  @override
  void onInit() {
    super.onInit();
    getExpenseTypes();
    if (Get.arguments != null && Get.arguments is String) {
      prefillVisit(Get.arguments);
    }
  }

  Future<void> getExpenseTypes() async {
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}commonMaster/findByGroup?type=Technician+Expense+Type");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        List<dynamic> types = data['data'] ?? [];
        if (types.isNotEmpty) {
          expenseTypes.assignAll(types.map((e) => e['name'].toString()).toList());
        }
      }
    } catch (e) {
      debugPrint("Error fetching expense types: $e");
    }
  }

  Future<void> prefillVisit(String visitId) async {
    isLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}technician-expense/visit-prefill/$visitId");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['success'] == true) {
        final prefillData = data['data'];

        // Map prefill data to VisitDatum format used by the dropdown
        final visit = VisitDatum(
          id: prefillData['service_visit_id'],
          visitNo: prefillData['visit_no'],
          status: prefillData['visit_status'],
          statusName: prefillData['visit_status'],
          serviceQueryId: prefillData['service_query_id'],
          complaintNo: prefillData['complaint_no'],
          customerId: prefillData['customer_id'],
          customerName: prefillData['customer_name'],
          complaintTakerName: prefillData['complaint_taker_name'],
          complaintTakerId: prefillData['complaint_taker_id'],
        );

        selectedVisits.assign(visit);
      }
    } catch (e) {
      debugPrint("Error prefilling visit: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<VisitDatum>> searchVisits(String query) async {
    isVisitLoading.value = true;
    try {
      final url =
          "${ApiEndPoint.serviceVisitList}?page=1&rowsPerPage=50&search=$query&company_id=${Pref.getCompanyId()}&location_id=${Pref.getLocationId()}&fin_year=${Pref.getFinancialYears()}";
      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        VisitModel res = VisitModel.fromJson(data);
        return res.data ?? [];
      }
    } catch (e) {
      debugPrint("Error searching visits: $e");
    } finally {
      isVisitLoading.value = false;
    }
    return [];
  }

  void addExpenseLine() {
    expenseLines.add(ExpenseLine());
  }

  void removeExpenseLine(int index) {
    if (expenseLines.length > 1) {
      expenseLines[index].dispose();
      expenseLines.removeAt(index);
    } else {
      toastMessage(text: "At least one expense line is required");
    }
  }

  double get totalRequestAmount {
    double total = 0;
    for (var line in expenseLines) {
      total += double.tryParse(line.requestAmountController.text) ?? 0;
    }
    return total;
  }

  double get totalPaidByClient {
    double total = 0;
    for (var line in expenseLines) {
      if (line.paidByClient.value) {
        total += double.tryParse(line.clientAmountController.text) ?? 0;
      }
    }
    return total;
  }

  double get netExpenseTotal {
    return totalRequestAmount - totalPaidByClient;
  }

  Future<void> submitExpense({bool isDraft = false}) async {
    if (selectedVisits.isEmpty) {
      toastMessage(text: "Please select at least one visit");
      return;
    }

    for (var line in expenseLines) {
      if (line.expenseType.value == null) {
        toastMessage(text: "Please select expense type for all lines");
        return;
      }
    }

    isLoading.value = true;
    try {
      // 1. Upload overall attachments
      overallAttachmentUrls.clear();
      for (var file in overallAttachments) {
        final resp = await ApiHandler.uploadFile(file, folderName: 'expense-attachments');
        final data = resp.data;
        if (resp.statusCode == 200 && data['success'] == true) {
          overallAttachmentUrls.add(data['data']['url']);
        }
      }

      // 2. Upload line attachments
      for (var line in expenseLines) {
        line.attachmentUrls.clear();
        for (var file in line.attachments) {
          final resp = await ApiHandler.uploadFile(file, folderName: 'expense-line-attachments');
          final data = resp.data;
          if (resp.statusCode == 200 && data['success'] == true) {
            line.attachmentUrls.add(data['data']['url']);
          }
        }
      }

      // 3. Submit Expense
      final body = {
        "visit_ids": selectedVisits.map((v) => v.id).toList(),
        "expense_date": DateFormat('yyyy-MM-dd').format(expenseDate.value),
        "remarks": remarksController.text,
        "is_draft": isDraft,
        "lines": expenseLines
            .map(
              (line) => {
                "expense_type": line.expenseType.value,
                "other_detail": line.otherDetailController.text,
                "request_amount": double.tryParse(line.requestAmountController.text) ?? 0,
                "paid_by_client": line.paidByClient.value,
                "client_amount": double.tryParse(line.clientAmountController.text) ?? 0,
                "description": line.descriptionController.text,
                "attachments": line.attachmentUrls,
              },
            )
            .toList(),
        "attachments": overallAttachmentUrls,
        "company_id": Pref.getCompanyId(),
        "location_id": Pref.getLocationId(),
        "fin_year": Pref.getFinancialYears(),
      };

      final response = await ApiHandler.postRequest(url: "${ApiEndPoint.baseUrl}expense/create", body: body);
      final data = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        toastMessage(text: isDraft ? "Draft saved successfully" : "Expense submitted successfully");
        Get.back();
      } else {
        toastMessage(text: data['message'] ?? "Failed to submit expense");
      }
    } catch (e) {
      debugPrint("Error submitting expense: $e");
      toastMessage(text: "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    remarksController.dispose();
    for (var line in expenseLines) {
      line.dispose();
    }
    super.onClose();
  }
}
