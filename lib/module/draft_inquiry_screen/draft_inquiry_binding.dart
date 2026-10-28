import 'package:get/get.dart';
import 'draft_inquiry_controller.dart';

class DraftInquiryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DraftInquiryController>(() => DraftInquiryController());
  }
}
