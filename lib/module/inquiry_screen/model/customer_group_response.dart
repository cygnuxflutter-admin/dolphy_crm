import 'dart:convert';

CustomerGroupResponseModel customerGroupResponseModelFromJson(String str) =>
    CustomerGroupResponseModel.fromJson(json.decode(str));

String customerGroupResponseModelToJson(CustomerGroupResponseModel data) =>
    json.encode(data.toJson());

class CustomerGroupResponseModel {
  final bool success;
  final String message;
  final List<CustomerGroupDatum> customerGroupData;
  final int status;
  final String error;
  final Pagination? pagination;

  CustomerGroupResponseModel({
    required this.success,
    required this.message,
    required this.customerGroupData,
    required this.status,
    required this.error,
    this.pagination,
  });

  factory CustomerGroupResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerGroupResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      customerGroupData: (json["data"] as List?)
          ?.map((e) => CustomerGroupDatum.fromJson(e))
          .toList() ??
          [],
      status: json["status"] ?? 0,
      error: json["error"] ?? "",
      pagination: json["pagination"] != null
          ? Pagination.fromJson(json["pagination"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": customerGroupData.map((x) => x.toJson()).toList(),
    "status": status,
    "error": error,
    "pagination": pagination?.toJson(),
  };
}

class CustomerGroupDatum {
  final String id;
  final String? tenantId;
  final String name;
  final String? code;
  final String? parentId;
  final int? level;
  final bool? isActive;
  final bool? isDeleted;
  final int? displayOrder;
  final String? tags;
  final String? remarks;
  final String? createdAt;
  final String? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final String? deletedAt;
  final String? deletedBy;
  final String? levelName;
  final Parent? parent;

  CustomerGroupDatum({
    required this.id,
    this.tenantId,
    required this.name,
    this.code,
    this.parentId,
    this.level,
    this.isActive,
    this.isDeleted,
    this.displayOrder,
    this.tags,
    this.remarks,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
    this.deletedBy,
    this.levelName,
    this.parent,
  });

  factory CustomerGroupDatum.fromJson(Map<String, dynamic> json) {
    return CustomerGroupDatum(
      id: json["id"] ?? "",
      tenantId: json["tenant_id"] ?? "",
      name: json["name"] ?? "",
      code: json["code"] ?? "",
      parentId: json["parent_id"] ?? "",
      level: json["level"] ?? 0,
      isActive: json["is_active"] ?? false,
      isDeleted: json["is_deleted"] ?? false,
      displayOrder: json["display_order"] ?? 0,
      tags: json["tags"] ?? "",
      remarks: json["remarks"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      createdBy: json["created_by"] ?? "",
      updatedBy: json["updated_by"] ?? "",
      deletedAt: json["deleted_at"] ?? "",
      deletedBy: json["deleted_by"] ?? "",
      levelName: json["level_name"] ?? "",
      parent:
      json["parent"] != null ? Parent.fromJson(json["parent"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "name": name,
    "code": code,
    "parent_id": parentId,
    "level": level,
    "is_active": isActive,
    "is_deleted": isDeleted,
    "display_order": displayOrder,
    "tags": tags,
    "remarks": remarks,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_at": deletedAt,
    "deleted_by": deletedBy,
    "level_name": levelName,
    "parent": parent?.toJson(),
  };
}

class Parent {
  final String id;
  final String name;
  final String code;
  final int level;
  final String levelName;

  Parent({
    required this.id,
    required this.name,
    required this.code,
    required this.level,
    required this.levelName,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      code: json["code"] ?? "",
      level: json["level"] ?? 0,
      levelName: json["level_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "level": level,
    "level_name": levelName,
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

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json["page"] ?? 0,
      limit: json["limit"] ?? 0,
      totalRecords: json["totalRecords"] ?? 0,
      totalPages: json["totalPages"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "totalRecords": totalRecords,
    "totalPages": totalPages,
  };
}
