import 'dart:convert';

ContactPersonResponseModel contactPersonResponseModelFromJson(String str) => ContactPersonResponseModel.fromJson(json.decode(str));

String contactPersonResponseModelToJson(ContactPersonResponseModel data) => json.encode(data.toJson());

class ContactPersonResponseModel {
  final bool success;
  final String message;
  final List<ContactPersonDatum> data;
  final int status;
  final dynamic error;

  ContactPersonResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.status,
    this.error,
  });

  factory ContactPersonResponseModel.fromJson(Map<String, dynamic> json) => ContactPersonResponseModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] != null ? List<ContactPersonDatum>.from(json["data"].map((x) => ContactPersonDatum.fromJson(x))) : [],
        status: json["status"] ?? 0,
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "error": error,
      };
}

class ContactPersonDatum {
  final String id;
  final String firstName;
  final dynamic addressType;
  final String lastName;
  final String mobileNumber;
  final String mobileAlt;
  final String emailId;
  final String designation;
  final String address;
  final String countryId;
  final String stateId;
  final String cityId;
  final String pincodeId;
  final String notes;
  final bool isActive;
  final String customerId;
  final String tenantId;
  final String createdBy;
  final dynamic updatedBy;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;
  final dynamic deletedAt;
  final String fullName;

  ContactPersonDatum({
    required this.id,
    required this.firstName,
    this.addressType,
    required this.lastName,
    required this.mobileNumber,
    required this.mobileAlt,
    required this.emailId,
    required this.designation,
    required this.address,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    required this.pincodeId,
    required this.notes,
    required this.isActive,
    required this.customerId,
    required this.tenantId,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    this.deletedAt,
    required this.fullName,
  });

  factory ContactPersonDatum.fromJson(Map<String, dynamic> json) => ContactPersonDatum(
        id: json["id"] ?? "",
        firstName: json["first_name"] ?? "",
        addressType: json["address_type"],
        lastName: json["last_name"] ?? "",
        mobileNumber: json["mobile_number"] ?? "",
        mobileAlt: json["mobile_alt"] ?? "",
        emailId: json["email_id"] ?? "",
        designation: json["designation"] ?? "",
        address: json["address"] ?? "",
        countryId: json["country_id"] ?? "",
        stateId: json["state_id"] ?? "",
        cityId: json["city_id"] ?? "",
        pincodeId: json["pincode_id"] ?? "",
        notes: json["notes"] ?? "",
        isActive: json["is_active"] ?? false,
        customerId: json["customer_id"] ?? "",
        tenantId: json["tenant_id"] ?? "",
        createdBy: json["created_by"] ?? "",
        updatedBy: json["updated_by"],
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
        isDeleted: json["is_deleted"] ?? false,
        deletedAt: json["deleted_at"],
        fullName: json["full_name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "address_type": addressType,
        "last_name": lastName,
        "mobile_number": mobileNumber,
        "mobile_alt": mobileAlt,
        "email_id": emailId,
        "designation": designation,
        "address": address,
        "country_id": countryId,
        "state_id": stateId,
        "city_id": cityId,
        "pincode_id": pincodeId,
        "notes": notes,
        "is_active": isActive,
        "customer_id": customerId,
        "tenant_id": tenantId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_deleted": isDeleted,
        "deleted_at": deletedAt,
        "full_name": fullName,
      };
}
