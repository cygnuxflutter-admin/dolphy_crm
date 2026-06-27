import 'package:crm/config/app_images.dart';
import 'package:crm/module/splash_screen/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<SplashController>(
          builder: (controller) {
            return FadeTransition(
              opacity: controller.animation,
              child: ScaleTransition(
                scale: controller.animation,
                child: Image.asset(AppImages.logo, scale: 3),
              ),
            );
          },
        ),
      ),
    );
  }
}
