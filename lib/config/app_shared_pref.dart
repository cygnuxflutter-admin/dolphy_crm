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
  static String isRememberMe = "isRememberMe";
  static String userEmail = "userEmail";
  static String userPassword = "userPassword";
  static String rememberedUsers = "rememberedUsers";
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

  static bool isRememberMe() {
    return pref?.getBool(SharedPrefKey.isRememberMe) ?? false;
  }

  static String getUserEmail() {
    return pref?.getString(SharedPrefKey.userEmail) ?? '';
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
}

