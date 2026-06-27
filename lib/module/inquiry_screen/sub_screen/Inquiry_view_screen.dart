import 'package:crm/config/app_colors.dart';
import 'package:crm/config/app_images.dart';
import 'package:crm/module/inquiry_screen/Inquiry_controller.dart';
import 'package:crm/module/inquiry_screen/model/Inquiry_view_response.dart';
import 'package:crm/module/inquiry_screen/sub_screen/add_Inquiry_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class InquiryDetailScreen extends StatelessWidget {
  InquiryDetailScreen({super.key});

  final InquiryScreenController controller = Get.find<InquiryScreenController>();
  final RxInt selectedTab = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Obx(() {
        if (controller.isLeadViewLoading.isTrue) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }

        if (controller.leadViewData.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppImages.noDataFound, scale: 3),
                const SizedBox(height: 16),
                const Text(
                  "No Lead Data Found",
                  style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        final lead = controller.leadViewData.value!;
        final tagText = controller.leadTagsTypeList.where((e) => lead.tags?.contains(e.id) ?? false).map((e) => e.name).join(", ");

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(lead),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildStatsSection(lead.summary),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [_buildInfoCard(lead, tagText), const SizedBox(height: 20), _buildTabsAndContent(lead), const SizedBox(height: 40)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAppBar(InquiryViewData lead) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
          onPressed: () {
            if (lead.id != null) {
              Get.to(() => AddInquiryScreen(isEdit: true, id: lead.id));
            }
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryColor, AppColors.indigo600Main],
                ),
              ),
            ),
            // Decorative elements
            Positioned(top: -30, right: -30, child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withOpacity(0.05))),
            Positioned(bottom: 40, left: -20, child: CircleAvatar(radius: 50, backgroundColor: Colors.white.withOpacity(0.03))),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: AppColors.indigo50,
                      child: Text(
                        lead.contactName?.substring(0, 1).toUpperCase() ?? "L",
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  lead.contactName ?? "Unknown Lead",
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.business_center_rounded, size: 14, color: Colors.white.withOpacity(0.8)),
                    const SizedBox(width: 6),
                    Text(
                      lead.companyName ?? "No Company",
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not launch $url", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Widget _buildStatsSection(Summary? summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statCard("Leads", summary?.totalOpportunities ?? 0, Icons.rocket_launch_rounded, Colors.orange),
          _statCard("Quotes", summary?.totalQuotations ?? 0, Icons.description_rounded, Colors.blue),
          _statCard("Invoices", summary?.totalInvoices ?? 0, Icons.receipt_long_rounded, Colors.green),
        ],
      ),
    );
  }

  Widget _statCard(String label, int count, IconData icon, Color color) {
    return Container(
      width: Get.width * 0.28,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(InquiryViewData lead, String tagText) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.person_search_rounded, color: AppColors.primaryColor, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Identity & Contact Details",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const Divider(indent: 20, endIndent: 20),
          _infoTileRow("Company Name", lead.companyName ?? "-", "Customer Code", lead.customerCode ?? "-"),
          _infoTileRow("PAN Number", lead.pan ?? "-", "GST Treatment", lead.gstCategoryName?.toString() ?? "-"),
          _infoTileRow("Mobile 1", "${lead.mobile1CountryCode ?? ""} ${lead.mobile1 ?? "-"}".trim(), "Mobile 2", "${lead.mobile2CountryCode ?? ""} ${lead.mobile2 ?? "-"}".trim()),
          _infoTileRow("Email Address", lead.email ?? "-", "Website", lead.website ?? "-"),
          _infoTileRow("Customer Group", lead.customerGroupName ?? "-", "Brand Name", lead.customerBrandName ?? "-"),
          _infoTileRow("GST / Tax ID", lead.gstNumber?.toString() ?? "-", "Tags", tagText.isEmpty ? "-" : tagText),
          _singleInfoTile(
            "Primary Address",
            "${lead.address ?? ""}, ${lead.cityName ?? ""}, ${lead.stateName ?? ""} - ${lead.pincodeName ?? ""}",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _infoTileRow(String label1, String value1, String label2, String value2, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, isLast ? 20 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label1.toUpperCase(),
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary.withOpacity(0.8), fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  value1.isEmpty ? "-" : value1,
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label2.toUpperCase(),
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary.withOpacity(0.8), fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  value2.isEmpty ? "-" : value2,
                  style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _singleInfoTile(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, isLast ? 20 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary.withOpacity(0.8), fontWeight: FontWeight.w800, letterSpacing: 0.5),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty || value == ", ,  - " ? "-" : value,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsAndContent(InquiryViewData lead) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: Row(children: [
            _tabButton(0, "Addresses", Icons.person_outline_rounded, lead.addresses?.length ?? 0),
            _tabButton(1, "Configuration", Icons.settings_outlined, null),
          ]),
        ),
        const SizedBox(height: 20),
        Obx(() {
          if (selectedTab.value == 0) {
            return _buildAddressList(lead);
          }
          return _buildConfigurationTab(lead);
        }),
      ],
    );
  }

  Widget _tabButton(int index, String label, IconData icon, int? count) {
    return Expanded(
      child: GestureDetector(
        onTap: () => selectedTab.value = index,
        child: Obx(() {
          final isSelected = selectedTab.value == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(14)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: isSelected ? AppColors.primaryColor : AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: isSelected ? AppColors.primaryColor : AppColors.textSecondary),
                ),
                if (count != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryColor : AppColors.gray100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildConfigurationTab(InquiryViewData lead) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("OFFICE DETAILS"),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _infoTileRow("Credit Limit", "₹${lead.creditLimit ?? "0"}", "Temp Limit", "₹${lead.temporaryCreditLimit ?? "0"}"),
              _infoTileRow("Credit Days", "${lead.creditDays ?? "0"} Days", "Tax Type", lead.defaultTaxType?.toString() ?? "-"),
              _infoTileRow(
                  "Price Type",
                  lead.defaultPriceType != null ? controller.getPriceTypeItem(lead.defaultPriceType!).name : "-",
                  "Disc / Int (%)",
                  "${lead.specialDiscountPercent ?? "0.00"}% / ${lead.overdueInterestPercent ?? "0.00"}%",
                  isLast: true),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle("FINANCIAL INFORMATION"),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _infoTileRow("Registration", "-", "Aadhar", lead.aadhaarNumber?.toString() ?? "-"),
              _infoTileRow("GST Date", lead.gstDate?.toString() ?? "-", "CST Number", lead.cstNumber?.toString() ?? "-"),
              _infoTileRow("CST Date", lead.cstDate?.toString() ?? "-", "Service Tax", lead.serviceTaxNumber?.toString() ?? "-", isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primaryColor, letterSpacing: 1.0),
      ),
    );
  }

  Widget _buildAddressList(InquiryViewData lead) {
    if (lead.addresses == null || lead.addresses!.isEmpty) {
      return _buildEmptyState(Icons.location_off_rounded, "No addresses found");
    }
    return Column(children: lead.addresses!.map((addr) => _buildAddressCard(addr)).toList());
  }

  Widget _buildAddressCard(LeadViewAddress addr) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppColors.primaryColor.withOpacity(0.05),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      addr.addressTypeName ?? "Address",
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_horiz_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    addr.street ?? "Street not mentioned",
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_city_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        "${addr.cityName ?? ""}, ${addr.stateName ?? ""} (${addr.pincodeName ?? ""})",
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person_rounded, size: 16, color: AppColors.primaryColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            addr.contactName ?? "-",
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ),
                        const VerticalDivider(),
                        GestureDetector(
                          onTap: () => _launchUrl('tel:${addr.mobile1}'),
                          child: Row(
                            children: [
                              const Icon(Icons.phone_in_talk_rounded, size: 16, color: AppColors.primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                addr.mobile1 ?? "-",
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.gray200),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
