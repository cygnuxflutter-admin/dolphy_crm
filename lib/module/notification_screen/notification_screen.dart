import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/app_colors.dart';
import 'controller/notification_controller.dart';
import 'model/notification_model.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.indigo600Main,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.white),
        ),
        actions: [
          Obx(() {
            if (controller.unreadCount.value > 0) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.red500,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${controller.unreadCount.value} New",
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notificationList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notificationList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.gray400),
                const SizedBox(height: 16),
                const Text(
                  "No notifications yet",
                  style: TextStyle(color: AppColors.gray500, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.getNotifications(isRefresh: true),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.notificationList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = controller.notificationList[index];
              return _buildNotificationItem(notification);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationItem(NotificationData notification) {
    final bool isRead = notification.isRead ?? false;

    return InkWell(
      onTap: () {
        if (!isRead) {
          controller.markAsRead(notification.id ?? "");
        }
        // Handle navigation based on type if needed
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : AppColors.indigo50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRead ? AppColors.gray200 : AppColors.indigo100,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(notification.type),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconData(notification.type),
                color: _getIconColor(notification.type),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title ?? "Notification",
                          style: TextStyle(
                            fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.indigo600Main,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message ?? "",
                    style: TextStyle(
                      fontSize: 13,
                      color: isRead ? AppColors.textSecondary : AppColors.gray800,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.createdAt != null
                        ? DateFormat('dd MMM yyyy, hh:mm a').format(notification.createdAt!.toLocal())
                        : "",
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String? type) {
    switch (type?.toUpperCase()) {
      case 'OUT_OF_STOCK':
        return Icons.inventory_2_outlined;
      case 'BROADCAST':
        return Icons.campaign_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getIconColor(String? type) {
    switch (type?.toUpperCase()) {
      case 'OUT_OF_STOCK':
        return AppColors.red500;
      case 'BROADCAST':
        return AppColors.indigo600Main;
      default:
        return AppColors.gray500;
    }
  }

  Color _getIconBackgroundColor(String? type) {
    switch (type?.toUpperCase()) {
      case 'OUT_OF_STOCK':
        return AppColors.red100;
      case 'BROADCAST':
        return AppColors.indigo100;
      default:
        return AppColors.gray100;
    }
  }
}
