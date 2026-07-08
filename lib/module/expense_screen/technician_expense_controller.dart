import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_shared_pref.dart';
import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import './model/technician_expense_model.dart';
import './model/technician_expense_view_model.dart';

class TechnicianExpenseController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<TechnicianExpense> expenseList = <TechnicianExpense>[].obs;
  RxInt currentPage = 1.obs;
  RxInt totalRecords = 0.obs;
  RxInt rowsPerPage = 50.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  int get totalPages => (totalRecords.value / rowsPerPage.value).ceil();

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  Future<void> fetchExpenses({bool isRefresh = true}) async {
    if (isRefresh) {
      currentPage.value = 1;
      expenseList.clear();
    }
    isLoading.value = true;

    try {
      final url =
          "${ApiEndPoint.technicianExpenseList}?page=${currentPage.value}&rowsPerPage=${rowsPerPage.value}&search=${searchController.value.text}&company_id=${Pref.getCompanyId()}&location_id=${Pref.getLocationId()}&fin_year=${Pref.getFinancialYears()}";

      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);

      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        TechnicianExpenseModel res = TechnicianExpenseModel.fromJson(data);
        if (res.data.isNotEmpty) {
          if (isRefresh) {
            expenseList.assignAll(res.data);
          } else {
            expenseList.addAll(res.data);
          }
        }
        totalRecords.value = res.pagination?.totalRecords ?? 0;
      }
    } catch (e) {
      debugPrint("Error fetching technician expenses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<TechnicianExpenseViewData?> fetchExpenseDetails(String id) async {
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}technician-expense/find/$id");
      final data = json.decode(response.data);

      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        return TechnicianExpenseViewModel.fromJson(data).data;
      }
    } catch (e) {
      debugPrint("Error fetching technician expense details: $e");
    }
    return null;
  }

  void onSearch(String query) {
    fetchExpenses();
  }

  void onPageChanged(int page) {
    currentPage.value = page;
    fetchExpenses(isRefresh: false);
  }
}
