import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../widget/toast_message.dart';
import '../model/picking_detail_response.dart';
import '../picking_list_controller.dart';
import 'pick_serials_screen.dart';

class PickingDetailScreen extends GetView<PickingListController> {
  final String pickingId;
  const PickingDetailScreen({super.key, required this.pickingId});

  @override
  Widget build(BuildContext context) {
    controller.getPickingDetail(pickingId);

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
          "Picking Details",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
        actions: [
          Obx(() {
            final data = controller.pickingDetail.value;
            if (data == null) return const SizedBox.shrink();

            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.white),
              onSelected: (value) {
                if (value == 'reject') {
                  _showRejectDialog(data.id!);
                }
              },
              itemBuilder: (context) => [
                if (data.status?.toUpperCase() != "REJECTED" && data.status?.toUpperCase() != "PACKING_REJECTED")
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
          return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
        }
        if (controller.detailError.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.detailError.value),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => controller.getPickingDetail(pickingId), child: const Text("Retry")),
              ],
            ),
          );
        }
        final data = controller.pickingDetail.value;
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
                        _buildRemarksAndAttachments(data),
                        const SizedBox(height: 20),
                        const Text(
                          "Items to Pick",
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
                            return _buildItemCard(data, item, index);
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildLogsSection(data),
                      ],
                    ),
                  ),
                ),
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

  Widget _buildOrderInfo(PickingDetailData data) {
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
                        "${data.pickingNo}".toUpperCase(),
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
                    _iconInfoRow(
                      color: AppColors.indigo600Main,
                      icon: Icons.calendar_today_outlined,
                      label: "PICKING DATE",
                      value: data.pickingDate != null ? DateFormat('dd MMM yyyy').format(data.createdAt!.toLocal()) : "-",
                    ),
                    const SizedBox(height: 12),
                    _iconInfoRow(color: AppColors.indigo600Main, icon: Icons.priority_high, label: "PRIORITY", value: data.priority ?? "-"),
                    const SizedBox(height: 12),
                    _iconInfoRow(color: AppColors.indigo600Main, icon: Icons.business_outlined, label: "CUSTOMER", value: data.customerName ?? "-"),
                    const SizedBox(height: 12),
                    _iconInfoRow(color: AppColors.indigo600Main, icon: Icons.location_city, label: "LOCATION", value: data.locationName ?? "-"),
                    const SizedBox(height: 12),
                    _iconInfoRow(color: AppColors.indigo600Main, icon: Icons.person_outline, label: "COMPANY NAME", value: data.companyName ?? "-"),
                    const SizedBox(height: 12),
                    _iconInfoRow(
                      color: AppColors.indigo600Main,
                      icon: Icons.phone_android,
                      label: "MOBILE",
                      value: data.invoice?.customerMobile ?? "-",
                    ),
                    const SizedBox(height: 12),
                    _iconInfoRow(
                      color: AppColors.indigo600Main,
                      icon: Icons.list_alt_outlined,
                      label: "TOTAL ITEMS",
                      value: "${data.items?.length ?? 0}",
                    ),
                    const SizedBox(height: 12),
                    _iconInfoRow(
                      color: _getStatusColor(status: data.status ?? ""),
                      icon: Icons.info_outline,
                      label: "STATUS",
                      value: data.status?.toUpperCase() ?? "-",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildInvoiceDetails(data),
      ],
    );
  }

  Widget _buildInvoiceDetails(PickingDetailData data) {
    if (data.invoice == null) return const SizedBox.shrink();
    final invoice = data.invoice!;

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
                              Text(
                                invoice.invoiceNo ?? "-",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
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
                              "₹${invoice.finalTotalAmount ?? "0.00"}",
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
                      _iconInfoRow(
                        color: AppColors.indigo600Main,
                        icon: Icons.calendar_today_outlined,
                        label: "INVOICE DATE",
                        value: invoice.invoiceDate != null ? DateFormat('dd MMM yyyy').format(invoice.invoiceDate!.toLocal()) : "-",
                      ),
                      const SizedBox(height: 12),
                      _iconInfoRow(
                        color: AppColors.orangeColor,
                        icon: Icons.discount_outlined,
                        label: "DISCOUNT",
                        value: "₹${invoice.totalDiscount ?? "0.00"}",
                      ),
                      const SizedBox(height: 12),
                      _iconInfoRow(
                        color: AppColors.indigo600Main,
                        icon: Icons.account_balance_wallet_outlined,
                        label: "TAXABLE AMOUNT",
                        value: "₹${invoice.totalTaxableAmount ?? "0.00"}",
                      ),
                      const SizedBox(height: 12),
                      _iconInfoRow(
                        color: AppColors.indigo600Main,
                        icon: Icons.request_quote_outlined,
                        label: "TAX AMOUNT",
                        value: "₹${invoice.totalTaxAmount ?? "0.00"}",
                      ),
                      const SizedBox(height: 12),
                      _iconInfoRow(
                        color: AppColors.indigo600Main,
                        icon: Icons.add_circle_outline,
                        label: "OTHER CHARGES",
                        value: "₹${invoice.totalChargesAmount ?? "0.00"}",
                      ),
                      const SizedBox(height: 12),
                      _iconInfoRow(
                        color: AppColors.indigo600Main,
                        icon: Icons.exposure_outlined,
                        label: "ROUND OFF",
                        value: invoice.roundOff ?? "0.00",
                      ),
                      const SizedBox(height: 12),
                      _iconInfoRow(
                        color: AppColors.green500Normal,
                        icon: Icons.credit_card,
                        label: "PAYMENT TERMS",
                        value: invoice.paymentTermsName ?? "-",
                        subValue: invoice.dueDate != null ? "Due: ${DateFormat('dd MMM yyyy').format(invoice.dueDate!.toLocal())}" : null,
                      ),
                      const SizedBox(height: 12),
                      _iconInfoRow(
                        color: AppColors.red500,
                        icon: Icons.monetization_on_outlined,
                        label: "PAYMENT STATUS",
                        value: invoice.paymentStatus ?? "-",
                      ),
                      const SizedBox(height: 12),
                      _iconInfoRow(
                        color: AppColors.indigo600Main,
                        icon: Icons.person_outline,
                        label: "RECEIVER DETAILS",
                        value: invoice.receiverName ?? "-",
                        subValue: invoice.receiverMobileNumber,
                      ),
                      const SizedBox(height: 12),
                      _addressInfoRow(
                        color: AppColors.blue500,
                        icon: Icons.location_on_outlined,
                        label: "BILLING ADDRESS",
                        addressDetails: invoice.billingAddressDetails,
                      ),
                      const SizedBox(height: 12),
                      _addressInfoRow(
                        color: AppColors.purple500,
                        icon: Icons.inventory_2_outlined,
                        label: "SHIPPING ADDRESS",
                        addressDetails: invoice.shippingAddressDetails,
                      ),
                      if (invoice.advanceAmount != null && invoice.advanceAmount != "0.00") ...[
                        const SizedBox(height: 12),
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
                                      text: "₹${invoice.advanceAmount ?? "0.00"}",
                                      style: const TextStyle(color: AppColors.indigo600Main, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (invoice.remarks != null && invoice.remarks.toString().isNotEmpty) ...[
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
                                invoice.remarks.toString(),
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

  Widget _addressInfoRow({required Color color, required IconData icon, required String label, IngAddressDetails? addressDetails}) {
    if (addressDetails != null) {
      return _iconInfoRow(
        color: color,
        icon: icon,
        label: label,
        value: addressDetails.street ?? "-",
        subValue: "${addressDetails.cityName ?? ""}, ${addressDetails.stateName ?? ""} - ${addressDetails.pincode ?? ""}",
      );
    }
    return _iconInfoRow(color: color, icon: icon, label: label, value: "-");
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

  Color _getStatusColor({required String status}) {
    if (status == "DRAFT") return AppColors.orangeColor;
    if (status == "PICKING") return AppColors.indigo600Main;
    if (status == "PICKED") return AppColors.green500Success;
    if (status == "REJECTED" || status == "PACKING_REJECTED") return AppColors.red500;
    return AppColors.textPrimary;
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
          maxLines: isFullWidth ? 4 : 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildItemCard(PickingDetailData data, Item item, int index) {
    final product = item.product;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200, width: 0.8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
                child: (product?.imageUrl?.isNotEmpty ?? false)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://tradeapi.cygnux.in${product!.imageUrl!.first}",
                          errorBuilder: (_, __, ___) => const Icon(Icons.inventory_2_outlined, color: AppColors.indigo600Main, size: 22),
                        ),
                      )
                    : const Icon(Icons.inventory_2_outlined, color: AppColors.indigo600Main, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.productName ?? "-",
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.qr_code, size: 12, color: AppColors.gray400),
                        const SizedBox(width: 4),
                        Text(
                          product?.productCode ?? "-",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    if (item.rackLocation != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 12, color: AppColors.indigo600Main),
                          const SizedBox(width: 4),
                          Text(
                            "${item.rackLocation?.rackName} (${item.rackLocation?.rackCode})",
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.indigo600Main),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
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
              _qtyColumn("Ordered", "${item.orderedQty ?? "0"}"),
              _qtyColumn("Picked", "${item.pickedQty ?? "0"}"),
              _qtyColumn("Pending", "${item.pendingQty ?? "0"}", valueColor: AppColors.red500),
              Column(
                children: [
                  const Text(
                    "ACTION",
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.gray500, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 4),
                  (data.status?.toUpperCase() == "REJECTED" || data.status?.toUpperCase() == "PACKING_REJECTED")
                      ? const Text(
                          "-",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        )
                      : (double.tryParse(item.pendingQty ?? "0") ?? 0) <= 0
                      ? const Text(
                          "Fully Picked",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.green500Success),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            controller.getPickingSuggestions(productId: product?.id ?? "", requiredQty: item.pendingQty ?? "0");
                            Get.bottomSheet(
                              PickSerialsScreen(item: item),
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              enableDrag: false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.indigo600Main,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: const Size(0, 30),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Pick Serials", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemarksAndAttachments(PickingDetailData data) {
    return Column(
      children: [
        // Site Remarks & Attachment Card
        Container(
          width: double.infinity,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.indigo600Main.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.assignment_outlined, color: AppColors.indigo600Main, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Site Remarks & Attachment".toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.indigo600Main, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Site Visit Remark:",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.invoice!.siteVisitRemark?.toString() ?? "-",
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Site Visit Attachment:",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),

                    if (data.invoice!.siteVisitAttachment == null || data.invoice!.siteVisitAttachment!.isEmpty)
                      const Center(
                        child: Text(
                          "No site visit attachment available",
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: data.invoice!.siteVisitAttachment!.split(",").length,
                        itemBuilder: (context, index) {
                          final url = data.invoice!.siteVisitAttachment!.split(",")[index].trim();
                          final fileName = url.split("/").last;
                          final isImage =
                              url.toLowerCase().contains(".jpg") || url.toLowerCase().contains(".jpeg") || url.toLowerCase().contains(".png");

                          return Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.gray200),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    color: AppColors.gray100,
                                    child: isImage
                                        ? Image.network(
                                            "$url",
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => const Icon(Icons.insert_drive_file, color: AppColors.gray400, size: 30),
                                          )
                                        : const Icon(Icons.insert_drive_file, color: AppColors.gray400, size: 30),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  color: AppColors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fileName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: AppColors.gray300),
                                            ),
                                            child: const Text("Site Attachment", style: TextStyle(fontSize: 7, fontWeight: FontWeight.w600)),
                                          ),
                                          const Text(
                                            "View",
                                            style: TextStyle(fontSize: 9, color: AppColors.indigo600Main, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Tabbed Remarks Section
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gray200, width: 0.8),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.gray100, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _buildTabItem(0, Icons.description_outlined, "Remarks Details")),
                      Expanded(child: _buildTabItem(1, Icons.attachment_outlined, "Site Attachment & Remarks")),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: controller.selectedAttachmentTab.value == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.description_outlined, size: 16, color: AppColors.indigo600Main),
                                SizedBox(width: 8),
                                Text(
                                  "Remarks Details",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.indigo600Main.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Picking Remarks:",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(data.remarks?.toString() ?? "-", style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.attachment_outlined, size: 16, color: AppColors.indigo600Main),
                                SizedBox(width: 8),
                                Text(
                                  "Site Attachment & Remarks",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.indigo600Main.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Site Visit Remark:",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data.invoice!.siteVisitRemark?.toString() ?? "-",
                                    style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Site Visit Attachment:",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  if (data.invoice!.siteVisitAttachment == null || data.invoice!.siteVisitAttachment!.isEmpty)
                                    const Text(
                                      "No site visit attachment available",
                                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                                    )
                                  else
                                    Text(
                                      data.invoice!.siteVisitAttachment!,
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final isSelected = controller.selectedAttachmentTab.value == index;
    return InkWell(
      onTap: () => controller.selectedAttachmentTab.value = index,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isSelected ? AppColors.indigo600Main : Colors.transparent, width: 2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
    );
  }

  Widget _qtyColumn(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.gray500, letterSpacing: 0.5),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildLogsSection(PickingDetailData detail) {
    final logs = detail.logs ?? [];
    if (logs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "History",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final log = logs[index];
            String logDate = "-";
            if (log.createdAt != null) {
              logDate = DateFormat("dd MMM yyyy, hh:mm a").format(log.createdAt!);
            }
            return Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        log.logType?.replaceAll("_", " ") ?? "Action",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.indigo600Main, fontSize: 13),
                      ),
                      Text(logDate, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                  if (log.notes != null && log.notes!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(log.notes!, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(log.createdByName ?? "Unknown", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _showRejectDialog(String pickingId) {
    final reasonController = TextEditingController();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.cancel_outlined, color: AppColors.red500, size: 24),
                        SizedBox(width: 12),
                        Text(
                          "Reject Picking",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.red500),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: AppColors.gray500),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4E5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFE0B2)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFFE65100), size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Rejecting this picking list will release all allocated stocks/serials, revert the Pick Request back to PENDING, and set the PI status to Picking Reject.",
                          style: TextStyle(fontSize: 12, color: Color(0xFFE65100), fontWeight: FontWeight.w500, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  text: const TextSpan(
                    text: "Rejection Remark ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    children: [
                      TextSpan(
                        text: "*",
                        style: TextStyle(color: AppColors.red500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Enter detailed reason for rejection...",
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.gray400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.gray300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.gray300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.indigo600Main),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Rejection remark is mandatory.",
                  style: TextStyle(fontSize: 11, color: AppColors.red500, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF3F4F6),
                          foregroundColor: AppColors.textPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (reasonController.text.trim().isNotEmpty) {
                            controller.rejectPicking(pickingId: pickingId, reason: reasonController.text.trim());
                          } else {
                            toastMessage(text: "Please enter a reason");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA4A4),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, size: 16),
                            SizedBox(width: 8),
                            Text("Reject", style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
