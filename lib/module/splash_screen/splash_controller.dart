import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_shared_pref.dart';
import '../../main.dart';
import '../home_screen/home_binding.dart';
import '../home_screen/home_screen.dart';
import '../login_screen/login_binding.dart';
import '../login_screen/login_screen.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    );

    animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      navigateToNext();
    });
  }

  void navigateToNext() {
    final String token = pref!.getString(SharedPrefKey.token) ?? "";
    debugPrint("Token === $token");
    if (token != "") {
      Get.offAll(() => HomeScreen(), binding: HomeScreenBinding());
    } else {
      Get.offAll(() => LoginScreen(), binding: LoginScreenBinding());
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
