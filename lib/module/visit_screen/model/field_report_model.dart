import 'dart:convert';

FieldReportModel fieldReportModelFromJson(String str) => FieldReportModel.fromJson(json.decode(str));

String fieldReportModelToJson(FieldReportModel data) => json.encode(data.toJson());

class FieldReportModel {
  bool? success;
  String? message;
  FieldReportData? data;
  int? status;
  dynamic error;

  FieldReportModel({
    this.success,
    this.message,
    this.data,
    this.status,
    this.error,
  });

  factory FieldReportModel.fromJson(Map<String, dynamic> json) => FieldReportModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : FieldReportData.fromJson(json["data"]),
        status: json["status"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "status": status,
        "error": error,
      };
}

class FieldReportData {
  String? id;
  String? tenantId;
  String? visitNo;
  String? serviceQueryId;
  String? customerId;
  String? addressId;
  String? visitPurpose;
  dynamic visitPurposeOther;
  DateTime? visitDate;
  DateTime? visitStartDatetime;
  DateTime? visitEndDatetime;
  String? assignedTo;
  List<String>? technicianIds;
  String? primaryTechnicianId;
  String? status;
  String? totalExpense;
  dynamic remark;
  String? visitOutcome;
  String? overallRemark;
  List<String>? attachments;
  String? contactPerson;
  String? mobileCountryCode;
  String? mobile;
  String? siteReceiverName;
  String? siteReceiverMobileCountryCode;
  String? siteReceiverMobile;
  dynamic sparePartQuotationIds;
  dynamic sparePartQuotationAttachments;
  dynamic sparePartProformaIds;
  dynamic sparePartProformaAttachments;
  String? createdBy;
  String? updatedBy;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? complaintNo;
  String? customerName;
  String? complaintTakerName;
  String? complaintTakerId;
  String? visitPurposeName;
  String? statusName;
  String? assignedToName;
  String? createdByName;
  String? primaryTechnicianName;
  String? technicianNames;
  List<Technician>? technicians;
  List<VisitTechnician>? visitTechnicians;
  bool? isTimeDelayed;
  String? advancePaidTotal;
  String? advanceUsedTotal;
  String? advanceReturnedTotal;
  String? advanceBalance;
  bool? canEdit;
  bool? canCancel;
  String? address;
  List<Product>? products;

  FieldReportData({
    this.id,
    this.tenantId,
    this.visitNo,
    this.serviceQueryId,
    this.customerId,
    this.addressId,
    this.visitPurpose,
    this.visitPurposeOther,
    this.visitDate,
    this.visitStartDatetime,
    this.visitEndDatetime,
    this.assignedTo,
    this.technicianIds,
    this.primaryTechnicianId,
    this.status,
    this.totalExpense,
    this.remark,
    this.visitOutcome,
    this.overallRemark,
    this.attachments,
    this.contactPerson,
    this.mobileCountryCode,
    this.mobile,
    this.siteReceiverName,
    this.siteReceiverMobileCountryCode,
    this.siteReceiverMobile,
    this.sparePartQuotationIds,
    this.sparePartQuotationAttachments,
    this.sparePartProformaIds,
    this.sparePartProformaAttachments,
    this.createdBy,
    this.updatedBy,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.complaintNo,
    this.customerName,
    this.complaintTakerName,
    this.complaintTakerId,
    this.visitPurposeName,
    this.statusName,
    this.assignedToName,
    this.createdByName,
    this.primaryTechnicianName,
    this.technicianNames,
    this.technicians,
    this.visitTechnicians,
    this.isTimeDelayed,
    this.advancePaidTotal,
    this.advanceUsedTotal,
    this.advanceReturnedTotal,
    this.advanceBalance,
    this.canEdit,
    this.canCancel,
    this.address,
    this.products,
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
        visitDate: json["visit_date"] == null ? null : DateTime.parse(json["visit_date"]),
        visitStartDatetime: json["visit_start_datetime"] == null ? null : DateTime.parse(json["visit_start_datetime"]),
        visitEndDatetime: json["visit_end_datetime"] == null ? null : DateTime.parse(json["visit_end_datetime"]),
        assignedTo: json["assigned_to"],
        technicianIds: json["technician_ids"] == null ? [] : List<String>.from(json["technician_ids"].map((x) => x)),
        primaryTechnicianId: json["primary_technician_id"],
        status: json["status"],
        totalExpense: json["total_expense"]?.toString(),
        remark: json["remark"],
        visitOutcome: json["visit_outcome"],
        overallRemark: json["overall_remark"],
        attachments: json["attachments"] == null ? [] : List<String>.from(json["attachments"].map((x) => x)),
        contactPerson: json["contact_person"],
        mobileCountryCode: json["mobile_country_code"],
        mobile: json["mobile"],
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
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
        technicians: json["technicians"] == null ? [] : List<Technician>.from(json["technicians"].map((x) => Technician.fromJson(x))),
        visitTechnicians: json["visit_technicians"] == null ? [] : List<VisitTechnician>.from(json["visit_technicians"].map((x) => VisitTechnician.fromJson(x))),
        isTimeDelayed: json["is_time_delayed"],
        advancePaidTotal: json["advance_paid_total"]?.toString(),
        advanceUsedTotal: json["advance_used_total"]?.toString(),
        advanceReturnedTotal: json["advance_returned_total"]?.toString(),
        advanceBalance: json["advance_balance"]?.toString(),
        canEdit: json["can_edit"],
        canCancel: json["can_cancel"],
        address: json["address"],
        products: json["products"] == null ? [] : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
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
        "visit_date": visitDate?.toIso8601String(),
        "visit_start_datetime": visitStartDatetime?.toIso8601String(),
        "visit_end_datetime": visitEndDatetime?.toIso8601String(),
        "assigned_to": assignedTo,
        "technician_ids": technicianIds == null ? [] : List<dynamic>.from(technicianIds!.map((x) => x)),
        "primary_technician_id": primaryTechnicianId,
        "status": status,
        "total_expense": totalExpense,
        "remark": remark,
        "visit_outcome": visitOutcome,
        "overall_remark": overallRemark,
        "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x)),
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
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
        "technicians": technicians == null ? [] : List<dynamic>.from(technicians!.map((x) => x.toJson())),
        "visit_technicians": visitTechnicians == null ? [] : List<dynamic>.from(visitTechnicians!.map((x) => x.toJson())),
        "is_time_delayed": isTimeDelayed,
        "advance_paid_total": advancePaidTotal,
        "advance_used_total": advanceUsedTotal,
        "advance_returned_total": advanceReturnedTotal,
        "advance_balance": advanceBalance,
        "can_edit": canEdit,
        "can_cancel": canCancel,
        "address": address,
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Product {
  String? id;
  String? tenantId;
  String? visitId;
  String? productId;
  String? taxInvoiceId;
  String? taxInvoiceNo;
  int? complaintQty;
  int? installedQty;
  int? clientSideQty;
  int? solveQty;
  String? usageNote;
  String? warrantyType;
  dynamic warrantyTypeOther;
  String? repeatServiceStatus;
  String? issueDescription;
  String? workRemark;
  List<String>? serialNumbers;
  List<dynamic>? attachments;
  String? createdBy;
  String? updatedBy;
  bool? isAddedOnVisit;
  bool? syncedToComplaint;
  String? serviceQueryItemId;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? productCode;
  String? productName;
  String? productImage;
  String? warrantyTypeName;
  String? syncType;
  int? suggestedComplaintQty;
  bool? needsComplaintSync;
  List<dynamic>? partRequests;

  Product({
    this.id,
    this.tenantId,
    this.visitId,
    this.productId,
    this.taxInvoiceId,
    this.taxInvoiceNo,
    this.complaintQty,
    this.installedQty,
    this.clientSideQty,
    this.solveQty,
    this.usageNote,
    this.warrantyType,
    this.warrantyTypeOther,
    this.repeatServiceStatus,
    this.issueDescription,
    this.workRemark,
    this.serialNumbers,
    this.attachments,
    this.createdBy,
    this.updatedBy,
    this.isAddedOnVisit,
    this.syncedToComplaint,
    this.serviceQueryItemId,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.productCode,
    this.productName,
    this.productImage,
    this.warrantyTypeName,
    this.syncType,
    this.suggestedComplaintQty,
    this.needsComplaintSync,
    this.partRequests,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        tenantId: json["tenant_id"],
        visitId: json["visit_id"],
        productId: json["product_id"],
        taxInvoiceId: json["tax_invoice_id"],
        taxInvoiceNo: json["tax_invoice_no"],
        complaintQty: json["complaint_qty"],
        installedQty: json["installed_qty"],
        clientSideQty: json["client_side_qty"],
        solveQty: json["solve_qty"],
        usageNote: json["usage_note"],
        warrantyType: json["warranty_type"],
        warrantyTypeOther: json["warranty_type_other"],
        repeatServiceStatus: json["repeat_service_status"],
        issueDescription: json["issue_description"],
        workRemark: json["work_remark"],
        serialNumbers: json["serial_numbers"] == null ? [] : List<String>.from(json["serial_numbers"].map((x) => x)),
        attachments: json["attachments"] == null ? [] : List<dynamic>.from(json["attachments"].map((x) => x)),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        isAddedOnVisit: json["is_added_on_visit"],
        syncedToComplaint: json["synced_to_complaint"],
        serviceQueryItemId: json["service_query_item_id"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        productCode: json["product_code"],
        productName: json["product_name"],
        productImage: json["product_image"],
        warrantyTypeName: json["warranty_type_name"],
        syncType: json["sync_type"],
        suggestedComplaintQty: json["suggested_complaint_qty"],
        needsComplaintSync: json["needs_complaint_sync"],
        partRequests: json["part_requests"] == null ? [] : List<dynamic>.from(json["part_requests"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "visit_id": visitId,
        "product_id": productId,
        "tax_invoice_id": taxInvoiceId,
        "tax_invoice_no": taxInvoiceNo,
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
        "serial_numbers": serialNumbers == null ? [] : List<dynamic>.from(serialNumbers!.map((x) => x)),
        "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x)),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "is_added_on_visit": isAddedOnVisit,
        "synced_to_complaint": syncedToComplaint,
        "service_query_item_id": serviceQueryItemId,
        "is_deleted": isDeleted,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "product_code": productCode,
        "product_name": productName,
        "product_image": productImage,
        "warranty_type_name": warrantyTypeName,
        "sync_type": syncType,
        "suggested_complaint_qty": suggestedComplaintQty,
        "needs_complaint_sync": needsComplaintSync,
        "part_requests": partRequests == null ? [] : List<dynamic>.from(partRequests!.map((x) => x)),
      };
}

class Technician {
  String? id;
  String? name;
  bool? isPrimary;

  Technician({
    this.id,
    this.name,
    this.isPrimary,
  });

  factory Technician.fromJson(Map<String, dynamic> json) => Technician(
        id: json["id"],
        name: json["name"],
        isPrimary: json["is_primary"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_primary": isPrimary,
      };
}

class VisitTechnician {
  String? id;
  String? userId;
  String? name;
  bool? isPrimary;
  String? fieldStatus;
  DateTime? assignedAt;
  DateTime? startedAt;
  String? startLatitude;
  String? startLongitude;
  DateTime? stoppedAt;
  String? stopLatitude;
  String? stopLongitude;
  String? remark;
  int? activeDurationSeconds;
  int? elapsedSeconds;
  bool? canStart;
  bool? isCurrentUser;
  List<TrackingLog>? trackingLogs;

  VisitTechnician({
    this.id,
    this.userId,
    this.name,
    this.isPrimary,
    this.fieldStatus,
    this.assignedAt,
    this.startedAt,
    this.startLatitude,
    this.startLongitude,
    this.stoppedAt,
    this.stopLatitude,
    this.stopLongitude,
    this.remark,
    this.activeDurationSeconds,
    this.elapsedSeconds,
    this.canStart,
    this.isCurrentUser,
    this.trackingLogs,
  });

  factory VisitTechnician.fromJson(Map<String, dynamic> json) => VisitTechnician(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        isPrimary: json["is_primary"],
        fieldStatus: json["field_status"],
        assignedAt: json["assigned_at"] == null ? null : DateTime.parse(json["assigned_at"]),
        startedAt: json["started_at"] == null ? null : DateTime.parse(json["started_at"]),
        startLatitude: json["start_latitude"],
        startLongitude: json["start_longitude"],
        stoppedAt: json["stopped_at"] == null ? null : DateTime.parse(json["stopped_at"]),
        stopLatitude: json["stop_latitude"],
        stopLongitude: json["stop_longitude"],
        remark: json["remark"],
        activeDurationSeconds: json["active_duration_seconds"],
        elapsedSeconds: json["elapsed_seconds"],
        canStart: json["can_start"],
        isCurrentUser: json["is_current_user"],
        trackingLogs: json["tracking_logs"] == null ? [] : List<TrackingLog>.from(json["tracking_logs"].map((x) => TrackingLog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "is_primary": isPrimary,
        "field_status": fieldStatus,
        "assigned_at": assignedAt?.toIso8601String(),
        "started_at": startedAt?.toIso8601String(),
        "start_latitude": startLatitude,
        "start_longitude": startLongitude,
        "stopped_at": stoppedAt?.toIso8601String(),
        "stop_latitude": stopLatitude,
        "stop_longitude": stopLongitude,
        "remark": remark,
        "active_duration_seconds": activeDurationSeconds,
        "elapsed_seconds": elapsedSeconds,
        "can_start": canStart,
        "is_current_user": isCurrentUser,
        "tracking_logs": trackingLogs == null ? [] : List<dynamic>.from(trackingLogs!.map((x) => x.toJson())),
      };
}

class TrackingLog {
  String? id;
  String? visitId;
  String? userId;
  String? action;
  String? latitude;
  String? longitude;
  String? remark;
  DateTime? createdAt;

  TrackingLog({
    this.id,
    this.visitId,
    this.userId,
    this.action,
    this.latitude,
    this.longitude,
    this.remark,
    this.createdAt,
  });

  factory TrackingLog.fromJson(Map<String, dynamic> json) => TrackingLog(
        id: json["id"],
        visitId: json["visit_id"],
        userId: json["user_id"],
        action: json["action"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        remark: json["remark"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visit_id": visitId,
        "user_id": userId,
        "action": action,
        "latitude": latitude,
        "longitude": longitude,
        "remark": remark,
        "created_at": createdAt?.toIso8601String(),
      };
}
