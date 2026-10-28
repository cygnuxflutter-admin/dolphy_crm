import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var notificationList = <NotificationData>[].obs;
  var unreadCount = 0.obs;
  var currentPage = 1;
  var totalPages = 1;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getNotifications();

    scrollController.addListener(() {
      if (scrollController.position.extentAfter < 200) {
        if (currentPage <= totalPages && !isLoadMore.value && !isLoading.value) {
          debugPrint("Loading more notifications... Page: $currentPage");
          getNotifications(isRefresh: false);
        }
      }
    });
  }

  Future<void> getNotifications({bool isRefresh = true}) async {
    if (isLoadMore.value || (isLoading.value && !isRefresh)) return;

    if (isRefresh) {
      currentPage = 1;
      isLoading.value = true;
    } else {
      isLoadMore.value = true;
    }

    try {
      String url = "${ApiEndPoint.notifications}?page=$currentPage&limit=20";
      debugPrint("Fetching notifications from: $url");

      Response response = await ApiHandler.getRequest(url);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.data);
        NotificationModel model = NotificationModel.fromJson(responseData);

        if (model.success == true) {
          if (isRefresh) {
            notificationList.clear();
            notificationList.value = model.data ?? [];
          } else {
            if (model.data != null && model.data!.isNotEmpty) {
              notificationList.addAll(model.data!);
            }
          }

          unreadCount.value = model.pagination?.unreadCount ?? 0;
          totalPages = model.pagination?.totalPages ?? 1;

          debugPrint("Current Page: $currentPage, Total Pages: $totalPages, Items: ${notificationList.length}");

          if (model.data != null && model.data!.isNotEmpty) {
            currentPage++;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    int index = notificationList.indexWhere((element) => element.id == notificationId);
    if (index != -1) {
      notificationList[index].isRead = true;
      notificationList.refresh();
      if (unreadCount.value > 0) unreadCount.value--;
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      final response = await ApiHandler.patchTokenRequest(url: ApiEndPoint.markReadNotifications, body: jsonEncode({"markAll": true}));

      if (response.statusCode == 200) {
        unreadCount.value = 0;
        for (var notification in notificationList) {
          notification.isRead = true;
        }
        notificationList.refresh();
      }
    } catch (e) {
      debugPrint("Error marking all notifications as read: $e");
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
