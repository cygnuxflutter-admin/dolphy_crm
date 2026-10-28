import 'dart:convert';

import 'package:crm/config/app_url.dart';
import 'package:crm/module/packing_screen/model/invoice_data_response_model.dart';
import 'package:crm/utils/api_handler.dart';
import 'package:get/get.dart';

class ViewPiController extends GetxController {
  RxBool isLoading = false.obs;
  RxString error = "".obs;
  Rx<InvoiceData?> invoiceData = Rx<InvoiceData?>(null);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      getInvoiceData(Get.arguments);
    } else {
      error.value = "Invoice ID not found";
    }
  }

  Future<void> getInvoiceData(String invoiceId) async {
    isLoading.value = true;
    error.value = "";
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}invoice/find/$invoiceId");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        invoiceData.value = InvoiceData.fromJson(data['data']);
      } else {
        error.value = data['message'] ?? "Failed to load invoice data";
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
