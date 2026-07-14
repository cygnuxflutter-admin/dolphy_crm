import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_shared_pref.dart';
import '../main.dart';

class PermissionHandler extends GetxService {
  RxMap rolePermission = {}.obs;

  @override
  void onInit() {
    super.onInit();
    getUserRolePermission();
  }

  void getUserRolePermission() {
    String? userInfoString = pref!.getString(SharedPrefKey.userInfo);
    if (userInfoString != null) {
      try {
        Map<String, dynamic> userInfo = json.decode(userInfoString);
        if (userInfo.containsKey('rolePermission')) {
          var permissions = userInfo['rolePermission'];
          if (permissions is Map) {
            rolePermission.assignAll(permissions);
            debugPrint("PermissionHandler: rolePermission loaded (Map)");
          } else if (permissions is List) {
            // If it's a list, we convert it to a map or handle it accordingly
            // For now, let's keep it as is but assign to value if GetX allows
            rolePermission.value = {for (var item in permissions) permissions.indexOf(item).toString(): item};
            debugPrint("PermissionHandler: rolePermission loaded (List converted to Map)");
          }
        }
      } catch (e) {
        debugPrint("Error loading permissions: $e");
      }
    }
  }

  bool _checkPermission(String moduleName, String childName, String permissionType) {
    if (rolePermission.isEmpty) return false;

    for (var module in rolePermission.values) {
      if (module is Map &&
          (module['name'].toString().toLowerCase() == moduleName.toLowerCase() ||
              module['identifier'].toString().toLowerCase() == moduleName.toLowerCase())) {
        var childData = module['childData'];
        if (childData is Map) {
          for (var child in childData.values) {
            if (child is Map &&
                (child['name'].toString().toLowerCase() == childName.toLowerCase() ||
                    child['identifier'].toString().toLowerCase() == childName.toLowerCase())) {
              var permission = child['permission'];
              if (permission is Map && (permission[permissionType] == true || permission[permissionType].toString() == "true")) {
                return true;
              }
            }
          }
        } else if (childData is List) {
          for (var child in childData) {
            if (child is Map &&
                (child['name'].toString().toLowerCase() == childName.toLowerCase() ||
                    child['identifier'].toString().toLowerCase() == childName.toLowerCase())) {
              var permission = child['permission'];
              if (permission is Map && (permission[permissionType] == true || permission[permissionType].toString() == "true")) {
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }

  // Inquiry
  bool get isInquiryViewAllowed => _checkPermission('Operations', 'Inquiry', 'view');
  bool get isInquiryCreateAllowed => _checkPermission('Operations', 'Inquiry', 'create');
  bool get isInquiryUpdateAllowed => _checkPermission('Operations', 'Inquiry', 'update');
  bool get isInquiryDeleteAllowed => _checkPermission('Operations', 'Inquiry', 'delete');

  // Lead (Opportunity)
  bool get isLeadViewAllowed => _checkPermission('Operations', 'Opportunity', 'view');
  bool get isLeadCreateAllowed => _checkPermission('Operations', 'Opportunity', 'create');
  bool get isLeadUpdateAllowed => _checkPermission('Operations', 'Opportunity', 'update');
  bool get isLeadDeleteAllowed => _checkPermission('Operations', 'Opportunity', 'delete');

  // Picking
  bool get isPickingViewAllowed => _checkPermission('Stock', 'Picking', 'view');

  // Packing
  bool get isPackingViewAllowed => _checkPermission('Stock', 'Packing', 'view');

  // Visits
  bool get isVisitViewAllowed => _checkPermission('Service', 'Visits', 'view');
  bool get isVisitCreateAllowed => _checkPermission('Service', 'Visits', 'create');
  bool get isVisitUpdateAllowed => _checkPermission('Service', 'Visits', 'update');
  bool get isVisitDeleteAllowed => _checkPermission('Service', 'Visits', 'delete');

  // Technician Expense
  bool get isTechnicianExpenseViewAllowed => _checkPermission('Service', 'Technician Expense', 'view');
}
