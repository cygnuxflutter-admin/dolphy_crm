import 'package:crm/config/app_colors.dart';
import 'package:crm/config/app_images.dart';
import 'package:crm/config/app_routes.dart';
import 'package:crm/module/home_screen/home_controller.dart';
import 'package:crm/module/home_screen/model/company_response_model.dart';
import 'package:crm/module/home_screen/model/location_response_model.dart';
import 'package:crm/utils/permission_handler.dart';
import 'package:crm/widget/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_shared_pref.dart';
import '../../main.dart';
import '../notification_screen/controller/notification_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeScreenController homeScreenController;
  late PermissionHandler permissionHandler;
  late NotificationController notificationController;

  @override
  void initState() {
    homeScreenController = Get.find<HomeScreenController>();
    permissionHandler = Get.find<PermissionHandler>();
    notificationController = Get.find<NotificationController>();
    initCall();
    super.initState();
  }

  Future<void> initCall() async {
    await homeScreenController.getLocation();
    await homeScreenController.getCompany();
    homeScreenController.selectedLocationData.value = LocationDatum(id: Pref.getLocationId(), locName: Pref.getLocationName());
    homeScreenController.selectedCompanyData.value = CompanyDatum(id: Pref.getCompanyId(), companyName: Pref.getCompanyName());
    homeScreenController.selectedFinancialYears.value = Pref.getFinancialYears();
    notificationController.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.indigo600Main,
        title: Image.asset(AppImages.logo, height: 40),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          Obx(
            () => Stack(
              children: [
                IconButton(
                  onPressed: () {
                    notificationController.markAllNotificationsAsRead();
                    Get.toNamed(AppRoutes.notificationScreen);
                  },
                  icon: const Icon(Icons.notifications_none_outlined, size: 26),
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
          IconButton(
            onPressed: () {
              showAlertDialog(context);
            },
            icon: const Icon(Icons.location_on_outlined),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
            children: [
              if (permissionHandler.isInquiryViewAllowed)
                _dashboardCard(
                  title: "Inquiry",
                  subtitle: "Manage your Inquiry",
                  icon: Icons.person_add_alt_1,
                  onTap: () => Get.toNamed(AppRoutes.inquiryScreen),
                ),
              if (permissionHandler.isLeadViewAllowed)
                _dashboardCard(title: "Lead", subtitle: "Track leads", icon: Icons.lightbulb_outline, onTap: () => Get.toNamed(AppRoutes.leadScreen)),
              if (permissionHandler.isPickingViewAllowed)
                _dashboardCard(
                  title: "PickIn",
                  subtitle: "Check your picking request",
                  icon: Icons.local_shipping_outlined,
                  onTap: () => Get.toNamed(AppRoutes.pickingListScreen),
                ),
              if (permissionHandler.isPackingViewAllowed)
                _dashboardCard(
                  title: "Packing",
                  subtitle: "Manage your packing list",
                  icon: Icons.inventory_2_outlined,
                  onTap: () => Get.toNamed(AppRoutes.packingScreen),
                ),
              if (permissionHandler.isVisitViewAllowed)
                _dashboardCard(
                  title: "Visits",
                  subtitle: "Track your visits",
                  icon: Icons.directions_walk_outlined,
                  onTap: () => Get.toNamed(AppRoutes.visitScreen),
                ),
              if (permissionHandler.isTechnicianExpenseViewAllowed)
                _dashboardCard(
                  title: "Visit Technician",
                  subtitle: "Technician expense",
                  icon: Icons.engineering_outlined,
                  onTap: () => Get.toNamed(AppRoutes.technicianExpenseScreen),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // DASHBOARD CARD
  Widget _dashboardCard({required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          boxShadow: [BoxShadow(color: AppColors.indigo600Main.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 30, color: AppColors.indigo600Main),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }

  // DRAWER
  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.indigo600Main,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppColors.indigo600Main, size: 40),
            ),
            accountName: Text(Pref.getUserName() ?? "User Name", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            accountEmail: null,
          ),
          ListTile(
            leading: const Icon(Icons.person_outline, color: AppColors.indigo600Main),
            title: const Text("Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            onTap: () {
              Get.back(); // Close drawer
              Get.toNamed(AppRoutes.profileScreen);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Logout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  // LOGOUT DIALOG
  void _logout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to logout?", style: TextStyle(fontSize: 15)),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.indigo600Main,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              await pref!.clear();
              Get.offAllNamed(AppRoutes.loginScreen);
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void showAlertDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.settings_outlined, color: AppColors.indigo600Main, size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    "App Settings",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, size: 20, color: AppColors.gray400),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, color: AppColors.gray200),
              ),
              Obx(
                () => _compactDropdown<LocationDatum>(
                  label: "Location",
                  items: homeScreenController.locationDataList,
                  itemAsString: (item) => item.locName,
                  selectedItem: homeScreenController.selectedLocationData.value,
                  onChanged: (value) => homeScreenController.selectedLocationData.value = value,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => _compactDropdown<String>(
                  label: "Financial Year",
                  items: homeScreenController.getLastThreeFinancialYears(),
                  itemAsString: (item) => item,
                  selectedItem: homeScreenController.selectedFinancialYears.value,
                  onChanged: (value) => homeScreenController.selectedFinancialYears.value = value,
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => _compactDropdown<CompanyDatum>(
                  label: "Company",
                  items: homeScreenController.companyDataList,
                  itemAsString: (item) => item.companyName,
                  selectedItem: homeScreenController.selectedCompanyData.value,
                  onChanged: (value) => homeScreenController.selectedCompanyData.value = value,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gray100,
                        foregroundColor: AppColors.textPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (homeScreenController.selectedLocationData.value != null &&
                            homeScreenController.selectedFinancialYears.value != null &&
                            homeScreenController.selectedCompanyData.value != null) {
                          await pref!.setString(SharedPrefKey.locationId, homeScreenController.selectedLocationData.value!.id);
                          await pref!.setString(SharedPrefKey.locationName, homeScreenController.selectedLocationData.value!.locName);
                          await pref!.setString(SharedPrefKey.financialYears, homeScreenController.selectedFinancialYears.value!);
                          await pref!.setString(SharedPrefKey.companyId, homeScreenController.selectedCompanyData.value!.id);
                          await pref!.setString(SharedPrefKey.companyName, homeScreenController.selectedCompanyData.value!.companyName);
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.indigo600Main,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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

  Widget _compactDropdown<T>({
    required String label,
    required List<T> items,
    required String Function(T) itemAsString,
    required T? selectedItem,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.gray500, letterSpacing: 0.5),
        ),
        const SizedBox(height: 6),
        CustomDropdown<T>(
          hintText: 'Select $label',
          items: (filter, loadProps) => items,
          itemAsString: itemAsString,
          selectedItem: selectedItem,
          compareFn: (a, b) => a == b,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
