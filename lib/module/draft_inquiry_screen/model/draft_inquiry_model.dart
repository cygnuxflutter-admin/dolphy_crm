import 'dart:convert';

DraftInquiryListResponse draftInquiryListResponseFromJson(String str) =>
    DraftInquiryListResponse.fromJson(json.decode(str));

String draftInquiryListResponseToJson(DraftInquiryListResponse data) =>
    json.encode(data.toJson());

class DraftInquiryListResponse {
  final bool? success;
  final String? message;
  final int? status;
  final List<DraftInquiryItem>? data;
  final Pagination? pagination;

  DraftInquiryListResponse({
    this.success,
    this.message,
    this.status,
    this.data,
    this.pagination,
  });

  factory DraftInquiryListResponse.fromJson(Map<String, dynamic> json) =>
      DraftInquiryListResponse(
        success: json["success"] is bool
            ? json["success"]
            : (json["status"] == 200 || json["status"] == 201),
        message: json["message"]?.toString() ?? "",
        status: json["status"] is int ? json["status"] : 200,
        data: json["data"] == null
            ? []
            : (json["data"] is List
                ? List<DraftInquiryItem>.from(
                    json["data"].map((x) => DraftInquiryItem.fromJson(x)))
                : (json["data"] is Map<String, dynamic>
                    ? [DraftInquiryItem.fromJson(json["data"])]
                    : [])),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class DraftInquiryItem {
  final String? id;
  final String? contactName;
  final String? salesPersonId;
  final String? salesPersonName;
  final String? companyName;
  final String? projectName;
  final String? designation;
  final String? mobile1CountryCode;
  final String? mobile1;
  final String? mobile2CountryCode;
  final String? mobile2;
  final String? email;
  final String? website;
  final String? address;
  final String? inquiryDate;
  final String? remarks;
  final List<dynamic>? tags;
  final String? sourceId;
  final String? sourceName;
  final String? clientTypeId;
  final String? clientTypeName;
  final String? customerGroupId;
  final String? customerGroupName;
  final String? customerBrandId;
  final String? customerBrandName;
  final String? countryId;
  final String? countryName;
  final String? stateId;
  final String? stateName;
  final String? cityId;
  final String? cityName;
  final String? pincodeId;
  final String? pincode;
  final String? createdAt;
  final String? updatedAt;

  DraftInquiryItem({
    this.id,
    this.contactName,
    this.salesPersonId,
    this.salesPersonName,
    this.companyName,
    this.projectName,
    this.designation,
    this.mobile1CountryCode,
    this.mobile1,
    this.mobile2CountryCode,
    this.mobile2,
    this.email,
    this.website,
    this.address,
    this.inquiryDate,
    this.remarks,
    this.tags,
    this.sourceId,
    this.sourceName,
    this.clientTypeId,
    this.clientTypeName,
    this.customerGroupId,
    this.customerGroupName,
    this.customerBrandId,
    this.customerBrandName,
    this.countryId,
    this.countryName,
    this.stateId,
    this.stateName,
    this.cityId,
    this.cityName,
    this.pincodeId,
    this.pincode,
    this.createdAt,
    this.updatedAt,
  });

  factory DraftInquiryItem.fromJson(Map<String, dynamic> json) =>
      DraftInquiryItem(
        id: json["id"]?.toString() ?? json["_id"]?.toString() ?? "",
        contactName: (() {
          final cName = json["contact_name"]?.toString().trim();
          if (cName != null && cName.isNotEmpty && cName != "null") return cName;
          final pName = json["person_name"]?.toString().trim();
          if (pName != null && pName.isNotEmpty && pName != "null") return pName;
          return "";
        })(),
        salesPersonId: json["sales_person_id"]?.toString() ?? "",
        salesPersonName: json["sales_person_name"]?.toString() ??
            (json["sales_person"] is Map
                ? json["sales_person"]["name"]?.toString()
                : ""),
        companyName: json["company_name"]?.toString() ?? "",
        projectName: json["project_name"]?.toString() ?? "",
        designation: (() {
          final jobPos = json["job_position"]?.toString().trim();
          if (jobPos != null && jobPos.isNotEmpty && jobPos != "null") return jobPos;
          final desig = json["designation"]?.toString().trim();
          if (desig != null && desig.isNotEmpty && desig != "null") return desig;
          final jobPosCamel = json["jobPosition"]?.toString().trim();
          if (jobPosCamel != null && jobPosCamel.isNotEmpty && jobPosCamel != "null") return jobPosCamel;
          final jobTitle = json["job_title"]?.toString().trim();
          if (jobTitle != null && jobTitle.isNotEmpty && jobTitle != "null") return jobTitle;
          final desigName = json["designation_name"]?.toString().trim();
          if (desigName != null && desigName.isNotEmpty && desigName != "null") return desigName;
          return "";
        })(),
        mobile1CountryCode: json["mobile1_country_code"]?.toString() ?? "+91",
        mobile1: json["mobile1"]?.toString() ?? json["mobile_no"]?.toString() ?? "",
        mobile2CountryCode: json["mobile2_country_code"]?.toString() ?? "+91",
        mobile2: json["mobile2"]?.toString() ?? "",
        email: json["email"]?.toString() ?? "",
        website: json["website"]?.toString() ?? "",
        address: json["address"]?.toString() ?? "",
        inquiryDate: json["inquiry_date"]?.toString() ??
            json["lead_date"]?.toString() ??
            "",
        remarks: json["remarks"]?.toString() ?? "",
        tags: json["tags"] is List ? json["tags"] : [],
        sourceId: json["source_id"]?.toString() ?? "",
        sourceName: json["source_name"]?.toString() ?? "",
        clientTypeId: json["client_type_id"]?.toString() ?? "",
        clientTypeName: json["client_type_name"]?.toString() ?? "",
        customerGroupId: json["customer_group_id"]?.toString() ?? "",
        customerGroupName: json["customer_group_name"]?.toString() ?? "",
        customerBrandId: json["customer_brand_id"]?.toString() ?? "",
        customerBrandName: json["customer_brand_name"]?.toString() ?? "",
        countryId: json["country_id"]?.toString() ?? "",
        countryName: json["country_name"]?.toString() ?? "",
        stateId: json["state_id"]?.toString() ?? "",
        stateName: json["state_name"]?.toString() ?? "",
        cityId: json["city_id"]?.toString() ?? "",
        cityName: json["city_name"]?.toString() ?? "",
        pincodeId: json["pincode_id"]?.toString() ?? "",
        pincode: json["pincode"]?.toString() ?? "",
        createdAt: json["created_at"]?.toString() ?? "",
        updatedAt: json["updated_at"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contact_name": contactName,
        "person_name": contactName,
        "sales_person_id": salesPersonId,
        "company_name": companyName,
        "project_name": projectName,
        "designation": designation,
        "job_position": designation,
        "mobile1_country_code": mobile1CountryCode,
        "mobile1": mobile1,
        "mobile2_country_code": mobile2CountryCode,
        "mobile2": mobile2,
        "email": email,
        "website": website,
        "address": address,
        "inquiry_date": inquiryDate,
        "remarks": remarks,
        "tags": tags,
        "source_id": sourceId,
        "source_name": sourceName,
        "client_type_id": clientTypeId,
        "client_type_name": clientTypeName,
        "customer_group_id": customerGroupId,
        "customer_group_name": customerGroupName,
        "customer_brand_id": customerBrandId,
        "customer_brand_name": customerBrandName,
        "country_id": countryId,
        "country_name": countryName,
        "state_id": stateId,
        "state_name": stateName,
        "city_id": cityId,
        "city_name": cityName,
        "pincode_id": pincodeId,
        "pincode": pincode,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Pagination {
  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int limit;

  Pagination({
    required this.totalRecords,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalRecords: json["totalRecords"] is int
            ? json["totalRecords"]
            : int.tryParse(json["totalRecords"]?.toString() ?? "0") ?? 0,
        totalPages: json["totalPages"] is int
            ? json["totalPages"]
            : int.tryParse(json["totalPages"]?.toString() ?? "1") ?? 1,
        currentPage: json["currentPage"] is int
            ? json["currentPage"]
            : int.tryParse(json["currentPage"]?.toString() ?? "1") ?? 1,
        limit: json["limit"] is int
            ? json["limit"]
            : int.tryParse(json["limit"]?.toString() ?? "20") ?? 20,
      );

  Map<String, dynamic> toJson() => {
        "totalRecords": totalRecords,
        "totalPages": totalPages,
        "currentPage": currentPage,
        "limit": limit,
      };
}
