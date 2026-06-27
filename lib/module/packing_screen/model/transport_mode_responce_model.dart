// To parse this JSON data, do
//
//     final vendorResponce = vendorResponceFromJson(jsonString);

import 'dart:convert';

TransportModeResponseModel transportModeResponseModelFromJson(String str) => TransportModeResponseModel.fromJson(json.decode(str));

String transportModeResponseModelToJson(TransportModeResponseModel data) => json.encode(data.toJson());

class TransportModeResponseModel {
  final bool? success;
  final String? message;
  final List<Mode>? data;
  final int? status;
  final dynamic error;

  TransportModeResponseModel({this.success, this.message, this.data, this.status, this.error});

  factory TransportModeResponseModel.fromJson(Map<String, dynamic> json) => TransportModeResponseModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Mode>.from(json["data"]!.map((x) => Mode.fromJson(x))),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "mode": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status,
    "error": error,
  };
}

class Mode {
  final String? type;
  final int? count;
  final List<Item>? items;

  Mode({this.type, this.count, this.items});

  factory Mode.fromJson(Map<String, dynamic> json) => Mode(
    type: json["type"],
    count: json["count"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {"type": type, "count": count, "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson()))};
}

class Item {
  final String? id;
  final String? name;
  final String? codeType;
  final String? codeKey;

  Item({this.id, this.name, this.codeType, this.codeKey});

  factory Item.fromJson(Map<String, dynamic> json) =>
      Item(id: json["id"], name: json["name"], codeType: json["code_type"], codeKey: json["code_key"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "code_type": codeType, "code_key": codeKey};
}
