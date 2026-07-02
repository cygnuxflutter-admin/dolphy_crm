import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_shared_pref.dart';
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
        final bool canAddProduct = (data.status?.toUpperCase() != "CANCELLED") &&
            ((data.createdBy == currentUserId) || (data.technicians?.any((t) => t.id == currentUserId && t.isPrimary == true) ?? false));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(data),
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
                ...data.products!.asMap().entries.map((entry) => _buildProductItem(entry.key + 1, entry.value)).toList()
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text("No products added to this report", style: TextStyle(color: AppColors.gray500)),
                  ),
                ),
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

  Widget _buildTopHeader(FieldReportData data) {
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
                  "ACTIVE DURATION",
                  style: TextStyle(fontSize: 10, color: AppColors.gray500, fontWeight: FontWeight.bold),
                ),
                const Text("00:04:39", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _statusBadge(data.statusName ?? data.status ?? "Pending"),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.green500Success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.green500Success.withOpacity(0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.check_circle, size: 14, color: AppColors.green500Success),
                  SizedBox(width: 6),
                  Text(
                    "Ended",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.green500Success),
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
        border: Border.all(color: AppColors.indigo600Main.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
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
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _formLabelWithIcon(Icons.qr_code, "Serial Numbers"),
        const SizedBox(height: 8),
        ...List.generate(
          p.serialNumbers?.length ?? 0,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(4)),
                  child: Text("${i + 1}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: p.serialNumbers![i],
                    style: const TextStyle(fontSize: 13),
                    onChanged: (val) => controller.updateSerialNumber(p.id ?? "", i, val),
                    decoration: InputDecoration(
                      hintText: "Enter serial number",
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
                ),
              ],
            ),
          ),
        ),
        if (p.serialNumbers == null || p.serialNumbers!.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.gray200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text("No serial numbers entered", style: TextStyle(fontSize: 13, color: AppColors.gray400)),
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
                initialValue: value,
                keyboardType: TextInputType.number,
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
                    final url = entry.value;
                    final fileName = url.split('/').last;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.indigo50.withOpacity(0.5), borderRadius: BorderRadius.circular(6)),
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
                onPressed: () {},
                icon: const Icon(Icons.add, size: 14),
                label: const Text("Add Part", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
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

  Widget _statusBadge(String status) {
    Color color = AppColors.gray500;
    if (status.toUpperCase() == "COMPLETED") color = AppColors.green500Success;
    if (status.toUpperCase() == "PENDING") color = AppColors.orangeColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
