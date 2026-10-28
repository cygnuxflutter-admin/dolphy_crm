import 'dart:convert';

import '../main.dart';

class SharedPrefKey {
  static String token = "token";
  static String userName = "userName";
  static String userId = "userId";
  static String financialYears = "financialYears";
  static String locationId = "locationId";
  static String locationName = "locationName";
  static String companyId = "companyId";
  static String companyName = "companyName";
  static String userInfo = "user_info";
  static String userEmail = "userEmail";
  static String userPassword = "userPassword";
  static String rememberedUsers = "rememberedUsers";
  static String fcmToken = "fcmToken";
}

class Pref {
  static String? getToken() {
    return pref!.getString(SharedPrefKey.token);
  }

  static String? getUserName() {
    return pref!.getString(SharedPrefKey.userName);
  }

  static String getUserId() {
    return pref?.getString(SharedPrefKey.userId) ?? '';
  }

  static String getFinancialYears() {
    return pref?.getString(SharedPrefKey.financialYears) ?? '';
  }

  static String getLocationId() {
    return pref?.getString(SharedPrefKey.locationId) ?? '';
  }

  static String getLocationName() {
    return pref?.getString(SharedPrefKey.locationName) ?? '';
  }

  static String getCompanyId() {
    return pref?.getString(SharedPrefKey.companyId) ?? '';
  }

  static String getCompanyName() {
    return pref?.getString(SharedPrefKey.companyName) ?? '';
  }

  static String getFinYear() {
    return pref?.getString(SharedPrefKey.financialYears) ?? '';
  }

  static String getUserEmail() {
    return pref?.getString(SharedPrefKey.userEmail) ?? '';
  }

  static Map<String, dynamic>? getUserInfo() {
    String? userInfo = pref?.getString(SharedPrefKey.userInfo);
    if (userInfo == null) return null;
    try {
      return json.decode(userInfo);
    } catch (e) {
      return null;
    }
  }

  static String getUserPassword() {
    return pref?.getString(SharedPrefKey.userPassword) ?? '';
  }

  static List<Map<String, String>> getRememberedUsers() {
    String? usersJson = pref?.getString(SharedPrefKey.rememberedUsers);
    if (usersJson == null) return [];
    try {
      List<dynamic> decoded = json.decode(usersJson);
      return decoded.map((e) => Map<String, String>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveRememberedUser(String email, String password) async {
    List<Map<String, String>> users = getRememberedUsers();
    int index = users.indexWhere((u) => u['email'] == email);
    if (index != -1) {
      users[index]['password'] = password;
    } else {
      users.add({'email': email, 'password': password});
    }
    await pref!.setString(SharedPrefKey.rememberedUsers, json.encode(users));
  }

  static Future<void> removeRememberedUser(String email) async {
    List<Map<String, String>> users = getRememberedUsers();
    users.removeWhere((u) => u['email'] == email);
    await pref!.setString(SharedPrefKey.rememberedUsers, json.encode(users));
  }

  static Future<void> setToken(String value) async {
    await pref!.setString(SharedPrefKey.token, value);
  }

  static Future<void> setUserName(String value) async {
    await pref!.setString(SharedPrefKey.userName, value);
  }

  static Future<void> setUserId(String value) async {
    await pref!.setString(SharedPrefKey.userId, value);
  }

  static Future<void> setUserInfo(String value) async {
    await pref!.setString(SharedPrefKey.userInfo, value);
  }

  static Future<void> setUserEmail(String value) async {
    await pref!.setString(SharedPrefKey.userEmail, value);
  }

  static Future<void> setUserPassword(String value) async {
    await pref!.setString(SharedPrefKey.userPassword, value);
  }

  static String getFcmToken() {
    return pref?.getString(SharedPrefKey.fcmToken) ?? '';
  }

  static Future<void> setFcmToken(String value) async {
    await pref?.setString(SharedPrefKey.fcmToken, value);
  }
}
