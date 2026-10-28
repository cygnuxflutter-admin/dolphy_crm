import 'package:crm/module/packing_screen/view_pi_controller.dart';
import 'package:get/get.dart';

class ViewPiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewPiController>(() => ViewPiController());
  }
}
