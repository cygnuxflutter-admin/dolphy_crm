import 'dart:convert';
import 'dart:io';

import 'package:crm/config/app_colors.dart';
import 'package:crm/utils/api_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/app_shared_pref.dart';
import '../../config/app_url.dart';
import '../../main.dart';
import '../home_screen/home_binding.dart';
import '../home_screen/home_screen.dart';
import '../login_screen/login_binding.dart';
import '../login_screen/login_screen.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeIn);

    animationController.forward();
  }

  @override
  void onReady() {
    super.onReady();
    _checkAppVersion();
  }

  Future<void> _checkAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;
      debugPrint("Current App Version: $currentVersion");

      final response = await ApiHandler.getRequest(ApiEndPoint.latestVersion);
      debugPrint("Status === ${response.statusCode}");
      debugPrint("Response === ${response.data}");

      dynamic data;
      if (response.data is String) {
        try {
          data = jsonDecode(response.data);
        } catch (e) {
          debugPrint("JSON Decode error: $e");
        }
      } else if (response.data is Map) {
        data = response.data;
      }

      if (response.statusCode == 200 && data != null && (data['success'] == true || data['status'] == 200)) {
        var versionData = data['data'] is Map ? data['data'] : data;
        String latestVersion = versionData['version']?.toString().trim() ?? "";
        String downloadUrl = (versionData['download_url'] ?? versionData['downloadUrl'] ?? versionData['url'])?.toString().trim() ?? "";

        debugPrint("Latest App Version from API: $latestVersion");

        if (latestVersion.isNotEmpty && currentVersion.trim() != latestVersion) {
          _showUpdateDialog(downloadUrl);
        } else {
          _proceedToNext();
        }
      } else {
        _proceedToNext();
      }
    } catch (e) {
      debugPrint("Error checking app version: $e");
      _proceedToNext();
    }
  }

  void _showUpdateDialog(String downloadUrl) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppColors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppColors.indigo50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.system_update_rounded,
                    color: AppColors.indigo600Main,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Update Required",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "A new version of the app is available. Please update to continue using the application.",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray500,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else {
                            exit(0);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.red500),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Exit",
                          style: TextStyle(color: AppColors.red500, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (downloadUrl.isNotEmpty) {
                            try {
                              String urlString = downloadUrl.trim();
                              if (!urlString.startsWith("http://") && !urlString.startsWith("https://")) {
                                urlString = "https://$urlString";
                              }
                              final Uri url = Uri.parse(urlString);
                              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                Get.snackbar("Error", "Could not launch update URL");
                              }
                            } catch (e) {
                              debugPrint("Error launching URL: $e");
                              Get.snackbar("Error", "Could not launch update URL");
                            }
                          } else {
                            Get.snackbar("Error", "Update link not found");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.indigo600Main,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Update",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _proceedToNext() {
    Future.delayed(const Duration(seconds: 1), () {
      navigateToNext();
    });
  }

  void navigateToNext() {
    final String token = pref!.getString(SharedPrefKey.token) ?? "";
    debugPrint("Token === $token");
    if (token != "") {
      Get.offAll(() => HomeScreen(), binding: HomeScreenBinding());
    } else {
      Get.offAll(() => LoginScreen(), binding: LoginScreenBinding());
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
