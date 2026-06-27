import 'dart:convert';

City cityFromJson(String str) => City.fromJson(json.decode(str));

String cityToJson(City data) => json.encode(data.toJson());

class City {
  final bool success;
  final String message;
  final List<CityDatum> data;
  final int status;
  final String error;
  final Pagination pagination;


  City({
    required this.success,
    required this.message,
    required this.data,
    required this.status,
    required this.error,
    required this.pagination,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    success: json["success"]??false,
    message: json["message"]??"",
    data: List<CityDatum>.from(json["data"].map((x) => CityDatum.fromJson(x))),
    status: json["status"]??0,
    error: json["error"]??"",
    pagination: Pagination.fromJson(json["pagination"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
    "error": error,
    "pagination": pagination.toJson(),
  };
}

class CityDatum {
  final String id;
  final String name;
  final StateId stateId;
  final StateId countryId;

  CityDatum({
    required this.id,
    required this.name,
    required this.stateId,
    required this.countryId,
  });

  factory CityDatum.fromJson(Map<String, dynamic> json) => CityDatum(
    id: json["id"]??"",
    name: json["name"]??"",
    stateId: StateId.fromJson(json["state_id"] ?? {}),
    countryId: StateId.fromJson(json["country_id"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state_id": stateId.toJson(),
    "country_id": countryId.toJson(),
  };
}

class StateId {
  final String id;
  final String name;

  StateId({
    required this.id,
    required this.name,
  });

  factory StateId.fromJson(Map<String, dynamic> json) => StateId(
    id: json["id"]??"",
    name: json["name"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Pagination {
  final int page;
  final int limit;
  final int totalPages;
  final int totalRecords;

  Pagination({
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalRecords,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"]??0,
    limit: json["limit"]??0,
    totalPages: json["totalPages"]??0,
    totalRecords: json["totalRecords"]??0,
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
    "totalRecords": totalRecords,
  };
}