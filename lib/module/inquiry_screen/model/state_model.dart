import 'dart:convert';

States stateFromJson(String str) => States.fromJson(json.decode(str));

String stateToJson(States data) => json.encode(data.toJson());

class States {
  final bool success;
  final String message;
  final List<StateDatum> data;
  final int status;
  final dynamic error;

  States({
    required this.success,
    required this.message,
    required this.data,
    required this.status,
    required this.error,
  });

  factory States.fromJson(Map<String, dynamic> json) => States(
    success: json["success"],
    message: json["message"],
    data: List<StateDatum>.from(json["data"].map((x) => StateDatum.fromJson(x))),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
    "error": error,
  };
}

class StateDatum {
  final String id;
  final String name;
  final CountryId countryId;

  StateDatum({
    required this.id,
    required this.name,
    required this.countryId,
  });

  factory StateDatum.fromJson(Map<String, dynamic> json) => StateDatum(
    id: json["id"],
    name: json["name"],
    countryId: CountryId.fromJson(json["country_id"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country_id": countryId.toJson(),
  };
}

class CountryId {
  final String id;
  final String name;

  CountryId({
    required this.id,
    required this.name,
  });

  factory CountryId.fromJson(Map<String, dynamic> json) => CountryId(
    id: json["id"]??"",
    name: json["name"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}