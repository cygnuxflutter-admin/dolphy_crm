// To parse this JSON data, do
//
//     final leadListResponseModel = leadListResponseModelFromJson(jsonString);

import 'dart:convert';

LeadListResponseModel leadListResponseModelFromJson(String str) => LeadListResponseModel.fromJson(json.decode(str));

String leadListResponseModelToJson(LeadListResponseModel data) => json.encode(data.toJson());

class LeadListResponseModel {
  final bool? success;
  final String? message;
  final List<LeadListDatum>? data;
  final int? status;
  final dynamic error;
  final Pagination? pagination;
  final List<Status>? statuses;

  LeadListResponseModel({this.success, this.message, this.data, this.status, this.error, this.pagination, this.statuses});

  factory LeadListResponseModel.fromJson(Map<String, dynamic> json) => LeadListResponseModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<LeadListDatum>.from(json["data"]!.map((x) => LeadListDatum.fromJson(x))),
    status: json["status"],
    error: json["error"],
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    statuses: json["statuses"] == null ? [] : List<Status>.from(json["statuses"]!.map((x) => Status.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "LeadListDatum": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status,
    "error": error,
    "pagination": pagination?.toJson(),
    "statuses": statuses == null ? [] : List<dynamic>.from(statuses!.map((x) => x.toJson())),
  };
}

class LeadListDatum {
  final String? id;
  final String? tenantId;
  final String? customerCode;
  final String? contactName;
  final String? address;
  final String? stateId;
  final String? cityId;
  final String? pincodeId;
  final dynamic billToAddressId;
  final dynamic shipToAddressId;
  final String? countryId;
  final String? pan;
  final String? personName;
  final String? jobPosition;
  final bool? isMobile;
  final String? mobile1CountryCode;
  final String? mobile1;
  final String? mobile2CountryCode;
  final String? mobile2;
  final String? landline;
  final String? email;
  final String? website;
  final List<String>? tags;
  final String? companyName;
  final String? projectName;
  final String? remarks;
  final String? contactType;
  final String? sourceId;
  final dynamic customerType;
  final dynamic customerTypeCodeKey;
  final String? creditLimit;
  final int? creditDays;
  final String? temporaryCreditLimit;
  final String? outstandingAmount;
  final String? defaultPriceType;
  final dynamic defaultTaxType;
  final String? specialDiscountPercent;
  final String? overdueInterestPercent;
  final bool? isBlackListed;
  final bool? mobileService;
  final bool? emailService;
  final bool? allowTransactionBeyondCredit;
  final bool? isSez;
  final String? gstCategory;
  final dynamic gstCategoryId;
  final dynamic gstCategoryCodeKey;
  final dynamic aadhaarNumber;
  final dynamic gstNumber;
  final dynamic gstDate;
  final DateTime? inquiryDate;
  final dynamic cstNumber;
  final dynamic cstDate;
  final dynamic serviceTaxNumber;
  final bool? isOpportunityCreated;
  final String? createdBy;
  final dynamic updatedBy;
  final String? createdAt;
  final DateTime? updatedAt;
  final String? customerGroupId;
  final String? customerBrandId;
  final bool? isCustomer;
  final bool? isActive;
  final bool? isDeleted;
  final dynamic deletedAt;
  final String? companyId;
  final String? companyCode;
  final String? finYear;
  final String? locationId;
  final String? locationCode;
  final String? stateName;
  final String? cityName;
  final String? pincodeName;
  final String? sourceName;
  final String? createdByName;
  final String? countryName;
  final String? locationName;
  final String? customerGroupName;
  final String? customerBrandName;
  final List<String>? tagNames;
  final List<Addresses>? addresses;
  final Summary? summary;

  LeadListDatum({
    this.id,
    this.tenantId,
    this.customerCode,
    this.contactName,
    this.address,
    this.stateId,
    this.cityId,
    this.pincodeId,
    this.billToAddressId,
    this.shipToAddressId,
    this.countryId,
    this.pan,
    this.personName,
    this.jobPosition,
    this.isMobile,
    this.mobile1CountryCode,
    this.mobile1,
    this.mobile2CountryCode,
    this.mobile2,
    this.landline,
    this.email,
    this.website,
    this.tags,
    this.companyName,
    this.projectName,
    this.remarks,
    this.contactType,
    this.sourceId,
    this.customerType,
    this.customerTypeCodeKey,
    this.creditLimit,
    this.creditDays,
    this.temporaryCreditLimit,
    this.outstandingAmount,
    this.defaultPriceType,
    this.defaultTaxType,
    this.specialDiscountPercent,
    this.overdueInterestPercent,
    this.isBlackListed,
    this.mobileService,
    this.emailService,
    this.allowTransactionBeyondCredit,
    this.isSez,
    this.gstCategory,
    this.gstCategoryId,
    this.gstCategoryCodeKey,
    this.aadhaarNumber,
    this.gstNumber,
    this.gstDate,
    this.inquiryDate,
    this.cstNumber,
    this.cstDate,
    this.serviceTaxNumber,
    this.isOpportunityCreated,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.customerGroupId,
    this.customerBrandId,
    this.isCustomer,
    this.isActive,
    this.isDeleted,
    this.deletedAt,
    this.companyId,
    this.companyCode,
    this.finYear,
    this.locationId,
    this.locationCode,
    this.stateName,
    this.cityName,
    this.pincodeName,
    this.sourceName,
    this.createdByName,
    this.countryName,
    this.locationName,
    this.customerGroupName,
    this.customerBrandName,
    this.tagNames,
    this.addresses,
    this.summary,
  });

  factory LeadListDatum.fromJson(Map<String, dynamic> json) => LeadListDatum(
    id: json["id"],
    tenantId: json["tenant_id"],
    customerCode: json["customer_code"],
    contactName: json["contact_name"],
    address: json["address"],
    stateId: json["state_id"],
    cityId: json["city_id"],
    pincodeId: json["pincode_id"],
    billToAddressId: json["bill_to_address_id"],
    shipToAddressId: json["ship_to_address_id"],
    countryId: json["country_id"],
    pan: json["pan"],
    personName: json["person_name"],
    jobPosition: json["job_position"],
    isMobile: json["is_mobile"],
    mobile1CountryCode: json["mobile1_country_code"],
    mobile1: json["mobile1"],
    mobile2CountryCode: json["mobile2_country_code"],
    mobile2: json["mobile2"],
    landline: json["landline"],
    email: json["email"],
    website: json["website"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    companyName: json["company_name"],
    projectName: json["project_name"],
    remarks: json["remarks"],
    contactType: json["contact_type"],
    sourceId: json["source_id"],
    customerType: json["customer_type"],
    customerTypeCodeKey: json["customer_type_code_key"],
    creditLimit: json["credit_limit"],
    creditDays: json["credit_days"],
    temporaryCreditLimit: json["temporary_credit_limit"],
    outstandingAmount: json["outstanding_amount"],
    defaultPriceType: json["default_price_type"],
    defaultTaxType: json["default_tax_type"],
    specialDiscountPercent: json["special_discount_percent"],
    overdueInterestPercent: json["overdue_interest_percent"],
    isBlackListed: json["is_black_listed"],
    mobileService: json["mobile_service"],
    emailService: json["email_service"],
    allowTransactionBeyondCredit: json["allow_transaction_beyond_credit"],
    isSez: json["is_sez"],
    gstCategory: json["gst_category"],
    gstCategoryId: json["gst_category_id"],
    gstCategoryCodeKey: json["gst_category_code_key"],
    aadhaarNumber: json["aadhaar_number"],
    gstNumber: json["gst_number"],
    gstDate: json["gst_date"],
    inquiryDate: json["inquiry_date"] == null ? null : DateTime.parse(json["inquiry_date"]),
    cstNumber: json["cst_number"],
    cstDate: json["cst_date"],
    serviceTaxNumber: json["service_tax_number"],
    isOpportunityCreated: json["is_opportunity_created"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    customerGroupId: json["customer_group_id"],
    customerBrandId: json["customer_brand_id"],
    isCustomer: json["is_customer"],
    isActive: json["is_active"],
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    companyId: json["company_id"],
    companyCode: json["company_code"],
    finYear: json["fin_year"],
    locationId: json["location_id"],
    locationCode: json["location_code"],
    stateName: json["state_name"],
    cityName: json["city_name"],
    pincodeName: json["pincode_name"],
    sourceName: json["source_name"],
    createdByName: json["created_by_name"],
    countryName: json["country_name"],
    locationName: json["location_name"],
    customerGroupName: json["customer_group_name"],
    customerBrandName: json["customer_brand_name"],
    tagNames: json["tag_names"] == null ? [] : List<String>.from(json["tag_names"]!.map((x) => x)),
    addresses: json["addresses"] == null ? [] : List<Addresses>.from(json["addresses"]!.map((x) => Addresses.fromJson(x))),
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
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
    "bill_to_address_id": billToAddressId,
    "ship_to_address_id": shipToAddressId,
    "country_id": countryId,
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
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "company_name": companyName,
    "project_name": projectName,
    "remarks": remarks,
    "contact_type": contactType,
    "source_id": sourceId,
    "customer_type": customerType,
    "customer_type_code_key": customerTypeCodeKey,
    "credit_limit": creditLimit,
    "credit_days": creditDays,
    "temporary_credit_limit": temporaryCreditLimit,
    "outstanding_amount": outstandingAmount,
    "default_price_type": defaultPriceType,
    "default_tax_type": defaultTaxType,
    "special_discount_percent": specialDiscountPercent,
    "overdue_interest_percent": overdueInterestPercent,
    "is_black_listed": isBlackListed,
    "mobile_service": mobileService,
    "email_service": emailService,
    "allow_transaction_beyond_credit": allowTransactionBeyondCredit,
    "is_sez": isSez,
    "gst_category": gstCategory,
    "gst_category_id": gstCategoryId,
    "gst_category_code_key": gstCategoryCodeKey,
    "aadhaar_number": aadhaarNumber,
    "gst_number": gstNumber,
    "gst_date": gstDate,
    "inquiry_date":
        "${inquiryDate!.year.toString().padLeft(4, '0')}-${inquiryDate!.month.toString().padLeft(2, '0')}-${inquiryDate!.day.toString().padLeft(2, '0')}",
    "cst_number": cstNumber,
    "cst_date": cstDate,
    "service_tax_number": serviceTaxNumber,
    "is_opportunity_created": isOpportunityCreated,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt?.toIso8601String(),
    "customer_group_id": customerGroupId,
    "customer_brand_id": customerBrandId,
    "is_customer": isCustomer,
    "is_active": isActive,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "company_id": companyId,
    "company_code": companyCode,
    "fin_year": finYear,
    "location_id": locationId,
    "location_code": locationCode,
    "state_name": stateName,
    "city_name": cityName,
    "pincode_name": pincodeName,
    "source_name": sourceName,
    "created_by_name": createdByName,
    "country_name": countryName,
    "location_name": locationName,
    "customer_group_name": customerGroupName,
    "customer_brand_name": customerBrandName,
    "tag_names": tagNames == null ? [] : List<dynamic>.from(tagNames!.map((x) => x)),
    "addresses": addresses == null ? [] : List<dynamic>.from(addresses!.map((x) => x.toJson())),
    "summary": summary?.toJson(),
  };
}

class Addresses {
  final String? id;
  final String? type;
  final String? contactName;
  final dynamic companyName;
  final dynamic email;
  final dynamic mobile1CountryCode;
  final String? mobile1;
  final bool? mobile1IsMobile;
  final dynamic mobile2CountryCode;
  final dynamic mobile2;
  final String? street;
  final String? cityId;
  final String? stateId;
  final String? pincodeId;
  final String? countryId;
  final dynamic designation;
  final dynamic remarks;
  final dynamic source;
  final bool? isActive;
  final String? tenantId;
  final String? customerId;
  final String? createdBy;
  final dynamic updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;
  final dynamic deletedAt;
  final String? stateName;
  final String? cityName;
  final String? pincodeName;

  Addresses({
    this.id,
    this.type,
    this.contactName,
    this.companyName,
    this.email,
    this.mobile1CountryCode,
    this.mobile1,
    this.mobile1IsMobile,
    this.mobile2CountryCode,
    this.mobile2,
    this.street,
    this.cityId,
    this.stateId,
    this.pincodeId,
    this.countryId,
    this.designation,
    this.remarks,
    this.source,
    this.isActive,
    this.tenantId,
    this.customerId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deletedAt,
    this.stateName,
    this.cityName,
    this.pincodeName,
  });

  factory Addresses.fromJson(Map<String, dynamic> json) => Addresses(
    id: json["id"],
    type: json["type"],
    contactName: json["contact_name"],
    companyName: json["company_name"],
    email: json["email"],
    mobile1CountryCode: json["mobile1_country_code"],
    mobile1: json["mobile_1"],
    mobile1IsMobile: json["mobile1_is_mobile"],
    mobile2CountryCode: json["mobile2_country_code"],
    mobile2: json["mobile_2"],
    street: json["street"],
    cityId: json["city_id"],
    stateId: json["state_id"],
    pincodeId: json["pincode_id"],
    countryId: json["country_id"],
    designation: json["designation"],
    remarks: json["remarks"],
    source: json["source"],
    isActive: json["is_active"],
    tenantId: json["tenant_id"],
    customerId: json["customer_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    stateName: json["state_name"],
    cityName: json["city_name"],
    pincodeName: json["pincode_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "contact_name": contactName,
    "company_name": companyName,
    "email": email,
    "mobile1_country_code": mobile1CountryCode,
    "mobile_1": mobile1,
    "mobile1_is_mobile": mobile1IsMobile,
    "mobile2_country_code": mobile2CountryCode,
    "mobile_2": mobile2,
    "street": street,
    "city_id": cityId,
    "state_id": stateId,
    "pincode_id": pincodeId,
    "country_id": countryId,
    "designation": designation,
    "remarks": remarks,
    "source": source,
    "is_active": isActive,
    "tenant_id": tenantId,
    "customer_id": customerId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "state_name": stateName,
    "city_name": cityName,
    "pincode_name": pincodeName,
  };
}

class Summary {
  final int? totalOpportunities;

  Summary({this.totalOpportunities});

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(totalOpportunities: json["total_opportunities"]);

  Map<String, dynamic> toJson() => {"total_opportunities": totalOpportunities};
}

class Pagination {
  final int? page;
  final int? limit;
  final int? totalRecords;
  final int? totalPages;

  Pagination({this.page, this.limit, this.totalRecords, this.totalPages});

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      Pagination(page: json["page"], limit: json["limit"], totalRecords: json["totalRecords"], totalPages: json["totalPages"]);

  Map<String, dynamic> toJson() => {"page": page, "limit": limit, "totalRecords": totalRecords, "totalPages": totalPages};
}

class Status {
  final String? name;
  final String? displayName;
  final String? color;

  Status({this.name, this.displayName, this.color});

  factory Status.fromJson(Map<String, dynamic> json) => Status(name: json["name"], displayName: json["display_name"], color: json["color"]);

  Map<String, dynamic> toJson() => {"name": name, "display_name": displayName, "color": color};
}
