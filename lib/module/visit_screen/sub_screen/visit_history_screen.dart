import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../model/visit_history_model.dart';
import '../model/visit_model.dart';
import '../visit_history_controller.dart';

class VisitHistoryScreen extends StatelessWidget {
  const VisitHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VisitHistoryController controller = Get.isRegistered<VisitHistoryController>()
        ? Get.find<VisitHistoryController>()
        : Get.put(VisitHistoryController());

    final String visitId = Get.arguments is String ? Get.arguments : "";
    if (visitId.isNotEmpty && controller.historyData.value?.currentVisitId != visitId && !controller.isLoading.value) {
      Future.microtask(() => controller.fetchHistory(visitId));
    }

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
          "Visit History",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.historyData.value == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
        }

        if (controller.error.isNotEmpty && controller.historyData.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.red500),
                  const SizedBox(height: 12),
                  Text(
                    controller.error.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.indigo600Main,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => controller.fetchHistory(visitId, isRefresh: true),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }

        final data = controller.historyData.value;
        if (data == null) {
          return const Center(child: Text("No Visit History Found"));
        }

        final visits = data.visits ?? [];

        return RefreshIndicator(
          onRefresh: () => controller.fetchHistory(visitId, isRefresh: true),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildComplaintCard(data),
              const SizedBox(height: 18),
              _buildSectionHeader(data),
              const SizedBox(height: 12),
              if (visits.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gray200),
                  ),
                  child: const Center(
                    child: Text(
                      "No visits linked to this complaint",
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                )
              else
                ...List.generate(visits.length, (index) {
                  final item = visits[index];
                  final isCurrent = (item.isCurrent == true) || (item.id != null && item.id == data.currentVisitId);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildVisitCard(context, item, index, isCurrent),
                  );
                }),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildComplaintCard(VisitHistoryData data) {
    final complaint = data.complaint;
    final int totalVisits = data.totalVisits ?? data.visits?.length ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.indigo600Main.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.history, color: AppColors.indigo600Main, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Visit History",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.indigo600Main,
                            ),
                          ),
                          if (complaint?.queryNo != null && complaint!.queryNo!.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.indigo100.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "Complaint #${complaint.queryNo}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.indigo600Main,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Showing all visits linked to this complaint",
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.gray600.withOpacity(0.85),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.indigo600Main,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "$totalVisits ${totalVisits == 1 ? 'visit' : 'visits'}",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _infoCell(
                        Icons.receipt_long_outlined,
                        "Complaint No.",
                        complaint?.queryNo ?? "-",
                        valueColor: AppColors.indigo600Main,
                      ),
                    ),
                    Expanded(
                      child: _infoCell(
                        Icons.phone_android_outlined,
                        "Mobile",
                        "${complaint?.mobileCountryCode ?? '+91'} ${complaint?.mobile ?? '-'}",
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.gray100),
                ),
                _infoCell(
                  Icons.business_outlined,
                  "Customer",
                  complaint?.customerName ?? (data.visits?.isNotEmpty == true ? data.visits!.first.customerName ?? "-" : "-"),
                  isFullWidth: true,
                ),
                if (complaint?.contactPerson != null && complaint!.contactPerson!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _infoCell(Icons.person_outline, "Contact Person", complaint.contactPerson ?? "-"),
                      ),
                      Expanded(
                        child: _infoCell(Icons.assignment_outlined, "Purpose", complaint.visitPurposeName ?? "-"),
                      ),
                    ],
                  ),
                ],
                if (complaint?.description != null && complaint!.description!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.indigo50.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.indigo100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.report_problem_outlined, size: 14, color: AppColors.indigo600Main),
                            SizedBox(width: 6),
                            Text(
                              "ISSUE / DESCRIPTION",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.indigo600Main,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          complaint!.description!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(VisitHistoryData data) {
    final int count = data.visits?.length ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.list_alt_rounded, color: AppColors.indigo600Main, size: 18),
            const SizedBox(width: 8),
            const Text(
              "All Visits for this Complaint",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1.5),
              decoration: BoxDecoration(
                color: AppColors.indigo100.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$count",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.indigo600Main,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          "Rows highlighted in blue indicate the visit you selected",
          style: TextStyle(
            fontSize: 11,
            color: AppColors.gray500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildVisitCard(BuildContext context, VisitDatum item, int index, bool isCurrent) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFFF6F8FE) : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? AppColors.indigo600Main : AppColors.gray200,
          width: isCurrent ? 1.4 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: isCurrent ? AppColors.indigo600Main.withOpacity(0.08) : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isCurrent ? AppColors.indigo600Main.withOpacity(0.12) : AppColors.indigo600Main.withOpacity(0.04),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isCurrent ? AppColors.indigo600Main : AppColors.gray200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "#${index + 1}",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isCurrent ? AppColors.white : AppColors.gray700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.directions_walk_outlined, color: AppColors.indigo600Main, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.visitNo ?? "No Visit Number",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: AppColors.indigo600Main,
                          ),
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.blue500,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "Current",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _statusBadge(item),
                _buildCardActionMenu(context, item),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _infoCell(Icons.assignment_outlined, "Purpose", item.visitPurposeName ?? "-")),
                    Expanded(child: _infoCell(Icons.engineering_outlined, "Technician", item.technicianNames ?? item.primaryTechnicianName ?? "-")),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _infoCell(Icons.play_circle_outline, "Visit Start", _formatDateTime(item.visitStartDatetime))),
                    Expanded(child: _infoCell(Icons.stop_circle_outlined, "Visit End", _formatDateTime(item.visitEndDatetime))),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _infoCell(Icons.history, "Created At", _formatDateTime(item.createdAt))),
                    Expanded(child: _infoCell(Icons.task_alt, "Outcome", item.visitOutcome ?? "-")),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _infoCell(
                        Icons.currency_rupee,
                        "Total Expense",
                        item.totalExpense != null ? "₹${item.totalExpense}" : "₹0.00",
                        valueColor: AppColors.indigo600Main,
                      ),
                    ),
                    Expanded(
                      child: _infoCell(
                        Icons.account_balance_wallet_outlined,
                        "Balance",
                        item.advanceBalance != null ? "₹${item.advanceBalance}" : "₹0.00",
                        valueColor: AppColors.green500Success,
                      ),
                    ),
                  ],
                ),
                if (item.remark != null && item.remark!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _infoCell(Icons.notes_outlined, "Remark", item.remark!, isFullWidth: true),
                ],
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.gray200),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.indigo600Main, width: 1),
                          foregroundColor: AppColors.indigo600Main,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => Get.toNamed(AppRoutes.visitViewScreen, arguments: item.id),
                        icon: const Icon(Icons.visibility_outlined, size: 16),
                        label: const Text(
                          "View Visit",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.gray300, width: 1),
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => Get.toNamed(
                          AppRoutes.visitFieldReportScreen,
                          arguments: {
                            'visit_id': item.id,
                            'is_view_only': true,
                          },
                        ),
                        icon: const Icon(Icons.assignment_outlined, size: 16),
                        label: const Text(
                          "Field Report",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
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

  Widget _buildCardActionMenu(BuildContext context, VisitDatum item) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert, color: AppColors.indigo600Main, size: 20),
      onSelected: (value) {
        if (value == 'view') {
          Get.toNamed(AppRoutes.visitViewScreen, arguments: item.id);
        } else if (value == 'field_report') {
          Get.toNamed(
            AppRoutes.visitFieldReportScreen,
            arguments: {
              'visit_id': item.id,
              'is_view_only': true,
            },
          );
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility_outlined, size: 16),
              SizedBox(width: 8),
              Text("View"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'field_report',
          child: Row(
            children: [
              Icon(Icons.assignment_outlined, size: 16),
              SizedBox(width: 8),
              Text("Field Report"),
            ],
          ),
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
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppColors.gray500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: isFullWidth ? 3 : 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
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

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "-";
    return DateFormat('dd/MM/yyyy hh:mm a').format(dateTime.toLocal()).toLowerCase();
  }
}
