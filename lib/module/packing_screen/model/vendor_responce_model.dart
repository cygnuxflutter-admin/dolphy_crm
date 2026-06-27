// To parse this JSON data, do
//
//     final vendorResponce = vendorResponceFromJson(jsonString);

import 'dart:convert';

VendorResponce vendorResponceFromJson(String str) => VendorResponce.fromJson(json.decode(str));

String vendorResponceToJson(VendorResponce data) => json.encode(data.toJson());

class VendorResponce {
  final bool? success;
  final String? message;
  final List<Vendor>? data;
  final int? status;
  final dynamic error;

  VendorResponce({this.success, this.message, this.data, this.status, this.error});

  factory VendorResponce.fromJson(Map<String, dynamic> json) => VendorResponce(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Vendor>.from(json["data"]!.map((x) => Vendor.fromJson(x))),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "vendor": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status,
    "error": error,
  };
}

class Vendor {
  final String? id;
  final String? vendorType;
  final String? name;
  final MobileNo? mobileNo;
  final String? contactPersonName;
  final List<String>? gstNo;
  final String? panNo;
  final String? tanNo;
  final VendorTypeName? vendorTypeName;

  Vendor({this.id, this.vendorType, this.name, this.mobileNo, this.contactPersonName, this.gstNo, this.panNo, this.tanNo, this.vendorTypeName});

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
    id: json["id"],
    vendorType: json["vendor_type"],
    name: json["name"],
    mobileNo: json["mobile_no"] != null ? mobileNoValues.map[json["mobile_no"]] : null,
    contactPersonName: json["contact_person_name"],
    gstNo: json["gst_no"] == null ? [] : List<String>.from(json["gst_no"]!.map((x) => x)),
    panNo: json["pan_no"],
    tanNo: json["tan_no"],
    vendorTypeName: json["vendor_type_name"] != null ? vendorTypeNameValues.map[json["vendor_type_name"]] : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vendor_type": vendorType,
    "name": name,
    "mobile_no": mobileNoValues.reverse[mobileNo],
    "contact_person_name": contactPersonName,
    "gst_no": gstNo == null ? [] : List<dynamic>.from(gstNo!.map((x) => x)),
    "pan_no": panNo,
    "tan_no": tanNo,
    "vendor_type_name": vendorTypeNameValues.reverse[vendorTypeName],
  };
}

enum MobileNo { EMPTY, THE_9424388888 }

final mobileNoValues = EnumValues({"": MobileNo.EMPTY, "9424388888": MobileNo.THE_9424388888});

enum VendorTypeName { TRANSPORTER }

final vendorTypeNameValues = EnumValues({"Transporter": VendorTypeName.TRANSPORTER});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
