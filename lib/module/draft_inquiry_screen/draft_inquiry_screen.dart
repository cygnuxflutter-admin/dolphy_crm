import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/app_colors.dart';
import '../../config/app_images.dart';
import '../../config/app_routes.dart';
import '../../utils/permission_handler.dart';
import '../notification_screen/controller/notification_controller.dart';
import 'draft_inquiry_controller.dart';
import 'model/draft_inquiry_model.dart';
import 'sub_screen/add_draft_inquiry_screen.dart';

class DraftInquiryScreen extends StatefulWidget {
  const DraftInquiryScreen({super.key});

  @override
  State<DraftInquiryScreen> createState() => _DraftInquiryScreenState();
}

class _DraftInquiryScreenState extends State<DraftInquiryScreen> {
  final DraftInquiryController controller = Get.find<DraftInquiryController>();
  final PermissionHandler permissionHandler = Get.find<PermissionHandler>();
  final NotificationController notificationController = Get.find<NotificationController>();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);

    // Initial fetch
    controller.pageCount.value = 1;
    controller.getDraftInquiryList(
      page: 1,
      search: controller.searchController.value.text,
      fromPagination: false,
      isLoading: true,
    );
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 150) {
      if (!controller.isListLoading.value &&
          controller.draftInquiryList.length < controller.totalCount.value) {
        controller.pageCount.value++;
        controller.getDraftInquiryList(
          page: controller.pageCount.value,
          search: controller.searchController.value.text,
          fromPagination: true,
          isLoading: false,
        );
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
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
          "Draft Inquiry",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
        actions: [
          Obx(
            () => Stack(
              children: [
                IconButton(
                  onPressed: () {
                    notificationController.markAllNotificationsAsRead();
                    Get.toNamed(AppRoutes.notificationScreen);
                  },
                  icon: const Icon(Icons.notifications_none_outlined, size: 26, color: Colors.white),
                ),
                if (notificationController.unreadCount.value > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${notificationController.unreadCount.value}',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Obx(
            () => permissionHandler.isDraftInquiryCreateAllowed
                ? IconButton(
                    icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.white),
                    onPressed: () async {
                      await Get.to(() => const AddDraftInquiryScreen());
                      controller.pageCount.value = 1;
                      controller.getDraftInquiryList(page: 1, fromPagination: false, isLoading: false);
                    },
                  )
                : const SizedBox(),
          ),
        ],
      ),

      /// BODY
      body: SafeArea(
        child: Column(
          children: [
            _searchBar(),
            Expanded(
              child: Obx(() {
                final list = controller.draftInquiryList;
                final totalCount = controller.totalCount.value;
                final isLoading = controller.isListLoading.value;

                if (isLoading && list.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.indigo600Main),
                  );
                }

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.noDataFound, scale: 3),
                        const SizedBox(height: 12),
                        const Text(
                          "No Draft Inquiries Found",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (permissionHandler.isDraftInquiryCreateAllowed) ...[
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await Get.to(() => const AddDraftInquiryScreen());
                              controller.pageCount.value = 1;
                              controller.getDraftInquiryList(page: 1, fromPagination: false, isLoading: false);
                            },
                            icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
                            label: const Text(
                              "ADD YOUR FIRST DRAFT INQUIRY",
                              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.indigo600Main,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                              shadowColor: AppColors.indigo600Main.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                final allLoaded = list.length >= totalCount;

                return RefreshIndicator(
                  color: AppColors.indigo600Main,
                  onRefresh: () async {
                    controller.pageCount.value = 1;
                    await controller.getDraftInquiryList(
                      page: 1,
                      search: controller.searchController.value.text,
                      fromPagination: false,
                      isLoading: true,
                    );
                  },
                  child: ListView.separated(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(14),
                    itemCount: list.length + (allLoaded ? 0 : 1),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (!allLoaded && index == list.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(color: AppColors.indigo600Main),
                          ),
                        );
                      }

                      final item = list[index];

                      String formattedDate = "-";
                      if (item.createdAt != null && item.createdAt!.isNotEmpty) {
                        try {
                          final dt = DateTime.parse(item.createdAt!).toLocal();
                          formattedDate = DateFormat("dd/MM/yyyy hh:mm a").format(dt);
                        } catch (_) {
                          formattedDate = item.createdAt ?? "-";
                        }
                      } else if (item.inquiryDate != null && item.inquiryDate!.isNotEmpty) {
                        formattedDate = item.inquiryDate!;
                      }

                      return _draftInquiryCard(item, formattedDate);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),

      /// FLOATING ACTION BUTTON
      floatingActionButton: Obx(
        () => permissionHandler.isDraftInquiryCreateAllowed
            ? FloatingActionButton(
                onPressed: () async {
                  await Get.to(() => const AddDraftInquiryScreen());
                  controller.pageCount.value = 1;
                  controller.getDraftInquiryList(page: 1, fromPagination: false, isLoading: false);
                },
                backgroundColor: AppColors.indigo600Main,
                child: const Icon(Icons.add, color: Colors.white),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  // ================= SEARCH BAR =================
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchController.value,
          onChanged: (value) {
            controller.pageCount.value = 1;
            controller.getDraftInquiryList(
              page: 1,
              search: value.trim(),
              fromPagination: false,
              isLoading: false,
            );
          },
          decoration: InputDecoration(
            hintText: "Search by contact name, company, mobile...",
            hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.indigo600Main),
            suffixIcon: Obx(() {
              if (controller.searchController.value.text.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.clear, size: 18, color: AppColors.gray500),
                  onPressed: () {
                    controller.searchController.value.clear();
                    controller.pageCount.value = 1;
                    controller.getDraftInquiryList(
                      page: 1,
                      search: "",
                      fromPagination: false,
                      isLoading: true,
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            }),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ),
    );
  }

  // ================= DRAFT INQUIRY CARD =================
  Widget _draftInquiryCard(DraftInquiryItem item, String dateStr) {
    final contactName = item.contactName?.isNotEmpty == true ? item.contactName! : "Unknown Contact";
    final companyName = item.companyName?.isNotEmpty == true ? item.companyName! : "";
    final projectName = item.projectName?.isNotEmpty == true ? item.projectName! : "";
    final designation = item.designation?.isNotEmpty == true ? item.designation! : "";
    final mobile = item.mobile1?.isNotEmpty == true ? item.mobile1! : "-";
    final email = item.email?.isNotEmpty == true ? item.email! : "-";
    final remarks = item.remarks?.isNotEmpty == true ? item.remarks! : "";

    // Address construction
    final List<String> addressParts = [];
    if (item.address != null && item.address!.trim().isNotEmpty) {
      addressParts.add(item.address!.trim());
    }
    if (item.cityName != null && item.cityName!.trim().isNotEmpty) {
      addressParts.add(item.cityName!.trim());
    }
    if (item.stateName != null && item.stateName!.trim().isNotEmpty) {
      addressParts.add(item.stateName!.trim());
    }
    if (item.pincode != null && item.pincode!.trim().isNotEmpty) {
      addressParts.add(item.pincode!.trim());
    }
    final fullAddress = addressParts.isNotEmpty ? addressParts.join(", ") : "-";

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray300.withOpacity(0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP SECTION (PERSON NAME + DRAFT BADGE)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    contactName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (item.sourceName != null && item.sourceName!.isNotEmpty)
                  _chip(item.sourceName!, AppColors.orangeColor),
                _draftChip(),
              ],
            ),
          ),

          /// COMPANY / DESIGNATION / PROJECT
          if (companyName.isNotEmpty || designation.isNotEmpty || projectName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (companyName.isNotEmpty)
                    Text(
                      companyName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  if (designation.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        "Designation: $designation",
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  if (projectName.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        "Project: $projectName",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.indigo600Main,
                        ),
                      ),
                    ),
                ],
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
                if (mobile != "-") ...[
                  _detailRow(Icons.phone_android_outlined, mobile),
                  const SizedBox(height: 6),
                ],
                if (email != "-") ...[
                  _detailRow(Icons.email_outlined, email),
                  const SizedBox(height: 6),
                ],
                if (fullAddress != "-") ...[
                  _detailRow(Icons.location_on_outlined, fullAddress),
                  const SizedBox(height: 6),
                ],
                _detailRow(Icons.calendar_today_outlined, dateStr),
                if (remarks.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _detailRow(Icons.note_alt_outlined, remarks),
                ],
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// ACTIONS BAR (EDIT & DELETE)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (permissionHandler.isDraftInquiryUpdateAllowed) ...[
                  _miniAction(Icons.edit_outlined, AppColors.yellow500, () async {
                    if (item.id != null) {
                      await Get.to(() => AddDraftInquiryScreen(isEdit: true, id: item.id, item: item));
                      controller.pageCount.value = 1;
                      controller.getDraftInquiryList(page: 1, fromPagination: false, isLoading: false);
                    }
                  }),
                ],
                if (permissionHandler.isDraftInquiryDeleteAllowed) ...[
                  const SizedBox(width: 12),
                  _miniAction(Icons.delete_outline, AppColors.red600Error, () {
                    if (item.id != null) {
                      _deleteDialog(item.id!);
                    }
                  }),
                ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.indigo600Main.withOpacity(0.7)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  // ================= BADGE CHIPS =================
  Widget _draftChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.indigo600Main.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.indigo600Main.withOpacity(0.3)),
      ),
      child: const Text(
        "Draft",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.indigo600Main,
        ),
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
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
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  // ================= DELETE DIALOG =================
  void _deleteDialog(String id) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.red600Error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline, size: 36, color: AppColors.red600Error),
              ),
              const SizedBox(height: 16),
              const Text(
                "Delete Draft Inquiry?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to delete this draft inquiry? This action cannot be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.gray400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text("Cancel", style: TextStyle(color: AppColors.gray600, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red600Error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        controller.deleteDraftInquiry(id: id);
                      },
                      child: const Text("Delete", style: TextStyle(fontWeight: FontWeight.w600)),
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
