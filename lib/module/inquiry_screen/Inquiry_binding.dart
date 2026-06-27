import 'package:crm/module/inquiry_screen/Inquiry_controller.dart';
import 'package:get/get.dart';

class InquiryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InquiryScreenController());
  }
}
