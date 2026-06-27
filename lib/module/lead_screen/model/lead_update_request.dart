import 'dart:convert';

LeadUpdateRequest leadUpdateRequestFromJson(String str) => LeadUpdateRequest.fromJson(json.decode(str));

String leadUpdateRequestToJson(LeadUpdateRequest data) => json.encode(data.toJson());

class LeadUpdateRequest {
  final String? opportunityName;
  final List<String>? productIds;
  final String? customerId;
  final num? expectedAmount;
  final String? probabilityId;
  final String? email;
  final String? mobile1;
  final String? mobile2;
  final String? landline;
  final String? mobile1CountryCode;
  final String? mobile2CountryCode;
  final String? cityId;
  final String? pincodeId;
  final String? stateId;
  final String? sourceId;
  final String? labelId;
  final String? salesPersonId;
  final List<String>? secondarySalesPersonIds;
  final bool? isMobile;
  final String? expectedClosingDate;
  final List<String>? tags;
  final String? interest;
  final bool? isBulkRequirement;
  final String? remarks;
  final List<Log>? logs;
  final List<Activity>? activities;
  final List<dynamic>? productCategory;
  final String? locationId;
  final String? companyId;
  final String? finYear;
  final String? contactPersonId;

  LeadUpdateRequest({
    this.opportunityName,
    this.productIds,
    this.customerId,
    this.expectedAmount,
    this.probabilityId,
    this.email,
    this.mobile1,
    this.mobile2,
    this.landline,
    this.mobile1CountryCode,
    this.mobile2CountryCode,
    this.cityId,
    this.pincodeId,
    this.stateId,
    this.sourceId,
    this.labelId,
    this.salesPersonId,
    this.secondarySalesPersonIds,
    this.isMobile,
    this.expectedClosingDate,
    this.tags,
    this.interest,
    this.isBulkRequirement,
    this.remarks,
    this.logs,
    this.activities,
    this.locationId,
    this.companyId,
    this.finYear,
    this.contactPersonId,
    this.productCategory,
  });

  factory LeadUpdateRequest.fromJson(Map<String, dynamic> json) => LeadUpdateRequest(
    opportunityName: json["opportunity_name"],
    productIds: json["product_ids"] == null ? [] : List<String>.from(json["product_ids"]!.map((x) => x)),
    customerId: json["customer_id"],
    expectedAmount: json["expected_amount"],
    probabilityId: json["probability_id"],
    email: json["email"],
    mobile1: json["mobile1"],
    mobile2: json["mobile2"],
    landline: json["landline"],
    mobile1CountryCode: json["mobile1_country_code"],
    mobile2CountryCode: json["mobile2_country_code"],
    cityId: json["city_id"],
    pincodeId: json["pincode_id"],
    stateId: json["state_id"],
    sourceId: json["source_id"],
    labelId: json["label_id"],
    salesPersonId: json["sales_person_id"],
    secondarySalesPersonIds: json["secondary_sales_person_ids"] == null ? [] : List<String>.from(json["secondary_sales_person_ids"]!.map((x) => x)),
    isMobile: json["isMobile"],
    expectedClosingDate: json["expected_closing_date"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    interest: json["interest"],
    isBulkRequirement: json["is_bulk_requirement"],
    remarks: json["remarks"],
    logs: json["logs"] == null ? [] : List<Log>.from(json["logs"]!.map((x) => Log.fromJson(x))),
    activities: json["activities"] == null ? [] : List<Activity>.from(json["activities"]!.map((x) => Activity.fromJson(x))),
    locationId: json["location_id"],
    companyId: json["company_id"],
    finYear: json["fin_year"],
    contactPersonId: json['contactPersonId'],
    productCategory: json['productCategory'] == null ? [] : List<dynamic>.from(json["productCategory"]),
  );

  Map<String, dynamic> toJson() => {
    "opportunity_name": opportunityName,
    "product_ids": productIds == null ? [] : List<dynamic>.from(productIds!.map((x) => x)),
    "customer_id": customerId,
    "expected_amount": expectedAmount,
    "probability_id": probabilityId,
    "email": email,
    "mobile1": mobile1,
    "mobile2": mobile2,
    "landline": landline,
    "mobile1_country_code": mobile1CountryCode,
    "mobile2_country_code": mobile2CountryCode,
    "city_id": cityId,
    "pincode_id": pincodeId,
    "state_id": stateId,
    "source_id": sourceId,
    "label_id": labelId,
    "sales_person_id": salesPersonId,
    "secondary_sales_person_ids": secondarySalesPersonIds == null ? [] : List<dynamic>.from(secondarySalesPersonIds!.map((x) => x)),
    "isMobile": isMobile,
    "expected_closing_date": expectedClosingDate,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "interest": interest,
    "is_bulk_requirement": isBulkRequirement,
    "remarks": remarks,
    "logs": logs == null ? [] : List<dynamic>.from(logs!.map((x) => x.toJson())),
    "activities": activities == null ? [] : List<dynamic>.from(activities!.map((x) => x.toJson())),
    "productCategory": productCategory == null ? [] : List<dynamic>.from(productCategory!.map((x) => x.toJson())),
    "location_id": locationId,
    "company_id": companyId,
    "fin_year": finYear,
    "contactPersonId": contactPersonId,
  };
}

class Activity {
  final String? id;
  final String? activityType;
  final String? activityStatus;
  final String? callMedium;
  final String? subject;
  final String? description;
  final String? startTime;
  final String? endTime;
  final String? link;
  final String? reminderTime;
  final String? followUpDate;

  Activity({
    this.id,
    this.activityType,
    this.activityStatus,
    this.callMedium,
    this.subject,
    this.description,
    this.startTime,
    this.endTime,
    this.link,
    this.reminderTime,
    this.followUpDate,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json["id"] ?? "",
    activityType: json["activity_type"],
    activityStatus: json["activity_status"],
    callMedium: json["call_medium"],
    subject: json["subject"],
    description: json["description"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    link: json["link"],
    reminderTime: json["reminder_time"],
    followUpDate: json["follow_up_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id ?? "",
    "activity_type": activityType,
    "activity_status": activityStatus,
    "call_medium": callMedium,
    "subject": subject,
    "description": description,
    "start_time": startTime,
    "end_time": endTime,
    "link": link,
    "reminder_time": reminderTime,
    "follow_up_date": followUpDate,
  };
}

class Log {
  final String? opportunityId;
  final String? notes;
  final String? reminderDate;
  final List<String>? attachmentUrl;

  Log({this.opportunityId, this.notes, this.reminderDate, this.attachmentUrl});

  factory Log.fromJson(Map<String, dynamic> json) => Log(
    opportunityId: json["id"] ?? "",
    notes: json["notes"] ?? "",
    reminderDate: json["reminder_date"] ?? "",
    attachmentUrl: json["attachment_url"] == null ? [] : List<String>.from(json["attachment_url"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": opportunityId ?? "",
    "notes": notes,
    "reminder_date": reminderDate,
    "attachment_url": attachmentUrl == null ? [] : List<String>.from(attachmentUrl!.map((x) => x)),
  };
}
