import 'dart:convert';

OpportunitySummaryModel opportunitySummaryModelFromJson(String str) => OpportunitySummaryModel.fromJson(json.decode(str));

String opportunitySummaryModelToJson(OpportunitySummaryModel data) => json.encode(data.toJson());

class OpportunitySummaryModel {
  bool success;
  String message;
  Data data;
  int status;
  dynamic error;

  OpportunitySummaryModel({required this.success, required this.message, required this.data, required this.status, this.error});

  factory OpportunitySummaryModel.fromJson(Map<String, dynamic> json) => OpportunitySummaryModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: Data.fromJson(json["data"] ?? {}),
    status: json["status"] ?? 0,
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data.toJson(), "status": status, "error": error};
}

class Data {
  OpportunityActivitySummary summary;
  List<OpportunitySummaryItem> items;
  Pagination pagination;

  Data({required this.summary, required this.items, required this.pagination});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    summary: OpportunityActivitySummary.fromJson(json["summary"] ?? {}),
    items: json["items"] == null ? [] : List<OpportunitySummaryItem>.from(json["items"].map((x) => OpportunitySummaryItem.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "summary": summary.toJson(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}

class OpportunitySummaryItem {
  String opportunityId;
  String opportunityName;
  String customerName;
  String companyName;
  String amount;
  dynamic status;
  String? followUpDate;
  bool isOwner;
  bool isFollower;
  bool isReportingManager;
  Map<String, List<ActivityItem>> activities;

  OpportunitySummaryItem({
    required this.opportunityId,
    required this.opportunityName,
    required this.customerName,
    required this.companyName,
    required this.amount,
    this.status,
    this.followUpDate,
    required this.isOwner,
    required this.isFollower,
    required this.isReportingManager,
    required this.activities,
  });

  factory OpportunitySummaryItem.fromJson(Map<String, dynamic> json) => OpportunitySummaryItem(
    opportunityId: json["opportunity_id"]?.toString() ?? "",
    opportunityName: json["opportunity_name"]?.toString() ?? "",
    customerName: json["customer_name"]?.toString() ?? "",
    companyName: json["company_name"]?.toString() ?? "",
    amount: json["amount"]?.toString() ?? "0",
    status: json["status"],
    followUpDate: json["follow_up_date"]?.toString(),
    isOwner: json["is_owner"] ?? false,
    isFollower: json["is_follower"] ?? false,
    isReportingManager: json["is_reporting_manager"] ?? false,
    activities: json["activities"] == null
        ? {}
        : Map.from(
            json["activities"],
          ).map((k, v) => MapEntry<String, List<ActivityItem>>(k, v == null ? [] : List<ActivityItem>.from(v.map((x) => ActivityItem.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "opportunity_id": opportunityId,
    "opportunity_name": opportunityName,
    "customer_name": customerName,
    "company_name": companyName,
    "amount": amount,
    "status": status,
    "follow_up_date": followUpDate,
    "is_owner": isOwner,
    "is_follower": isFollower,
    "is_reporting_manager": isReportingManager,
    "activities": Map.from(activities).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
  };
}

class ActivityItem {
  String id;
  String date;
  String status;
  String invitationStatus;
  dynamic remarks;
  String subject;

  ActivityItem({required this.id, required this.date, required this.status, required this.invitationStatus, this.remarks, required this.subject});

  factory ActivityItem.fromJson(Map<String, dynamic> json) => ActivityItem(
    id: json["id"]?.toString() ?? "",
    date: json["date"]?.toString() ?? "",
    status: json["status"]?.toString() ?? "",
    invitationStatus: json["invitation_status"]?.toString() ?? "",
    remarks: json["remarks"],
    subject: json["subject"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "status": status,
    "invitation_status": invitationStatus,
    "remarks": remarks,
    "subject": subject,
  };
}

class Pagination {
  int totalItems;
  int totalPages;
  int currentPage;
  int limit;

  Pagination({required this.totalItems, required this.totalPages, required this.currentPage, required this.limit});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalItems: json["totalItems"] ?? 0,
    totalPages: json["totalPages"] ?? 0,
    currentPage: json["currentPage"] ?? 1,
    limit: json["limit"] ?? 20,
  );

  Map<String, dynamic> toJson() => {"totalItems": totalItems, "totalPages": totalPages, "currentPage": currentPage, "limit": limit};
}

class OpportunityActivitySummary {
  ActivitySummary? call;
  ActivitySummary? meeting;

  OpportunityActivitySummary({this.call, this.meeting});

  factory OpportunityActivitySummary.fromJson(Map<String, dynamic> json) => OpportunityActivitySummary(
    call: json["call"] == null ? null : ActivitySummary.fromJson(json["call"]),
    meeting: json["meeting"] == null ? null : ActivitySummary.fromJson(json["meeting"]),
  );

  Map<String, dynamic> toJson() => {"call": call?.toJson(), "meeting": meeting?.toJson()};
}

class ActivitySummary {
  int total;
  int done;
  int pending;
  int past;
  int today;
  int future;

  ActivitySummary({required this.total, required this.done, required this.pending, required this.past, required this.today, required this.future});

  factory ActivitySummary.fromJson(Map<String, dynamic> json) => ActivitySummary(
    total: json["total"] ?? 0,
    done: json["done"] ?? 0,
    pending: json["pending"] ?? 0,
    past: json["past"] ?? 0,
    today: json["today"] ?? 0,
    future: json["future"] ?? 0,
  );

  Map<String, dynamic> toJson() => {"total": total, "done": done, "pending": pending, "past": past, "today": today, "future": future};
}
