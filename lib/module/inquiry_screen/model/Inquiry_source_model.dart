import 'dart:convert';

InquirySourceModel leadSourceModelFromJson(String str) => InquirySourceModel.fromJson(json.decode(str));

String leadSourceModelToJson(InquirySourceModel data) => json.encode(data.toJson());

class InquirySourceModel {
  final bool success;
  final String message;
  final List<InquirySourceDatum> inquirySourceDatum;
  final int status;
  final dynamic error;

  InquirySourceModel({required this.success, required this.message, required this.inquirySourceDatum, required this.status, required this.error});

  factory InquirySourceModel.fromJson(Map<String, dynamic> json) => InquirySourceModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    inquirySourceDatum: List<InquirySourceDatum>.from(json["data"].map((x) => InquirySourceDatum.fromJson(x))),
    status: json["status"] ?? 0,
    error: json["error"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "LeadSourceData": List<dynamic>.from(inquirySourceDatum.map((x) => x.toJson())),
    "status": status,
    "error": error,
  };
}

class InquirySourceDatum {
  final String type;
  final int count;
  final List<LeadSourceItem> leadSourceItems;

  InquirySourceDatum({required this.type, required this.count, required this.leadSourceItems});

  factory InquirySourceDatum.fromJson(Map<String, dynamic> json) => InquirySourceDatum(
    type: json["type"] ?? "",
    count: json["count"] ?? 0,
    leadSourceItems: List<LeadSourceItem>.from(json["items"].map((x) => LeadSourceItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {"type": type, "count": count, "items": List<dynamic>.from(leadSourceItems.map((x) => x.toJson()))};
}

class LeadSourceItem {
  final String id;
  final String name;

  LeadSourceItem({required this.id, required this.name});

  factory LeadSourceItem.fromJson(Map<String, dynamic> json) => LeadSourceItem(id: json["id"] ?? "", name: json["name"] ?? "");

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
