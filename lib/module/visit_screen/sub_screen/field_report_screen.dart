import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_shared_pref.dart';
import '../../../widget/dropdown.dart';
import '../model/dispatched_serial_model.dart';
import '../model/field_report_model.dart';
import '../visit_controller.dart';
import '../widget/add_product_to_visit_dialog.dart';

class FieldReportScreen extends GetView<VisitController> {
  const FieldReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String visitId = Get.arguments ?? "";
    if (visitId.isNotEmpty) {
      controller.getFieldReport(visitId);
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
        title: const Text(
          "Field Service Report",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
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

        final currentUserId = Pref.getUserId();
        final bool canAddProduct =
            (data.status?.toUpperCase() != "CANCELLED") &&
            ((data.createdBy == currentUserId) || (data.technicians?.any((t) => t.id == currentUserId && t.isPrimary == true) ?? false));

        final currentUserTech = data.visitTechnicians?.firstWhereOrNull((t) => t.isCurrentUser == true);
        final String fieldStatus = currentUserTech?.fieldStatus?.toLowerCase() ?? "";
        final bool showEndButton = (fieldStatus == "started" || fieldStatus == "paused") && currentUserTech?.canStart == false;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(data, visitId),
              const SizedBox(height: 16),
              _buildVisitInfoCard(data),
              const SizedBox(height: 24),
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
              if (data.products != null && data.products!.isNotEmpty)
                ...data.products!.asMap().entries.map((entry) => _buildProductItem(entry.key + 1, entry.value))
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text("No products added to this report", style: TextStyle(color: AppColors.gray500)),
                  ),
                ),
              if (showEndButton) ...[const SizedBox(height: 24), _buildEndTrackingForm(visitId)],
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.redColor,
                        side: const BorderSide(color: AppColors.redColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTopHeader(FieldReportData data, String visitId) {
    final currentUserTech = data.visitTechnicians?.firstWhereOrNull((t) => t.isCurrentUser == true);
    final String status = currentUserTech?.fieldStatus?.toLowerCase() ?? "";

    final bool showStartButton = currentUserTech != null && status == "assigned" && currentUserTech.canStart == true;
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
                    "${data.visitNo ?? ''}  Complaint ${data.complaintNo ?? ''}",
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
        const SizedBox(height: 12),
        Row(
          children: [
            _statusBadge(data.statusName ?? data.status ?? "Pending"),
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
                    onPressed: controller.isLoading.value ? null : () => controller.stopVisit(visitId),
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
                    onPressed: controller.isLoading.value ? null : () => controller.stopVisit(visitId),
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
                  color: (currentUserTech?.fieldStatus?.toLowerCase() == "completed" ? AppColors.green500Success : AppColors.orangeColor).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (currentUserTech?.fieldStatus?.toLowerCase() == "completed" ? AppColors.green500Success : AppColors.orangeColor)
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      currentUserTech?.fieldStatus?.toLowerCase() == "completed" ? Icons.check_circle : Icons.watch_later_outlined,
                      size: 14,
                      color: currentUserTech?.fieldStatus?.toLowerCase() == "completed" ? AppColors.green500Success : AppColors.orangeColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      (currentUserTech?.fieldStatus ?? "PENDING").toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: currentUserTech?.fieldStatus?.toLowerCase() == "completed" ? AppColors.green500Success : AppColors.orangeColor,
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
              Icon(Icons.assignment_outlined, size: 18, color: AppColors.indigo600Main),
              SizedBox(width: 8),
              Text(
                "Visit Info",
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.gray100),
          ),
          _buildResponsiveInfoGrid([
            _infoItem("VISIT NO.", data.visitNo ?? "-"),
            _infoItem("COMPLAINT NO.", data.complaintNo ?? "-"),
            _infoItem("CUSTOMER", data.customerName ?? "-"),
            _infoItem("STATUS", data.statusName ?? "-"),
            _infoItem("VISIT PURPOSE", data.visitPurposeName ?? "-"),
            _infoItem(
              "VISIT START DATE & TIME",
              data.visitStartDatetime != null ? DateFormat('dd/MM/yyyy hh:mm a').format(data.visitStartDatetime!) : "-",
            ),
            _infoItem("VISIT END DATE & TIME", data.visitEndDatetime != null ? DateFormat('dd/MM/yyyy hh:mm a').format(data.visitEndDatetime!) : "-"),
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
          padding: const EdgeInsets.only(bottom: 16),
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

  Widget _infoItem(String label, String value) {
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
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
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
                                child: Text(
                                  p.productName ?? "-",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (p.productCode != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.indigo50, borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                    p.productCode!,
                                    style: const TextStyle(fontSize: 9, color: AppColors.indigo600Main, fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
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
                    const SizedBox(width: 8),
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
                    const SizedBox(height: 20),
                    _formLabel("ISSUE DESCRIPTION"),
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
                    const SizedBox(height: 20),
                    _buildSerialSection(p),
                    const SizedBox(height: 20),
                    _buildWorkAttachmentsSection(p),
                    const SizedBox(height: 20),
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

  Widget _productMainDetails(Product p) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.gray50, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PRODUCT",
            style: TextStyle(fontSize: 10, color: AppColors.gray500, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "[${p.productCode ?? ''}] ${p.productName ?? '-'}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.indigo600Main),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _iconText(Icons.receipt_outlined, "Tax Invoice: ${p.taxInvoiceNo ?? '-'}"),
              _iconText(Icons.receipt_outlined, "Tax Date: ${p.taxInvoiceDate ?? '-'}"),
              _iconText(Icons.verified_user_outlined, "Warranty: ${p.warrantyTypeName ?? '-'}"),
              _iconText(Icons.repeat_on_outlined, "Repeat: ${p.repeatServiceStatus ?? 'First Service'}"),
            ],
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formLabelWithIcon(Icons.qr_code, "Serial Number"),
        const SizedBox(height: 8),
        if (p.serialNumbers != null && p.serialNumbers!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: LayoutBuilder(
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
            ),
          )
        else
          InkWell(
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
                children: [
                  const Icon(Icons.add_circle_outline, size: 24, color: AppColors.gray400),
                  const SizedBox(height: 8),
                  const Text(
                    "No serial number entered",
                    style: TextStyle(fontSize: 13, color: AppColors.gray500, fontWeight: FontWeight.bold),
                  ),
                  const Text("Tap here to add serial number", style: TextStyle(fontSize: 11, color: AppColors.gray400)),
                ],
              ),
            ),
          ),
      ],
    );
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
              const SizedBox(width: 12),
              Expanded(child: _qtyField("Installed Qty", "${p.installedQty ?? 0}")),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _qtyField("Client Side Qty", "${p.clientSideQty ?? 0}")),
              const SizedBox(width: 12),
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
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gray600),
        ),
        const SizedBox(height: 6),
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
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.gray200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => _pickFile(p.id ?? ""),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.gray50,
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                      border: Border(right: BorderSide(color: AppColors.gray200)),
                    ),
                    child: const Text("Choose Files", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      p.attachments != null && p.attachments!.isNotEmpty ? "${p.attachments!.length} files chosen" : "No file chosen",
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
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

  Future<void> _pickFile(String productId) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        controller.uploadProductAttachment(productId, File(image.path));
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Widget _buildPartsRequiredSection(Product p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _formLabelWithIcon(Icons.settings_input_component_outlined, "Parts Required"),
              TextButton.icon(
                onPressed: () => controller.addPartRequest(p.id ?? ""),
                icon: const Icon(Icons.add, size: 14),
                label: const Text("Add Part", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (p.partRequests != null && p.partRequests!.isNotEmpty)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                children: [
                  ...p.partRequests!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final part = entry.value;
                    return Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border(bottom: index == p.partRequests!.length - 1 ? BorderSide.none : const BorderSide(color: AppColors.gray100)),
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
                              IconButton(
                                onPressed: () => controller.removePartRequest(p.id ?? "", index),
                                icon: const Icon(Icons.delete_outline, color: AppColors.redColor, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _formLabel("Part Name"),
                          CustomDropdown<dynamic>(
                            hintText: "Search part...",
                            items: (filter, loadProps) async => await controller.searchProducts(filter),
                            itemAsString: (item) => "[${item['product_code'] ?? ''}] ${item['product_name'] ?? '-'}",
                            selectedItem: part['product_id'] != null ? part : null,
                            compareFn: (i, s) => (i?['id'] ?? i?['product_id']) == (s?['id'] ?? s?['product_id']),
                            onChanged: (val) => controller.updatePartRequest(p.id ?? "", index, 'product', val),
                            showSearchBox: true,
                            padding: 0,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _formLabel("Qty"),
                                    TextFormField(
                                      initialValue: "${part['qty'] ?? 1}",
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
                                      initialValue: part['remark'] ?? "",
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
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Column(
                children: const [
                  Icon(Icons.inventory_2_outlined, color: AppColors.gray300, size: 40),
                  SizedBox(height: 12),
                  Text("No parts requested yet.", style: TextStyle(color: AppColors.gray400, fontSize: 13)),
                ],
              ),
            ),
        ],
      ),
    );
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

  int _calculateActiveSeconds(List<TrackingLog>? logs) {
    if (logs == null || logs.isEmpty) return 0;
    int totalSeconds = 0;
    DateTime? startTime;

    for (var log in logs) {
      final action = log.action?.toLowerCase();
      final time = log.createdAt;
      if (time == null) continue;

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
          Obx(
            () => Container(
              decoration: BoxDecoration(
                border: Border.all(color: controller.finalAttachmentUrls.isEmpty ? AppColors.redColor : AppColors.gray200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => _pickFinalFile(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                        border: Border(right: BorderSide(color: controller.finalAttachmentUrls.isEmpty ? AppColors.redColor : AppColors.gray200)),
                      ),
                      child: const Text("Choose Files", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        controller.finalAttachmentUrls.isNotEmpty ? "${controller.finalAttachmentUrls.length} files chosen" : "No file chosen",
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => controller.finalAttachmentUrls.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text("At least one attachment is required", style: TextStyle(color: AppColors.redColor, fontSize: 11)),
                  )
                : const SizedBox.shrink(),
          ),
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
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        controller.uploadFinalAttachment(File(image.path));
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }
}
