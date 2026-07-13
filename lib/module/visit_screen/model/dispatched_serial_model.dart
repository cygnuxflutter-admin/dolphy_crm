import 'dart:convert';

DispatchedSerialModel dispatchedSerialModelFromJson(String str) => DispatchedSerialModel.fromJson(json.decode(str));

String dispatchedSerialModelToJson(DispatchedSerialModel data) => json.encode(data.toJson());

class DispatchedSerialModel {
  bool? success;
  String? message;
  List<DispatchedSerialData>? data;
  int? status;
  dynamic error;

  DispatchedSerialModel({this.success, this.message, this.data, this.status, this.error});

  factory DispatchedSerialModel.fromJson(Map<String, dynamic> json) => DispatchedSerialModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<DispatchedSerialData>.from(json["data"].map((x) => DispatchedSerialData.fromJson(x))),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status,
    "error": error,
  };
}

class DispatchedSerialData {
  String? serialId;
  String? serialNumber;
  String? dispatchNumber;

  DispatchedSerialData({this.serialId, this.serialNumber, this.dispatchNumber});

  factory DispatchedSerialData.fromJson(Map<String, dynamic> json) => DispatchedSerialData(
    serialId: json["serial_id"],
    serialNumber: json["serial_number"],
    dispatchNumber: json["dispatch_number"],
  );

  Map<String, dynamic> toJson() => {
    "serial_id": serialId,
    "serial_number": serialNumber,
    "dispatch_number": dispatchNumber,
  };
}
