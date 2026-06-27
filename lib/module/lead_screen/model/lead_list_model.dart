import 'dart:convert';

LeadListResponseModel leadListResponseModelFromJson(String str) => LeadListResponseModel.fromJson(json.decode(str));

String leadListResponseModelToJson(LeadListResponseModel data) => json.encode(data.toJson());

class LeadListResponseModel {
  final bool success;
  final String message;
  final List<OpportunityListDatum> leadListData;
  final int status;
  final dynamic error;
  final Pagination? pagination;

  LeadListResponseModel({
    required this.success,
    required this.message,
    required this.leadListData,
    required this.status,
    this.error,
    this.pagination,
  });

  factory LeadListResponseModel.fromJson(Map<String, dynamic> json) {
    return LeadListResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      leadListData: json["data"] == null
          ? <OpportunityListDatum>[]
          : List<OpportunityListDatum>.from(json["data"].map((x) => OpportunityListDatum.fromJson(x))),
      status: json["status"] ?? 0,
      error: json["error"],
      pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(leadListData.map((x) => x.toJson())),
    "status": status,
    "error": error,
    "pagination": pagination?.toJson(),
  };
}

class OpportunityListDatum {
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
  final List<String> tags;
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
  final String salesPersonName;
  final String assignedByName;
  final int quotationCount;

  OpportunityListDatum({
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
    required this.salesPersonName,
    required this.assignedByName,
    required this.quotationCount,
  });

  factory OpportunityListDatum.fromJson(Map<String, dynamic> json) {
    return OpportunityListDatum(
      id: json["id"] ?? "",
      tenantId: json["tenant_id"] ?? "",
      opportunityName: json["opportunity_name"] ?? "",
      customerId: json["customer_id"] ?? "",
      productId: json["product_id"] ?? "",
      expectedAmount: json["expected_amount"]?.toString() ?? "0",
      probability: json["probability"]?.toString() ?? "0",
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
      tags: json["tags"] == null ? <String>[] : List<String>.from(json["tags"].map((x) => x.toString())),
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
      salesPersonName: json["sales_person_name"] ?? "",
      assignedByName: json["assigned_by_name"] ?? "",
      quotationCount: json["quotation_count"] ?? 0,
    );
  }

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
    "sales_person_name": salesPersonName,
    "assigned_by_name": assignedByName,
    "quotation_count": quotationCount,
  };
}

class Pagination {
  final int page;
  final int limit;
  final int totalRecords;
  final int totalPages;

  Pagination({required this.page, required this.limit, required this.totalRecords, required this.totalPages});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(page: json["page"] ?? 1, limit: json["limit"] ?? 10, totalRecords: json["totalRecords"] ?? 0, totalPages: json["totalPages"] ?? 0);
  }

  Map<String, dynamic> toJson() => {"page": page, "limit": limit, "totalRecords": totalRecords, "totalPages": totalPages};
}
