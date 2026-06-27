import 'dart:convert';

PinCode pinCodeFromJson(String str) => PinCode.fromJson(json.decode(str));

String pinCodeToJson(PinCode data) => json.encode(data.toJson());

class PinCode {
  final bool success;
  final String message;
  final List<PinCodeDatum> data;
  final int status;
  final String error;
  final Pagination pagination;

  PinCode({required this.success, required this.message, required this.data, required this.status, required this.error, required this.pagination});

  factory PinCode.fromJson(Map<String, dynamic> json) => PinCode(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: json["data"] != null ? List<PinCodeDatum>.from(json["data"].map((x) => PinCodeDatum.fromJson(x))) : [],
    status: json["status"] ?? 0,
    error: json["error"] ?? "",
    pagination: Pagination.fromJson(json["pagination"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<PinCodeDatum>.from(data.map((x) => x.toJson())),
    "status": status,
    "error": error,
    "pagination": pagination.toJson(),
  };
}

class PinCodeDatum {
  final String id;
  final String pinCode;
  final Id cityId;
  final Id stateId;
  final Id countryId;

  PinCodeDatum({required this.id, required this.pinCode, required this.cityId, required this.stateId, required this.countryId});

  factory PinCodeDatum.fromJson(Map<String, dynamic> json) => PinCodeDatum(
    id: json["id"] ?? "",
    pinCode: json["pinCode"],
    cityId: Id.fromJson(json["city_id"] ?? {}),
    stateId: Id.fromJson(json["state_id"] ?? {}),
    countryId: Id.fromJson(json["country_id"] ?? {}),
  );

  Map<String, dynamic> toJson() => {"id": id, "pinCode": pinCode, "city_id": cityId.toJson(), "state_id": stateId.toJson(), "country_id": countryId.toJson()};
}

class Id {
  final String id;
  final String name;

  Id({required this.id, required this.name});

  factory Id.fromJson(Map<String, dynamic> json) => Id(id: json["id"] ?? "", name: json["name"] ?? "");

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class Pagination {
  final int page;
  final int limit;
  final int totalRecords;
  final int totalPages;

  Pagination({required this.page, required this.limit, required this.totalRecords, required this.totalPages});

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      Pagination(page: json["page"] ?? 0, limit: json["limit"] ?? 0, totalRecords: json["totalRecords"] ?? 0, totalPages: json["totalPages"] ?? 0);

  Map<String, dynamic> toJson() => {"page": page, "limit": limit, "totalRecords": totalRecords, "totalPages": totalPages};
}
