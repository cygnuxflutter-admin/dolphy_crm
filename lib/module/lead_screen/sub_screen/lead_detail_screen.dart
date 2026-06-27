import 'package:crm/module/lead_screen/sub_screen/add_activity_screen.dart';
import 'package:crm/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../widget/button_view.dart';
import '../lead_controller.dart';
import '../model/lead_type.dart';

class LeadDetailScreen extends StatefulWidget {
  const LeadDetailScreen({super.key});

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  int selectedIndex = 0;
  LeadController leadController = Get.find<LeadController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      leadController.opportunityLogDateController.value.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Lead Details",
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.white),
        ),
        backgroundColor: AppColors.indigo600Main,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (leadController.isOpportunityLoading.isTrue) {
              return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
            } else if (leadController.isOpportunityLoading.isFalse && leadController.leadViewData.value == null) {
              return Center(child: Image.asset(AppImages.noDataFound, scale: 3));
            } else {
              return Column(
                children: [
                  _headerCard(),
                  const SizedBox(height: 14),
                  _infoCard(),
                  leadController.leadViewData.value!.assignmentHistory!.isEmpty
                      ? SizedBox()
                      : Column(children: [const SizedBox(height: 14), _leadAssignedList()]),
                  const SizedBox(height: 14),
                  _logActivityCard(),
                ],
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat("dd MMM yyyy HH:mm").format(DateTime.parse(leadController.leadViewData.value!.opportunity!.createdAt!)),
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Text(
            "${leadController.leadViewData.value!.opportunity!.customerName}'s Opportunity",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          Text(
            "Expected Revenue: ${leadController.leadViewData.value!.opportunity!.expectedAmount}  •  Probability: ${leadController.leadViewData.value!.opportunity!.probability}%",
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          Obx(() {
            final selected = leadController.selectedOpportunitySection.value;

            return GestureDetector(
              onTap: () => _openSectionBottomSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selected != null ? AppColors.indigo600Main : AppColors.gray300, width: 1.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selected?.name ?? "Select Section",
                      style: TextStyle(color: selected != null ? AppColors.indigo600Main : AppColors.gray500, fontWeight: FontWeight.w500),
                    ),
                    const Icon(Icons.keyboard_arrow_down, color: AppColors.indigo600Main),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _openSectionBottomSheet(BuildContext context) {
    final searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 500,
            padding: const EdgeInsets.all(16),
            child: StatefulBuilder(
              builder: (context, setState) {
                final filteredList = leadController.opportunitySectionList
                    .where((element) => element.name.toLowerCase().contains(searchController.text.toLowerCase()))
                    .toList();

                return Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search Section",
                        prefixIcon: const Icon(Icons.search, color: AppColors.indigo600Main),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.indigo600Main, width: 1.5),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: filteredList.isEmpty
                          ? const Center(child: Text("No Data Found"))
                          : ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final item = filteredList[index];
                                final isSelected = leadController.selectedOpportunitySection.value?.id == item.id;

                                return ListTile(
                                  title: Text(
                                    item.name,
                                    style: TextStyle(
                                      color: isSelected ? AppColors.indigo600Main : Colors.black,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                  trailing: isSelected ? const Icon(Icons.check, color: AppColors.indigo600Main) : null,
                                  onTap: () {
                                    leadController.selectedOpportunitySection.value = item;
                                    leadController.updateOpportunitySection(
                                      id: leadController.leadViewData.value!.opportunity!.id!,
                                      sectionId: item.id,
                                      sectionName: item.name,
                                    );
                                    Get.back();
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _infoRow("Opportunity Name", leadController.leadViewData.value!.opportunity!.opportunityName!),
          _infoRow("Owner", leadController.leadViewData.value!.opportunity!.salesPersonName!),
          _infoRow(
            "Close Date",
            leadController.leadViewData.value!.opportunity!.expectedClosingDate.isEmpty
                ? "-"
                : DateFormat("dd MMM yyyy").format(DateTime.parse(leadController.leadViewData.value!.opportunity!.expectedClosingDate!)),
          ),
          _infoRow("Stage", leadController.leadViewData.value!.opportunity.sectionName),
          _infoRow("Probability", "${leadController.leadViewData.value!.opportunity.probability}%"),
          _infoRow("Description / Remarks", leadController.leadViewData.value!.opportunity.remarks),
        ],
      ),
    );
  }

  Widget _leadAssignedList() {
    final assignments = leadController.leadViewData.value!.assignmentHistory;
    return Container(
      padding: EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Text(
            "Lead Assigned",
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.black, fontSize: 18),
          ),
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final data = assignments[index];
              return _leadAssignedItem(dateTime: data.assignedAt, assignedBy: data.assignedByName, assignedTo: data.assignedToName);
            },
          ),
        ],
      ),
    );
  }

  Widget _leadAssignedItem({required String dateTime, required String assignedBy, required String assignedTo}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.indigo600Main,
            child: Text(
              assignedTo.isNotEmpty ? assignedTo[0].toUpperCase() : "-",
              style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(width: 12),

          /// Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Date", style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                Text(DateFormat('dd MMM y , hh:mm a').format(DateTime.parse(dateTime)), style: const TextStyle(fontWeight: FontWeight.w600)),

                const Text("Assigned By", style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                Text(assignedBy, style: const TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 6),

                const Row(
                  children: [
                    Icon(Icons.arrow_downward, size: 14, color: AppColors.gray500),
                    SizedBox(width: 4),
                    Text("Assigned To", style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),

                Text(
                  assignedTo,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.indigo600Main),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _logActivityCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gray200),
            ),
            child: Row(children: [_segmentItem("Log Note", 0), _segmentItem("Activities", 1)]),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: _buildTabContent(),
          ),
          const SizedBox(height: 15),
          _activityItem(isLogs: selectedIndex == 0),
        ],
      ),
    );
  }

  Widget _segmentItem(String title, int index) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (selectedIndex == index) return;

          setState(() {
            selectedIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: isSelected ? AppColors.indigo600Main : AppColors.transparent, borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(color: isSelected ? AppColors.white : AppColors.black, fontWeight: FontWeight.w600, fontSize: 14),
              child: Text(title),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedIndex) {
      case 0:
        return KeyedSubtree(
          key: const ValueKey(0),
          child: Column(
            children: [
              const SizedBox(height: 14),
              commonTextField(
                labelText: "Select reminder date (optional)",
                hintText: "Select Date",
                controller: leadController.opportunityLogDateController.value,
                suffixIcon: const Icon(Icons.calendar_month),
                textInputType: TextInputType.none,
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              Form(
                key: formKey,
                child: commonTextField(
                  needValidation: true,
                  labelText: "Type your log",
                  hintText: "Type your log here...",
                  controller: leadController.opportunityLogDetailsController.value,
                  validationMessage: "Type your log",
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  leadController.openImagePickerSheet();
                },
                child: Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gray300),
                    color: AppColors.gray50,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 32, color: AppColors.gray400),
                      SizedBox(height: 6),
                      Text('Add Image', style: TextStyle(color: AppColors.gray500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() {
                return leadController.uploadedImageLink.isNotEmpty
                    ? SizedBox(
                        height: 110,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(height: 100, width: 100, child: Image.network(leadController.uploadedImageLink[index])),
                            );
                          },
                          itemCount: leadController.uploadedImageLink.length,
                        ),
                      )
                    : SizedBox();
              }),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 80,
                    height: 30,
                    child: commonButton(
                      radius: 12,
                      name: 'Cancel',
                      textColor: AppColors.textSecondary,
                      borderColor: AppColors.gray300,
                      bgColor: AppColors.white,
                      onTap: () {
                        leadController.opportunityLogDateController.value.clear();
                        leadController.opportunityLogDetailsController.value.clear();
                        leadController.uploadedImageLink.clear();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    height: 30,
                    child: commonButton(
                      radius: 12,
                      isLoader: leadController.isAddLogLoading.value,
                      name: 'Save Log',
                      bgColor: AppColors.indigo600Main,
                      loaderColorWhite: true,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          leadController.addLog(id: leadController.leadViewData.value!.opportunity.id);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const Divider(height: 30),
            ],
          ),
        );
      case 1:
        return KeyedSubtree(
          key: const ValueKey(2),
          child: Row(
            children: [
              Expanded(
                child: commonButton(
                  icon: Icons.call_outlined,
                  name: 'Add Call',
                  onTap: () {
                    Get.to(() => AddActivityScreen(isMeeting: false, isView: true, id: leadController.leadViewData.value!.opportunity.id));
                  },
                  bgColor: AppColors.indigo600Main,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: commonButton(
                  icon: Icons.meeting_room_outlined,
                  name: 'Add Meeting',
                  onTap: () {
                    Get.to(() => AddActivityScreen(isMeeting: true, isView: true, id: leadController.leadViewData.value!.opportunity.id));
                  },
                  borderColor: AppColors.indigo600Main,
                  iconColor: AppColors.indigo600Main,
                  textColor: AppColors.indigo600Main,
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _activityItem({required bool isLogs}) {
    final logs = leadController.leadViewData.value!.leadViewLogs;
    final activities = leadController.leadViewData.value!.leadViewActivities;

    return isLogs
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final data = logs[index];

              final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(data.createdAt));
              final previousDate = index > 0 ? DateFormat('yyyy-MM-dd').format(DateTime.parse(logs[index - 1].createdAt)) : null;

              final bool showDateHeader = index == 0 || currentDate != previousDate;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showDateHeader)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Divider(color: AppColors.gray600, height: 1),
                              ),
                            ),
                            Text(
                              DateFormat('dd MMMM yyyy').format(DateTime.parse(data.createdAt)),
                              style: TextStyle(fontSize: 12, color: AppColors.gray600, fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Divider(color: AppColors.gray600, height: 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.indigo600Light,
                          child: Text(
                            data.createdByName.isEmpty ? "-" : data.createdByName.trim()[0].toUpperCase(),
                            style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: data.createdByName,
                                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: "  •  ${timeAgo(data.createdAt)}",
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text("• ${data.notes}", style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  data.attachmentUrl.isNotEmpty
                      ? SizedBox(
                          height: 110,
                          child: ListView.builder(
                            itemCount: data.attachmentUrl.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(height: 100, width: 100, child: Image.network(data.attachmentUrl[index])),
                              );
                            },
                          ),
                        )
                      : SizedBox(),
                ],
              );
            },
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              final duration = leadController.calculateDurationInMinutes(activity.startTime, activity.endTime);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gray200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                activity.activityType ==
                                        leadController.oppActivityTypeList
                                            .expand((datum) => datum.items)
                                            .firstWhere(
                                              (item) => item.name.toLowerCase() == 'meeting',
                                              orElse: () => LeadItem(id: '', name: ''),
                                            )
                                            .id
                                    ? Icons.meeting_room
                                    : Icons.call,
                                size: 16,
                                color:
                                    activity.activityType ==
                                        leadController.oppActivityTypeList
                                            .expand((datum) => datum.items)
                                            .firstWhere(
                                              (item) => item.name.toLowerCase() == 'meeting',
                                              orElse: () => LeadItem(id: '', name: ''),
                                            )
                                            .id
                                    ? AppColors.green500Success
                                    : AppColors.indigo600Main,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                activity.subject,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "When : ${leadController.formatDateTime(activity.startTime)} – ${leadController.formatDateTime(activity.endTime)}",
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text("Duration : $duration min", style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text(
                            "Created : ${leadController.formatDateTime(activity.createdAt)}",
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  String timeAgo(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
    final DateTime now = DateTime.now();

    final Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(title, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
              style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
    );
  }
}
