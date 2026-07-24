class NotificationModel {
  bool? success;
  String? message;
  List<NotificationData>? data;
  int? status;
  String? error;
  Pagination? pagination;

  NotificationModel({this.success, this.message, this.data, this.status, this.error, this.pagination});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
    status = json['status'];
    error = json['error'];
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    data['error'] = error;
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class NotificationData {
  String? id;
  String? tenantId;
  String? userId;
  String? title;
  String? message;
  String? type;
  Map<String, dynamic>? data;
  bool? isRead;
  DateTime? readAt;
  DateTime? createdAt;

  NotificationData({this.id, this.tenantId, this.userId, this.title, this.message, this.type, this.data, this.isRead, this.readAt, this.createdAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantId = json['tenant_id'];
    userId = json['user_id'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
    data = json['data'];
    isRead = json['is_read'];
    readAt = json['read_at'] != null ? DateTime.parse(json['read_at']) : null;
    createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tenant_id'] = tenantId;
    data['user_id'] = userId;
    data['title'] = title;
    data['message'] = message;
    data['type'] = type;
    data['data'] = this.data;
    data['is_read'] = isRead;
    data['read_at'] = readAt?.toIso8601String();
    data['created_at'] = createdAt?.toIso8601String();
    return data;
  }
}

class Pagination {
  int? page;
  int? limit;
  int? totalRecords;
  int? totalPages;
  int? unreadCount;

  Pagination({this.page, this.limit, this.totalRecords, this.totalPages, this.unreadCount});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    totalRecords = json['total_records'] ?? json['totalRecords'];
    totalPages = json['total_pages'] ?? json['totalPages'];
    unreadCount = json['unread_count'] ?? json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['totalRecords'] = totalRecords;
    data['totalPages'] = totalPages;
    data['unreadCount'] = unreadCount;
    return data;
  }
}
