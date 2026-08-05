import 'package:get/get.dart';

import '../notification_screen/controller/notification_controller.dart';
import 'lead_controller.dart';

class LeadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LeadController());
    Get.lazyPut(() => NotificationController());
  }
}
