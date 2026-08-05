import 'package:crm/module/home_screen/home_controller.dart';
import 'package:get/get.dart';
import '../notification_screen/controller/notification_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController());
    Get.lazyPut(() => NotificationController());
  }
}
