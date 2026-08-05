import 'package:crm/module/packing_screen/model/physical_box_status_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../model/box_config_model.dart';
import '../model/box_suggestion_response_model.dart';
import '../model/packing_list_detail_response_model.dart';
import '../packing_controller.dart';

class PackingListScreen extends GetView<PackingController> {
  const PackingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String id = Get.arguments;

    // Call API only if needed, and after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.packingListDetail.value?.id != id && !controller.isListDetailLoading.value) {
        controller.getPackingListDetail(id);
      }
      controller.fetchEWayBillRequiredData();
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
        title: Obx(() {
          final data = controller.packingListDetail.value;
          return Text(
            data != null ? "View Packing List: ${data.packingNo}" : "View Packing List",
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.white, fontSize: 16),
          );
        }),
      ),
      body: Obx(() {
        if (controller.isListDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.listDetailError.value.isNotEmpty) {
          return Center(child: Text(controller.listDetailError.value));
        }
        final data = controller.packingListDetail.value;
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
                        _buildHeaderCard(data),
                        const SizedBox(height: 16),
                        _buildCustomerAndSummaryGrid(data),
                        const SizedBox(height: 20),
                        _buildBoxSuggestionsSection(context, data),
                        const SizedBox(height: 20),
                        _buildPhysicalBoxDetailsSection(context, data),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => controller.saveBoxConfigs(),
                  icon: const Icon(Icons.save, color: Colors.white, size: 20),
                  label: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.indigo600Main,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
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

  Widget _buildHeaderCard(PackingListDetailData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: Get.width,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200, width: 0.8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.packingNo ?? "-",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.indigo600Main),
          ),
          Text(
            data.packingDate != null ? DateFormat('dd MMM yyyy').format(data.packingDate!.toLocal()) : "-",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerAndSummaryGrid(PackingListDetailData data) {
    return Column(
      children: [
        // Customer Information Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gray200, width: 0.8),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.business, color: AppColors.indigo600Main, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "CUSTOMER INFORMATION".toUpperCase(),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: 0.5),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, color: AppColors.gray100),
              ),
              _buildDetailRow("Company Name", data.customer?.companyName ?? data.customerName ?? "-"),
              const SizedBox(height: 8),
              _buildDetailRow("Contact", "${data.customer?.contactName ?? "-"} | ${data.customer?.mobile1 ?? "-"}"),
              const SizedBox(height: 8),
              _buildDetailRow("Email", data.customer?.email ?? "-"),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Summary Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gray200, width: 0.8),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.summarize_outlined, color: AppColors.indigo600Main, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "SUMMARY".toUpperCase(),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: 0.5),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, color: AppColors.gray100),
              ),
              Obx(() {
                final suggestionSummary = controller.boxSuggestionData.value?.summary;
                int totalProducts = suggestionSummary?.totalProducts ?? data.items?.length ?? 0;
                int totalPackedQty = suggestionSummary?.totalPackedQty ?? 0;
                int totalSuggestedBoxes = suggestionSummary?.totalSuggestedBoxes ?? 0;

                if (suggestionSummary == null) {
                  totalPackedQty = 0;
                  totalSuggestedBoxes = 0;
                  for (var item in data.items ?? []) {
                    final double pq = double.tryParse(item.packedQty ?? "0") ?? 0;
                    totalPackedQty += pq.toInt();

                    final int perBox = item.product?.perBoxItemCount ?? 1;
                    final int basePerBox = perBox > 0 ? perBox : 1;
                    totalSuggestedBoxes += (pq / basePerBox).ceil();
                  }
                }

                return Column(
                  children: [
                    _buildSummaryRow("Total Products:", "$totalProducts"),
                    const SizedBox(height: 8),
                    _buildSummaryRow("Total Packed Qty:", "$totalPackedQty"),
                    const SizedBox(height: 8),
                    _buildSummaryRow("Total Suggested Boxes:", "$totalSuggestedBoxes"),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      "Actual Boxes:",
                      "${controller.boxConfigs.fold(0, (sum, config) => sum + (config.toBox - config.fromBox + 1).clamp(1, 99999))}",
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildBoxSuggestionsSection(BuildContext context, PackingListDetailData data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200, width: 0.8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.grid_view_outlined, color: AppColors.indigo600Main, size: 18),
                const SizedBox(width: 8),
                const Text(
                  "Box Suggestion Details",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.gray100),
          Obx(() {
            controller.boxConfigs.length;
            final suggestionItems = controller.boxSuggestionData.value?.items;

            if (suggestionItems != null && suggestionItems.isNotEmpty) {
              final items = List<BoxSuggestionItem>.from(suggestionItems);
              items.sort((a, b) => (a.productName ?? "").toLowerCase().compareTo((b.productName ?? "").toLowerCase()));

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (int i = 0; i < items.length; i++) ...[
                      _buildSuggestionItemCard(items[i], i + 1),
                      if (i < items.length - 1) const SizedBox(height: 16),
                    ],
                  ],
                ),
              );
            }

            final items = List<PackingListDataItem>.from(data.items ?? []);
            items.sort((a, b) => (a.product?.productName ?? "").toLowerCase().compareTo((b.product?.productName ?? "").toLowerCase()));

            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("No items available", style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.7), fontSize: 12)),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    _buildSuggestionItemCard(items[i], i + 1),
                    if (i < items.length - 1) const SizedBox(height: 16),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSuggestionItemCard(dynamic item, int index) {
    String productName = "-";
    String productCode = "-";
    String imageUrl = "";
    int packedQty = 0;
    int perBoxCount = 1;
    int fullBoxes = 0;
    int remaining = 0;
    int suggestedBoxes = 0;
    int physicallyPacked = 0;
    int actualBox = 0;
    String breakdown = "";
    String? productId;

    if (item is BoxSuggestionItem) {
      productId = item.productId;
      productName = item.productName ?? "-";
      productCode = item.productCode ?? "-";
      imageUrl = item.imageUrl ?? "";
      packedQty = item.packedQty ?? 0;
      perBoxCount = item.perBoxCount ?? 1;
      fullBoxes = item.fullBoxes ?? 0;
      remaining = item.remainingItems ?? 0;
      suggestedBoxes = item.suggestedBoxes ?? 0;
      physicallyPacked = controller.getPhysicallyPackedQty(productId ?? "");
      actualBox = item.actualBoxes ?? controller.getActualBoxesForProduct(productId ?? "");
      breakdown = item.boxBreakdown ?? "";
    } else if (item is PackingListDataItem) {
      productId = item.product?.id;
      productName = item.product?.productName ?? "-";
      productCode = item.product?.productCode ?? "-";
      imageUrl = item.product?.imageUrl ?? "";
      final double pqDouble = double.tryParse(item.packedQty ?? "0") ?? 0;
      packedQty = item.packedQty != null ? pqDouble.toInt() : (item.orderedQty ?? 0);
      perBoxCount = item.perBoxCount ?? item.product?.perBoxItemCount ?? 1;
      fullBoxes = item.fullBoxes ?? (packedQty ~/ (perBoxCount > 0 ? perBoxCount : 1));
      remaining = item.remainingItems ?? (packedQty % (perBoxCount > 0 ? perBoxCount : 1));
      suggestedBoxes = item.suggestedBoxes ?? (packedQty / (perBoxCount > 0 ? perBoxCount : 1)).ceil();
      physicallyPacked = controller.getPhysicallyPackedQty(productId ?? "");
      actualBox = item.actualBoxes ?? controller.getActualBoxesForProduct(productId ?? "");
      breakdown = item.boxBreakdown ?? "";
      if (breakdown.isEmpty) {
        final int bpb = perBoxCount > 0 ? perBoxCount : 1;
        if (remaining > 0) {
          breakdown = "$fullBoxes box(es) × $bpb + 1 box × $remaining = $packedQty items";
        } else {
          breakdown = "$suggestedBoxes box(es) × $bpb items each = ${suggestedBoxes * bpb} items";
        }
      }
    }

    final int basePerBox = perBoxCount > 0 ? perBoxCount : 1;
    final int pendingPack = packedQty - physicallyPacked;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Index, Image, Name
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.indigo600Main, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    "#$index",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 24, color: AppColors.gray400),
                        )
                      : const Icon(Icons.image_not_supported, size: 24, color: AppColors.gray400),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        productCode,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.indigo600Main),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.gray200),
          // Stats Grid
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _itemStat("Packed Qty", "$packedQty")),
                    Expanded(child: _itemStat("Per Box Count", "$basePerBox")),
                    Expanded(child: _itemStat("Full Boxes", "$fullBoxes")),
                    Expanded(child: _itemStat("Remaining", "$remaining")),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _itemStat("Suggested Boxes", "$suggestedBoxes")),
                    Expanded(
                      child: _itemStat(
                        "Physically Packed",
                        "$physicallyPacked",
                        valueColor: physicallyPacked >= packedQty ? AppColors.green500Success : AppColors.orangeColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _itemStat("Actual Boxes", "$actualBox", isBordered: true)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "PENDING PACK",
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          physicallyPacked >= packedQty
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.green500Success, borderRadius: BorderRadius.circular(4)),
                                  child: const Text(
                                    "Completed",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.red500, borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                    "$pendingPack Left",
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Footer: Breakdown
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Box Breakdown: $breakdown",
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemStat(String label, String value, {Color? valueColor, bool isBordered = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textSecondary, letterSpacing: 0.3),
        ),
        const SizedBox(height: 4),
        isBordered
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.indigo600Main.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.indigo600Main),
                ),
              )
            : Text(
                value,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: valueColor ?? AppColors.textPrimary),
              ),
      ],
    );
  }

  Widget _buildPhysicalBoxDetailsSection(BuildContext context, PackingListDetailData data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200, width: 0.8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.archive_outlined, color: AppColors.indigo600Main, size: 18),
                const SizedBox(width: 8),
                const Text(
                  "Physical Box Details",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.gray100),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  bool allItemsCompleted = (data.items ?? []).every((item) {
                    final double pqDouble = double.tryParse(item.packedQty ?? "0") ?? 0;
                    final int packedQty = pqDouble.toInt();
                    final int physicallyPacked = controller.getPhysicallyPackedQty(item.product?.id ?? "");
                    return physicallyPacked >= packedQty;
                  });

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: allItemsCompleted ? null : () => controller.autoFillWithAI(data),
                        icon: Icon(Icons.psychology, color: allItemsCompleted ? AppColors.gray600 : Colors.white, size: 16),
                        label: Text(
                          "Auto-Fill With AI",
                          style: TextStyle(color: allItemsCompleted ? AppColors.gray600 : Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.indigo600Light,
                          disabledBackgroundColor: AppColors.gray300,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: allItemsCompleted ? null : () => _showBoxConfigBottomSheet(context, data),
                        icon: Icon(Icons.add, color: allItemsCompleted ? AppColors.gray600 : Colors.white, size: 16),
                        label: Text(
                          "Create Box Config",
                          style: TextStyle(color: allItemsCompleted ? AppColors.gray600 : Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.indigo600Main,
                          disabledBackgroundColor: AppColors.gray300,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 16),
                // PACKING STATUS Header
                const Text(
                  "PACKING STATUS",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  // Register boxConfigs dependency
                  controller.boxConfigs.length;
                  final summary = List<ProductSummary>.from(controller.productSummary);
                  summary.sort((a, b) => (a.productName ?? "").toLowerCase().compareTo((b.productName ?? "").toLowerCase()));

                  final items = List<PackingListDataItem>.from(data.items ?? []);
                  items.sort((a, b) => (a.product?.productName ?? "").toLowerCase().compareTo((b.product?.productName ?? "").toLowerCase()));

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: summary.isNotEmpty ? summary.length : items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      String productName = "-";
                      String imageUrl = "";
                      int packedQty = 0;
                      int totalOrdered = 0;
                      bool isDone = false;

                      if (summary.isNotEmpty) {
                        final s = summary[index];
                        productName = s.productName ?? "-";
                        packedQty = s.totalQtyPacked ?? 0;
                        totalOrdered = s.totalQtyOrdered ?? 0;
                        isDone = s.status == "COMPLETED";
                        // Find matching item for image
                        final matchingItem = items.firstWhereOrNull((i) => i.product?.id == s.productId);
                        imageUrl = matchingItem?.product?.imageUrl ?? "";
                      } else {
                        final item = items[index];
                        productName = item.product?.productName ?? "-";
                        imageUrl = item.product?.imageUrl ?? "";
                        totalOrdered = (double.tryParse(item.packedQty ?? "0") ?? 0).toInt();
                        packedQty = controller.getPhysicallyPackedQty(item.product?.id ?? "");
                        isDone = packedQty >= totalOrdered;
                      }

                      final double progress = totalOrdered > 0 ? (packedQty / totalOrdered).clamp(0.0, 1.0) : 0.0;

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.gray50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.gray200, width: 0.6),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 36,
                                height: 36,
                                color: AppColors.gray200,
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const Center(
                                            child: SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5)),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.image_not_supported, size: 16, color: AppColors.gray400);
                                        },
                                      )
                                    : const Icon(Icons.widgets_outlined, size: 16, color: AppColors.gray400),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            minHeight: 6,
                                            backgroundColor: AppColors.gray200,
                                            valueColor: AlwaysStoppedAnimation<Color>(isDone ? AppColors.green500Success : AppColors.indigo600Light),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "$packedQty/$totalOrdered",
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (isDone)
                              const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, color: AppColors.green500Success, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    "Done",
                                    style: TextStyle(color: AppColors.green500Success, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            else
                              const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.pending, color: AppColors.orangeColor, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    "Pending",
                                    style: TextStyle(color: AppColors.orangeColor, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }),
                const SizedBox(height: 24),
                // BOX CONFIGURATIONS
                const Text(
                  "BOX CONFIGURATIONS",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  if (controller.boxConfigs.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      alignment: Alignment.center,
                      child: Text(
                        "No box configurations created yet.",
                        style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.7), fontSize: 12),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.boxConfigs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final config = controller.boxConfigs[index];
                      final int numBoxes = (config.toBox - config.fromBox + 1).clamp(1, 99999);
                      final String boxTitle = numBoxes > 1 ? "Boxes ${config.fromBox} - ${config.toBox}" : "Box ${config.fromBox}";

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
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        boxTitle,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.indigo600Main),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Qty: $numBoxes box(es) • ${config.weight.toStringAsFixed(3)} kg",
                                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _showBoxConfigBottomSheet(context, data, config: config, index: index),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(color: AppColors.indigo600Main, borderRadius: BorderRadius.circular(4)),
                                    child: const Icon(Icons.edit, size: 14, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => controller.deleteBoxConfig(config.id),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(color: AppColors.red100, borderRadius: BorderRadius.circular(4)),
                                    child: const Icon(Icons.delete, size: 14, color: AppColors.red500),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20, color: AppColors.gray100),
                            ...(() {
                              final sortedBoxItems = List<BoxConfigItem>.from(config.items);
                              sortedBoxItems.sort((a, b) => a.productName.toLowerCase().compareTo(b.productName.toLowerCase()));
                              return sortedBoxItems.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: AppColors.green500Success, size: 14),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "${item.productName} (${item.qty} pc/box)",
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            })(),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBoxConfigBottomSheet(BuildContext context, PackingListDetailData data, {BoxConfiguration? config, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BoxConfigBottomSheet(detailData: data, config: config, index: index),
        );
      },
    );
  }
}

class BoxConfigBottomSheet extends StatefulWidget {
  final PackingListDetailData detailData;
  final BoxConfiguration? config;
  final int? index;

  const BoxConfigBottomSheet({super.key, required this.detailData, this.config, this.index});

  @override
  State<BoxConfigBottomSheet> createState() => _BoxConfigBottomSheetState();
}

class _ItemRow {
  String productId;
  String productName;
  TextEditingController qtyController;

  _ItemRow({required this.productId, required this.productName, required int qty}) : qtyController = TextEditingController(text: qty.toString());
}

class _BoxConfigBottomSheetState extends State<BoxConfigBottomSheet> {
  late TextEditingController fromBoxController;
  late TextEditingController toBoxController;
  late TextEditingController lengthController;
  late TextEditingController widthController;
  late TextEditingController heightController;
  late TextEditingController netWeightController;
  late TextEditingController grossWeightController;
  late TextEditingController remarksController;
  late String dimUom;
  late String weightUom;
  final List<_ItemRow> selectedItems = [];

  @override
  void initState() {
    super.initState();
    final bool isEdit = widget.config != null;
    final String defaultBoxVal = isEdit ? widget.config!.fromBox.toString() : (widget.index != null ? (widget.index! + 1).toString() : "1");
    final String defaultToBoxVal = isEdit ? widget.config!.toBox.toString() : (widget.index != null ? (widget.index! + 1).toString() : "1");
    fromBoxController = TextEditingController(text: defaultBoxVal);
    toBoxController = TextEditingController(text: defaultToBoxVal);
    lengthController = TextEditingController(text: isEdit ? widget.config!.length.toString() : "0");
    widthController = TextEditingController(text: isEdit ? widget.config!.width.toString() : "0");
    heightController = TextEditingController(text: isEdit ? widget.config!.height.toString() : "0");
    netWeightController = TextEditingController(text: isEdit ? widget.config!.netWeight.toStringAsFixed(3) : "0.000");
    grossWeightController = TextEditingController(text: isEdit ? widget.config!.grossWeight.toStringAsFixed(3) : "0.000");
    remarksController = TextEditingController(text: isEdit ? widget.config!.remarks : "");
    dimUom = isEdit ? widget.config!.dimUom : "cm";
    weightUom = isEdit ? widget.config!.weightUom : "kg";

    if (isEdit) {
      for (var item in widget.config!.items) {
        final row = _ItemRow(productId: item.productId, productName: item.productName, qty: item.qty);
        row.qtyController.addListener(_onFieldChanged);
        selectedItems.add(row);
      }
    } else {
      final firstItem = widget.detailData.items?.firstOrNull;
      final row = _ItemRow(productId: firstItem?.product?.id ?? "", productName: firstItem?.product?.productName ?? "", qty: 1);
      row.qtyController.addListener(_onFieldChanged);
      selectedItems.add(row);
    }

    fromBoxController.addListener(_onFieldChanged);
    toBoxController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    fromBoxController.dispose();
    toBoxController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    netWeightController.dispose();
    grossWeightController.dispose();
    remarksController.dispose();
    for (var row in selectedItems) {
      row.qtyController.dispose();
    }
    super.dispose();
  }

  void _onFieldChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _addItemRow() {
    final firstItem = widget.detailData.items?.firstOrNull;
    final row = _ItemRow(productId: firstItem?.product?.id ?? "", productName: firstItem?.product?.productName ?? "", qty: 1);
    row.qtyController.addListener(_onFieldChanged);
    setState(() {
      selectedItems.add(row);
    });
  }

  Widget _buildFieldLabelColumn(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.config != null;
    final int from = int.tryParse(fromBoxController.text) ?? 1;
    final int to = int.tryParse(toBoxController.text) ?? 1;
    final int numBoxes = (to - from + 1).clamp(0, 99999);

    int totalQtyPerBox = 0;
    for (var row in selectedItems) {
      totalQtyPerBox += int.tryParse(row.qtyController.text) ?? 0;
    }
    final int totalItems = numBoxes * totalQtyPerBox;

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isEdit ? "Edit Box Configuration" : "Create Box Configuration",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 20, color: AppColors.gray400),
              ),
            ],
          ),
          const Divider(height: 1, color: AppColors.gray200),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "From Box *",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: fromBoxController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "To Box *",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: toBoxController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              children: [
                const TextSpan(text: "Creating "),
                TextSpan(
                  text: "$numBoxes",
                  style: const TextStyle(color: AppColors.indigo600Main, fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: " boxes"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Dimensions & Weight",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildFieldLabelColumn("Length", lengthController)),
              const SizedBox(width: 8),
              Expanded(child: _buildFieldLabelColumn("Width", widthController)),
              const SizedBox(width: 8),
              Expanded(child: _buildFieldLabelColumn("Height", heightController)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dim. UOM",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gray300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dimUom,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                          style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                          items: ["cm", "mm", "inch"].map((uom) {
                            return DropdownMenuItem(value: uom, child: Text(uom));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => dimUom = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildFieldLabelColumn("Net Weight", netWeightController)),
              const SizedBox(width: 8),
              Expanded(child: _buildFieldLabelColumn("Gross Weight", grossWeightController)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Weight UOM",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 38,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gray300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: weightUom,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                          style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                          items: ["g", "kg"].map((uom) {
                            return DropdownMenuItem(value: uom, child: Text(uom));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => weightUom = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Remarks",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: remarksController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Enter remarks for this box configuration...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Box Contents *",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, itemIdx) {
              final row = selectedItems[itemIdx];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Product *",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 38,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.gray300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: row.productId.isEmpty ? null : row.productId,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                              style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                              items: (widget.detailData.items ?? []).map((item) {
                                final String pid = item.product?.id ?? "";
                                final String name = item.product?.productName ?? "";
                                return DropdownMenuItem(
                                  value: pid,
                                  child: Text(name, overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  final prod = widget.detailData.items?.firstWhereOrNull((i) => i.product?.id == val);
                                  setState(() {
                                    row.productId = val;
                                    row.productName = prod?.product?.productName ?? "";
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Qty Per Box *",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 38,
                          child: TextField(
                            controller: row.qtyController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            ),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (selectedItems.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 18, left: 4),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.red500, size: 20),
                        onPressed: () {
                          setState(() {
                            selectedItems.removeAt(itemIdx);
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            "Total: $numBoxes boxes * $totalQtyPerBox = $totalItems items",
            style: const TextStyle(fontSize: 11, color: AppColors.indigo600Main, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _addItemRow,
            icon: const Icon(Icons.add, size: 14, color: AppColors.indigo600Main),
            label: const Text(
              "Add Another Item",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.indigo600Main),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
          const Divider(height: 32, color: AppColors.gray200),
          if (isEdit)
            OutlinedButton.icon(
              onPressed: () {
                Get.find<PackingController>().deleteBoxConfig(widget.config!.id);
                Navigator.pop(context);
                Get.snackbar("Success", "Box configuration deleted", backgroundColor: Colors.red, colorText: Colors.white);
              },
              icon: const Icon(Icons.delete, size: 16, color: AppColors.red500),
              label: const Text(
                "Delete",
                style: TextStyle(color: AppColors.red500, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.red500),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          SizedBox(height: 20),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
                child: const Text("Cancel"),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  List<BoxConfigItem> boxItems = [];
                  for (var row in selectedItems) {
                    final int qty = int.tryParse(row.qtyController.text) ?? 0;
                    if (qty > 0 && row.productId.isNotEmpty) {
                      boxItems.add(BoxConfigItem(productId: row.productId, productName: row.productName, qty: qty));
                    }
                  }

                  if (boxItems.isEmpty) {
                    Get.snackbar("Error", "Please add at least one product with quantity", backgroundColor: Colors.red, colorText: Colors.white);
                    return;
                  }

                  final String bName = isEdit ? widget.config!.boxName : "Box ${Get.find<PackingController>().boxConfigs.length + 1}";

                  final updatedConfig = BoxConfiguration(
                    id: isEdit ? widget.config!.id : "${DateTime.now().millisecondsSinceEpoch}",
                    boxName: bName,
                    weight: double.tryParse(grossWeightController.text) ?? 500.0,
                    fromBox: int.tryParse(fromBoxController.text) ?? 1,
                    toBox: int.tryParse(toBoxController.text) ?? 1,
                    length: double.tryParse(lengthController.text) ?? 100.0,
                    width: double.tryParse(widthController.text) ?? 100.0,
                    height: double.tryParse(heightController.text) ?? 100.0,
                    dimUom: dimUom,
                    netWeight: double.tryParse(netWeightController.text) ?? 500.0,
                    grossWeight: double.tryParse(grossWeightController.text) ?? 500.0,
                    weightUom: weightUom,
                    remarks: remarksController.text,
                    items: boxItems,
                  );

                  if (isEdit) {
                    Get.find<PackingController>().updatePhysicalBoxConfig(packingId: widget.detailData.id ?? "", config: updatedConfig).then((
                      success,
                    ) {
                      if (success) {
                        Navigator.pop(context);
                      }
                    });
                  } else {
                    Get.find<PackingController>().addBoxConfig(updatedConfig);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.indigo600Main,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "Save Configuration",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
