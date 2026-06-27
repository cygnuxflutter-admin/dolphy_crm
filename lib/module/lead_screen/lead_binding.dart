import 'package:get/get.dart';

import 'lead_controller.dart';

class LeadBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => LeadController());
  }
}
