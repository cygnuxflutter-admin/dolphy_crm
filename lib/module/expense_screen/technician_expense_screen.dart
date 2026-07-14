import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import './model/technician_expense_model.dart';
import './technician_expense_controller.dart';
import './technician_expense_view_screen.dart';
import '../../../widget/toast_message.dart';
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
    String status = item.status.toUpperCase();

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(Icons.more_vert, color: AppColors.indigo600Main, size: 20),
      onSelected: (value) {
        if (value == 'view') {
          Get.to(() => TechnicianExpenseViewScreen(expenseId: item.id));
        } else if (value == 'edit') {
          if (Get.isRegistered<ExpenseController>()) {
            Get.find<ExpenseController>().clearData();
          }
          Get.toNamed(AppRoutes.addExpenseScreen, arguments: {'isEdit': true, 'id': item.id});
        } else if (value == 'cancel') {
          _showCancelDialog(context, item);
        } else if (value == 'submit') {
          _showSubmitDialog(context, item);
        }
      },
      itemBuilder: (context) {
        List<PopupMenuEntry<String>> menuItems = [
          const PopupMenuItem(
            value: 'view',
            child: Row(children: [Icon(Icons.visibility_outlined, size: 16, color: AppColors.gray600), SizedBox(width: 8), Text("View")]),
          ),
        ];

        if (status == "DRAFT") {
          menuItems.addAll([
            const PopupMenuItem(
              value: 'edit',
              child: Row(children: [Icon(Icons.edit_outlined, size: 16, color: AppColors.gray600), SizedBox(width: 8), Text("Edit")]),
            ),
            const PopupMenuItem(
              value: 'cancel',
              child: Row(children: [Icon(Icons.cancel_outlined, size: 16, color: AppColors.red500), SizedBox(width: 8), Text("Cancel", style: TextStyle(color: AppColors.red500))]),
            ),
            const PopupMenuItem(
              value: 'submit',
              child: Row(children: [Icon(Icons.send_outlined, size: 16, color: AppColors.blue500), SizedBox(width: 8), Text("Submit", style: TextStyle(color: AppColors.blue500))]),
            ),
          ]);
        }

        return menuItems;
      },
    );
  }

  void _showCancelDialog(BuildContext context, TechnicianExpense item) {
    final TextEditingController remarksController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cancel_outlined, color: Colors.red, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cancel Expense",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Please provide a reason for cancellation",
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: Colors.grey.shade500, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    text: 'Cancellation Remarks ',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                    children: [
                      TextSpan(text: '*', style: TextStyle(color: Colors.red.shade400)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: remarksController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Why are you cancelling this expense?",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Cancel", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (remarksController.text.trim().isEmpty) {
                          toastMessage(text: "Please enter cancellation remarks", color: Colors.red);
                          return;
                        }
                        controller.cancelExpense(item.id, remarksController.text.trim());
                      },
                      icon: const Icon(Icons.cancel_outlined, size: 18, color: Colors.white),
                      label: const Text("Confirm Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSubmitDialog(BuildContext context, TechnicianExpense item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_outlined, color: Colors.blue, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          const Text(
                            "Submit Expense",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: Colors.grey.shade500, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Are you sure you want to submit this expense? Once submitted, it cannot be edited unless rejected.",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Cancel", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.submitExpense(item.id);
                      },
                      icon: const Icon(Icons.send_outlined, size: 18, color: Colors.white),
                      label: const Text("Submit", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue500,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
