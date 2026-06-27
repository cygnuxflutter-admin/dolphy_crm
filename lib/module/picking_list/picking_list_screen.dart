import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/app_colors.dart';
import '../../config/app_images.dart';
import 'model/picking_list_response.dart';
import 'picking_list_controller.dart';
import 'sub_screen/picking_detail_screen.dart';

class PickingListScreen extends StatefulWidget {
  const PickingListScreen({super.key});

  @override
  State<PickingListScreen> createState() => _PickingListScreenState();
}

class _PickingListScreenState extends State<PickingListScreen> with TickerProviderStateMixin {
  final PickingListController controller = Get.find<PickingListController>();
  final ScrollController scrollController = ScrollController();
  late AnimationController _refreshIconController;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    _refreshIconController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _refreshIconController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _handleRefresh() async {
    _refreshIconController.repeat();
    controller.searchController.value.clear();
    controller.pageCount.value = 1;
    await Future.wait([controller.getPickingCounts(), controller.fetchData(page: 1, isFirstTime: true)]);
    _refreshIconController.stop();
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      controller.loadMore();
    }
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Picking List",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.selectedDate.value == null ? Icons.calendar_today_outlined : Icons.calendar_month,
                color: controller.selectedDate.value == null ? AppColors.white : AppColors.yellow500,
              ),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate.value ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  controller.selectedDate.value = picked;
                  controller.pageCount.value = 1;
                  await Future.wait([controller.getPickingCounts(), controller.fetchData(page: 1, status: null)]);
                }
              },
            ),
          ),
          Obx(
            () => controller.selectedDate.value != null
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.white),
                    onPressed: () {
                      controller.selectedDate.value = null;
                      controller.pageCount.value = 1;
                      _handleRefresh();
                    },
                  )
                : const SizedBox.shrink(),
          ),
          RotationTransition(
            turns: _refreshIconController,
            child: IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.white),
              onPressed: _handleRefresh,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildCountCards(),
          _searchBar(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildCountCards() {
    return Obx(() {
      final counts = controller.pickingCounts.value;
      final selectedIndex = controller.selectedFilterIndex.value;

      if (counts == null && controller.isCountsLoading.value) {
        return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
      }

      final items = [
        {'label': 'All PICKINGS', 'count': counts?.all ?? 0, 'index': 0, 'color': AppColors.indigo600Main},
        {'label': 'PENDING', 'count': counts?.draft ?? 0, 'index': 1, 'color': AppColors.yellow500},
        {'label': 'PARTIAL', 'count': counts?.picking ?? 0, 'index': 2, 'color': AppColors.orangeColor},
        {'label': 'PICKED', 'count': counts?.picked ?? 0, 'index': 3, 'color': AppColors.green500Success},
        {'label': 'PICKING REJECT', 'count': counts?.packingReject ?? 0, 'index': 4, 'color': AppColors.red500},
        {'label': 'REJECT', 'count': counts?.rejected ?? 0, 'index': 5, 'color': AppColors.gray600},
      ];

      return Container(
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = selectedIndex == item['index'];
            final color = item['color'] as Color;

            return GestureDetector(
              onTap: () => controller.onTabChanged(item['index'] as int),
              child: Container(
                width: 110,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? color : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? color : AppColors.gray200),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                    else
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['count'].toString(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? AppColors.white : AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['label'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.white.withOpacity(0.9) : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildList() {
    return Obx(() {
      final list = controller.pickingList;
      final isLoading = controller.isLoading.value;
      final totalCount = controller.totalCount.value;
      final error = controller.error.value;

      if (isLoading && list.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
      }

      if (error.isNotEmpty && list.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchData(page: 1),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.indigo600Main),
                child: const Text("Retry", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }

      if (list.isEmpty) {
        return Center(child: Image.asset(AppImages.noDataFound, scale: 3));
      }

      return ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.all(14),
        itemCount: list.length + (list.length < totalCount ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == list.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final data = list[index];
          return _pickingCard(data);
        },
      );
    });
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: TextField(
        controller: controller.searchController.value,
        onChanged: (value) => value.isEmpty
            ? controller.fetchData(isFirstTime: true, page: 1)
            : value.length % 3 == 0
            ? controller.searchPickingList(value)
            : null,
        decoration: InputDecoration(
          hintText: "Search Picking List...",
          prefixIcon: const Icon(Icons.search, color: AppColors.indigo600Main, size: 20),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _pickingCard(PickingListDatum data) {
    String pickingDate = "-";
    bool isPicking = data.status?.toUpperCase() == 'PICKING';

    if (data.createdAt != null && data.createdAt!.isNotEmpty) {
      try {
        DateTime date = DateTime.parse(data.createdAt!);
        // Convert to GMT+5:30 (IST)
        DateTime istDate = date.toUtc().add(const Duration(hours: 5, minutes: 30));
        pickingDate = DateFormat("dd/MM/yyyy hh:mm a").format(istDate).toLowerCase();
      } catch (e) {
        debugPrint("Error parsing date: $e");
      }
    }

    return GestureDetector(
      onTap: () => Get.to(() => PickingDetailScreen(pickingId: data.id!)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200, width: 0.8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.indigo600Main.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 16, color: AppColors.indigo600Main),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.pickingNo ?? "-",
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.indigo600Main),
                        ),
                        Text(
                          data.invoiceNo ?? "-",
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  if (data.priority != null && data.priority!.isNotEmpty) ...[
                    _compactBadge(data.priority!, _getPriorityColor(data.priority)),
                    const SizedBox(width: 6),
                  ],
                  _compactBadge(data.status ?? data.orderType ?? "-", _getStatusColor(data.status)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _compactInfoCell(Icons.person_outline, "Customer", data.customerName ?? "-")),
                      Expanded(
                        child: _compactInfoCell(Icons.calendar_today_outlined, "Date", pickingDate, valueColor: isPicking ? AppColors.red500 : null),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _compactInfoCell(Icons.person_pin_outlined, "Sales Person", data.salesPerson ?? "-")),
                      Expanded(
                        child: _compactInfoCell(
                          Icons.comment_outlined,
                          "SP Remarks",
                          (data.piRemarks == null || data.piRemarks!.isEmpty) ? "-" : data.piRemarks!,
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
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _compactBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
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
}
