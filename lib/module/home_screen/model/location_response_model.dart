import 'dart:convert';

LocationResponse locationResponseFromJson(String str) => LocationResponse.fromJson(json.decode(str));

String locationResponseToJson(LocationResponse data) => json.encode(data.toJson());

class LocationResponse {
  final bool success;
  final String message;
  final List<LocationDatum> locationData;
  final int status;
  final String error;
  final Pagination? pagination;

  LocationResponse({required this.success, required this.message, required this.locationData, required this.status, required this.error, this.pagination});

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      locationData: (json["data"] as List?)?.map((e) => LocationDatum.fromJson(e)).toList() ?? [],
      status: json["status"] ?? 0,
      error: json["error"] ?? "",
      pagination: json["pagination"] != null ? Pagination.fromJson(json["pagination"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": locationData.map((x) => x.toJson()).toList(), "status": status, "error": error, "pagination": pagination?.toJson()};
}

class LocationDatum {
  final String id;
  final String locName;
  final String? locLevel;
  final String? reportLevel;
  final String? locCode;
  final String? reportLoc;
  final String? locAddress;
  final String? locState;
  final String? locCity;
  final String? locPincode;
  final String? locMobile;
  final String? locEmail;
  final String? zone;
  final String? locationStartDate;
  final String? locationEndDate;
  final bool? isComputerised;
  final String? tenantId;
  final String? createdBy;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final bool? isActive;
  final bool? isDeleted;
  final String? deletedAt;
  final String? locStateName;
  final String? locCityName;
  final String? zoneName;
  final String? locLevelName;
  final String? reportLevelName;
  final String? reportLocName;

  LocationDatum({
    required this.id,
    required this.locName,
     this.locLevel,
     this.reportLevel,
     this.locCode,
     this.reportLoc,
     this.locAddress,
     this.locState,
     this.locCity,
     this.locPincode,
     this.locMobile,
     this.locEmail,
     this.zone,
     this.locationStartDate,
     this.locationEndDate,
     this.isComputerised,
     this.tenantId,
     this.createdBy,
     this.updatedBy,
     this.createdAt,
     this.updatedAt,
     this.isActive,
     this.isDeleted,
     this.deletedAt,
     this.locStateName,
     this.locCityName,
     this.zoneName,
     this.locLevelName,
     this.reportLevelName,
     this.reportLocName,
  });

  factory LocationDatum.fromJson(Map<String, dynamic> json) {
    return LocationDatum(
      id: json["id"] ?? "",
      locLevel: json["loc_level"] ?? "",
      reportLevel: json["report_level"] ?? "",
      locCode: json["loc_code"] ?? "",
      locName: json["loc_name"] ?? "",
      reportLoc: json["report_loc"] ?? "",
      locAddress: json["loc_address"] ?? "",
      locState: json["loc_state"] ?? "",
      locCity: json["loc_city"] ?? "",
      locPincode: json["loc_pincode"] ?? "",
      locMobile: json["loc_mobile"] ?? "",
      locEmail: json["loc_email"] ?? "",
      zone: json["zone"] ?? "",
      locationStartDate: json["location_start_date"] ?? "",
      locationEndDate: json["location_end_date"] ?? "",
      isComputerised: json["is_computerised"] ?? false,
      tenantId: json["tenant_id"] ?? "",
      createdBy: json["created_by"] ?? "",
      updatedBy: json["updated_by"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      isActive: json["is_active"] ?? false,
      isDeleted: json["is_deleted"] ?? false,
      deletedAt: json["deleted_at"] ?? "",
      locStateName: json["loc_state_name"] ?? "",
      locCityName: json["loc_city_name"] ?? "",
      zoneName: json["zone_name"] ?? "",
      locLevelName: json["loc_level_name"] ?? "",
      reportLevelName: json["report_level_name"] ?? "",
      reportLocName: json["report_loc_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "loc_level": locLevel,
    "report_level": reportLevel,
    "loc_code": locCode,
    "loc_name": locName,
    "report_loc": reportLoc,
    "loc_address": locAddress,
    "loc_state": locState,
    "loc_city": locCity,
    "loc_pincode": locPincode,
    "loc_mobile": locMobile,
    "loc_email": locEmail,
    "zone": zone,
    "location_start_date": locationStartDate,
    "location_end_date": locationEndDate,
    "is_computerised": isComputerised,
    "tenant_id": tenantId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_active": isActive,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "loc_state_name": locStateName,
    "loc_city_name": locCityName,
    "zone_name": zoneName,
    "loc_level_name": locLevelName,
    "report_level_name": reportLevelName,
    "report_loc_name": reportLocName,
  };
}

class Pagination {
  final int page;
  final int limit;
  final int totalRecords;
  final int totalPages;

  Pagination({required this.page, required this.limit, required this.totalRecords, required this.totalPages});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(page: json["page"] ?? 1, limit: json["limit"] ?? 10, totalRecords: json["totalRecords"] ?? 0, totalPages: json["totalPages"] ?? 0);
  }

  Map<String, dynamic> toJson() => {"page": page, "limit": limit, "totalRecords": totalRecords, "totalPages": totalPages};
}
