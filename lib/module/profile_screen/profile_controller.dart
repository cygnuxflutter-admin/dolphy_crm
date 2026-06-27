import 'dart:convert';

import 'package:crm/module/login_screen/login_model.dart';
import 'package:get/get.dart';

import '../../config/app_shared_pref.dart';
import '../../main.dart';

class ProfileController extends GetxController {
  Rxn<LogInData> userData = Rxn<LogInData>();

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  void getUserInfo() {
    try {
      String? userInfo = pref!.getString(SharedPrefKey.userInfo);
      if (userInfo != null) {
        Map<String, dynamic> userMap = json.decode(userInfo);
        userData.value = LogInData.fromJson(userMap);
      }
    } catch (e) {
      print("Error parsing user info: $e");
    }
  }
}
