import 'dart:convert';

PackingCountsResponseModel packingCountsResponseModelFromJson(String str) => PackingCountsResponseModel.fromJson(json.decode(str));

String packingCountsResponseModelToJson(PackingCountsResponseModel data) => json.encode(data.toJson());

class PackingCountsResponseModel {
  final bool? success;
  final String? message;
  final PackingCounts? data;
  final int? status;
  final dynamic error;

  PackingCountsResponseModel({this.success, this.message, this.data, this.status, this.error});

  factory PackingCountsResponseModel.fromJson(Map<String, dynamic> json) => PackingCountsResponseModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : PackingCounts.fromJson(json["data"]),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data?.toJson(), "status": status, "error": error};
}

class PackingCounts {
  final int? all;
  final int? readyToPack;
  final int? draft;
  final int? packing;
  final int? packed;
  final int? invoiced;
  final int? dcGenerated;
  final int? readyForDispatch;
  final int? cancelled;
  final int? rejected;
  final int? inPacking;
  final int? pending;

  PackingCounts({
    this.all,
    this.readyToPack,
    this.draft,
    this.packing,
    this.packed,
    this.invoiced,
    this.dcGenerated,
    this.readyForDispatch,
    this.cancelled,
    this.rejected,
    this.inPacking,
    this.pending,
  });

  factory PackingCounts.fromJson(Map<String, dynamic> json) => PackingCounts(
    all: int.tryParse(json["all"]?.toString() ?? ""),
    readyToPack: int.tryParse(json["READY_TO_PACK"]?.toString() ?? ""),
    draft: int.tryParse(json["DRAFT"]?.toString() ?? ""),
    packing: int.tryParse(json["PACKING"]?.toString() ?? ""),
    packed: int.tryParse(json["PACKED"]?.toString() ?? ""),
    invoiced: int.tryParse(json["INVOICED"]?.toString() ?? ""),
    dcGenerated: int.tryParse(json["DC_GENERATED"]?.toString() ?? ""),
    readyForDispatch: int.tryParse(json["READY_FOR_DISPATCH"]?.toString() ?? ""),
    cancelled: int.tryParse(json["CANCELLED"]?.toString() ?? ""),
    rejected: int.tryParse(json["REJECTED"]?.toString() ?? ""),
    inPacking: int.tryParse(json["IN_PACKING"]?.toString() ?? ""),
    pending: int.tryParse(json["PENDING"]?.toString() ?? ""),
  );

  Map<String, dynamic> toJson() => {
    "all": all,
    "READY_TO_PACK": readyToPack,
    "DRAFT": draft,
    "PACKING": packing,
    "PACKED": packed,
    "INVOICED": invoiced,
    "DC_GENERATED": dcGenerated,
    "READY_FOR_DISPATCH": readyForDispatch,
    "CANCELLED": cancelled,
    "REJECTED": rejected,
    "IN_PACKING": inPacking,
    "PENDING": pending,
  };
}
