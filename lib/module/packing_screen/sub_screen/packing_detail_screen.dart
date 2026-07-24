import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/app_colors.dart';
import '../model/packing_detail_responce_model.dart';
import '../packing_controller.dart';

class PackingDetailScreen extends GetView<PackingController> {
  const PackingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String id = Get.arguments;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.packingDetail.value?.id != id && !controller.isDetailLoading.value) {
        controller.getPackingDetail(id);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.indigo600Main,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Packing Details",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
        actions: [
          Obx(() {
            final data = controller.packingDetail.value;
            if (data == null) return const SizedBox.shrink();

            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.white),
              onSelected: (value) {
                if (value == 'reject') {
                  _showRejectPackingDialog(context, data.id!);
                } else if (value == 'request_invoice') {
                  _showRequestInvoiceDialog(context, data);
                }
              },
              itemBuilder: (context) => [
                if (data.status != "REJECTED" && data.status != "INVOICED" && data.status != "READY_FOR_DISPATCH")
                  const PopupMenuItem(
                    value: 'reject',
                    child: Row(
                      children: [
                        Icon(Icons.block, color: AppColors.red500, size: 20),
                        SizedBox(width: 8),
                        Text("Reject", style: TextStyle(color: AppColors.red500)),
                      ],
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.detailError.isNotEmpty) {
          return Center(child: Text(controller.detailError.value));
        }
        final data = controller.packingDetail.value;
        if (data == null) {
          return const Center(child: Text("No Data Found"));
        }

        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOrderInfo(data),
                        const SizedBox(height: 20),
                        const Text(
                          "Items to Pack",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.items?.length ?? 0,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = data.items![index];
                            return _buildItemCard(data, item);
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildLogsSection(context, data),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                if (data.status == "PICKED") _buildBottomButton("START PACKING", () => _showCreatePackingDialog(context, data.id!)),
              ],
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(child: CircularProgressIndicator(color: AppColors.white)),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildBottomButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.indigo600Main,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfo(PackingDetailData data) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gray200, width: 0.8),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.indigo600Main.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, color: AppColors.indigo600Main, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Packing Details".toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.indigo600Main, letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _infoCell(Icons.inventory_2_outlined, "Packing No", data.packingNo ?? "-")),
                        Expanded(
                          child: _infoCell(
                            Icons.calendar_today_outlined,
                            "Packing Date",
                            data.packingDate != null ? DateFormat('dd MMM yyyy').format(data.packingDate!.toLocal()) : "-",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _infoCell(Icons.confirmation_number_outlined, "Picking No", data.picking?.pickingNo ?? "-")),
                        Expanded(
                          child: _infoCell(
                            Icons.calendar_today_outlined,
                            "Picking Date",
                            data.picking?.pickingDate != null ? DateFormat('dd MMM yyyy').format(data.picking!.pickingDate!.toLocal()) : "-",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _infoCell(
                            Icons.business_outlined,
                            "Company",
                            (data.customer?.companyName != null && data.customer!.companyName!.isNotEmpty)
                                ? data.customer!.companyName!
                                : (data.customer?.contactName ?? "-"),
                          ),
                        ),
                        Expanded(child: _infoCell(Icons.inventory_2_outlined, "Total Packages", "${data.totalPackages ?? "0"}")),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _infoCell(
                            Icons.info_outline,
                            "Status",
                            controller.detailStatusLabel.value,
                            valueColor: controller.detailStatusColor.value,
                          ),
                        ),
                        const Expanded(child: SizedBox.shrink()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildRejectionReason(data),
        const SizedBox(height: 20),
        _buildInvoiceDetails(data),
        if (data.invoice != null) ...[const SizedBox(height: 20), _buildRemarksAndAttachmentsTab(data)],
      ],
    );
  }

  Widget _buildRejectionReason(PackingDetailData data) {
    if (data.status != "REJECTED" || data.rejectionReason == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.red500.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.red500.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, size: 18, color: AppColors.red500),
              const SizedBox(width: 8),
              const Text(
                "Packing Rejection Reason",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.red500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            data.rejectionReason.toString(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.red500),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetails(PackingDetailData data) {
    if (data.invoice == null) return const SizedBox.shrink();

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200, width: 0.8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.indigo600Main.withValues(alpha: 0.05),
              border: Border(bottom: BorderSide(color: AppColors.gray100, width: 1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_outlined, color: AppColors.indigo600Main, size: 20),
                const SizedBox(width: 10),
                Text(
                  "Invoice Details".toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.indigo600Main, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () => controller.isInvoiceExpanded.toggle(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.indigo600Main.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.indigo600Main.withValues(alpha: 0.2), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.description_outlined, color: AppColors.indigo600Main, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Invoice Summary",
                                style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    data.invoice?.invoiceNo ?? "-",
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
                                  ),
                                  if (data.invoice?.isDcFlow == true) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.green500Normal.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(color: AppColors.green500Normal.withValues(alpha: 0.3), width: 0.5),
                                      ),
                                      child: const Text(
                                        "DC Flow",
                                        style: TextStyle(color: AppColors.green500Normal, fontSize: 8, fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "TOTAL AMOUNT",
                              style: TextStyle(color: AppColors.gray500, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                            ),
                            Text(
                              "₹${data.invoice?.finalTotalAmount ?? "0.00"}",
                              style: const TextStyle(color: AppColors.indigo600Main, fontWeight: FontWeight.w900, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Obx(
                          () => AnimatedRotation(
                            turns: controller.isInvoiceExpanded.value ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(Icons.keyboard_arrow_down, color: AppColors.indigo600Main.withValues(alpha: 0.5), size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  if (!controller.isInvoiceExpanded.value) return const SizedBox.shrink();
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: AppColors.gray100),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _infoCell(
                              Icons.calendar_today_outlined,
                              "Invoice Date",
                              data.invoice?.invoiceDate != null ? DateFormat('dd MMM yyyy').format(data.invoice!.invoiceDate!.toLocal()) : "-",
                            ),
                          ),
                          Expanded(child: _infoCell(Icons.discount_outlined, "Discount", "₹${data.invoice?.totalDiscount ?? "0.00"}")),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _infoCell(
                              Icons.account_balance_wallet_outlined,
                              "Taxable Amount",
                              "₹${data.invoice?.totalTaxableAmount ?? "0.00"}",
                            ),
                          ),
                          Expanded(child: _infoCell(Icons.request_quote_outlined, "Tax Amount", "₹${data.invoice?.totalTaxAmount ?? "0.00"}")),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _infoCell(Icons.add_circle_outline, "Other Charges", "₹${data.invoice?.totalChargesAmount ?? "0.00"}")),
                          Expanded(child: _infoCell(Icons.exposure_outlined, "Round Off", data.invoice?.roundOff ?? "0.00")),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1, color: AppColors.gray100),
                      ),
                      _iconInfoRow(
                        color: AppColors.green500Normal,
                        icon: Icons.credit_card,
                        label: "PAYMENT TERMS",
                        value: data.invoice?.paymentTermsName ?? "-",
                        subValue: data.invoice?.dueDate != null ? "Due: ${DateFormat('dd MMM yyyy').format(data.invoice!.dueDate!.toLocal())}" : null,
                      ),
                      const SizedBox(height: 12),
                      _iconInfoRow(
                        color: AppColors.red500,
                        icon: Icons.monetization_on_outlined,
                        label: "PAYMENT STATUS",
                        value: data.invoice?.paymentStatus ?? "-",
                      ),
                      const SizedBox(height: 12),
                      _iconInfoRow(
                        color: AppColors.indigo600Main,
                        icon: Icons.person_outline,
                        label: "RECEIVER DETAILS",
                        value: data.invoice?.receiverName ?? "-",
                        subValue: data.invoice?.receiverMobileNumber,
                      ),
                      const SizedBox(height: 12),
                      _addressInfoRow(
                        color: AppColors.blue500,
                        icon: Icons.location_on_outlined,
                        label: "BILLING ADDRESS",
                        addressId: data.invoice?.billingAddress,
                        customerAddresses: data.customerAddresses,
                      ),
                      const SizedBox(height: 12),
                      _addressInfoRow(
                        color: AppColors.purple500,
                        icon: Icons.inventory_2_outlined,
                        label: "SHIPPING ADDRESS",
                        addressId: data.invoice?.shippingAddress,
                        customerAddresses: data.customerAddresses,
                      ),
                      if (data.invoice?.advanceAmount != null && data.invoice!.advanceAmount != "0.00") ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.indigo600Main.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.indigo600Main.withValues(alpha: 0.1), width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.info_outline, size: 16, color: AppColors.indigo600Main),
                                  SizedBox(width: 8),
                                  Text(
                                    "Advance Payment Details",
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                                  children: [
                                    const TextSpan(
                                      text: "Advance Amount: ",
                                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.gray600),
                                    ),
                                    TextSpan(
                                      text: "₹${data.invoice?.advanceAmount ?? "0.00"}",
                                      style: const TextStyle(color: AppColors.indigo600Main, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (data.piRemarks != null && data.piRemarks!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9E7),
                            borderRadius: BorderRadius.circular(12),
                            border: const Border(left: BorderSide(color: Color(0xFFFFC107), width: 4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.info_outline, size: 16, color: Color(0xFFFFC107)),
                                  SizedBox(width: 8),
                                  Text(
                                    "REMARKS",
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF856404), letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                data.piRemarks ?? "-",
                                style: const TextStyle(fontSize: 13, color: Color(0xFF856404), fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemarksAndAttachmentsTab(PackingDetailData data) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.gray200, width: 0.8)),
              ),
              child: Row(
                children: [
                  _tabItem(
                    icon: Icons.comment_bank_outlined,
                    label: "Site Remarks & Attachments",
                    isSelected: controller.selectedAttachmentTab.value == 0,
                    onTap: () => controller.selectedAttachmentTab.value = 0,
                  ),
                  _tabItem(
                    icon: Icons.attachment_outlined,
                    label: "PI Attachment",
                    isSelected: controller.selectedAttachmentTab.value == 1,
                    onTap: () => controller.selectedAttachmentTab.value = 1,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              if (controller.selectedAttachmentTab.value == 0) {
                return _buildSiteRemarksSection(data);
              } else {
                return _buildPIAttachmentSection(data);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _tabItem({required IconData icon, required String label, required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: isSelected ? AppColors.indigo600Main : Colors.transparent, width: 2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? AppColors.indigo600Main : AppColors.gray500),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppColors.indigo600Main : AppColors.gray500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSiteRemarksSection(PackingDetailData data) {
    final attachments = data.invoice?.siteVisitAttachment?.split(',').where((s) => s.isNotEmpty).toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "SITE REMARKS",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gray500, letterSpacing: 0.5),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.gray100.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(8)),
          child: Text(data.invoice?.siteVisitRemark ?? "No remarks", style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
        ),
        const SizedBox(height: 20),
        const Text(
          "ATTACHMENTS",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gray500, letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        if (attachments.isEmpty)
          const Text("No attachments", style: TextStyle(fontSize: 12, color: AppColors.gray400))
        else
          Wrap(spacing: 12, runSpacing: 12, children: attachments.map((url) => _buildAttachmentTile(url)).toList()),
      ],
    );
  }

  Widget _buildPIAttachmentSection(PackingDetailData data) {
    final attachments = data.invoice?.attachments?.split(',').where((s) => s.isNotEmpty).toList() ?? [];
    final advanceAttachments = data.invoice?.advanceAttachment?.split(',').where((s) => s.isNotEmpty).toList() ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ADVANCE ATTACHMENTS",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gray500, letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        if (advanceAttachments.isEmpty)
          const Text("No attachments", style: TextStyle(fontSize: 12, color: AppColors.gray400))
        else
          Wrap(spacing: 12, runSpacing: 12, children: advanceAttachments.map((url) => _buildAttachmentTile(url)).toList()),
        const SizedBox(height: 24),
        const Text(
          "PI ATTACHMENTS",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gray500, letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        if (attachments.isEmpty)
          const Text("No attachments", style: TextStyle(fontSize: 12, color: AppColors.gray400))
        else
          Wrap(spacing: 12, runSpacing: 12, children: attachments.map((url) => _buildAttachmentTile(url)).toList()),
      ],
    );
  }

  Widget _buildAttachmentTile(String url) {
    bool isPdf = url.toLowerCase().endsWith('.pdf');
    bool isImage = ['.jpg', '.jpeg', '.png', '.gif', '.webp'].any((ext) => url.toLowerCase().endsWith(ext));

    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar("Error", "Could not open attachment link");
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Center(
                child: isImage
                    ? Image.network(
                        url,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: AppColors.gray400),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                        },
                      )
                    : Icon(
                        isPdf ? Icons.picture_as_pdf : Icons.insert_drive_file,
                        color: isPdf ? Colors.red.withValues(alpha: 0.7) : AppColors.indigo600Main.withValues(alpha: 0.7),
                        size: 40,
                      ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6)),
                  child: Text(
                    url.split('/').last,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addressInfoRow({
    required Color color,
    required IconData icon,
    required String label,
    String? addressId,
    List<CustomerAddress>? customerAddresses,
  }) {
    CustomerAddress? addr;
    if (customerAddresses != null && addressId != null) {
      for (var a in customerAddresses) {
        if (a.id == addressId) {
          addr = a;
          break;
        }
      }
    }

    if (addr != null) {
      return _iconInfoRow(
        color: color,
        icon: icon,
        label: label,
        value: addr.street ?? "-",
        subValue: "${addr.cityName ?? ""}, ${addr.stateName ?? ""} - ${addr.pinCode ?? ""}",
      );
    }
    return _iconInfoRow(color: color, icon: icon, label: label, value: addressId ?? "-");
  }

  Widget _iconInfoRow({required Color color, required IconData icon, required String label, required String value, String? subValue}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color.withValues(alpha: 0.8), letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                if (subValue != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subValue,
                    style: const TextStyle(fontSize: 11, color: AppColors.gray600, fontWeight: FontWeight.w500),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCell(IconData icon, String label, String value, {bool isFullWidth = false, Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.indigo600Main.withValues(alpha: 0.5)),
            const SizedBox(width: 6),
            Text(
              label.toUpperCase(),
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: isFullWidth ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildItemCard(PackingDetailData data, DataItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200, width: 0.8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.inventory_2_outlined, color: AppColors.indigo600Main, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product?.productName ?? "-",
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.qr_code, size: 12, color: AppColors.gray400),
                    const SizedBox(width: 4),
                    Text(
                      item.product?.productCode ?? "-",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: AppColors.gray100),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _qtyColumn("Ordered", item.orderedQty ?? "0"),
                    _qtyColumn("Picked", item.pickedQty ?? "0"),
                    _qtyColumn(
                      "Packed",
                      item.packedQty ?? "0",
                      /* isAction: data.status == "PACKED",
                      onTap: data.status == "PACKED"
                          ? () {
                              _showPackedQtyDialog(data.id!, item);
                            }
                          : null,*/
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

  Widget _buildLogsSection(BuildContext context, PackingDetailData detail) {
    final logs = detail.logs ?? [];
    if (logs.isEmpty && !controller.isLogNoteOpen.value) return const SizedBox.shrink();

    // Group logs by date
    Map<String, List<Log>> groupedLogs = {};
    for (var log in logs) {
      if (log.createdAt != null) {
        String dateKey = DateFormat('dd MMM yyyy').format(log.createdAt!.toLocal()).toUpperCase();
        if (!groupedLogs.containsKey(dateKey)) {
          groupedLogs[dateKey] = [];
        }
        groupedLogs[dateKey]!.add(log);
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200, width: 0.8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history_outlined, color: AppColors.gray600, size: 20),
              SizedBox(width: 8),
              Text(
                "Activity Timeline",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.gray600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => ElevatedButton.icon(
              onPressed: () => controller.isLogNoteOpen.toggle(),
              icon: Icon(controller.isLogNoteOpen.value ? Icons.close : Icons.add, size: 18),
              label: Text(controller.isLogNoteOpen.value ? "Log Note" : "Log Note", style: const TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.indigo600Main,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Obx(() {
            if (!controller.isLogNoteOpen.value) return const SizedBox.shrink();
            return _buildLogNoteForm(context);
          }),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: groupedLogs.length,
            itemBuilder: (context, index) {
              String dateKey = groupedLogs.keys.elementAt(index);
              List<Log> dayLogs = groupedLogs[dateKey]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateKey,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 16),
                  ...dayLogs.map((log) {
                    bool isLast = dayLogs.indexOf(log) == dayLogs.length - 1 && index == groupedLogs.length - 1;
                    return _buildTimelineItem(log, isLast);
                  }),
                  if (index != groupedLogs.length - 1) const SizedBox(height: 16),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogNoteForm(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.edit_note, size: 20, color: AppColors.gray600),
                const SizedBox(width: 8),
                const Text(
                  "New Log",
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => _selectReminderDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.gray200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: AppColors.indigo600Main),
                        const SizedBox(width: 6),
                        Obx(
                          () => Text(
                            controller.reminderDate.value != null ? DateFormat('dd MMM yyyy').format(controller.reminderDate.value!) : "Reminder?",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.gray600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Text Input
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller.logNoteController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Type your log details here...",
                hintStyle: TextStyle(color: AppColors.gray400, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          // File Picker Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gray300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => _pickFiles(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: const BoxDecoration(
                        color: AppColors.gray100,
                        border: Border(right: BorderSide(color: AppColors.gray300)),
                      ),
                      child: const Text("Choose Files", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(
                      () => Text(
                        controller.selectedLogFiles.isEmpty ? "No file chosen" : "${controller.selectedLogFiles.length} file(s) selected",
                        style: const TextStyle(fontSize: 13, color: AppColors.gray600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // Form Footer
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    controller.isLogNoteOpen.value = false;
                    controller.logNoteController.clear();
                    controller.reminderDate.value = null;
                    controller.selectedLogFiles.clear();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: AppColors.gray600, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => controller.postLogNote(),
                  icon: const Icon(Icons.send, size: 16),
                  label: const Text("Post", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.indigo600Main,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectReminderDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.indigo600Main, onPrimary: Colors.white, onSurface: AppColors.textPrimary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.reminderDate.value = picked;
    }
  }

  Future<void> _pickFiles() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      controller.selectedLogFiles.addAll(images.map((image) => File(image.path)));
    }
  }

  Widget _buildTimelineItem(Log log, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.indigo600Main.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.indigo600Main.withValues(alpha: 0.2)),
                ),
                child: Center(
                  child: Text(
                    log.createdByName?.isNotEmpty == true ? log.createdByName![0].toUpperCase() : "A",
                    style: const TextStyle(color: AppColors.indigo600Main, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (!isLast) Expanded(child: Container(width: 1, color: AppColors.gray200)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      log.createdByName ?? "Unknown User",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                    ),
                    Text(
                      log.createdAt != null ? DateFormat('dd/MM/yyyy hh:mm a').format(log.createdAt!.toLocal()) : "-",
                      style: const TextStyle(fontSize: 11, color: AppColors.gray500, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gray200, width: 0.8),
                  ),
                  child: Text(log.notes ?? "-", style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyColumn(String label, String value, {bool isAction = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.gray500, letterSpacing: 0.5),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isAction ? AppColors.indigo600Main : AppColors.textPrimary),
              ),
              if (isAction) ...[const SizedBox(width: 4), const Icon(Icons.edit, size: 12, color: AppColors.indigo600Main)],
            ],
          ),
        ],
      ),
    );
  }

  void _showRejectPackingDialog(BuildContext context, String id) {
    final TextEditingController reasonController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, size: 20, color: AppColors.red500),
                    const SizedBox(width: 8),
                    const Text(
                      "Reject Packing",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.red500),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 20, color: AppColors.gray400),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(color: AppColors.redColor, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.block, size: 40, color: AppColors.red500),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Are you sure you want to reject this packing?",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "This action cannot be undone.",
                      style: TextStyle(fontSize: 14, color: AppColors.gray500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Rejection Reason",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.red500.withValues(alpha: 0.7)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: reasonController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter reason for rejection...",
                        hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.gray300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.gray300),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a reason';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.gray600,
                              side: const BorderSide(color: AppColors.gray300),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.of(context).pop();
                              controller.rejectPacking(id, reason: reasonController.text);
                            }
                          },
                          icon: const Icon(Icons.block, size: 18, color: Colors.white),
                          label: const Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red500,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreatePackingDialog(BuildContext context, String id) {
    final TextEditingController remarksController = TextEditingController();
    final RxBool isShrinkWrapped = false.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 20),
                  const SizedBox(width: 8),
                  const Text("Create Packing", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20, color: AppColors.gray400),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(color: AppColors.indigo50, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.inventory_2_outlined, size: 40, color: AppColors.indigo600Main),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Is this package shrink wrapped?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Switch(
                      value: isShrinkWrapped.value,
                      onChanged: (value) => isShrinkWrapped.value = value,
                      activeThumbColor: AppColors.indigo600Main,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Remarks (Optional)",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.indigo600Main.withValues(alpha: 0.7)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: remarksController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Enter any additional remarks...",
                      hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.gray300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.gray300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.red500,
                            side: const BorderSide(color: AppColors.red500),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            controller.createPackingFromPicking(
                              pickingId: id,
                              isShrinkWrapped: isShrinkWrapped.value,
                              remarks: remarksController.text,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.indigo600Main,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            "Create Packing",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      ),
    );
  }

  void _showRequestInvoiceDialog(BuildContext context, PackingDetailData data) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.near_me_outlined, size: 20, color: AppColors.indigo600Main),
                  const SizedBox(width: 8),
                  const Text(
                    "Request For Invoice",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20, color: AppColors.gray400),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(color: AppColors.indigo600Main, shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text("Are you sure?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: AppColors.gray500, fontFamily: 'Inter'),
                      children: [
                        const TextSpan(text: "You are about to request an invoice for Packing List "),
                        TextSpan(
                          text: data.packingNo ?? "-",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const TextSpan(text: "."),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF1F4F9),
                            foregroundColor: AppColors.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            controller.requestForInvoice(data.id!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.indigo600Main,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Confirm",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
