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
}
