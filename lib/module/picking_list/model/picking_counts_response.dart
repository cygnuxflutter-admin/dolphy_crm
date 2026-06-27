import 'dart:convert';

PickingCountsResponse pickingCountsResponseFromJson(String str) => PickingCountsResponse.fromJson(json.decode(str));

String pickingCountsResponseToJson(PickingCountsResponse data) => json.encode(data.toJson());

class PickingCountsResponse {
  final bool? success;
  final String? message;
  final PickingCounts? data;
  final int? status;

  PickingCountsResponse({this.success, this.message, this.data, this.status});

  factory PickingCountsResponse.fromJson(Map<String, dynamic> json) => PickingCountsResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : PickingCounts.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data?.toJson(), "status": status};
}

class PickingCounts {
  final int? all;
  final int? draft;
  final int? assigned;
  final int? picking;
  final int? partial;
  final int? picked;
  final int? cancelled;
  final int? packingReject;
  final int? rejected;

  PickingCounts({this.all, this.draft, this.partial, this.picked, this.packingReject, this.rejected, this.assigned, this.cancelled, this.picking});

  factory PickingCounts.fromJson(Map<String, dynamic> json) => PickingCounts(
    all: int.tryParse(json["all"]?.toString() ?? ""),
    draft: int.tryParse(json["DRAFT"]?.toString() ?? ""),
    partial: int.tryParse(json["PARTIAL"]?.toString() ?? ""),
    picked: int.tryParse(json["PICKED"]?.toString() ?? ""),
    packingReject: int.tryParse(json["PACKING_REJECT"]?.toString() ?? ""),
    rejected: int.tryParse(json["REJECTED"]?.toString() ?? ""),
    assigned: int.tryParse(json["ASSIGNED"]?.toString() ?? ""),
    cancelled: int.tryParse(json["CANCELLED"]?.toString() ?? ""),
    picking: int.tryParse(json["PICKING"]?.toString() ?? ""),
  );

  Map<String, dynamic> toJson() => {
    "all": all,
    "DRAFT": draft,
    "PARTIAL": partial,
    "PICKED": picked,
    "PACKING_REJECT": packingReject,
    "REJECTED": rejected,
    "PICKING": picking,
    "ASSIGNED": assigned,
    "CANCELLED": cancelled,
  };
}
