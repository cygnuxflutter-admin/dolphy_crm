import 'dart:convert';

import 'package:crm/config/app_shared_pref.dart';
import 'package:crm/config/app_url.dart';
import 'package:crm/main.dart';
import 'package:crm/module/home_screen/model/company_response_model.dart';
import 'package:crm/module/home_screen/model/location_response_model.dart';
import 'package:crm/utils/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../config/app_routes.dart';

class HomeScreenController extends GetxController {
  RxList<LocationDatum> locationDataList = <LocationDatum>[].obs;
  RxList<CompanyDatum> companyDataList = <CompanyDatum>[].obs;
  Rx<LocationDatum?> selectedLocationData = Rx<LocationDatum?>(null);
  Rx<CompanyDatum?> selectedCompanyData = Rx<CompanyDatum?>(null);
  Rx<String?> selectedFinancialYears = Rx<String?>(null);
  RxString appVersion = "".obs;

  @override
  void onInit() {
    super.onInit();
    getAppVersion();
  }

  Future<void> getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String environment = "Test";
      if (ApiEndPoint.baseUrl.contains("dolphyapi.cygnux.in")) {
        environment = "Live";
      } else if (ApiEndPoint.baseUrl.contains("tradeapi.cygnux.in")) {
        environment = "Test";
      }

      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      if (buildNumber.isNotEmpty) {
        appVersion.value = "$environment V-$buildNumber";
      } else {
        appVersion.value = "$environment V$version";
      }
    } catch (e) {
      debugPrint("Error fetching package info: $e");
    }
  }

  Future<void> getLocation() async {
    final response = await ApiHandler.getRequest("${ApiEndPoint.getLocation}?page=1&limit=100&search=");
    final data = json.decode(response.data);
    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        LocationResponse locationResponse = LocationResponse.fromJson(json.decode(response.data));
        locationDataList.addAll(locationResponse.locationData);
        logger.i(JsonEncoder.withIndent(" " * 4).convert(locationDataList));
        if (Pref.getLocationId().isEmpty) {
          await pref!.setString(SharedPrefKey.locationId, locationDataList.firstWhere((e) => e.locCode == "U-C").id);
          await pref!.setString(SharedPrefKey.locationName, locationDataList.firstWhere((e) => e.locCode == "U-C").locName);
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
    Map<String, dynamic>? userInfo = Pref.getUserInfo();

    if (userInfo?['user_info'] != null && userInfo!['user_info']['company_names'].isNotEmpty) {
      List<dynamic> companyNames = userInfo['user_info']['company_names'];
      String? defaultCompanyId = userInfo['user_info']['company']?.toString();

      companyDataList.clear();
      for (var item in companyNames) {
        companyDataList.add(CompanyDatum(id: item['value']?.toString() ?? "", companyName: item['label']?.toString() ?? ""));
      }

      if (companyDataList.isNotEmpty) {
        CompanyDatum selected;
        if (defaultCompanyId != null && defaultCompanyId.isNotEmpty) {
          // Find the company that matches the default ID from login response
          selected = companyDataList.firstWhere((e) => e.id == defaultCompanyId, orElse: () => companyDataList.first);
        } else {
          // If no default company ID, fallback to first one
          selected = companyDataList.first;
        }

        await pref!.setString(SharedPrefKey.companyId, selected.id);
        await pref!.setString(SharedPrefKey.companyName, selected.companyName);
      }
      return;
    }
    debugPrint("here");

    final response = await ApiHandler.getRequest(ApiEndPoint.getCompany);
    final data = json.decode(response.data);
    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        CompanyResponse companyResponse = CompanyResponse.fromJson(json.decode(response.data));
        companyDataList.clear();
        companyDataList.addAll(companyResponse.companyData);
        if (Pref.getCompanyId().isEmpty && companyDataList.isNotEmpty) {
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
