import 'package:crm/module/inquiry_screen/Inquiry_controller.dart';
import 'package:get/get.dart';
import '../notification_screen/controller/notification_controller.dart';

class InquiryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InquiryScreenController());
    Get.lazyPut(() => NotificationController());
  }
}
