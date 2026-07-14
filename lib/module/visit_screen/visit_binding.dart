import 'package:get/get.dart';

import 'add_visit_controller.dart';
import 'visit_controller.dart';

class VisitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitController>(() => VisitController());
    Get.lazyPut<AddVisitController>(() => AddVisitController());
  }
}
