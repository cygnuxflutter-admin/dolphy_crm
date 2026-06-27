import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../visit_controller.dart';

class VisitViewScreen extends GetView<VisitController> {
  const VisitViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String visitId = Get.arguments ?? "";
    if (visitId.isNotEmpty) {
      controller.getVisitDetail(visitId);
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
          "Visit Details",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
      ),
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.detailError.isNotEmpty) {
          return Center(child: Text(controller.detailError.value));
        }
        final data = controller.visitDetail.value;
        if (data == null) {
          return const Center(child: Text("No Data Found"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(data),
              const SizedBox(height: 16),
              _buildSectionTitle("Customer & Contact Information"),
              _buildInfoCard([
                _infoTile(Icons.person_outline, "Customer", data.customerName ?? "-"),
                _infoTile(Icons.location_on_outlined, "Address", data.address ?? "-"),
                _infoTile(Icons.person_pin_outlined, "Contact Person", data.contactPerson ?? "-"),
                _infoTile(Icons.phone_android_outlined, "Mobile", "${data.mobileCountryCode ?? ''} ${data.mobile ?? ''}"),
              ]),
              const SizedBox(height: 16),
              _buildSectionTitle("Visit Information"),
              _buildInfoCard([
                _infoTile(Icons.assignment_outlined, "Purpose", data.visitPurposeName ?? "-"),
                _infoTile(Icons.calendar_today_outlined, "Visit Date", data.visitDate != null ? DateFormat('dd/MM/yyyy').format(data.visitDate!) : "-"),
                _infoTile(Icons.access_time, "Start Time", data.visitStartDatetime != null ? DateFormat('hh:mm a').format(data.visitStartDatetime!) : "-"),
                _infoTile(Icons.access_time, "End Time", data.visitEndDatetime != null ? DateFormat('hh:mm a').format(data.visitEndDatetime!) : "-"),
                _infoTile(Icons.engineering_outlined, "Primary Technician", data.primaryTechnicianName ?? "-"),
                _infoTile(Icons.group_outlined, "All Technicians", data.technicianNames ?? "-"),
              ]),
              const SizedBox(height: 16),
              if (data.products != null && data.products!.isNotEmpty) ...[
                _buildSectionTitle("Products (${data.products!.length})"),
                ...data.products!.map((product) => _buildProductCard(product)).toList(),
                const SizedBox(height: 16),
              ],
              _buildSectionTitle("Financials"),
              _buildInfoCard([
                _infoTile(Icons.currency_rupee, "Total Expense", data.totalExpense ?? "0.00", valueColor: AppColors.indigo600Main),
                _infoTile(Icons.account_balance_wallet_outlined, "Advance Paid", data.advancePaidTotal ?? "0.00"),
                _infoTile(Icons.payments_outlined, "Advance Used", data.advanceUsedTotal ?? "0.00"),
                _infoTile(Icons.keyboard_return_outlined, "Advance Returned", data.advanceReturnedTotal ?? "0.00"),
                _infoTile(Icons.account_balance_outlined, "Balance", data.advanceBalance ?? "0.00", valueColor: AppColors.green500Success),
              ]),
              const SizedBox(height: 16),
              _buildSectionTitle("Other Details"),
              _buildInfoCard([
                _infoTile(Icons.notes, "Remark", data.remark ?? "-"),
                _infoTile(Icons.task_alt, "Outcome", data.visitOutcome ?? "-"),
                _infoTile(Icons.description_outlined, "Overall Remark", data.overallRemark ?? "-"),
                _infoTile(Icons.person_add_alt_1_outlined, "Created By", data.createdByName ?? "-"),
                _infoTile(Icons.calendar_month_outlined, "Created At", data.createdAt != null ? DateFormat('dd/MM/yyyy hh:mm a').format(data.createdAt!) : "-"),
              ]),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard(dynamic data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.indigo600Main.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.directions_walk_outlined, color: AppColors.indigo600Main, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.visitNo ?? "-",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                ),
                const SizedBox(height: 4),
                Text(
                  "Complaint No: ${data.complaintNo ?? '-'}",
                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          _statusBadge(data),
        ],
      ),
    );
  }

  Widget _statusBadge(dynamic item) {
    String label = item.statusName ?? item.status ?? "-";
    Color color = AppColors.gray500;

    String status = (item.status ?? "").toUpperCase();
    if (status == "COMPLETED") {
      color = AppColors.green500Success;
    } else if (status == "PENDING") {
      color = AppColors.orangeColor;
    } else if (status == "IN_PROGRESS") {
      color = AppColors.blue500;
    } else if (status == "CANCELLED" || status == "REJECTED") {
      color = AppColors.red500;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.gray600, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.gray400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.gray500),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.inventory_2_outlined, color: AppColors.indigo600Main, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName ?? "-",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      product.productCode ?? "-",
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              _productInfoItem("Complaint", "${product.complaintQty ?? 0}"),
              _productInfoItem("Solve", "${product.solveQty ?? 0}"),
              _productInfoItem("Warranty", product.warrantyTypeName ?? "-"),
            ],
          ),
          if (product.issueDescription != null && product.issueDescription!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "Issue: ${product.issueDescription}",
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _productInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.gray500, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
