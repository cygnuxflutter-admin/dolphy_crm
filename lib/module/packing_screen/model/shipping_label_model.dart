// To parse this JSON data, do
//
//     final shippingLabelResponse = shippingLabelResponseFromJson(jsonString);

import 'dart:convert';

ShippingLabelResponse shippingLabelResponseFromJson(String str) => ShippingLabelResponse.fromJson(json.decode(str));

String shippingLabelResponseToJson(ShippingLabelResponse data) => json.encode(data.toJson());

class ShippingLabelResponse {
  final bool? success;
  final String? message;
  final ShippingLabelData? data;
  final int? status;
  final dynamic error;

  ShippingLabelResponse({this.success, this.message, this.data, this.status, this.error});

  factory ShippingLabelResponse.fromJson(Map<String, dynamic> json) => ShippingLabelResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ShippingLabelData.fromJson(json["data"]),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data?.toJson(), "status": status, "error": error};
}

class ShippingLabelData {
  final String? packingNo;
  final int? totalBoxes;
  final To? to;
  final From? from;

  ShippingLabelData({this.packingNo, this.totalBoxes, this.to, this.from});

  factory ShippingLabelData.fromJson(Map<String, dynamic> json) => ShippingLabelData(
    packingNo: json["packing_no"],
    totalBoxes: json["total_boxes"],
    to: json["to"] == null ? null : To.fromJson(json["to"]),
    from: json["from"] == null ? null : From.fromJson(json["from"]),
  );

  Map<String, dynamic> toJson() => {"packing_no": packingNo, "total_boxes": totalBoxes, "to": to?.toJson(), "from": from?.toJson()};
}

class From {
  final String? companyName;
  final List<String>? addressLines;
  final String? cityCode;
  final String? city;
  final String? mobile;

  From({this.companyName, this.addressLines, this.cityCode, this.city, this.mobile});

  factory From.fromJson(Map<String, dynamic> json) => From(
    companyName: json["companyName"],
    addressLines: json["addressLines"] == null ? [] : List<String>.from(json["addressLines"]!.map((x) => x)),
    cityCode: json["cityCode"],
    city: json["city"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "companyName": companyName,
    "addressLines": addressLines == null ? [] : List<dynamic>.from(addressLines!.map((x) => x)),
    "cityCode": cityCode,
    "city": city,
    "mobile": mobile,
  };
}

class To {
  final String? companyName;
  final String? address;
  final String? city;
  final String? pincode;
  final String? contact;
  final String? receiverName;
  final String? receiverMobile;
  final String? transporterName;

  To({this.companyName, this.address, this.city, this.pincode, this.contact, this.receiverName, this.receiverMobile, this.transporterName});

  factory To.fromJson(Map<String, dynamic> json) => To(
    companyName: json["companyName"],
    address: json["address"],
    city: json["city"],
    pincode: json["pincode"],
    contact: json["contact"],
    receiverName: json["receiverName"],
    receiverMobile: json["receiverMobile"],
    transporterName: json["transporterName"],
  );

  Map<String, dynamic> toJson() => {
    "companyName": companyName,
    "address": address,
    "city": city,
    "pincode": pincode,
    "contact": contact,
    "receiverName": receiverName,
    "receiverMobile": receiverMobile,
    "transporterName": transporterName,
  };
}
