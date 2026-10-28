import 'package:crm/config/app_colors.dart';
import 'package:crm/config/app_shared_pref.dart';
import 'package:crm/utils/image_picker_utils.dart';
import 'package:crm/widget/dropdown.dart';
import 'package:crm/widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/dispatched_serial_model.dart';
import '../model/field_report_model.dart';
import '../visit_controller.dart';
import '../widget/add_product_to_visit_dialog.dart';

class FieldReportScreen extends GetView<VisitController> {
  const FieldReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic args = Get.arguments;
    final String visitId = args is Map ? (args["visit_id"] ?? "") : (args is String ? args : "");
    final bool isViewOnly = args is Map ? (args["is_view_only"] == true) : false;

    if (visitId.isNotEmpty && (controller.fieldReportDetail.value?.id != visitId || isViewOnly)) {
      Future.microtask(() => controller.getFieldReport(visitId));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.indigo600Main,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isViewOnly ? "Visit Field Report" : "Field Service Report",
          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
        /*        actions: [
          Obx(() {
            final data = controller.fieldReportDetail.value;
            if (data == null) return const SizedBox.shrink();
            final currentUserTech = data.visitTechnicians.firstWhereOrNull((t) => t.isCurrentUser == true);
            final String fieldStatus = currentUserTech?.fieldStatus.toLowerCase() ?? "";

            if (fieldStatus == "completed") {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton.icon(
                  onPressed: controller.isLoading.value ? null : () => controller.saveFieldReport(visitId),
                  icon: controller.isLoading.value
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save, color: Colors.white, size: 18),
                  label: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],*/
      ),
      body: Obx(() {
        if (controller.isFieldReportLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.fieldReportError.isNotEmpty) {
          return Center(child: Text(controller.fieldReportError.value));
        }
        final data = controller.fieldReportDetail.value;
        if (data == null) {
          return const Center(child: Text("No Report Data Found"));
        }

        if (isViewOnly) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopHeaderViewOnly(data),
                  const SizedBox(height: 14),
                  _buildVisitInfoCardViewOnly(data),
                  const SizedBox(height: 18),
                  _buildProductComplaintDetailsViewOnly(data),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF64748B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      onPressed: () => Get.back(),
                      child: const Text("Close", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }

        final currentUserId = Pref.getUserId();
        final bool canAddProduct =
            (data.status.toUpperCase() != "CANCELLED") &&
            ((data.createdBy == currentUserId) || (data.technicians.any((t) => t.id == currentUserId && t.isPrimary == true)));

        final currentUserTech = data.visitTechnicians.firstWhereOrNull((t) => t.isCurrentUser == true);
        final String fieldStatus = currentUserTech?.fieldStatus.toLowerCase() ?? "";
        final bool showEndButton = (fieldStatus == "started" || fieldStatus == "paused") && currentUserTech?.canStart == false;

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: SingleChildScrollView(
            controller: controller.fieldReportScrollController,
            padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopHeader(data, visitId),
                const SizedBox(height: 8),
                _buildVisitInfoCard(data),
                const SizedBox(height: 15),
                _buildSiteArrivalCard(data, visitId),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        "Product Complaint Details",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFEAB308)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (canAddProduct)
                      ElevatedButton.icon(
                        onPressed: () {
                          controller.clearAddProductForm();
                          Get.dialog(AddProductToVisitDialog(visitId: visitId));
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text("Add Product"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.indigo600Main,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (data.products.isNotEmpty)
                  ...data.products.asMap().entries.map((entry) => _buildProductItem(entry.key + 1, entry.value))
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text("No products added to this report", style: TextStyle(color: AppColors.gray500)),
                    ),
                  ),
                if (showEndButton) ...[
                  const SizedBox(height: 24),
                  KeyedSubtree(key: controller.endTrackingKey, child: _buildEndTrackingForm(visitId)),
                ],
                const SizedBox(height: 0),
                Row(
                  children: [
                    if (showEndButton) ...[
                      Expanded(
                        child: Obx(
                          () => ElevatedButton.icon(
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                                    if (controller.validateEndTrackingForm()) {
                                      _showEndVisitConfirmation(visitId);
                                    }
                                  },
                            icon: controller.isLoading.value
                                ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Icon(Icons.stop_circle_outlined, size: 18),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.redColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            label: Text(controller.isLoading.value ? "Ending..." : "End", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isLoading.value ? null : () => controller.saveFieldReport(visitId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.indigo600Main,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text("Save & Draft", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTopHeader(FieldReportData data, String visitId) {
    final currentUserTech = data.visitTechnicians.firstWhereOrNull((t) => t.isCurrentUser == true);
    final String status = currentUserTech?.fieldStatus.toLowerCase() ?? "";

    final bool showStartButton = currentUserTech != null && (status == "assigned" || status == "reached") && currentUserTech.canStart == true;
    final bool showPauseStopButtons = currentUserTech != null && status == "started" && currentUserTech.canStart == false;
    final bool showRestartStopButtons = currentUserTech != null && status == "paused" && currentUserTech.canStart == false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Visit Field Report",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Visit No.: ${data.visitNo}  ",
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Complaint No.: ${data.complaintNo}",
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "TIMER",
                  style: TextStyle(fontSize: 10, color: AppColors.gray500, fontWeight: FontWeight.bold),
                ),
                Obx(
                  () =>
                      Text(_formatDuration(controller.currentTimerSeconds.value), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            _statusBadge(data.statusName),
            const Spacer(),
            if (showStartButton)
              ElevatedButton.icon(
                onPressed: controller.isLoading.value ? null : () => controller.startVisit(visitId),
                icon: controller.isLoading.value
                    ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.play_circle_outline, size: 18),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.indigo600Main,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  elevation: 0,
                ),
                label: Text(controller.isLoading.value ? "Starting..." : "Start", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              )
            else if (showPauseStopButtons)
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            final remarkController = TextEditingController();
                            Get.dialog(
                              AlertDialog(
                                title: const Text("Pause Visit"),
                                content: TextField(
                                  controller: remarkController,
                                  decoration: const InputDecoration(hintText: "Enter remark"),
                                ),
                                actions: [
                                  TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                      controller.pauseVisit(visitId, remark: remarkController.text);
                                    },
                                    child: const Text("Pause"),
                                  ),
                                ],
                              ),
                            );
                          },
                    icon: controller.isLoading.value
                        ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.pause_circle_outline, size: 18),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orangeColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 0,
                    ),
                    label: Text(
                      controller.isLoading.value ? "Pausing..." : "Pause",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: controller.isLoading.value ? null : () => controller.scrollToEndTracking(),
                    icon: controller.isLoading.value
                        ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.stop_circle_outlined, size: 18),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 0,
                    ),
                    label: Text(controller.isLoading.value ? "Ending..." : "End", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              )
            else if (showRestartStopButtons)
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.isLoading.value ? null : () => controller.resumeVisit(visitId),
                    icon: controller.isLoading.value
                        ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.play_circle_outline, size: 18),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green500Success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 0,
                    ),
                    label: Text(
                      controller.isLoading.value ? "Restarting..." : "Restart",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: controller.isLoading.value ? null : () => controller.scrollToEndTracking(),
                    icon: controller.isLoading.value
                        ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.stop_circle_outlined, size: 18),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 0,
                    ),
                    label: Text(controller.isLoading.value ? "Ending..." : "End", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (currentUserTech?.fieldStatus.toLowerCase() == "completed" ? AppColors.green500Success : AppColors.orangeColor).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (currentUserTech?.fieldStatus.toLowerCase() == "completed" ? AppColors.green500Success : AppColors.orangeColor).withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      currentUserTech?.fieldStatus.toLowerCase() == "completed" ? Icons.check_circle : Icons.watch_later_outlined,
                      size: 14,
                      color: currentUserTech?.fieldStatus.toLowerCase() == "completed" ? AppColors.green500Success : AppColors.orangeColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      (currentUserTech?.fieldStatus ?? "PENDING").toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: currentUserTech?.fieldStatus.toLowerCase() == "completed" ? AppColors.green500Success : AppColors.orangeColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildVisitInfoCard(FieldReportData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.indigo600Main.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.assignment_outlined, size: 18, color: AppColors.indigo600Main),
              SizedBox(width: 8),
              Text(
                "Visit Info",
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(height: 1, color: AppColors.gray100),
          ),
          _buildResponsiveInfoGrid([
            // _infoItem("VISIT NO.", data.visitNo ?? "-"),
            // _infoItem("COMPLAINT NO.", data.complaintNo ?? "-"),
            _infoItem("CUSTOMER", data.customerName ?? "-"),
            _infoItem("STATUS", data.statusName ?? "-"),
            _infoItem("VISIT PURPOSE", data.visitPurposeName ?? "-"),
            _infoItem("VISIT START DATE & TIME", DateFormat('dd/MM/yyyy hh:mm a').format(data.visitStartDatetime.toLocal())),
            _infoItem("VISIT END DATE & TIME", DateFormat('dd/MM/yyyy hh:mm a').format(data.visitEndDatetime.toLocal())),
            _infoItem("TECHNICIAN", data.technicianNames ?? "-"),
          ]),
        ],
      ),
    );
  }

  Widget _buildResponsiveInfoGrid(List<Widget> items) {
    return Column(
      children: List.generate((items.length / 2).ceil(), (index) {
        int first = index * 2;
        int second = first + 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: items[first]),
              const SizedBox(width: 16),
              Expanded(child: second < items.length ? items[second] : const SizedBox.shrink()),
            ],
          ),
        );
      }),
    );
  }

  Widget _infoItem(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.gray500, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildTopHeaderViewOnly(FieldReportData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.green500Success.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.assignment_turned_in_outlined, color: AppColors.green500Success, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                "Visit Field Report",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (data.visitNo.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.blue500,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    data.visitNo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              if (data.complaintNo.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.indigo50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.indigo100),
                  ),
                  child: Text(
                    "Complaint #${data.complaintNo}",
                    style: const TextStyle(
                      color: AppColors.indigo600Main,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              _statusBadge(data.statusName),
            ],
          ),
          if (data.customerName.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "Customer: ${data.customerName}",
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVisitInfoCardViewOnly(FieldReportData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.blue500),
              SizedBox(width: 8),
              Text(
                "Visit Info",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.blue500),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: AppColors.gray100),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _infoItem("VISIT NO.", data.visitNo.isNotEmpty ? data.visitNo : "-")),
              const SizedBox(width: 12),
              Expanded(
                child: _infoItem(
                  "COMPLAINT NO.",
                  data.complaintNo.isNotEmpty ? data.complaintNo : "-",
                  valueColor: AppColors.blue600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _infoItem("CUSTOMER", data.customerName.isNotEmpty ? data.customerName : "-")),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "STATUS",
                      style: TextStyle(fontSize: 10, color: AppColors.gray500, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    _statusBadge(data.statusName),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _infoItem("VISIT PURPOSE", data.visitPurposeName.isNotEmpty ? data.visitPurposeName : "-")),
              const SizedBox(width: 12),
              Expanded(child: _infoItem("TECHNICIAN", data.technicianNames ?? data.primaryTechnicianName ?? "-")),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _infoItem(
                  "VISIT START DATE & TIME",
                  DateFormat('dd/MM/yyyy hh:mm a').format(data.visitStartDatetime.toLocal()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoItem(
                  "VISIT END DATE & TIME",
                  DateFormat('dd/MM/yyyy hh:mm a').format(data.visitEndDatetime.toLocal()),
                ),
              ),
            ],
          ),
          if (data.address.isNotEmpty) ...[
            const SizedBox(height: 12),
            _infoItem("ADDRESS", data.address, valueColor: AppColors.blue600),
          ],
        ],
      ),
    );
  }

  Widget _buildProductComplaintDetailsViewOnly(FieldReportData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.inventory_2_outlined, color: Color(0xFFEAB308), size: 18),
            const SizedBox(width: 8),
            const Text(
              "Product Complaint Details",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFEAB308)),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1.5),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF9C3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${data.products.length}",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF854D0E),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (data.products.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gray200),
            ),
            child: const Center(
              child: Text("No products added to this report", style: TextStyle(color: AppColors.gray500, fontSize: 13)),
            ),
          )
        else
          ...data.products.asMap().entries.map((entry) => _buildProductItemViewOnly(entry.key + 1, entry.value)),
      ],
    );
  }

  Widget _buildProductItemViewOnly(int index, Product p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.blue500,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$index",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              p.productName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (p.productCode.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.gray100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                p.productCode,
                                style: const TextStyle(fontSize: 10, color: AppColors.gray700, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _miniBadge(Icons.assignment_outlined, "Complaint: ${p.complaintQty ?? 0}"),
                          _miniBadge(
                            Icons.check_circle_outline,
                            "Solve: ${p.solveQty ?? 0}",
                            color: (p.solveQty != null && p.solveQty! > 0) ? AppColors.green500Success : AppColors.gray500,
                          ),
                          _miniBadge(
                            Icons.verified_user_outlined,
                            "Warranty: ${p.warrantyTypeName ?? 'Under Warranty'}",
                            color: AppColors.blue600,
                          ),
                          _miniBadge(
                            Icons.repeat_on_outlined,
                            "Repeat: ${p.repeatServiceStatus ?? 'First Service'}",
                            color: AppColors.indigo600Main,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.report_problem_outlined, size: 14, color: Color(0xFFEF4444)),
                SizedBox(width: 6),
                Text(
                  "Issue Description",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gray700),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                p.issueDescription ?? "No description",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Row(
                children: [
                  Expanded(child: _readonlyQtyItem("Complaint Qty", "${p.complaintQty ?? 0}")),
                  Expanded(child: _readonlyQtyItem("Installed Qty", "${p.installedQty ?? 0}")),
                  Expanded(child: _readonlyQtyItem("Client Side Qty", "${p.clientSideQty ?? 0}")),
                  Expanded(
                    child: _readonlyQtyItem(
                      "Solve Qty",
                      "${p.solveQty ?? 0}",
                      valueColor: (p.solveQty != null && p.solveQty! > 0) ? AppColors.green500Success : null,
                    ),
                  ),
                ],
              ),
            ),
            if (p.serialNumbers != null && p.serialNumbers!.isNotEmpty && p.serialNumbers![0].isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.qr_code, size: 14, color: AppColors.indigo600Main),
                  const SizedBox(width: 6),
                  const Text(
                    "Serial Number: ",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gray600),
                  ),
                  Expanded(
                    child: Text(
                      p.serialNumbers!.join(', '),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                    ),
                  ),
                ],
              ),
            ],
            if (p.workRemark.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notes, size: 14, color: AppColors.gray500),
                  const SizedBox(width: 6),
                  const Text(
                    "Work Remark: ",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gray600),
                  ),
                  Expanded(
                    child: Text(
                      p.workRemark,
                      style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ],
            if (p.attachments != null && p.attachments!.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text(
                "ATTACHMENTS",
                style: TextStyle(fontSize: 10, color: AppColors.gray500, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: p.attachments!.map((url) {
                  return InkWell(
                    onTap: () {
                      Get.dialog(
                        Dialog(
                          child: Stack(
                            children: [
                              InteractiveViewer(child: Image.network(url, fit: BoxFit.contain)),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  onPressed: () => Get.back(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        url,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 50,
                          height: 50,
                          color: AppColors.gray200,
                          child: const Icon(Icons.image, size: 24, color: AppColors.gray400),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _readonlyQtyItem(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.gray500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildProductItem(int index, Product p) {
    return Obx(() {
      final bool isExpanded = controller.expandedProducts[p.id ?? ""] ?? (index == 1);
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => controller.toggleProductExpansion(p.id ?? ""),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  "$index",
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Tooltip(
                                            message: p.productName,
                                            triggerMode: TooltipTriggerMode.longPress,
                                            waitDuration: Duration.zero,
                                            showDuration: const Duration(seconds: 4),
                                            preferBelow: false,
                                            verticalOffset: 16,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            margin: const EdgeInsets.symmetric(horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1E293B),
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 4)),
                                              ],
                                            ),
                                            textStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500, height: 1.3),
                                            child: Text(
                                              p.productName,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        if (p.productCode.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: AppColors.indigo50, borderRadius: BorderRadius.circular(4)),
                                            child: Text(
                                              p.productCode,
                                              style: const TextStyle(fontSize: 9, color: AppColors.indigo600Main, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _miniBadge(Icons.assignment_outlined, "Complaint ${p.complaintQty ?? 0}"),
                                const SizedBox(width: 6),
                                _miniBadge(
                                  Icons.check_circle_outline,
                                  "Solve ${p.solveQty ?? '-'}",
                                  color: p.solveQty != null ? AppColors.green500Success : AppColors.orangeColor,
                                ),
                                const SizedBox(width: 6),
                                _miniBadge(Icons.description_outlined, "Invoice ${p.taxInvoiceNo ?? '-'}", color: AppColors.gray500),
                                const SizedBox(width: 6),
                                _miniBadge(Icons.description_outlined, "Date ${p.taxInvoiceDate ?? '-'}", color: AppColors.gray500),
                                if (p.serialNumbers != null && p.serialNumbers!.isNotEmpty) ...[
                                  const SizedBox(width: 6),
                                  _miniBadge(Icons.qr_code_scanner, "S/N ${p.serialNumbers!.length}", color: AppColors.gray500),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (p.isAddedOnVisit == true) _tagBadge("Added on Visit", AppColors.blue500),
                        if (p.needsComplaintSync == true)
                          Padding(padding: const EdgeInsets.only(top: 4), child: _tagBadge("Sync Required", AppColors.orangeColor)),
                        Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.indigo600Main),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _productMainDetails(p),
                    const SizedBox(height: 16),
                    if (p.usageNote.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.indigo600Main.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.indigo600Main.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.note_alt_outlined, size: 18, color: AppColors.indigo600Main),
                            const SizedBox(width: 10),
                            RichText(
                              text: TextSpan(
                                text: "Usage Note  ",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.indigo600Main),
                                children: [
                                  TextSpan(
                                    text: p.usageNote,
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.sticky_note_2_outlined, size: 16, color: AppColors.indigo600Main),
                          const SizedBox(width: 8),
                          Text(
                            "ISSUE DESCRIPTION",
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gray600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.gray200),
                      ),
                      child: Text(p.issueDescription ?? "No description", style: const TextStyle(fontSize: 13)),
                    ),
                    const SizedBox(height: 20),
                    _buildQuantitySection(p),
                    const SizedBox(height: 16),
                    _buildSerialSection(p),
                    const SizedBox(height: 16),
                    _buildWorkAttachmentsSection(p),
                    const SizedBox(height: 10),
                    _buildPartsAvailableSection(p),
                    const SizedBox(height: 16),
                    _buildPartsRequiredSection(p),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildPartsAvailableSection(Product p) {
    if (p.partsAvailable == null || p.partsAvailable!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _formLabelWithIcon(Icons.inventory_2_outlined, "Parts Available"),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.green500Success.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                ...p.partsAvailable!.asMap().entries.map((entry) {
                  final index = entry.key;
                  final part = entry.value as Map<String, dynamic>;
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border(bottom: index == p.partsAvailable!.length - 1 ? BorderSide.none : const BorderSide(color: AppColors.gray100)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              part['part_name'] ?? "Available Part #${index + 1}",
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.green500Success),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.green500Success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "QTY: ${part['qty'] ?? 0}",
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.green500Success),
                              ),
                            ),
                          ],
                        ),
                        if (part['remark'] != null && part['remark'].toString().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text("Remark: ${part['remark']}", style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productMainDetails(Product p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.gray50, borderRadius: BorderRadius.circular(8)),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          _iconText(Icons.receipt_outlined, "Tax Invoice: ${p.taxInvoiceNo ?? '-'}"),
          _iconText(Icons.receipt_outlined, "Tax Date: ${p.taxInvoiceDate ?? '-'}"),
          _iconText(Icons.verified_user_outlined, "Warranty: ${p.warrantyTypeName ?? '-'}"),
          _iconText(Icons.repeat_on_outlined, "Repeat: ${p.repeatServiceStatus ?? 'First Service'}"),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.gray500),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _tagBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(text.contains("Visit") ? Icons.add_circle_outline : Icons.sync, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildSerialSection(Product p) {
    final String visitId = controller.fieldReportDetail.value?.id ?? Get.arguments ?? "";
    return Obx(() {
      final bool isExpanded = controller.expandedSerialSections[p.id ?? ""] ?? false;
      final bool hasSerial = p.serialNumbers != null && p.serialNumbers!.isNotEmpty && p.serialNumbers![0].isNotEmpty;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => controller.toggleSerialSectionExpansion(p.id ?? ""),
              borderRadius: BorderRadius.vertical(top: const Radius.circular(8), bottom: Radius.circular(isExpanded ? 0 : 8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code, size: 16, color: AppColors.indigo600Main),
                    const SizedBox(width: 8),
                    const Text(
                      "Serial Number",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                    ),
                    const SizedBox(width: 8),
                    if (hasSerial)
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.indigo50, borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            p.serialNumbers!.length > 1 ? "${p.serialNumbers![0]} (+${p.serialNumbers!.length - 1})" : p.serialNumbers![0],
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(4)),
                        child: const Text(
                          "Not entered",
                          style: TextStyle(fontSize: 10, color: AppColors.gray500, fontWeight: FontWeight.w500),
                        ),
                      ),
                    const Spacer(),
                    Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.indigo600Main),
                  ],
                ),
              ),
            ),
            if (isExpanded) ...[
              const Divider(height: 1, color: AppColors.gray200),
              Padding(
                padding: const EdgeInsets.all(12),
                child: p.serialNumbers != null && p.serialNumbers!.isNotEmpty
                    ? LayoutBuilder(
                        builder: (context, constraints) {
                          return RawAutocomplete<DispatchedSerialData>(
                            optionsBuilder: (TextEditingValue textEditingValue) async {
                              return await controller.getDispatchedSerialSuggestions(
                                visitId: visitId,
                                visitItemId: p.id ?? "",
                                productId: p.productId ?? "",
                                query: textEditingValue.text,
                              );
                            },
                            displayStringForOption: (DispatchedSerialData option) => option.serialNumber ?? "",
                            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                              if (textEditingController.text.isEmpty && p.serialNumbers![0].isNotEmpty) {
                                textEditingController.text = p.serialNumbers![0];
                              }
                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                style: const TextStyle(fontSize: 13),
                                onChanged: (val) => controller.updateSerialNumber(p.id ?? "", 0, val),
                                onFieldSubmitted: (value) => onFieldSubmitted(),
                                onTap: () {
                                  // Force call optionsBuilder when tapped
                                  final String currentText = textEditingController.text;
                                  textEditingController.value = TextEditingValue(
                                    text: currentText,
                                    selection: TextSelection.collapsed(offset: currentText.length),
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: "Type dispatched serial number",
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: AppColors.gray200),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: AppColors.gray200),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: AppColors.indigo600Main),
                                  ),
                                ),
                              );
                            },
                            onSelected: (DispatchedSerialData selection) {
                              controller.updateSerialNumber(p.id ?? "", 0, selection.serialNumber ?? "");
                            },
                            optionsViewBuilder: (context, onSelected, options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  borderRadius: BorderRadius.circular(8),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: 250, maxWidth: constraints.maxWidth),
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        separatorBuilder: (context, index) => const Divider(height: 1),
                                        itemBuilder: (BuildContext context, int index) {
                                          final option = options.elementAt(index);
                                          return InkWell(
                                            onTap: () => onSelected(option),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(color: Colors.black, fontSize: 13),
                                                  children: [
                                                    TextSpan(
                                                      text: option.serialNumber ?? "",
                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    if (option.dispatchNumber != null)
                                                      TextSpan(
                                                        text: " (${option.dispatchNumber})",
                                                        style: const TextStyle(color: AppColors.gray500),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : InkWell(
                        onTap: () => controller.updateSolveQty(p.id ?? "", "1"),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.gray200),
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.gray50,
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.add_circle_outline, size: 24, color: AppColors.gray400),
                              SizedBox(height: 8),
                              Text(
                                "No serial number entered",
                                style: TextStyle(fontSize: 13, color: AppColors.gray500, fontWeight: FontWeight.bold),
                              ),
                              Text("Tap here to add serial number", style: TextStyle(fontSize: 11, color: AppColors.gray400)),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildQuantitySection(Product p) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _formLabelWithIcon(Icons.calendar_view_day_outlined, "Quantity Details"),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _qtyField("Complaint Qty", "${p.complaintQty ?? 0}")),
              const SizedBox(width: 20),
              Expanded(child: _qtyField("Installed Qty", "${p.installedQty ?? 0}")),
              const SizedBox(width: 20),
              Expanded(child: _qtyField("Client Side Qty", "${p.clientSideQty ?? 0}")),
              const SizedBox(width: 20),
              Expanded(
                child: _qtyField(
                  "Solve Qty *",
                  "${p.solveQty ?? 0}",
                  isEditable: true,
                  onChanged: (val) => controller.updateSolveQty(p.id ?? "", val),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyField(String label, String value, {bool isEditable = false, Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gray600),
          ),
        ),
        // const SizedBox(height: 6),
        isEditable
            ? TextFormField(
                key: ValueKey(value),
                initialValue: value,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                onChanged: onChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.indigo600Main),
                  ),
                ),
              )
            : TextFormField(
                key: ValueKey(value),
                initialValue: value,
                readOnly: true,
                enabled: false,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                onChanged: onChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.indigo600Main),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildWorkAttachmentsSection(Product p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _formLabelWithIcon(Icons.edit_note, "Work & Attachments"),
          const SizedBox(height: 12),
          const Text(
            "WORK REMARK",
            style: TextStyle(fontSize: 10, color: AppColors.gray500, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: p.workRemark,
            maxLines: 3,
            style: const TextStyle(fontSize: 13),
            onChanged: (val) => controller.updateWorkRemark(p.id ?? "", val),
            decoration: InputDecoration(
              hintText: "Additional work notes for this product..",
              hintStyle: const TextStyle(fontSize: 12, color: AppColors.gray400),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.gray200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.gray200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.indigo600Main),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "ATTACHMENTS",
            style: TextStyle(fontSize: 10, color: AppColors.gray500, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final bool isUploading = controller.isUploadingProductAttachments[p.id ?? ""] ?? false;
            final String progressText = controller.productAttachmentUploadProgress[p.id ?? ""] ?? "Uploading...";

            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border.all(color: isUploading ? AppColors.indigo600Main.withValues(alpha: 0.5) : AppColors.gray200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: isUploading ? null : () => _pickFile(p.id ?? ""),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isUploading ? AppColors.indigo50.withValues(alpha: 0.5) : AppColors.gray50,
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                            border: const Border(right: BorderSide(color: AppColors.gray200)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isUploading) ...[
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.indigo600Main),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                isUploading ? "Uploading..." : "Choose Files",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isUploading ? AppColors.indigo600Main : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: isUploading
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        progressText,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.indigo600Main),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  p.attachments != null && p.attachments!.isNotEmpty ? "${p.attachments!.length} files chosen" : "No file chosen",
                                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ),
                    ],
                  ),
                  if (isUploading) const LinearProgressIndicator(minHeight: 2.5, backgroundColor: AppColors.indigo50, color: AppColors.indigo600Main),
                ],
              ),
            );
          }),
          if (p.attachments != null && p.attachments!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gray100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Uploaded files (${p.attachments!.length}):",
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  ...p.attachments!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final attachmentUrl = entry.value;
                    final fileName = attachmentUrl.split('/').last;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.indigo50.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              fileName,
                              style: const TextStyle(fontSize: 12, color: AppColors.indigo600Main),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => controller.removeProductAttachment(p.id ?? "", index),
                            child: const Icon(Icons.close, size: 14, color: AppColors.red500),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickPartFile(String productId, int partIndex) async {
    ImagePickerUtils.showOptions(
      multiImage: true,
      onMultiImageSelected: (files) {
        controller.uploadPartAttachments(productId, partIndex, files);
      },
      onImageSelected: (file) {
        controller.uploadPartAttachments(productId, partIndex, [file]);
      },
    );
  }

  Future<void> _pickFile(String productId) async {
    ImagePickerUtils.showOptions(
      multiImage: true,
      onMultiImageSelected: (files) {
        controller.uploadProductAttachments(productId, files);
      },
      onImageSelected: (file) {
        controller.uploadProductAttachments(productId, [file]);
      },
    );
  }

  Widget _buildPartsRequiredSection(Product p) {
    return Obx(() {
      final bool isExpanded = controller.expandedPartsSections[p.id ?? ""] ?? false;
      final int partCount = p.partRequests?.length ?? 0;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => controller.togglePartsSectionExpansion(p.id ?? ""),
              borderRadius: BorderRadius.vertical(top: const Radius.circular(8), bottom: Radius.circular(isExpanded ? 0 : 8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.settings_input_component_outlined, size: 16, color: AppColors.indigo600Main),
                    const SizedBox(width: 8),
                    const Flexible(
                      child: Text(
                        "Parts Required",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: partCount > 0 ? AppColors.indigo50 : AppColors.gray100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        partCount > 0 ? "$partCount Part${partCount > 1 ? 's' : ''}" : "0 Parts",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: partCount > 0 ? AppColors.indigo600Main : AppColors.gray500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        controller.addPartRequest(p.id ?? "");
                        if (!isExpanded) {
                          controller.togglePartsSectionExpansion(p.id ?? "");
                        }
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 14, color: AppColors.indigo600Main),
                            SizedBox(width: 2),
                            Text(
                              "Add",
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.indigo600Main, size: 20),
                  ],
                ),
              ),
            ),
            if (isExpanded) ...[
              const Divider(height: 1, color: AppColors.gray200),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (p.partRequests != null && p.partRequests!.isNotEmpty)
                      Column(
                        children: [
                          ...p.partRequests!.asMap().entries.map((entry) {
                            final index = entry.key;
                            final part = entry.value;
                            return Container(
                              margin: EdgeInsets.only(bottom: index == p.partRequests!.length - 1 ? 0 : 12),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.gray200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "PART #${index + 1}",
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                                      ),
                                      Row(
                                        children: [
                                          if (part.status.isNotEmpty)
                                            Container(
                                              margin: const EdgeInsets.only(right: 8),
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: (part.status == 'requested' ? AppColors.orangeColor : AppColors.green500Success).withValues(
                                                  alpha: 0.1,
                                                ),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                part.status.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  color: part.status == 'requested' ? AppColors.orangeColor : AppColors.green500Success,
                                                ),
                                              ),
                                            ),
                                          IconButton(
                                            onPressed: () => controller.removePartRequest(p.id ?? "", index),
                                            icon: const Icon(Icons.delete_outline, color: AppColors.redColor, size: 20),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  _formLabel("Part Name"),
                                  CustomDropdown<dynamic>(
                                    hintText: "Search part...",
                                    items: (filter, loadProps) async => await controller.searchProducts(filter),
                                    itemAsString: (item) {
                                      if (item is PartRequest) return item.partName;
                                      if (item is Map) return "[${item['product_code'] ?? ''}] ${item['product_name'] ?? '-'}";
                                      return item.toString();
                                    },
                                    selectedItem: part.partName.isNotEmpty ? part : null,
                                    compareFn: (i, s) {
                                      if (i is PartRequest && s is PartRequest) return i.id == s.id;
                                      if (i is Map && s is Map) return (i['id'] ?? i['product_id']) == (s['id'] ?? s['product_id']);
                                      if (i is PartRequest && s is Map) return i.partName.contains(s['product_name'] ?? '');
                                      return false;
                                    },
                                    onChanged: (val) => controller.updatePartRequest(p.id ?? "", index, 'product', val),
                                    showSearchBox: true,
                                    padding: 0,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _formLabel("Qty"),
                                            TextFormField(
                                              initialValue: "${part.qty}",
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              style: const TextStyle(fontSize: 12),
                                              onChanged: (val) => controller.updatePartRequest(p.id ?? "", index, 'qty', int.tryParse(val) ?? 1),
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: const BorderSide(color: AppColors.gray200),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: const BorderSide(color: AppColors.gray200),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _formLabel("Remark"),
                                            TextFormField(
                                              initialValue: part.remark,
                                              style: const TextStyle(fontSize: 12),
                                              onChanged: (val) => controller.updatePartRequest(p.id ?? "", index, 'remark', val),
                                              decoration: InputDecoration(
                                                hintText: "Enter remark",
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: const BorderSide(color: AppColors.gray200),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: const BorderSide(color: AppColors.gray200),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _formLabel("Attachment"),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Obx(() {
                                          final String partKey = "${p.id ?? ''}_$index";
                                          final bool isUploading = controller.isUploadingPartAttachments[partKey] ?? false;
                                          final String progressText = controller.partAttachmentUploadProgress[partKey] ?? "Uploading...";

                                          return Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: isUploading ? AppColors.indigo600Main.withValues(alpha: 0.5) : AppColors.gray200,
                                              ),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: isUploading ? null : () => _pickPartFile(p.id ?? "", index),
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                        decoration: BoxDecoration(
                                                          color: isUploading ? AppColors.indigo50.withValues(alpha: 0.5) : AppColors.gray50,
                                                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                                                          border: const Border(right: BorderSide(color: AppColors.gray200)),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            if (isUploading) ...[
                                                              const SizedBox(
                                                                width: 12,
                                                                height: 12,
                                                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.indigo600Main),
                                                              ),
                                                              const SizedBox(width: 6),
                                                            ],
                                                            Text(
                                                              isUploading ? "Uploading..." : "Choose Files",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                color: isUploading ? AppColors.indigo600Main : AppColors.textPrimary,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                                        child: isUploading
                                                            ? Text(
                                                                progressText,
                                                                style: const TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: AppColors.indigo600Main,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              )
                                                            : Text(
                                                                part.attachments.isNotEmpty ? "${part.attachments.length} files" : "No file chosen",
                                                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (isUploading)
                                                  const LinearProgressIndicator(
                                                    minHeight: 2,
                                                    backgroundColor: AppColors.indigo50,
                                                    color: AppColors.indigo600Main,
                                                  ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  if (part.attachments.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    ...List.generate(part.attachments.length, (attIndex) {
                                      final url = part.attachments[attIndex];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                url.split('/').last,
                                                style: const TextStyle(fontSize: 11, color: AppColors.indigo600Main),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            InkWell(
                                              onTap: () => controller.removePartAttachment(p.id ?? "", index, attIndex),
                                              child: const Icon(Icons.delete_outline, size: 16, color: AppColors.redColor),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ],
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () => controller.addPartRequest(p.id ?? ""),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.indigo50.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.indigo600Main.withValues(alpha: 0.2)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, size: 16, color: AppColors.indigo600Main),
                                  SizedBox(width: 6),
                                  Text(
                                    "Add Another Part",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.gray200),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.inventory_2_outlined, color: AppColors.gray300, size: 36),
                            const SizedBox(height: 8),
                            const Text("No parts requested yet.", style: TextStyle(color: AppColors.gray400, fontSize: 13)),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () => controller.addPartRequest(p.id ?? ""),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text("Add Part", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.indigo600Main,
                                side: const BorderSide(color: AppColors.indigo600Main),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _formLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gray600),
      ),
    );
  }

  Widget _formLabelWithIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.indigo600Main),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
        ),
      ],
    );
  }

  Widget _miniBadge(IconData icon, String text, {Color color = AppColors.indigo600Main}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _statusBadge(String status) {
    Color color = AppColors.gray500;
    if (status.toUpperCase() == "COMPLETED") color = AppColors.green500Success;
    if (status.toUpperCase() == "PENDING") color = AppColors.orangeColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _buildEndTrackingForm(String visitId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.redColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cancel_outlined, color: AppColors.redColor, size: 18),
              const SizedBox(width: 8),
              const Text(
                "End Tracking",
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.redColor, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text("Fill all required fields below, then click End Tracking at the top.", style: TextStyle(fontSize: 12, color: AppColors.gray500)),
          const SizedBox(height: 20),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabelledField(
                  "SERVICE RECEIVED BY *",
                  controller.serviceReceivedByController.value,
                  hint: "Enter name",
                  errorText: controller.serviceReceivedByError.value,
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "CONTACT NUMBER *",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gray600),
                    ),
                    const SizedBox(height: 6),
                    IntlPhoneField(
                      controller: controller.contactNumberController.value,
                      initialCountryCode: 'IN',
                      style: const TextStyle(fontSize: 13),
                      dropdownTextStyle: const TextStyle(fontSize: 13),
                      flagsButtonPadding: const EdgeInsets.only(left: 8),
                      showDropdownIcon: false,
                      showCountryFlag: true,
                      onChanged: (phone) {
                        if (controller.contactNumberError.isNotEmpty) {
                          controller.contactNumberError.value = "";
                        }
                        controller.siteReceiverMobileCountryCode.value = phone.countryCode;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter number",
                        hintStyle: const TextStyle(fontSize: 12, color: AppColors.gray400),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        errorText: controller.contactNumberError.value.isNotEmpty ? controller.contactNumberError.value : null,
                        errorStyle: const TextStyle(fontSize: 10, color: AppColors.redColor),
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: controller.contactNumberError.value.isNotEmpty ? AppColors.redColor : AppColors.gray200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: controller.contactNumberError.value.isNotEmpty ? AppColors.redColor : AppColors.gray200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: controller.contactNumberError.value.isNotEmpty ? AppColors.redColor : AppColors.indigo600Main,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _formLabel("VISIT OUTCOME *"),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOutcomeOption("Close Visit", "Visit is fully resolved", "closed"),
                const SizedBox(height: 10),
                _buildOutcomeOption("Next Visit Required", "Issue needs follow-up visit", "next_visit_required"),
                if (controller.visitOutcomeError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(controller.visitOutcomeError.value, style: const TextStyle(color: AppColors.redColor, fontSize: 10)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabelledField(
                  "OVERALL REMARK *",
                  controller.overallRemarkController.value,
                  hint: "Summarize the work done and final status...",
                  maxLines: 3,
                  errorText: controller.overallRemarkError.value,
                ),
                const SizedBox(height: 20),
                _buildLabelledField(
                  "USAGE / CROWD NOTE *",
                  controller.finalUsageNoteController.value,
                  hint: "Describe usage conditions, crowd level, or site notes...",
                  maxLines: 3,
                  errorText: controller.finalUsageNoteError.value,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _formLabel("ATTACHMENTS *"),
          Obx(() {
            final bool isUploading = controller.isUploadingFinalAttachments.value;
            final String progressText = controller.finalAttachmentUploadProgress.value.isNotEmpty
                ? controller.finalAttachmentUploadProgress.value
                : "Uploading...";

            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border.all(color: isUploading ? AppColors.indigo600Main.withValues(alpha: 0.5) : AppColors.gray200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: isUploading ? null : () => _pickFinalFile(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isUploading ? AppColors.indigo50.withValues(alpha: 0.5) : AppColors.gray50,
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                            border: const Border(right: BorderSide(color: AppColors.gray200)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isUploading) ...[
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.indigo600Main),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                isUploading ? "Uploading..." : "Choose Files",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isUploading ? AppColors.indigo600Main : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: isUploading
                              ? Text(
                                  progressText,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.indigo600Main),
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Text(
                                  controller.finalAttachmentUrls.isNotEmpty
                                      ? "${controller.finalAttachmentUrls.length} files chosen"
                                      : "No file chosen",
                                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ),
                    ],
                  ),
                  if (isUploading) const LinearProgressIndicator(minHeight: 2.5, backgroundColor: AppColors.indigo50, color: AppColors.indigo600Main),
                ],
              ),
            );
          }),
          /* Obx(
            () => controller.finalAttachmentUrls.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text("At least one attachment is required", style: TextStyle(color: AppColors.redColor, fontSize: 11)),
                  )
                : const SizedBox.shrink(),
          ),*/
          const SizedBox(height: 12),
          Obx(
            () => controller.finalAttachmentUrls.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.gray100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Uploaded files (${controller.finalAttachmentUrls.length}):",
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          ...controller.finalAttachmentUrls.asMap().entries.map((entry) {
                            final index = entry.key;
                            final url = entry.value;
                            final fileName = url.split('/').last;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(color: AppColors.indigo50.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      fileName,
                                      style: const TextStyle(fontSize: 12, color: AppColors.indigo600Main, fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => controller.removeFinalAttachment(index),
                                    child: const Icon(Icons.close, size: 14, color: AppColors.red500),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelledField(
    String label,
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
  }) {
    final bool hasError = errorText != null && errorText.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gray600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: AppColors.gray400),
            contentPadding: const EdgeInsets.all(12),
            errorText: hasError ? errorText : null,
            errorStyle: const TextStyle(fontSize: 10, color: AppColors.redColor),
            suffixIcon: hasError ? const Icon(Icons.error_outline, color: AppColors.redColor, size: 18) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: hasError ? AppColors.redColor : AppColors.gray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: hasError ? AppColors.redColor : AppColors.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: hasError ? AppColors.redColor : AppColors.indigo600Main),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutcomeOption(String title, String subtitle, String value) {
    return Obx(() {
      final isSelected = controller.visitOutcome.value == value;
      final bool hasError = controller.visitOutcomeError.isNotEmpty;
      return InkWell(
        onTap: () {
          controller.visitOutcome.value = value;
          controller.visitOutcomeError.value = "";
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? AppColors.redColor : (hasError ? AppColors.redColor : AppColors.gray200)),
          ),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? AppColors.redColor : (hasError ? AppColors.redColor : AppColors.gray400), width: 2),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.redColor),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? AppColors.redColor : AppColors.textPrimary),
                  ),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.gray500)),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _pickFinalFile() async {
    ImagePickerUtils.showOptions(
      multiImage: true,
      onMultiImageSelected: (files) {
        controller.uploadFinalAttachments(files);
      },
      onImageSelected: (file) {
        controller.uploadFinalAttachments([file]);
      },
    );
  }

  Widget _buildSiteArrivalCard(FieldReportData data, String visitId) {
    final technicians = data.visitTechnicians ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.indigo600Main.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.location_on_outlined, size: 18, color: AppColors.green500Success),
              SizedBox(width: 8),
              Text(
                "Site Arrival",
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.green500Success),
              ),
            ],
          ),
          const SizedBox(height: 8),
          /*          const Text(
            "Each technician must mark Reached at Site with location and attachment before starting the visit.",
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),*/
          Wrap(spacing: 16, runSpacing: 16, children: [...technicians.map((tech) => _buildTechnicianArrivalCard(tech, visitId))]),
        ],
      ),
    );
  }

  Widget _buildTechnicianArrivalCard(VisitTechnician tech, String visitId) {
    final bool isReached = tech.reachedAt != null;
    final bool isCurrentUser = tech.isCurrentUser == true;

    return Container(
      width: Get.width > 600 ? (Get.width - 64 - 16) / 2 : double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isReached ? AppColors.green500Success.withValues(alpha: 0.02) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isReached ? AppColors.green500Success.withValues(alpha: 0.2) : AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(tech.name ?? "-", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(width: 10),
                    if (tech.isPrimary == true) ...[const SizedBox(height: 4), _primaryBadge()],
                  ],
                ),
              ),
            ],
          ),

          if (isReached) ...[
            const SizedBox(height: 12),
            _arrivalInfoItem(Icons.access_time, DateFormat('dd/MM/yyyy hh:mm a').format(tech.reachedAt!.toLocal()), isReached),
            const SizedBox(height: 8),
            _arrivalInfoItem(Icons.location_on_outlined, "${tech.reachedLatitude ?? '-'}, ${tech.reachedLongitude ?? '-'}", false),
            if (tech.reachedAttachments != null && tech.reachedAttachments.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tech.reachedAttachments!.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final url = entry.value;
                  return OutlinedButton.icon(
                    onPressed: () => _launchURL(url),
                    icon: const Icon(Icons.open_in_new, size: 14),
                    label: Text("View $index", style: const TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.indigo600Main,
                      side: const BorderSide(color: AppColors.indigo600Main),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ] else if (isCurrentUser && tech.canReachAtSite == true) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.isLocationChecking.value
                      ? null
                      : () async {
                          final bool isLocationReady = await controller.checkAndRequestLocation();
                          if (isLocationReady) {
                            _showArrivalDialog(visitId);
                          }
                        },
                  icon: controller.isLocationChecking.value
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.location_on_outlined, size: 18),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green500Success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  label: controller.isLocationChecking.value
                      ? const Text("Checking location...", style: TextStyle(fontWeight: FontWeight.bold))
                      : const Text("Reached at Site", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showArrivalDialog(String visitId) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: Get.width * 0.95,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Reached at Site", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1, color: AppColors.gray200),
              ),
              const Text(
                "Your current location will be recorded. Upload at least one photo or document as proof of site arrival.",
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              const Text("Attachments *", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Obx(() {
                final bool isUploading = controller.isUploadingSiteArrivalAttachments.value;
                final String progressText = controller.siteArrivalUploadProgress.value.isNotEmpty
                    ? controller.siteArrivalUploadProgress.value
                    : "Uploading...";

                return Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    border: Border.all(color: isUploading ? AppColors.indigo600Main.withValues(alpha: 0.5) : AppColors.gray300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: InkWell(
                              onTap: isUploading ? null : () => _pickSiteArrivalFile(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isUploading ? AppColors.indigo50.withValues(alpha: 0.5) : Colors.transparent,
                                  border: const Border(right: BorderSide(color: AppColors.gray300)),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isUploading) ...[
                                        const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.indigo600Main),
                                        ),
                                        const SizedBox(width: 6),
                                      ],
                                      Text(
                                        isUploading ? "Uploading..." : "Choose Files",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isUploading ? AppColors.indigo600Main : AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: isUploading
                                  ? Text(
                                      progressText,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.indigo600Main),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(
                                      controller.siteArrivalAttachmentUrls.isNotEmpty
                                          ? "${controller.siteArrivalAttachmentUrls.length} files chosen"
                                          : "No file chosen",
                                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      if (isUploading)
                        const LinearProgressIndicator(minHeight: 2.5, backgroundColor: AppColors.indigo50, color: AppColors.indigo600Main),
                    ],
                  ),
                );
              }),
              Obx(() {
                if (controller.siteArrivalAttachmentUrls.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: controller.siteArrivalAttachmentUrls.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.description_outlined, size: 16, color: AppColors.indigo600Main),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.value.split('/').last,
                                  style: const TextStyle(fontSize: 12, color: AppColors.indigo600Main),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.removeSiteArrivalAttachment(entry.key),
                                child: const Icon(Icons.close, size: 16, color: AppColors.red500),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.gray300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                                if (controller.siteArrivalAttachmentUrls.isEmpty) {
                                  toastMessage(text: "Please upload at least one attachment");
                                  return;
                                }
                                await controller.reachVisit(visitId);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green500Success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text(
                                "Reached",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickSiteArrivalFile() async {
    ImagePickerUtils.showOptions(
      multiImage: true,
      onMultiImageSelected: (files) {
        controller.uploadSiteArrivalAttachments(files);
      },
      onImageSelected: (file) {
        controller.uploadSiteArrivalAttachments([file]);
      },
    );
  }

  Widget _arrivalInfoItem(IconData icon, String text, bool isReached) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.gray500),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        Spacer(),
        if (isReached) _statusBadgeSmall(isReached ? "Reached" : "Pending", isReached),
      ],
    );
  }

  Widget _statusBadgeSmall(String text, bool isSuccess) {
    final Color color = isSuccess ? AppColors.green500Success : AppColors.gray500;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _primaryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
      child: const Text(
        "Primary",
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      toastMessage(text: "Could not launch $url");
    }
  }

  void _showEndVisitConfirmation(String visitId) {
    Get.dialog(
      Obx(
        () => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("End Visit", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Are you sure you want to end this visit tracking? This will submit your final report and stop the timer."),
          actions: [
            TextButton(
              onPressed: controller.isLoading.value ? null : () => Get.back(),
              style: TextButton.styleFrom(foregroundColor: AppColors.gray500),
              child: controller.isLoading.value
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gray400))
                  : const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () async {
                      await controller.stopVisit(visitId);
                      if (!controller.isLoading.value && (Get.isDialogOpen ?? false)) {
                        Get.back();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: controller.isLoading.value
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text("End Visit", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
