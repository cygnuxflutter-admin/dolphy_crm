import 'dart:convert';

CountryResponseModel countryResponseModelFromJson(String str) => CountryResponseModel.fromJson(json.decode(str));

String countryResponseModelToJson(CountryResponseModel data) => json.encode(data.toJson());

class CountryResponseModel {
  final bool success;
  final String message;
  final List<CountryDatum> countryData;
  final int status;
  final dynamic error;

  CountryResponseModel({
    required this.success,
    required this.message,
    required this.countryData,
    required this.status,
    required this.error,
  });

  factory CountryResponseModel.fromJson(Map<String, dynamic> json) => CountryResponseModel(
    success: json["success"]??false,
    message: json["message"]??"",
    countryData: List<CountryDatum>.from(json["data"].map((x) => CountryDatum.fromJson(x))),
    status: json["status"]??0,
    error: json["error"]??'',
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "CountryData": List<dynamic>.from(countryData.map((x) => x.toJson())),
    "status": status,
    "error": error,
  };
}

class CountryDatum {
  final String id;
  final String name;

  CountryDatum({
    required this.id,
    required this.name,
  });

  factory CountryDatum.fromJson(Map<String, dynamic> json) => CountryDatum(
    id: json["id"]??"",
    name: json["name"]??"",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
