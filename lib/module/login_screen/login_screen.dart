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
      backgroundColor: Colors.white, // Background white taaki bottom scroll/bounce white dikhe
      body: Stack(
        children: [
          // Blue background overlay top section ke liye
          Container(height: MediaQuery.of(context).size.height * 0.5, color: AppColors.indigo600Main),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Top section with Logo (Blue Area)
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(padding: const EdgeInsets.all(18), child: Image.asset(AppImages.logo)),
                        const SizedBox(height: 10),
                        const Text(
                          "Welcome Back",
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        const Text("Login to continue", style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ),

                // Bottom section with Form (White Area that fills screen)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
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

                        // Email Field with Overlay
                        Obx(() {
                          bool isSelectionMode = loginScreenController.rememberedUsers.isNotEmpty && !loginScreenController.isManualMode.value;
                          return Stack(
                            children: [
                              commonTextField(
                                labelText: "Email",
                                hintText: "you@example.com",
                                controller: loginScreenController.emailController,
                                focusNode: loginScreenController.emailFocusNode,
                                isEmailValidator: true,
                                suffixIcon: isSelectionMode ? const Icon(Icons.keyboard_arrow_down, color: AppColors.gray500) : null,
                              ),
                              if (isSelectionMode)
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () => loginScreenController.showSavedAccountsSelection(),
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(color: Colors.transparent),
                                  ),
                                ),
                            ],
                          );
                        }),

                        const SizedBox(height: 16),

                        // Password Field with Overlay
                        Obx(() {
                          bool isSelectionMode = loginScreenController.rememberedUsers.isNotEmpty && !loginScreenController.isManualMode.value;
                          return Stack(
                            children: [
                              commonTextField(
                                labelText: "Password",
                                hintText: "••••••••",
                                controller: loginScreenController.passwordController,
                                focusNode: loginScreenController.passwordFocusNode,
                                obscureText: loginScreenController.obSecure.value,
                                maxLine: 1,
                                minLine: 1,
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isSelectionMode) const Icon(Icons.keyboard_arrow_down, color: AppColors.gray500),
                                    IconButton(
                                      onPressed: () {
                                        loginScreenController.obSecure.value = !loginScreenController.obSecure.value;
                                      },
                                      icon: Icon(
                                        loginScreenController.obSecure.value ? Icons.visibility : Icons.visibility_off,
                                        color: AppColors.gray500,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                validationMessage: "Password is required!",
                              ),
                              if (isSelectionMode)
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () => loginScreenController.showSavedAccountsSelection(),
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(color: Colors.transparent),
                                  ),
                                ),
                            ],
                          );
                        }),

                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(() {
                              return SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: loginScreenController.rememberMe.value,
                                  activeColor: AppColors.indigo600Main,
                                  onChanged: (value) {
                                    loginScreenController.rememberMe.value = value!;
                                  },
                                ),
                              );
                            }),
                            const SizedBox(width: 8),
                            const Text(
                              "Remember Me",
                              style: TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
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
                        const SizedBox(height: 40), // Extra space bottom bounce ke liye
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
