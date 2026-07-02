import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import 'model/visit_model.dart';
import 'visit_controller.dart';

class VisitScreen extends GetView<VisitController> {
  const VisitScreen({super.key});

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Service Visits",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          _buildCountCards(),
          _searchBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.visitList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.error.isNotEmpty && controller.visitList.isEmpty) {
                return Center(child: Text(controller.error.value));
              }
              if (controller.visitList.isEmpty) {
                return const Center(child: Text("No Data Found"));
              }
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => controller.fetchData(),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.visitList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = controller.visitList[index];
                          return _buildVisitCard(context, item);
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
        onPressed: () async {
          final result = await Get.toNamed(AppRoutes.addVisitScreen);
          if (result == true) {
            controller.fetchData();
            controller.getVisitCounts();
          }
        },
        backgroundColor: AppColors.indigo600Main,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildVisitCard(BuildContext context, VisitDatum item) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.indigo600Main.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.directions_walk_outlined, color: AppColors.indigo600Main, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.visitNo ?? "No Visit Number",
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.indigo600Main),
                  ),
                ),
                _statusBadge(item),
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
                    Expanded(child: _infoCell(Icons.receipt_long_outlined, "Complaint No", item.complaintNo ?? "-")),
                    Expanded(
                      child: _infoCell(
                        Icons.calendar_today_outlined,
                        "Visit Date",
                        item.visitDate != null ? DateFormat('dd/MM/yyyy').format(item.visitDate!) : "-",
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.gray100),
                ),
                _infoCell(Icons.person_outline, "Customer", item.customerName ?? "-", isFullWidth: true),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _infoCell(Icons.phone_android_outlined, "Mobile", item.mobile ?? "-")),
                    Expanded(child: _infoCell(Icons.assignment_outlined, "Purpose", item.visitPurposeName ?? "-")),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _infoCell(Icons.engineering_outlined, "Technician", item.technicianNames ?? "-")),
                    Expanded(child: _infoCell(Icons.person_add_alt_1_outlined, "Created By", item.createdByName ?? "-")),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _infoCell(Icons.currency_rupee, "Total Expense", item.totalExpense ?? "0.00", valueColor: AppColors.indigo600Main),
                    ),
                    Expanded(
                      child: _infoCell(
                        Icons.account_balance_wallet_outlined,
                        "Balance",
                        item.advanceBalance ?? "0.00",
                        valueColor: AppColors.green500Success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(VisitDatum item) {
    String label = item.statusName ?? item.status ?? "-";
    String status = (item.status ?? "").toUpperCase();

    if (status == "IN_PROGRESS") {
      final myTech = item.visitTechnicians?.firstWhereOrNull((tech) => tech.isCurrentUser == true);
      if (myTech != null && (myTech.fieldStatus ?? "").toUpperCase() == "COMPLETED") {
        label = "Completed(My Task)";
      }
    }

    Color color = AppColors.gray500;

    if (label.toUpperCase().contains("COMPLETED")) {
      color = AppColors.green500Success;
    } else if (status == "PENDING") {
      color = AppColors.orangeColor;
    } else if (status == "IN_PROGRESS") {
      color = AppColors.blue500;
    } else if (status == "CANCELLED" || status == "REJECTED") {
      color = AppColors.red500;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context, VisitDatum item) {
    final status = (item.status ?? "").toUpperCase();
    final bool isCompleted = status == "COMPLETED";
    final bool isPending = status == "PENDING";
    final bool isCancelled = status == "CANCELLED";

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(Icons.more_vert, color: AppColors.indigo600Main, size: 20),
      onSelected: (value) async {
        if (value == 'view') {
          Get.toNamed(AppRoutes.visitViewScreen, arguments: item.id);
        } else if (value == 'field_report') {
          Get.toNamed(AppRoutes.visitFieldReportScreen, arguments: item.id);
        } else if (value == 'cancel') {
          _showCancelVisitDialog(context, item);
        } else if (value == 'add_expense') {
          Get.toNamed(AppRoutes.addExpenseScreen, arguments: item.id);
        } else if (value == 'edit') {
          final result = await Get.toNamed(AppRoutes.addVisitScreen, arguments: item.id);
          if (result == true) {
            controller.fetchData();
            controller.getVisitCounts();
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text("View")]),
        ),
        const PopupMenuItem(
          value: 'field_report',
          child: Row(children: [Icon(Icons.assignment_outlined, size: 16), SizedBox(width: 8), Text("Field Report")]),
        ),
        if (isCompleted)
          const PopupMenuItem(
            value: 'add_expense',
            child: Row(children: [Icon(Icons.add_card_outlined, size: 16), SizedBox(width: 8), Text("Add Expense")]),
          ),
        if (isCancelled || isPending)
          const PopupMenuItem(
            value: 'edit',
            child: Row(children: [Icon(Icons.edit_outlined, size: 16), SizedBox(width: 8), Text("Edit")]),
          ),
        if (isPending)
          const PopupMenuItem(
            value: 'cancel',
            child: Row(
              children: [
                Icon(Icons.cancel_outlined, size: 16, color: AppColors.red500),
                SizedBox(width: 8),
                Text("Cancel Visit", style: TextStyle(color: AppColors.red500)),
              ],
            ),
          ),
      ],
    );
  }

  void _showCancelVisitDialog(BuildContext context, VisitDatum item) {
    final TextEditingController remarksController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.red500.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.cancel_outlined, color: AppColors.red500, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cancel Visit",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Text("Visit ${item.visitNo} will be marked as cancelled", style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: AppColors.gray400),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Cancellation Remarks *",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: remarksController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Why are you cancelling this visit?",
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.gray400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.gray200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.gray200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.red500, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter cancellation remarks";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gray100,
                          foregroundColor: AppColors.textPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("Close", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            controller.cancelVisit(item.id!, remarksController.text.trim());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red500,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel_outlined, size: 16),
                            SizedBox(width: 8),
                            Text("Confirm Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
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
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Icon(icon, size: 18, color: isDisabled ? AppColors.gray300 : AppColors.gray600),
      ),
    );
  }

  Widget _buildCountCards() {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Obx(() {
        final counts = controller.visitCounts.value;
        final selectedIndex = controller.selectedTabIndex.value;

        final List<Map<String, dynamic>> tabs = [
          {"label": "ALL VISITS", "count": counts?.all ?? 0, "icon": Icons.grid_view_rounded, "color": AppColors.indigo600Main},
          {"label": "PENDING", "count": counts?.pending ?? 0, "icon": Icons.pending_actions, "color": AppColors.orangeColor},
          {"label": "IN PROGRESS", "count": counts?.inProgress ?? 0, "icon": Icons.directions_run, "color": AppColors.blue500},
          {"label": "COMPLETED", "count": counts?.completed ?? 0, "icon": Icons.check_circle_outline, "color": AppColors.green500Success},
          {"label": "CANCELLED", "count": counts?.cancelled ?? 0, "icon": Icons.cancel_outlined, "color": AppColors.red500},
        ];

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: tabs.length,
          itemBuilder: (context, index) {
            final tab = tabs[index];
            final isSelected = selectedIndex == index;
            final Color statusColor = tab['color'];

            return GestureDetector(
              onTap: () => controller.onTabChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(right: 12),
                width: 120,
                decoration: BoxDecoration(
                  color: isSelected ? statusColor : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(color: statusColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                    else
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                  border: Border.all(color: isSelected ? Colors.transparent : AppColors.gray200, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: Icon(tab['icon'], size: 50, color: isSelected ? AppColors.white.withOpacity(0.12) : statusColor.withOpacity(0.04)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.white.withOpacity(0.2) : statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(tab['icon'], size: 16, color: isSelected ? AppColors.white : statusColor),
                                ),
                                Text(
                                  "${tab['count']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              tab['label'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? AppColors.white.withOpacity(0.9) : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller.searchController.value,
        onChanged: controller.onSearch,
        decoration: InputDecoration(
          hintText: "Search visits...",
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }
}
