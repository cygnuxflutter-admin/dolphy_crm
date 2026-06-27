import 'package:crm/widget/textfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../widget/button_view.dart';
import '../../../widget/dropdown.dart';
import '../../../widget/toast_message.dart';
import '../lead_controller.dart';
import '../model/lead_type.dart';
import '../model/lead_update_request.dart';

class AddActivityScreen extends StatefulWidget {
  final int index;
  final bool isAdd;
  final bool isMeeting;
  final bool isView;
  final Activity? activity;
  final String? id;

  const AddActivityScreen({super.key, this.index = 0, required this.isMeeting, this.activity, this.isAdd = false, this.isView = false, this.id});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final LeadController leadController = Get.find<LeadController>();

  /// Date-Time
  DateTime? startDateTime;
  DateTime? endDateTime;
  DateTime? followUpDateTime;
  DateTime? reminderDateTime;

  final key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (leadController.oppActivityStatusList.isEmpty) {
      await leadController.getActivityStatus();
    }
    setDefaultActivityStatus();

    if (leadController.oppActivityTypeList.isEmpty) {
      await leadController.getActivityType();
    }
    setActivityDefaults(isMeeting: widget.isMeeting);
    editDataFeel();
  }

  void setDefaultActivityStatus() {
    if (leadController.oppActivityStatusList.isEmpty) return;

    final plannedStatus = leadController.oppActivityStatusList.firstWhereOrNull((e) => e.name.toLowerCase() == 'planned');

    if (plannedStatus != null) {
      leadController.selectedActivityStatus.value = plannedStatus;
    } else {
      leadController.selectedActivityStatus.value = leadController.oppActivityStatusList.first;
    }
  }

  void setActivityDefaults({required bool isMeeting}) {
    if (leadController.oppActivityTypeList.isEmpty) return;

    final type = leadController.oppActivityTypeList
        .expand((datum) => datum.items)
        .firstWhere(
          (item) => widget.isMeeting
              ? (item.codeKey == 'MEETING' || item.name.toLowerCase() == 'meeting')
              : (item.codeKey == 'CALL' || item.name.toLowerCase() == 'call'),
          orElse: () => LeadItem(id: '', name: ''),
        );

    if (type.id.isNotEmpty) {
      leadController.selectedActivityType.value = type;
    }
  }

  void editDataFeel() {
    if (!widget.isAdd && !widget.isView) {
      leadController.selectedActivityType.value = leadController.oppActivityTypeList
          .expand((datum) => datum.items)
          .firstWhere(
            (item) => item.name.toLowerCase() == 'meeting',
            orElse: () => LeadItem(id: '', name: ''),
          );

      debugPrint("selected 111 === ${leadController.selectedActivityType.value!.toJson()}");
      leadController.selectedActivityStatus.value = leadController.oppActivityStatusList.firstWhere(
        (item) => item.id == widget.activity?.activityStatus,
      );
      leadController.startController.value.text = widget.activity?.startTime ?? '';
      leadController.endController.value.text = widget.activity?.endTime ?? '';
      leadController.subjectController.value.text = widget.activity?.subject ?? '';
      leadController.addNotesController.value.text = widget.activity?.description ?? '';
      leadController.followUpDateController.value.text = widget.activity?.followUpDate ?? '';
      leadController.reminderDateController.value.text = widget.activity?.reminderTime ?? '';
    }
  }

  Future<void> pickDateTime({bool isStart = false, bool isReminder = false, bool isFollowUp = false}) async {
    final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));

    if (date == null) return;

    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (time == null) return;

    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    setState(() {
      if (isStart) {
        startDateTime = dateTime;
        leadController.startController.value.text = formatDateTime(dateTime);
      } else if (isReminder) {
        reminderDateTime = dateTime;
        leadController.reminderDateController.value.text = formatDateTime(dateTime);
      } else if (isFollowUp) {
        followUpDateTime = dateTime;
        leadController.followUpDateController.value.text = formatDateTime(dateTime);
      } else {
        endDateTime = dateTime;
        leadController.endController.value.text = formatDateTime(dateTime);
      }
    });
  }

  String formatDateTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';

    return '${dt.year}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')} '
        '${hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')} '
        '$amPm';
  }

  bool isEndTimeValid({required DateTime? start, required DateTime? end}) {
    if (start == null || end == null) return true;
    return !end.isBefore(start);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.indigo600Main,
        title: Text(widget.isMeeting ? "Schedule Meeting" : "Schedule Call", style: const TextStyle(color: AppColors.white)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: key,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Obx(
                    () => CustomDropdown<LeadItem>(
                      hintText: 'Activity Type',
                      enabled: !widget.isView,
                      items: (String filter, LoadProps? loadProps) {
                        return leadController.oppActivityTypeList.expand((datum) => datum.items).toList();
                      },
                      itemAsString: (item) => item.name,
                      selectedItem: leadController.selectedActivityType.value,
                      compareFn: (a, b) => a?.id == b?.id,
                      onChanged: (value) {
                        leadController.selectedActivityType.value = value;
                      },
                    ),
                  ),
                  Obx(
                    () => CustomDropdown<LeadItem>(
                      hintText: 'Status',
                      enabled: !widget.isView,
                      items: (String filter, LoadProps? loadProps) {
                        return leadController.oppActivityStatusList;
                      },
                      itemAsString: (item) => item.name,
                      selectedItem: leadController.selectedActivityStatus.value,
                      compareFn: (a, b) => a?.id == b?.id,
                      onChanged: (value) {
                        leadController.selectedActivityStatus.value = value;
                      },
                    ),
                  ),
                  commonTextField(
                    labelText: "Start",
                    hintText: "mm/dd/yyyy --:-- --",
                    controller: leadController.startController.value,
                    readOnly: true,
                    needValidation: true,
                    validationMessage: "Start time required",
                    suffixIcon: const Icon(Icons.calendar_today),
                    onTap: () => pickDateTime(isStart: true),
                  ),
                  commonTextField(
                    labelText: "End",
                    hintText: "mm/dd/yyyy --:-- --",
                    controller: leadController.endController.value,
                    readOnly: true,
                    needValidation: true,
                    validationMessage: "End time required",
                    suffixIcon: const Icon(Icons.calendar_today),
                    onTap: () => pickDateTime(),
                  ),
                  commonTextField(
                    labelText: "Subject",
                    hintText: "Enter Subject",
                    controller: leadController.subjectController.value,
                    needValidation: true,
                    validationMessage: "Subject required",
                    textInputType: TextInputType.text,
                  ),
                  commonTextField(controller: leadController.addNotesController.value, maxLine: 4, labelText: 'Notes', hintText: "Enter notes..."),

                  if (widget.isMeeting)
                    commonTextField(
                      labelText: "Call Medium",
                      hintText: "Zoom / Google Meet / Phone",
                      controller: leadController.callMediumController.value,
                    ),
                  commonTextField(
                    labelText: "Follow Up Date",
                    hintText: "mm/dd/yyyy --:-- --",
                    controller: leadController.followUpDateController.value,
                    readOnly: true,
                    suffixIcon: const Icon(Icons.calendar_today),
                    onTap: () => pickDateTime(isFollowUp: true),
                  ),
                  commonTextField(
                    labelText: "Reminder Time",
                    hintText: "mm/dd/yyyy --:-- --",
                    controller: leadController.reminderDateController.value,
                    readOnly: true,
                    suffixIcon: const Icon(Icons.calendar_today),
                    onTap: () => pickDateTime(isReminder: true),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => CheckboxListTile(
                            value: leadController.isMarkDone.value,
                            onChanged: (v) => leadController.isMarkDone.value = v ?? false,
                            title: const Text("Mark as done"),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppColors.indigo600Main,
                            checkColor: AppColors.white,
                            side: BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Obx(
                          () => CheckboxListTile(
                            value: leadController.isReminderSent.value,
                            onChanged: (v) => leadController.isReminderSent.value = v ?? false,
                            title: const Text("Reminder Sent"),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppColors.indigo600Main,
                            checkColor: AppColors.white,
                            side: BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                            leadController.startController.value.clear();
                            leadController.endController.value.clear();
                            leadController.subjectController.value.clear();
                            leadController.callMediumController.value.clear();
                            leadController.addNotesController.value.clear();
                            leadController.followUpDateController.value.clear();
                            leadController.reminderDateController.value.clear();
                            leadController.isReminderSent.value = false;
                            leadController.isMarkDone.value = false;
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: commonButton(
                          loaderColorWhite: true,
                          name: 'Save',
                          bgColor: AppColors.indigo600Main,
                          isLoader: widget.isView ? leadController.isActivityCreateLoading.value : false,
                          onTap: () {
                            if (key.currentState!.validate()) {
                              if (!isEndTimeValid(start: startDateTime, end: endDateTime)) {
                                toastMessage(text: "End time should be greater than start time");
                                return;
                              }
                              if (widget.isAdd) {
                                leadController.activityList.add(
                                  Activity(
                                    activityStatus: leadController.selectedActivityStatus.value?.id ?? '',
                                    activityType: leadController.selectedActivityType.value?.id ?? '',
                                    subject: leadController.subjectController.value.text,
                                    startTime: leadController.startController.value.text,
                                    endTime: leadController.endController.value.text,
                                    followUpDate: leadController.followUpDateController.value.text,
                                    reminderTime: leadController.reminderDateController.value.text,
                                    description: leadController.addNotesController.value.text,
                                    // type: widget.isMeeting ? "meeting" : "call",
                                    callMedium: leadController.callMediumController.value.text,
                                    link: '',
                                  ),
                                );
                                Get.back();
                              } else if (widget.isView) {
                                leadController.activityCreate(
                                  activityStatusId: leadController.selectedActivityStatus.value?.id ?? '',
                                  activityTypeId: leadController.selectedActivityType.value?.id ?? '',
                                  subject: leadController.subjectController.value.text,
                                  startTime: leadController.startController.value.text,
                                  endTime: leadController.endController.value.text,
                                  followUpDate: leadController.followUpDateController.value.text,
                                  reminderTime: leadController.reminderDateController.value.text,
                                  description: leadController.addNotesController.value.text,
                                  callMedium: leadController.callMediumController.value.text,
                                  opportunityId: widget.id!,
                                  invitationStatus: 'Pending',
                                  isReminderSent: leadController.isReminderSent.value,
                                );
                              } else {
                                leadController.activityList[widget.index] = Activity(
                                  id: leadController.activityList[widget.index].id ?? "",
                                  activityStatus: leadController.activityList[widget.index].activityStatus ?? '',
                                  activityType: leadController.activityList[widget.index].activityType ?? '',
                                  subject: leadController.subjectController.value.text,
                                  startTime: leadController.startController.value.text,
                                  endTime: leadController.endController.value.text,
                                  followUpDate: leadController.followUpDateController.value.text,
                                  reminderTime: leadController.reminderDateController.value.text,
                                  description: leadController.addNotesController.value.text,
                                  // type: widget.isMeeting ? "meeting" : "call",
                                  callMedium: leadController.callMediumController.value.text,
                                  link: '',
                                );
                                Get.back();
                              }

                              leadController.startController.value.clear();
                              leadController.endController.value.clear();
                              leadController.subjectController.value.clear();
                              leadController.addNotesController.value.clear();
                              leadController.followUpDateController.value.clear();
                              leadController.reminderDateController.value.clear();
                              leadController.isReminderSent.value = false;
                              leadController.isMarkDone.value = false;
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
}
