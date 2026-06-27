// To parse this JSON data, do
//
//     final pickingListResponseModel = pickingListResponseModelFromJson(jsonString);

import 'dart:convert';

PickingListResponseModel pickingListResponseModelFromJson(String str) => PickingListResponseModel.fromJson(json.decode(str));

String pickingListResponseModelToJson(PickingListResponseModel data) => json.encode(data.toJson());

class PickingListResponseModel {
  final bool? success;
  final String? message;
  final List<PackingList>? data;
  final int? status;
  final dynamic error;
  final Pagination? pagination;
  final List<Status>? statuses;

  PickingListResponseModel({this.success, this.message, this.data, this.status, this.error, this.pagination, this.statuses});

  factory PickingListResponseModel.fromJson(Map<String, dynamic> json) => PickingListResponseModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<PackingList>.from(json["data"]!.map((x) => PackingList.fromJson(x))),
    status: json["status"],
    error: json["error"],
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    statuses: json["statuses"] == null ? [] : List<Status>.from(json["statuses"]!.map((x) => Status.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<PackingList>.from(data!.map((x) => x.toJson())),
    "status": status,
    "error": error,
    "pagination": pagination?.toJson(),
    "statuses": statuses == null ? [] : List<dynamic>.from(statuses!.map((x) => x.toJson())),
  };
}

class PackingList {
  final String? id;
  final String? tenantId;
  final String? pickingNo;
  final DateTime? pickingDate;
  final String? invoiceId;
  final String? pickRequestId;
  final String? customerId;
  final String? warehouseId;
  final String? assignedTo;
  final DateTime? assignedAt;
  final String? priority;
  final String? remarks;
  final String? status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;
  final String? deletedBy;
  final DateTime? deletedAt;
  final String? companyId;
  final String? companyCode;
  final String? finYear;
  final String? locationId;
  final String? locationCode;
  final bool? isViewed;
  final String? customerName;
  final String? invoiceNo;
  final String? tax_invoice_no;
  final String? invoiceAmount;
  final String? piRemarks;
  final String? salesPerson;
  final String? companyName;
  final String? locationName;
  final String? packingNo;
  final int? totalPackages;
  final bool? isRegularInvoiceApproved;
  final bool? isPackingDetailSaved;
  final bool? isDCFlow;
  final DateTime? packingDate;
  final String? spMarks;
  final String? advanceAmount;
  final String? pickingId;
  final String? packedBy;
  final DateTime? packedAt;
  final String? totalWeight;
  final String? totalVolume;
  final String? rejectionReason;
  final String? rejectedBy;
  final DateTime? rejectedAt;
  final String? transportMode;
  final String? transporterId;
  final bool? isManualTransporter;
  final String? transporterName;
  final String? vehicleNo;
  final String? lrNo;
  final DateTime? lrDate;
  final String? driverName;
  final String? driverContact;
  final String? transportRemarks;
  final String? ewayBillNo;
  final String? transporterGstin;
  final String? transporterPan;
  final bool? isRequiredEwaybill;
  final String? dispatchStatus;
  final String? dispatchNo;

  PackingList({
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
    this.tax_invoice_no,
    this.invoiceAmount,
    this.piRemarks,
    this.salesPerson,
    this.companyName,
    this.locationName,
    this.packingNo,
    this.totalPackages,
    this.isRegularInvoiceApproved,
    this.packingDate,
    this.spMarks,
    this.advanceAmount,
    this.isPackingDetailSaved,
    this.isDCFlow,
    this.pickingId,
    this.packedBy,
    this.packedAt,
    this.totalWeight,
    this.totalVolume,
    this.rejectionReason,
    this.rejectedBy,
    this.rejectedAt,
    this.transportMode,
    this.transporterId,
    this.isManualTransporter,
    this.transporterName,
    this.vehicleNo,
    this.lrNo,
    this.lrDate,
    this.driverName,
    this.driverContact,
    this.transportRemarks,
    this.ewayBillNo,
    this.transporterGstin,
    this.transporterPan,
    this.isRequiredEwaybill,
    this.dispatchStatus,
    this.dispatchNo,
  });

  factory PackingList.fromJson(Map<String, dynamic> json) => PackingList(
    id: json["id"],
    tenantId: json["tenant_id"],
    pickingNo: json["picking_no"],
    pickingDate: json["picking_date"] == null ? null : DateTime.parse(json["picking_date"]),
    invoiceId: json["invoice_id"],
    pickRequestId: json["pick_request_id"],
    customerId: json["customer_id"],
    warehouseId: json["warehouse_id"],
    assignedTo: json["assigned_to"],
    assignedAt: json["assigned_at"] == null ? null : DateTime.parse(json["assigned_at"]),
    priority: json["priority"],
    remarks: json["remarks"],
    status: json["status"],
    startedAt: json["started_at"] == null ? null : DateTime.parse(json["started_at"]),
    completedAt: json["completed_at"] == null ? null : DateTime.parse(json["completed_at"]),
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isDeleted: json["is_deleted"],
    deletedBy: json["deleted_by"],
    deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
    companyId: json["company_id"],
    companyCode: json["company_code"],
    finYear: json["fin_year"],
    locationId: json["location_id"],
    locationCode: json["location_code"],
    isViewed: json["is_viewed"],
    customerName: json["customer_name"],
    invoiceNo: json["invoice_no"],
    tax_invoice_no: json['tax_invoice_no'],
    invoiceAmount: json["invoice_amount"],
    piRemarks: json["pi_remarks"],
    salesPerson: json["sales_person"],
    companyName: json["company_name"],
    locationName: json["location_name"],
    packingNo: json["packing_no"],
    totalPackages: json["total_packages"],
    isRegularInvoiceApproved: json["is_regular_invoice_approved"],
    isPackingDetailSaved: json["is_packing_detail_saved"],
    isDCFlow: json["is_dc_flow"],
    packingDate: json["packing_date"] == null ? null : DateTime.tryParse(json["packing_date"].toString()),
    spMarks: json["sp_marks"],
    advanceAmount: json["advance_amount"],
    pickingId: json["picking_id"],
    packedBy: json["packed_by"],
    packedAt: json["packed_at"] == null ? null : DateTime.tryParse(json["packed_at"].toString()),
    totalWeight: json["total_weight"],
    totalVolume: json["total_volume"],
    rejectionReason: json["rejection_reason"],
    rejectedBy: json["rejected_by"],
    rejectedAt: json["rejected_at"] == null ? null : DateTime.tryParse(json["rejected_at"].toString()),
    transportMode: json["transport_mode"],
    transporterId: json["transporter_id"],
    isManualTransporter: json["is_manual_transporter"],
    transporterName: json["transporter_name"],
    vehicleNo: json["vehicle_no"],
    lrNo: json["lr_no"],
    lrDate: json["lr_date"] == null ? null : DateTime.tryParse(json["lr_date"].toString()),
    driverName: json["driver_name"],
    driverContact: json["driver_contact"],
    transportRemarks: json["transport_remarks"],
    ewayBillNo: json["eway_bill_no"],
    transporterGstin: json["transporter_gstin"],
    transporterPan: json["transporter_pan"],
    isRequiredEwaybill: json["is_required_ewaybill"],
    dispatchStatus: json["dispatch_status"],
    dispatchNo: json["dispatch_no"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "picking_no": pickingNo,
    "picking_date":
        "${pickingDate!.year.toString().padLeft(4, '0')}-${pickingDate!.month.toString().padLeft(2, '0')}-${pickingDate!.day.toString().padLeft(2, '0')}",
    "invoice_id": invoiceId,
    "pick_request_id": pickRequestId,
    "customer_id": customerId,
    "warehouse_id": warehouseId,
    "assigned_to": assignedTo,
    "assigned_at": assignedAt?.toIso8601String(),
    "priority": priority,
    "remarks": remarks,
    "status": status,
    "started_at": startedAt?.toIso8601String(),
    "completed_at": completedAt?.toIso8601String(),
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_deleted": isDeleted,
    "deleted_by": deletedBy,
    "deleted_at": deletedAt?.toIso8601String(),
    "company_id": companyId,
    "company_code": companyCode,
    "fin_year": finYear,
    "location_id": locationId,
    "location_code": locationCode,
    "is_viewed": isViewed,
    "customer_name": customerName,
    "invoice_no": invoiceNo,
    "tax_invoice_no": tax_invoice_no,
    "invoice_amount": invoiceAmount,
    "pi_remarks": piRemarks,
    "sales_person": salesPerson,
    "company_name": companyName,
    "location_name": locationName,
    "packing_no": packingNo,
    "total_packages": totalPackages,
    "is_regular_invoice_approved": isRegularInvoiceApproved,
    "is_packing_detail_saved": isPackingDetailSaved,
    "is_dc_flow": isDCFlow,
    "packing_date": packingDate?.toIso8601String(),
    "sp_marks": spMarks,
    "advance_amount": advanceAmount,
    "picking_id": pickingId,
    "packed_by": packedBy,
    "packed_at": packedAt?.toIso8601String(),
    "total_weight": totalWeight,
    "total_volume": totalVolume,
    "rejection_reason": rejectionReason,
    "rejected_by": rejectedBy,
    "rejected_at": rejectedAt?.toIso8601String(),
    "transport_mode": transportMode,
    "transporter_id": transporterId,
    "is_manual_transporter": isManualTransporter,
    "transporter_name": transporterName,
    "vehicle_no": vehicleNo,
    "lr_no": lrNo,
    "lr_date": lrDate?.toIso8601String(),
    "driver_name": driverName,
    "driver_contact": driverContact,
    "transport_remarks": transportRemarks,
    "eway_bill_no": ewayBillNo,
    "transporter_gstin": transporterGstin,
    "transporter_pan": transporterPan,
    "is_required_ewaybill": isRequiredEwaybill,
    "dispatch_status": dispatchStatus,
    "dispatch_no": dispatchNo,
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

class Status {
  final String? name;
  final String? displayName;
  final String? color;

  Status({this.name, this.displayName, this.color});

  factory Status.fromJson(Map<String, dynamic> json) => Status(name: json["name"], displayName: json["display_name"], color: json["color"]);

  Map<String, dynamic> toJson() => {"name": name, "display_name": displayName, "color": color};
}
