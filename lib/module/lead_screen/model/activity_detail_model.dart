import 'dart:convert';

ActivityDetailModel activityDetailModelFromJson(String str) => ActivityDetailModel.fromJson(json.decode(str));

String activityDetailModelToJson(ActivityDetailModel data) => json.encode(data.toJson());

class ActivityDetailModel {
  bool success;
  String message;
  ActivityDetailData data;
  int status;
  dynamic error;

  ActivityDetailModel({required this.success, required this.message, required this.data, required this.status, this.error});

  factory ActivityDetailModel.fromJson(Map<String, dynamic> json) => ActivityDetailModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: ActivityDetailData.fromJson(json["data"] ?? {}),
    status: json["status"] ?? 0,
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data.toJson(), "status": status, "error": error};
}

class ActivityDetailData {
  String id;
  String tenant;
  String opportunityId;
  String activityType;
  String activityStatus;
  String invitationStatus;
  dynamic callMedium;
  String subject;
  String description;
  dynamic remarks;
  String startTime;
  String endTime;
  dynamic locationId;
  dynamic link;
  String createdBy;
  String followUpDate;
  String reminderTime;
  bool isReminderSent;
  String createdAt;
  String updatedAt;
  dynamic updatedBy;
  dynamic companyId;
  dynamic companyCode;
  dynamic finYear;
  dynamic locationCode;
  bool isDeleted;
  dynamic deletedAt;
  String entityType;
  dynamic companyName;
  dynamic locationName;

  ActivityDetailData({
    required this.id,
    required this.tenant,
    required this.opportunityId,
    required this.activityType,
    required this.activityStatus,
    required this.invitationStatus,
    this.callMedium,
    required this.subject,
    required this.description,
    this.remarks,
    required this.startTime,
    required this.endTime,
    this.locationId,
    this.link,
    required this.createdBy,
    required this.followUpDate,
    required this.reminderTime,
    required this.isReminderSent,
    required this.createdAt,
    required this.updatedAt,
    this.updatedBy,
    this.companyId,
    this.companyCode,
    this.finYear,
    this.locationCode,
    required this.isDeleted,
    this.deletedAt,
    required this.entityType,
    this.companyName,
    this.locationName,
  });

  factory ActivityDetailData.fromJson(Map<String, dynamic> json) => ActivityDetailData(
    id: json["id"]?.toString() ?? "",
    tenant: json["tenant"]?.toString() ?? "",
    opportunityId: json["opportunity_id"]?.toString() ?? "",
    activityType: json["activity_type"]?.toString() ?? "",
    activityStatus: json["activity_status"]?.toString() ?? "",
    invitationStatus: json["invitation_status"]?.toString() ?? "",
    callMedium: json["call_medium"],
    subject: json["subject"]?.toString() ?? "",
    description: json["description"]?.toString() ?? "",
    remarks: json["remarks"],
    startTime: json["start_time"]?.toString() ?? "",
    endTime: json["end_time"]?.toString() ?? "",
    locationId: json["location_id"],
    link: json["link"],
    createdBy: json["created_by"]?.toString() ?? "",
    followUpDate: json["follow_up_date"]?.toString() ?? "",
    reminderTime: json["reminder_time"]?.toString() ?? "",
    isReminderSent: json["is_reminder_sent"] ?? false,
    createdAt: json["created_at"]?.toString() ?? "",
    updatedAt: json["updated_at"]?.toString() ?? "",
    updatedBy: json["updated_by"],
    companyId: json["company_id"],
    companyCode: json["company_code"],
    finYear: json["fin_year"],
    locationCode: json["location_code"],
    isDeleted: json["is_deleted"] ?? false,
    deletedAt: json["deleted_at"],
    entityType: json["entity_type"]?.toString() ?? "",
    companyName: json["company_name"],
    locationName: json["location_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant": tenant,
    "opportunity_id": opportunityId,
    "activity_type": activityType,
    "activity_status": activityStatus,
    "invitation_status": invitationStatus,
    "call_medium": callMedium,
    "subject": subject,
    "description": description,
    "remarks": remarks,
    "start_time": startTime,
    "end_time": endTime,
    "location_id": locationId,
    "link": link,
    "created_by": createdBy,
    "follow_up_date": followUpDate,
    "reminder_time": reminderTime,
    "is_reminder_sent": isReminderSent,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "updated_by": updatedBy,
    "company_id": companyId,
    "company_code": companyCode,
    "fin_year": finYear,
    "location_code": locationCode,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "entity_type": entityType,
    "company_name": companyName,
    "location_name": locationName,
  };
}
