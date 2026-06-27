// To parse this JSON data, do
//
//     final getAssignPartnerResponseModel = getAssignPartnerResponseModelFromJson(jsonString);

import 'dart:convert';

GetAssignSalesPersonResponseModel getAssignPartnerResponseModelFromJson(String str) => GetAssignSalesPersonResponseModel.fromJson(json.decode(str));

String getAssignPartnerResponseModelToJson(GetAssignSalesPersonResponseModel data) => json.encode(data.toJson());

class GetAssignSalesPersonResponseModel {
  final bool? success;
  final String? message;
  final List<AssignSalesPerson>? data;
  final int? status;
  final String? error;
  final Pagination? pagination;

  GetAssignSalesPersonResponseModel({
    this.success,
    this.message,
    this.data,
    this.status,
    this.error,
    this.pagination,
  });

  factory GetAssignSalesPersonResponseModel.fromJson(Map<String, dynamic> json) => GetAssignSalesPersonResponseModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<AssignSalesPerson>.from(json["data"]!.map((x) => AssignSalesPerson.fromJson(x))),
    status: json["status"],
    error: json["error"],
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status,
    "error": error,
    "pagination": pagination?.toJson(),
  };
}

class AssignSalesPerson {
  final String? id;
  final String? userId;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? internalId;
  final String? userCode;
  final String? secretQuestion;
  final String? secretAnswer;
  final String? gender;
  final String? employeeStatus;
  final String? managerId;
  final String? reportingPersonId;
  final String? location;
  final String? employeeGroup;
  final String? company;
  final String? maxQuotationDiscount;
  final String? roleId;
  final String? subRoleId;
  final String? tenantId;
  final String? orgId;
  final String? dbName;
  final String? subDomain;
  final String? contact;
  final String? address;
  final String? city;
  final String? state;
  final String? pin;
  final String? createdBy;
  final bool? isActive;
  final bool? isBlocked;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? dateOfJoining;
  final DateTime? dateOfBirth;
  final bool? isDeleted;
  final String? deletedAt;
  final String? password;
  final bool? isVerified;

  AssignSalesPerson({
    this.id,
    this.userId,
    this.email,
    this.firstName,
    this.lastName,
    this.internalId,
    this.userCode,
    this.secretQuestion,
    this.secretAnswer,
    this.gender,
    this.dateOfBirth,
    this.employeeStatus,
    this.managerId,
    this.reportingPersonId,
    this.location,
    this.dateOfJoining,
    this.employeeGroup,
    this.company,
    this.maxQuotationDiscount,
    this.roleId,
    this.subRoleId,
    this.tenantId,
    this.orgId,
    this.dbName,
    this.subDomain,
    this.contact,
    this.address,
    this.city,
    this.state,
    this.pin,
    this.createdBy,
    this.isActive,
    this.isBlocked,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deletedAt,
    this.password,
    this.isVerified,
  });

  factory AssignSalesPerson.fromJson(Map<String, dynamic> json) => AssignSalesPerson(
    id: json["id"],
    userId: json["user_id"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    internalId: json["internal_id"],
    userCode: json["user_code"],
    secretQuestion: json["secret_question"],
    secretAnswer: json["secret_answer"],
    gender: json["gender"],
    dateOfBirth: json["date_of_birth"] == null ? null : DateTime.parse(json["date_of_birth"]),
    employeeStatus: json["employee_status"],
    managerId: json["manager_id"],
    reportingPersonId: json["reporting_person_id"],
    location: json["location"],
    dateOfJoining: json["date_of_joining"] == null ? null : DateTime.parse(json["date_of_joining"]),
    employeeGroup: json["employee_group"],
    company: json["company"],
    maxQuotationDiscount: json["max_quotation_discount"],
    roleId: json["role_id"],
    subRoleId: json["sub_role_id"],
    tenantId: json["tenant_id"],
    orgId: json["org_id"],
    dbName: json["db_name"],
    subDomain: json["sub_domain"],
    contact: json["contact"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    pin: json["pin"],
    createdBy: json["created_by"],
    isActive: json["is_active"],
    isBlocked: json["is_blocked"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    password: json["password"],
    isVerified: json["is_verified"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "internal_id": internalId,
    "user_code": userCode,
    "secret_question": secretQuestion,
    "secret_answer": secretAnswer,
    "gender": gender,
    "date_of_birth": "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    "employee_status": employeeStatus,
    "manager_id": managerId,
    "reporting_person_id": reportingPersonId,
    "location": location,
    "date_of_joining": "${dateOfJoining!.year.toString().padLeft(4, '0')}-${dateOfJoining!.month.toString().padLeft(2, '0')}-${dateOfJoining!.day.toString().padLeft(2, '0')}",
    "employee_group": employeeGroup,
    "company": company,
    "max_quotation_discount": maxQuotationDiscount,
    "role_id": roleId,
    "sub_role_id": subRoleId,
    "tenant_id": tenantId,
    "org_id": orgId,
    "db_name": dbName,
    "sub_domain": subDomain,
    "contact": contact,
    "address": address,
    "city": city,
    "state": state,
    "pin": pin,
    "created_by": createdBy,
    "is_active": isActive,
    "is_blocked": isBlocked,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "password": password,
    "is_verified": isVerified,
  };
}

class Pagination {
  final int? page;
  final int? limit;
  final int? totalPages;
  final int? totalRecords;

  Pagination({
    this.page,
    this.limit,
    this.totalPages,
    this.totalRecords,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
    totalRecords: json["totalRecords"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
    "totalRecords": totalRecords,
  };
}
