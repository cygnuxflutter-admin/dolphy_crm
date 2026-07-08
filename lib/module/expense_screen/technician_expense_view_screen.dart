import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import 'model/technician_expense_view_model.dart';
import 'technician_expense_controller.dart';

class TechnicianExpenseViewScreen extends StatefulWidget {
  final String expenseId;
  const TechnicianExpenseViewScreen({super.key, required this.expenseId});

  @override
  State<TechnicianExpenseViewScreen> createState() => _TechnicianExpenseViewScreenState();
}

class _TechnicianExpenseViewScreenState extends State<TechnicianExpenseViewScreen> {
  final controller = Get.find<TechnicianExpenseController>();
  bool isLoading = true;
  TechnicianExpenseViewData? data;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    setState(() => isLoading = true);
    data = await controller.fetchExpenseDetails(widget.expenseId);
    setState(() => isLoading = false);
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "-";
    var istDateTime = dateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
    return DateFormat('dd/MM/yyyy hh:mm a').format(istDateTime);
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return "-";
    var istDateTime = dateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
    return DateFormat('dd/MM/yyyy').format(istDateTime);
  }

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
          "Technician Expense",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data == null
          ? const Center(child: Text("Data not found"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildGeneralInfo(),
                  const SizedBox(height: 16),
                  _buildDatesAndDetails(),
                  const SizedBox(height: 16),
                  _buildFinancialSummary(),
                  const SizedBox(height: 16),
                  _buildPaymentSummary(),
                  const SizedBox(height: 24),
                  const Text(
                    "Expense Line Items",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  _buildLineItems(),
                  const SizedBox(height: 24),
                  const Text(
                    "Processing History",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  _buildStatusHistory(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(color: AppColors.indigo600Main, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data!.expenseNo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            _statusBadge(data!.status),
          ],
        ),
      ],
    );
  }

  Widget _buildGeneralInfo() {
    return _buildSection(
      title: "General Information",
      children: [
        _buildDetailRow(Icons.access_time, "VISIT NO.", data!.visitNo),
        _buildDetailRow(Icons.assignment_outlined, "COMPLAINT NO.", data!.complaintNo),
        _buildDetailRow(Icons.person_outline, "CUSTOMER", data!.customerName),
        _buildDetailRow(Icons.engineering_outlined, "TECHNICIAN", data!.technicianName),
      ],
    );
  }

  Widget _buildDatesAndDetails() {
    return _buildSection(
      title: "Dates & Details",
      children: [
        _buildDetailRow(Icons.calendar_today_outlined, "EXPENSE DATE", formatDate(data!.expenseDate)),
        _buildDetailRow(Icons.chat_bubble_outline, "REMARKS", data!.remarks.isEmpty ? "-" : data!.remarks),
        _buildDetailRow(Icons.attach_file, "ATTACHMENTS", "No attachments"),
      ],
    );
  }

  Widget _buildFinancialSummary() {
    return _buildSection(
      title: "Financial Summary",
      children: [
        _buildSummaryRow("REQUEST AMOUNT", data!.totalRequestAmount),
        _buildSummaryRow("APPROVE AMOUNT", data!.totalApproveAmount),
        _buildSummaryRow("PAY BY CLIENT", data!.totalClientAmount),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    return _buildSection(
      title: "Payment Summary",
      children: [
        _buildSummaryRow("PENDING AMOUNT", data!.pendingAmount),
        _buildSummaryRow("PAID AMOUNT", data!.paidAmount),
        const SizedBox(height: 8),
        const Text(
          "Cash paid to technician – updated when expense payment is recorded, not on approval.",
          style: TextStyle(fontSize: 10, color: AppColors.gray500, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const Divider(height: 24, color: AppColors.gray100),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.gray400),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.gray500),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _infoCell(IconData icon, String label, String value, {Color? valueColor}) {
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
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildLineItems() {
    return Column(children: data!.lines.map((line) => _buildLineItemCard(line)).toList());
  }

  Widget _buildLineItemCard(Line line) {
    String typeDisplay = line.expenseTypeName;
    if (line.expenseTypeName.toLowerCase() == "travel" && line.travelTypeName.isNotEmpty) {
      typeDisplay += " - ${line.travelTypeName}";
      if (line.kilometre != null && line.kilometre != "null" && line.kilometre!.isNotEmpty) {
        typeDisplay += " - ${line.kilometre} km";
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    "#${line.lineNo}",
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    line.expenseIdentifier,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                _statusBadge(data!.status),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _infoCell(Icons.category_outlined, "EXPENSE TYPE", typeDisplay)),
                    Expanded(child: _infoCell(Icons.info_outline, "DETAILS", line.description.isEmpty ? "-" : line.description)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1, color: AppColors.gray100),
                ),
                Row(
                  children: [
                    Expanded(child: _infoCell(Icons.currency_rupee, "REQ. AMOUNT", line.requestAmount, valueColor: AppColors.textPrimary)),
                    Expanded(child: _infoCell(Icons.check_circle_outline, "APPR. AMOUNT", line.approveAmount, valueColor: AppColors.green500Success)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.payment_outlined, size: 14, color: AppColors.gray400),
                              SizedBox(width: 6),
                              Text(
                                "PAY BY CLIENT",
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.gray500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: line.isPaidByClient ? AppColors.green500Success.withValues(alpha: 0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              line.clientAmount,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: line.isPaidByClient ? AppColors.green500Success : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: _infoCell(Icons.attach_file, "ATTACHMENTS", "No attachments")),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data!.statusHistory.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final history = data!.statusHistory[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.send_outlined, size: 14, color: AppColors.indigo600Main),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${history.action} by ${history.actedByName}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text("-> ${history.toStatus}", style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    if (history.remarks.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          history.remarks,
                          style: const TextStyle(fontSize: 11, color: AppColors.gray500, fontStyle: FontStyle.italic),
                        ),
                      ),
                  ],
                ),
              ),
              Text(formatDateTime(history.createdAt), style: const TextStyle(fontSize: 10, color: AppColors.gray400)),
            ],
          );
        },
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color = AppColors.gray500;
    String label = status.toUpperCase();
    if (label == "SUBMITTED") {
      color = AppColors.blue500;
    } else if (label == "APPROVED") {
      color = AppColors.green500Success;
    } else if (label == "REJECTED" || label == "CANCELLED") {
      color = AppColors.red500;
    } else if (label == "PENDING") {
      color = AppColors.orangeColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}
