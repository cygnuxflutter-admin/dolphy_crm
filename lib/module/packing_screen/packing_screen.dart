import 'package:crm/config/app_colors.dart';
import 'package:crm/config/app_routes.dart';
import 'package:crm/module/packing_screen/model/packing_list_response_model.dart';
import 'package:crm/module/packing_screen/packing_controller.dart';
import 'package:crm/module/picking_list/picking_binding.dart';
import 'package:crm/module/picking_list/sub_screen/picking_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/app_images.dart';

class PackingScreen extends GetView<PackingController> {
  const PackingScreen({super.key});

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
          "Packing List",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Column(
          children: [
            _searchBar(),
            _buildCountCards(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.packingList.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
                }
                if (controller.error.isNotEmpty && controller.packingList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
                        const SizedBox(height: 16),
                        Text(
                          controller.error.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.fetchAllData(),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.indigo600Main),
                          child: const Text("Retry", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                }
                if (controller.packingList.isEmpty) {
                  return Center(child: Image.asset(AppImages.noDataFound, scale: 3));
                }
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => controller.fetchAllData(),
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 14, left: 14, right: 14),
                          itemCount: controller.packingList.length,
                          separatorBuilder: (_, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = controller.packingList[index];
                            return _ExpandablePackingCard(item: item, index: index, controller: controller);
                          },
                        ),
                      ),
                    ),
                    _buildPagination(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountCards() {
    return Obx(() {
      final counts = controller.packingCounts.value;
      final selectedIndex = controller.selectedTabIndex.value;

      if (counts == null && controller.isLoading.value) {
        return const SizedBox(height: 80, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
      }

      final items = [
        {'label': 'All', 'count': counts?.all ?? 0, 'index': 0, 'color': AppColors.indigo600Main},
        {'label': 'NEW ORDER', 'count': counts?.readyToPack ?? 0, 'index': 1, 'color': AppColors.indigo600Main},
        {'label': 'IN PACKING', 'count': counts?.inPacking ?? 0, 'index': 2, 'color': AppColors.orangeColor},
        {'label': 'READY DISPATCH', 'count': counts?.readyForDispatch ?? 0, 'index': 4, 'color': const Color(0xFFEF5350)},
        {'label': 'INVOICE PROCESS', 'count': counts?.invoiced ?? 0, 'index': 3, 'color': const Color(0xFF66BB6A)},
        // {'label': 'REJECTED', 'count': counts?.rejected ?? 0, 'index': 5, 'color': AppColors.red500},
      ];

      return Container(
        height: 80,
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
                      BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
                    else
                      BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2)),
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
                        fontSize: 10,
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

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0, left: 14, right: 14, top: 8),
      child: TextField(
        controller: controller.searchController.value,
        onChanged: controller.onSearch,
        decoration: InputDecoration(
          hintText: "Search Packing List...",
          prefixIcon: const Icon(Icons.search, color: AppColors.indigo600Main, size: 20),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Obx(() {
      if (controller.totalPages <= 1) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.gray200, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _paginationButton(
              icon: Icons.keyboard_double_arrow_left,
              onTap: controller.currentPage.value > 1 ? () => controller.onPageChanged(1) : null,
            ),
            const SizedBox(width: 8),
            _paginationButton(
              icon: Icons.keyboard_arrow_left,
              onTap: controller.currentPage.value > 1 ? () => controller.onPageChanged(controller.currentPage.value - 1) : null,
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: AppColors.indigo600Main, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  "${controller.currentPage.value}",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _paginationButton(
              icon: Icons.keyboard_arrow_right,
              onTap: controller.currentPage.value < controller.totalPages ? () => controller.onPageChanged(controller.currentPage.value + 1) : null,
            ),
            const SizedBox(width: 8),
            _paginationButton(
              icon: Icons.keyboard_double_arrow_right,
              onTap: controller.currentPage.value < controller.totalPages ? () => controller.onPageChanged(controller.totalPages) : null,
            ),
          ],
        ),
      );
    });
  }

  Widget _paginationButton({required IconData icon, VoidCallback? onTap}) {
    bool isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Icon(icon, size: 18, color: isDisabled ? AppColors.gray300 : AppColors.gray600),
      ),
    );
  }
}

class _ExpandablePackingCard extends StatefulWidget {
  final PackingList item;
  final int index;
  final PackingController controller;

  const _ExpandablePackingCard({required this.item, required this.index, required this.controller});

  @override
  State<_ExpandablePackingCard> createState() => _ExpandablePackingCardState();
}

class _ExpandablePackingCardState extends State<_ExpandablePackingCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final controller = widget.controller;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.indigo600Main.withValues(alpha: 0.05),
                  borderRadius: _isExpanded ? const BorderRadius.vertical(top: Radius.circular(12)) : BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 28,
                      width: 28,
                      margin: const EdgeInsets.only(top: 4),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: AppColors.indigo600Main, shape: BoxShape.circle),
                      child: Text(
                        "${widget.index + 1}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.invoiceNo ?? "No Packing Number",
                            style: const TextStyle(fontSize: 16, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Text(
                                "location: ",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: AppColors.black),
                              ),
                              Text(
                                item.locationCode ?? "-",
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.indigo600Main),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              if (item.priority != null && item.priority!.isNotEmpty) _compactBadge(item.priority!, _getPriorityColor(item.priority)),
                              _compactBadge(controller.getStatusLabel(item), controller.getBadgeColor(item, controller.getStatusLabel(item))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(padding: const EdgeInsets.only(top: 4), child: _actionButton(context, item, controller)),
                  ],
                ),
              ),
              if (_isExpanded)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     _compactBadge(controller.getStatusLabel(item), controller.getBadgeColor(item, controller.getStatusLabel(item))),
                      //     if (item.isRegularInvoiceApproved != null)
                      //       _compactBadge(
                      //         item.isRegularInvoiceApproved! ? "Approved" : "Pending",
                      //         item.isRegularInvoiceApproved! ? AppColors.green500Normal : AppColors.orangeColor,
                      //       ),
                      //   ],
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.symmetric(vertical: 8),
                      //   child: Divider(height: 1, color: AppColors.gray100),
                      // ),
                      Row(
                        children: [
                          Expanded(child: _infoCell(Icons.confirmation_number_outlined, "Picking No", item.pickingNo ?? "-")),
                          Expanded(child: _infoCell(Icons.inventory_2_outlined, "Packages", "${item.totalPackages ?? 0}")),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _infoCell(Icons.receipt_long_outlined, "Inv No", item.tax_invoice_no ?? "-")),
                          Expanded(child: _infoCell(Icons.description_outlined, "PI No", item.invoiceNo ?? "-")),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _infoCell(Icons.person_outline, "Customer", item.customerName ?? "-", isFullWidth: true)),
                          Expanded(child: _infoCell(Icons.person_outline, "Sales Person", item.salesPerson ?? "-", isFullWidth: true)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _infoCell(
                              Icons.access_time,
                              "Picking Date",
                              item.createdAt != null
                                  ? DateFormat('dd/MM/yyyy hh:mm a').format(item.createdAt!.toLocal())
                                  : (item.pickingDate != null ? DateFormat('dd/MM/yyyy hh:mm a').format(item.pickingDate!.toLocal()) : "-"),
                            ),
                          ),
                          Expanded(
                            child: _infoCell(
                              Icons.access_time,
                              "Packing Date",
                              item.packingDate != null ? DateFormat('dd/MM/yyyy hh:mm a').format(item.packingDate!.toLocal()) : "-",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _infoCell(Icons.currency_rupee, "Amount", item.invoiceAmount ?? "-", valueColor: AppColors.indigo600Main)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.comment_outlined, size: 14, color: AppColors.gray400),
                              SizedBox(width: 6),
                              Text(
                                "PI Remarks",
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.gray500, letterSpacing: 0.5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.piRemarks ?? "---",
                            overflow: TextOverflow.clip,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
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

  Widget _actionButton(BuildContext context, PackingList item, PackingController controller) {
    final status = (item.status ?? "").trim().toUpperCase();
    List<PopupMenuItem<String>> menuItems = [];

    switch (status) {
      case "DRAFT":
        menuItems = [
          _buildMenuItem(value: 'view', icon: Icons.visibility_outlined, label: "View"),
          _buildMenuItem(value: 'create', icon: Icons.add, label: "Create Packing"),
          _buildMenuItem(value: 'cancel', icon: Icons.cancel_outlined, label: "Cancel", color: AppColors.red500),
          _buildMenuItem(value: 'Download', icon: Icons.download_outlined, label: "Download"),
          _buildMenuItem(value: 'view_pi', icon: Icons.download_outlined, label: "View PI"),
        ];
        break;
      case "PICKED":
        menuItems = [
          _buildMenuItem(value: 'view', icon: Icons.visibility_outlined, label: "View"),
          _buildMenuItem(value: 'start', icon: Icons.play_arrow, label: "Start Packing"),
          _buildMenuItem(value: 'reject', icon: Icons.block, label: "Reject", color: AppColors.red500),
          _buildMenuItem(value: 'Download', icon: Icons.download_outlined, label: "Download"),
          _buildMenuItem(value: 'view_pi', icon: Icons.download_outlined, label: "View PI"),
        ];
        break;
      case "INVOICED":
      case "DC_GENERATED":
        menuItems = [
          _buildMenuItem(value: 'view', icon: Icons.visibility_outlined, label: "View"),
          _buildMenuItem(value: 'view_packing_list', icon: Icons.format_list_bulleted, label: "Packing List"),
          _buildMenuItem(value: 'Download', icon: Icons.download_outlined, label: "Download"),
          _buildMenuItem(value: 'view_pi', icon: Icons.download_outlined, label: "View PI"),
        ];
        break;
      case "PACKING":
      case "PACKED":
      case "IN_PACKING":
        menuItems = [
          _buildMenuItem(value: 'view', icon: Icons.visibility_outlined, label: "View"),
          _buildMenuItem(value: 'view_packing_list', icon: Icons.format_list_bulleted, label: "Packing List"),
          _buildMenuItem(value: 'Download', icon: Icons.download_outlined, label: "Download"),
          _buildMenuItem(value: 'view_pi', icon: Icons.download_outlined, label: "View PI"),
        ];
        break;
      case "REJECTED":
        menuItems = [
          _buildMenuItem(value: 'view', icon: Icons.visibility_outlined, label: "View"),
          _buildMenuItem(value: 'view_packing_list', icon: Icons.format_list_bulleted, label: "Packing List"),
          _buildMenuItem(value: 'Download', icon: Icons.download_outlined, label: "Download"),
          _buildMenuItem(value: 'view_pi', icon: Icons.download_outlined, label: "View PI"),
        ];
        break;
    }

    if (menuItems.isEmpty) {
      return const Icon(Icons.remove_red_eye, size: 16, color: AppColors.gray400);
    }

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(Icons.more_vert, color: AppColors.indigo600Main, size: 20),
      onSelected: (value) {
        if (value == 'view') {
          if (item.status?.toUpperCase() == "PICKED") {
            Get.to(() => PickingDetailScreen(pickingId: item.id!), binding: PickingListBinding());
          } else {
            Get.toNamed(AppRoutes.packingDetailScreen, arguments: item.id);
          }
        }
        if (value == 'create') _showCreatePackingDialog(context, item.pickingId ?? item.id!, controller);
        if (value == 'cancel') _showCancelPackingDialog(context, item.id!, controller);
        if (value == 'start') _showStartPackingDialog(context, item, controller);
        if (value == 'reject') _showRejectPackingDialog(context, item.id!, controller);
        if (value == 'view_packing_list') Get.toNamed(AppRoutes.packingListScreen, arguments: item.id);
        if (value == 'Download') Get.toNamed(AppRoutes.pickingRequestDetailScreen, arguments: item.pickRequestId ?? item.pickingId ?? item.id);
        if (value == 'view_pi') {
          if (item.invoiceId != null) {
            Get.toNamed(AppRoutes.viewPiScreen, arguments: item.invoiceId);
          } else {
            Get.snackbar("Error", "Invoice ID not found", backgroundColor: Colors.red, colorText: Colors.white);
          }
        }
      },
      itemBuilder: (context) => menuItems,
    );
  }

  PopupMenuItem<String> _buildMenuItem({required String value, required IconData icon, required String label, Color? color, bool enabled = true}) {
    return PopupMenuItem<String>(
      value: value,
      enabled: enabled,
      child: Row(
        children: [
          Icon(icon, size: 16, color: enabled ? (color ?? AppColors.indigo600Main) : AppColors.gray400),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: enabled ? (color ?? AppColors.textPrimary) : AppColors.gray400, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _compactBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
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

  Widget _infoCell(IconData icon, String label, String value, {bool isFullWidth = false, Color? valueColor}) {
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
          maxLines: isFullWidth ? 2 : 1,
          overflow: isFullWidth ? TextOverflow.clip : TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }

  void _showCreatePackingDialog(BuildContext context, String id, PackingController controller) {
    final TextEditingController remarksController = TextEditingController();
    final RxBool isShrinkWrapped = false.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
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
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text("Remarks (Optional)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
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
                              child: controller.isLoading.value
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text(
                                      "Create Packing",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
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
      ),
    );
  }

  void _showCancelPackingDialog(BuildContext context, String id, PackingController controller) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.cancel_outlined, size: 28, color: AppColors.indigo600Main),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Cancel Start Packing?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "This will remove the draft packing and move the order back to New Order.",
                    style: TextStyle(fontSize: 15, color: AppColors.gray600, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            controller.deletePacking(id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orangeColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text("Yes, Cancel", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gray500.withValues(alpha: 0.8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text("Close", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: AppColors.gray400, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStartPackingDialog(BuildContext context, PackingList item, PackingController controller) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.play_circle_outline, size: 28, color: AppColors.indigo600Main),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Start Packing?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(fontSize: 15, color: AppColors.gray600, height: 1.5, fontFamily: 'Inter'),
                      children: [
                        const TextSpan(text: "Are you sure you want to start packing for "),
                        TextSpan(
                          text: item.pickingNo ?? "-",
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.gray800),
                        ),
                        const TextSpan(text: "? The order will move to In Packing."),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                                    bool success = await controller.startPacking(item.id!);
                                    if (success && Get.isDialogOpen == true) {
                                      Get.back();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.indigo600Main,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            child: controller.isLoading.value
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text("Yes, Start Packing", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gray100,
                            foregroundColor: AppColors.gray700,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text("Close", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: AppColors.gray400, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectPackingDialog(BuildContext context, String id, PackingController controller) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rejecting the packing will revert stock to BOOKED and re-open the Pick Request for a fresh picking cycle.",
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      text: const TextSpan(
                        text: "Rejection Reason ",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        children: [
                          TextSpan(
                            text: "*",
                            style: TextStyle(color: AppColors.red500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: reasonController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Enter rejection reason...",
                        hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.gray300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.gray300),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.red500),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.red500),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a rejection reason';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(
                          () => Expanded(
                            child: SizedBox(
                              height: 44,
                              child: TextButton(
                                onPressed: controller.isLoading.value ? null : () => Navigator.of(context).pop(),
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.indigo50,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Obx(
                          () => Expanded(
                            child: GestureDetector(
                              onTap: controller.isLoading.value
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        controller.rejectPacking(id, reason: reasonController.text);
                                      }
                                    },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.red500),
                                height: 44,
                                child: controller.isLoading.value
                                    ? const Center(
                                        child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                                      )
                                    : const Text(
                                        "Confirm",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                              ),
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
      ),
    );
  }
}
