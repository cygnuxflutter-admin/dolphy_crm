import 'package:crm/config/app_colors.dart';
import 'package:crm/module/lead_screen/model/lead_type.dart';
import 'package:crm/module/visit_screen/visit_controller.dart';
import 'package:crm/widget/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SyncToComplaintDialog extends GetView<VisitController> {
  final String visitId;
  const SyncToComplaintDialog({super.key, required this.visitId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Divider(height: 1),
            Expanded(
              child: Obx(() {
                if (controller.isSyncPreviewLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.syncPreviewData.value == null) {
                  return const Center(
                    child: Text("No sync data available", style: TextStyle(color: AppColors.textSecondary)),
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*const Text(
                        "Review visit-added products below and complete warranty details before syncing them into the linked complaint.",
                        style: TextStyle(fontSize: 12, color: AppColors.gray500),
                      ),
                      const SizedBox(height: 16),*/
                      _buildInfoSection(),
                      const SizedBox(height: 16),
                      ...controller.syncPreviewData.value!.products.asMap().entries.map((entry) {
                        return _buildProductCard(entry.value, entry.key + 1);
                      }),
                    ],
                  ),
                );
              }),
            ),
            const Divider(height: 1),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Sync Visit Products to Complaint",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, size: 20, color: AppColors.gray400),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    final data = controller.syncPreviewData.value!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray200, width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(child: _infoItem("COMPLAINT NO.", data.complaint.complaintNo)),
          Expanded(child: _infoItem("VISIT NO.", data.visit.visitNo)),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gray400),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildProductCard(dynamic product, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.gray200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.indigo600Main),
                    const SizedBox(width: 8),
                    Text(
                      "Product $index",
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                if (product.needsComplaintSync == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.orangeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                    child: const Text(
                      "Update Complaint Qty",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.orangeColor),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel("Product"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.gray200),
                  ),
                  child: Text(
                    "[${product.productCode}] - ${product.productName}",
                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: 12),
                _buildFieldLabel("Tax Invoice No"),
                _buildTextField(
                  initialValue: product.taxInvoiceNo,
                  onChanged: (val) {
                    product.taxInvoiceNo = val;
                    controller.syncPreviewData.refresh();
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("Complaint Qty *"),
                          _buildTextField(
                            initialValue: "${product.complaintQty}",
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              product.complaintQty = int.tryParse(val) ?? 0;
                              controller.syncPreviewData.refresh();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("Installed Qty"),
                          _buildTextField(
                            initialValue: "${product.installedQty}",
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              product.installedQty = int.tryParse(val) ?? 0;
                              controller.syncPreviewData.refresh();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildFieldLabel("Warranty Type *"),
                CustomDropdown<LeadItem>(
                  hintText: "Select...",
                  padding: 0,
                  items: (filter, props) async => controller.warrantyTypeList,
                  itemAsString: (item) => item.name,
                  selectedItem: controller.warrantyTypeList.firstWhereOrNull((e) => e.id == product.warrantyType),
                  onChanged: (val) {
                    product.warrantyType = val?.id;
                    controller.syncPreviewData.refresh();
                  },
                  compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
                  showSearchBox: false,
                ),
                const SizedBox(height: 12),
                _buildFieldLabel("Repeat Service Status *"),
                CustomDropdown<Map<String, String>>(
                  hintText: "Select...",
                  padding: 0,
                  items: (filter, props) async => controller.repeatServiceStatusList,
                  itemAsString: (item) => item['name'] ?? "",
                  selectedItem: controller.repeatServiceStatusList.firstWhereOrNull((e) => e['id'] == product.repeatServiceStatus),
                  onChanged: (val) {
                    product.repeatServiceStatus = val?['id'];
                    controller.syncPreviewData.refresh();
                  },
                  compareFn: (item, selectedItem) => item?['id'] == selectedItem?['id'],
                  showSearchBox: false,
                ),
                const SizedBox(height: 12),
                _buildFieldLabel("Issue Description *"),
                _buildTextField(
                  initialValue: product.issueDescription,
                  maxLines: 2,
                  onChanged: (val) {
                    product.issueDescription = val;
                    controller.syncPreviewData.refresh();
                  },
                ),
                const SizedBox(height: 12),
                _buildFieldLabel("Usage / Crowd Note"),
                _buildTextField(
                  initialValue: product.usageNote,
                  maxLines: 2,
                  onChanged: (val) {
                    product.usageNote = val;
                    controller.syncPreviewData.refresh();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildTextField({String? initialValue, TextInputType? keyboardType, int maxLines = 1, required Function(String) onChanged}) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
      onChanged: onChanged,
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.gray300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Cancel", style: TextStyle(color: AppColors.textPrimary)),
          ),
          const SizedBox(width: 12),
          Obx(
            () => ElevatedButton.icon(
              onPressed: controller.isSyncing.value ? null : () => controller.performSync(visitId),
              icon: controller.isSyncing.value
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.sync, size: 16, color: Colors.white),
              label: const Text("Sync to Complaint", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.indigo600Main,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
