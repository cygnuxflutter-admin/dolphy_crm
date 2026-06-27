import 'package:get/get.dart';

import 'picking_list_controller.dart';

class PickingListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PickingListController>(() => PickingListController());
  }
}
