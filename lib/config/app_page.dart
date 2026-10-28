import 'package:crm/module/draft_inquiry_screen/draft_inquiry_binding.dart';
import 'package:crm/module/draft_inquiry_screen/draft_inquiry_screen.dart';
import 'package:crm/module/home_screen/home_binding.dart';
import 'package:crm/module/home_screen/home_screen.dart';
import 'package:crm/module/inquiry_screen/Inquiry_binding.dart';
import 'package:crm/module/login_screen/login_binding.dart';
import 'package:crm/module/login_screen/login_screen.dart';
import 'package:get/get.dart';

import 'package:crm/module/expense_screen/add_expense_screen.dart';
import 'package:crm/module/expense_screen/expense_binding.dart';
import 'package:crm/module/expense_screen/technician_expense_binding.dart';
import 'package:crm/module/expense_screen/technician_expense_screen.dart';
import 'package:crm/module/inquiry_screen/Inquiry_screen.dart';
import 'package:crm/module/lead_screen/lead_binding.dart';
import 'package:crm/module/lead_screen/lead_screen.dart';
import 'package:crm/module/lead_screen/sub_screen/add_lead_screen.dart';
import 'package:crm/module/lead_screen/sub_screen/lead_detail_screen.dart';
import 'package:crm/module/notification_screen/notification_binding.dart';
import 'package:crm/module/notification_screen/notification_screen.dart';
import 'package:crm/module/packing_screen/packing_binding.dart';
import 'package:crm/module/packing_screen/packing_screen.dart';
import 'package:crm/module/packing_screen/sub_screen/packing_detail_screen.dart';
import 'package:crm/module/packing_screen/sub_screen/packing_list_screen.dart';
import 'package:crm/module/packing_screen/sub_screen/picking_request_detail_view.dart';
import 'package:crm/module/packing_screen/view_pi_binding.dart';
import 'package:crm/module/packing_screen/view_pi_screen.dart';
import 'package:crm/module/picking_list/picking_binding.dart';
import 'package:crm/module/picking_list/picking_list_screen.dart';
import 'package:crm/module/profile_screen/profile_binding.dart';
import 'package:crm/module/profile_screen/profile_screen.dart';
import 'package:crm/module/splash_screen/splash_binding.dart';
import 'package:crm/module/splash_screen/splash_screen.dart';
import 'package:crm/module/visit_screen/sub_screen/add_visit_screen.dart';
import 'package:crm/module/visit_screen/sub_screen/field_report_screen.dart';
import 'package:crm/module/visit_screen/sub_screen/visit_history_screen.dart';
import 'package:crm/module/visit_screen/sub_screen/visit_view_screen.dart';
import 'package:crm/module/visit_screen/visit_binding.dart';
import 'package:crm/module/visit_screen/visit_screen.dart';
import 'package:crm/config/app_routes.dart';

List<GetPage> getPages = [
  GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen(), binding: SplashBinding()),
  GetPage(name: AppRoutes.loginScreen, page: () => LoginScreen(), binding: LoginScreenBinding()),
  GetPage(name: AppRoutes.homeScreen, page: () => HomeScreen(), binding: HomeScreenBinding()),
  GetPage(name: AppRoutes.leadScreen, page: () => LeadScreen(), binding: LeadBinding()),
  GetPage(name: AppRoutes.addLeadScreen, page: () => AddLeadScreen(), binding: LeadBinding()),
  GetPage(name: AppRoutes.LeadDetailScreen, page: () => LeadDetailScreen(), binding: LeadBinding()),
  GetPage(name: AppRoutes.inquiryScreen, page: () => InquiryScreen(), binding: InquiryScreenBinding()),
  GetPage(name: AppRoutes.pickingListScreen, page: () => PickingListScreen(), binding: PickingListBinding()),
  GetPage(name: AppRoutes.profileScreen, page: () => ProfileScreen(), binding: ProfileBinding()),
  GetPage(name: AppRoutes.packingScreen, page: () => const PackingScreen(), binding: PackingBinding()),
  GetPage(name: AppRoutes.packingDetailScreen, page: () => PackingDetailScreen(), binding: PackingBinding()),
  GetPage(name: AppRoutes.packingListScreen, page: () => PackingListScreen(), binding: PackingBinding()),
  GetPage(name: AppRoutes.pickingRequestDetailScreen, page: () => PickingRequestDetailView(), binding: PackingBinding()),
  GetPage(name: AppRoutes.visitScreen, page: () => const VisitScreen(), binding: VisitBinding()),
  GetPage(name: AppRoutes.visitViewScreen, page: () => const VisitViewScreen(), binding: VisitBinding()),
  GetPage(name: AppRoutes.visitFieldReportScreen, page: () => const FieldReportScreen(), binding: VisitBinding()),
  GetPage(name: AppRoutes.visitHistoryScreen, page: () => const VisitHistoryScreen(), binding: VisitBinding()),
  GetPage(name: AppRoutes.addVisitScreen, page: () => const AddVisitScreen(), binding: VisitBinding()),
  GetPage(name: AppRoutes.addExpenseScreen, page: () => const AddExpenseScreen(), binding: ExpenseBinding()),
  GetPage(name: AppRoutes.technicianExpenseScreen, page: () => const TechnicianExpenseScreen(), binding: TechnicianExpenseBinding()),
  GetPage(name: AppRoutes.notificationScreen, page: () => const NotificationScreen(), binding: NotificationBinding()),
  GetPage(name: AppRoutes.viewPiScreen, page: () => const ViewPiScreen(), binding: ViewPiBinding()),
  GetPage(name: AppRoutes.draftInquiryScreen, page: () => const DraftInquiryScreen(), binding: DraftInquiryBinding()),
];
