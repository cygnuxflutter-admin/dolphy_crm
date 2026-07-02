import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_text_style.dart';
import '../../../widget/dropdown.dart';
import '../visit_controller.dart';

class AddProductToVisitDialog extends GetView<VisitController> {
  final String visitId;
  const AddProductToVisitDialog({super.key, required this.visitId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Add Product to Visit", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: const Text(
                  "This product will be added only to this visit. Warranty type and repeat service status can be set later when syncing to the complaint from Complaint Tracker.",
                  style: TextStyle(fontSize: 12, color: AppColors.gray600),
                ),
              ),
              const SizedBox(height: 20),
              _buildLabel("Tax Invoice"),
              CustomDropdown<dynamic>(
                hintText: "Search tax invoice no...",
                compareFn: (item1, item2) => item1?['id'] == item2?['id'],
                items: (filter, loadProps) async {
                  await controller.searchTaxInvoices(filter);
                  return controller.taxInvoices;
                },
                itemAsString: (item) => item['invoice_no'] ?? "-",
                selectedItem: controller.selectedTaxInvoice.value,
                onChanged: (value) {
                  controller.selectedTaxInvoice.value = value;
                  controller.selectedProduct.value = null; // Clean selected product
                  if (value != null) {
                    if (value['invoice_no'] != null) {
                      controller.taxInvoiceNoController.value.text = value['invoice_no'];
                    }
                    controller.getInvoiceItems(value['id']);
                  } else {
                    controller.taxInvoiceNoController.value.clear();
                    controller.invoiceProducts.clear();
                    controller.searchProducts(""); // Show all general products
                  }
                },
                padding: 0,
              ),
              const SizedBox(height: 16),
              _buildTextField(label: "Tax Invoice No", controller: controller.taxInvoiceNoController.value, hint: "Tax invoice no..."),
              const SizedBox(height: 16),
              _buildLabel("Product", isRequired: true),
              CustomDropdown<dynamic>(
                hintText: "Select tax invoice or search product...",
                compareFn: (item1, item2) => item1?['id'] == item2?['id'],
                infiniteScrollProps: const InfiniteScrollProps(loadProps: LoadProps(take: 20)),
                items: (filter, loadProps) async {
                  int page = 1;
                  if (loadProps != null && loadProps.take > 0) {
                    page = (loadProps.skip ~/ loadProps.take) + 1;
                  }
                  return await controller.searchProducts(filter, page: page, limit: loadProps?.take ?? 20);
                },
                itemAsString: (item) => "[${item['product_code']}] ${item['product_name']}",
                selectedItem: controller.selectedProduct.value,
                onChanged: (value) => controller.selectedProduct.value = value,
                padding: 0,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Complaint Qty",
                isRequired: true,
                controller: controller.complaintQtyController.value,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(label: "Installed Qty", controller: controller.installedQtyController.value, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(label: "Client Side Qty", controller: controller.clientSideQtyController.value, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Issue Description",
                isRequired: true,
                controller: controller.issueDescriptionController.value,
                hint: "Describe the issue...",
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Usage / Crowd Note",
                controller: controller.usageCrowdNoteController.value,
                hint: "Usage / crowd note...",
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: const Text("Cancel", style: TextStyle(color: AppColors.textPrimary)),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => ElevatedButton(
                      onPressed: controller.isAddProductLoading.value ? null : () => controller.addProductToVisit(visitId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.indigo600Main,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: controller.isAddProductLoading.value
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text("Add to Visit"),
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

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          children: isRequired
              ? [
                  const TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    bool isRequired = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired: isRequired),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint ?? label,
            hintStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.gray400),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.indigo600Main, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
