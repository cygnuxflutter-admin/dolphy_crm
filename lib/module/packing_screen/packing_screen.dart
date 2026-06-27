import 'package:crm/module/packing_screen/model/vendor_responce_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../widget/dropdown.dart';
import '../../widget/textfield.dart';
import 'model/packing_list_response_model.dart';
import 'model/transport_mode_responce_model.dart';
import 'packing_controller.dart';

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
      body: Column(
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
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
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
    );
  }

  Widget _buildCountCards() {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Obx(() {
        final counts = controller.packingCounts.value;
        final selectedIndex = controller.selectedTabIndex.value;
        final List<Map<String, dynamic>> tabs = [
          {"label": "ALL ORDERS", "count": counts?.all ?? 0, "icon": Icons.grid_view_rounded, "color": AppColors.indigo600Main},
          {"label": "NEW ORDERS", "count": counts?.readyToPack ?? 0, "icon": Icons.shopping_bag_outlined, "color": AppColors.blue500},
          {"label": "IN PACKING", "count": counts?.pending ?? 0, "icon": Icons.inventory_2_outlined, "color": AppColors.orangeColor},
          {"label": "INVOICING", "count": counts?.invoiced ?? 0, "icon": Icons.receipt_long_outlined, "color": AppColors.purple500},
          {"label": "DISPATCH", "count": counts?.readyForDispatch ?? 0, "icon": Icons.local_shipping_outlined, "color": AppColors.green500Success},
          {"label": "REJECTED", "count": counts?.rejected ?? 0, "icon": Icons.cancel_outlined, "color": AppColors.red500},
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
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(right: 12),
                width: 120,
                decoration: BoxDecoration(
                  color: isSelected ? statusColor : AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(color: statusColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                    else
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                  border: Border.all(color: isSelected ? Colors.transparent : AppColors.gray200, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: Icon(tab['icon'], size: 50, color: isSelected ? AppColors.white.withOpacity(0.12) : statusColor.withOpacity(0.04)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.white.withOpacity(0.2) : statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(tab['icon'], size: 16, color: isSelected ? AppColors.white : statusColor),
                                ),
                                Text(
                                  "${tab['count']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              tab['label'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? AppColors.white.withOpacity(0.9) : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              decoration: BoxDecoration(
                color: AppColors.indigo600Main.withOpacity(0.05),
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
                      _compactBadge(
                        controller.getStatusLabel(item),
                        controller.getBadgeColor(item, controller.getStatusLabel(item)),
                      ),
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
    if (item.status == "PICKED") {
      return PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.more_vert, color: AppColors.indigo600Main, size: 20),
        onSelected: (value) {
          if (value == 'create') _showCreatePackingDialog(context, item.id!);
          if (value == 'reject') _showRejectPackingDialog(context, item.id!);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'create',
            child: Row(children: [Icon(Icons.add, size: 16), SizedBox(width: 8), Text("Create Packing")]),
          ),
          const PopupMenuItem(
            value: 'reject',
            child: Row(
              children: [
                Icon(Icons.block, size: 16, color: Colors.red),
                SizedBox(width: 8),
                Text("Reject", style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      );
    }

    if (item.status == "PACKED" ||
        item.status == "PENDING" ||
        item.status == "INVOICED" ||
        item.status == "INVOICE_PROCESS" ||
        item.status == "READY_FOR_DISPATCH") {
      return PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.more_vert, color: AppColors.indigo600Main, size: 20),
        onSelected: (value) {
          if (value == 'view') Get.toNamed(AppRoutes.packingDetailScreen, arguments: item.id);
          if (value == 'request_invoice') _showRequestInvoiceDialog(context, item);
          if (value == 'request_e_way_bill') {
            _showRequestEWayBillBottomSheet(context, item);
          }
          if (value == 'view_packing_list') Get.toNamed(AppRoutes.packingListScreen, arguments: item.id);
          if (value == 'box_wise') controller.viewBoxWisePackingList(item.id!);
          if (value == 'print_label') controller.printShippingLabel(item.id!);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'view',
            child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text("View")]),
          ),
          const PopupMenuItem(
            value: 'view_packing_list',
            child: Row(children: [Icon(Icons.format_list_bulleted, size: 16), SizedBox(width: 8), Text("Packing List")]),
          ),
          if (item.status == "PACKED" || item.status == "PENDING")
            PopupMenuItem(
              value: 'request_invoice',
              enabled: item.isPackingDetailSaved == true,
              child: Row(
                children: [
                  Icon(Icons.send_outlined, size: 16, color: item.isPackingDetailSaved == false ? null : AppColors.gray400),
                  const SizedBox(width: 8),
                  Text("Request Invoice", style: TextStyle(color: item.isPackingDetailSaved == false ? null : AppColors.gray400)),
                ],
              ),
            ),
          if (item.status == "PACKED")
            PopupMenuItem(
              value: 'Generate Delivery Challan',
              enabled: item.isDCFlow == true,
              child: Row(
                children: [
                  Icon(Icons.file_present_outlined, size: 16, color: item.isDCFlow == false ? null : AppColors.gray400),
                  const SizedBox(width: 8),
                  Text("Generate Delivery Challan", style: TextStyle(color: item.isDCFlow == false ? null : AppColors.gray400)),
                ],
              ),
            ),
          if (item.status == "INVOICED" || item.status == "INVOICE_PROCESS" || item.status == "READY_FOR_DISPATCH")
            const PopupMenuItem(
              value: 'request_e_way_bill',
              child: Row(children: [Icon(Icons.send_outlined, size: 16), SizedBox(width: 8), Text("E-Way Bill")]),
            ),
          const PopupMenuItem(
            value: 'box_wise',
            child: Row(children: [Icon(Icons.file_download_outlined, size: 16), SizedBox(width: 8), Text("BoxWise List")]),
          ),
          const PopupMenuItem(
            value: 'print_label',
            child: Row(children: [Icon(Icons.print_outlined, size: 16), SizedBox(width: 8), Text("Print Label")]),
          ),
        ],
      );
    }

    if (item.status == "REJECTED") {
      return PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.more_vert, color: AppColors.indigo600Main, size: 20),
        onSelected: (value) {
          if (value == 'view') Get.toNamed(AppRoutes.packingDetailScreen, arguments: item.id);
          if (value == 'view_packing_list') Get.toNamed(AppRoutes.packingListScreen, arguments: item.id);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'view',
            child: Row(children: [Icon(Icons.visibility_outlined, size: 16), SizedBox(width: 8), Text("View")]),
          ),
          const PopupMenuItem(
            value: 'view_packing_list',
            child: Row(children: [Icon(Icons.format_list_bulleted, size: 16), SizedBox(width: 8), Text("Packing List")]),
          ),
        ],
      );
    }

    return const Icon(Icons.arrow_forward_ios, color: AppColors.indigo600Main, size: 12);
  }

  Widget _compactBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }

  Color _getStatusColor(PackingList item) {
    if (item.status == "PACKED" || item.status == "PENDING") return AppColors.orangeColor;
    if (item.status == "INVOICED" || item.status == "INVOICE_PROCESS") {
      return item.isRegularInvoiceApproved == true ? AppColors.blue500 : AppColors.gray600;
    }
    if (item.status == "READY_FOR_DISPATCH") return AppColors.blue500;
    if (item.status == "REJECTED") return AppColors.red500;
    return AppColors.gray500;
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

  Widget _statusBadge(PackingList item) {
    String displayStatus = item.status ?? "-";
    Color color = AppColors.gray500;

    if (item.status == "PACKED" || item.status == "PENDING") {
      displayStatus = "In packing";
      color = AppColors.orangeColor;
    } else if (item.status == "INVOICED" || item.status == "INVOICE_PROCESS") {
      if (item.isRegularInvoiceApproved == true) {
        displayStatus = "Ready For Dispatch";
        color = AppColors.blue500;
      } else {
        displayStatus = "Invoiced";
        color = AppColors.gray600;
      }
    } else if (item.status == "READY_FOR_DISPATCH") {
      displayStatus = "Ready For Dispatch";
      color = AppColors.blue500;
    } else if (item.status == "PICKED") {
      displayStatus = "Picked";
      color = AppColors.gray500;
    } else if (item.status == "REJECTED") {
      displayStatus = "Rejected";
      color = AppColors.red500;
    }

    return _badge(displayStatus, color);
  }

  Widget _approveBadge(PackingList item) {
    if (item.isRegularInvoiceApproved == null) {
      return const Text(
        "-",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.gray400),
      );
    }

    String label = item.isRegularInvoiceApproved! ? "Approved" : "Pending";
    Color color = item.isRegularInvoiceApproved! ? AppColors.green500Normal : AppColors.orangeColor;

    return _badge(label, color);
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: color),
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
                      activeColor: AppColors.indigo600Main,
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
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
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
    controller.remarksController.text = item.transportRemarks ?? "";

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
                                items: (filter, loadProps) => Future.value(controller.transportModes),
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
