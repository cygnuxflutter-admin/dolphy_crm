import 'package:crm/module/inquiry_screen/model/Inquiry_source_model.dart';
import 'package:crm/module/inquiry_screen/model/city_model.dart';
import 'package:crm/module/inquiry_screen/model/pincode_model.dart';
import 'package:crm/module/inquiry_screen/model/state_model.dart';

import 'country_model.dart';

class AddAddressModel {
  final LeadSourceItem type;
  final String contactName;
  final String? companyName;
  final String? email;
  final String mobile1;
  final String? mobile2;
  final String street;
  final CityDatum cityId;
  final StateDatum stateId;
  final PinCodeDatum pincodeId;
  final CountryDatum countryId;
  final String? remarks;
  final bool isActive;
  final String? designation;

  AddAddressModel({
    required this.type,
    required this.contactName,
    this.companyName,
    this.designation,
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

  factory AddAddressModel.fromJson(Map<String, dynamic> json) => AddAddressModel(
    type: json["type"],
    contactName: json["contact_name"] ?? "",
    companyName: json["company_name"],
    designation: json["designation"],
    email: json["email"],
    mobile1: json["mobile_1"] ?? "",
    mobile2: json["mobile_2"],
    street: json["street"] ?? "",
    cityId: json["city_id"],
    stateId: json["state_id"],
    pincodeId: json["pincode_id"],
    countryId: json["country_id"],
    remarks: json["remarks"],
    isActive: json["is_active"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "contact_name": contactName,
    "company_name": companyName,
    "designation": designation,
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
