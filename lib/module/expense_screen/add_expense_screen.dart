import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_text_style.dart';
import '../../../widget/dropdown.dart';
import '../visit_screen/model/visit_model.dart';
import 'expense_controller.dart';

class AddExpenseScreen extends GetView<ExpenseController> {
  const AddExpenseScreen({super.key});

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
          "Add Expense",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVisitSelectSection(context),
              const SizedBox(height: 20),
              if (controller.selectedVisits.isNotEmpty) ...[_buildSelectedVisitDetails(), const SizedBox(height: 24)],
              _buildGeneralInfoSection(context),
              const SizedBox(height: 24),
              _buildExpenseLinesSection(context),
              const SizedBox(height: 32),
              _buildBottomButtons(),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildVisitSelectSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Visit Select ",
            style: AppTextStyle.bold.copyWith(fontSize: 14, color: AppColors.textPrimary),
            children: [
              TextSpan(
                text: "(Search by Visit, Complaint, Customer, or Complaint Taker)",
                style: AppTextStyle.regular.copyWith(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "All visits can be selected. Only visits with the same complaint taker as the first selected visit are allowed. Submit requires every selected visit to be completed.",
          style: AppTextStyle.regular.copyWith(fontSize: 11, color: AppColors.gray500),
        ),
        const SizedBox(height: 12),
        CustomMultiDropdownSearch<VisitDatum>(
          hintText: "Select Visit",
          items: (filter, loadProps) => controller.searchVisits(filter),
          selectedItems: controller.selectedVisits,
          itemAsString: (VisitDatum visit) => "${visit.visitNo} - ${visit.customerName} - ${visit.complaintTakerName}",
          compareFn: (i, s) => i?.id == s?.id,
          disabledItemFn: (VisitDatum visit) {
            if (controller.selectedVisits.isNotEmpty) {
              final firstComplaintTakerId = controller.selectedVisits.first.complaintTakerId;
              return visit.complaintTakerId != firstComplaintTakerId;
            }
            return false;
          },
          onChanged: (value) {
            controller.selectedVisits.assignAll(value);
          },
        ),
      ],
    );
  }

  Widget _buildSelectedVisitDetails() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.indigo600Main.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.assignment_outlined, size: 18, color: AppColors.indigo600Main),
                const SizedBox(width: 8),
                Text("Selected Visit Details", style: AppTextStyle.bold.copyWith(color: AppColors.indigo600Main)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.indigo50, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    "${controller.selectedVisits.length} visit",
                    style: AppTextStyle.bold.copyWith(fontSize: 10, color: AppColors.indigo600Main),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.selectedVisits.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final visit = controller.selectedVisits[index];
              return Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _detailItem("VISIT NO.", visit.visitNo ?? "-"),
                      const SizedBox(width: 24),
                      _detailItem("COMPLAINT NO.", visit.complaintNo ?? "-"),
                      const SizedBox(width: 24),
                      _detailItem("CUSTOMER", visit.customerName ?? "-"),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "STATUS",
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.gray500),
                          ),
                          const SizedBox(height: 4),
                          _statusBadge(visit.statusName ?? visit.status ?? "Pending"),
                        ],
                      ),
                      const SizedBox(width: 24),
                      _detailItem("COMPLAINT TAKER", visit.complaintTakerName ?? "-"),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.gray500),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildGeneralInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Expense Date *"),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Text(DateFormat('yyyy-MM-dd').format(controller.expenseDate.value), style: AppTextStyle.regular.copyWith(fontSize: 14)),
                    const Spacer(),
                    const Icon(Icons.calendar_today, size: 16, color: AppColors.gray400),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Attachments"),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => _pickOverallFiles(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: const BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                        border: Border(right: BorderSide(color: AppColors.border)),
                      ),
                      child: Text("Choose Files", style: AppTextStyle.bold.copyWith(fontSize: 13)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        controller.overallAttachments.isEmpty ? "No file chosen" : "${controller.overallAttachments.length} files chosen",
                        style: AppTextStyle.regular.copyWith(fontSize: 13, color: AppColors.gray500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Remarks"),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.remarksController,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: "Enter remarks",
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpenseLinesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Expense Lines", style: AppTextStyle.bold.copyWith(fontSize: 14)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExpenseHeader(),
                ...List.generate(controller.expenseLines.length, (index) => _buildExpenseRow(index)),
                _buildExpenseFooter(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () => controller.addExpenseLine(),
            icon: const Icon(Icons.add, size: 16),
            label: const Text("Add Expense Line (+)"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.indigo600Main,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseHeader() {
    return Container(
      color: AppColors.gray50,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _headerCell("No.", width: 40),
          _headerCell("Technician Expense Type", width: 180),
          _headerCell("Other / Travel Detail", width: 180),
          _headerCell("Request Amount", width: 120),
          _headerCell("Paid By Client", width: 150),
          _headerCell("Description", width: 200),
          _headerCell("Attachments", width: 180),
          _headerCell("", width: 40),
        ],
      ),
    );
  }

  Widget _headerCell(String label, {double? width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gray600),
      ),
    );
  }

  Widget _buildExpenseRow(int index) {
    final line = controller.expenseLines[index];
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(width: 40, alignment: Alignment.center, child: Text("${index + 1}")),
          Container(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Obx(
              () => CustomDropdown<String>(
                hintText: "Select type",
                items: (filter, loadProps) => controller.expenseTypes,
                itemAsString: (item) => item,
                selectedItem: line.expenseType.value,
                padding: 0,
                onChanged: (val) => line.expenseType.value = val,
              ),
            ),
          ),
          Container(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              controller: line.otherDetailController,
              decoration: _inputDecoration("Other detail"),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Container(
            width: 120,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              controller: line.requestAmountController,
              keyboardType: TextInputType.number,
              onChanged: (_) => controller.expenseLines.refresh(),
              decoration: _inputDecoration("0.00"),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Container(
            width: 150,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: line.paidByClient.value,
                        onChanged: (val) {
                          line.paidByClient.value = val ?? false;
                          controller.expenseLines.refresh();
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const Text("Yes", style: TextStyle(fontSize: 11)),
                  ],
                ),
                Obx(
                  () => line.paidByClient.value
                      ? TextFormField(
                          controller: line.clientAmountController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => controller.expenseLines.refresh(),
                          decoration: _inputDecoration("Client Amount"),
                          style: const TextStyle(fontSize: 12),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextFormField(
              controller: line.descriptionController,
              maxLines: 2,
              decoration: _inputDecoration("Description"),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Container(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => _pickLineFiles(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(4)),
                      child: const Text("Choose Files", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Obx(
                        () => Text(
                          line.attachments.isEmpty ? "No file chosen" : "${line.attachments.length} files",
                          style: const TextStyle(fontSize: 10, color: AppColors.gray500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.red500, size: 20),
              onPressed: () => controller.removeExpenseLine(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseFooter() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.gray50,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 400), // Offset to Total column
              _headerCell("Total", width: 100),
              Container(
                width: 120,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Obx(() => Text(controller.totalRequestAmount.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 150),
              Obx(
                () => Text(
                  controller.totalPaidByClient > 0 ? controller.totalPaidByClient.toStringAsFixed(2) : "-",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 150),
              Text(
                "Net Expense Total (Request Amount - Paid by Client)",
                style: AppTextStyle.bold.copyWith(color: AppColors.indigo600Main, fontSize: 13),
              ),
              const SizedBox(width: 20),
              Obx(
                () => Text(
                  controller.netExpenseTotal.toStringAsFixed(2),
                  style: AppTextStyle.bold.copyWith(color: AppColors.indigo600Main, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
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
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.submitExpense(isDraft: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gray600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text("Save Draft", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.submitExpense(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.indigo600Main,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text("Submit", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.indigo600Main),
      ),
    );
  }

  Widget _label(String text) {
    return Text(text, style: AppTextStyle.bold.copyWith(fontSize: 12, color: AppColors.textPrimary));
  }

  Widget _statusBadge(String status) {
    Color color = AppColors.gray500;
    if (status.toUpperCase() == "COMPLETED") color = AppColors.green500Success;
    if (status.toUpperCase() == "PENDING") color = AppColors.orangeColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.expenseDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != controller.expenseDate.value) {
      controller.expenseDate.value = picked;
    }
  }

  Future<void> _pickOverallFiles() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      controller.overallAttachments.addAll(images.map((img) => File(img.path)));
    }
  }

  Future<void> _pickLineFiles(int index) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      controller.expenseLines[index].attachments.addAll(images.map((img) => File(img.path)));
    }
  }
}
