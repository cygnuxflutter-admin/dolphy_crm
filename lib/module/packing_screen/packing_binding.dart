import 'package:get/get.dart';
import 'packing_controller.dart';

class PackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PackingController>(() => PackingController());
  }
}
