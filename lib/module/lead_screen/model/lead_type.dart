import 'dart:convert';

LeadType leadTypeFromJson(String str) => LeadType.fromJson(json.decode(str));

String leadTypeToJson(LeadType data) => json.encode(data.toJson());

class LeadType {
  final bool success;
  final String message;
  final List<LeadTypeDatum> data;
  final int status;
  final dynamic error;

  LeadType({required this.success, required this.message, required this.data, required this.status, required this.error});

  factory LeadType.fromJson(Map<String, dynamic> json) => LeadType(
    success: json["success"],
    message: json["message"],
    data: List<LeadTypeDatum>.from(json["data"].map((x) => LeadTypeDatum.fromJson(x))),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<LeadTypeDatum>.from(data.map((x) => x.toJson())),
    "status": status,
    "error": error,
  };
}

class LeadTypeDatum {
  final String type;
  final int count;
  final List<LeadItem> items;

  LeadTypeDatum({required this.type, required this.count, required this.items});

  factory LeadTypeDatum.fromJson(Map<String, dynamic> json) =>
      LeadTypeDatum(type: json["type"], count: json["count"], items: List<LeadItem>.from(json["items"].map((x) => LeadItem.fromJson(x))));

  Map<String, dynamic> toJson() => {"type": type, "count": count, "items": List<dynamic>.from(items.map((x) => x.toJson()))};
}

class LeadItem {
  final String id;
  final String name;
  final String? codeType;
  final String? codeKey;

  LeadItem({required this.id, required this.name, this.codeType, this.codeKey});

  factory LeadItem.fromJson(Map<String, dynamic> json) => LeadItem(
    id: json["id"],
    name: json["name"],
    codeType: json["code_type"],
    codeKey: json["code_key"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code_type": codeType,
    "code_key": codeKey,
  };
}
