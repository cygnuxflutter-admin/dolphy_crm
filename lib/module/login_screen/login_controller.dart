import 'dart:convert';

import 'package:crm/module/home_screen/home_binding.dart';
import 'package:crm/module/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';
import '../../config/app_shared_pref.dart';
import '../../config/app_strings.dart';
import '../../config/app_url.dart';
import '../../utils/api_handler.dart';
import '../../utils/permission_handler.dart';
import '../../widget/toast_message.dart';

class LoginScreenController extends GetxController {
  final TextEditingController emailController = TextEditingController(text: "dipl@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "TenantAdmin#2025");
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  RxBool obSecure = true.obs;
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;
  RxBool isManualMode = false.obs;
  RxList<Map<String, String>> rememberedUsers = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRememberedUsers();
    rememberMe.value = Pref.isRememberMe();
    if (rememberMe.value) {
      emailController.text = Pref.getUserEmail();
      passwordController.text = Pref.getUserPassword();
    }
  }

  void loadRememberedUsers() {
    rememberedUsers.assignAll(Pref.getRememberedUsers());
  }

  void selectUser(Map<String, String> user) {
    emailController.text = user['email'] ?? '';
    passwordController.text = user['password'] ?? '';
    rememberMe.value = true;
    isManualMode.value = false;
  }

  void showSavedAccountsSelection() {
    if (rememberedUsers.isEmpty) return;

    FocusManager.instance.primaryFocus?.unfocus();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: rememberedUsers.length,
                itemBuilder: (context, index) {
                  var user = rememberedUsers[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.indigo600Main.withValues(alpha: 0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.person, color: AppColors.indigo600Main, size: 20),
                    ),
                    title: Text(user['email'] ?? "", style: const TextStyle(fontWeight: FontWeight.w500)),
                    onTap: () {
                      selectUser(user);
                      Get.back();
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.redColor, size: 20),
                      onPressed: () {
                        removeUser(user['email'] ?? "");
                        if (rememberedUsers.isEmpty) Get.back();
                      },
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 30),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.edit_note, color: AppColors.indigo600Main),
              title: const Text(
                "Use another account / Type manually",
                style: TextStyle(color: AppColors.indigo600Main, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                isManualMode.value = true;
                Get.back();
                emailFocusNode.requestFocus();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void removeUser(String email) async {
    await Pref.removeRememberedUser(email);
    loadRememberedUsers();
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      var response = await ApiHandler.postRequest(
        url: ApiEndPoint.logIn,
        body: {"email": emailController.text.trim(), "password": passwordController.text},
      );

      final data = response.data;
      debugPrint("Login Response: $data");

      if (response.statusCode == 200) {
        if (data != null && data['status'] == 200) {
          if (rememberMe.value) {
            await Pref.setRememberMe(true);
            await Pref.setUserEmail(emailController.text.trim());
            await Pref.setUserPassword(passwordController.text);
            await Pref.saveRememberedUser(emailController.text.trim(), passwordController.text);
            loadRememberedUsers();
          } else {
            await Pref.setRememberMe(false);
          }

          await Pref.setToken(data['accessToken'] ?? "");
          await Pref.setUserId(data['data']?['id']?.toString() ?? "");
          await Pref.setUserName("${data['data']?['first_name'] ?? ""} ${data['data']?['last_name'] ?? ""}");
          await Pref.setUserInfo(json.encode(data['data']));

          Get.find<PermissionHandler>().getUserRolePermission();

          isLoading.value = false;
          toastMessage(text: AppStrings.loginSuccessfully, color: AppColors.greenColor, isTop: false);
          Get.offAll(() => HomeScreen(), binding: HomeScreenBinding());
        } else {
          isLoading.value = false;
          toastMessage(text: data?['message'] ?? AppStrings.invalidCredential, color: AppColors.redColor, isTop: false);
        }
      } else {
        isLoading.value = false;
        toastMessage(text: data?['message'] ?? "Server error: ${response.statusCode}", color: AppColors.redColor, isTop: false);
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      isLoading.value = false;
      toastMessage(text: "Connection error. Please check your network.", color: AppColors.redColor, isTop: false);
    }
  }
}
