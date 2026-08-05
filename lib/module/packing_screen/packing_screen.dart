import 'package:crm/config/app_colors.dart';
import 'package:crm/config/app_routes.dart';
import 'package:crm/module/packing_screen/model/packing_list_response_model.dart';
import 'package:crm/module/packing_screen/model/transport_mode_responce_model.dart';
import 'package:crm/module/packing_screen/model/vendor_responce_model.dart';
import 'package:crm/module/packing_screen/packing_controller.dart';
import 'package:crm/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../widget/dropdown.dart';

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
            _buildCountCards(),
            _searchBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.packingList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.error.isNotEmpty && controller.packingList.isEmpty) {
                  return Center(child: Text(controller.error.value));
                }
                if (controller.packingList.isEmpty) {
                  return const Center(child: Text("No Data Found"));
                }
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => controller.fetchData(),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.packingList.length,
                          separatorBuilder: (_, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = controller.packingList[index];
                            return _buildPackingCard(context, item);
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
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Obx(() {
        final counts = controller.packingCounts.value;
        final selectedIndex = controller.selectedTabIndex.value;
        final List<Map<String, dynamic>> tabs = [
          {"label": "ALL", "count": counts?.all ?? 0, "icon": Icons.playlist_add_check, "color": AppColors.gray500},
          {"label": "NEW ORDER", "count": counts?.readyToPack ?? 0, "icon": Icons.add, "color": const Color(0xFF5C6BC0)},
          {"label": "IN PACKING", "count": counts?.inPacking ?? 0, "icon": Icons.schedule, "color": const Color(0xFF26C6DA)},
          {"label": "INVOICE UNDER PROGRESS", "count": counts?.invoiced ?? 0, "icon": Icons.description, "color": const Color(0xFF66BB6A)},
          {"label": "READY FOR DISPATCH", "count": counts?.readyForDispatch ?? 0, "icon": Icons.send, "color": const Color(0xFFEF5350)},
          {"label": "REJECTED", "count": counts?.rejected ?? 0, "icon": Icons.block, "color": const Color(0xFFF44336)},
        ];

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: tabs.length,
          itemBuilder: (context, index) {
            final tab = tabs[index];
            final isSelected = selectedIndex == index;
            final Color statusColor = tab['color'];

            return GestureDetector(
              onTap: () => controller.onTabChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 12),
                width: 140,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isSelected ? statusColor : AppColors.gray200, width: isSelected ? 2 : 1),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tab['label'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.textSecondary, letterSpacing: 0.5),
                          ),
                          const Spacer(),
                          Text(
                            "${tab['count']}",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: isSelected ? statusColor : AppColors.textPrimary),
                          ),
                        ],
                      ),
                      /*     Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: statusColor.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))],
                          ),
                          child: Icon(tab['icon'], size: 16, color: Colors.white),
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller.searchController.value,
        onChanged: controller.onSearch,
        decoration: InputDecoration(
          hintText: "Search by Order No / Customer",
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildPackingCard(BuildContext context, PackingList item) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.packingDetailScreen, arguments: item.id),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200, width: 0.8),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                color: AppColors.indigo600Main.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, color: AppColors.indigo600Main, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.packingNo ?? "No Packing Number",
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.indigo600Main),
                    ),
                  ),
                  _actionButton(context, item),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _compactBadge(controller.getStatusLabel(item), controller.getBadgeColor(item, controller.getStatusLabel(item))),
                      if (item.isRegularInvoiceApproved != null)
                        _compactBadge(
                          item.isRegularInvoiceApproved! ? "Approved" : "Pending",
                          item.isRegularInvoiceApproved! ? AppColors.green500Normal : AppColors.orangeColor,
                        ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, color: AppColors.gray100),
                  ),
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
                              : (item.createdAt != null ? DateFormat('dd/MM/yyyy hh:mm a').format(item.pickingDate!.toLocal()) : "-"),
                        ),
                      ),
                      Expanded(
                        child: _infoCell(
                          Icons.access_time,
                          "Packing Date",
                          item.createdAt != null
                              ? DateFormat('dd/MM/yyyy hh:mm a').format(item.createdAt!.toLocal())
                              : (item.createdAt != null ? DateFormat('dd/MM/yyyy hh:mm a').format(item.packingDate!.toLocal()) : "-"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _infoCell(Icons.currency_rupee, "Amount", item.invoiceAmount ?? "-", valueColor: AppColors.indigo600Main),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, PackingList item) {
    final status = (item.status ?? "").trim().toUpperCase();
    List<PopupMenuItem<String>> menuItems = [];

    switch (status) {
      case "DRAFT":
        menuItems = [
          _buildMenuItem(value: 'view', icon: Icons.visibility_outlined, label: "View"),
          _buildMenuItem(value: 'create', icon: Icons.add, label: "Create Packing"),
          _buildMenuItem(value: 'cancel', icon: Icons.cancel_outlined, label: "Cancel", color: AppColors.red500),
        ];
        break;
      case "PICKED":
        menuItems = [
          _buildMenuItem(value: 'start', icon: Icons.play_arrow, label: "Start Packing"),
          _buildMenuItem(value: 'reject', icon: Icons.block, label: "Reject", color: AppColors.red500),
        ];
        break;
      case "INVOICED":
      case "DC_GENERATED":
        menuItems = [
          _buildMenuItem(value: 'view', icon: Icons.visibility_outlined, label: "View"),
          _buildMenuItem(value: 'view_packing_list', icon: Icons.format_list_bulleted, label: "Packing List"),
          _buildMenuItem(value: 'request_e_way_bill', icon: Icons.send_outlined, label: "Request for Eway Bill"),
          _buildMenuItem(value: 'box_wise', icon: Icons.file_download_outlined, label: "Boxwise List"),
          _buildMenuItem(value: 'print_label', icon: Icons.print_outlined, label: "Print Label"),
        ];
        break;
      case "PACKING":
      case "PACKED":
      case "IN_PACKING":
        menuItems = [
          _buildMenuItem(value: 'view', icon: Icons.visibility_outlined, label: "View"),
          _buildMenuItem(value: 'view_packing_list', icon: Icons.format_list_bulleted, label: "Packing List"),
          _buildMenuItem(value: 'request_invoice', icon: Icons.send_outlined, label: "Request for Invoice", enabled: status == "PACKED"),
          _buildMenuItem(value: 'box_wise', icon: Icons.file_download_outlined, label: "Boxwise List"),
          _buildMenuItem(value: 'print_label', icon: Icons.print_outlined, label: "Print Label"),
          _buildMenuItem(value: 'generate_dc', icon: Icons.file_present_outlined, label: "Generate Delivery Challan", enabled: item.isDCFlow == true),
        ];
        break;
    }

    if (menuItems.isEmpty) {
      return const Icon(Icons.arrow_forward_ios, color: AppColors.indigo600Main, size: 12);
    }

    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: const Icon(Icons.more_vert, color: AppColors.indigo600Main, size: 20),
      onSelected: (value) {
        if (value == 'view') Get.toNamed(AppRoutes.packingDetailScreen, arguments: item.id);
        if (value == 'create') _showCreatePackingDialog(context, item.pickingId ?? item.id!);
        if (value == 'cancel') _showCancelPackingDialog(context, item.id!);
        if (value == 'start') _showStartPackingDialog(context, item);
        if (value == 'reject') _showRejectPackingDialog(context, item.id!);
        if (value == 'view_packing_list') Get.toNamed(AppRoutes.packingListScreen, arguments: item.id);
        if (value == 'request_invoice') _showRequestInvoiceDialog(context, item);
        if (value == 'request_e_way_bill') _showRequestEWayBillBottomSheet(context, item);
        if (value == 'box_wise') controller.viewBoxWisePackingList(item.id!);
        if (value == 'print_label') controller.printShippingLabel(item.id!);
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: color),
      ),
    );
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
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.textPrimary),
        ),
      ],
    );
  }

  void _showCreatePackingDialog(BuildContext context, String id) {
    final TextEditingController remarksController = TextEditingController();
    final RxBool isShrinkWrapped = false.obs;

    controller.fetchEWayBillRequiredData();
    controller.selectedTransportMode.value = null;
    controller.selectedVendorId.value = null;

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Is this package shrink wrapped?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        /*   Obx(
                          () => Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: isShrinkWrapped.value,
                              onChanged: (value) => isShrinkWrapped.value = value,
                              activeThumbColor: AppColors.indigo600Main,
                            ),
                          ),
                        ),*/
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Transport Mode", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Obx(
                          () => CustomDropdown<Item>(
                            hintText: "Select Transport Mode",
                            items: (filter, loadProps) => Future.value(controller.transportModes.toList()),
                            itemAsString: (item) => item.name ?? "",
                            compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
                            selectedItem: controller.selectedTransportMode.value,
                            onChanged: (val) => controller.selectedTransportMode.value = val,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text("Vendor", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Obx(
                          () => CustomDropdown<Vendor>(
                            hintText: "Select Vendor",
                            items: (filter, loadProps) => Future.value(controller.vendors),
                            itemAsString: (item) => item.name ?? "",
                            compareFn: (item, selectedItem) => item?.id == selectedItem?.id,
                            selectedItem: controller.selectedVendorId.value,
                            onChanged: (val) => controller.selectedVendorId.value = val,
                          ),
                        ),
                      ],
                    ),
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
                                        transportMode: controller.selectedTransportMode.value?.id,
                                        vendorId: controller.selectedVendorId.value?.id,
                                        transporterName: controller.selectedVendorId.value?.name,
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

  void _showCancelPackingDialog(BuildContext context, String id) {
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

  void _showStartPackingDialog(BuildContext context, PackingList item) {
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
                                // pick whatever fits your "Confirm" label comfortably
                                height: 44, // optional, locks height too
                                child: controller.isLoading.value
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                          constraints: BoxConstraints(maxHeight: 20, minHeight: 20, maxWidth: 20, minWidth: 20),
                                        ),
                                      )
                                    : Text(
                                        "Confirm",
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        // Obx(
                        //   () => Expanded(
                        //     child: SizedBox(
                        //       // pick whatever fits your "Confirm" label comfortably
                        //       height: 44, // optional, locks height too
                        //       child: ElevatedButton.icon(
                        //         onPressed: controller.isLoading.value
                        //             ? null
                        //             : () {
                        //                 if (formKey.currentState!.validate()) {
                        //                   controller.rejectPacking(id, reason: reasonController.text);
                        //                 }
                        //               },
                        //         icon: controller.isLoading.value
                        //             ? const SizedBox(width: 18, height: 18, child: CircularProgressInd // Obx(
                        //                         //   () => Expanded(
                        //                         //     child: SizedBox(
                        //                         //       // pick whatever fits your "Confirm" label comfortably
                        //                         //       height: 44, // optional, locks height too
                        //                         //       child: ElevatedButton.icon(
                        //                         //         onPressed: controller.isLoading.value
                        //                         //             ? null
                        //                         //             : () {
                        //                         //                 if (formKey.currentState!.validate()) {
                        //                         //                   controller.rejectPacking(id, reason: reasonController.text);
                        //                         //                 }
                        //                         //               },
                        //                         //         icon: controller.isLoading.value
                        //                         //             ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        //                         //             : SizedBox(),
                        //                         //         label: Text(
                        //                         //           controller.isLoading.value ? "" : "Confirm",
                        //                         //           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        //                         //         ),
                        //                         //         style: ElevatedButton.styleFrom(
                        //                         //           backgroundColor: AppColors.red500,
                        //                         //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        //                         //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        //                         //         ),
                        //                         //       ),
                        //                         //     ),
                        //                         //   ),
                        //                         // ),icator(color: Colors.white, strokeWidth: 2))
                        //             : SizedBox(),
                        //         label: Text(
                        //           controller.isLoading.value ? "" : "Confirm",
                        //           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        //         ),
                        //         style: ElevatedButton.styleFrom(
                        //           backgroundColor: AppColors.red500,
                        //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
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

  void _showRequestEWayBillBottomSheet(BuildContext context, PackingList item) async {
    await controller.fetchEWayBillRequiredData();

    controller.selectedTransportMode.value = controller.transportModes.firstWhereOrNull(
      (e) => e.name == item.transportMode || e.id == item.transportMode,
    );
    controller.selectedVendorId.value = controller.vendors.firstWhereOrNull((e) => e.id == item.transporterId);

    controller.transporterGstinController.text = item.transporterGstin ?? "";
    controller.vehicleNoController.text = item.vehicleNo ?? "";
    controller.lrAwbController.text = item.lrNo ?? "";
    controller.eWayBillNoController.text = item.ewayBillNo ?? "";
    controller.driverNameController.text = item.driverName ?? "";
    controller.driverContactController.text = item.driverContact ?? "";
    controller.remarksController.text = item.remarks ?? "";

    controller.selectedVendorId.refresh();
    controller.selectedTransportMode.refresh();

    if (context.mounted) {
      Get.bottomSheet(
        Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.send_outlined, size: 20, color: AppColors.indigo600Main),
                    const SizedBox(width: 8),
                    const Text(
                      "Request For E-Way Bill",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
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
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: AppColors.indigo600Main, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontFamily: 'Inter'),
                                  children: [
                                    const TextSpan(text: "Requesting e-way bill for Packing List: "),
                                    TextSpan(
                                      text: item.packingNo ?? "-",
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => CustomDropdown<Item>(
                                hintText: "Transport",
                                items: (filter, loadProps) => Future.value(controller.transportModes.toList()),
                                itemAsString: (item) => item.name ?? "",
                                compareFn: (item, selectedItem) => item?.name == selectedItem?.name,
                                selectedItem: controller.transportModes.firstWhereOrNull((e) => e.id == controller.selectedTransportMode.value?.id),
                                onChanged: (val) {
                                  controller.selectedTransportMode.value = val;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => CustomDropdown<Vendor>(
                                hintText: "Vendor",
                                items: (filter, loadProps) => Future.value(controller.vendors),
                                itemAsString: (item) => item.name ?? "",
                                compareFn: (item, selectedItem) => item?.name == selectedItem?.name,
                                selectedItem: controller.vendors.firstWhereOrNull((e) => e.name == controller.selectedVendorId.value?.name),
                                onChanged: (val) {
                                  controller.selectedVendorId.value = val;
                                  if (val != null && val.gstNo != null && val.gstNo!.isNotEmpty) {
                                    controller.transporterGstinController.text = val.gstNo!.first;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: commonTextField(
                              labelText: "Transporter GSTIN",
                              hintText: "ENTER GSTIN",
                              controller: controller.transporterGstinController,
                              isGstInputValidator: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: commonTextField(labelText: "Vehicle No", hintText: "MH 12 AB 1234", controller: controller.vehicleNoController),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: commonTextField(labelText: "LR / AWB Number", hintText: "Enter LR No", controller: controller.lrAwbController),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: commonTextField(
                              labelText: "E-Way Bill Number",
                              hintText: "Enter E-Way Bill Number",
                              controller: controller.eWayBillNoController,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: commonTextField(
                              labelText: "Driver Name",
                              hintText: "Enter driver name",
                              controller: controller.driverNameController,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: commonTextField(
                              labelText: "Driver Contact",
                              hintText: "Phone number",
                              controller: controller.driverContactController,
                              isPhoneNumberValidator: true,
                              textInputType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                      commonTextField(
                        labelText: "Additional Remarks",
                        hintText: "Enter transport remarks if any...",
                        controller: controller.remarksController,
                        maxLine: 3,
                      ),
                      const SizedBox(height: 16),
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
                                controller.requestForEWayBill(item.id!);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.indigo600Main,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              child: const Text(
                                "Confirm & Proceed",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    }
  }

  void _showRequestInvoiceDialog(BuildContext context, PackingList item) {
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
                  const Icon(Icons.send_outlined, size: 20, color: AppColors.indigo600Main),
                  const SizedBox(width: 8),
                  const Text(
                    "Request For Invoice",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
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
                          text: item.packingNo ?? "-",
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
                            controller.requestForInvoice(item.id!);
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
