import 'package:crm/module/lead_screen/sub_screen/add_activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../widget/button_view.dart';
import '../lead_controller.dart';

class LeadDetailScreen extends StatefulWidget {
  const LeadDetailScreen({super.key});

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  int selectedTab = 0; // 0: Lead Assigned, 1: Activities, 2: Secondary Sales, 3: Contact Details
  int selectedTimelineTab = 0; // 0: View Log, 1: View Activity
  LeadController leadController = Get.find<LeadController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController _stagesScrollController = ScrollController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      leadController.opportunityLogDateController.value.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  void initState() {
    super.initState();
    if (leadController.opportunitySectionList.isEmpty) {
      leadController.getOpportunitySection();
    }
  }

  @override
  void dispose() {
    _stagesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Lead Details",
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.black),
        ),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
      ),

      body: SafeArea(
        child: Obx(() {
          if (leadController.isOpportunityLoading.isTrue) {
            return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
          } else if (leadController.isOpportunityLoading.isFalse && leadController.leadViewData.value == null) {
            return Center(child: Image.asset(AppImages.noDataFound, scale: 3));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leadController.opportunitySectionList.isNotEmpty) ...[_stagesBreadcrumbs(), const SizedBox(height: 16)],
                  _headerSection(),
                  const SizedBox(height: 20),
                  _identityAndContactCard(),
                  const SizedBox(height: 20),
                  _summaryCard(),
                  const SizedBox(height: 20),
                  _tabsSection(),
                  const SizedBox(height: 20),
                  _tabContent(),
                  const SizedBox(height: 28),
                  _activityTimelineSection(),
                ],
              ),
            );
          }
        }),
      ),
    );
  }

  // Header showing Name, Company, Value, Probability, Close Date
  Widget _headerSection() {
    final opp = leadController.leadViewData.value!.opportunity;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            opp.customerName.isNotEmpty ? opp.customerName.toUpperCase() : "-",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            opp.opportunityName.isNotEmpty ? opp.opportunityName.toUpperCase() : "-",
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _headerStatItem(Icons.monetization_on_outlined, "₹${opp.expectedAmount}", "ESTIMATED VALUE"),
              _headerStatItem(Icons.pie_chart_outline, "${opp.probability}%", "PROBABILITY"),
              _headerStatItem(
                Icons.calendar_today_outlined,
                opp.expectedClosingDate.isEmpty ? "-" : DateFormat("dd MMM yyyy").format(DateTime.parse(opp.expectedClosingDate)),
                "CLOSE DATE",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerStatItem(IconData icon, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.indigo600Light.withOpacity(0.1),
          child: Icon(icon, size: 16, color: AppColors.indigo600Main),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  // Stages Breadcrumb
  Widget _stagesBreadcrumbs() {
    return Obx(() {
      if (leadController.opportunitySectionList.isEmpty) return const SizedBox.shrink();

      return Container(
        height: 44,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.gray200),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _stagesScrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: leadController.opportunitySectionList.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;
                final bool isSelected = leadController.selectedOpportunitySection.value?.id == item.id;
                final bool isFirst = index == 0;
                final bool isLast = index == leadController.opportunitySectionList.length - 1;
                const double arrowWidth = 12.0;

                return Align(
                  widthFactor: isFirst ? 1.0 : 0.78,
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      leadController.selectedOpportunitySection.value = item;
                      leadController.updateOpportunitySection(
                        id: leadController.leadViewData.value!.opportunity.id!,
                        sectionId: item.id,
                        sectionName: item.name,
                      );
                    },
                    child: ClipPath(
                      clipper: ChevronClipper(isFirst: isFirst, isLast: isLast),
                      child: Container(
                        padding: EdgeInsets.only(left: isFirst ? 24 : 24 + arrowWidth, right: isLast ? 24 : 24 + arrowWidth),
                        height: 34,
                        alignment: Alignment.center,
                        color: isSelected ? AppColors.green500Success : AppColors.gray100,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) ...[const Icon(Icons.check, size: 14, color: AppColors.white), const SizedBox(width: 4)],
                            Text(
                              item.name,
                              style: TextStyle(
                                color: isSelected ? AppColors.white : AppColors.gray600,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }

  // Identity & Contact Details
  Widget _identityAndContactCard() {
    final opp = leadController.leadViewData.value!.opportunity;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.person_outline, size: 20, color: AppColors.indigo600Main),
              SizedBox(width: 8),
              Text(
                "Identity & Contact Details",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _detailRow(
            "COMPANY NAME",
            opp.companyName.isNotEmpty ? opp.companyName : (opp.opportunityName.isNotEmpty ? opp.opportunityName : "-"),
            "CUSTOMER NAME",
            opp.customerName,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.gray200),
          ),
          _detailRow("OWNER", opp.salesPersonName, "PROBABILITY", "${opp.probability}%"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.gray200),
          ),
          _detailRow("CONTACT MO", opp.mobile1, "EMAIL", opp.email),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.gray200),
          ),
          _detailRow("GST NO", opp.customerGstNumber, "LOCATION", opp.locationCode),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.gray200),
          ),
          _detailRow("CITY", opp.cityName, "STATE", opp.stateName),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.gray200),
          ),
          _detailFullRow("ADDRESS", opp.address),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.gray200),
          ),
          _detailFullRow("REMARKS", opp.remarks),
        ],
      ),
    );
  }

  Widget _detailRow(String key1, String val1, String key2, String val2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _detailKeyValue(key1, val1)),
        const SizedBox(width: 16),
        Expanded(child: _detailKeyValue(key2, val2)),
      ],
    );
  }

  Widget _detailFullRow(String key, String value) {
    return _detailKeyValue(key, value);
  }

  Widget _detailKeyValue(String key, String value) {
    final displayValue = value.isNotEmpty ? value : "-";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          displayValue,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  // Summary Card
  Widget _summaryCard() {
    final summary = leadController.leadViewData.value!.summary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SUMMARY",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.indigo600Light.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.indigo600Main.withOpacity(0.2),
                        child: const Icon(Icons.calendar_month_outlined, size: 18, color: AppColors.indigo600Main),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Activities", style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          Text(summary.totalActivities.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.orange.withOpacity(0.2),
                        child: const Icon(Icons.description_outlined, size: 18, color: Colors.orange),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Quotations", style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${summary.totalQuotations} ",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                                TextSpan(
                                  text: "₹${summary.totalQuotationValue}",
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.green500Success),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  // Tabs Section
  Widget _tabsSection() {
    final leadAssignedCount = leadController.leadViewData.value?.assignmentHistory.length ?? 0;
    final activitiesCount = leadController.leadViewData.value?.leadViewActivities.length ?? 0;
    final secondarySalesCount = leadController.leadViewData.value?.secondarySalesPersons.length ?? 0;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray200),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _tabItem("Lead Assigned", Icons.person_add_alt_1_outlined, 0, badgeCount: leadAssignedCount),
            _tabItem("Activities", Icons.list_alt, 1, badgeCount: activitiesCount),
            _tabItem("Secondary Sales", Icons.people_outline, 2, badgeCount: secondarySalesCount),
            _tabItem("Contact Details", Icons.call_outlined, 3),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String title, IconData icon, int index, {int? badgeCount}) {
    final bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isSelected ? AppColors.indigo600Main : Colors.transparent, width: 2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isSelected ? AppColors.indigo600Main : AppColors.gray500),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? AppColors.indigo600Main : AppColors.gray600,
              ),
            ),
            if (badgeCount != null && badgeCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.indigo600Light.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Tab Content
  Widget _tabContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Builder(
        builder: (context) {
          if (selectedTab == 0) {
            return _leadAssignedList();
          } else if (selectedTab == 1) {
            return _activitiesList();
          } else if (selectedTab == 2) {
            return _secondarySalesList();
          } else {
            return _contactDetailsTab();
          }
        },
      ),
    );
  }

  Widget _leadAssignedList() {
    final assignments = leadController.leadViewData.value!.assignmentHistory;
    if (assignments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text("No previous assignments available.", style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(color: Color(0xFFF1F3F5)),
              child: Row(
                children: const [
                  SizedBox(
                    width: 160,
                    child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  SizedBox(
                    width: 150,
                    child: Text("Assigned by", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  SizedBox(
                    width: 150,
                    child: Text("Assigned to", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
            ...assignments.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: Text(
                            DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(data.assignedAt)),
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(data.assignedByName, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(data.assignedToName, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        ),
                      ],
                    ),
                  ),
                  if (index < assignments.length - 1) const Divider(height: 1, color: AppColors.gray200),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _activitiesList() {
    final activities = leadController.leadViewData.value!.leadViewActivities;
    if (activities.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text("No activities found.", style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final activity = activities[index];
        final startTime = DateTime.tryParse(activity.startTime) ?? DateTime.now();
        final endTime = DateTime.tryParse(activity.endTime) ?? DateTime.now();
        final timeString = "${DateFormat('dd MMM yyyy, hh:mm a').format(startTime)} - ${DateFormat('hh:mm a').format(endTime)}";

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.gray200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    activity.activityTypeName.toLowerCase() == 'meeting' ? Icons.groups_outlined : Icons.call_outlined,
                    size: 16,
                    color: AppColors.green500Success,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      activity.subject.isNotEmpty ? activity.subject : "-",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(4)),
                    child: const Icon(Icons.edit_outlined, size: 14, color: AppColors.indigo600Main),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    activity.invitationStatus.isNotEmpty ? activity.invitationStatus : "Pending",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.orange),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                activity.description.isNotEmpty ? activity.description : "-",
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.gray200),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.access_time_outlined, size: 14, color: AppColors.indigo600Main),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(timeString, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ),
                  const Icon(Icons.person_outline, size: 14, color: AppColors.indigo600Main),
                  const SizedBox(width: 4),
                  Text(activity.createdByName.split(" ").first, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.green500Success),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.green500Success),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _secondarySalesList() {
    final secondarySales = leadController.leadViewData.value!.secondarySalesPersons;
    if (secondarySales.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text("No secondary sales persons assigned.", style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(color: Color(0xFFF1F3F5)),
              child: Row(
                children: const [
                  SizedBox(
                    width: 140,
                    child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  SizedBox(
                    width: 180,
                    child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  SizedBox(
                    width: 140,
                    child: Text("Assigned By", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
            ...secondarySales.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: Text(data.user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        SizedBox(
                          width: 180,
                          child: Text(data.user.email, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        ),
                        SizedBox(
                          width: 140,
                          child: Text(data.assignedByName, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                        ),
                      ],
                    ),
                  ),
                  if (index < secondarySales.length - 1) const Divider(height: 1, color: AppColors.gray200),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _contactDetailsTab() {
    final opp = leadController.leadViewData.value!.opportunity;
    final contact = opp.contactPersonData;

    if (contact == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text("No contact details available.", style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    final name = "${contact.firstName} ${contact.lastName}".trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _contactRow("Name", name),
          const SizedBox(height: 12),
          _contactRow("Mobile", contact.mobileNumber),
          const SizedBox(height: 12),
          _contactRow("Alt Mobile", contact.mobileAlt),
          const SizedBox(height: 12),
          _contactRow("Email", contact.emailId),
          const SizedBox(height: 12),
          _contactRow("Designation", contact.designation),
          const SizedBox(height: 12),
          _contactRow("Address", contact.address),
          const SizedBox(height: 12),
          _contactRow("Country", contact.countryName),
          const SizedBox(height: 12),
          _contactRow("State", contact.stateName),
          const SizedBox(height: 12),
          _contactRow("City", contact.cityName),
          const SizedBox(height: 12),
          _contactRow("Pincode", contact.pincodeName),
          const SizedBox(height: 12),
          _contactRow("Notes", contact.notes),
        ],
      ),
    );
  }

  Widget _contactRow(String label, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
          ),
          TextSpan(
            text: value.isNotEmpty ? value : "-",
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  void _openActivitySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Add Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: commonButton(
                      icon: Icons.call_outlined,
                      name: 'Add Call',
                      onTap: () {
                        Get.back();
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
                        Get.back();
                        Get.to(() => AddActivityScreen(isMeeting: true, isView: true, id: leadController.leadViewData.value!.opportunity.id));
                      },
                      borderColor: AppColors.indigo600Main,
                      iconColor: AppColors.indigo600Main,
                      textColor: AppColors.indigo600Main,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
            ],
          ),
        );
      },
    );
  }

  Widget _activityTimelineSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ACTIVITY TIMELINE",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          _logsList(),
        ],
      ),
    );
  }

  Widget _logsList() {
    final logs = leadController.leadViewData.value!.leadViewLogs;
    if (logs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text("No logs found.", style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }
    return ListView.builder(
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
                child: Text(
                  DateFormat('dd MMM yyyy').format(DateTime.parse(data.createdAt)).toUpperCase(),
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                ),
              ),
            Container(
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
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.indigo600Light,
                    child: Text(
                      data.createdByName.isEmpty ? "-" : data.createdByName.trim()[0].toUpperCase(),
                      style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.createdByName,
                              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(data.createdAt)),
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(data.notes, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                        if (data.attachmentUrl.isNotEmpty) const SizedBox(height: 12),
                        if (data.attachmentUrl.isNotEmpty)
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              itemCount: data.attachmentUrl.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: SizedBox(height: 60, width: 60, child: Image.network(data.attachmentUrl[i], fit: BoxFit.cover)),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String timeAgo(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);
    if (difference.inSeconds < 60) return '${difference.inSeconds} seconds ago';
    if (difference.inMinutes < 60) return '${difference.inMinutes} minutes ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30) return '${(difference.inDays / 7).floor()} weeks ago';
    if (difference.inDays < 365) return '${(difference.inDays / 30).floor()} months ago';
    return '${(difference.inDays / 365).floor()} years ago';
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
    );
  }
}

class ChevronClipper extends CustomClipper<Path> {
  final bool isFirst;
  final bool isLast;

  ChevronClipper({this.isFirst = false, this.isLast = false});

  @override
  Path getClip(Size size) {
    Path path = Path();
    double arrowWidth = 10.0;

    if (isFirst) {
      path.moveTo(0, 0);
      path.lineTo(size.width - arrowWidth, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - arrowWidth, size.height);
      path.lineTo(0, size.height);
    } else if (isLast) {
      path.moveTo(0, 0);
      path.lineTo(arrowWidth, size.height / 2);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(0, 0);
      path.lineTo(arrowWidth, size.height / 2);
      path.lineTo(0, size.height);
      path.lineTo(size.width - arrowWidth, size.height);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - arrowWidth, 0);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(ChevronClipper oldClipper) => oldClipper.isFirst != isFirst || oldClipper.isLast != isLast;
}
