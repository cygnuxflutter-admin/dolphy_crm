import 'package:crm/config/app_colors.dart';
import 'package:crm/config/app_shared_pref.dart';
import 'package:crm/widget/barcode_scanner_widget.dart';
import 'package:crm/widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/picking_detail_response.dart';
import '../model/picking_suggestions_response.dart';
import '../picking_list_controller.dart';

class PickSerialsScreen extends StatelessWidget {
  final Item item;
  PickSerialsScreen({super.key, required this.item});

  final PickingListController controller = Get.find<PickingListController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: const EdgeInsets.all(20),
      child: Obx(() {
        if (controller.isSuggestionsLoading.value) {
          return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()));
        }

        if (controller.suggestionsError.value.isNotEmpty) {
          return SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 40, color: AppColors.redColor),
                const SizedBox(height: 16),
                Text(controller.suggestionsError.value, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: () => Get.back(), child: const Text("Go Back")),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => controller.getPickingSuggestions(productId: item.product?.id ?? "", requiredQty: item.pendingQty ?? "0"),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        final suggestions = controller.pickingSuggestions.value;
        if (suggestions == null) {
          return SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No suggestions available"),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: () => Get.back(), child: const Text("Go Back")),
              ],
            ),
          );
        }

        bool isBatchProduct = item.product?.trackingType?.toUpperCase() == "BATCH";
        bool showTabs = item.product?.trackingType?.toUpperCase() == "SERIAL";

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.gray300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            _header(context, isBatchProduct),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isBatchProduct) ...[_batchInfo(), const SizedBox(height: 16)],
                    if (showTabs && controller.selectedInputTabIndex.value == 2) ...[_rangeErrorBanner(), const SizedBox(height: 16)],
                    if (showTabs) ...[_serialTabs(), const SizedBox(height: 16)],
                    if (isBatchProduct) ...[
                      _step1SelectRack(suggestions),
                      const SizedBox(height: 16),
                      _batchFlow(),
                    ] else if (controller.selectedInputTabIndex.value == 0) ...[
                      _barcodeFlow(),
                    ] else if (controller.selectedInputTabIndex.value == 1) ...[
                      _step1SelectRack(suggestions),
                      const SizedBox(height: 16),
                      _serialFlow(suggestions),
                    ] else if (controller.selectedInputTabIndex.value == 2) ...[
                      _rangeFlow(),
                    ],
                    const SizedBox(height: 16),
                    _selectedSerialsSummary(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _footerActions(context, suggestions, isBatchProduct, item),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
          ],
        );
      }),
    );
  }

  Widget _header(BuildContext context, bool isBatch) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pick ${!isBatch ? "Serials" : "Quantity"} for ",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: item.product?.productCode ?? "-",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                    ),
                    if (!isBatch)
                      TextSpan(
                        text: "  ${controller.selectedSerials.length}/${item.pendingQty ?? "0"}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
      ],
    );
  }

  Widget _batchInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.indigo100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColors.blue600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "This is a BATCH product. Select a rack location and enter the quantity to pick. System will automatically allocate from oldest batches (FIFO).",
              style: TextStyle(fontSize: 12, color: AppColors.lBlue900Dark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _serialTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          _tabItem(Icons.qr_code_scanner, "Single Barcode", controller.selectedInputTabIndex.value == 0, 0),
          const SizedBox(width: 4),
          _tabItem(Icons.location_on_outlined, "By Rack Location", controller.selectedInputTabIndex.value == 1, 1),
          const SizedBox(width: 4),
          _tabItem(Icons.list_alt, "Range Input", controller.selectedInputTabIndex.value == 2, 2),
        ],
      ),
    );
  }

  Widget _tabItem(IconData icon, String label, bool isSelected, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => controller.selectedInputTabIndex.value = index,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : AppColors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? AppColors.gray800 : AppColors.gray500,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _barcodeFlow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Scan or Enter Serial Number", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.barcodeController,
                  onSubmitted: (value) => _addSerialByBarcode(value),
                  decoration: InputDecoration(
                    hintText: "Enter serial number...",
                    fillColor: AppColors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner, color: AppColors.indigo600Main),
                      onPressed: () {
                        Get.to(
                          () => BarcodeScannerWidget(
                            onResult: (barcode) async {
                              return _addSerialByBarcode(barcode);
                            },
                          ),
                          preventDuplicates: false,
                        );
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.gray300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.gray300),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: () => _addSerialByBarcode(controller.barcodeController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.indigo600Main,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 16, color: AppColors.white),
                      Text("Add", style: TextStyle(color: AppColors.white, fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _addSerialByBarcode(String barcode) {
    print("Adding serial by barcode: $barcode");
    if (barcode.isEmpty) return false;

    if (controller.selectedSerials.length >= (double.tryParse(item.pendingQty ?? "0")?.toInt() ?? 0)) {
      print("Limit reached ${double.tryParse(item.pendingQty ?? "0")?.toInt() ?? 0}");
      toastMessage(text: "You have already selected the required quantity (${item.pendingQty ?? "0"})", color: AppColors.redColor);
      return false;
    }

    if (controller.selectedSerials.any((s) => s.serialNo == barcode)) {
      print("Already added");
      toastMessage(text: "This serial number is already in the list", color: AppColors.redColor);
      controller.barcodeController.clear();
      return false;
    }

    final allSerials = controller.pickingSuggestions.value?.serials ?? [];
    print("Total available serials: ${allSerials.length}");

    final suggestion = allSerials.firstWhereOrNull((s) => s.serialNo == barcode);

    if (suggestion != null) {
      print("Found suggestion: ${suggestion.serialNo}");
      controller.selectedSerials.add(suggestion);
      controller.barcodeController.clear();
      return true;
    } else {
      print("Serial not found in suggestions");
      toastMessage(text: "Serial number not found in available stock", color: AppColors.redColor);
      return false;
    }
  }

  Widget _rangeFlow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add Serial Range", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.startRangeController,
                  decoration: InputDecoration(
                    hintText: "Start (e.g., SN001)",
                    fillColor: AppColors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.gray300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.gray300),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text("to", style: TextStyle(color: AppColors.textSecondary)),
              ),
              Expanded(
                child: TextField(
                  controller: controller.endRangeController,
                  decoration: InputDecoration(
                    hintText: "End (e.g., SN012)",
                    fillColor: AppColors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.gray300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.gray300),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _addSerialsByRange(),
            icon: const Icon(Icons.add, size: 16, color: AppColors.white),
            label: const Text("Add Range", style: TextStyle(color: AppColors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.indigo600Main,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  void _addSerialsByRange() {
    String start = controller.startRangeController.text.trim();
    String end = controller.endRangeController.text.trim();

    if (start.isEmpty || end.isEmpty) {
      toastMessage(text: "Please enter both start and end serial numbers", color: AppColors.redColor);
      return;
    }

    final allSerials = controller.pickingSuggestions.value?.serials ?? [];
    int startIndex = allSerials.indexWhere((s) => s.serialNo == start);
    int endIndex = allSerials.indexWhere((s) => s.serialNo == end);

    if (startIndex == -1 || endIndex == -1 || startIndex > endIndex) {
      toastMessage(text: "Please check your serial numbers and try again.", color: AppColors.redColor);
      return;
    }

    List<Serial> rangeSerials = allSerials.sublist(startIndex, endIndex + 1);
    int allowedQty = (double.tryParse(item.pendingQty ?? "0")?.toInt() ?? 0) - controller.selectedSerials.length;

    if (allowedQty <= 0) {
      toastMessage(text: "You have already selected the required quantity", color: AppColors.redColor);
      return;
    }

    int addedCount = 0;
    for (var serial in rangeSerials) {
      if (addedCount >= allowedQty) break;
      if (!controller.selectedSerials.any((s) => s.id == serial.id)) {
        controller.selectedSerials.add(serial);
        addedCount++;
      }
    }

    if (addedCount > 0) {
      controller.startRangeController.clear();
      controller.endRangeController.clear();
      toastMessage(text: "Added $addedCount serials from range", color: AppColors.indigo600Main);
    } else {
      toastMessage(text: "All serials in this range are already selected", color: AppColors.indigo600Main);
    }
  }

  Widget _rangeErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.red100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.red100),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 18, color: AppColors.red600Error),
          const SizedBox(width: 8),
          Expanded(
            child: Text("No valid serials found in range. Please check and try again.", style: TextStyle(fontSize: 12, color: AppColors.red800)),
          ),
        ],
      ),
    );
  }

  Widget _selectedSerialsSummary() {
    bool isSerial = item.product!.trackingType == "SERIAL";
    if (!isSerial) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.check_circle_outline, size: 18, color: AppColors.green500Normal),
            SizedBox(width: 8),
            Text(
              "Selected Serials (${controller.selectedSerials.length}/${item.pendingQty ?? "0"})",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 100),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.green100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.green100),
          ),
          child: controller.selectedSerials.isEmpty
              ? const Center(
                  child: Text("No serials selected yet", style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.selectedSerials
                      .map(
                        (s) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.green100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                s.serialNo,
                                style: const TextStyle(fontSize: 11, color: AppColors.green800, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () => controller.selectedSerials.remove(s),
                                child: const Icon(Icons.close, size: 14, color: AppColors.green800),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _step1SelectRack(SuggestionsData suggestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.looks_one, size: 16, color: AppColors.indigo600Main),
            SizedBox(width: 4),
            Text(
              "Step 1: Select Warehouse / Rack",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.lBlue900Dark),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RackSuggestion>(
              isExpanded: true,
              value: controller.selectedRack.value,
              hint: const Text("Select rack location...", style: TextStyle(fontSize: 13, color: AppColors.grey500Placeholder)),
              onChanged: (RackSuggestion? newValue) {
                controller.selectedRack.value = newValue;
                controller.selectedSerials.clear();
              },
              items: suggestions.byRack.map((RackSuggestion rack) {
                return DropdownMenuItem<RackSuggestion>(
                  value: rack,
                  child: Text("${rack.rackName} - ${rack.warehouseName} (${rack.count.toInt()} pcs)", style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _batchFlow() {
    final serials = controller.pickingSuggestions.value?.serials ?? [];
    final uniqueBatches = serials.map((e) => e.batchNumber).where((b) => b.isNotEmpty).toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.looks_two, size: 16, color: AppColors.green500Normal),
            SizedBox(width: 4),
            Text(
              "Step 2: Enter Quantity to Pick",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.lBlue900Dark),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          "Available Batches:",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.gray600),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray200),
          ),
          child: uniqueBatches.isEmpty
              ? const Text("No batches available", style: TextStyle(fontSize: 13, color: AppColors.gray500))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: uniqueBatches
                      .map(
                        (batch) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.inventory_2_outlined, size: 14, color: AppColors.gray500),
                              const SizedBox(width: 8),
                              Text(
                                batch,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.gray800),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller.quantityController,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            controller.pickQuantity.value = value;
          },
          decoration: InputDecoration(
            hintText: "Max: ${item.pendingQty ?? "0"}",
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "System will pick from oldest batches first (FIFO). Maximum available: ${item.pendingQty ?? "0"}",
          style: TextStyle(fontSize: 10, color: AppColors.gray500),
        ),
      ],
    );
  }

  Widget _serialFlow(SuggestionsData suggestions) {
    if (controller.selectedRack.value == null) return const SizedBox();

    final filteredSerials = suggestions.serials.where((s) => s.rackId == controller.selectedRack.value?.rackId).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.looks_two, size: 16, color: AppColors.green500Normal),
                const SizedBox(width: 4),
                Text(
                  "Step 2: Select Serials from ${controller.selectedRack.value?.rackName}",
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.lBlue900Dark),
                ),
              ],
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            int needed = (double.tryParse(item.pendingQty ?? "0")?.toInt() ?? 0);
            controller.selectedSerials.clear();
            controller.selectedSerials.addAll(filteredSerials.take(needed));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.indigo600Light,
            minimumSize: const Size(0, 30),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text("Select (${item.pendingQty ?? "0"})", style: const TextStyle(fontSize: 11, color: AppColors.white)),
        ),
        const SizedBox(height: 12),
        ..._buildComboList(filteredSerials, 10),
      ],
    );
  }

  List<Widget> _buildComboList(List<Serial> serials, int comboLimit) {
    List<Widget> combos = [];
    for (int i = 0; i < serials.length; i += comboLimit) {
      int end = (i + comboLimit < serials.length) ? i + comboLimit : serials.length;
      List<Serial> chunk = serials.sublist(i, end);
      combos.add(_comboItem(chunk, i ~/ comboLimit + 1));
      combos.add(const SizedBox(height: 12));
    }
    return combos;
  }

  Widget _comboItem(List<Serial> chunk, int index) {
    int selectedInChunk = chunk.where((s) => controller.selectedSerials.any((selected) => selected.id == s.id)).length;
    bool allSelected = selectedInChunk == chunk.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: ExpansionTile(
        initiallyExpanded: index == 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none),
        title: Row(
          children: [
            Expanded(
              child: Text(
                "Combo: ${chunk.first.serialNo} - ${chunk.last.serialNo}",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Text("$selectedInChunk/${chunk.length} pcs", style: const TextStyle(fontSize: 11, color: AppColors.blue500)),
          ],
        ),
        trailing: OutlinedButton(
          onPressed: () {
            int maxQty = (double.tryParse(item.pendingQty ?? "0")?.toInt() ?? 0);
            int needed = maxQty - controller.selectedSerials.length;

            if (allSelected) {
              // Remove all items in this chunk from selectedSerials
              for (var s in chunk) {
                controller.selectedSerials.removeWhere((selected) => selected.id == s.id);
              }
            } else {
              // Add only those items from chunk that are not already selected, respecting the limit
              if (needed <= 0) {
                toastMessage(text: "You have already selected the required quantity ($maxQty)", color: AppColors.redColor);
                return;
              }

              for (var s in chunk) {
                if (controller.selectedSerials.length < maxQty) {
                  if (!controller.selectedSerials.any((selected) => selected.id == s.id)) {
                    controller.selectedSerials.add(s);
                  }
                }
              }
            }
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.blue500),
            minimumSize: const Size(0, 28),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(allSelected ? "Deselect Box" : "Select Box", style: const TextStyle(fontSize: 10, color: AppColors.blue500)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(spacing: 5, runSpacing: 5, children: chunk.map((s) => _serialChip(s)).toList()),
          ),
        ],
      ),
    );
  }

  Widget _serialChip(Serial serial) {
    bool isSelected = controller.selectedSerials.any((s) => s.id == serial.id);
    return InkWell(
      onTap: () {
        if (isSelected) {
          controller.selectedSerials.removeWhere((s) => s.id == serial.id);
        } else {
          int maxQty = (double.tryParse(item.pendingQty ?? "0")?.toInt() ?? 0);
          if (controller.selectedSerials.length < maxQty) {
            controller.selectedSerials.add(serial);
          } else {
            toastMessage(text: "You have already selected the required quantity ($maxQty)", color: AppColors.redColor);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.indigo600Light : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.indigo600Light : AppColors.gray300),
        ),
        child: Text(
          serial.serialNo,
          style: TextStyle(
            fontSize: 8,
            color: isSelected ? AppColors.white : AppColors.gray800,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _footerActions(BuildContext context, SuggestionsData suggestions, bool isBatch, Item item) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textSecondary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
                    if (isBatch) {
                      if (controller.selectedRack.value == null) {
                        toastMessage(text: "Please select a rack location", color: AppColors.redColor);
                        return;
                      }
                      if (controller.pickQuantity.value.isEmpty || double.parse(controller.pickQuantity.value) <= 0) {
                        toastMessage(text: "Please enter a valid quantity", color: AppColors.redColor);
                        return;
                      }
                      controller.submitPick(
                        pickingId: item.pickingId ?? "",
                        pickingItemId: item.id ?? "",
                        productId: item.productId ?? "",
                        locationId: Pref.getLocationId() ?? "",
                        companyId: Pref.getCompanyId() ?? "",
                        finYear: Pref.getFinancialYears(),
                        rackId: controller.selectedRack.value!.rackId,
                        quantity: double.parse(controller.pickQuantity.value),
                      );
                    } else {
                      if (controller.selectedSerials.isEmpty) {
                        toastMessage(text: "Please select at least one serial", color: AppColors.redColor);
                        return;
                      }
                      controller.submitPick(
                        pickingId: controller.pickingDetail.value?.id ?? "",
                        pickingItemId: item.id ?? "",
                        productId: item.productId ?? "",
                        locationId: Pref.getLocationId() ?? "",
                        companyId: Pref.getCompanyId() ?? "",
                        finYear: Pref.getFinancialYears(),
                        serialNumbers: controller.selectedSerials.map((s) => s.serialNo).toList(),
                        rackId: controller.selectedRack.value?.rackId,
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.indigo600Main,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: controller.isLoading.value
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                : Text(
                    "Submit Pick (${isBatch ? (controller.pickQuantity.value.isEmpty ? "0" : controller.pickQuantity.value) : controller.selectedSerials.length})",
                  ),
          ),
        ),
      ],
    );
  }
}
