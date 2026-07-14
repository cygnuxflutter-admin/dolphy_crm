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
  final List<Quotation> quotations;
  final List<LeadViewLog> leadViewLogs;
  final List<AssignmentHistory> assignmentHistory;
  final List<SecondarySalesPerson> secondarySalesPersons;
  final Summary summary;

  LeadViewData({
    required this.opportunity,
    required this.leadViewActivities,
    required this.quotations,
    required this.leadViewLogs,
    required this.assignmentHistory,
    required this.secondarySalesPersons,
    required this.summary,
  });

  factory LeadViewData.fromJson(Map<String, dynamic> json) => LeadViewData(
    opportunity: Opportunity.fromJson(json["opportunity"] ?? {}),
    leadViewActivities: json["activities"] == null ? [] : List<LeadViewActivity>.from(json["activities"].map((x) => LeadViewActivity.fromJson(x))),
    quotations: json["quotations"] == null ? [] : List<Quotation>.from(json["quotations"].map((x) => Quotation.fromJson(x))),
    leadViewLogs: json["logs"] == null ? [] : List<LeadViewLog>.from(json["logs"].map((x) => LeadViewLog.fromJson(x))),
    assignmentHistory: json["assignment_history"] == null ? [] : List<AssignmentHistory>.from(json["assignment_history"].map((x) => AssignmentHistory.fromJson(x))),
    secondarySalesPersons: json["secondary_sales_persons"] == null ? [] : List<SecondarySalesPerson>.from(json["secondary_sales_persons"].map((x) => SecondarySalesPerson.fromJson(x))),
    summary: Summary.fromJson(json["summary"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "opportunity": opportunity.toJson(),
    "activities": leadViewActivities.map((x) => x.toJson()).toList(),
    "quotations": quotations.map((x) => x.toJson()).toList(),
    "logs": leadViewLogs.map((x) => x.toJson()).toList(),
    "assignment_history": assignmentHistory.map((x) => x.toJson()).toList(),
    "secondary_sales_persons": secondarySalesPersons.map((x) => x.toJson()).toList(),
    "summary": summary.toJson(),
  };
}

class SecondarySalesPerson {
  final String id;
  final String userId;
  final String assignedBy;
  final String assignedByName;
  final String createdAt;
  final User user;

  SecondarySalesPerson({
    required this.id,
    required this.userId,
    required this.assignedBy,
    required this.assignedByName,
    required this.createdAt,
    required this.user,
  });

  factory SecondarySalesPerson.fromJson(Map<String, dynamic> json) => SecondarySalesPerson(
    id: json["id"]?.toString() ?? "",
    userId: json["user_id"]?.toString() ?? "",
    assignedBy: json["assigned_by"]?.toString() ?? "",
    assignedByName: json["assigned_by_name"]?.toString() ?? "",
    createdAt: json["created_at"]?.toString() ?? "",
    user: User.fromJson(json["user"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "assigned_by": assignedBy,
    "assigned_by_name": assignedByName,
    "created_at": createdAt,
    "user": user.toJson(),
  };
}

class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"]?.toString() ?? "",
    name: json["name"]?.toString() ?? "",
    email: json["email"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
  };
}

class Quotation {
  final String id;
  final String quotationNo;
  final String totalAmount;
  final String status;
  final String createdAt;

  Quotation({
    required this.id,
    required this.quotationNo,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) => Quotation(
    id: json["id"]?.toString() ?? "",
    quotationNo: json["quotation_no"]?.toString() ?? "",
    totalAmount: json["total_amount"]?.toString() ?? "",
    status: json["status"]?.toString() ?? "",
    createdAt: json["created_at"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quotation_no": quotationNo,
    "total_amount": totalAmount,
    "status": status,
    "created_at": createdAt,
  };
}

class LeadViewActivity {
  final String id;
  final String activityType;
  final String activityTypeName;
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
    required this.activityTypeName,
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
    id: json["id"]?.toString() ?? "",
    activityType: json["activity_type"]?.toString() ?? "",
    activityTypeName: json["activity_type_name"]?.toString() ?? "",
    activityStatus: json["activity_status"]?.toString() ?? "",
    invitationStatus: json["invitation_status"]?.toString() ?? "",
    callMedium: json["call_medium"]?.toString() ?? "",
    subject: json["subject"]?.toString() ?? "",
    description: json["description"]?.toString() ?? "",
    startTime: json["start_time"]?.toString() ?? "",
    endTime: json["end_time"]?.toString() ?? "",
    location: json["location"]?.toString() ?? "",
    link: json["link"]?.toString() ?? "",
    followUpDate: json["follow_up_date"]?.toString() ?? "",
    reminderTime: json["reminder_time"]?.toString() ?? "",
    isReminderSent: json["is_reminder_sent"] ?? false,
    createdBy: json["created_by"]?.toString() ?? "",
    createdByName: json["created_by_name"]?.toString() ?? "",
    createdAt: json["created_at"]?.toString() ?? "",
    updatedAt: json["updated_at"]?.toString() ?? "",
    invitees: json["invitees"] ?? [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "activity_type": activityType,
    "activity_type_name": activityTypeName,
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
    id: json["id"]?.toString() ?? "",
    assignedFrom: json["assigned_from"]?.toString() ?? "",
    assignedFromName: json["assigned_from_name"]?.toString() ?? "",
    assignedTo: json["assigned_to"]?.toString() ?? "",
    assignedToName: json["assigned_to_name"]?.toString() ?? "",
    assignedBy: json["assigned_by"]?.toString() ?? "",
    assignedByName: json["assigned_by_name"]?.toString() ?? "",
    notes: json["notes"]?.toString() ?? "",
    assignedAt: json["assigned_at"]?.toString() ?? "",
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
    id: json["id"]?.toString() ?? "",
    notes: json["notes"]?.toString() ?? "",
    reminderDate: json["reminder_date"]?.toString() ?? "",
    createdBy: json["created_by"]?.toString() ?? "",
    createdByName: json["created_by_name"]?.toString() ?? "",
    createdAt: json["created_at"]?.toString() ?? "",
    attachmentUrl: json["attachment_url"] == null ? [] : List<String>.from(json["attachment_url"].map((x) => x?.toString() ?? "")),
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
  
  // New fields from JSON
  final String companyName;
  final String customerGstNumber;
  final String locationCode;
  final ContactPersonData? contactPersonData;
  
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
    required this.companyName,
    required this.customerGstNumber,
    required this.locationCode,
    this.contactPersonData,
  });

  factory Opportunity.fromJson(Map<String, dynamic> json) => Opportunity(
    id: json["id"]?.toString() ?? "",
    tenantId: json["tenant_id"]?.toString() ?? "",
    opportunityName: json["opportunity_name"]?.toString() ?? "",
    customerId: json["customer_id"]?.toString() ?? "",
    productId: json["product_id"]?.toString() ?? "",
    expectedAmount: json["expected_amount"]?.toString() ?? "",
    probability: json["probability"]?.toString() ?? "",
    email: json["email"]?.toString() ?? "",
    personName: json["person_name"]?.toString() ?? "",
    mobile1: json["mobile1"]?.toString() ?? "",
    mobile2: json["mobile2"]?.toString() ?? "",
    address: json["address"]?.toString() ?? (json["customer_address"]?.toString() ?? ""),
    isBulkRequirement: json["is_bulk_requirement"] ?? false,
    cityId: json["city_id"]?.toString() ?? "",
    pincodeId: json["pincode_id"]?.toString() ?? "",
    stateId: json["state_id"]?.toString() ?? "",
    sourceId: json["source_id"]?.toString() ?? "",
    labelId: json["label_id"]?.toString() ?? "",
    salesPersonId: json["sales_person_id"]?.toString() ?? "",
    expectedClosingDate: json["expected_closing_date"]?.toString() ?? "",
    isAssigned: json["is_assigned"] ?? false,
    assignedBy: json["assigned_by"]?.toString() ?? "",
    assignedAt: json["assigned_at"]?.toString() ?? "",
    tags: json["tags"] ?? [],
    remarks: json["remarks"]?.toString() ?? "",
    interest: json["interest"]?.toString() ?? "",
    sectionId: json["section_id"]?.toString() ?? "",
    sectionName: json["section_name"]?.toString() ?? "",
    createdBy: json["created_by"]?.toString() ?? "",
    updatedBy: json["updated_by"]?.toString() ?? "",
    createdAt: json["created_at"]?.toString() ?? "",
    updatedAt: json["updated_at"]?.toString() ?? "",
    isDeleted: json["is_deleted"] ?? false,
    deletedAt: json["deleted_at"]?.toString() ?? "",
    customerName: json["customer_name"]?.toString() ?? "",
    customerPriceType: json["customer_price_type"]?.toString() ?? "",
    stateName: json["state_name"]?.toString() ?? "",
    cityName: json["city_name"]?.toString() ?? "",
    pincodeName: json["pincode_name"]?.toString() ?? "",
    sourceName: json["source_name"]?.toString() ?? "",
    labelName: json["label_name"]?.toString() ?? "",
    salesPersonName: json["sales_person_name"]?.toString() ?? "",
    createdByName: json["created_by_name"]?.toString() ?? "",
    updatedByName: json["updated_by_name"]?.toString() ?? "",
    companyName: json["company_name"]?.toString() ?? "",
    customerGstNumber: json["customer_gst_number"]?.toString() ?? "",
    locationCode: json["location_code"]?.toString() ?? "",
    contactPersonData: json["contact_person_data"] == null ? null : ContactPersonData.fromJson(json["contact_person_data"]),
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
    "company_name": companyName,
    "customer_gst_number": customerGstNumber,
    "location_code": locationCode,
    "contact_person_data": contactPersonData?.toJson(),
  };
}


class ContactPersonData {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String mobileAlt;
  final String emailId;
  final String designation;
  final String address;
  final String countryName;
  final String stateName;
  final String cityName;
  final String pincodeName;
  final String notes;

  ContactPersonData({
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.mobileAlt,
    required this.emailId,
    required this.designation,
    required this.address,
    required this.countryName,
    required this.stateName,
    required this.cityName,
    required this.pincodeName,
    required this.notes,
  });

  factory ContactPersonData.fromJson(Map<String, dynamic> json) => ContactPersonData(
    firstName: json["first_name"]?.toString() ?? "",
    lastName: json["last_name"]?.toString() ?? "",
    mobileNumber: json["mobile_number"]?.toString() ?? "",
    mobileAlt: json["mobile_alt"]?.toString() ?? "",
    emailId: json["email_id"]?.toString() ?? "",
    designation: json["designation"]?.toString() ?? "",
    address: json["address"]?.toString() ?? "",
    countryName: json["country_name"]?.toString() ?? "",
    stateName: json["state_name"]?.toString() ?? "",
    cityName: json["city_name"]?.toString() ?? "",
    pincodeName: json["pincode_name"]?.toString() ?? "",
    notes: json["notes"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "mobile_number": mobileNumber,
    "mobile_alt": mobileAlt,
    "email_id": emailId,
    "designation": designation,
    "address": address,
    "country_name": countryName,
    "state_name": stateName,
    "city_name": cityName,
    "pincode_name": pincodeName,
    "notes": notes,
  };
}

class Summary {
  final int totalActivities;
  final int totalCalls;
  final int totalMeetings;
  final int totalQuotations;
  final num totalQuotationValue;
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
    totalQuotationValue: json["total_quotation_value"] ?? 0.0,
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
