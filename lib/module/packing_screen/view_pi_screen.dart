import 'package:crm/config/app_colors.dart';
import 'package:crm/module/packing_screen/model/invoice_data_response_model.dart';
import 'package:crm/module/packing_screen/view_pi_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewPiScreen extends GetView<ViewPiController> {
  const ViewPiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.indigo600Main,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Proforma Invoice",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }
        if (controller.invoiceData.value == null) {
          return const Center(child: Text("No Data Found"));
        }

        final data = controller.invoiceData.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(data),
              const SizedBox(height: 16),
              _buildAddressSection(data),
              const SizedBox(height: 24),
              const Text(
                "Items Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              _buildItemsSection(data),
              const SizedBox(height: 24),
              _buildSummarySection(data),
              const SizedBox(height: 16),
              _buildRemarksSection(data),
              const SizedBox(height: 16),
              _buildAmountInWords(data),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(InvoiceData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Invoice No", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(data.invoiceNo ?? "-", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Date", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(
                data.invoiceDate != null ? DateFormat('dd MMM yyyy').format(data.invoiceDate!) : "-",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(InvoiceData data) {
    return Column(
      children: [
        _buildAddressCard(
          title: "To (Billing Address)",
          companyName: data.billingAddressDetail?.companyName ?? "-",
          address:
              "${data.billingAddressDetail?.street ?? ""}, ${data.billingAddressDetail?.cityName ?? ""}, ${data.billingAddressDetail?.stateName ?? ""} - ${data.billingAddressDetail?.pincodeName ?? ""}",
          contact:
              "${(data.billingAddressDetail?.contactName ?? "").toLowerCase().startsWith('mr') ? '' : 'Mr. '}${data.billingAddressDetail?.contactName ?? "-"} - ${data.customerMobile ?? ""}",
          gst: (data.customerGstNumber?.isNotEmpty ?? false) ? "GST: ${data.customerGstNumber}" : null,
          extra: "State Name: ${data.customerState ?? ""}, Code: ${data.billingAddressDetail?.stateCode ?? ""}",
          icon: Icons.receipt_long,
          iconColor: Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildAddressCard(
          title: "Ship To (Shipping Address)",
          companyName: data.shippingAddressDetail?.companyName ?? "-",
          address:
              "${data.shippingAddressDetail?.street ?? ""}, ${data.shippingAddressDetail?.cityName ?? ""}, ${data.shippingAddressDetail?.stateName ?? ""} - ${data.shippingAddressDetail?.pincodeName ?? ""}",
          contact:
              "${(data.shippingAddressDetail?.contactName ?? "").toLowerCase().startsWith('mr') ? '' : 'Mr. '}${data.shippingAddressDetail?.contactName ?? "-"} - ${data.receiverMobileNumber ?? ""}",
          icon: Icons.local_shipping,
          iconColor: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildAddressCard({
    required String title,
    required String companyName,
    required String address,
    required String contact,
    String? gst,
    String? extra,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            companyName,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(address, style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4)),
          const SizedBox(height: 4),
          Text(contact, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          if (gst != null) ...[
            const SizedBox(height: 4),
            Text(
              gst,
              style: const TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
          if (extra != null) ...[const SizedBox(height: 4), Text(extra, style: TextStyle(fontSize: 12, color: Colors.grey[600]))],
        ],
      ),
    );
  }

  Widget _buildItemsSection(InvoiceData data) {
    if (data.items == null) return const SizedBox.shrink();
    return Column(children: data.items!.map((item) => _buildProductItem(item)).toList());
  }

  Widget _buildProductItem(Item item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
            child: (item.imageUrl?.isNotEmpty ?? false)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported, size: 24, color: Colors.grey),
                    ),
                  )
                : const Icon(Icons.image_not_supported, size: 24, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.productName ?? "-",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "₹ ${double.tryParse(item.taxableAmount?.toString() ?? "0")?.toStringAsFixed(2) ?? "0.00"}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text("Code: ${item.productCode ?? ""} | HSN: ${item.hsnCode ?? ""}", style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag("Qty: ${item.quantity ?? "0"}", Colors.blue[50]!, Colors.blue[700]!),
                    _buildTag("Rate: ₹ ${item.unitPrice ?? "0"}", Colors.green[50]!, Colors.green[700]!),
                    if (double.tryParse(item.igst.toString()) != null && (double.tryParse(item.igst.toString()) ?? 0) > 0)
                      _buildTag("IGST: ${item.igst}%", Colors.orange[50]!, Colors.orange[700]!),
                    if (double.tryParse(item.cgst.toString()) != null && (double.tryParse(item.cgst.toString()) ?? 0) > 0)
                      _buildTag("CGST: ${item.cgst}%", Colors.orange[50]!, Colors.orange[700]!),
                    if (double.tryParse(item.sgst.toString()) != null && (double.tryParse(item.sgst.toString()) ?? 0) > 0)
                      _buildTag("SGST: ${item.sgst}%", Colors.orange[50]!, Colors.orange[700]!),
                    if ((double.tryParse(item.igst.toString()) ?? 0) <= 0 && (double.tryParse(item.cgst.toString()) ?? 0) <= 0)
                      _buildTag("GST: ${item.taxPercentage ?? "0"}%", Colors.orange[50]!, Colors.orange[700]!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSummarySection(InvoiceData data) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹ ');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _summaryRow("Subtotal", currencyFormat.format(double.tryParse(data.totalTaxableAmount ?? "0") ?? 0), Colors.black54),
          const SizedBox(height: 12),
          if (data.charges != null)
            ...data.charges!.map((charge) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _summaryRow(charge.chargeName ?? "", currencyFormat.format(double.tryParse(charge.amount ?? "0") ?? 0), Colors.black54),
              );
            }),
          if ((data.freightCharge ?? 0) > 0 && !(data.charges?.any((c) => (c.chargeName ?? "").toLowerCase().contains("freight")) ?? false)) ...[
            _summaryRow("Freight Charges", currencyFormat.format(data.freightCharge!.toDouble()), Colors.black54),
            const SizedBox(height: 12),
          ],
          if (double.tryParse(data.totalIgstAmount ?? "0")! > 0) ...[
            _summaryRow("IGST", currencyFormat.format(double.tryParse(data.totalIgstAmount ?? "0") ?? 0), Colors.black54),
            const SizedBox(height: 12),
          ],
          if (double.tryParse(data.totalCgstAmount ?? "0")! > 0) ...[
            _summaryRow("CGST", currencyFormat.format(double.tryParse(data.totalCgstAmount ?? "0") ?? 0), Colors.black54),
            const SizedBox(height: 12),
          ],
          if (double.tryParse(data.totalSgstAmount ?? "0")! > 0) ...[
            _summaryRow("SGST", currencyFormat.format(double.tryParse(data.totalSgstAmount ?? "0") ?? 0), Colors.black54),
            const SizedBox(height: 12),
          ],
          const Divider(height: 24, thickness: 1),
          _summaryRow(
            "Final Total",
            currencyFormat.format(double.tryParse(data.finalTotalAmount ?? "0") ?? 0),
            AppColors.indigo600Main,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color color, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: color, fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          value,
          style: TextStyle(color: color, fontSize: isTotal ? 20 : 15, fontWeight: isTotal ? FontWeight.bold : FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRemarksSection(InvoiceData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PI Remarks",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue),
          ),
          const SizedBox(height: 4),
          Text(
            (data.remarks == null || data.remarks.toString().isEmpty) ? "---" : data.remarks.toString(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInWords(InvoiceData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Amount in words",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue),
          ),
          const SizedBox(height: 4),
          Text(
            _numberToWords(double.tryParse(data.finalTotalAmount ?? "0") ?? 0),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  String _numberToWords(double amount) {
    if (amount == 0) return "Zero Rupees Only";

    int totalPaise = (amount * 100).round();
    int rupees = totalPaise ~/ 100;
    int paise = totalPaise % 100;

    final units = [
      "",
      "One",
      "Two",
      "Three",
      "Four",
      "Five",
      "Six",
      "Seven",
      "Eight",
      "Nine",
      "Ten",
      "Eleven",
      "Twelve",
      "Thirteen",
      "Fourteen",
      "Fifteen",
      "Sixteen",
      "Seventeen",
      "Eighteen",
      "Nineteen",
    ];
    final tens = ["", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"];

    String formatThreeDigits(int n) {
      String res = "";
      if (n >= 100) {
        res += "${units[n ~/ 100]} Hundred ";
        n %= 100;
      }
      if (n > 0) {
        if (res.isNotEmpty) res += "and ";
        if (n < 20) {
          res += units[n];
        } else {
          res += tens[n ~/ 10];
          if (n % 10 > 0) res += " ${units[n % 10]}";
        }
      }
      return res.trim();
    }

    String convertToWords(int n) {
      if (n == 0) return "";
      String res = "";
      if (n >= 10000000) {
        res += "${formatThreeDigits(n ~/ 10000000)} Crore ";
        n %= 10000000;
      }
      if (n >= 100000) {
        res += "${formatThreeDigits(n ~/ 100000)} Lakh ";
        n %= 100000;
      }
      if (n >= 1000) {
        res += "${formatThreeDigits(n ~/ 1000)} Thousand ";
        n %= 1000;
      }
      if (n > 0) {
        res += formatThreeDigits(n);
      }
      return res.trim();
    }

    String result = "";
    if (rupees > 0) {
      result += "${convertToWords(rupees)} Rupees";
    }
    if (paise > 0) {
      if (result.isNotEmpty) result += " and ";
      result += "${convertToWords(paise)} Paise";
    }

    return "${result.trim()} Only";
  }
}
