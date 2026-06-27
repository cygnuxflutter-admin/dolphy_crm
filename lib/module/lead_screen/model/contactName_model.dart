import 'dart:convert';

ContactNameModel contactNameModelFromJson(String str) => ContactNameModel.fromJson(json.decode(str));

String contactNameModelToJson(ContactNameModel data) => json.encode(data.toJson());

class ContactNameModel {
  final bool success;
  final String message;
  final List<ContactNameDatum> data;
  final int status;
  final dynamic error;
  final Pagination pagination;

  ContactNameModel({
    required this.success,
    required this.message,
    required this.data,
    required this.status,
    required this.error,
    required this.pagination,
  });

  factory ContactNameModel.fromJson(Map<String, dynamic> json) => ContactNameModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: json["data"] != null ? List<ContactNameDatum>.from(json["data"].map((x) => ContactNameDatum.fromJson(x))) : [],
    status: json["status"] ?? 0,
    error: json["error"],
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

class ContactNameDatum {
  final String id;
  final String tenantId;
  final String customerCode;
  final String contactName;
  final String address;
  final String stateId;
  final String cityId;
  final String pincodeId;
  final String pan;
  final String personName;
  final String jobPosition;
  final bool isMobile;
  final String mobile1CountryCode;
  final String mobile1;
  final String mobile2CountryCode;
  final String mobile2;
  final String landline;
  final String email;
  final String website;
  final List<String> tags;
  final String companyName;
  final String projectName;
  final String remarks;
  final String sourceId;
  final String creditLimit;
  final int creditDays;
  final String defaultPriceType;
  final String gstCategory;
  final String gstNumber;
  final String createdBy;
  final String createdAt;
  final String updatedAt;
  final String customerGroupId;
  final bool isCustomer;
  final bool isActive;
  final String stateName;
  final String cityName;
  final String pincodeName;
  final String sourceName;
  final String countryName;
  final List<Address> addresses;

  ContactNameDatum({
    required this.id,
    required this.tenantId,
    required this.customerCode,
    required this.contactName,
    required this.address,
    required this.stateId,
    required this.cityId,
    required this.pincodeId,
    required this.pan,
    required this.personName,
    required this.jobPosition,
    required this.isMobile,
    required this.mobile1CountryCode,
    required this.mobile1,
    required this.mobile2CountryCode,
    required this.mobile2,
    required this.landline,
    required this.email,
    required this.website,
    required this.tags,
    required this.companyName,
    required this.projectName,
    required this.remarks,
    required this.sourceId,
    required this.creditLimit,
    required this.creditDays,
    required this.defaultPriceType,
    required this.gstCategory,
    required this.gstNumber,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.customerGroupId,
    required this.isCustomer,
    required this.isActive,
    required this.stateName,
    required this.cityName,
    required this.pincodeName,
    required this.sourceName,
    required this.countryName,
    required this.addresses,
  });

  factory ContactNameDatum.fromJson(Map<String, dynamic> json) => ContactNameDatum(
    id: json["id"] ?? "",
    tenantId: json["tenant_id"] ?? "",
    customerCode: json["customer_code"] ?? "",
    contactName: json["contact_name"] ?? "",
    address: json["address"] ?? "",
    stateId: json["state_id"] ?? "",
    cityId: json["city_id"] ?? "",
    pincodeId: json["pincode_id"] ?? "",
    pan: json["pan"] ?? "",
    personName: json["person_name"] ?? "",
    jobPosition: json["job_position"] ?? "",
    isMobile: json["is_mobile"] ?? false,
    mobile1CountryCode: json["mobile1_country_code"] ?? "",
    mobile1: json["mobile1"] ?? "",
    mobile2CountryCode: json["mobile2_country_code"] ?? "",
    mobile2: json["mobile2"] ?? "",
    landline: json["landline"] ?? "",
    email: json["email"] ?? "",
    website: json["website"] ?? "",
    tags: json["tags"] != null ? List<String>.from(json["tags"]) : [],
    companyName: json["company_name"] ?? "",
    projectName: json["project_name"] ?? "",
    remarks: json["remarks"] ?? "",
    sourceId: json["source_id"] ?? "",
    creditLimit: json["credit_limit"]?.toString() ?? "0.00",
    creditDays: json["credit_days"] ?? 0,
    defaultPriceType: json["default_price_type"] ?? "",
    gstCategory: json["gst_category"] ?? "",
    gstNumber: json["gst_number"] ?? "",
    createdBy: json["created_by"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    customerGroupId: json["customer_group_id"] ?? "",
    isCustomer: json["is_customer"] ?? false,
    isActive: json["is_active"] ?? false,
    stateName: json["state_name"] ?? "",
    cityName: json["city_name"] ?? "",
    pincodeName: json["pincode_name"] ?? "",
    sourceName: json["source_name"] ?? "",
    countryName: json["country_name"] ?? "",
    addresses: json["addresses"] != null ? List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "customer_code": customerCode,
    "contact_name": contactName,
    "address": address,
    "state_id": stateId,
    "city_id": cityId,
    "pincode_id": pincodeId,
    "pan": pan,
    "person_name": personName,
    "job_position": jobPosition,
    "is_mobile": isMobile,
    "mobile1_country_code": mobile1CountryCode,
    "mobile1": mobile1,
    "mobile2_country_code": mobile2CountryCode,
    "mobile2": mobile2,
    "landline": landline,
    "email": email,
    "website": website,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "company_name": companyName,
    "project_name": projectName,
    "remarks": remarks,
    "source_id": sourceId,
    "credit_limit": creditLimit,
    "credit_days": creditDays,
    "default_price_type": defaultPriceType,
    "gst_category": gstCategory,
    "gst_number": gstNumber,
    "created_by": createdBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "customer_group_id": customerGroupId,
    "is_customer": isCustomer,
    "is_active": isActive,
    "state_name": stateName,
    "city_name": cityName,
    "pincode_name": pincodeName,
    "source_name": sourceName,
    "country_name": countryName,
    "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
  };
}

class Address {
  final String id;
  final String type;
  final String contactName;
  final String companyName;
  final String email;
  final String mobile1;
  final String mobile2;
  final String street;
  final String cityId;
  final String stateId;
  final String pincodeId;
  final String countryName;
  final String remarks;
  final bool isActive;
  final String stateName;
  final String cityName;
  final String pincodeName;

  Address({
    required this.id,
    required this.type,
    required this.contactName,
    required this.companyName,
    required this.email,
    required this.mobile1,
    required this.mobile2,
    required this.street,
    required this.cityId,
    required this.stateId,
    required this.pincodeId,
    required this.countryName,
    required this.remarks,
    required this.isActive,
    required this.stateName,
    required this.cityName,
    required this.pincodeName,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"] ?? "",
    type: json["type"] ?? "",
    contactName: json["contact_name"] ?? "",
    companyName: json["company_name"] ?? "",
    email: json["email"] ?? "",
    mobile1: json["mobile_1"] ?? json["mobile1"] ?? "",
    mobile2: json["mobile_2"] ?? json["mobile2"] ?? "",
    street: json["street"] ?? "",
    cityId: json["city_id"] ?? "",
    stateId: json["state_id"] ?? "",
    pincodeId: json["pincode_id"] ?? "",
    countryName: json["country_name"] ?? "",
    remarks: json["remarks"] ?? "",
    isActive: json["is_active"] ?? false,
    stateName: json["state_name"] ?? "",
    cityName: json["city_name"] ?? "",
    pincodeName: json["pincode_name"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "contact_name": contactName,
    "company_name": companyName,
    "email": email,
    "mobile_1": mobile1,
    "mobile_2": mobile2,
    "street": street,
    "city_id": cityId,
    "state_id": stateId,
    "pincode_id": pincodeId,
    "country_name": countryName,
    "remarks": remarks,
    "is_active": isActive,
    "state_name": stateName,
    "city_name": cityName,
    "pincode_name": pincodeName,
  };
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
