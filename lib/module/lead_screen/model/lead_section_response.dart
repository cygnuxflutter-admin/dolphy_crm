import 'dart:convert';

LeadSectionResponse leadSectionResponseFromJson(String str) => LeadSectionResponse.fromJson(json.decode(str));

String leadSectionResponseToJson(LeadSectionResponse data) => json.encode(data.toJson());

class LeadSectionResponse {
  final bool success;
  final String message;
  final List<LeadSectionDatum> opportunitySectionData;
  final int status;
  final String error;
  final Pagination pagination;

  LeadSectionResponse({
    required this.success,
    required this.message,
    required this.opportunitySectionData,
    required this.status,
    required this.error,
    required this.pagination,
  });

  factory LeadSectionResponse.fromJson(Map<String, dynamic> json) => LeadSectionResponse(
    success: json["success"] ?? false,
    message: json["message"] ?? '',
    opportunitySectionData: (json["data"] as List?)
        ?.map((x) => LeadSectionDatum.fromJson(x))
        .toList() ??
        [],
    status: json["status"] ?? 0,
    error: json["error"] ?? '',
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "opportunitySectionData": List<dynamic>.from(opportunitySectionData.map((x) => x.toJson())),
    "status": status,
    "error": error,
    "pagination": pagination.toJson(),
  };
}

class LeadSectionDatum {
  final String id;
  final String uniqueCode;
  final String name;
  final String description;
  final String type;
  final int position;
  final bool isActive;
  final String tenantId;
  final String createdBy;
  final String updatedBy;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;
  final String deletedAt;

  LeadSectionDatum({
    required this.id,
    required this.uniqueCode,
    required this.name,
    required this.description,
    required this.type,
    required this.position,
    required this.isActive,
    required this.tenantId,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.deletedAt,
  });

  factory LeadSectionDatum.fromJson(Map<String, dynamic> json) => LeadSectionDatum(
    id: json["id"] ?? '',
    uniqueCode: json["unique_code"] ?? '',
    name: json["name"] ?? '',
    description: json["description"] ?? '',
    type: json["type"] ?? '',
    position: json["position"] ?? 0,
    isActive: json["is_active"] ?? false,
    tenantId: json["tenant_id"] ?? '',
    createdBy: json["created_by"] ?? '',
    updatedBy: json["updated_by"] ?? '',
    createdAt: json["created_at"] ?? '',
    updatedAt: json["updated_at"] ?? '',
    isDeleted: json["is_deleted"] ?? false,
    deletedAt: json["deleted_at"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_code": uniqueCode,
    "name": name,
    "description": description,
    "type": type,
    "position": position,
    "is_active": isActive,
    "tenant_id": tenantId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
  };
}

class Pagination {
  final int page;
  final int limit;
  final int totalRecords;
  final int totalPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.totalRecords,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"] ?? 1,
    limit: json["limit"] ?? 10,
    totalRecords: json["totalRecords"] ?? 0,
    totalPages: json["totalPages"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "totalRecords": totalRecords,
    "totalPages": totalPages,
  };
}
