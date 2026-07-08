import 'package:get/get.dart';
import './technician_expense_controller.dart';

class TechnicianExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TechnicianExpenseController>(() => TechnicianExpenseController());
  }
}
