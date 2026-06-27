import 'package:crm/module/login_screen/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';
import '../../config/app_images.dart';
import '../../widget/button_view.dart';
import '../../widget/textfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginScreenController loginScreenController = Get.find<LoginScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.indigo600Main,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 16)],
                    ),
                    child: Image.asset(AppImages.logo, scale: 10),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text("Login to continue", style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      const Text("Enter your credentials", style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      const SizedBox(height: 26),
                      commonTextField(
                        labelText: "Email",
                        hintText: "you@example.com",
                        controller: loginScreenController.emailController.value,
                        isEmailValidator: true,
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        return commonTextField(
                          labelText: "Password",
                          hintText: "••••••••",
                          controller: loginScreenController.passwordController.value,
                          obscureText: loginScreenController.obSecure.value,
                          maxLine: 1,
                          minLine: 1,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              loginScreenController.obSecure.value = !loginScreenController.obSecure.value;
                            },
                            child: Icon(loginScreenController.obSecure.value ? Icons.visibility : Icons.visibility_off, color: AppColors.gray500),
                          ),
                          validationMessage: "Password is required!",
                        );
                      }),
                      const SizedBox(height: 32),
                      Obx(() {
                        return commonButton(
                          name: "Login",
                          isLoader: loginScreenController.isLoading.value,
                          loaderColorWhite: true,
                          bgColor: AppColors.indigo600Main,
                          onTap: () {
                            loginScreenController.login();
                          },
                        );
                      }),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
