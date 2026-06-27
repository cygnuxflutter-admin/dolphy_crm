import 'dart:convert';

import 'package:crm/module/home_screen/home_binding.dart';
import 'package:crm/module/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';
import '../../config/app_shared_pref.dart';
import '../../config/app_url.dart';
import '../../main.dart';
import '../../utils/api_handler.dart';
import '../../widget/toast_message.dart';

class LoginScreenController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController(/*text: "dipl@gmail.com"*/).obs;
  Rx<TextEditingController> passwordController = TextEditingController(/*text: "TenantAdmin#2025"*/).obs;
  RxBool obSecure = true.obs;
  RxBool isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true;
    var response = await ApiHandler.postRequest(
      url: ApiEndPoint.logIn,
      body: {"email": emailController.value.text, "password": passwordController.value.text},
    );

    final data = response.data;

    if (response.statusCode == 200) {
      // LoginModel loginModel = loginModelFromJson(json.encode(response.data));

      if (data['status'] == 200) {
        await pref!.setString(SharedPrefKey.token, data['accessToken']);
        await pref!.setString(SharedPrefKey.userId, data['data']['id']);
        await pref!.setString(SharedPrefKey.userName, "${data['data']['first_name']} ${data['data']['last_name']}");
        await pref!.setString(SharedPrefKey.userInfo, json.encode(data['data']));

        debugPrint(data['accessToken']);
        debugPrint(data['data']['id']);
        debugPrint("${data['data']['first_name']} ${data['data']['last_name']}");

        isLoading.value = false;
        toastMessage(text: "Login Successfully", color: AppColors.greenColor, isTop: false);
        Get.offAll(() => HomeScreen(), binding: HomeScreenBinding());
      } else {
        isLoading.value = false;
        toastMessage(text: "Invalid Credential ", color: AppColors.redColor, isTop: false);
        debugPrint("not done in else${response.statusCode}");
      }
    } else {
      isLoading.value = false;
      toastMessage(text: "Invalid Credential", color: AppColors.redColor, isTop: false);
      debugPrint("not done ${response.statusCode}");
    }
  }
}
