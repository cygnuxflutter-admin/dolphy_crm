import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../packing_controller.dart';

class PickingRequestDetailView extends GetView<PackingController> {
  const PickingRequestDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final String id = Get.arguments ?? "";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (id.isNotEmpty) {
        controller.getPickingRequestDetail(id);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.indigo600Main,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Pick Request Detail",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white, fontSize: 16),
        ),
      ),
      body: Obx(() {
        if (controller.isPickingRequestLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.pickingRequestDetail.value?.data;
        if (data == null) {
          return const Center(child: Text("No Data Found"));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  children: [
                    Text("Dolphy - Pick Request", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              _buildHeaderInfo("Pick No", data.pickingNo ?? "-"),
              _buildHeaderInfo("Date", data.requestDate != null ? DateFormat('dd/MM/yyyy hh:mm a').format(data.requestDate!.toLocal()) : "-"),
              _buildHeaderInfo("Party", data.customer?.companyName ?? "-"),
              _buildHeaderInfo("PI No", data.invoice?.invoiceNo ?? "-"),
              _buildHeaderInfo("SP Remarks", (data.remarks ?? "").isEmpty ? "-" : data.remarks!),
              _buildHeaderInfo("Transport Mode", data.invoice?.transportModeName ?? "-"),
              const SizedBox(height: 8),
              const Divider(thickness: 1, color: Colors.grey, height: 24),
              const Text("Items", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.items?.length ?? 0,
                separatorBuilder: (context, index) => const Divider(height: 32),
                itemBuilder: (context, index) {
                  final item = data.items![index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product?.productCode ?? "-", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            Text(item.product?.productName ?? "-", style: const TextStyle(fontSize: 14, color: Colors.black87)),
                            const SizedBox(height: 16),
                            const Text("Location", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text(
                              (item.rackSuggestions != null && item.rackSuggestions!.isNotEmpty)
                                  ? item.rackSuggestions!.map((e) => e.rackName).join(", ")
                                  : "No Location",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (item.product?.productImage != null && item.product!.productImage!.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                item.product!.productImage!.first,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported, size: 30, color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, size: 30, color: Colors.grey),
                            ),
                          const SizedBox(height: 16),
                          const Text("Qty", style: TextStyle(fontSize: 14, color: Colors.grey)),
                          Text(item.requestedQty?.toString() ?? "0", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const Divider(thickness: 1, color: Colors.grey, height: 24),
              const Text("Remarks :", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text(data.remarks ?? "-", style: const TextStyle(fontSize: 14)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text("$label :", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
