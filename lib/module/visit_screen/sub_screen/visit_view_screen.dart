import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/app_colors.dart';
import '../model/visit_view_model.dart';
import '../visit_controller.dart';

class VisitViewScreen extends GetView<VisitController> {
  const VisitViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String visitId = Get.arguments ?? "";
    if (visitId.isNotEmpty) {
      controller.getVisitDetail(visitId);
    }

    return Obx(() {
      final data = controller.visitDetail.value;
      final bool isCancelled = (data?.status ?? "").toUpperCase() == "CANCELLED";
      final int tabCount = isCancelled ? 3 : 4;

      if (controller.isDetailLoading.value) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              "View Visit",
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.detailError.isNotEmpty) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
          ),
          body: Center(child: Text(controller.detailError.value)),
        );
      }

      if (data == null) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
          ),
          body: const Center(child: Text("No Data Found")),
        );
      }

      return DefaultTabController(
        key: ValueKey("visit_tabs_${data.id}_$tabCount"),
        length: tabCount,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.white,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
              onPressed: () => Get.back(),
            ),
            titleSpacing: 0,
            toolbarHeight: 130,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.blueColor, borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: AppColors.blueColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                child: const Icon(Icons.info_outline, color: AppColors.blueColor, size: 16),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "View Visit",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Text(data.visitNo, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statusBadge(data),
                      Expanded(
                        child: Align(alignment: Alignment.centerRight, child: _buildHeaderButtons(data)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(bottom: BorderSide(color: AppColors.gray200, width: 1)),
                ),
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                  labelColor: AppColors.indigo600Main,
                  unselectedLabelColor: AppColors.gray500,
                  indicatorColor: AppColors.indigo600Main,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.grid_view_rounded, size: 18),
                          const SizedBox(width: 8),
                          const Text("Overview"),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.indigo100, borderRadius: BorderRadius.circular(10)),
                            child: Text("${data.products.length}", style: const TextStyle(fontSize: 10, color: AppColors.indigo600Main)),
                          ),
                        ],
                      ),
                    ),
                    const Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.person_pin_circle_outlined, size: 18), SizedBox(width: 8), Text("Field Tracking")],
                      ),
                    ),
                    const Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.assignment_outlined, size: 18),
                          SizedBox(width: 8),
                          Text("Field Report"),
                          SizedBox(width: 4),
                          Icon(Icons.check_circle, size: 14, color: AppColors.green500Success),
                        ],
                      ),
                    ),
                    if (!isCancelled)
                      const Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.receipt_long_outlined, size: 18), SizedBox(width: 8), Text("Visit Expense")],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              _buildOverviewTab(data),
              _buildFieldTrackingTab(data),
              _buildFieldReportTab(data),
              if (!isCancelled) const Center(child: Text("Visit Expense Content")),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFieldReportTab(VisitViewData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildEndTrackingCard(data),
          const SizedBox(height: 16),
          if (data.products == null || data.products!.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text("No field reports found", style: TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else
            ...data.products!.map((product) => _buildFieldReportCard(product)).toList(),
        ],
      ),
    );
  }

  Widget _buildEndTrackingCard(VisitViewData data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.cancel_outlined, size: 20, color: AppColors.red500),
                SizedBox(width: 10),
                Text(
                  "End Tracking",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.red500),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.gray200),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _reportInfoItem("VISIT OUTCOME", (data.visitOutcome == null || data.visitOutcome!.isEmpty) ? "-" : data.visitOutcome!),
                    ),
                    Expanded(
                      child: _reportInfoItem(
                        "SERVICE RECEIVED BY",
                        (data.siteReceiverName == null || data.siteReceiverName!.isEmpty) ? "-" : data.siteReceiverName!,
                      ),
                    ),
                    Expanded(
                      child: _reportInfoItem(
                        "RECEIVER CONTACT",
                        "${data.siteReceiverMobileCountryCode ?? ''} ${data.siteReceiverMobile ?? ''}".trim().isEmpty
                            ? "-"
                            : "${data.siteReceiverMobileCountryCode ?? ''} ${data.siteReceiverMobile ?? ''}",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _reportInfoItem("ENDED AT", _formatDateTime(data.visitTechnicians.first.stoppedAt))),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "END LOCATION",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gray400),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${data.visitTechnicians.first.stopLatitude ?? ''}, ${data.visitTechnicians.first.stopLongitude ?? ''}".trim().isEmpty
                                ? "-"
                                : "${data.visitTechnicians.first.stopLatitude}, ${data.visitTechnicians.first.stopLongitude}",
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          if (data.visitTechnicians.first.stopLatitude != null &&
                              data.visitTechnicians.first.stopLongitude != null &&
                              data.visitTechnicians.first.stopLatitude!.isNotEmpty &&
                              data.visitTechnicians.first.stopLongitude!.isNotEmpty)
                            InkWell(
                              onTap: () => _openMap(data.visitTechnicians.first.stopLatitude, data.visitTechnicians.first.stopLongitude),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on_outlined, size: 12, color: AppColors.indigo600Main),
                                  Text(
                                    " View on map",
                                    style: TextStyle(fontSize: 11, color: AppColors.indigo600Main, decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 20),
                _reportInfoItem("OVERALL REMARK", (data.overallRemark == null || data.overallRemark!.isEmpty) ? "-" : data.overallRemark!),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ATTACHMENTS",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gray400),
                    ),
                    const SizedBox(height: 8),
                    if (data.attachments != null && data.attachments!.isNotEmpty)
                      OutlinedButton.icon(
                        onPressed: () {
                          if (data.attachments!.length == 1) {
                            _openFile(data.attachments!.first);
                          } else {
                            _showAttachmentsDialog(data.attachments!);
                          }
                        },
                        icon: const Icon(Icons.open_in_new, size: 14),
                        label: const Text("View File", style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.indigo600Main,
                          side: const BorderSide(color: AppColors.indigo600Main, width: 0.5),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      )
                    else
                      const Text(
                        "-",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldReportCard(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.gray100, width: 1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.build_outlined, size: 16, color: AppColors.orangeColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "[${product.productCode ?? '-'}] ${product.productName ?? '-'}",
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.orangeColor),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _reportInfoItem("COMPLAINT QTY", "${product.complaintQty ?? 0}")),
                    Expanded(child: _reportInfoItem("SOLVE QTY", "${product.solveQty ?? 0}")),
                    Expanded(child: _reportInfoItem("INSTALLED QTY", "${product.installedQty ?? 0}")),
                  ],
                ),
                const SizedBox(height: 20),
                _reportInfoItem(
                  "WARRANTY",
                  (product.warrantyTypeName == null || product.warrantyTypeName!.isEmpty) ? "-" : product.warrantyTypeName!,
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _reportInfoItem("WORK REMARK", (product.workRemark == null || product.workRemark!.isEmpty) ? "-" : product.workRemark!),
                    ),
                    Expanded(
                      child: _reportInfoItem(
                        "ATTACHMENTS",
                        (product.attachments == null || product.attachments!.isEmpty) ? "-" : "${product.attachments!.length} files",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _reportInfoItem(
                  "SERIAL NUMBERS",
                  (product.serialNumbers == null || product.serialNumbers!.isEmpty) ? "-" : product.serialNumbers!.join(", "),
                ),
                const SizedBox(height: 20),
                _reportInfoItem(
                  "PARTS REQUIRED",
                  (product.partRequests == null || product.partRequests!.isEmpty) ? "No parts requested" : "${product.partRequests!.length} parts",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reportInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.gray400),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildFieldTrackingTab(VisitViewData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.gray200, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.person_pin_circle_outlined, size: 20, color: AppColors.red500),
                  SizedBox(width: 10),
                  Text(
                    "Field Tracking",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.red500),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.gray200),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // Table Header
                  Container(
                    color: AppColors.gray50,
                    height: 40,
                    child: Row(
                      children: [
                        _tableHeaderItem("#", 40),
                        _tableHeaderItem("Technician", 180),
                        _tableHeaderItem("Status", 120),
                        _tableHeaderItem("Start Time", 180),
                        _tableHeaderItem("Start Location (Lat, Long)", 200),
                        _tableHeaderItem("Elapsed Time", 120),
                        _tableHeaderItem("Stop Remark", 150),
                      ],
                    ),
                  ),
                  // Table Rows
                  ...List.generate(data.visitTechnicians?.length ?? 0, (index) {
                    final tech = data.visitTechnicians![index];
                    return Obx(() {
                      final bool isExpanded = controller.expandedTechLogs[tech.id ?? ""] ?? false;
                      return Column(
                        children: [
                          Container(
                            height: 80,
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.gray100, width: 1)),
                            ),
                            child: Row(
                              children: [
                                _tableCellItem(Text("${index + 1}", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)), 40),
                                _tableCellItem(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        tech.name ?? "-",
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          if (tech.isPrimary == true) ...[
                                            _techBadge("Primary", AppColors.indigo600Main.withOpacity(0.1), AppColors.indigo600Main),
                                            const SizedBox(width: 4),
                                          ],
                                          if (tech.isCurrentUser == true) ...[
                                            _techBadge("You", AppColors.blueColor.withOpacity(0.1), AppColors.blueColor),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                  180,
                                ),
                                _tableCellItem(_techStatusBadge(tech.fieldStatus ?? "-"), 120),
                                _tableCellItem(
                                  Text(_formatDateTime(tech.startedAt), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  180,
                                ),
                                _tableCellItem(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${tech.startLatitude ?? ''}, ${tech.startLongitude ?? ''}".trim().isEmpty
                                            ? "-"
                                            : "${tech.startLatitude}, ${tech.startLongitude}",
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      ),
                                      InkWell(
                                        onTap: () => _openMap(tech.startLatitude, tech.startLongitude),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.location_on_outlined, size: 12, color: AppColors.indigo600Main),
                                            Text(
                                              " View on map",
                                              style: TextStyle(fontSize: 11, color: AppColors.indigo600Main, decoration: TextDecoration.underline),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  200,
                                ),
                                _tableCellItem(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _formatDuration(tech.activeDurationSeconds ?? 0),
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.green500Success),
                                      ),
                                      InkWell(
                                        onTap: () => controller.toggleTechLogExpansion(tech.id ?? ""),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                              size: 12,
                                              color: AppColors.indigo600Main,
                                            ),
                                            Text(
                                              isExpanded ? " Hide Log" : " View Log",
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.indigo600Main,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  120,
                                ),
                                _tableCellItem(Text(tech.remark ?? "-", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)), 150),
                              ],
                            ),
                          ),
                          if (isExpanded) _buildTrackingHistory(tech),
                        ],
                      );
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeaderItem(String label, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _tableCellItem(Widget child, double width) {
    return Container(width: width, padding: const EdgeInsets.symmetric(horizontal: 12), alignment: Alignment.centerLeft, child: child);
  }

  Widget _buildTrackingHistory(VisitTechnician tech) {
    return Container(
      width: 990, // Sum of header widths
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: AppColors.gray50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.history, size: 16, color: AppColors.indigo600Main),
              SizedBox(width: 8),
              Text(
                "TRACKING HISTORY",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.indigo600Main, letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (tech.trackingLogs == null || tech.trackingLogs!.isEmpty)
            const Text("No tracking history found", style: TextStyle(fontSize: 12, color: AppColors.textSecondary))
          else
            ...tech.trackingLogs!.map((log) => _buildTrackingLogEntry(log)).toList(),
        ],
      ),
    );
  }

  Widget _buildTrackingLogEntry(TrackingLog log) {
    Color statusColor = AppColors.gray500;
    String actionStr = (log.action ?? "").toUpperCase();

    if (actionStr == "START" || actionStr == "RESUME") {
      statusColor = AppColors.green500Success;
    } else if (actionStr == "PAUSE" || actionStr == "STOP") {
      statusColor = AppColors.orangeColor;
    } else if (actionStr == "END" || actionStr == "COMPLETED") {
      statusColor = AppColors.red500;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border(left: BorderSide(color: statusColor, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDateTime(log.createdAt),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  actionStr,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _openMap(log.latitude, log.longitude),
                  child: const Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12, color: AppColors.indigo600Main),
                      Text(" Map", style: TextStyle(fontSize: 11, color: AppColors.indigo600Main)),
                    ],
                  ),
                ),
              ],
            ),
            if (log.remark != null && log.remark!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.yellow100.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.yellow100, width: 0.5),
                ),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                    children: [
                      const TextSpan(
                        text: "Stop Remark: ",
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.orangeColor),
                      ),
                      TextSpan(text: log.remark),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return "-";
    // Convert to GMT+5:30 (IST)
    final ist = dt.toUtc().add(const Duration(hours: 5, minutes: 30));
    return DateFormat('dd/MM/yyyy hh:mm a').format(ist);
  }

  Widget _buildHeaderButtons(VisitViewData? data) {
    final bool isCancelled = (data?.status ?? "").toUpperCase() == "CANCELLED";
    final bool isCompleted = (data?.status ?? "").toUpperCase() == "COMPLETED";

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _headerButton(onTap: () {}, icon: Icons.sync, label: "Sync (1)", color: AppColors.indigo600Main),
          const SizedBox(width: 4),
          if (!isCancelled && isCompleted) _headerButton(onTap: () {}, icon: Icons.add, label: "Add Expense", color: AppColors.indigo600Main),
          if (!isCancelled && isCompleted) const SizedBox(width: 4),
          _headerButton(onTap: () => Get.back(), label: "Back", color: AppColors.red500, isOutline: false, bgColor: AppColors.red100),
        ],
      ),
    );
  }

  Widget _headerButton({
    required VoidCallback onTap,
    IconData? icon,
    required String label,
    required Color color,
    bool isOutline = true,
    Color? bgColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: isOutline ? AppColors.white : (bgColor ?? color),
          borderRadius: BorderRadius.circular(4),
          border: isOutline ? Border.all(color: color, width: 0.5) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 12, color: color), const SizedBox(width: 2)],
            Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(VisitViewData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard(
            title: "Visit Details",
            icon: Icons.calendar_today_outlined,
            children: [
              _gridInfoItem("VISIT NO.", (data.visitNo == null || data.visitNo!.isEmpty) ? "-" : data.visitNo!),
              _gridInfoItem("COMPLAINT NO.", (data.complaintNo == null || data.complaintNo!.isEmpty) ? "-" : data.complaintNo!),
              _gridInfoItem("VISIT START DATE & TIME", _formatDateTime(data.visitStartDatetime)),
              _gridInfoItem("VISIT END DATE & TIME", _formatDateTime(data.visitEndDatetime)),
              _gridInfoItem("VISIT PURPOSE", (data.visitPurposeName == null || data.visitPurposeName!.isEmpty) ? "-" : data.visitPurposeName!),
              _gridInfoItem(
                "PRIMARY TECHNICIAN",
                (data.primaryTechnicianName == null || data.primaryTechnicianName!.isEmpty) ? "-" : data.primaryTechnicianName!,
              ),
              _gridInfoItem("TECHNICIAN", (data.technicianNames == null || data.technicianNames!.isEmpty) ? "-" : data.technicianNames!),
              _gridInfoItem("ASSIGNED TO", (data.assignedToName == null || data.assignedToName!.isEmpty) ? "-" : data.assignedToName!),
              _gridInfoItem("CREATED BY", (data.createdByName == null || data.createdByName!.isEmpty) ? "-" : data.createdByName!),
              _gridInfoItem("CREATED AT", _formatDateTime(data.createdAt)),
              _gridInfoItem("TOTAL EXPENSE", (data.totalExpense == null || data.totalExpense!.isEmpty) ? "0.00" : data.totalExpense!),
              _gridInfoItem("REMAINING ADVANCE", (data.advanceBalance == null || data.advanceBalance!.isEmpty) ? "0.00" : data.advanceBalance!),
              _gridInfoItem(
                "APPROVED EXPENSES",
                "0.00",
                valueColor: AppColors.green500Success,
                extra: _statusBadgeSmall("0 approved", AppColors.green500Success),
              ),
            ],
            footer: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.receipt_long_outlined, size: 16),
              label: const Text("View Visit Expense"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.indigo600Main,
                side: const BorderSide(color: AppColors.indigo600Main, width: 0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            title: "Contact & Location",
            icon: Icons.person_outline,
            children: [
              _gridInfoItem("CONTACT PERSON", (data.contactPerson == null || data.contactPerson!.isEmpty) ? "-" : data.contactPerson!),
              _gridInfoItem(
                "MOBILE",
                "${data.mobileCountryCode ?? ''} ${data.mobile ?? ''}".trim().isEmpty ? "-" : "${data.mobileCountryCode ?? ''} ${data.mobile ?? ''}",
              ),
              _gridInfoItem("ADDRESS", (data.address == null || data.address!.isEmpty) ? "-" : data.address!),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailCard(title: "Remarks", icon: Icons.notes_outlined, children: [_gridInfoItem("No remarks", "", isFullWidth: true)]),
          const SizedBox(height: 16),
          _buildProductComplaintDetails(data),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProductComplaintDetails(VisitViewData data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 20, color: AppColors.orangeColor),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Product Complaint Details",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.orangeColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _headerButton(onTap: () {}, icon: Icons.sync, label: "Sync to Complaint (1)", color: AppColors.indigo600Main),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.gray200),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(AppColors.gray50),
              headingRowHeight: 40,
              dataRowHeight: 60,
              columnSpacing: 24,
              columns: const [
                DataColumn(
                  label: Text(
                    "#",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Product",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Source",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Tax Invoice No",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Warranty Type",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Repeat Service Status",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Complaint Qty",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Solved Qty",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Installed Qty",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Usage / Crowd Note",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Issue Description",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ),
              ],
              rows: List.generate(data.products?.length ?? 0, (index) {
                final product = data.products![index];
                return DataRow(
                  cells: [
                    DataCell(Text("${index + 1}", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (product.productName == null || product.productName!.isEmpty) ? "-" : product.productName!,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Text(
                            (product.productCode == null || product.productCode!.isEmpty) ? "-" : product.productCode!,
                            style: const TextStyle(fontSize: 10, color: AppColors.gray400),
                          ),
                        ],
                      ),
                    ),
                    DataCell(_sourceBadge(product.isAddedOnVisit ?? false)),
                    DataCell(
                      Text(
                        (product.taxInvoiceNo == null || product.taxInvoiceNo!.isEmpty) ? "-" : product.taxInvoiceNo!,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                    DataCell(
                      Text(
                        (product.warrantyTypeName == null || product.warrantyTypeName!.isEmpty) ? "-" : product.warrantyTypeName!,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                    DataCell(
                      Text(
                        (product.repeatServiceStatus == null || product.repeatServiceStatus!.isEmpty) ? "-" : product.repeatServiceStatus!,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                    DataCell(Text("${product.complaintQty ?? 0}", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                    DataCell(
                      Text(
                        "${product.solveQty ?? 0}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: (product.solveQty ?? 0) > 0 ? AppColors.green500Success : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    DataCell(Text("${product.installedQty ?? 0}", style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                    DataCell(
                      Text(
                        (product.usageNote == null || product.usageNote!.isEmpty) ? "-" : product.usageNote!,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                    DataCell(
                      Text(
                        (product.issueDescription == null || product.issueDescription!.isEmpty) ? "-" : product.issueDescription!,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sourceBadge(bool isAddedOnVisit) {
    String label = isAddedOnVisit ? "Added on Visit" : "Complaint";
    Color color = isAddedOnVisit ? AppColors.blueColor : AppColors.gray400;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _buildDetailCard({required String title, required IconData icon, required List<Widget> children, Widget? footer}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.indigo600Main),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.gray200),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(spacing: 24, runSpacing: 20, children: children),
          ),
          if (footer != null) ...[Padding(padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16), child: footer)],
        ],
      ),
    );
  }

  Widget _gridInfoItem(String label, String value, {bool isFullWidth = false, Widget? extra, Color? valueColor}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = isFullWidth ? constraints.maxWidth : (constraints.maxWidth - 24) / 2;
        if (width < 140 && !isFullWidth) {
          width = constraints.maxWidth;
        }

        return SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.gray400),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valueColor ?? AppColors.textPrimary),
                    ),
                  ),
                  if (extra != null) extra,
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statusBadgeSmall(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _statusBadge(VisitViewData item) {
    String label = item.statusName ?? item.status ?? "-";
    Color color = AppColors.gray500;

    String status = (item.status ?? "").toUpperCase();
    if (status == "COMPLETED") {
      color = AppColors.green500Success;
    } else if (status == "PENDING") {
      color = AppColors.orangeColor;
    } else if (status == "IN_PROGRESS") {
      color = AppColors.blue500;
    } else if (status == "CANCELLED" || status == "REJECTED") {
      color = AppColors.red500;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }

  Widget _techBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Text(
        label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  Widget _techStatusBadge(String status) {
    Color color = AppColors.gray500;
    if (status.toUpperCase() == "COMPLETED") color = AppColors.blueColor;
    if (status.toUpperCase() == "STARTED") color = AppColors.green500Success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _openFile(String? url) async {
    if (url == null || url.isEmpty) {
      Get.snackbar("Error", "File URL not available", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar("Error", "Could not open file", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred", snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _showAttachmentsDialog(List<String> attachments) {
    Get.dialog(
      AlertDialog(
        title: const Text("Attachments", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: attachments.map((url) {
            String fileName = url.split('/').last;
            return ListTile(
              leading: Icon(_getFileIcon(fileName), color: AppColors.indigo600Main, size: 20),
              title: Text(fileName, style: const TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () {
                Get.back();
                _openFile(url);
              },
            );
          }).toList(),
        ),
        actions: [TextButton(onPressed: () => Get.back(), child: const Text("Close"))],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    String ext = fileName.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif'].contains(ext)) return Icons.image_outlined;
    if (ext == 'pdf') return Icons.picture_as_pdf_outlined;
    return Icons.insert_drive_file_outlined;
  }

  Future<void> _openMap(String? lat, String? lng) async {
    if (lat == null || lng == null || lat.toString().isEmpty || lng.toString().isEmpty) {
      Get.snackbar("Error", "Location coordinates not available", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        Get.snackbar("Error", "Could not launch Google Maps", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
