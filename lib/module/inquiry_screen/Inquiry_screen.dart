import 'package:crm/module/inquiry_screen/Inquiry_binding.dart';
import 'package:crm/module/inquiry_screen/sub_screen/Inquiry_view_screen.dart';
import 'package:crm/module/inquiry_screen/sub_screen/add_Inquiry_screen.dart';
import 'package:crm/module/lead_screen/lead_binding.dart';
import 'package:crm/module/lead_screen/sub_screen/add_lead_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/app_colors.dart';
import '../../config/app_images.dart';
import 'Inquiry_controller.dart';

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final InquiryScreenController inquiryScreenController = Get.find<InquiryScreenController>();

  final ScrollController scrollController = ScrollController();

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (inquiryScreenController.leadList.length < inquiryScreenController.totalCount.value) {
        inquiryScreenController.pageCount.value++;
        inquiryScreenController.getLeadListApi(
          page: inquiryScreenController.pageCount.value,
          search: inquiryScreenController.searchController.value.text,
          isLoading: false,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);

    inquiryScreenController.getLeadListApi(
      page: inquiryScreenController.pageCount.value,
      search: inquiryScreenController.searchController.value.text,
      fromPagination: false,
    );

    inquiryScreenController.getLeadSourceItem();
    inquiryScreenController.getLeadTagsType();
    inquiryScreenController.getPriceType();
    inquiryScreenController.getStateApi();
    inquiryScreenController.getCityApi(page: 1, search: '', fromPagination: false);
    inquiryScreenController.getCountry();
    inquiryScreenController.getPinCodeApi(page: 1, search: "", fromPagination: false);
    inquiryScreenController.getAddressType();
    inquiryScreenController.getCustomerGroup();
    inquiryScreenController.getCustomerBrand();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      /// APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.indigo600Main,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Inquiry",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person_add_alt_1_rounded, // 🔥 NEW ADD ICON
              color: AppColors.white,
            ),
            onPressed: () => Get.to(AddInquiryScreen(), binding: InquiryScreenBinding()),
          ),
        ],
      ),

      body: SafeArea(
        child: Obx(() {
          final leads = inquiryScreenController.leadList;
          final totalCount = inquiryScreenController.totalCount.value;
          final isLoading = inquiryScreenController.isLeadDataLoading.value;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
          }

          if (leads.isEmpty) {
            return Center(child: Image.asset(AppImages.noDataFound, scale: 3));
          }

          final allLoaded = leads.length >= totalCount;

          return ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.all(14),
            itemCount: leads.length + (allLoaded ? 0 : 1),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (!allLoaded && index == leads.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final data = leads[index];

              String createdAt = "-";
              if (data.createdAt!.isNotEmpty) {
                DateTime dt = DateTime.parse(data.createdAt!).toUtc().add(const Duration(hours: 5, minutes: 30));
                createdAt = DateFormat("dd/MM/yyyy hh:mm a").format(dt);
              }

              return _leadCard(data, index, createdAt);
            },
          );
        }),
      ),
    );
  }

  // ================= CRM LEAD CARD =================
  Widget _leadCard(data, int index, String createdAt) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.gray300.withOpacity(.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP SECTION (PERSON NAME & STATUS)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    data.contactName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                _typeChip1(data.isCustomer),
                _statusChip(data.isActive),
              ],
            ),
          ),

          /// COMPANY NAME
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              data.companyName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Divider(height: 1, color: AppColors.gray100),
          ),

          /// DETAILS GRID
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow(Icons.email_outlined, data.email ?? "-"),
                const SizedBox(height: 8),
                _detailRow(Icons.phone_android_outlined, data.mobile1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _detailRow(Icons.location_city_outlined, data.cityName ?? "-")),
                    Expanded(child: _detailRow(Icons.person_outline, data.createdByName ?? "-")),
                  ],
                ),
                const SizedBox(height: 8),
                Row(children: [Expanded(child: _detailRow(Icons.calendar_today_outlined, createdAt))]),
              ],
            ),
          ),

          const SizedBox(height: 14),

          /// ACTIONS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _miniAction(Icons.person_add_alt_1_rounded, AppColors.green500Success, () async {
                  await inquiryScreenController.getInquiryView(id: data.id);
                  if (inquiryScreenController.leadViewData.value != null) {
                    Get.to(() => AddLeadScreen(
                          isEdit: false,
                          prefillFromInquiry: inquiryScreenController.leadViewData.value,
                        ),
                        binding: LeadBinding(),
                    );
                  }
                }),
                const SizedBox(width: 12),
                _miniAction(Icons.visibility_outlined, AppColors.indigo600Main, () async {
                  await inquiryScreenController.getInquiryView(id: data.id);
                  Get.to(() => InquiryDetailScreen());
                }),
                const SizedBox(width: 12),
                _miniAction(Icons.edit_outlined, AppColors.yellow500, () async {
                  inquiryScreenController.addAddressList.clear();
                  Get.to(() => AddInquiryScreen(isEdit: true, id: data.id));
                }),
                const SizedBox(width: 12),
                _miniAction(Icons.delete_outline, AppColors.red600Error, () => _deleteDialog(data.id)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= DETAIL ROW =================
  Widget _detailRow(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.indigo600Main.withOpacity(0.7)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  // ================= TYPE CHIP =================
  Widget _typeChip1(bool isCustomer) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.orangeColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.orangeColor.withOpacity(.3)),
      ),
      child: Center(
        child: Text(
          isCustomer ? "Customer" : "Inquiry",
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.orangeColor),
        ),
      ),
    );
  }

  // ================= STATUS CHIP =================
  Widget _statusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.green500Success.withOpacity(.1) : AppColors.red600Error.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? AppColors.green500Success.withOpacity(.3) : AppColors.red600Error.withOpacity(.3)),
      ),
      child: Text(
        isActive ? "Active" : "Inactive",
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isActive ? AppColors.green500Success : AppColors.red600Error),
      ),
    );
  }

  // ================= MINI ACTION =================
  Widget _miniAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  // ================= DELETE DIALOG =================
  void _deleteDialog(String id) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline, size: 42, color: AppColors.red600Error),
              const SizedBox(height: 16),
              const Text("Delete Lead?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to delete this lead?",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red600Error,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        inquiryScreenController.deleteLeadApi(id: id);
                      },
                      child: const Text("Delete", style: TextStyle(color: AppColors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gray500,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text("Cancel", style: TextStyle(color: AppColors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
