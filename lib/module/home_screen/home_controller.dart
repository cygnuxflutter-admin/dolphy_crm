import 'dart:convert';

import 'package:crm/config/app_shared_pref.dart';
import 'package:crm/config/app_url.dart';
import 'package:crm/main.dart';
import 'package:crm/module/home_screen/model/company_response_model.dart';
import 'package:crm/module/home_screen/model/location_response_model.dart';
import 'package:crm/utils/api_handler.dart';
import 'package:get/get.dart';

import '../../config/app_routes.dart';

class HomeScreenController extends GetxController {
  RxList<LocationDatum> locationDataList = <LocationDatum>[].obs;
  RxList<CompanyDatum> companyDataList = <CompanyDatum>[].obs;
  Rx<LocationDatum?> selectedLocationData = Rx<LocationDatum?>(null);
  Rx<CompanyDatum?> selectedCompanyData = Rx<CompanyDatum?>(null);
  Rx<String?> selectedFinancialYears = Rx<String?>(null);

  Future<void> getLocation() async {
    final response = await ApiHandler.getRequest("${ApiEndPoint.getLocation}?page=1&limit=100&search=");
    final data = json.decode(response.data);
    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        LocationResponse locationResponse = LocationResponse.fromJson(json.decode(response.data));
        locationDataList.addAll(locationResponse.locationData);
        logger.i(JsonEncoder.withIndent(" " * 4).convert(locationDataList));
        if (Pref.getLocationId().isEmpty) {
          await pref!.setString(SharedPrefKey.locationId, locationDataList.firstWhere((e) => e.locCode == "U-A").id);
          await pref!.setString(SharedPrefKey.locationName, locationDataList.firstWhere((e) => e.locCode == "U-A").locName);
        }
        if (Pref.getFinancialYears().isEmpty) {
          await pref!.setString(SharedPrefKey.financialYears, getLastThreeFinancialYears().first);
          selectedFinancialYears.value = getLastThreeFinancialYears().first;
        }
      }
    } else {
      if (data['status'] == 401) {
        if (data['title'] == "unauthorized") {
          await pref!.clear();
          Get.offAllNamed(AppRoutes.loginScreen);
        }
      }
    }
  }

  Future<void> getCompany() async {
    final response = await ApiHandler.getRequest(ApiEndPoint.getCompany);
    final data = json.decode(response.data);
    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        CompanyResponse companyResponse = CompanyResponse.fromJson(json.decode(response.data));
        companyDataList.addAll(companyResponse.companyData);
        if (Pref.getCompanyId().isEmpty) {
          await pref!.setString(SharedPrefKey.companyId, companyDataList.first.id);
          await pref!.setString(SharedPrefKey.companyName, companyDataList.first.companyName);
        }
      }
    } else {
      if (data['status'] == 401) {
        if (data['title'] == "unauthorized") {
          await pref!.clear();
          Get.offAllNamed(AppRoutes.loginScreen);
        }
      }
    }
  }

  List<String> getLastThreeFinancialYears() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;

    int startYear;

    if (month >= 4) {
      startYear = year;
    } else {
      startYear = year - 1;
    }

    List<String> financialYears = [];

    for (int i = 0; i < 3; i++) {
      int fyStart = startYear - i;
      int fyEnd = fyStart + 1;
      financialYears.add("$fyStart-$fyEnd");
    }

    return financialYears;
  }
}
