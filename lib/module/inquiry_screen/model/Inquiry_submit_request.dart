import 'dart:convert';

InquirySubmitRequestModel leadSubmitRequestModelFromJson(String str) => InquirySubmitRequestModel.fromJson(json.decode(str));

String leadSubmitRequestModelToJson(InquirySubmitRequestModel data) => json.encode(data.toJson());

class InquirySubmitRequestModel {
  final bool isCustomer;
  final String contactName;
  final String address;
  final String gstCategory;
  final String taxPayerType;
  final String stateId;
  final String cityId;
  final String countryId;
  final String pincodeId;
  final List<String> gstNumber;
  final String pan;
  final String personName;
  final String customerGroupId;
  final String customerBrandId;
  final String jobPosition;
  final String mobile1CountryCode;
  final String mobile2CountryCode;
  final String mobile1;
  final String mobile2;
  final String landline;
  final String email;
  final String website;
  final String defaultPriceType;
  final String leadDate;
  final String sourceId;
  final String remarks;
  final List<String> tags;
  final String companyName;
  final String projectName;
  final List<Address> addresses;
  final String locationId;
  final String companyId;
  final String finYear;

  InquirySubmitRequestModel({
    required this.isCustomer,
    required this.contactName,
    required this.address,
    required this.gstCategory,
    required this.taxPayerType,
    required this.stateId,
    required this.cityId,
    required this.countryId,
    required this.pincodeId,
    required this.gstNumber,
    required this.customerGroupId,
    required this.customerBrandId,
    required this.pan,
    required this.personName,
    required this.jobPosition,
    required this.mobile1CountryCode,
    required this.mobile2CountryCode,
    required this.mobile1,
    required this.mobile2,
    required this.landline,
    required this.email,
    required this.website,
    required this.defaultPriceType,
    required this.leadDate,
    required this.sourceId,
    required this.remarks,
    required this.tags,
    required this.companyName,
    required this.projectName,
    required this.addresses,
    required this.locationId,
    required this.companyId,
    required this.finYear,
  });

  factory InquirySubmitRequestModel.fromJson(Map<String, dynamic> json) => InquirySubmitRequestModel(
    isCustomer: json["is_customer"],
    contactName: json["contact_name"],
    address: json["address"],
    gstCategory: json["gst_category"],
    taxPayerType: json["tax_payer_type"],
    stateId: json["state_id"],
    cityId: json["city_id"],
    countryId: json["country_id"],
    pincodeId: json["pincode_id"],
    customerGroupId: json["customer_group_id"],
    customerBrandId: json["customer_brand_id"],
    gstNumber: List<String>.from(json["gst_number"].map((x) => x)),
    pan: json["pan"],
    personName: json["person_name"],
    jobPosition: json["job_position"],
    mobile1CountryCode: json["mobile1_country_code"],
    mobile2CountryCode: json["mobile2_country_code"],
    mobile1: json["mobile1"],
    mobile2: json["mobile2"],
    landline: json["landline"],
    email: json["email"],
    website: json["website"],
    defaultPriceType: json["default_price_type"],
    leadDate: json["lead_date"],
    sourceId: json["source_id"],
    remarks: json["remarks"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    companyName: json["company_name"],
    projectName: json["project_name"],
    addresses: List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
    locationId: json["location_id"],
    companyId: json["company_id"],
    finYear: json["fin_year"],
  );

  Map<String, dynamic> toJson() => {
    "is_customer": isCustomer,
    "contact_name": contactName,
    "address": address,
    "gst_category": gstCategory,
    "tax_payer_type": taxPayerType,
    "customer_group_id": customerGroupId,
    "customer_brand_id": customerBrandId,
    "state_id": stateId,
    "city_id": cityId,
    "country_id": countryId,
    "pincode_id": pincodeId,
    "gst_number": List<dynamic>.from(gstNumber.map((x) => x)),
    "pan": pan,
    "person_name": personName,
    "job_position": jobPosition,
    "mobile1_country_code": mobile1CountryCode,
    "mobile2_country_code": mobile2CountryCode,
    "mobile1": mobile1,
    "mobile2": mobile2,
    "landline": landline,
    "email": email,
    "website": website,
    "default_price_type": defaultPriceType,
    "lead_date": leadDate,
    "source_id": sourceId,
    "remarks": remarks,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "company_name": companyName,
    "project_name": projectName,
    "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
    "location_id": locationId,
    "company_id": companyId,
    "fin_year": finYear,
  };
}

class Address {
  final String type;
  final String contactName;
  final String? designation;
  final String? companyName;
  final String? email;
  final String mobile1;
  final String? mobile2;
  final String street;
  final String cityId;
  final String stateId;
  final String pincodeId;
  final String countryId;
  final String? remarks;
  final bool isActive;

  Address({
    required this.type,
    required this.contactName,
    this.designation,
    this.companyName,
    this.email,
    required this.mobile1,
    this.mobile2,
    required this.street,
    required this.cityId,
    required this.stateId,
    required this.pincodeId,
    required this.countryId,
    this.remarks,
    required this.isActive,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    type: json["type"],
    contactName: json["contact_name"] ?? "",
    designation: json["designation"],
    companyName: json["company_name"],
    email: json["email"],
    mobile1: json["mobile_1"] ?? "",
    mobile2: json["mobile_2"],
    street: json["street"] ?? "",
    cityId: json["city_id"] ?? "",
    stateId: json["state_id"] ?? "",
    pincodeId: json["pincode_id"] ?? "",
    countryId: json["country_id"] ?? "",
    remarks: json["remarks"],
    isActive: json["is_active"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "contact_name": contactName,
    "designation": designation,
    "company_name": companyName,
    "email": email,
    "mobile_1": mobile1,
    "mobile_2": mobile2,
    "street": street,
    "city_id": cityId,
    "state_id": stateId,
    "pincode_id": pincodeId,
    "country_id": countryId,
    "remarks": remarks,
    "is_active": isActive,
  };
}
