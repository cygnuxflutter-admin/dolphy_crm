import 'package:crm/widget/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../widget/button_view.dart';
import '../lead_controller.dart';
import '../model/lead_type.dart';
import '../model/lead_update_request.dart';
import '../sub_screen/add_activity_screen.dart';

class LeadDetailsMobile extends StatefulWidget {
  final LeadController leadController;

  const LeadDetailsMobile({super.key, required this.leadController});

  @override
  State<LeadDetailsMobile> createState() => _LeadDetailsMobileState();
}

class _LeadDetailsMobileState extends State<LeadDetailsMobile> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [_segmentItem("Notes", 0), _segmentItem("Activity", 1)]),
          ),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: Tween<double>(begin: 0.98, end: 1.0).animate(animation), child: child),
                );
              },
              child: _buildTabContent(widget.leadController),
            ),
          ),
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
          decoration: BoxDecoration(color: isSelected ? AppColors.indigo600Main : Colors.transparent, borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(color: isSelected ? AppColors.white : AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 14),
              child: Text(title),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(LeadController leadController) {
    switch (selectedIndex) {
      case 0:
        return KeyedSubtree(key: const ValueKey(0), child: _InternalNotesTab(leadController));
      case 1:
        return KeyedSubtree(key: const ValueKey(2), child: _ActivityTab(leadController));
      default:
        return const SizedBox();
    }
  }
}

class _InternalNotesTab extends StatelessWidget {
  final LeadController leadController;

  const _InternalNotesTab(this.leadController);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: commonButton(
                icon: Icons.note_add_outlined,
                name: 'Add Log',
                bgColor: AppColors.indigo600Main,
                onTap: () => _addLogBottomSheet(context),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: leadController.logsList.isEmpty
                  ? const Center(
                      child: Text('No logs yet', style: TextStyle(color: Colors.grey)),
                    )
                  : Obx(() {
                      return ListView.builder(
                        itemCount: leadController.logsList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                              color: AppColors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        leadController.logsList[index].notes!,
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
                                      ),
                                      if (leadController.logsList[index].reminderDate != "") ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          leadController.logsList[index].reminderDate!,
                                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                        ),
                                      ],

                                      if (leadController.logsList[index].attachmentUrl!.isNotEmpty)
                                        SizedBox(
                                          height: 110,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, i) {
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child: Image.network(leadController.logsList[index].attachmentUrl![i]),
                                                ),
                                              );
                                            },
                                            itemCount: leadController.logsList[index].attachmentUrl!.length,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                GestureDetector(
                                  onTap: () {
                                    leadController.logsList.removeAt(index);
                                  },
                                  child: const Icon(Icons.delete, color: AppColors.red600Error, size: 22),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
            ),
          ],
        ),
      );
    });
  }
}

void _addLogBottomSheet(BuildContext context) {
  LeadController leadController = Get.find<LeadController>();
  final key = GlobalKey<FormState>();

  Get.bottomSheet(
    isScrollControlled: true,
    SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                const Text(
                  'Add Log',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 20),
                commonTextField(
                  controller: leadController.reminderDateController.value,
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      leadController.reminderDateController.value.text = DateFormat('d, MMMM, yyyy').format(picked);
                    }
                  },
                  labelText: 'Reminder Date',
                  hintText: "Select Date (optional)",
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                ),
                const SizedBox(height: 8),
                commonTextField(
                  controller: leadController.logDetailController.value,
                  maxLine: 4,
                  needValidation: true,
                  labelText: 'Log Details *',
                  hintText: "Type your log here...",
                ),
                const SizedBox(height: 8),
                Text(
                  'Attachment (optional)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
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
                      border: Border.all(color: AppColors.border),
                      color: AppColors.gray50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo_outlined, size: 32, color: AppColors.gray400),
                        SizedBox(height: 8),
                        Text(
                          'Add Image',
                          style: TextStyle(color: AppColors.gray500, fontWeight: FontWeight.w500),
                        ),
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
                Row(
                  children: [
                    Expanded(
                      child: commonButton(
                        name: 'Cancel',
                        borderColor: AppColors.indigo600Main,
                        iconColor: AppColors.indigo600Main,
                        textColor: AppColors.indigo600Main,
                        onTap: () {
                          Get.back();
                          leadController.reminderDateController.value.clear();
                          leadController.logDetailController.value.clear();
                          leadController.uploadedImageLink.clear();
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: commonButton(
                        name: 'Save Log',
                        bgColor: AppColors.indigo600Main,
                        onTap: () {
                          if (key.currentState!.validate()) {
                            leadController.logsList.add(
                              Log(
                                reminderDate: leadController.dateConverter(leadController.reminderDateController.value.text),
                                notes: leadController.logDetailController.value.text,
                                attachmentUrl: List.generate(leadController.uploadedImageLink.length, (i) {
                                  return leadController.uploadedImageLink[i];
                                }),
                              ),
                            );
                            leadController.logsList.refresh();
                            debugPrint("Log data === ${leadController.logsList.first.toJson()}");

                            leadController.reminderDateController.value.clear();
                            leadController.logDetailController.value.clear();
                            leadController.uploadedImageLink.clear();
                            Get.back();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _ActivityTab extends StatelessWidget {
  const _ActivityTab(this.leadController);

  final LeadController leadController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: commonButton(
                  icon: Icons.call_outlined,
                  name: 'Add Call',
                  onTap: () {
                    Get.to(AddActivityScreen(isMeeting: false, isView: false, isAdd: true));
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
                    Get.to(() => AddActivityScreen(isMeeting: true, isView: false, isAdd: true));
                  },
                  borderColor: AppColors.indigo600Main,
                  iconColor: AppColors.indigo600Main,
                  textColor: AppColors.indigo600Main,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: leadController.activityList.length,
                itemBuilder: (context, index) {
                  final activity = leadController.activityList[index];
                  final duration = leadController.calculateDurationInMinutes(activity.startTime!, activity.endTime!);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
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
                                    size: 18,
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
                                  const SizedBox(width: 8),
                                  Text(
                                    activity.subject!,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "When : ${leadController.formatDateTime(activity.startTime!)} – ${leadController.formatDateTime(activity.endTime!)}",
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Duration : $duration min",
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => AddActivityScreen(
                                isMeeting:
                                    activity.activityType ==
                                    leadController.oppActivityTypeList
                                        .expand((datum) => datum.items)
                                        .firstWhere(
                                          (item) => item.name.toLowerCase() == 'meeting',
                                          orElse: () => LeadItem(id: '', name: ''),
                                        )
                                        .id,
                                activity: activity,
                                isAdd: false,
                                index: index,
                                isView: false,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.indigo600Main),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.edit, size: 12, color: AppColors.indigo600Main),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
