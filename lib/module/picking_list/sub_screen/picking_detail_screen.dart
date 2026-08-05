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
                if (value == 'invoice') {
                  _showInvoiceDetailsDialog(data);
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
                const PopupMenuItem(
                  value: 'invoice',
                  child: Row(
                    children: [
                      Icon(Icons.book, color: AppColors.primaryColor, size: 20),
                      SizedBox(width: 8),
                      Text("invoice", style: TextStyle(color: AppColors.primaryColor)),
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
                        // const SizedBox(height: 20),
                        // _buildLogsSection(data),
                        // const SizedBox(height: 20),
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
    String pickingDate = "-";
    bool isPicking = data.status?.toUpperCase() == 'PICKING';

    if (data.createdAt != null) {
      try {
        DateTime istDate = data.createdAt!.toUtc().add(const Duration(hours: 5, minutes: 30));
        pickingDate = DateFormat("dd/MM/yyyy hh:mm a").format(istDate).toLowerCase();
      } catch (e) {
        debugPrint("Error parsing date: $e");
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.indigo600Main.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   height: 28,
                //   width: 28,
                //   alignment: Alignment.center,
                //   decoration: const BoxDecoration(color: AppColors.indigo600Main, shape: BoxShape.circle),
                //   child: const Icon(Icons.inventory_2_outlined, color: AppColors.white, size: 16),
                // ),
                // const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.invoice?.invoiceNo ?? "-",
                        style: const TextStyle(fontSize: 16, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.customerName ?? "-",
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.indigo600Main),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pickingDate.toUpperCase(),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gray500, letterSpacing: 0.5),
                      ),

                      // _compactInfoCell(Icons.calendar_today_outlined, "Picking Date", pickingDate, valueColor: isPicking ? AppColors.red500 : null),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (data.priority != null && data.priority!.isNotEmpty) ...[
                      _compactBadge(data.priority!, _getPriorityColor(data.priority)),
                      const SizedBox(height: 05),
                    ],
                    _compactBadge(data.status ?? "-", _getStatusColor(data.status)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    // Expanded(child: _compactInfoCell(Icons.person_outline, "Customer", data.customerName ?? "-")),
                    Expanded(
                      child: _compactInfoCell(Icons.local_shipping_outlined, "Transport Mode", data.invoice?.transportMode?.toString() ?? "-"),
                    ),
                    Expanded(child: _compactInfoCell(Icons.info_outline, "Status", data.status?.toUpperCase() ?? "-")),
                    Expanded(child: _compactInfoCell(Icons.location_on_outlined, "Location", data.locationName ?? "-")),
                  ],
                ),
                // const SizedBox(height: 10),
                if (data.invoice != null) ...[
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: AppColors.gray100),

                  _buildRemarksSummary(data),
                  // const Divider(height: 1, color: AppColors.gray100),

                  // _buildInvoiceDetails(data),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetails(PickingDetailData data) {
    if (data.invoice == null) return const SizedBox.shrink();
    final invoice = data.invoice!;

    return InkWell(
      onTap: () => _showInvoiceDetailsDialog(data),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(Icons.description_outlined, color: AppColors.indigo600Main, size: 22),
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
            const SizedBox(width: 12),
            const Icon(Icons.visibility_outlined, color: AppColors.indigo600Main, size: 20),
          ],
        ),
      ),
    );
  }

  void _showInvoiceDetailsDialog(PickingDetailData data) {
    final invoice = data.invoice!;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Invoice Details",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                    ),
                    IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close), visualDensity: VisualDensity.compact),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconInfoRow(
                      color: AppColors.indigo600Main,
                      icon: Icons.calendar_today_outlined,
                      label: "INVOICE DATE",
                      value: invoice.invoiceDate != null ? DateFormat('dd MMM yyyy').format(invoice.invoiceDate!.toLocal()) : "-",
                    ),
                    const Divider(height: 24, color: AppColors.gray100),
                    _iconInfoRow(
                      color: AppColors.orangeColor,
                      icon: Icons.discount_outlined,
                      label: "DISCOUNT",
                      value: "₹${invoice.totalDiscount ?? "0.00"}",
                    ),
                    const Divider(height: 24, color: AppColors.gray100),
                    _iconInfoRow(
                      color: AppColors.indigo600Main,
                      icon: Icons.account_balance_wallet_outlined,
                      label: "TAXABLE AMOUNT",
                      value: "₹${invoice.totalTaxableAmount ?? "0.00"}",
                    ),
                    const Divider(height: 24, color: AppColors.gray100),
                    _iconInfoRow(
                      color: AppColors.indigo600Main,
                      icon: Icons.request_quote_outlined,
                      label: "TAX AMOUNT",
                      value: "₹${invoice.totalTaxAmount ?? "0.00"}",
                    ),
                    const Divider(height: 24, color: AppColors.gray100),
                    _iconInfoRow(
                      color: AppColors.indigo600Main,
                      icon: Icons.add_circle_outline,
                      label: "OTHER CHARGES",
                      value: "₹${invoice.totalChargesAmount ?? "0.00"}",
                    ),
                    const Divider(height: 24, color: AppColors.gray100),
                    _iconInfoRow(
                      color: AppColors.indigo600Main,
                      icon: Icons.exposure_outlined,
                      label: "ROUND OFF",
                      value: invoice.roundOff ?? "0.00",
                    ),
                    const Divider(height: 24, color: AppColors.gray100),
                    _iconInfoRow(
                      color: AppColors.green500Normal,
                      icon: Icons.credit_card,
                      label: "PAYMENT TERMS",
                      value: invoice.paymentTermsName ?? "-",
                      subValue: invoice.dueDate != null ? "Due: ${DateFormat('dd MMM yyyy').format(invoice.dueDate!.toLocal())}" : null,
                    ),
                    const Divider(height: 24, color: AppColors.gray100),
                    _iconInfoRow(
                      color: AppColors.red500,
                      icon: Icons.monetization_on_outlined,
                      label: "PAYMENT STATUS",
                      value: invoice.paymentStatus ?? "-",
                    ),
                    const Divider(height: 24, color: AppColors.gray100),
                    _iconInfoRow(
                      color: AppColors.indigo600Main,
                      icon: Icons.person_outline,
                      label: "RECEIVER DETAILS",
                      value: invoice.receiverName ?? "-",
                      subValue: invoice.receiverMobileNumber,
                    ),
                    const Divider(height: 24, color: AppColors.gray100),
                    _addressInfoRow(
                      color: AppColors.blue500,
                      icon: Icons.location_on_outlined,
                      label: "BILLING ADDRESS",
                      addressDetails: invoice.billingAddressDetails,
                    ),
                    const Divider(height: 24, color: AppColors.gray100),
                    _addressInfoRow(
                      color: AppColors.purple500,
                      icon: Icons.inventory_2_outlined,
                      label: "SHIPPING ADDRESS",
                      addressDetails: invoice.shippingAddressDetails,
                    ),
                    if (invoice.advanceAmount != null && invoice.advanceAmount != "0.00") ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
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
                ),
              ],
            ),
          ),
        ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              if (subValue != null) ...[
                const SizedBox(height: 2),
                Text(
                  subValue,
                  style: const TextStyle(fontSize: 11, color: AppColors.gray600, fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _compactInfoCell(IconData icon, String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: AppColors.gray400),
            const SizedBox(width: 4),
            Text(
              label.toUpperCase(),
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.gray500, letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _compactBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      width: 70,
      alignment: Alignment.center,
      child: Text(
        label.isNotEmpty ? label[0].toUpperCase() + label.substring(1).toLowerCase() : "-",
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toUpperCase()) {
      case 'HIGH':
      case 'URGENT':
        return AppColors.red500;
      case 'MEDIUM':
        return AppColors.orangeColor;
      case 'LOW':
        return AppColors.green500Success;
      default:
        return AppColors.indigo600Main;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'DRAFT':
        return AppColors.gray600;
      case 'READY_TO_PICK':
        return AppColors.yellow500;
      case 'ASSIGNED':
        return AppColors.purple500;
      case 'PICKING':
        return AppColors.orangeColor;
      case 'PARTIAL':
        return AppColors.orangeColor;
      case 'PICKED':
      case 'PACKED':
        return AppColors.green500Success;
      case 'CANCELLED':
      case 'REJECT':
      case 'REJECTED':
      case 'PACKING_REJECT':
        return AppColors.red500;
      default:
        return AppColors.indigo600Main;
    }
  }

  Widget _buildRemarksSummary(PickingDetailData data) {
    String spRemarks = data.invoice?.remarks?.toString() ?? "----";
    String customerRemarks = data.invoice?.customerRemark?.toString() ?? "----";

    return InkWell(
      onTap: () => _showRemarksDetailsDialog(data),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            const Icon(Icons.assignment_outlined, color: AppColors.indigo600Main, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "SP Remarks",
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    "Remarks: $spRemarks",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Customer Remark: $customerRemarks",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.visibility_outlined, color: AppColors.indigo600Main, size: 20),
          ],
        ),
      ),
    );
  }

  void _showRemarksDetailsDialog(PickingDetailData data) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "SP Remarks Details",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                    ),
                    IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close), visualDensity: VisualDensity.compact),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconInfoRow(
                      color: AppColors.indigo600Main,
                      icon: Icons.assignment_outlined,
                      label: "REMARKS",
                      value: data.remarks?.toString() ?? "----",
                    ),
                    const Divider(height: 24, color: AppColors.gray100),
                    _iconInfoRow(
                      color: AppColors.blue500,
                      icon: Icons.person_outline,
                      label: "CUSTOMER REMARKS",
                      value: data.invoice?.customerRemark?.toString() ?? "----",
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

  Widget _buildItemCard(PickingDetailData data, Item item, int index) {
    final product = item.product;
    final bool isFullyPicked = (double.tryParse(item.pendingQty ?? "0") ?? 0) <= 0;

    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: isFullyPicked ? AppColors.green500Success.withValues(alpha: 0.05) : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isFullyPicked ? AppColors.green500Success.withValues(alpha: 0.3) : AppColors.gray200, width: 0.8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: isFullyPicked ? AppColors.green500Success : AppColors.primaryColor, shape: BoxShape.circle),
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: isFullyPicked ? AppColors.green500Success.withValues(alpha: 0.1) : AppColors.indigo600Main.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: (product?.imageUrl?.isNotEmpty ?? false)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                product!.imageUrl!.first,
                                fit: BoxFit.fill,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.inventory_2_outlined,
                                  color: isFullyPicked ? AppColors.green500Success : AppColors.indigo600Main,
                                  size: 22,
                                ),
                              ),
                            )
                          : Icon(Icons.inventory_2_outlined, color: isFullyPicked ? AppColors.green500Success : AppColors.indigo600Main, size: 22),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.productCode ?? "-",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isFullyPicked ? AppColors.green500Success : AppColors.indigo600Main,
                      ),
                    ),
                    Text(
                      (item.batchNumbers?.isNotEmpty ?? false) ? item.batchNumbers!.first : "----",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isFullyPicked ? AppColors.green500Success : AppColors.indigo600Main,
                      ),
                    ),

                    Text(
                      product?.productName ?? "-",
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: isFullyPicked ? AppColors.green500Success.withValues(alpha: 0.1) : AppColors.gray100),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _qtyColumn("Rack Name", item.rackLocation?.rackName ?? "-", size: 18),
              _qtyColumn("Order Qty", num.parse(item.orderedQty ?? "0").toInt().toString(), size: 18),
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

  Widget _qtyColumn(String label, String value, {Color? valueColor, double? size}) {
    double fontSize = size ?? 14;
    if (label.toUpperCase() == "ORDERED") {
      fontSize = 17;
    }

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
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w900, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildLogsSection(PickingDetailData detail) {
    final logs = detail.logs ?? [];
    if (logs.isEmpty) return const SizedBox.shrink();

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
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Log Note action
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text("Log Note", style: TextStyle(fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.gray200),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
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
                    (log.createdByName?.isNotEmpty ?? false) ? log.createdByName![0].toUpperCase() : "A",
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
