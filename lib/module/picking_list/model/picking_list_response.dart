import 'dart:convert';

PickingListResponse pickingListResponseFromJson(String str) => PickingListResponse.fromJson(json.decode(str));

String pickingListResponseToJson(PickingListResponse data) => json.encode(data.toJson());

class PickingListResponse {
  final bool? success;
  final String? message;
  final List<PickingListDatum>? data;
  final int? status;
  final dynamic error;
  final Pagination? pagination;

  PickingListResponse({this.success, this.message, this.data, this.status, this.error, this.pagination});

  factory PickingListResponse.fromJson(Map<String, dynamic> json) => PickingListResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<PickingListDatum>.from(json["data"].map((x) => PickingListDatum.fromJson(x))),
    status: json["status"],
    error: json["error"],
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status,
    "error": error,
    "pagination": pagination?.toJson(),
  };
}

class PickingListDatum {
  final String? id;
  final String? tenantId;
  final String? pickingNo;
  final String? pickingDate;
  final String? invoiceId;
  final String? pickRequestId;
  final String? customerId;
  final String? warehouseId;
  final String? assignedTo;
  final dynamic assignedAt;
  final String? priority;
  final String? remarks;
  final String? status;
  final dynamic startedAt;
  final String? completedAt;
  final String? createdBy;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;
  final bool? isDeleted;
  final dynamic deletedBy;
  final dynamic deletedAt;
  final String? companyId;
  final String? companyCode;
  final String? finYear;
  final String? locationId;
  final String? locationCode;
  final bool? isViewed;
  final String? customerName;
  final String? invoiceNo;
  final String? invoiceAmount;
  final String? piRemarks;
  final String? salesPerson;
  final String? companyName;
  final String? locationName;
  final String? orderType;

  PickingListDatum({
    this.id,
    this.tenantId,
    this.pickingNo,
    this.pickingDate,
    this.invoiceId,
    this.pickRequestId,
    this.customerId,
    this.warehouseId,
    this.assignedTo,
    this.assignedAt,
    this.priority,
    this.remarks,
    this.status,
    this.startedAt,
    this.completedAt,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deletedBy,
    this.deletedAt,
    this.companyId,
    this.companyCode,
    this.finYear,
    this.locationId,
    this.locationCode,
    this.isViewed,
    this.customerName,
    this.invoiceNo,
    this.invoiceAmount,
    this.piRemarks,
    this.salesPerson,
    this.companyName,
    this.locationName,
    this.orderType,
  });

  factory PickingListDatum.fromJson(Map<String, dynamic> json) => PickingListDatum(
    id: json["id"],
    tenantId: json["tenant_id"],
    pickingNo: json["picking_no"],
    pickingDate: json["picking_date"],
    invoiceId: json["invoice_id"],
    pickRequestId: json["pick_request_id"],
    customerId: json["customer_id"],
    warehouseId: json["warehouse_id"],
    assignedTo: json["assigned_to"],
    assignedAt: json["assigned_at"],
    priority: json["priority"],
    remarks: json["remarks"],
    status: json["status"],
    startedAt: json["started_at"],
    completedAt: json["completed_at"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    isDeleted: json["is_deleted"],
    deletedBy: json["deleted_by"],
    deletedAt: json["deleted_at"],
    companyId: json["company_id"],
    companyCode: json["company_code"],
    finYear: json["fin_year"],
    locationId: json["location_id"],
    locationCode: json["location_code"],
    isViewed: json["is_viewed"],
    customerName: json["customer_name"],
    invoiceNo: json["invoice_no"],
    invoiceAmount: json["invoice_amount"],
    piRemarks: json["pi_remarks"],
    salesPerson: json["sales_person"],
    companyName: json["company_name"],
    locationName: json["location_name"],
    orderType: json["order_type"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "picking_no": pickingNo,
    "picking_date": pickingDate,
    "invoice_id": invoiceId,
    "pick_request_id": pickRequestId,
    "customer_id": customerId,
    "warehouse_id": warehouseId,
    "assigned_to": assignedTo,
    "assigned_at": assignedAt,
    "priority": priority,
    "remarks": remarks,
    "status": status,
    "started_at": startedAt,
    "completed_at": completedAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_deleted": isDeleted,
    "deleted_by": deletedBy,
    "deleted_at": deletedAt,
    "company_id": companyId,
    "company_code": companyCode,
    "fin_year": finYear,
    "location_id": locationId,
    "location_code": locationCode,
    "is_viewed": isViewed,
    "customer_name": customerName,
    "invoice_no": invoiceNo,
    "invoice_amount": invoiceAmount,
    "pi_remarks": piRemarks,
    "sales_person": salesPerson,
    "company_name": companyName,
    "location_name": locationName,
    "order_type": orderType,
  };
}

class Pagination {
  final int? page;
  final int? limit;
  final int? totalRecords;
  final int? totalPages;

  Pagination({this.page, this.limit, this.totalRecords, this.totalPages});

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      Pagination(page: json["page"], limit: json["limit"], totalRecords: json["totalRecords"], totalPages: json["totalPages"]);

  Map<String, dynamic> toJson() => {"page": page, "limit": limit, "totalRecords": totalRecords, "totalPages": totalPages};
}
