import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import './model/technician_expense_model.dart';
import './technician_expense_controller.dart';
import './technician_expense_view_screen.dart';
import 'expense_controller.dart';

class TechnicianExpenseScreen extends GetView<TechnicianExpenseController> {
  const TechnicianExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.indigo600Main,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Technician Expenses",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          _searchBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.expenseList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.expenseList.isEmpty) {
                return const Center(child: Text("No Data Found"));
              }
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => controller.fetchExpenses(),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.expenseList.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = controller.expenseList[index];
                          return _buildExpenseCard(context, item);
                        },
                      ),
                    ),
                  ),
                  _buildPagination(),
                ],
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (Get.isRegistered<ExpenseController>()) {
            Get.find<ExpenseController>().clearData();
          }
          Get.toNamed(AppRoutes.addExpenseScreen);
        },
        backgroundColor: AppColors.indigo600Main,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller.searchController.value,
        onChanged: controller.onSearch,
        decoration: InputDecoration(
          hintText: "Search expenses...",
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildExpenseCard(BuildContext context, TechnicianExpense item) {
    // GMT +5:30 formatting
    String formatDateTime(DateTime? dateTime) {
      if (dateTime == null) return "-";
      var istDateTime = dateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
      return DateFormat('dd/MM/yyyy hh:mm a').format(istDateTime);
    }

    String formatDate(DateTime? dateTime) {
      if (dateTime == null) return "-";
      var istDateTime = dateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
      return DateFormat('dd/MM/yyyy').format(istDateTime);
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.indigo600Main.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_outlined, color: AppColors.indigo600Main, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.expenseNo,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.indigo600Main),
                  ),
                ),
                _statusBadge(item.status),
                _buildActionMenu(context, item),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _infoCell(Icons.directions_walk_outlined, "Visit No", item.visitNo)),
                    Expanded(child: _infoCell(Icons.assignment_outlined, "Complaint No", item.complaintNo)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.gray100),
                ),
                _infoCell(Icons.person_outline, "Customer", item.customerName, isFullWidth: true),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _infoCell(Icons.engineering_outlined, "Technician", item.technicianName)),
                    Expanded(child: _infoCell(Icons.calendar_today_outlined, "Expense Date", formatDate(item.expenseDate))),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _infoCell(Icons.currency_rupee, "Req. Amount", item.totalRequestAmount, valueColor: AppColors.indigo600Main)),
                    Expanded(
                      child: _infoCell(Icons.check_circle_outline, "Appr. Amount", item.totalApproveAmount, valueColor: AppColors.green500Success),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _infoCell(Icons.pending_actions, "Pending", item.pendingAmount, valueColor: AppColors.orangeColor)),
                    Expanded(child: _infoCell(Icons.payments_outlined, "Paid", item.paidAmount, valueColor: AppColors.blue500)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _infoCell(Icons.account_balance_wallet_outlined, "Paid by Client", item.totalClientAmount)),
                    Expanded(child: _infoCell(Icons.access_time, "Created", formatDateTime(item.createdAt))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context, TechnicianExpense item) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(Icons.more_vert, color: AppColors.indigo600Main, size: 20),
      onSelected: (value) {
        if (value == 'view') {
          Get.to(() => TechnicianExpenseViewScreen(expenseId: item.id));
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text("View")]),
        ),
      ],
    );
  }

  Widget _infoCell(IconData icon, String label, String value, {bool isFullWidth = false, Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.gray400),
            const SizedBox(width: 6),
            Text(
              label.toUpperCase(),
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.gray500, letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: isFullWidth ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    Color color = AppColors.gray500;
    String label = status.toUpperCase();

    if (label == "SUBMITTED") {
      color = AppColors.blue500;
    } else if (label == "APPROVED") {
      color = AppColors.green500Success;
    } else if (label == "REJECTED" || label == "CANCELLED") {
      color = AppColors.red500;
    } else if (label == "PENDING") {
      color = AppColors.orangeColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }

  Widget _buildPagination() {
    return Obx(() {
      if (controller.totalPages <= 1) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.gray200, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _paginationButton(
              icon: Icons.keyboard_double_arrow_left,
              onTap: controller.currentPage.value > 1 ? () => controller.onPageChanged(1) : null,
            ),
            const SizedBox(width: 8),
            _paginationButton(
              icon: Icons.keyboard_arrow_left,
              onTap: controller.currentPage.value > 1 ? () => controller.onPageChanged(controller.currentPage.value - 1) : null,
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: AppColors.indigo600Main, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  "${controller.currentPage.value}",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _paginationButton(
              icon: Icons.keyboard_arrow_right,
              onTap: controller.currentPage.value < controller.totalPages ? () => controller.onPageChanged(controller.currentPage.value + 1) : null,
            ),
            const SizedBox(width: 8),
            _paginationButton(
              icon: Icons.keyboard_double_arrow_right,
              onTap: controller.currentPage.value < controller.totalPages ? () => controller.onPageChanged(controller.totalPages) : null,
            ),
          ],
        ),
      );
    });
  }

  Widget _paginationButton({required IconData icon, VoidCallback? onTap}) {
    bool isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Icon(icon, size: 18, color: isDisabled ? AppColors.gray300 : AppColors.gray600),
      ),
    );
  }
}
