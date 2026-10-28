import 'dart:convert';

import 'package:crm/config/app_colors.dart';
import 'package:crm/config/app_url.dart';
import 'package:crm/module/visit_screen/model/visit_history_model.dart';
import 'package:crm/utils/api_handler.dart';
import 'package:crm/widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisitHistoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxString error = "".obs;
  Rxn<VisitHistoryData> historyData = Rxn<VisitHistoryData>();
  String? visitId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is String && args.isNotEmpty) {
      visitId = args;
      fetchHistory(args);
    }
  }

  Future<void> fetchHistory(String id, {bool isRefresh = false}) async {
    visitId = id;
    if (!isRefresh && historyData.value != null && historyData.value?.currentVisitId == id) {
      return;
    }

    if (!isRefresh) {
      isLoading.value = true;
    }
    error.value = "";

    try {
      final url = ApiEndPoint.serviceVisitHistory.replaceAll("{visit_id}", id);
      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);

      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        final model = VisitHistoryModel.fromJson(data);
        historyData.value = model.data;
      } else {
        error.value = data['message'] ?? "Failed to fetch visit history";
        toastMessage(text: error.value, color: AppColors.red500);
      }
    } catch (e) {
      debugPrint("Error fetching visit history: $e");
      error.value = "Something went wrong while fetching history";
      toastMessage(text: error.value, color: AppColors.red500);
    } finally {
      isLoading.value = false;
    }
  }
}
