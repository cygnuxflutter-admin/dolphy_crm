import 'dart:convert';

VisitCountsResponseModel visitCountsResponseModelFromJson(String str) => VisitCountsResponseModel.fromJson(json.decode(str));

String visitCountsResponseModelToJson(VisitCountsResponseModel data) => json.encode(data.toJson());

class VisitCountsResponseModel {
  final bool? success;
  final String? message;
  final VisitCounts? data;
  final int? status;

  VisitCountsResponseModel({this.success, this.message, this.data, this.status});

  factory VisitCountsResponseModel.fromJson(Map<String, dynamic> json) => VisitCountsResponseModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : VisitCounts.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data?.toJson(), "status": status};
}

class VisitCounts {
  final int? all;
  final int? pending;
  final int? inProgress;
  final int? completed;
  final int? cancelled;
  final int? rejected;

  VisitCounts({
    this.all,
    this.pending,
    this.inProgress,
    this.completed,
    this.cancelled,
    this.rejected,
  });

  factory VisitCounts.fromJson(Map<String, dynamic> json) => VisitCounts(
    all: int.tryParse((json["all"] ?? json["ALL"] ?? "0").toString()),
    pending: int.tryParse((json["PENDING"] ?? json["pending"] ?? "0").toString()),
    inProgress: int.tryParse((json["IN_PROGRESS"] ?? json["in_progress"] ?? json["IN PROGRESS"] ?? json["inprogress"] ?? "0").toString()),
    completed: int.tryParse((json["COMPLETED"] ?? json["completed"] ?? "0").toString()),
    cancelled: int.tryParse((json["CANCELLED"] ?? json["cancelled"] ?? "0").toString()),
    rejected: int.tryParse((json["REJECTED"] ?? json["rejected"] ?? "0").toString()),
  );

  Map<String, dynamic> toJson() => {
    "all": all,
    "PENDING": pending,
    "IN_PROGRESS": inProgress,
    "COMPLETED": completed,
    "CANCELLED": cancelled,
    "REJECTED": rejected,
  };
}
