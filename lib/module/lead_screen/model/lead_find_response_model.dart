import 'dart:convert';

LeadFindResponseModel leadFindResponseModelFromJson(String str) => LeadFindResponseModel.fromJson(json.decode(str));

String leadFindResponseModelToJson(LeadFindResponseModel data) => json.encode(data.toJson());

class LeadFindResponseModel {
  final bool success;
  final String message;
  final OpportunityFindData opportunityFindData;
  final int status;
  final String error;

  LeadFindResponseModel({required this.success, required this.message, required this.opportunityFindData, required this.status, required this.error});

  factory LeadFindResponseModel.fromJson(Map<String, dynamic> json) => LeadFindResponseModel(
    success: json["success"] ?? false,
    message: json["message"]?.toString() ?? "",
    opportunityFindData: OpportunityFindData.fromJson(json["data"] ?? {}),
    status: int.tryParse(json["status"]?.toString() ?? "0") ?? 0,
    error: json["error"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "OpportunityFindData": opportunityFindData.toJson(),
    "status": status,
    "error": error,
  };
}

class OpportunityFindData {
  final String id;
  final String tenantId;
  final String opportunityName;
  final String customerId;
  final List<String> productIds;
  final String expectedAmount;
  final String probability;
  final String probabilityId;
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
  final List<String> tags;
  final String remarks;
  final String interest;
  final String sectionId;
  final String sectionName;
  final String createdBy;
  final String updatedBy;
  final String createdAt;
  final String updatedAt;
  final String companyId;
  final String companyCode;
  final String finYear;
  final String locationId;
  final String locationCode;
  final bool isDeleted;
  final String deletedAt;
  final List<OpportunityFindAddress> opportunityFindAddress;
  final List<OpportunityFindLog> opportunityFindLog;
  final List<OpportunityFindActivity> opportunityFindActivity;
  final List<OpportunitySecondarySalesPerson> opportunitySecondarySalesPerson;
  final String customerName;
  final String customerPriceType;
  final String mobile1CountryCode;
  final String mobile2CountryCode;
  final String landline;
  final bool isMobile;
  final String stateName;
  final String cityName;
  final String pincodeName;
  final String salesPersonName;
  final String assignedByName;
  final String companyName;
  final String locationName;
  final String contactPersonId;
  final List<String> productCategory;

  OpportunityFindData({
    required this.id,
    required this.tenantId,
    required this.opportunityName,
    required this.customerId,
    required this.productIds,
    required this.expectedAmount,
    required this.probability,
    required this.probabilityId,
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
    required this.companyId,
    required this.companyCode,
    required this.finYear,
    required this.locationId,
    required this.locationCode,
    required this.isDeleted,
    required this.deletedAt,
    required this.opportunityFindAddress,
    required this.opportunityFindLog,
    required this.opportunityFindActivity,
    required this.opportunitySecondarySalesPerson,
    required this.customerName,
    required this.customerPriceType,
    required this.mobile1CountryCode,
    required this.mobile2CountryCode,
    required this.landline,
    required this.isMobile,
    required this.stateName,
    required this.cityName,
    required this.pincodeName,
    required this.salesPersonName,
    required this.assignedByName,
    required this.companyName,
    required this.locationName,
    required this.contactPersonId,
    required this.productCategory,
  });

  factory OpportunityFindData.fromJson(Map<String, dynamic> json) => OpportunityFindData(
    id: json["id"]?.toString() ?? "",
    tenantId: json["tenant_id"]?.toString() ?? "",
    opportunityName: json["opportunity_name"]?.toString() ?? "",
    customerId: json["customer_id"]?.toString() ?? "",
    productIds: _parseList(json["product_ids"]),
    expectedAmount: json["expected_amount"]?.toString() ?? "",
    probability: json["probability"]?.toString() ?? "",
    probabilityId: json["probability_id"]?.toString() ?? "",
    email: json["email"]?.toString() ?? "",
    personName: json["person_name"]?.toString() ?? "",
    mobile1: json["mobile1"]?.toString() ?? "",
    mobile2: json["mobile2"]?.toString() ?? "",
    address: json["address"]?.toString() ?? "",
    isBulkRequirement: json["is_bulk_requirement"] == true,
    cityId: json["city_id"]?.toString() ?? "",
    pincodeId: json["pincode_id"]?.toString() ?? "",
    stateId: json["state_id"]?.toString() ?? "",
    sourceId: json["source_id"]?.toString() ?? "",
    labelId: json["label_id"]?.toString() ?? "",
    salesPersonId: json["sales_person_id"]?.toString() ?? "",
    expectedClosingDate: json["expected_closing_date"]?.toString() ?? "",
    isAssigned: json["is_assigned"] == true,
    assignedBy: json["assigned_by"]?.toString() ?? "",
    assignedAt: json["assigned_at"]?.toString() ?? "",
    tags: _parseList(json["tags"]),
    remarks: json["remarks"]?.toString() ?? "",
    interest: json["interest"]?.toString() ?? "",
    sectionId: json["section_id"]?.toString() ?? "",
    sectionName: json["section_name"]?.toString() ?? "",
    createdBy: json["created_by"]?.toString() ?? "",
    updatedBy: json["updated_by"]?.toString() ?? "",
    createdAt: json["created_at"]?.toString() ?? "",
    updatedAt: json["updated_at"]?.toString() ?? "",
    companyId: json["company_id"]?.toString() ?? "",
    companyCode: json["company_code"]?.toString() ?? "",
    finYear: json["fin_year"]?.toString() ?? "",
    locationId: json["location_id"]?.toString() ?? "",
    locationCode: json["location_code"]?.toString() ?? "",
    isDeleted: json["is_deleted"] == true,
    deletedAt: json["deleted_at"]?.toString() ?? "",
    opportunityFindAddress: (json["addresses"] is List ? json["addresses"] : json["opportunityFindAddresses"]) is List
        ? ((json["addresses"] ?? json["opportunityFindAddresses"]) as List)
              .map<OpportunityFindAddress>((x) => OpportunityFindAddress.fromJson(x))
              .toList()
        : [],
    opportunityFindLog: (json["logs"] is List ? json["logs"] : json["opportunityFindLogs"]) is List
        ? ((json["logs"] ?? json["opportunityFindLogs"]) as List).map<OpportunityFindLog>((x) => OpportunityFindLog.fromJson(x)).toList()
        : [],
    opportunityFindActivity: (json["activities"] is List ? json["activities"] : json["opportunityFindActivities"]) is List
        ? ((json["activities"] ?? json["opportunityFindActivities"]) as List)
              .map<OpportunityFindActivity>((x) => OpportunityFindActivity.fromJson(x))
              .toList()
        : [],
    opportunitySecondarySalesPerson: json["secondary_sales_persons"] is List
        ? (json["secondary_sales_persons"] as List).map<OpportunitySecondarySalesPerson>((x) => OpportunitySecondarySalesPerson.fromJson(x)).toList()
        : [],
    customerName: json["customer_name"]?.toString() ?? "",
    customerPriceType: json["customer_price_type"]?.toString() ?? "",
    mobile1CountryCode: json["mobile1_country_code"]?.toString() ?? "",
    mobile2CountryCode: json["mobile2_country_code"]?.toString() ?? "",
    landline: json["landline"]?.toString() ?? "",
    isMobile: json["is_mobile"] == true,
    stateName: json["state_name"]?.toString() ?? "",
    cityName: json["city_name"]?.toString() ?? "",
    pincodeName: json["pincode_name"]?.toString() ?? "",
    salesPersonName: json["sales_person_name"]?.toString() ?? "",
    assignedByName: json["assigned_by_name"]?.toString() ?? "",
    companyName: json["company_name"]?.toString() ?? "",
    locationName: json["location_name"]?.toString() ?? "",
    contactPersonId: json["contact_person_id"]?.toString() ?? "",
    productCategory: _parseList(json["product_category"]),
  );

  static List<String> _parseList(dynamic value) {
    if (value == null) return [];
    if (value is List) return List<String>.from(value.map((x) => x.toString()));
    if (value is String) {
      if (value.isEmpty) return [];
      if (value.startsWith("[") && value.endsWith("]")) {
        try {
          var decoded = json.decode(value);
          if (decoded is List) return List<String>.from(decoded.map((x) => x.toString()));
        } catch (e) {
          // Fall through to comma split
        }
      }
      return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return [value.toString()];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "opportunity_name": opportunityName,
    "customer_id": customerId,
    "product_ids": productIds,
    "expected_amount": expectedAmount,
    "probability": probability,
    "probability_id": probabilityId,
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
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "remarks": remarks,
    "interest": interest,
    "section_id": sectionId,
    "section_name": sectionName,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "company_id": companyId,
    "company_code": companyCode,
    "fin_year": finYear,
    "location_id": locationId,
    "location_code": locationCode,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "opportunityFindAddresses": opportunityFindAddress.map((e) => e.toJson()).toList(),
    "opportunityFindLogs": opportunityFindLog.map((e) => e.toJson()).toList(),
    "opportunityFindActivities": opportunityFindActivity.map((e) => e.toJson()).toList(),
    "OpportunitySecondary_sales_persons": opportunitySecondarySalesPerson.map((x) => x.toJson()).toList(),
    "customer_name": customerName,
    "customer_price_type": customerPriceType,
    "mobile1_country_code": mobile1CountryCode,
    "mobile2_country_code": mobile2CountryCode,
    "landline": landline,
    "is_mobile": isMobile,
    "state_name": stateName,
    "city_name": cityName,
    "pincode_name": pincodeName,
    "sales_person_name": salesPersonName,
    "assigned_by_name": assignedByName,
    "company_name": companyName,
    "location_name": locationName,
    "contact_person_id": contactPersonId,
    "product_category": productCategory,
  };
}

class OpportunitySecondarySalesPerson {
  final String? id;
  final String? userId;
  final User? user;
  final String? assignedBy;
  final String? assignedByName;
  final String? createdAt;

  OpportunitySecondarySalesPerson({this.id, this.userId, this.user, this.assignedBy, this.assignedByName, this.createdAt});

  factory OpportunitySecondarySalesPerson.fromJson(Map<String, dynamic> json) => OpportunitySecondarySalesPerson(
    id: json["id"]?.toString() ?? "",
    userId: json["user_id"]?.toString() ?? "",
    user: json["user"] != null ? User.fromJson(json["user"]) : User(),
    assignedBy: json["assigned_by"]?.toString() ?? "",
    assignedByName: json["assigned_by_name"]?.toString() ?? "",
    createdAt: json["created_at"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "user": user!.toJson(),
    "assigned_by": assignedBy,
    "assigned_by_name": assignedByName,
    "created_at": createdAt,
  };
}

class User {
  final String? id;
  final String? name;
  final String? email;

  User({this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"]?.toString() ?? "", name: json["name"]?.toString() ?? "", email: json["email"]?.toString() ?? "");

  Map<String, dynamic> toJson() => {"id": id, "name": name, "email": email};
}

class OpportunityFindActivity {
  final String id;
  final String tenant;
  final String activityType;
  final String activityStatus;
  final String invitationStatus;
  final String callMedium;
  final String subject;
  final String description;
  final String startTime;
  final String endTime;
  final String locationId;
  final String link;
  final String createdBy;
  final String followUpDate;
  final String reminderTime;
  final bool isReminderSent;
  final String createdAt;
  final String updatedAt;
  final String updatedBy;
  final String companyId;
  final String companyCode;
  final String finYear;
  final String locationCode;
  final bool isDeleted;
  final String deletedAt;
  final List<dynamic> invitees;
  final String activityTypeName;
  final String createdByName;

  OpportunityFindActivity({
    required this.id,
    required this.tenant,
    required this.activityType,
    required this.activityStatus,
    required this.invitationStatus,
    required this.callMedium,
    required this.subject,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.locationId,
    required this.link,
    required this.createdBy,
    required this.followUpDate,
    required this.reminderTime,
    required this.isReminderSent,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
    required this.companyId,
    required this.companyCode,
    required this.finYear,
    required this.locationCode,
    required this.isDeleted,
    required this.deletedAt,
    required this.invitees,
    required this.activityTypeName,
    required this.createdByName,
  });

  factory OpportunityFindActivity.fromJson(Map<String, dynamic> json) => OpportunityFindActivity(
    id: json["id"]?.toString() ?? "",
    tenant: json["tenant"]?.toString() ?? "",
    activityType: json["activity_type"]?.toString() ?? "",
    activityStatus: json["activity_status"]?.toString() ?? "",
    invitationStatus: json["invitation_status"]?.toString() ?? "",
    callMedium: json["call_medium"]?.toString() ?? "",
    subject: json["subject"]?.toString() ?? "",
    description: json["description"]?.toString() ?? "",
    startTime: json["start_time"]?.toString() ?? "",
    endTime: json["end_time"]?.toString() ?? "",
    locationId: json["location_id"]?.toString() ?? "",
    link: json["link"]?.toString() ?? "",
    createdBy: json["created_by"]?.toString() ?? "",
    followUpDate: json["follow_up_date"]?.toString() ?? "",
    reminderTime: json["reminder_time"]?.toString() ?? "",
    isReminderSent: json["is_reminder_sent"] == true,
    createdAt: json["created_at"]?.toString() ?? "",
    updatedAt: json["updated_at"]?.toString() ?? "",
    updatedBy: json["updated_by"]?.toString() ?? "",
    companyId: json["company_id"]?.toString() ?? "",
    companyCode: json["company_code"]?.toString() ?? "",
    finYear: json["fin_year"]?.toString() ?? "",
    locationCode: json["location_code"]?.toString() ?? "",
    isDeleted: json["is_deleted"] == true,
    deletedAt: json["deleted_at"]?.toString() ?? "",
    invitees: json["invitees"] is List ? List<dynamic>.from(json["invitees"].map((x) => x)) : [],
    activityTypeName: json["activity_type_name"]?.toString() ?? "",
    createdByName: json["created_by_name"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant": tenant,
    "activity_type": activityType,
    "activity_status": activityStatus,
    "invitation_status": invitationStatus,
    "call_medium": callMedium,
    "subject": subject,
    "description": description,
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
    "invitees": List<dynamic>.from(invitees.map((x) => x)),
    "activity_type_name": activityTypeName,
    "created_by_name": createdByName,
  };
}

class OpportunityFindAddress {
  final String id;
  final String type;
  final String contactName;
  final String companyName;
  final String email;
  final String mobile1;
  final String mobile2;
  final String street;
  final String cityId;
  final String stateId;
  final String pincodeId;
  final String countryId;
  final String designation;
  final String remarks;
  final bool isActive;
  final String tenantId;
  final String customerId;
  final String createdBy;
  final String updatedBy;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;
  final String deletedAt;
  final String stateName;
  final String cityName;
  final String pincodeName;

  OpportunityFindAddress({
    required this.id,
    required this.type,
    required this.contactName,
    required this.companyName,
    required this.email,
    required this.mobile1,
    required this.mobile2,
    required this.street,
    required this.cityId,
    required this.stateId,
    required this.pincodeId,
    required this.countryId,
    required this.designation,
    required this.remarks,
    required this.isActive,
    required this.tenantId,
    required this.customerId,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.deletedAt,
    required this.stateName,
    required this.cityName,
    required this.pincodeName,
  });

  factory OpportunityFindAddress.fromJson(Map<String, dynamic> json) => OpportunityFindAddress(
    id: json["id"]?.toString() ?? "",
    type: json["type"]?.toString() ?? "",
    contactName: json["contact_name"]?.toString() ?? "",
    companyName: json["company_name"]?.toString() ?? "",
    email: json["email"]?.toString() ?? "",
    mobile1: json["mobile_1"]?.toString() ?? json["mobile1"]?.toString() ?? "",
    mobile2: json["mobile_2"]?.toString() ?? json["mobile2"]?.toString() ?? "",
    street: json["street"]?.toString() ?? "",
    cityId: json["city_id"]?.toString() ?? "",
    stateId: json["state_id"]?.toString() ?? "",
    pincodeId: json["pincode_id"]?.toString() ?? "",
    countryId: json["country_id"]?.toString() ?? "",
    designation: json["designation"]?.toString() ?? "",
    remarks: json["remarks"]?.toString() ?? "",
    isActive: json["is_active"] == true,
    tenantId: json["tenant_id"]?.toString() ?? "",
    customerId: json["customer_id"]?.toString() ?? "",
    createdBy: json["created_by"]?.toString() ?? "",
    updatedBy: json["updated_by"]?.toString() ?? "",
    createdAt: json["created_at"]?.toString() ?? "",
    updatedAt: json["updated_at"]?.toString() ?? "",
    isDeleted: json["is_deleted"] == true,
    deletedAt: json["deleted_at"]?.toString() ?? "",
    stateName: json["state_name"]?.toString() ?? "",
    cityName: json["city_name"]?.toString() ?? "",
    pincodeName: json["pincode_name"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "contact_name": contactName,
    "company_name": companyName,
    "email": email,
    "mobile_1": mobile1,
    "mobile_2": mobile2,
    "street": street,
    "city_id": cityId,
    "state_id": stateId,
    "pincode_id": pincodeId,
    "country_id": countryId,
    "designation": designation,
    "remarks": remarks,
    "is_active": isActive,
    "tenant_id": tenantId,
    "customer_id": customerId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "state_name": stateName,
    "city_name": cityName,
    "pincode_name": pincodeName,
  };
}

class OpportunityFindLog {
  final String id;
  final String entityType;
  final String entityId;
  final String parentType;
  final String parentId;
  final String rootType;
  final String rootId;
  final String notes;
  final String logType;
  final Metadata metadata;
  final List<String> attachmentUrl;
  final String createdBy;
  final String tenantId;
  final String createdAt;
  final String createdByName;

  OpportunityFindLog({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.parentType,
    required this.parentId,
    required this.rootType,
    required this.rootId,
    required this.notes,
    required this.logType,
    required this.metadata,
    required this.attachmentUrl,
    required this.createdBy,
    required this.tenantId,
    required this.createdAt,
    required this.createdByName,
  });

  factory OpportunityFindLog.fromJson(Map<String, dynamic> json) => OpportunityFindLog(
    id: json["id"]?.toString() ?? "",
    entityType: json["entity_type"]?.toString() ?? "",
    entityId: json["entity_id"]?.toString() ?? "",
    parentType: json["parent_type"]?.toString() ?? "",
    parentId: json["parent_id"]?.toString() ?? "",
    rootType: json["root_type"]?.toString() ?? "",
    rootId: json["root_id"]?.toString() ?? "",
    notes: json["notes"]?.toString() ?? "",
    logType: json["log_type"]?.toString() ?? "",
    metadata: Metadata.fromJson(json["metadata"] ?? {}),
    attachmentUrl: json["attachment_url"] is List ? List<String>.from(json["attachment_url"].map((x) => x.toString())) : [],
    createdBy: json["created_by"]?.toString() ?? "",
    tenantId: json["tenant_id"]?.toString() ?? "",
    createdAt: json["created_at"]?.toString() ?? "",
    createdByName: json["created_by_name"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "entity_type": entityType,
    "entity_id": entityId,
    "parent_type": parentType,
    "parent_id": parentId,
    "root_type": rootType,
    "root_id": rootId,
    "notes": notes,
    "log_type": logType,
    "metadata": metadata.toJson(),
    "attachment_url": List<dynamic>.from(attachmentUrl.map((x) => x)),
    "created_by": createdBy,
    "tenant_id": tenantId,
    "createdAt": createdAt,
    "created_by_name": createdByName,
  };
}

class Metadata {
  final String newStage;
  final String updatedBy;
  final String previousStage;
  final String action;
  final String assignedBy;
  final String assignedTo;
  final String customerName;
  final String endTime;
  final String startTime;
  final String activityId;
  final String createdFrom;
  final String activityType;
  final String reminderDate;

  Metadata({
    required this.newStage,
    required this.updatedBy,
    required this.previousStage,
    required this.action,
    required this.assignedBy,
    required this.assignedTo,
    required this.customerName,
    required this.endTime,
    required this.startTime,
    required this.activityId,
    required this.createdFrom,
    required this.activityType,
    required this.reminderDate,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    newStage: json["new_stage"]?.toString() ?? "",
    updatedBy: json["updated_by"]?.toString() ?? "",
    previousStage: json["previous_stage"]?.toString() ?? "",
    action: json["action"]?.toString() ?? "",
    assignedBy: json["assigned_by"]?.toString() ?? "",
    assignedTo: json["assigned_to"]?.toString() ?? "",
    customerName: json["customer_name"]?.toString() ?? "",
    endTime: json["end_time"]?.toString() ?? "",
    startTime: json["start_time"]?.toString() ?? "",
    activityId: json["activity_id"]?.toString() ?? "",
    createdFrom: json["created_from"]?.toString() ?? "",
    activityType: json["activity_type"]?.toString() ?? "",
    reminderDate: json["reminder_date"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "new_stage": newStage,
    "updated_by": updatedBy,
    "previous_stage": previousStage,
    "action": action,
    "assigned_by": assignedBy,
    "assigned_to": assignedTo,
    "customer_name": customerName,
    "end_time": endTime,
    "start_time": startTime,
    "activity_id": activityId,
    "created_from": createdFrom,
    "activity_type": activityType,
    "reminder_date": reminderDate,
  };
}
