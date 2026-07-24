import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../../../config/app_url.dart';
import '../../../utils/api_handler.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  var notificationList = <NotificationData>[].obs;
  var unreadCount = 0.obs;
  var currentPage = 1;
  var totalPages = 1;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  Future<void> getNotifications({bool isRefresh = true}) async {
    if (isRefresh) {
      currentPage = 1;
      notificationList.clear();
    }

    if (currentPage > totalPages && !isRefresh) return;

    try {
      isLoading.value = true;
      String url = "${ApiEndPoint.notifications}?page=$currentPage&limit=20";
      Response response = await ApiHandler.getRequest(url);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.data);
        NotificationModel model = NotificationModel.fromJson(responseData);
        if (model.success == true) {
          if (isRefresh) {
            notificationList.value = model.data ?? [];
          } else {
            notificationList.addAll(model.data ?? []);
          }
          unreadCount.value = model.pagination?.unreadCount ?? 0;
          totalPages = model.pagination?.totalPages ?? 1;
          currentPage++;
        }
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
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
}
