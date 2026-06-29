import 'package:crm/module/home_screen/home_binding.dart';
import 'package:crm/module/home_screen/home_screen.dart';
import 'package:crm/module/inquiry_screen/Inquiry_binding.dart';
import 'package:crm/module/login_screen/login_binding.dart';
import 'package:crm/module/login_screen/login_screen.dart';
import 'package:get/get.dart';

import '../module/inquiry_screen/Inquiry_screen.dart';
import '../module/lead_screen/lead_binding.dart';
import '../module/lead_screen/lead_screen.dart';
import '../module/lead_screen/sub_screen/add_lead_screen.dart';
import '../module/lead_screen/sub_screen/lead_detail_screen.dart';
import '../module/packing_screen/packing_binding.dart';
import '../module/packing_screen/packing_screen.dart';
import '../module/packing_screen/sub_screen/packing_detail_screen.dart';
import '../module/packing_screen/sub_screen/packing_list_screen.dart';
import '../module/picking_list/picking_binding.dart';
import '../module/picking_list/picking_list_screen.dart';
import '../module/profile_screen/profile_binding.dart';
import '../module/profile_screen/profile_screen.dart';
import '../module/splash_screen/splash_binding.dart';
import '../module/splash_screen/splash_screen.dart';
import '../module/visit_screen/sub_screen/add_visit_screen.dart';
import '../module/visit_screen/sub_screen/field_report_screen.dart';
import '../module/visit_screen/sub_screen/visit_view_screen.dart';
import '../module/visit_screen/visit_binding.dart';
import '../module/visit_screen/visit_screen.dart';
import 'app_routes.dart';

List<GetPage> getPages = [
  GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen(), binding: SplashBinding()),
  GetPage(name: AppRoutes.loginScreen, page: () => LoginScreen(), binding: LoginScreenBinding()),
  GetPage(name: AppRoutes.homeScreen, page: () => HomeScreen(), binding: HomeScreenBinding()),
  // GetPage(name: AppRoutes.addLeadScreen, page: () => AddInquiryScreen(), binding: InquiryScreenBinding()),
  GetPage(name: AppRoutes.leadScreen, page: () => LeadScreen(), binding: LeadBinding()),
  GetPage(name: AppRoutes.AddLeadScreen, page: () => AddLeadScreen(), binding: LeadBinding()),
  GetPage(name: AppRoutes.LeadDetailScreen, page: () => LeadDetailScreen(), binding: LeadBinding()),
  GetPage(name: AppRoutes.inquiryScreen, page: () => InquiryScreen(), binding: InquiryScreenBinding()),
  GetPage(name: AppRoutes.pickingListScreen, page: () => PickingListScreen(), binding: PickingListBinding()),
  GetPage(name: AppRoutes.profileScreen, page: () => ProfileScreen(), binding: ProfileBinding()),
  GetPage(name: AppRoutes.packingScreen, page: () => const PackingScreen(), binding: PackingBinding()),
  GetPage(name: AppRoutes.packingDetailScreen, page: () => const PackingDetailScreen(), binding: PackingBinding()),
  GetPage(name: AppRoutes.packingListScreen, page: () => const PackingListScreen(), binding: PackingBinding()),
  GetPage(name: AppRoutes.visitScreen, page: () => const VisitScreen(), binding: VisitBinding()),
  GetPage(name: AppRoutes.visitViewScreen, page: () => const VisitViewScreen(), binding: VisitBinding()),
  GetPage(name: AppRoutes.visitFieldReportScreen, page: () => const FieldReportScreen(), binding: VisitBinding()),
  GetPage(name: AppRoutes.addVisitScreen, page: () => const AddVisitScreen(), binding: VisitBinding()),
];
