import 'dart:convert';

CompanyResponse companyResponseFromJson(String str) => CompanyResponse.fromJson(json.decode(str));

String companyResponseToJson(CompanyResponse data) => json.encode(data.toJson());

class CompanyResponse {
  final bool success;
  final String message;
  final List<CompanyDatum> companyData;
  final int status;
  final String error;
  final Pagination? pagination;

  CompanyResponse({required this.success, required this.message, required this.companyData, required this.status, required this.error, this.pagination});

  factory CompanyResponse.fromJson(Map<String, dynamic> json) {
    return CompanyResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      companyData: (json["data"] as List?)?.map((e) => CompanyDatum.fromJson(e)).toList() ?? [],
      status: json["status"] ?? 0,
      error: json["error"] ?? "",
      pagination: json["pagination"] != null ? Pagination.fromJson(json["pagination"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": companyData.map((x) => x.toJson()).toList(), "status": status, "error": error, "pagination": pagination?.toJson()};
}

class CompanyDatum {
  final String id;
  final String? tenantId;
  final String? companyCode;
  final String companyName;
  final String? legalName;
  final String? gstNo;
  final String? panNo;
  final String? address;
  final String? countryId;
  final String? stateId;
  final String? cityId;
  final String? pincode;
  final String? contactPerson;
  final String? contactNo;
  final String? email;
  final bool? isActive;
  final String? createdBy;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final bool? isDeleted;
  final String? deletedBy;
  final String? deletedAt;

  CompanyDatum({
    required this.id,
     this.tenantId,
     this.companyCode,
    required this.companyName,
     this.legalName,
     this.gstNo,
     this.panNo,
     this.address,
     this.countryId,
     this.stateId,
     this.cityId,
     this.pincode,
     this.contactPerson,
     this.contactNo,
     this.email,
     this.isActive,
     this.createdBy,
     this.updatedBy,
     this.createdAt,
     this.updatedAt,
     this.isDeleted,
     this.deletedBy,
     this.deletedAt,
  });

  factory CompanyDatum.fromJson(Map<String, dynamic> json) {
    return CompanyDatum(
      id: json["id"] ?? "",
      tenantId: json["tenant_id"] ?? "",
      companyCode: json["company_code"] ?? "",
      companyName: json["company_name"] ?? "",
      legalName: json["legal_name"] ?? "",
      gstNo: json["gst_no"] ?? "",
      panNo: json["pan_no"] ?? "",
      address: json["address"] ?? "",
      countryId: json["country_id"] ?? "",
      stateId: json["state_id"] ?? "",
      cityId: json["city_id"] ?? "",
      pincode: json["pincode"] ?? "",
      contactPerson: json["contact_person"] ?? "",
      contactNo: json["contact_no"] ?? "",
      email: json["email"] ?? "",
      isActive: json["is_active"] ?? false,
      createdBy: json["created_by"] ?? "",
      updatedBy: json["updated_by"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      isDeleted: json["is_deleted"] ?? false,
      deletedBy: json["deleted_by"] ?? "",
      deletedAt: json["deleted_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "company_code": companyCode,
    "company_name": companyName,
    "legal_name": legalName,
    "gst_no": gstNo,
    "pan_no": panNo,
    "address": address,
    "country_id": countryId,
    "state_id": stateId,
    "city_id": cityId,
    "pincode": pincode,
    "contact_person": contactPerson,
    "contact_no": contactNo,
    "email": email,
    "is_active": isActive,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_deleted": isDeleted,
    "deleted_by": deletedBy,
    "deleted_at": deletedAt,
  };
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Pagination({required this.total, required this.page, required this.limit, required this.totalPages});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(total: json["total"] ?? 1, page: json["page"] ?? 20, limit: json["limit"] ?? 0, totalPages: json["totalPages"] ?? 0);
  }

  Map<String, dynamic> toJson() => {"total": total, "page": page, "limit": limit, "totalPages": totalPages};
}
