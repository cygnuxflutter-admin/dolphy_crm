import 'dart:convert';

import 'package:crm/config/app_colors.dart';
import 'package:crm/config/app_routes.dart';
import 'package:crm/module/lead_screen/lead_controller.dart';
import 'package:crm/module/lead_screen/sub_screen/add_activity_screen.dart';
import 'package:crm/module/lead_screen/sub_screen/add_lead_screen.dart';
import 'package:crm/widget/button_view.dart';
import 'package:crm/widget/dropdown.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/app_images.dart';
import '../../widget/textfield.dart';
import 'model/get_assign_partner.dart';
import 'model/opportunity_summary_model.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {
  LeadController leadController = Get.find<LeadController>();

  final ScrollController scrollController = ScrollController();
  final ScrollController summaryScrollController = ScrollController();

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (leadController.leadList.length < leadController.totalCount.value) {
        leadController.pageCount.value++;
        leadController.getLeadListApi(page: leadController.pageCount.value, search: leadController.searchController.value.text, isLoading: false);
      }
    }
  }

  void _summaryScrollListener() {
    if (summaryScrollController.position.pixels == summaryScrollController.position.maxScrollExtent) {
      if (leadController.opportunitySummaryList.length < leadController.summaryTotalCount.value) {
        leadController.summaryPageCount.value++;
        leadController.getOpportunitySummaryApi(
          page: leadController.summaryPageCount.value,
          search: leadController.searchController.value.text,
          isLoading: false,
        );
      }
    }
  }

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    summaryScrollController.addListener(_summaryScrollListener);
    leadController.getLeadListApi(page: leadController.pageCount.value, search: leadController.searchController.value.text);
    leadController.getOpportunitySummaryApi(page: leadController.summaryPageCount.value, search: leadController.searchController.value.text);

    leadController.activitySearchController.value.addListener(() {
      if (leadController.ignoreSearchSuggestions) {
        leadController.ignoreSearchSuggestions = false;
        return;
      }
      final query = leadController.activitySearchController.value.text;
      if (query.isNotEmpty) {
        leadController.getSearchSuggestions(query);
      } else {
        leadController.searchSuggestions.clear();
        if (leadController.selectedFilterGroups.value.isNotEmpty) {
          leadController.selectedFilterGroups.value = "";
          leadController.summaryPageCount.value = 1;
          leadController.getOpportunitySummaryApi(page: 1);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Lead",
            style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.white),
          ),
          backgroundColor: AppColors.indigo600Main,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.white),
              onPressed: () {
                Get.toNamed(AppRoutes.AddLeadScreen);
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.white,
            labelColor: AppColors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Leads"),
              Tab(text: "Activity"),
            ],
          ),
        ),
        body: SafeArea(child: TabBarView(children: [_buildLeadList(), _buildActivityList()])),
      ),
    );
  }

  Widget _buildLeadList() {
    return Obx(() {
      if (leadController.isOpportunityDataLoading.isTrue) {
        return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
      } else if (leadController.isOpportunityDataLoading.isFalse && leadController.leadList.isEmpty) {
        return Center(child: Image.asset(AppImages.noDataFound, scale: 3));
      } else {
        final allDataLoaded = leadController.leadList.length >= leadController.totalCount.value;

        return ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: leadController.leadList.length + (allDataLoaded ? 0 : 1),
          separatorBuilder: (_, _) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            if (!allDataLoaded && index == leadController.leadList.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final item = leadController.leadList[index];
            String createdAt = "-";
            if (item.createdAt!.isNotEmpty) {
              createdAt = DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(item.createdAt!));
            }
            return _OpportunityCard(
              createdAt: createdAt,
              opportunityName: item.opportunityName,
              customerName: item.customerName,
              email: item.email!,
              mobile: item.mobile1!,
              sourceName: item.sourceName!,
              salesPerson: item.salesPersonName,
              leadController: leadController,
              id: item.id!,
            );
          },
        );
      }
    });
  }

  Widget _buildActivityList() {
    return Column(
      children: [
        _buildActivitySearchField(),
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  Obx(() => _buildSummaryHeader()),
                  _buildActivityFilters(),
                  Expanded(
                    child: Obx(() {
                      if (leadController.isSummaryLoading.isTrue && leadController.opportunitySummaryList.isEmpty) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
                      } else if (leadController.isSummaryLoading.isFalse && leadController.opportunitySummaryList.isEmpty) {
                        return Center(child: Image.asset(AppImages.noDataFound, scale: 3));
                      } else {
                        final allDataLoaded = leadController.opportunitySummaryList.length >= leadController.summaryTotalCount.value;

                        return ListView.separated(
                          controller: summaryScrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: leadController.opportunitySummaryList.length + (allDataLoaded ? 0 : 1),
                          separatorBuilder: (_, _) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            if (!allDataLoaded && index == leadController.opportunitySummaryList.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }

                            final item = leadController.opportunitySummaryList[index];
                            return _ActivitySummaryCard(item: item, leadController: leadController);
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
              Obx(() => _buildSuggestionsOverlay()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivitySearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Obx(() {
        final selected = leadController.selectedSearchSuggestion.value;
        final categoryLabel = leadController.selectedSearchCategory.value;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray300.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.search, color: AppColors.textSecondary, size: 20),
              ),
              Expanded(
                child: selected != null
                    ? Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.gray100,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.gray300),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5A4352), // Dark purple-ish color from image
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    categoryLabel.toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    selected.value,
                                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    leadController.selectedSearchSuggestion.value = null;
                                    leadController.selectedSearchCategory.value = "";
                                    leadController.selectedFilterGroups.value = "";
                                    leadController.activitySearchController.value.clear();
                                    leadController.summaryPageCount.value = 1;
                                    leadController.getOpportunitySummaryApi(page: 1);
                                  },
                                  child: const Icon(Icons.close, size: 16, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(child: SizedBox.shrink()),
                        ],
                      )
                    : TextField(
                        controller: leadController.activitySearchController.value,
                        decoration: const InputDecoration(
                          hintText: "Search activities...",
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
              ),
              if (selected == null && leadController.activitySearchController.value.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, size: 18, color: AppColors.textSecondary),
                  onPressed: () {
                    leadController.activitySearchController.value.clear();
                    leadController.searchSuggestions.clear();
                  },
                ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 20),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSuggestionsOverlay() {
    if (leadController.searchSuggestions.isEmpty && !leadController.isSearchSuggestionsLoading.value) {
      return const SizedBox.shrink();
    }

    return Container(
      color: AppColors.background.withOpacity(0.95),
      child: leadController.isSearchSuggestionsLoading.value
          ? const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: leadController.searchSuggestions.length,
              itemBuilder: (context, index) {
                final category = leadController.searchSuggestions[index];
                return Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(
                      category.label,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                    ),
                    children: category.items.map((item) {
                      return ListTile(
                        title: Text(item.displayValue ?? item.value),
                        onTap: () {
                          // Construct filterGroups
                          final filterGroups = [
                            {
                              "logic": "AND",
                              "conditions": [
                                {"field": item.filterField, "operator": item.filterOperator, "value": item.value},
                              ],
                            },
                          ];
                          leadController.selectedSearchSuggestion.value = item;
                          leadController.selectedSearchCategory.value = category.label;
                          leadController.selectedFilterGroups.value = jsonEncode(filterGroups);
                          leadController.summaryPageCount.value = 1;
                          leadController.getOpportunitySummaryApi(page: 1);

                          // Set ignore flag before updating text to prevent re-opening suggestions
                          leadController.ignoreSearchSuggestions = true;
                          leadController.activitySearchController.value.text = item.value;
                          leadController.searchSuggestions.clear();

                          FocusScope.of(context).unfocus();
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSummaryHeader() {
    final summary = leadController.activitySummary.value;
    final bool isRefreshing = leadController.isSummaryLoading.value && summary == null;

    int totalActivities = 0;
    int completedActivities = 0;
    int pendingActivities = 0;
    String opportunitiesCount = "0";

    if (summary != null) {
      final String filter = leadController.selectedActivityFilter.value;
      if (filter == "call") {
        totalActivities = summary.call?.total ?? 0;
        completedActivities = summary.call?.done ?? 0;
        pendingActivities = summary.call?.pending ?? 0;
      } else if (filter == "meeting") {
        totalActivities = summary.meeting?.total ?? 0;
        completedActivities = summary.meeting?.done ?? 0;
        pendingActivities = summary.meeting?.pending ?? 0;
      } else {
        totalActivities = (summary.call?.total ?? 0) + (summary.meeting?.total ?? 0);
        completedActivities = (summary.call?.done ?? 0) + (summary.meeting?.done ?? 0);
        pendingActivities = (summary.call?.pending ?? 0) + (summary.meeting?.pending ?? 0);
      }
      opportunitiesCount = leadController.summaryTotalCount.value.toString();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _summaryHeaderItem("TOTAL ACTIVITIES", isRefreshing ? "..." : totalActivities.toString(), Icons.assignment_outlined, Colors.blue),
            const SizedBox(width: 12),
            _summaryHeaderItem("COMPLETED", isRefreshing ? "..." : completedActivities.toString(), Icons.check_circle_outline, Colors.green),
            const SizedBox(width: 12),
            _summaryHeaderItem("PENDING", isRefreshing ? "..." : pendingActivities.toString(), Icons.access_time, Colors.orange),
            const SizedBox(width: 12),
            _summaryHeaderItem("OPPORTUNITIES", isRefreshing ? "..." : opportunitiesCount, Icons.people_outline, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          _filterChip("All", ""),
          const SizedBox(width: 8),
          _filterChip("Calls", "call"),
          const SizedBox(width: 8),
          _filterChip("Meetings", "meeting"),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    return Obx(() {
      bool isSelected = leadController.selectedActivityFilter.value == value;
      return GestureDetector(
        onTap: () {
          leadController.selectedActivityFilter.value = value;
          leadController.summaryPageCount.value = 1;
          leadController.getOpportunitySummaryApi(page: 1, search: leadController.searchController.value.text);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.indigo600Main : AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? AppColors.indigo600Main : AppColors.gray300),
            boxShadow: isSelected ? [BoxShadow(color: AppColors.indigo600Main.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))] : null,
          ),
          child: Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? AppColors.white : AppColors.textSecondary),
          ),
        ),
      );
    });
  }

  Widget _summaryHeaderItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                title,
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivitySummaryCard extends StatelessWidget {
  final OpportunitySummaryItem item;
  final LeadController leadController;

  const _ActivitySummaryCard({required this.item, required this.leadController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.companyName,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "₹${item.amount}",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(item.customerName, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const Divider(height: 20),
          _buildActivitySection("Calls", item.activities["Call"] ?? []),
          const SizedBox(height: 8),
          _buildActivitySection("Meetings", item.activities["Meeting"] ?? []),
        ],
      ),
    );
  }

  Widget _buildActivitySection(String title, List<ActivityItem> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(title == "Calls" ? Icons.call : Icons.meeting_room, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(10)),
              child: Text(activities.length.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (activities.isEmpty)
          const Text("-", style: TextStyle(color: AppColors.textSecondary, fontSize: 12))
        else
          Wrap(spacing: 8, runSpacing: 8, children: activities.map((activity) => _buildActivityTag(activity, title == "Meetings")).toList()),
      ],
    );
  }

  Widget _buildActivityTag(ActivityItem activity, bool isMeeting) {
    Color color = Colors.grey;
    if (activity.date.isNotEmpty) {
      DateTime? activityDate = DateTime.tryParse(activity.date);

      if (activityDate == null) {
        // Try common formats if standard ISO parsing fails
        final formats = ['yyyy-MM-dd hh:mm a', 'dd-MM-yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd', 'dd MMM yyyy', 'd MMM yyyy', 'd, MMMM, yyyy'];
        for (var format in formats) {
          try {
            activityDate = DateFormat(format).parse(activity.date);
            break;
          } catch (_) {}
        }
      }

      if (activityDate != null) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final activityDay = DateTime(activityDate.year, activityDate.month, activityDate.day);

        if (activityDay.isAfter(today)) {
          color = Colors.green;
        } else if (activityDay.isBefore(today)) {
          color = Colors.red;
        } else {
          color = const Color(0xFFEAB308); // Today (Amber/Yellow)
        }
      }
    }
    return GestureDetector(
      onTap: () async {
        await leadController.getActivityDetailApi(id: activity.id);
        if (leadController.activityDetailData.value != null) {
          showDialog(
            context: Get.context!,
            builder: (context) => _ActivityDetailDialog(leadController: leadController, isMeeting: isMeeting),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              activity.date.isNotEmpty ? activity.date : "No Date",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityDetailDialog extends StatelessWidget {
  final LeadController leadController;
  final bool isMeeting;

  const _ActivityDetailDialog({required this.leadController, required this.isMeeting});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          if (leadController.isActivityDetailLoading.value) {
            return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
          }
          final data = leadController.activityDetailData.value;
          if (data == null) return const Text("No data found");

          String followUpDate = "-";
          if (data.followUpDate.isNotEmpty) {
            try {
              followUpDate = DateFormat("dd/MM").format(DateTime.parse(data.followUpDate));
            } catch (e) {
              followUpDate = data.followUpDate;
            }
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${isMeeting ? 'Meetings' : 'Calls'} Details", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: const Icon(Icons.cancel_outlined, color: AppColors.textSecondary),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  borderRadius: BorderRadius.circular(12),
                  border: const Border(left: BorderSide(color: AppColors.indigo600Main, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.auto_awesome_mosaic_outlined, size: 16, color: AppColors.indigo600Main),
                        SizedBox(width: 8),
                        Text(
                          "SUBJECT",
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(data.subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "STATUS",
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.indigo50, borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            data.invitationStatus,
                            style: const TextStyle(color: AppColors.indigo600Main, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "FOLLOW-UP",
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(followUpDate, style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "DESCRIPTION",
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(data.description.isEmpty ? "-" : data.description, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: commonButton(
                      name: "Done",
                      onTap: () => Get.back(),
                      bgColor: const Color(0xFF64748B),
                      textColor: AppColors.white,
                      icon: Icons.check_circle_outline,
                      iconColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: commonButton(
                      name: "Schedule Activity",
                      onTap: () {
                        Get.back();
                        Get.to(() => AddActivityScreen(isMeeting: isMeeting, isView: true, isAdd: false, id: data.opportunityId));
                      },
                      bgColor: AppColors.indigo600Main,
                      textColor: AppColors.white,
                      icon: Icons.bolt,
                      iconColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final String createdAt;
  final String opportunityName;
  final String customerName;
  final String email;
  final String mobile;
  final String sourceName;
  final String salesPerson;
  final String id;
  final LeadController leadController;

  _OpportunityCard({
    required this.createdAt,
    required this.opportunityName,
    required this.customerName,
    required this.email,
    required this.mobile,
    required this.sourceName,
    required this.salesPerson,
    required this.id,
    required this.leadController,
  });

  final GlobalKey<FormState> assignPersonKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addLogsKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  opportunityName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20, color: AppColors.textSecondary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: AppColors.white,
                // onSelected: (value)  {
                //   if (value == 'view') {
                //     Get.toNamed(AppRoutes.LeadDetailScreen);
                //   } else if (value == 'edit') {
                //      leadController.getOpportunityFiend(id: id);
                //     Get.to(() => AddLeadScreen(isEdit: true));
                //   } else if (value == 'delete') {}
                // },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: const [
                        Icon(Icons.visibility, size: 20),
                        SizedBox(width: 12),
                        Text("View", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    onTap: () {
                      leadController.getOpportunityView(id: id);
                      Get.toNamed(AppRoutes.LeadDetailScreen);
                    },
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: const [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 12),
                        Text("Edit", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    onTap: () {
                      Get.to(() => AddLeadScreen(isEdit: true, id: id));
                    },
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: const [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text("Delete", style: TextStyle(fontSize: 14, color: Colors.red)),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.delete_outline, size: 40, color: AppColors.red600Error),
                                const SizedBox(height: 20),
                                const Text(
                                  "Are you sure you want to delete opportunity?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    Expanded(
                                      child: commonButton(
                                        name: "Delete",
                                        onTap: () {
                                          leadController.deleteLeadApi(id: id);
                                        },
                                        bgColor: AppColors.red600Error,
                                        textColor: AppColors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: commonButton(
                                        name: "Cancel",
                                        onTap: () => Get.back(),
                                        bgColor: AppColors.gray200,
                                        textColor: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  PopupMenuItem(
                    value: 'Add Log',
                    child: Row(
                      children: const [
                        Icon(Icons.calendar_today_outlined, size: 20),
                        SizedBox(width: 12),
                        Text("Add Log", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Add Log',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 12),
                                  commonTextField(
                                    controller: leadController.opportunityLogDateController.value,
                                    readOnly: true,
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(const Duration(days: 365)),
                                      );
                                      if (picked != null) {
                                        leadController.opportunityLogDateController.value.text = DateFormat('d MMM yyyy').format(picked);
                                      }
                                    },
                                    labelText: 'Reminder Date',
                                    hintText: "Select Date (optional)",
                                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                                  ),
                                  Form(
                                    key: addLogsKey,
                                    child: commonTextField(
                                      needValidation: true,
                                      labelText: "Type your log",
                                      hintText: "Type your log here...",
                                      controller: leadController.opportunityLogDetailsController.value,
                                      validationMessage: "Type your log here...",
                                    ),
                                  ),
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
                                          SizedBox(height: 6),
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
                                                  child: SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: Image.network(leadController.uploadedImageLink[index]),
                                                  ),
                                                );
                                              },
                                              itemCount: leadController.uploadedImageLink.length,
                                            ),
                                          )
                                        : SizedBox();
                                  }),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 50,
                                        child: commonButton(
                                          name: 'Cancel',
                                          borderColor: AppColors.indigo600Main,
                                          iconColor: AppColors.indigo600Main,
                                          textColor: AppColors.indigo600Main,
                                          onTap: () {
                                            Get.back();
                                            leadController.opportunityLogDateController.value.clear();
                                            leadController.opportunityLogDetailsController.value.clear();
                                            leadController.uploadedImageLink.clear();
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      SizedBox(
                                        width: 100,
                                        height: 50,
                                        child: Obx(() {
                                          return commonButton(
                                            isLoader: leadController.isAddLogLoading.value,
                                            name: 'Save Log',
                                            bgColor: AppColors.indigo600Main,
                                            loaderColorWhite: true,
                                            onTap: () {
                                              if (addLogsKey.currentState!.validate()) {
                                                leadController.addLog(id: id, isAddList: true);
                                              }
                                            },
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  PopupMenuItem(
                    value: 'Add Meeting',
                    child: Row(
                      children: const [
                        Icon(Icons.meeting_room_outlined, size: 20),
                        SizedBox(width: 12),
                        Text("Add Meeting", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    onTap: () {
                      Get.to(() => AddActivityScreen(isMeeting: true, isView: true, isAdd: false, id: id));
                    },
                  ),
                  PopupMenuItem(
                    value: 'Add Call',
                    child: Row(
                      children: const [
                        Icon(Icons.add_call, size: 20),
                        SizedBox(width: 12),
                        Text("Add Call", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    onTap: () {
                      Get.to(() => AddActivityScreen(isMeeting: false, isView: true, isAdd: false, id: id));
                    },
                  ),
                  PopupMenuItem(
                    value: 'Add Assign',
                    child: Row(
                      children: const [
                        Icon(Icons.person_outline, size: 20),
                        SizedBox(width: 12),
                        Text("Add Assign", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: SizedBox(
                            width: 420,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          "Assign User",
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Divider(height: 1),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Obx(
                                    () => Form(
                                      key: assignPersonKey,
                                      child: CustomDropdown<AssignSalesPerson>(
                                        hintText: 'Assign Sales person',
                                        items: (filter, LoadProps? loadProps) {
                                          return leadController.assignSalesPersonList;
                                        },
                                        itemAsString: (item) => "${item.firstName} ${item.lastName}",
                                        selectedItem: leadController.selectedAssignSalesPerson.value,
                                        compareFn: (a, b) => a?.id == b?.id,
                                        onChanged: (value) {
                                          leadController.selectedAssignSalesPerson.value = value;
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please select assign person';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                const Divider(height: 1),

                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        height: 50,
                                        child: commonButton(
                                          name: 'Cancel',
                                          borderColor: AppColors.indigo600Main,
                                          iconColor: AppColors.indigo600Main,
                                          textColor: AppColors.indigo600Main,
                                          onTap: () {
                                            leadController.selectedAssignSalesPerson.value = null;
                                            Get.back();
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      SizedBox(
                                        width: 100,
                                        height: 50,
                                        child: commonButton(
                                          name: "Save",
                                          bgColor: AppColors.indigo600Main,
                                          isLoader: leadController.isAddAssignLoading.value,
                                          loaderColorWhite: true,
                                          onTap: () {
                                            if (assignPersonKey.currentState!.validate()) {
                                              leadController.addAssign(id: id);
                                            }
                                          },
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
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// CREATED DATE
          Text(createdAt, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),

          const Divider(height: 22, color: AppColors.border),

          /// CUSTOMER
          _infoRow(icon: Icons.business, label: "Customer", value: customerName),

          const SizedBox(height: 8),

          /// EMAIL
          _infoRow(icon: Icons.email_outlined, label: "Email", value: email),

          const SizedBox(height: 8),

          /// MOBILE
          _infoRow(icon: Icons.call_outlined, label: "Mobile", value: mobile),

          const Divider(height: 22, color: AppColors.border),

          /// SOURCE & SALES PERSON
          Row(
            children: [
              Expanded(
                child: _chipInfo(icon: Icons.source_outlined, text: sourceName),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _chipInfo(icon: Icons.person_outline, text: salesPerson),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _infoRow({required IconData icon, required String label, required String value}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 16, color: AppColors.textSecondary),
      const SizedBox(width: 8),
      SizedBox(
        width: 80,
        child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
      ),
      Expanded(
        child: Text(
          value.isEmpty ? "-" : value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
      ),
    ],
  );
}

Widget _chipInfo({required IconData icon, required String text}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: AppColors.gray100, borderRadius: BorderRadius.circular(12)),
    child: Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text.isEmpty ? "-" : text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
