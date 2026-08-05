// import 'dart:convert';
//
// FieldReportModel fieldReportModelFromJson(String str) => FieldReportModel.fromJson(json.decode(str));
//
// String fieldReportModelToJson(FieldReportModel data) => json.encode(data.toJson());
//
// class FieldReportModel {
//   bool success;
//   String message;
//   FieldReportData? data;
//   int status;
//   dynamic error;
//
//   FieldReportModel({required this.success, required this.message, required this.data, required this.status, required this.error});
//
//   factory FieldReportModel.fromJson(Map<String, dynamic> json) => FieldReportModel(
//     success: json["success"],
//     message: json["message"],
//     data: FieldReportData.fromJson(json["data"]),
//     status: json["status"],
//     error: json["error"],
//   );
//
//   Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data!.toJson(), "status": status, "error": error};
// }
//
// class FieldReportData {
//   String id;
//   String tenantId;
//   String visitNo;
//   String serviceQueryId;
//   String customerId;
//   String addressId;
//   String visitPurpose;
//   dynamic visitPurposeOther;
//   DateTime visitDate;
//   DateTime visitStartDatetime;
//   DateTime visitEndDatetime;
//   String assignedTo;
//   List<String> technicianIds;
//   String primaryTechnicianId;
//   String status;
//   String totalExpense;
//   dynamic remark;
//   dynamic visitOutcome;
//   dynamic overallRemark;
//   dynamic crowdNote;
//   dynamic attachments;
//   String contactPerson;
//   String mobileCountryCode;
//   String mobile;
//   dynamic siteReceiverName;
//   dynamic siteReceiverMobileCountryCode;
//   dynamic siteReceiverMobile;
//   dynamic sparePartQuotationIds;
//   dynamic sparePartQuotationAttachments;
//   dynamic sparePartProformaIds;
//   dynamic sparePartProformaAttachments;
//   String createdBy;
//   String updatedBy;
//   bool isDeleted;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String complaintNo;
//   String customerName;
//   String complaintTakerName;
//   String complaintTakerId;
//   String visitPurposeName;
//   String statusName;
//   String assignedToName;
//   String createdByName;
//   String primaryTechnicianName;
//   String technicianNames;
//   List<Technician> technicians;
//   List<VisitTechnician> visitTechnicians;
//   bool isTimeDelayed;
//   String advancePaidTotal;
//   String advanceUsedTotal;
//   String advanceReturnedTotal;
//   String advanceBalance;
//   bool canEdit;
//   bool canCancel;
//   bool canEditFieldReport;
//   String address;
//   List<Product> products;
//
//   FieldReportData({
//     required this.id,
//     required this.tenantId,
//     required this.visitNo,
//     required this.serviceQueryId,
//     required this.customerId,
//     required this.addressId,
//     required this.visitPurpose,
//     required this.visitPurposeOther,
//     required this.visitDate,
//     required this.visitStartDatetime,
//     required this.visitEndDatetime,
//     required this.assignedTo,
//     required this.technicianIds,
//     required this.primaryTechnicianId,
//     required this.status,
//     required this.totalExpense,
//     required this.remark,
//     required this.visitOutcome,
//     required this.overallRemark,
//     required this.crowdNote,
//     required this.attachments,
//     required this.contactPerson,
//     required this.mobileCountryCode,
//     required this.mobile,
//     required this.siteReceiverName,
//     required this.siteReceiverMobileCountryCode,
//     required this.siteReceiverMobile,
//     required this.sparePartQuotationIds,
//     required this.sparePartQuotationAttachments,
//     required this.sparePartProformaIds,
//     required this.sparePartProformaAttachments,
//     required this.createdBy,
//     required this.updatedBy,
//     required this.isDeleted,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.complaintNo,
//     required this.customerName,
//     required this.complaintTakerName,
//     required this.complaintTakerId,
//     required this.visitPurposeName,
//     required this.statusName,
//     required this.assignedToName,
//     required this.createdByName,
//     required this.primaryTechnicianName,
//     required this.technicianNames,
//     required this.technicians,
//     required this.visitTechnicians,
//     required this.isTimeDelayed,
//     required this.advancePaidTotal,
//     required this.advanceUsedTotal,
//     required this.advanceReturnedTotal,
//     required this.advanceBalance,
//     required this.canEdit,
//     required this.canCancel,
//     required this.canEditFieldReport,
//     required this.address,
//     required this.products,
//   });
//
//   factory FieldReportData.fromJson(Map<String, dynamic> json) => FieldReportData(
//     id: json["id"],
//     tenantId: json["tenant_id"],
//     visitNo: json["visit_no"],
//     serviceQueryId: json["service_query_id"],
//     customerId: json["customer_id"],
//     addressId: json["address_id"],
//     visitPurpose: json["visit_purpose"],
//     visitPurposeOther: json["visit_purpose_other"],
//     visitDate: DateTime.parse(json["visit_date"]),
//     visitStartDatetime: DateTime.parse(json["visit_start_datetime"]),
//     visitEndDatetime: DateTime.parse(json["visit_end_datetime"]),
//     assignedTo: json["assigned_to"],
//     technicianIds: List<String>.from(json["technician_ids"].map((x) => x)),
//     primaryTechnicianId: json["primary_technician_id"],
//     status: json["status"],
//     totalExpense: json["total_expense"],
//     remark: json["remark"],
//     visitOutcome: json["visit_outcome"],
//     overallRemark: json["overall_remark"],
//     crowdNote: json["crowd_note"],
//     attachments: json["attachments"],
//     contactPerson: json["contact_person"],
//     mobileCountryCode: json["mobile_country_code"],
//     mobile: json["mobile"],
//     siteReceiverName: json["site_receiver_name"],
//     siteReceiverMobileCountryCode: json["site_receiver_mobile_country_code"],
//     siteReceiverMobile: json["site_receiver_mobile"],
//     sparePartQuotationIds: json["spare_part_quotation_ids"],
//     sparePartQuotationAttachments: json["spare_part_quotation_attachments"],
//     sparePartProformaIds: json["spare_part_proforma_ids"],
//     sparePartProformaAttachments: json["spare_part_proforma_attachments"],
//     createdBy: json["created_by"],
//     updatedBy: json["updated_by"],
//     isDeleted: json["is_deleted"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     complaintNo: json["complaint_no"],
//     customerName: json["customer_name"],
//     complaintTakerName: json["complaint_taker_name"],
//     complaintTakerId: json["complaint_taker_id"],
//     visitPurposeName: json["visit_purpose_name"],
//     statusName: json["status_name"],
//     assignedToName: json["assigned_to_name"],
//     createdByName: json["created_by_name"],
//     primaryTechnicianName: json["primary_technician_name"],
//     technicianNames: json["technician_names"],
//     technicians: List<Technician>.from(json["technicians"].map((x) => Technician.fromJson(x))),
//     visitTechnicians: List<VisitTechnician>.from(json["visit_technicians"].map((x) => VisitTechnician.fromJson(x))),
//     isTimeDelayed: json["is_time_delayed"],
//     advancePaidTotal: json["advance_paid_total"],
//     advanceUsedTotal: json["advance_used_total"],
//     advanceReturnedTotal: json["advance_returned_total"],
//     advanceBalance: json["advance_balance"],
//     canEdit: json["can_edit"],
//     canCancel: json["can_cancel"],
//     canEditFieldReport: json["can_edit_field_report"],
//     address: json["address"],
//     products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "tenant_id": tenantId,
//     "visit_no": visitNo,
//     "service_query_id": serviceQueryId,
//     "customer_id": customerId,
//     "address_id": addressId,
//     "visit_purpose": visitPurpose,
//     "visit_purpose_other": visitPurposeOther,
//     "visit_date": visitDate.toIso8601String(),
//     "visit_start_datetime": visitStartDatetime.toIso8601String(),
//     "visit_end_datetime": visitEndDatetime.toIso8601String(),
//     "assigned_to": assignedTo,
//     "technician_ids": List<dynamic>.from(technicianIds.map((x) => x)),
//     "primary_technician_id": primaryTechnicianId,
//     "status": status,
//     "total_expense": totalExpense,
//     "remark": remark,
//     "visit_outcome": visitOutcome,
//     "overall_remark": overallRemark,
//     "crowd_note": crowdNote,
//     "attachments": attachments,
//     "contact_person": contactPerson,
//     "mobile_country_code": mobileCountryCode,
//     "mobile": mobile,
//     "site_receiver_name": siteReceiverName,
//     "site_receiver_mobile_country_code": siteReceiverMobileCountryCode,
//     "site_receiver_mobile": siteReceiverMobile,
//     "spare_part_quotation_ids": sparePartQuotationIds,
//     "spare_part_quotation_attachments": sparePartQuotationAttachments,
//     "spare_part_proforma_ids": sparePartProformaIds,
//     "spare_part_proforma_attachments": sparePartProformaAttachments,
//     "created_by": createdBy,
//     "updated_by": updatedBy,
//     "is_deleted": isDeleted,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "complaint_no": complaintNo,
//     "customer_name": customerName,
//     "complaint_taker_name": complaintTakerName,
//     "complaint_taker_id": complaintTakerId,
//     "visit_purpose_name": visitPurposeName,
//     "status_name": statusName,
//     "assigned_to_name": assignedToName,
//     "created_by_name": createdByName,
//     "primary_technician_name": primaryTechnicianName,
//     "technician_names": technicianNames,
//     "technicians": List<dynamic>.from(technicians.map((x) => x.toJson())),
//     "visit_technicians": List<dynamic>.from(visitTechnicians.map((x) => x.toJson())),
//     "is_time_delayed": isTimeDelayed,
//     "advance_paid_total": advancePaidTotal,
//     "advance_used_total": advanceUsedTotal,
//     "advance_returned_total": advanceReturnedTotal,
//     "advance_balance": advanceBalance,
//     "can_edit": canEdit,
//     "can_cancel": canCancel,
//     "can_edit_field_report": canEditFieldReport,
//     "address": address,
//     "products": List<dynamic>.from(products.map((x) => x.toJson())),
//   };
// }
//
// class Product {
//   String id;
//   String tenantId;
//   String visitId;
//   String productId;
//   dynamic taxInvoiceId;
//   String taxInvoiceNo;
//   dynamic taxInvoiceDate;
//   int complaintQty;
//   int installedQty;
//   int clientSideQty;
//   int solveQty;
//   String usageNote;
//   String warrantyType;
//   dynamic warrantyTypeOther;
//   String repeatServiceStatus;
//   String issueDescription;
//   String workRemark;
//   List<String> serialNumbers;
//   List<String> attachments;
//   String createdBy;
//   String updatedBy;
//   bool isAddedOnVisit;
//   bool syncedToComplaint;
//   String serviceQueryItemId;
//   bool isDeleted;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String productCode;
//   String productName;
//   String productImage;
//   String warrantyTypeName;
//   String syncType;
//   int suggestedComplaintQty;
//   bool needsComplaintSync;
//   List<dynamic> partRequests;
// //
//   Product({
//     required this.id,
//     required this.tenantId,
//     required this.visitId,
//     required this.productId,
//     required this.taxInvoiceId,
//     required this.taxInvoiceNo,
//     required this.taxInvoiceDate,
//     required this.complaintQty,
//     required this.installedQty,
//     required this.clientSideQty,
//     required this.solveQty,
//     required this.usageNote,
//     required this.warrantyType,
//     required this.warrantyTypeOther,
//     required this.repeatServiceStatus,
//     required this.issueDescription,
//     required this.workRemark,
//     required this.serialNumbers,
//     required this.attachments,
//     required this.createdBy,
//     required this.updatedBy,
//     required this.isAddedOnVisit,
//     required this.syncedToComplaint,
//     required this.serviceQueryItemId,
//     required this.isDeleted,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.productCode,
//     required this.productName,
//     required this.productImage,
//     required this.warrantyTypeName,
//     required this.syncType,
//     required this.suggestedComplaintQty,
//     required this.needsComplaintSync,
//     required this.partRequests,
// //   });
//
//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//     id: json["id"],
//     tenantId: json["tenant_id"],
//     visitId: json["visit_id"],
//     productId: json["product_id"],
//     taxInvoiceId: json["tax_invoice_id"],
//     taxInvoiceNo: json["tax_invoice_no"],
//     taxInvoiceDate: json["tax_invoice_date"],
//     complaintQty: json["complaint_qty"],
//     installedQty: json["installed_qty"],
//     clientSideQty: json["client_side_qty"],
//     solveQty: json["solve_qty"],
//     usageNote: json["usage_note"],
//     warrantyType: json["warranty_type"],
//     warrantyTypeOther: json["warranty_type_other"],
//     repeatServiceStatus: json["repeat_service_status"],
//     issueDescription: json["issue_description"],
//     workRemark: json["work_remark"],
//     serialNumbers: List<String>.from(json["serial_numbers"].map((x) => x)),
//     attachments: List<String>.from(json["attachments"].map((x) => x)),
//     createdBy: json["created_by"],
//     updatedBy: json["updated_by"],
//     isAddedOnVisit: json["is_added_on_visit"],
//     syncedToComplaint: json["synced_to_complaint"],
//     serviceQueryItemId: json["service_query_item_id"],
//     isDeleted: json["is_deleted"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     productCode: json["product_code"],
//     productName: json["product_name"],
//     productImage: json["product_image"],
//     warrantyTypeName: json["warranty_type_name"],
//     syncType: json["sync_type"],
//     suggestedComplaintQty: json["suggested_complaint_qty"],
//     needsComplaintSync: json["needs_complaint_sync"],
//     partRequests: List<dynamic>.from(json["part_requests"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "tenant_id": tenantId,
//     "visit_id": visitId,
//     "product_id": productId,
//     "tax_invoice_id": taxInvoiceId,
//     "tax_invoice_no": taxInvoiceNo,
//     "tax_invoice_date": taxInvoiceDate,
//     "complaint_qty": complaintQty,
//     "installed_qty": installedQty,
//     "client_side_qty": clientSideQty,
//     "solve_qty": solveQty,
//     "usage_note": usageNote,
//     "warranty_type": warrantyType,
//     "warranty_type_other": warrantyTypeOther,
//     "repeat_service_status": repeatServiceStatus,
//     "issue_description": issueDescription,
//     "work_remark": workRemark,
//     "serial_numbers": List<dynamic>.from(serialNumbers.map((x) => x)),
//     "attachments": List<dynamic>.from(attachments.map((x) => x)),
//     "created_by": createdBy,
//     "updated_by": updatedBy,
//     "is_added_on_visit": isAddedOnVisit,
//     "synced_to_complaint": syncedToComplaint,
//     "service_query_item_id": serviceQueryItemId,
//     "is_deleted": isDeleted,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "product_code": productCode,
//     "product_name": productName,
//     "product_image": productImage,
//     "warranty_type_name": warrantyTypeName,
//     "sync_type": syncType,
//     "suggested_complaint_qty": suggestedComplaintQty,
//     "needs_complaint_sync": needsComplaintSync,
//     "part_requests": List<dynamic>.from(partRequests.map((x) => x)),
//   };
// }
//
// class Technician {
//   String id;
//   String name;
//   bool isPrimary;
//
//   Technician({required this.id, required this.name, required this.isPrimary});
//
//   factory Technician.fromJson(Map<String, dynamic> json) => Technician(id: json["id"], name: json["name"], isPrimary: json["is_primary"]);
//
//   Map<String, dynamic> toJson() => {"id": id, "name": name, "is_primary": isPrimary};
// }
//
// class VisitTechnician {
//   String id;
//   String userId;
//   String name;
//   bool isPrimary;
//   String fieldStatus;
//   DateTime assignedAt;
//   DateTime? reachedAt;
//   String? reachedLatitude;
//   String? reachedLongitude;
//   List<String> reachedAttachments;
//   dynamic startedAt;
//   dynamic startLatitude;
//   dynamic startLongitude;
//   dynamic stoppedAt;
//   dynamic stopLatitude;
//   dynamic stopLongitude;
//   dynamic remark;
//   int activeDurationSeconds;
//   int elapsedSeconds;
//   bool canReachAtSite;
//   bool canStart;
//   bool isCurrentUser;
//   List<TrackingLog> trackingLogs;
//
//   VisitTechnician({
//     required this.id,
//     required this.userId,
//     required this.name,
//     required this.isPrimary,
//     required this.fieldStatus,
//     required this.assignedAt,
//     required this.reachedAt,
//     required this.reachedLatitude,
//     required this.reachedLongitude,
//     required this.reachedAttachments,
//     required this.startedAt,
//     required this.startLatitude,
//     required this.startLongitude,
//     required this.stoppedAt,
//     required this.stopLatitude,
//     required this.stopLongitude,
//     required this.remark,
//     required this.activeDurationSeconds,
//     required this.elapsedSeconds,
//     required this.canReachAtSite,
//     required this.canStart,
//     required this.isCurrentUser,
//     required this.trackingLogs,
//   });
//
//   factory VisitTechnician.fromJson(Map<String, dynamic> json) => VisitTechnician(
//     id: json["id"],
//     userId: json["user_id"],
//     name: json["name"],
//     isPrimary: json["is_primary"],
//     fieldStatus: json["field_status"],
//     assignedAt: DateTime.parse(json["assigned_at"]),
//     reachedAt: json["reached_at"] == null ? null : DateTime.parse(json["reached_at"]),
//     reachedLatitude: json["reached_latitude"],
//     reachedLongitude: json["reached_longitude"],
//     reachedAttachments: List<String>.from(json["reached_attachments"].map((x) => x)),
//     startedAt: json["started_at"],
//     startLatitude: json["start_latitude"],
//     startLongitude: json["start_longitude"],
//     stoppedAt: json["stopped_at"],
//     stopLatitude: json["stop_latitude"],
//     stopLongitude: json["stop_longitude"],
//     remark: json["remark"],
//     activeDurationSeconds: json["active_duration_seconds"],
//     elapsedSeconds: json["elapsed_seconds"],
//     canReachAtSite: json["can_reach_at_site"],
//     canStart: json["can_start"],
//     isCurrentUser: json["is_current_user"],
//     trackingLogs: List<TrackingLog>.from(json["tracking_logs"].map((x) => TrackingLog.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "user_id": userId,
//     "name": name,
//     "is_primary": isPrimary,
//     "field_status": fieldStatus,
//     "assigned_at": assignedAt.toIso8601String(),
//     "reached_at": reachedAt?.toIso8601String(),
//     "reached_latitude": reachedLatitude,
//     "reached_longitude": reachedLongitude,
//     "reached_attachments": List<dynamic>.from(reachedAttachments.map((x) => x)),
//     "started_at": startedAt,
//     "start_latitude": startLatitude,
//     "start_longitude": startLongitude,
//     "stopped_at": stoppedAt,
//     "stop_latitude": stopLatitude,
//     "stop_longitude": stopLongitude,
//     "remark": remark,
//     "active_duration_seconds": activeDurationSeconds,
//     "elapsed_seconds": elapsedSeconds,
//     "can_reach_at_site": canReachAtSite,
//     "can_start": canStart,
//     "is_current_user": isCurrentUser,
//     "tracking_logs": List<dynamic>.from(trackingLogs.map((x) => x.toJson())),
//   };
// }
//
// class TrackingLog {
//   String id;
//   String visitId;
//   String userId;
//   String action;
//   String latitude;
//   String longitude;
//   dynamic remark;
//   List<String> attachments;
//   DateTime createdAt;
//
//   TrackingLog({
//     required this.id,
//     required this.visitId,
//     required this.userId,
//     required this.action,
//     required this.latitude,
//     required this.longitude,
//     required this.remark,
//     required this.attachments,
//     required this.createdAt,
//   });
//
//   factory TrackingLog.fromJson(Map<String, dynamic> json) => TrackingLog(
//     id: json["id"],
//     visitId: json["visit_id"],
//     userId: json["user_id"],
//     action: json["action"],
//     latitude: json["latitude"],
//     longitude: json["longitude"],
//     remark: json["remark"],
//     attachments: List<String>.from(json["attachments"].map((x) => x)),
//     createdAt: DateTime.parse(json["created_at"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "visit_id": visitId,
//     "user_id": userId,
//     "action": action,
//     "latitude": latitude,
//     "longitude": longitude,
//     "remark": remark,
//     "attachments": List<dynamic>.from(attachments.map((x) => x)),
//     "created_at": createdAt.toIso8601String(),
//   };
// }
// To parse this JSON data, do
//
//     final fieldReportModel = fieldReportModelFromJson(jsonString);

import 'dart:convert';

FieldReportModel fieldReportModelFromJson(String str) => FieldReportModel.fromJson(json.decode(str));

String fieldReportModelToJson(FieldReportModel data) => json.encode(data.toJson());

class FieldReportModel {
  bool success;
  String message;
  FieldReportData data;
  int status;
  dynamic error;

  FieldReportModel({required this.success, required this.message, required this.data, required this.status, required this.error});

  factory FieldReportModel.fromJson(Map<String, dynamic> json) => FieldReportModel(
    success: json["success"],
    message: json["message"],
    data: FieldReportData.fromJson(json["data"]),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data.toJson(), "status": status, "error": error};
}

class FieldReportData {
  String id;
  String tenantId;
  String visitNo;
  String serviceQueryId;
  String customerId;
  String addressId;
  String visitPurpose;
  dynamic visitPurposeOther;
  DateTime visitDate;
  DateTime visitStartDatetime;
  DateTime visitEndDatetime;
  String assignedTo;
  List<String> technicianIds;
  String primaryTechnicianId;
  String status;
  String totalExpense;
  String remark;
  dynamic visitOutcome;
  dynamic overallRemark;
  dynamic crowdNote;
  dynamic attachments;
  String contactPerson;
  String mobileCountryCode;
  String mobile;
  dynamic siteReceiverName;
  dynamic siteReceiverMobileCountryCode;
  dynamic siteReceiverMobile;
  dynamic sparePartQuotationIds;
  dynamic sparePartQuotationAttachments;
  dynamic sparePartProformaIds;
  dynamic sparePartProformaAttachments;
  String createdBy;
  String updatedBy;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  String complaintNo;
  String customerName;
  String complaintTakerName;
  String complaintTakerId;
  String visitPurposeName;
  String statusName;
  String assignedToName;
  String createdByName;
  String primaryTechnicianName;
  String technicianNames;
  List<Technician> technicians;
  List<VisitTechnician> visitTechnicians;
  bool isTimeDelayed;
  String advancePaidTotal;
  String advanceUsedTotal;
  String advanceReturnedTotal;
  String advanceBalance;
  bool canEdit;
  bool canCancel;
  bool canEditFieldReport;
  String address;
  List<Product> products;

  FieldReportData({
    required this.id,
    required this.tenantId,
    required this.visitNo,
    required this.serviceQueryId,
    required this.customerId,
    required this.addressId,
    required this.visitPurpose,
    required this.visitPurposeOther,
    required this.visitDate,
    required this.visitStartDatetime,
    required this.visitEndDatetime,
    required this.assignedTo,
    required this.technicianIds,
    required this.primaryTechnicianId,
    required this.status,
    required this.totalExpense,
    required this.remark,
    required this.visitOutcome,
    required this.overallRemark,
    required this.crowdNote,
    required this.attachments,
    required this.contactPerson,
    required this.mobileCountryCode,
    required this.mobile,
    required this.siteReceiverName,
    required this.siteReceiverMobileCountryCode,
    required this.siteReceiverMobile,
    required this.sparePartQuotationIds,
    required this.sparePartQuotationAttachments,
    required this.sparePartProformaIds,
    required this.sparePartProformaAttachments,
    required this.createdBy,
    required this.updatedBy,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.complaintNo,
    required this.customerName,
    required this.complaintTakerName,
    required this.complaintTakerId,
    required this.visitPurposeName,
    required this.statusName,
    required this.assignedToName,
    required this.createdByName,
    required this.primaryTechnicianName,
    required this.technicianNames,
    required this.technicians,
    required this.visitTechnicians,
    required this.isTimeDelayed,
    required this.advancePaidTotal,
    required this.advanceUsedTotal,
    required this.advanceReturnedTotal,
    required this.advanceBalance,
    required this.canEdit,
    required this.canCancel,
    required this.canEditFieldReport,
    required this.address,
    required this.products,
  });

  factory FieldReportData.fromJson(Map<String, dynamic> json) => FieldReportData(
    id: json["id"],
    tenantId: json["tenant_id"],
    visitNo: json["visit_no"],
    serviceQueryId: json["service_query_id"],
    customerId: json["customer_id"],
    addressId: json["address_id"],
    visitPurpose: json["visit_purpose"],
    visitPurposeOther: json["visit_purpose_other"],
    visitDate: json["visit_date"] == null ? DateTime.now() : DateTime.parse(json["visit_date"]),
    visitStartDatetime: json["visit_start_datetime"] == null ? DateTime.now() : DateTime.parse(json["visit_start_datetime"]),
    visitEndDatetime: json["visit_end_datetime"] == null ? DateTime.now() : DateTime.parse(json["visit_end_datetime"]),
    assignedTo: json["assigned_to"] ?? "",
    technicianIds: json["technician_ids"] == null ? <String>[] : List<String>.from(json["technician_ids"].map((x) => x.toString())),
    primaryTechnicianId: json["primary_technician_id"] ?? "",
    status: json["status"] ?? "",
    totalExpense: json["total_expense"] ?? "",
    remark: json["remark"] ?? "",
    visitOutcome: json["visit_outcome"],
    overallRemark: json["overall_remark"],
    crowdNote: json["crowd_note"],
    attachments: json["attachments"],
    contactPerson: json["contact_person"] ?? "",
    mobileCountryCode: json["mobile_country_code"] ?? "",
    mobile: json["mobile"] ?? "",
    siteReceiverName: json["site_receiver_name"],
    siteReceiverMobileCountryCode: json["site_receiver_mobile_country_code"],
    siteReceiverMobile: json["site_receiver_mobile"],
    sparePartQuotationIds: json["spare_part_quotation_ids"],
    sparePartQuotationAttachments: json["spare_part_quotation_attachments"],
    sparePartProformaIds: json["spare_part_proforma_ids"],
    sparePartProformaAttachments: json["spare_part_proforma_attachments"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    isDeleted: json["is_deleted"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    complaintNo: json["complaint_no"],
    customerName: json["customer_name"],
    complaintTakerName: json["complaint_taker_name"],
    complaintTakerId: json["complaint_taker_id"],
    visitPurposeName: json["visit_purpose_name"],
    statusName: json["status_name"],
    assignedToName: json["assigned_to_name"],
    createdByName: json["created_by_name"],
    primaryTechnicianName: json["primary_technician_name"],
    technicianNames: json["technician_names"],
    technicians: json["technicians"] == null ? <Technician>[] : List<Technician>.from(json["technicians"].map((x) => Technician.fromJson(x))),
    visitTechnicians: json["visit_technicians"] == null
        ? <VisitTechnician>[]
        : List<VisitTechnician>.from(json["visit_technicians"].map((x) => VisitTechnician.fromJson(x))),
    isTimeDelayed: json["is_time_delayed"],
    advancePaidTotal: json["advance_paid_total"],
    advanceUsedTotal: json["advance_used_total"],
    advanceReturnedTotal: json["advance_returned_total"],
    advanceBalance: json["advance_balance"],
    canEdit: json["can_edit"],
    canCancel: json["can_cancel"],
    canEditFieldReport: json["can_edit_field_report"] ?? false,
    address: json["address"] ?? "",
    products: json["products"] == null ? <Product>[] : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "visit_no": visitNo,
    "service_query_id": serviceQueryId,
    "customer_id": customerId,
    "address_id": addressId,
    "visit_purpose": visitPurpose,
    "visit_purpose_other": visitPurposeOther,
    "visit_date": visitDate.toIso8601String(),
    "visit_start_datetime": visitStartDatetime.toIso8601String(),
    "visit_end_datetime": visitEndDatetime.toIso8601String(),
    "assigned_to": assignedTo,
    "technician_ids": List<dynamic>.from(technicianIds.map((x) => x)),
    "primary_technician_id": primaryTechnicianId,
    "status": status,
    "total_expense": totalExpense,
    "remark": remark,
    "visit_outcome": visitOutcome,
    "overall_remark": overallRemark,
    "crowd_note": crowdNote,
    "attachments": attachments,
    "contact_person": contactPerson,
    "mobile_country_code": mobileCountryCode,
    "mobile": mobile,
    "site_receiver_name": siteReceiverName,
    "site_receiver_mobile_country_code": siteReceiverMobileCountryCode,
    "site_receiver_mobile": siteReceiverMobile,
    "spare_part_quotation_ids": sparePartQuotationIds,
    "spare_part_quotation_attachments": sparePartQuotationAttachments,
    "spare_part_proforma_ids": sparePartProformaIds,
    "spare_part_proforma_attachments": sparePartProformaAttachments,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "is_deleted": isDeleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "complaint_no": complaintNo,
    "customer_name": customerName,
    "complaint_taker_name": complaintTakerName,
    "complaint_taker_id": complaintTakerId,
    "visit_purpose_name": visitPurposeName,
    "status_name": statusName,
    "assigned_to_name": assignedToName,
    "created_by_name": createdByName,
    "primary_technician_name": primaryTechnicianName,
    "technician_names": technicianNames,
    "technicians": List<Technician>.from(technicians.map((x) => x.toJson())),
    "visit_technicians": List<VisitTechnician>.from(visitTechnicians.map((x) => x.toJson())),
    "is_time_delayed": isTimeDelayed,
    "advance_paid_total": advancePaidTotal,
    "advance_used_total": advanceUsedTotal,
    "advance_returned_total": advanceReturnedTotal,
    "advance_balance": advanceBalance,
    "can_edit": canEdit,
    "can_cancel": canCancel,
    "can_edit_field_report": canEditFieldReport,
    "address": address,
    "products": List<Product>.from(products.map((x) => x.toJson())),
  };
}

class Product {
  String id;
  String tenantId;
  String visitId;
  String productId;
  String? taxInvoiceId;
  String taxInvoiceNo;
  String? taxInvoiceDate;
  int complaintQty;
  int installedQty;
  int clientSideQty;
  int solveQty;
  String usageNote;
  String warrantyType;
  dynamic warrantyTypeOther;
  String repeatServiceStatus;
  String issueDescription;
  String workRemark;
  List<String> serialNumbers;
  List<dynamic> attachments;
  String createdBy;
  String updatedBy;
  bool isAddedOnVisit;
  bool syncedToComplaint;
  String serviceQueryItemId;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  String productCode;
  String productName;
  String productImage;
  String warrantyTypeName;
  String syncType;
  int suggestedComplaintQty;
  bool needsComplaintSync;
  List<PartRequest> partRequests;
  List<dynamic>? partsAvailable;

  Product({
    required this.id,
    required this.tenantId,
    required this.visitId,
    required this.productId,
    required this.taxInvoiceId,
    required this.taxInvoiceNo,
    required this.taxInvoiceDate,
    required this.complaintQty,
    required this.installedQty,
    required this.clientSideQty,
    required this.solveQty,
    required this.usageNote,
    required this.warrantyType,
    required this.warrantyTypeOther,
    required this.repeatServiceStatus,
    required this.issueDescription,
    required this.workRemark,
    required this.serialNumbers,
    required this.attachments,
    required this.createdBy,
    required this.updatedBy,
    required this.isAddedOnVisit,
    required this.syncedToComplaint,
    required this.serviceQueryItemId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.productCode,
    required this.productName,
    required this.productImage,
    required this.warrantyTypeName,
    required this.syncType,
    required this.suggestedComplaintQty,
    required this.needsComplaintSync,
    required this.partRequests,
    this.partsAvailable,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"] ?? "",
    tenantId: json["tenant_id"] ?? "",
    visitId: json["visit_id"] ?? "",
    productId: json["product_id"] ?? "",
    taxInvoiceId: json["tax_invoice_id"],
    taxInvoiceNo: json["tax_invoice_no"] ?? "",
    taxInvoiceDate: json["tax_invoice_date"]?.toString(),
    complaintQty: json["complaint_qty"] ?? 0,
    installedQty: json["installed_qty"] ?? 0,
    clientSideQty: json["client_side_qty"] ?? 0,
    solveQty: json["solve_qty"] ?? 0,
    usageNote: json["usage_note"] ?? "",
    warrantyType: json["warranty_type"] ?? "",
    warrantyTypeOther: json["warranty_type_other"],
    repeatServiceStatus: json["repeat_service_status"] ?? "",
    issueDescription: json["issue_description"] ?? "",
    workRemark: json["work_remark"] ?? "",
    serialNumbers: json["serial_numbers"] == null ? <String>[] : List<String>.from(json["serial_numbers"].map((x) => x.toString())),
    attachments: json["attachments"] == null ? <dynamic>[] : List<dynamic>.from(json["attachments"].map((x) => x)),
    createdBy: json["created_by"] ?? "",
    updatedBy: json["updated_by"] ?? "",
    isAddedOnVisit: json["is_added_on_visit"] ?? false,
    syncedToComplaint: json["synced_to_complaint"] ?? false,
    serviceQueryItemId: json["service_query_item_id"] ?? "",
    isDeleted: json["is_deleted"] ?? false,
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
    updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
    productCode: json["product_code"] ?? "",
    productName: json["product_name"] ?? "",
    productImage: json["product_image"] ?? "",
    warrantyTypeName: json["warranty_type_name"] ?? "",
    syncType: json["sync_type"] ?? "",
    suggestedComplaintQty: json["suggested_complaint_qty"] ?? 0,
    needsComplaintSync: json["needs_complaint_sync"] ?? false,
    partRequests: json["part_requests"] == null ? <PartRequest>[] : List<PartRequest>.from(json["part_requests"].map((x) => PartRequest.fromJson(x))),
    partsAvailable: json["parts_available"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "visit_id": visitId,
    "product_id": productId,
    "tax_invoice_id": taxInvoiceId,
    "tax_invoice_no": taxInvoiceNo,
    "tax_invoice_date": taxInvoiceDate,
    "complaint_qty": complaintQty,
    "installed_qty": installedQty,
    "client_side_qty": clientSideQty,
    "solve_qty": solveQty,
    "usage_note": usageNote,
    "warranty_type": warrantyType,
    "warranty_type_other": warrantyTypeOther,
    "repeat_service_status": repeatServiceStatus,
    "issue_description": issueDescription,
    "work_remark": workRemark,
    "serial_numbers": List<dynamic>.from(serialNumbers.map((x) => x)),
    "attachments": List<dynamic>.from(attachments.map((x) => x)),
    "created_by": createdBy,
    "updated_by": updatedBy,
    "is_added_on_visit": isAddedOnVisit,
    "synced_to_complaint": syncedToComplaint,
    "service_query_item_id": serviceQueryItemId,
    "is_deleted": isDeleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "product_code": productCode,
    "product_name": productName,
    "product_image": productImage,
    "warranty_type_name": warrantyTypeName,
    "sync_type": syncType,
    "suggested_complaint_qty": suggestedComplaintQty,
    "needs_complaint_sync": needsComplaintSync,
    "part_requests": List<dynamic>.from(partRequests.map((x) => x.toJson())),
    "parts_available": partsAvailable,
  };
}

class PartRequest {
  String id;
  String partName;
  int qty;
  String remark;
  List<String> attachments;
  String status;
  DateTime createdAt;

  PartRequest({
    required this.id,
    required this.partName,
    required this.qty,
    required this.remark,
    required this.attachments,
    required this.status,
    required this.createdAt,
  });

  factory PartRequest.fromJson(Map<String, dynamic> json) => PartRequest(
    id: json["id"] ?? "",
    partName: json["part_name"] ?? "",
    qty: json["qty"] ?? 0,
    remark: json["remark"] ?? "",
    attachments: json["attachments"] == null ? <String>[] : List<String>.from(json["attachments"].map((x) => x.toString())),
    status: json["status"] ?? "",
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "part_name": partName,
    "qty": qty,
    "remark": remark,
    "attachments": List<dynamic>.from(attachments.map((x) => x)),
    "status": status,
    "created_at": createdAt.toIso8601String(),
  };
}

class Technician {
  String id;
  String name;
  bool isPrimary;

  Technician({required this.id, required this.name, required this.isPrimary});

  factory Technician.fromJson(Map<String, dynamic> json) => Technician(id: json["id"], name: json["name"], isPrimary: json["is_primary"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "is_primary": isPrimary};
}

class VisitTechnician {
  String id;
  String userId;
  String name;
  bool isPrimary;
  String fieldStatus;
  DateTime assignedAt;
  DateTime? reachedAt;
  dynamic reachedLatitude;
  dynamic reachedLongitude;
  List<String> reachedAttachments;
  DateTime? startedAt;
  String? startLatitude;
  String? startLongitude;
  DateTime? stoppedAt;
  dynamic stopLatitude;
  dynamic stopLongitude;
  dynamic remark;
  int activeDurationSeconds;
  int elapsedSeconds;
  bool canReachAtSite;
  bool canStart;
  bool isCurrentUser;
  List<TrackingLog> trackingLogs;

  VisitTechnician({
    required this.id,
    required this.userId,
    required this.name,
    required this.isPrimary,
    required this.fieldStatus,
    required this.assignedAt,
    required this.reachedAt,
    required this.reachedLatitude,
    required this.reachedLongitude,
    required this.reachedAttachments,
    required this.startedAt,
    required this.startLatitude,
    required this.startLongitude,
    required this.stoppedAt,
    required this.stopLatitude,
    required this.stopLongitude,
    required this.remark,
    required this.activeDurationSeconds,
    required this.elapsedSeconds,
    required this.canReachAtSite,
    required this.canStart,
    required this.isCurrentUser,
    required this.trackingLogs,
  });

  factory VisitTechnician.fromJson(Map<String, dynamic> json) => VisitTechnician(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    isPrimary: json["is_primary"],
    fieldStatus: json["field_status"],
    assignedAt: DateTime.parse(json["assigned_at"]),
    reachedAt: json["reached_at"] == null ? null : DateTime.parse(json["reached_at"]),
    reachedLatitude: json["reached_latitude"],
    reachedLongitude: json["reached_longitude"],
    reachedAttachments: List<String>.from(json["reached_attachments"].map((x) => x)),
    startedAt: json["started_at"] == null ? null : DateTime.parse(json["started_at"]),
    startLatitude: json["start_latitude"],
    startLongitude: json["start_longitude"],
    stoppedAt: json["stopped_at"] == null ? null : DateTime.parse(json["stopped_at"]),
    stopLatitude: json["stop_latitude"],
    stopLongitude: json["stop_longitude"],
    remark: json["remark"],
    activeDurationSeconds: json["active_duration_seconds"],
    elapsedSeconds: json["elapsed_seconds"],
    canReachAtSite: json["can_reach_at_site"],
    canStart: json["can_start"],
    isCurrentUser: json["is_current_user"],
    trackingLogs: List<TrackingLog>.from(json["tracking_logs"].map((x) => TrackingLog.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "is_primary": isPrimary,
    "field_status": fieldStatus,
    "assigned_at": assignedAt.toIso8601String(),
    "reached_at": reachedAt?.toIso8601String(),
    "reached_latitude": reachedLatitude,
    "reached_longitude": reachedLongitude,
    "reached_attachments": List<dynamic>.from(reachedAttachments.map((x) => x)),
    "started_at": startedAt?.toIso8601String(),
    "start_latitude": startLatitude,
    "start_longitude": startLongitude,
    "stopped_at": stoppedAt?.toIso8601String(),
    "stop_latitude": stopLatitude,
    "stop_longitude": stopLongitude,
    "remark": remark,
    "active_duration_seconds": activeDurationSeconds,
    "elapsed_seconds": elapsedSeconds,
    "can_reach_at_site": canReachAtSite,
    "can_start": canStart,
    "is_current_user": isCurrentUser,
    "tracking_logs": List<dynamic>.from(trackingLogs.map((x) => x.toJson())),
  };
}

class TrackingLog {
  String id;
  String visitId;
  String userId;
  String action;
  String latitude;
  String longitude;
  dynamic remark;
  List<dynamic> attachments;
  DateTime createdAt;

  TrackingLog({
    required this.id,
    required this.visitId,
    required this.userId,
    required this.action,
    required this.latitude,
    required this.longitude,
    required this.remark,
    required this.attachments,
    required this.createdAt,
  });

  factory TrackingLog.fromJson(Map<String, dynamic> json) => TrackingLog(
    id: json["id"],
    visitId: json["visit_id"],
    userId: json["user_id"],
    action: json["action"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    remark: json["remark"],
    attachments: List<dynamic>.from(json["attachments"].map((x) => x)),
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "visit_id": visitId,
    "user_id": userId,
    "action": action,
    "latitude": latitude,
    "longitude": longitude,
    "remark": remark,
    "attachments": List<dynamic>.from(attachments.map((x) => x)),
    "created_at": createdAt.toIso8601String(),
  };
}
