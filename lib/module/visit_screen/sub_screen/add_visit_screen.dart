import 'package:crm/config/app_colors.dart';
import 'package:crm/module/lead_screen/model/get_assign_partner.dart';
import 'package:crm/module/lead_screen/model/lead_type.dart';
import 'package:crm/module/visit_screen/add_visit_controller.dart';
import 'package:crm/widget/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddVisitScreen extends GetView<AddVisitController> {
  const AddVisitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.indigo600Main,
        title: Obx(
          () => Text(
            controller.isEdit.value ? "Edit Visit" : "Add Visit",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildFormCard(), const SizedBox(height: 20), _buildProductTable(), const SizedBox(height: 30), _buildActionButtons()],
                ),
              ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Obx(() => _buildComplaintDropdown()),
          _buildTextField("Customer Name", controller.customerNameController.value, readOnly: true),
          const SizedBox(height: 16),
          _buildDateTimePicker("Visit Start Date & Time *", controller.startDateController.value),
          const SizedBox(height: 16),
          _buildDateTimePicker("Visit End Date & Time *", controller.endDateController.value),
          const SizedBox(height: 16),
          Obx(() => _buildPurposeDropdown()),
          _buildTextField("Customer Mobile *", controller.mobileController.value, readOnly: true),
          const SizedBox(height: 16),
          _buildTextField("Contact Person", controller.contactPersonController.value, readOnly: true),
          const SizedBox(height: 16),
          Obx(() => _buildPrimaryTechnicianDropdown()),
          Obx(() => _buildTechniciansDropdown()),
          _buildTextField("Address", controller.addressController.value, maxLines: 3, readOnly: true),
          const SizedBox(height: 16),
          _buildTextField("Remark", controller.remarkController.value, maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildComplaintDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Complaint No. *",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.gray600),
        ),
        const SizedBox(height: 8),
        CustomDropdown<dynamic>(
          hintText: "Search complaint no, customer...",
          items: (filter, props) async {
            await controller.getComplaints(filter);
            return controller.complaintList;
          },
          itemAsString: (dynamic item) => item['complaint_no'] ?? "",
          onChanged: (val) => controller.onComplaintSelected(val),
          selectedItem: controller.selectedComplaint.value,
          compareFn: (item, selectedItem) => item?['id'] == selectedItem?['id'],
          showSearchBox: true,
        ),
      ],
    );
  }

  Widget _buildPurposeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Visit Purpose *",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.gray600),
        ),
        const SizedBox(height: 8),
        CustomDropdown<LeadItem>(
          hintText: "Select purpose...",
          items: (filter, props) async => controller.visitPurposeList,
          itemAsString: (item) => item.name,
          onChanged: (val) => controller.selectedVisitPurpose.value = val,
          selectedItem: controller.selectedVisitPurpose.value,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          showSearchBox: false,
        ),
      ],
    );
  }

  Widget _buildPrimaryTechnicianDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Primary Technician *",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.gray600),
        ),
        const SizedBox(height: 8),
        CustomDropdown<AssignSalesPerson>(
          hintText: "Select primary technician...",
          items: (filter, props) async {
            await controller.getTechnicians(search: filter);
            return controller.technicianList;
          },
          itemAsString: (item) => "${item.firstName} ${item.lastName}",
          onChanged: (val) => controller.onPrimaryTechnicianSelected(val),
          selectedItem: controller.selectedPrimaryTechnician.value,
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          showSearchBox: true,
        ),
      ],
    );
  }

  Widget _buildTechniciansDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Technician *",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.gray600),
        ),
        const SizedBox(height: 8),
        CustomMultiDropdownSearch<AssignSalesPerson>(
          hintText: "Search user...",
          items: (filter, props) async {
            await controller.getTechnicians(search: filter);
            return controller.technicianList;
          },
          itemAsString: (item) => "${item.firstName} ${item.lastName}",
          selectedItems: controller.selectedTechnicians.toList(),
          onChanged: (List<AssignSalesPerson> selected) {
            controller.selectedTechnicians.assignAll(selected);
            // logic: if primary technician is not in the list, clear it
            if (controller.selectedPrimaryTechnician.value != null && !selected.any((e) => e.id == controller.selectedPrimaryTechnician.value?.id)) {
              controller.selectedPrimaryTechnician.value = null;
            }
          },
          compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
          showSearchBox: true,
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController textController, {int maxLines = 1, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.gray600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textController,
          maxLines: maxLines,
          readOnly: readOnly,
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration(label),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(String label, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.gray600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textController,
          readOnly: true,
          style: const TextStyle(fontSize: 13),
          decoration: _inputDecoration(
            "Select date & time",
          ).copyWith(suffixIcon: const Icon(Icons.calendar_today, size: 18, color: AppColors.gray400)),
          onTap: () => controller.selectDateTime(Get.context!, textController),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 13),
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
    );
  }

  Widget _buildProductTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            const Text(
              "Product Complaint Details",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            if (controller.complaintProducts.isNotEmpty)
              const Text("Products copied from linked complaint", style: TextStyle(fontSize: 10, color: AppColors.gray500)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray200),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.gray50),
              dataRowMaxHeight: 100, // Increased to accommodate multi-line product names and images
              dataRowMinHeight: 70,
              columns: const [
                DataColumn(
                  label: Text("#", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text("Image", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text("Product", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text("Tax Invoice No", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text("Warranty Type", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text("Repeat Service Status", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text("Complaint Qty", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text("Installed Qty", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text("Usage / Crowd Note", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                DataColumn(
                  label: Text("Issue Description", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
              rows: controller.complaintProducts.asMap().entries.map((entry) {
                final index = entry.key;
                final p = entry.value;
                return DataRow(
                  cells: [
                    DataCell(Text("${index + 1}")),
                    DataCell(
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(4)),
                        child: p.productImage.isNotEmpty
                            ? Image.network(
                                "https://tradeapi.cygnux.in${p.productImage}",
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 20, color: AppColors.gray400),
                              )
                            : const Icon(Icons.image, size: 20, color: AppColors.gray400),
                      ),
                    ),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Text(
                              p.productName,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(p.productCode, style: const TextStyle(fontSize: 10, color: AppColors.gray500)),
                        ],
                      ),
                    ),
                    DataCell(Text(p.taxInvoiceNo.isEmpty ? "-" : p.taxInvoiceNo)),
                    DataCell(Text(p.warrantyTypeName)),
                    DataCell(Text(p.repeatServiceStatus?.replaceAll('_', ' ').capitalizeFirst ?? "-")),
                    DataCell(Text("${p.complaintQty}")),
                    DataCell(Text("${p.installedQty}")),
                    DataCell(Text(p.usageNote.isEmpty ? "-" : p.usageNote)),
                    DataCell(Text(p.issueDescription.isEmpty ? "-" : p.issueDescription)),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        if (controller.complaintProducts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text("No products found for selected complaint", style: TextStyle(color: AppColors.gray500)),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        OutlinedButton(
          onPressed: () => Get.back(),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.red500),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(color: AppColors.red500, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () => controller.submitVisit(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.indigo600Main,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
