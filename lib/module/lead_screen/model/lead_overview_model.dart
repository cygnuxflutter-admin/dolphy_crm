import 'dart:convert';

LeadViewResponseModel leadViewResponseModelFromJson(String str) => LeadViewResponseModel.fromJson(json.decode(str));

String leadViewResponseModelToJson(LeadViewResponseModel data) => json.encode(data.toJson());

class LeadViewResponseModel {
  final bool success;
  final String message;
  final LeadViewData leadViewData;
  final int status;
  final String error;

  LeadViewResponseModel({required this.success, required this.message, required this.leadViewData, required this.status, required this.error});

  factory LeadViewResponseModel.fromJson(Map<String, dynamic> json) => LeadViewResponseModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    leadViewData: LeadViewData.fromJson(json["data"] ?? {}),
    status: json["status"] ?? 0,
    error: json["error"] ?? "",
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": leadViewData.toJson(), "status": status, "error": error};
}

class LeadViewData {
  final Opportunity opportunity;
  final List<LeadViewActivity> leadViewActivities;
  final List<dynamic> quotations;
  final List<LeadViewLog> leadViewLogs;
  final List<AssignmentHistory> assignmentHistory;
  final Summary summary;

  LeadViewData({
    required this.opportunity,
    required this.leadViewActivities,
    required this.quotations,
    required this.leadViewLogs,
    required this.assignmentHistory,
    required this.summary,
  });

  factory LeadViewData.fromJson(Map<String, dynamic> json) => LeadViewData(
    opportunity: Opportunity.fromJson(json["opportunity"] ?? {}),
    leadViewActivities: json["activities"] == null ? [] : List<LeadViewActivity>.from(json["activities"].map((x) => LeadViewActivity.fromJson(x))),
    quotations: json["quotations"] ?? [],
    leadViewLogs: json["logs"] == null ? [] : List<LeadViewLog>.from(json["logs"].map((x) => LeadViewLog.fromJson(x))),
    assignmentHistory: json["assignment_history"] == null
        ? []
        : List<AssignmentHistory>.from(json["assignment_history"].map((x) => AssignmentHistory.fromJson(x))),
    summary: Summary.fromJson(json["summary"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "opportunity": opportunity.toJson(),
    "activities": leadViewActivities.map((x) => x.toJson()).toList(),
    "quotations": quotations,
    "opportunityViewLog": leadViewLogs.map((x) => x.toJson()).toList(),
    "assignment_history": assignmentHistory.map((x) => x.toJson()).toList(),
    "summary": summary.toJson(),
  };
}

class LeadViewActivity {
  final String id;
  final String activityType;
  final String activityStatus;
  final String invitationStatus;
  final String callMedium;
  final String subject;
  final String description;
  final String startTime;
  final String endTime;
  final String location;
  final String link;
  final String followUpDate;
  final String reminderTime;
  final bool isReminderSent;
  final String createdBy;
  final String createdByName;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> invitees;

  LeadViewActivity({
    required this.id,
    required this.activityType,
    required this.activityStatus,
    required this.invitationStatus,
    required this.callMedium,
    required this.subject,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.link,
    required this.followUpDate,
    required this.reminderTime,
    required this.isReminderSent,
    required this.createdBy,
    required this.createdByName,
    required this.createdAt,
    required this.updatedAt,
    required this.invitees,
  });

  factory LeadViewActivity.fromJson(Map<String, dynamic> json) => LeadViewActivity(
    id: json["id"] ?? "",
    activityType: json["activity_type"] ?? "",
    activityStatus: json["activity_status"] ?? "",
    invitationStatus: json["invitation_status"] ?? "",
    callMedium: json["call_medium"] ?? "",
    subject: json["subject"] ?? "",
    description: json["description"] ?? "",
    startTime: json["start_time"] ?? "",
    endTime: json["end_time"] ?? "",
    location: json["location"] ?? "",
    link: json["link"] ?? "",
    followUpDate: json["follow_up_date"] ?? "",
    reminderTime: json["reminder_time"] ?? "",
    isReminderSent: json["is_reminder_sent"] ?? false,
    createdBy: json["created_by"] ?? "",
    createdByName: json["created_by_name"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    invitees: json["invitees"] ?? [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "activity_type": activityType,
    "activity_status": activityStatus,
    "invitation_status": invitationStatus,
    "call_medium": callMedium,
    "subject": subject,
    "description": description,
    "start_time": startTime,
    "end_time": endTime,
    "location": location,
    "link": link,
    "follow_up_date": followUpDate,
    "reminder_time": reminderTime,
    "is_reminder_sent": isReminderSent,
    "created_by": createdBy,
    "created_by_name": createdByName,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "invitees": invitees,
  };
}

class AssignmentHistory {
  final int step;
  final String id;
  final String assignedFrom;
  final String assignedFromName;
  final String assignedTo;
  final String assignedToName;
  final String assignedBy;
  final String assignedByName;
  final String notes;
  final String assignedAt;

  AssignmentHistory({
    required this.step,
    required this.id,
    required this.assignedFrom,
    required this.assignedFromName,
    required this.assignedTo,
    required this.assignedToName,
    required this.assignedBy,
    required this.assignedByName,
    required this.notes,
    required this.assignedAt,
  });

  factory AssignmentHistory.fromJson(Map<String, dynamic> json) => AssignmentHistory(
    step: json["step"] ?? 0,
    id: json["id"] ?? "",
    assignedFrom: json["assigned_from"] ?? "",
    assignedFromName: json["assigned_from_name"] ?? "",
    assignedTo: json["assigned_to"] ?? "",
    assignedToName: json["assigned_to_name"] ?? "",
    assignedBy: json["assigned_by"] ?? "",
    assignedByName: json["assigned_by_name"] ?? "",
    notes: json["notes"] ?? "",
    assignedAt: json["assigned_at"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "step": step,
    "id": id,
    "assigned_from": assignedFrom,
    "assigned_from_name": assignedFromName,
    "assigned_to": assignedTo,
    "assigned_to_name": assignedToName,
    "assigned_by": assignedBy,
    "assigned_by_name": assignedByName,
    "notes": notes,
    "assigned_at": assignedAt,
  };
}

class LeadViewLog {
  final String id;
  final String notes;
  final String reminderDate;
  final String createdBy;
  final String createdByName;
  final String createdAt;
  final List<String> attachmentUrl;

  LeadViewLog({
    required this.id,
    required this.notes,
    required this.reminderDate,
    required this.createdBy,
    required this.createdByName,
    required this.createdAt,
    required this.attachmentUrl,
  });

  factory LeadViewLog.fromJson(Map<String, dynamic> json) => LeadViewLog(
    id: json["id"] ?? "",
    notes: json["notes"] ?? "",
    reminderDate: json["reminder_date"] ?? "",
    createdBy: json["created_by"] ?? "",
    createdByName: json["created_by_name"] ?? "",
    createdAt: json["created_at"] ?? "",
    attachmentUrl: json["attachment_url"] == null ? [] : List<String>.from(json["attachment_url"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "notes": notes,
    "reminder_date": reminderDate,
    "created_by": createdBy,
    "created_by_name": createdByName,
    "created_at": createdAt,
    "attachment_url": List<dynamic>.from(attachmentUrl.map((x) => x)),
  };
}

class Opportunity {
  final String id;
  final String tenantId;
  final String opportunityName;
  final String customerId;
  final String productId;
  final String expectedAmount;
  final String probability;
  final String email;
  final String personName;
  final String mobile1;
  final String mobile2;
  final String address;
  final bool isBulkRequirement;
  final String cityId;
  final String pincodeId;
  final String stateId;
  final String sourceId;
  final String labelId;
  final String salesPersonId;
  final String expectedClosingDate;
  final bool isAssigned;
  final String assignedBy;
  final String assignedAt;
  final List<dynamic> tags;
  final String remarks;
  final String interest;
  final String sectionId;
  final String sectionName;
  final String createdBy;
  final String updatedBy;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;
  final String deletedAt;
  final String customerName;
  final String customerPriceType;
  final String stateName;
  final String cityName;
  final String pincodeName;
  final String sourceName;
  final String labelName;
  final String salesPersonName;
  final String createdByName;
  final String updatedByName;

  Opportunity({
    required this.id,
    required this.tenantId,
    required this.opportunityName,
    required this.customerId,
    required this.productId,
    required this.expectedAmount,
    required this.probability,
    required this.email,
    required this.personName,
    required this.mobile1,
    required this.mobile2,
    required this.address,
    required this.isBulkRequirement,
    required this.cityId,
    required this.pincodeId,
    required this.stateId,
    required this.sourceId,
    required this.labelId,
    required this.salesPersonId,
    required this.expectedClosingDate,
    required this.isAssigned,
    required this.assignedBy,
    required this.assignedAt,
    required this.tags,
    required this.remarks,
    required this.interest,
    required this.sectionId,
    required this.sectionName,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.deletedAt,
    required this.customerName,
    required this.customerPriceType,
    required this.stateName,
    required this.cityName,
    required this.pincodeName,
    required this.sourceName,
    required this.labelName,
    required this.salesPersonName,
    required this.createdByName,
    required this.updatedByName,
  });

  factory Opportunity.fromJson(Map<String, dynamic> json) => Opportunity(
    id: json["id"] ?? "",
    tenantId: json["tenant_id"] ?? "",
    opportunityName: json["opportunity_name"] ?? "",
    customerId: json["customer_id"] ?? "",
    productId: json["product_id"] ?? "",
    expectedAmount: json["expected_amount"] ?? "",
    probability: json["probability"] ?? "",
    email: json["email"] ?? "",
    personName: json["person_name"] ?? "",
    mobile1: json["mobile1"] ?? "",
    mobile2: json["mobile2"] ?? "",
    address: json["address"] ?? "",
    isBulkRequirement: json["is_bulk_requirement"] ?? false,
    cityId: json["city_id"] ?? "",
    pincodeId: json["pincode_id"] ?? "",
    stateId: json["state_id"] ?? "",
    sourceId: json["source_id"] ?? "",
    labelId: json["label_id"] ?? "",
    salesPersonId: json["sales_person_id"] ?? "",
    expectedClosingDate: json["expected_closing_date"] ?? "",
    isAssigned: json["is_assigned"] ?? false,
    assignedBy: json["assigned_by"] ?? "",
    assignedAt: json["assigned_at"] ?? "",
    tags: json["tags"] ?? [],
    remarks: json["remarks"] ?? "",
    interest: json["interest"] ?? "",
    sectionId: json["section_id"] ?? "",
    sectionName: json["section_name"] ?? "",
    createdBy: json["created_by"] ?? "",
    updatedBy: json["updated_by"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    isDeleted: json["is_deleted"] ?? false,
    deletedAt: json["deleted_at"] ?? "",
    customerName: json["customer_name"] ?? "",
    customerPriceType: json["customer_price_type"] ?? "",
    stateName: json["state_name"] ?? "",
    cityName: json["city_name"] ?? "",
    pincodeName: json["pincode_name"] ?? "",
    sourceName: json["source_name"] ?? "",
    labelName: json["label_name"] ?? "",
    salesPersonName: json["sales_person_name"] ?? "",
    createdByName: json["created_by_name"] ?? "",
    updatedByName: json["updated_by_name"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "opportunity_name": opportunityName,
    "customer_id": customerId,
    "product_id": productId,
    "expected_amount": expectedAmount,
    "probability": probability,
    "email": email,
    "person_name": personName,
    "mobile1": mobile1,
    "mobile2": mobile2,
    "address": address,
    "is_bulk_requirement": isBulkRequirement,
    "city_id": cityId,
    "pincode_id": pincodeId,
    "state_id": stateId,
    "source_id": sourceId,
    "label_id": labelId,
    "sales_person_id": salesPersonId,
    "expected_closing_date": expectedClosingDate,
    "is_assigned": isAssigned,
    "assigned_by": assignedBy,
    "assigned_at": assignedAt,
    "tags": tags,
    "remarks": remarks,
    "interest": interest,
    "section_id": sectionId,
    "section_name": sectionName,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "customer_name": customerName,
    "customer_price_type": customerPriceType,
    "state_name": stateName,
    "city_name": cityName,
    "pincode_name": pincodeName,
    "source_name": sourceName,
    "label_name": labelName,
    "sales_person_name": salesPersonName,
    "created_by_name": createdByName,
    "updated_by_name": updatedByName,
  };
}

class Summary {
  final int totalActivities;
  final int totalCalls;
  final int totalMeetings;
  final int totalQuotations;
  final int totalQuotationValue;
  final int totalLogs;
  final int totalAssignments;

  Summary({
    required this.totalActivities,
    required this.totalCalls,
    required this.totalMeetings,
    required this.totalQuotations,
    required this.totalQuotationValue,
    required this.totalLogs,
    required this.totalAssignments,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalActivities: json["total_activities"] ?? 0,
    totalCalls: json["total_calls"] ?? 0,
    totalMeetings: json["total_meetings"] ?? 0,
    totalQuotations: json["total_quotations"] ?? 0,
    totalQuotationValue: json["total_quotation_value"] ?? 0,
    totalLogs: json["total_logs"] ?? 0,
    totalAssignments: json["total_assignments"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "total_activities": totalActivities,
    "total_calls": totalCalls,
    "total_meetings": totalMeetings,
    "total_quotations": totalQuotations,
    "total_quotation_value": totalQuotationValue,
    "total_logs": totalLogs,
    "total_assignments": totalAssignments,
  };
}
