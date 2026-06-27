// To parse this JSON data, do
//
//     final activityTpeRequestModel = activityTpeRequestModelFromJson(jsonString);

import 'dart:convert';

ActivityTpeResponseModel activityTpeRequestModelFromJson(String str) => ActivityTpeResponseModel.fromJson(json.decode(str));

String activityTpeRequestModelToJson(ActivityTpeResponseModel data) => json.encode(data.toJson());

class ActivityTpeResponseModel {
  final bool? success;
  final String? message;
  final List<ActivityData>? data;
  final int? status;
  final dynamic error;

  ActivityTpeResponseModel({
    this.success,
    this.message,
    this.data,
    this.status,
    this.error,
  });

  factory ActivityTpeResponseModel.fromJson(Map<String, dynamic> json) => ActivityTpeResponseModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<ActivityData>.from(json["data"]!.map((x) => ActivityData.fromJson(x))),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<ActivityData>.from(data!.map((x) => x.toJson())),
    "status": status,
    "error": error,
  };
}

class ActivityData {
  final String? type;
  final int? count;
  final List<Item>? items;

  ActivityData({
    this.type,
    this.count,
    this.items,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) => ActivityData(
    type: json["type"],
    count: json["count"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "count": count,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class Item {
  final String? id;
  final String? name;

  Item({
    this.id,
    this.name,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
