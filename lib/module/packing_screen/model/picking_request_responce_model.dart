// To parse this JSON data, do
//
//     final pickingRequestResponseModel = pickingRequestResponseModelFromJson(jsonString);

import 'dart:convert';

PickingRequestResponseModel pickingRequestResponseModelFromJson(String str) => PickingRequestResponseModel.fromJson(json.decode(str));

String pickingRequestResponseModelToJson(PickingRequestResponseModel data) => json.encode(data.toJson());

class PickingRequestResponseModel {
  bool? success;
  String? message;
  PickingRequestData? data;
  int? status;
  dynamic error;

  PickingRequestResponseModel({this.success, this.message, this.data, this.status, this.error});

  factory PickingRequestResponseModel.fromJson(Map<String, dynamic> json) => PickingRequestResponseModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : PickingRequestData.fromJson(json["data"]),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data?.toJson(), "status": status, "error": error};
}

class PickingRequestData {
  String? id;
  String? tenantId;
  String? pickingNo;
  DateTime? requestDate;
  String? invoiceId;
  String? customerId;
  dynamic warehouseId;
  String? priority;
  String? remarks;
  String? status;
  String? approvedBy;
  DateTime? approvedAt;
  String? rejectedBy;
  DateTime? rejectedAt;
  String? rejectionReason;
  dynamic processedBy;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isDeleted;
  dynamic deletedBy;
  dynamic deletedAt;
  String? companyId;
  String? companyCode;
  String? finYear;
  String? locationId;
  String? locationCode;
  bool? isViewed;
  List<Item>? items;
  String? updatedByName;
  String? approvedByName;
  String? rejectedByName;
  Customer? customer;
  Invoice? invoice;
  List<Log>? logs;
  String? companyName;
  String? locationName;

  PickingRequestData({
    this.id,
    this.tenantId,
    this.pickingNo,
    this.requestDate,
    this.invoiceId,
    this.customerId,
    this.warehouseId,
    this.priority,
    this.remarks,
    this.status,
    this.approvedBy,
    this.approvedAt,
    this.rejectedBy,
    this.rejectedAt,
    this.rejectionReason,
    this.processedBy,
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
    this.items,
    this.updatedByName,
    this.approvedByName,
    this.rejectedByName,
    this.customer,
    this.invoice,
    this.logs,
    this.companyName,
    this.locationName,
  });

  factory PickingRequestData.fromJson(Map<String, dynamic> json) => PickingRequestData(
    id: json["id"],
    tenantId: json["tenant_id"],
    pickingNo: json["picking_no"],
    requestDate: json["request_date"] == null ? null : DateTime.tryParse(json["request_date"]),
    invoiceId: json["invoice_id"],
    customerId: json["customer_id"],
    warehouseId: json["warehouse_id"],
    priority: json["priority"],
    remarks: json["remarks"],
    status: json["status"],
    approvedBy: json["approved_by"],
    approvedAt: json["approved_at"] == null ? null : DateTime.tryParse(json["approved_at"]),
    rejectedBy: json["rejected_by"],
    rejectedAt: json["rejected_at"] == null ? null : DateTime.tryParse(json["rejected_at"]),
    rejectionReason: json["rejection_reason"],
    processedBy: json["processed_by"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"]),
    isDeleted: json["is_deleted"],
    deletedBy: json["deleted_by"],
    deletedAt: json["deleted_at"],
    companyId: json["company_id"],
    companyCode: json["company_code"],
    finYear: json["fin_year"],
    locationId: json["location_id"],
    locationCode: json["location_code"],
    isViewed: json["is_viewed"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    updatedByName: json["updated_by_name"],
    approvedByName: json["approved_by_name"],
    rejectedByName: json["rejected_by_name"],
    customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    invoice: json["invoice"] == null ? null : Invoice.fromJson(json["invoice"]),
    logs: json["logs"] == null ? [] : List<Log>.from(json["logs"].map((x) => Log.fromJson(x))),
    companyName: json["company_name"],
    locationName: json["location_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "picking_no": pickingNo,
    "request_date": requestDate?.toIso8601String(),
    "invoice_id": invoiceId,
    "customer_id": customerId,
    "warehouse_id": warehouseId,
    "priority": priority,
    "remarks": remarks,
    "status": status,
    "approved_by": approvedBy,
    "approved_at": approvedAt?.toIso8601String(),
    "rejected_by": rejectedBy,
    "rejected_at": rejectedAt?.toIso8601String(),
    "rejection_reason": rejectionReason,
    "processed_by": processedBy,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_deleted": isDeleted,
    "deleted_by": deletedBy,
    "deleted_at": deletedAt,
    "company_id": companyId,
    "company_code": companyCode,
    "fin_year": finYear,
    "location_id": locationId,
    "location_code": locationCode,
    "is_viewed": isViewed,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "updated_by_name": updatedByName,
    "approved_by_name": approvedByName,
    "rejected_by_name": rejectedByName,
    "customer": customer?.toJson(),
    "invoice": invoice?.toJson(),
    "logs": logs == null ? [] : List<dynamic>.from(logs!.map((x) => x.toJson())),
    "company_name": companyName,
    "location_name": locationName,
  };
}

class Customer {
  String? id;
  String? companyName;
  String? mobile1;
  dynamic email;

  Customer({this.id, this.companyName, this.mobile1, this.email});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      Customer(id: json["id"], companyName: json["company_name"], mobile1: json["mobile1"], email: json["email"]);

  Map<String, dynamic> toJson() => {"id": id, "company_name": companyName, "mobile1": mobile1, "email": email};
}

class Invoice {
  String? id;
  String? tenantId;
  String? invoiceNo;
  String? invoiceType;
  dynamic parentInvoiceId;
  dynamic stockLocationId;
  String? collectionType;
  String? quotationId;
  String? customerId;
  DateTime? invoiceDate;
  DateTime? dueDate;
  String? subtotal;
  String? taxAmount;
  String? discountAmount;
  String? totalAmount;
  String? paidAmount;
  String? balanceAmount;
  String? billingAddress;
  String? shippingAddress;
  String? paymentStatus;
  String? deliveryStatus;
  String? status;
  dynamic remarks;
  dynamic termsConditions;
  String? paymentTerms;
  String? createdBy;
  String? updatedBy;
  bool? isDeleted;
  bool? isApproval;
  String? approvalStatus;
  dynamic approvedBy;
  String? approvalRemarks;
  bool? isPiApproved;
  String? piApprovedBy;
  String? advanceReceived;
  String? netPayable;
  bool? isAdvancePaymentTerm;
  int? advancePaymentsCount;
  dynamic transporterId;
  dynamic stockApprovalId;
  bool? isStockApproved;
  dynamic packingId;
  dynamic ewayBillNo;
  bool? isConfirmed;
  dynamic confirmedBy;
  String? attachments;
  bool? isRequiredEwaybill;
  String? companyId;
  String? companyCode;
  String? finYear;
  String? locationId;
  String? locationCode;
  String? receiverName;
  String? receiverMobileNumber;
  String? receiverCountryCode;
  DateTime? poDate;
  String? poNumber;
  String? gstTreatmentId;
  String? creditRequestStatus;
  String? email;
  String? collectionTypeId;
  String? opportunityId;
  String? totalTaxableAmount;
  String? totalTaxAmount;
  String? overallDiscount;
  String? totalChargesAmount;
  String? finalTotalAmount;
  String? totalCgstAmount;
  String? totalSgstAmount;
  String? totalIgstAmount;
  bool? isPostedForPi;
  String? postedForPiBy;
  dynamic finYearInt;
  dynamic vehicleNo;
  String? advanceAmount;
  String? advanceAttachment;
  String? priority;
  bool? isExport;
  dynamic currencyId;
  String? exchangeRate;
  dynamic exportType;
  dynamic shippingBillNo;
  dynamic shippingBillDate;
  dynamic portOfLoading;
  dynamic portOfDischarge;
  dynamic vesselFlightNo;
  dynamic destinationCountryId;
  String? creditAttachment;
  String? creditRemark;
  dynamic ewayPdfUrl;
  dynamic irn;
  dynamic einvoicePdfUrl;
  String? totalBeforeDiscountAmount;
  dynamic transporterGstin;
  dynamic transporterName;
  String? transportMode;
  dynamic lrNo;
  dynamic driverName;
  dynamic driverContact;
  dynamic transportRemarks;
  String? transportModeId;
  String? overallDiscountAmount;
  String? totalDiscount;
  String? totalReturnedQty;
  String? totalReturnedAmount;
  bool? hasReturns;
  bool? isMigrated;
  dynamic migrationSource;
  dynamic migrationBatchId;
  bool? isAccounted;
  dynamic taxInvoiceId;
  dynamic taxInvoiceNo;
  dynamic dcId;
  dynamic dcNo;
  bool? isDcFlow;
  dynamic customerRemark;
  dynamic gstCategoryCodeKey;
  String? roundOff;
  bool? isEwayCancelled;
  dynamic ewayCancelledBy;
  dynamic ewayCancelRemarks;
  bool? isIrnCancelled;
  dynamic irnCancelledBy;
  dynamic irnCancelRemarks;
  bool? isCancelled;
  dynamic cancelledBy;
  dynamic cancelledTiRef;
  dynamic cancelledAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic approvedAt;
  dynamic piApprovedAt;
  dynamic postedForPiAt;
  dynamic confirmedAt;
  dynamic piAutoCancelAt;
  dynamic ewayCancelledAt;
  dynamic irnCancelledAt;
  dynamic piTypeId;
  dynamic piType;
  dynamic siteVisitRemark;
  dynamic siteVisitAttachment;
  bool? isSalesMigrated;
  dynamic outstandingRemarks;
  bool? isSaleReturnTaxInvoice;
  dynamic saleReturnId;
  dynamic salesMigAmount;
  String? averageDiscountRate;
  String? averageDiscountAmount;
  String? otherAdjSettledAmount;
  String? otherAdjInvoiceWriteOffAmount;
  dynamic stockBookingValidUntil;
  dynamic piCancelRemarks;
  dynamic stockBookingApprovalId;
  bool? isStockBookingApproved;
  String? totalExtraMarginAmount;
  String? totalEffectiveDiscountAmount;
  dynamic receiverDocumentTypeId;
  dynamic receiverDocumentType;
  dynamic receiverDocumentTypeCodeKey;
  dynamic discountRequestStatus;
  dynamic balancePast;
  dynamic totalPast;
  dynamic taxPast;
  dynamic revisedFromPiId;
  dynamic supersededByPiId;
  bool? isGstConsolidation;
  dynamic consolidationStatus;
  dynamic consolidatedIntoInvoiceId;
  dynamic consolidationBatchId;
  String? paidType;
  String? customerName;
  String? customerMobile;
  dynamic customerEmail;
  IngAddressDetails? billingAddressDetails;
  IngAddressDetails? shippingAddressDetails;
  String? paymentTermsName;
  String? createdByName;
  String? updatedByName;
  String? transportModeName;

  Invoice({
    this.id,
    this.tenantId,
    this.invoiceNo,
    this.invoiceType,
    this.parentInvoiceId,
    this.stockLocationId,
    this.collectionType,
    this.quotationId,
    this.customerId,
    this.invoiceDate,
    this.dueDate,
    this.subtotal,
    this.taxAmount,
    this.discountAmount,
    this.totalAmount,
    this.paidAmount,
    this.balanceAmount,
    this.billingAddress,
    this.shippingAddress,
    this.paymentStatus,
    this.deliveryStatus,
    this.status,
    this.remarks,
    this.termsConditions,
    this.paymentTerms,
    this.createdBy,
    this.updatedBy,
    this.isDeleted,
    this.isApproval,
    this.approvalStatus,
    this.approvedBy,
    this.approvalRemarks,
    this.isPiApproved,
    this.piApprovedBy,
    this.advanceReceived,
    this.netPayable,
    this.isAdvancePaymentTerm,
    this.advancePaymentsCount,
    this.transporterId,
    this.stockApprovalId,
    this.isStockApproved,
    this.packingId,
    this.ewayBillNo,
    this.isConfirmed,
    this.confirmedBy,
    this.attachments,
    this.isRequiredEwaybill,
    this.companyId,
    this.companyCode,
    this.finYear,
    this.locationId,
    this.locationCode,
    this.receiverName,
    this.receiverMobileNumber,
    this.receiverCountryCode,
    this.poDate,
    this.poNumber,
    this.gstTreatmentId,
    this.creditRequestStatus,
    this.email,
    this.collectionTypeId,
    this.opportunityId,
    this.totalTaxableAmount,
    this.totalTaxAmount,
    this.overallDiscount,
    this.totalChargesAmount,
    this.finalTotalAmount,
    this.totalCgstAmount,
    this.totalSgstAmount,
    this.totalIgstAmount,
    this.isPostedForPi,
    this.postedForPiBy,
    this.finYearInt,
    this.vehicleNo,
    this.advanceAmount,
    this.advanceAttachment,
    this.priority,
    this.isExport,
    this.currencyId,
    this.exchangeRate,
    this.exportType,
    this.shippingBillNo,
    this.shippingBillDate,
    this.portOfLoading,
    this.portOfDischarge,
    this.vesselFlightNo,
    this.destinationCountryId,
    this.creditAttachment,
    this.creditRemark,
    this.ewayPdfUrl,
    this.irn,
    this.einvoicePdfUrl,
    this.totalBeforeDiscountAmount,
    this.transporterGstin,
    this.transporterName,
    this.transportMode,
    this.lrNo,
    this.driverName,
    this.driverContact,
    this.transportRemarks,
    this.transportModeId,
    this.overallDiscountAmount,
    this.totalDiscount,
    this.totalReturnedQty,
    this.totalReturnedAmount,
    this.hasReturns,
    this.isMigrated,
    this.migrationSource,
    this.migrationBatchId,
    this.isAccounted,
    this.taxInvoiceId,
    this.taxInvoiceNo,
    this.dcId,
    this.dcNo,
    this.isDcFlow,
    this.customerRemark,
    this.gstCategoryCodeKey,
    this.roundOff,
    this.isEwayCancelled,
    this.ewayCancelledBy,
    this.ewayCancelRemarks,
    this.isIrnCancelled,
    this.irnCancelledBy,
    this.irnCancelRemarks,
    this.isCancelled,
    this.cancelledBy,
    this.cancelledTiRef,
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.approvedAt,
    this.piApprovedAt,
    this.postedForPiAt,
    this.confirmedAt,
    this.piAutoCancelAt,
    this.ewayCancelledAt,
    this.irnCancelledAt,
    this.piTypeId,
    this.piType,
    this.siteVisitRemark,
    this.siteVisitAttachment,
    this.isSalesMigrated,
    this.outstandingRemarks,
    this.isSaleReturnTaxInvoice,
    this.saleReturnId,
    this.salesMigAmount,
    this.averageDiscountRate,
    this.averageDiscountAmount,
    this.otherAdjSettledAmount,
    this.otherAdjInvoiceWriteOffAmount,
    this.stockBookingValidUntil,
    this.piCancelRemarks,
    this.stockBookingApprovalId,
    this.isStockBookingApproved,
    this.totalExtraMarginAmount,
    this.totalEffectiveDiscountAmount,
    this.receiverDocumentTypeId,
    this.receiverDocumentType,
    this.receiverDocumentTypeCodeKey,
    this.discountRequestStatus,
    this.balancePast,
    this.totalPast,
    this.taxPast,
    this.revisedFromPiId,
    this.supersededByPiId,
    this.isGstConsolidation,
    this.consolidationStatus,
    this.consolidatedIntoInvoiceId,
    this.consolidationBatchId,
    this.paidType,
    this.customerName,
    this.customerMobile,
    this.customerEmail,
    this.billingAddressDetails,
    this.shippingAddressDetails,
    this.paymentTermsName,
    this.createdByName,
    this.updatedByName,
    this.transportModeName,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    id: json["id"],
    tenantId: json["tenant_id"],
    invoiceNo: json["invoice_no"],
    invoiceType: json["invoice_type"],
    parentInvoiceId: json["parent_invoice_id"],
    stockLocationId: json["stock_location_id"],
    collectionType: json["collection_type"],
    quotationId: json["quotation_id"],
    customerId: json["customer_id"],
    invoiceDate: json["invoice_date"] == null ? null : DateTime.tryParse(json["invoice_date"]),
    dueDate: json["due_date"] == null ? null : DateTime.tryParse(json["due_date"]),
    subtotal: json["subtotal"],
    taxAmount: json["tax_amount"],
    discountAmount: json["discount_amount"],
    totalAmount: json["total_amount"],
    paidAmount: json["paid_amount"],
    balanceAmount: json["balance_amount"],
    billingAddress: json["billing_address"],
    shippingAddress: json["shipping_address"],
    paymentStatus: json["payment_status"],
    deliveryStatus: json["delivery_status"],
    status: json["status"],
    remarks: json["remarks"],
    termsConditions: json["terms_conditions"],
    paymentTerms: json["payment_terms"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    isDeleted: json["is_deleted"],
    isApproval: json["is_approval"],
    approvalStatus: json["approval_status"],
    approvedBy: json["approved_by"],
    approvalRemarks: json["approval_remarks"],
    isPiApproved: json["is_pi_approved"],
    piApprovedBy: json["pi_approved_by"],
    advanceReceived: json["advance_received"],
    netPayable: json["net_payable"],
    isAdvancePaymentTerm: json["is_advance_payment_term"],
    advancePaymentsCount: json["advance_payments_count"],
    transporterId: json["transporter_id"],
    stockApprovalId: json["stock_approval_id"],
    isStockApproved: json["is_stock_approved"],
    packingId: json["packing_id"],
    ewayBillNo: json["eway_bill_no"],
    isConfirmed: json["is_confirmed"],
    confirmedBy: json["confirmed_by"],
    attachments: json["attachments"],
    isRequiredEwaybill: json["is_required_ewaybill"],
    companyId: json["company_id"],
    companyCode: json["company_code"],
    finYear: json["fin_year"],
    locationId: json["location_id"],
    locationCode: json["location_code"],
    receiverName: json["receiver_name"],
    receiverMobileNumber: json["receiver_mobile_number"],
    receiverCountryCode: json["receiver_country_code"],
    poDate: json["po_date"] == null ? null : DateTime.tryParse(json["po_date"]),
    poNumber: json["po_number"],
    gstTreatmentId: json["gst_treatment_id"],
    creditRequestStatus: json["credit_request_status"],
    email: json["email"],
    collectionTypeId: json["collection_type_id"],
    opportunityId: json["opportunity_id"],
    totalTaxableAmount: json["total_taxable_amount"],
    totalTaxAmount: json["total_tax_amount"],
    overallDiscount: json["overall_discount"],
    totalChargesAmount: json["total_charges_amount"],
    finalTotalAmount: json["final_total_amount"],
    totalCgstAmount: json["total_cgst_amount"],
    totalSgstAmount: json["total_sgst_amount"],
    totalIgstAmount: json["total_igst_amount"],
    isPostedForPi: json["is_posted_for_pi"],
    postedForPiBy: json["posted_for_pi_by"],
    finYearInt: json["fin_year_int"],
    vehicleNo: json["vehicle_no"],
    advanceAmount: json["advance_amount"],
    advanceAttachment: json["advance_attachment"],
    priority: json["priority"],
    isExport: json["is_export"],
    currencyId: json["currency_id"],
    exchangeRate: json["exchange_rate"],
    exportType: json["export_type"],
    shippingBillNo: json["shipping_bill_no"],
    shippingBillDate: json["shipping_bill_date"],
    portOfLoading: json["port_of_loading"],
    portOfDischarge: json["port_of_discharge"],
    vesselFlightNo: json["vessel_flight_no"],
    destinationCountryId: json["destination_country_id"],
    creditAttachment: json["credit_attachment"],
    creditRemark: json["credit_remark"],
    ewayPdfUrl: json["eway_pdf_url"],
    irn: json["irn"],
    einvoicePdfUrl: json["einvoice_pdf_url"],
    totalBeforeDiscountAmount: json["total_before_discount_amount"],
    transporterGstin: json["transporter_gstin"],
    transporterName: json["transporter_name"],
    transportMode: json["transport_mode"],
    lrNo: json["lr_no"],
    driverName: json["driver_name"],
    driverContact: json["driver_contact"],
    transportRemarks: json["transport_remarks"],
    transportModeId: json["transport_mode_id"],
    overallDiscountAmount: json["overall_discount_amount"],
    totalDiscount: json["total_discount"],
    totalReturnedQty: json["total_returned_qty"],
    totalReturnedAmount: json["total_returned_amount"],
    hasReturns: json["has_returns"],
    isMigrated: json["is_migrated"],
    migrationSource: json["migration_source"],
    migrationBatchId: json["migration_batch_id"],
    isAccounted: json["is_accounted"],
    taxInvoiceId: json["tax_invoice_id"],
    taxInvoiceNo: json["tax_invoice_no"],
    dcId: json["dc_id"],
    dcNo: json["dc_no"],
    isDcFlow: json["is_dc_flow"],
    customerRemark: json["customer_remark"],
    gstCategoryCodeKey: json["gst_category_code_key"],
    roundOff: json["round_off"],
    isEwayCancelled: json["is_eway_cancelled"],
    ewayCancelledBy: json["eway_cancelled_by"],
    ewayCancelRemarks: json["eway_cancel_remarks"],
    isIrnCancelled: json["is_irn_cancelled"],
    irnCancelledBy: json["irn_cancelled_by"],
    irnCancelRemarks: json["irn_cancel_remarks"],
    isCancelled: json["is_cancelled"],
    cancelledBy: json["cancelled_by"],
    cancelledTiRef: json["cancelled_ti_ref"],
    cancelledAt: json["cancelled_at"],
    createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    approvedAt: json["approved_at"],
    piApprovedAt: json["pi_approved_at"],
    postedForPiAt: json["posted_for_pi_at"],
    confirmedAt: json["confirmed_at"],
    piAutoCancelAt: json["pi_auto_cancel_at"],
    ewayCancelledAt: json["eway_cancelled_at"],
    irnCancelledAt: json["irn_cancelled_at"],
    piTypeId: json["pi_type_id"],
    piType: json["pi_type"],
    siteVisitRemark: json["site_visit_remark"],
    siteVisitAttachment: json["site_visit_attachment"],
    isSalesMigrated: json["is_sales_migrated"],
    outstandingRemarks: json["outstanding_remarks"],
    isSaleReturnTaxInvoice: json["is_sale_return_tax_invoice"],
    saleReturnId: json["sale_return_id"],
    salesMigAmount: json["sales_mig_amount"],
    averageDiscountRate: json["average_discount_rate"],
    averageDiscountAmount: json["average_discount_amount"],
    otherAdjSettledAmount: json["other_adj_settled_amount"],
    otherAdjInvoiceWriteOffAmount: json["other_adj_invoice_write_off_amount"],
    stockBookingValidUntil: json["stock_booking_valid_until"],
    piCancelRemarks: json["pi_cancel_remarks"],
    stockBookingApprovalId: json["stock_booking_approval_id"],
    isStockBookingApproved: json["is_stock_booking_approved"],
    totalExtraMarginAmount: json["total_extra_margin_amount"],
    totalEffectiveDiscountAmount: json["total_effective_discount_amount"],
    receiverDocumentTypeId: json["receiver_document_type_id"],
    receiverDocumentType: json["receiver_document_type"],
    receiverDocumentTypeCodeKey: json["receiver_document_type_code_key"],
    discountRequestStatus: json["discount_request_status"],
    balancePast: json["balance_past"],
    totalPast: json["total_past"],
    taxPast: json["tax_past"],
    revisedFromPiId: json["revised_from_pi_id"],
    supersededByPiId: json["superseded_by_pi_id"],
    isGstConsolidation: json["is_gst_consolidation"],
    consolidationStatus: json["consolidation_status"],
    consolidatedIntoInvoiceId: json["consolidated_into_invoice_id"],
    consolidationBatchId: json["consolidation_batch_id"],
    paidType: json["paid_type"],
    customerName: json["customer_name"],
    customerMobile: json["customer_mobile"],
    customerEmail: json["customer_email"],
    billingAddressDetails: json["billing_address_details"] == null ? null : IngAddressDetails.fromJson(json["billing_address_details"]),
    shippingAddressDetails: json["shipping_address_details"] == null ? null : IngAddressDetails.fromJson(json["shipping_address_details"]),
    paymentTermsName: json["payment_terms_name"],
    createdByName: json["created_by_name"],
    updatedByName: json["updated_by_name"],
    transportModeName: json["transport_mode_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "invoice_no": invoiceNo,
    "invoice_type": invoiceType,
    "parent_invoice_id": parentInvoiceId,
    "stock_location_id": stockLocationId,
    "collection_type": collectionType,
    "quotation_id": quotationId,
    "customer_id": customerId,
    "invoice_date": invoiceDate?.toIso8601String(),
    "due_date": dueDate?.toIso8601String(),
    "subtotal": subtotal,
    "tax_amount": taxAmount,
    "discount_amount": discountAmount,
    "total_amount": totalAmount,
    "paid_amount": paidAmount,
    "balance_amount": balanceAmount,
    "billing_address": billingAddress,
    "shipping_address": shippingAddress,
    "payment_status": paymentStatus,
    "delivery_status": deliveryStatus,
    "status": status,
    "remarks": remarks,
    "terms_conditions": termsConditions,
    "payment_terms": paymentTerms,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "is_deleted": isDeleted,
    "is_approval": isApproval,
    "approval_status": approvalStatus,
    "approved_by": approvedBy,
    "approval_remarks": approvalRemarks,
    "is_pi_approved": isPiApproved,
    "pi_approved_by": piApprovedBy,
    "advance_received": advanceReceived,
    "net_payable": netPayable,
    "is_advance_payment_term": isAdvancePaymentTerm,
    "advance_payments_count": advancePaymentsCount,
    "transporter_id": transporterId,
    "stock_approval_id": stockApprovalId,
    "is_stock_approved": isStockApproved,
    "packing_id": packingId,
    "eway_bill_no": ewayBillNo,
    "is_confirmed": isConfirmed,
    "confirmed_by": confirmedBy,
    "attachments": attachments,
    "is_required_ewaybill": isRequiredEwaybill,
    "company_id": companyId,
    "company_code": companyCode,
    "fin_year": finYear,
    "location_id": locationId,
    "location_code": locationCode,
    "receiver_name": receiverName,
    "receiver_mobile_number": receiverMobileNumber,
    "receiver_country_code": receiverCountryCode,
    "po_date": poDate?.toIso8601String(),
    "po_number": poNumber,
    "gst_treatment_id": gstTreatmentId,
    "credit_request_status": creditRequestStatus,
    "email": email,
    "collection_type_id": collectionTypeId,
    "opportunity_id": opportunityId,
    "total_taxable_amount": totalTaxableAmount,
    "total_tax_amount": totalTaxAmount,
    "overall_discount": overallDiscount,
    "total_charges_amount": totalChargesAmount,
    "final_total_amount": finalTotalAmount,
    "total_cgst_amount": totalCgstAmount,
    "total_sgst_amount": totalSgstAmount,
    "total_igst_amount": totalIgstAmount,
    "is_posted_for_pi": isPostedForPi,
    "posted_for_pi_by": postedForPiBy,
    "fin_year_int": finYearInt,
    "vehicle_no": vehicleNo,
    "advance_amount": advanceAmount,
    "advance_attachment": advanceAttachment,
    "priority": priority,
    "is_export": isExport,
    "currency_id": currencyId,
    "exchange_rate": exchangeRate,
    "export_type": exportType,
    "shipping_bill_no": shippingBillNo,
    "shipping_bill_date": shippingBillDate,
    "port_of_loading": portOfLoading,
    "port_of_discharge": portOfDischarge,
    "vessel_flight_no": vesselFlightNo,
    "destination_country_id": destinationCountryId,
    "credit_attachment": creditAttachment,
    "credit_remark": creditRemark,
    "eway_pdf_url": ewayPdfUrl,
    "irn": irn,
    "einvoice_pdf_url": einvoicePdfUrl,
    "total_before_discount_amount": totalBeforeDiscountAmount,
    "transporter_gstin": transporterGstin,
    "transporter_name": transporterName,
    "transport_mode": transportMode,
    "lr_no": lrNo,
    "driver_name": driverName,
    "driver_contact": driverContact,
    "transport_remarks": transportRemarks,
    "transport_mode_id": transportModeId,
    "overall_discount_amount": overallDiscountAmount,
    "total_discount": totalDiscount,
    "total_returned_qty": totalReturnedQty,
    "total_returned_amount": totalReturnedAmount,
    "has_returns": hasReturns,
    "is_migrated": isMigrated,
    "migration_source": migrationSource,
    "migration_batch_id": migrationBatchId,
    "is_accounted": isAccounted,
    "tax_invoice_id": taxInvoiceId,
    "tax_invoice_no": taxInvoiceNo,
    "dc_id": dcId,
    "dc_no": dcNo,
    "is_dc_flow": isDcFlow,
    "customer_remark": customerRemark,
    "gst_category_code_key": gstCategoryCodeKey,
    "round_off": roundOff,
    "is_eway_cancelled": isEwayCancelled,
    "eway_cancelled_by": ewayCancelledBy,
    "eway_cancel_remarks": ewayCancelRemarks,
    "is_irn_cancelled": isIrnCancelled,
    "irn_cancelled_by": irnCancelledBy,
    "irn_cancel_remarks": irnCancelRemarks,
    "is_cancelled": isCancelled,
    "cancelled_by": cancelledBy,
    "cancelled_ti_ref": cancelledTiRef,
    "cancelled_at": cancelledAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "approved_at": approvedAt,
    "pi_approved_at": piApprovedAt,
    "posted_for_pi_at": postedForPiAt,
    "confirmed_at": confirmedAt,
    "pi_auto_cancel_at": piAutoCancelAt,
    "eway_cancelled_at": ewayCancelledAt,
    "irn_cancelled_at": irnCancelledAt,
    "pi_type_id": piTypeId,
    "pi_type": piType,
    "site_visit_remark": siteVisitRemark,
    "site_visit_attachment": siteVisitAttachment,
    "is_sales_migrated": isSalesMigrated,
    "outstanding_remarks": outstandingRemarks,
    "is_sale_return_tax_invoice": isSaleReturnTaxInvoice,
    "sale_return_id": saleReturnId,
    "sales_mig_amount": salesMigAmount,
    "average_discount_rate": averageDiscountRate,
    "average_discount_amount": averageDiscountAmount,
    "other_adj_settled_amount": otherAdjSettledAmount,
    "other_adj_invoice_write_off_amount": otherAdjInvoiceWriteOffAmount,
    "stock_booking_validUntil": stockBookingValidUntil,
    "pi_cancel_remarks": piCancelRemarks,
    "stock_booking_approval_id": stockBookingApprovalId,
    "is_stock_booking_approved": isStockBookingApproved,
    "total_extra_margin_amount": totalExtraMarginAmount,
    "total_effective_discount_amount": totalEffectiveDiscountAmount,
    "receiver_document_type_id": receiverDocumentTypeId,
    "receiver_document_type": receiverDocumentType,
    "receiver_document_type_code_key": receiverDocumentTypeCodeKey,
    "discount_request_status": discountRequestStatus,
    "balance_past": balancePast,
    "total_past": totalPast,
    "tax_past": taxPast,
    "revised_from_pi_id": revisedFromPiId,
    "superseded_by_pi_id": supersededByPiId,
    "is_gst_consolidation": isGstConsolidation,
    "consolidation_status": consolidationStatus,
    "consolidated_into_invoice_id": consolidatedIntoInvoiceId,
    "consolidation_batch_id": consolidationBatchId,
    "paid_type": paidType,
    "customer_name": customerName,
    "customer_mobile": customerMobile,
    "customer_email": customerEmail,
    "billing_address_details": billingAddressDetails?.toJson(),
    "shipping_address_details": shippingAddressDetails?.toJson(),
    "payment_terms_name": paymentTermsName,
    "created_by_name": createdByName,
    "updated_by_name": updatedByName,
    "transport_mode_name": transportModeName,
  };
}

class IngAddressDetails {
  String? id;
  String? street;
  String? cityId;
  String? stateId;
  String? pincodeId;
  String? contactName;
  dynamic mobile1;
  String? companyName;
  String? cityName;
  String? stateName;
  String? pincode;

  IngAddressDetails({
    this.id,
    this.street,
    this.cityId,
    this.stateId,
    this.pincodeId,
    this.contactName,
    this.mobile1,
    this.companyName,
    this.cityName,
    this.stateName,
    this.pincode,
  });

  factory IngAddressDetails.fromJson(Map<String, dynamic> json) => IngAddressDetails(
    id: json["id"],
    street: json["street"],
    cityId: json["city_id"],
    stateId: json["state_id"],
    pincodeId: json["pincode_id"],
    contactName: json["contact_name"],
    mobile1: json["mobile_1"],
    companyName: json["company_name"],
    cityName: json["city_name"],
    stateName: json["state_name"],
    pincode: json["pincode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "street": street,
    "city_id": cityId,
    "state_id": stateId,
    "pincode_id": pincodeId,
    "contact_name": contactName,
    "mobile_1": mobile1,
    "company_name": companyName,
    "city_name": cityName,
    "state_name": stateName,
    "pincode": pincode,
  };
}

class Item {
  String? id;
  String? tenantId;
  String? pickRequestId;
  String? invoiceId;
  String? invoiceItemId;
  String? productId;
  String? requestedQty;
  String? approvedQty;
  dynamic remarks;
  String? overrideRackId;
  String? overrideBatch;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isDeleted;
  Product? product;
  List<DashboardLocation>? rackSuggestions;
  List<DashboardLocation>? dashboardLocations;
  List<DashboardLocation>? otherRacks;
  int? totalSuggestedQty;

  Item({
    this.id,
    this.tenantId,
    this.pickRequestId,
    this.invoiceId,
    this.invoiceItemId,
    this.productId,
    this.requestedQty,
    this.approvedQty,
    this.remarks,
    this.overrideRackId,
    this.overrideBatch,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.product,
    this.rackSuggestions,
    this.dashboardLocations,
    this.otherRacks,
    this.totalSuggestedQty,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    tenantId: json["tenant_id"],
    pickRequestId: json["pick_request_id"],
    invoiceId: json["invoice_id"],
    invoiceItemId: json["invoice_item_id"],
    productId: json["product_id"],
    requestedQty: json["requested_qty"]?.toString(),
    approvedQty: json["approved_qty"]?.toString(),
    remarks: json["remarks"],
    overrideRackId: json["override_rack_id"],
    overrideBatch: json["override_batch"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"]),
    isDeleted: json["is_deleted"],
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    rackSuggestions: json["rack_suggestions"] == null
        ? []
        : List<DashboardLocation>.from(json["rack_suggestions"].map((x) => DashboardLocation.fromJson(x))),
    dashboardLocations: json["dashboard_locations"] == null
        ? []
        : List<DashboardLocation>.from(json["dashboard_locations"].map((x) => DashboardLocation.fromJson(x))),
    otherRacks: json["other_racks"] == null ? [] : List<DashboardLocation>.from(json["other_racks"].map((x) => DashboardLocation.fromJson(x))),
    totalSuggestedQty: json["total_suggested_qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "pick_request_id": pickRequestId,
    "invoice_id": invoiceId,
    "invoice_item_id": invoiceItemId,
    "product_id": productId,
    "requested_qty": requestedQty,
    "approved_qty": approvedQty,
    "remarks": remarks,
    "override_rack_id": overrideRackId,
    "override_batch": overrideBatch,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_deleted": isDeleted,
    "product": product?.toJson(),
    "rack_suggestions": rackSuggestions == null ? [] : List<dynamic>.from(rackSuggestions!.map((x) => x.toJson())),
    "dashboard_locations": dashboardLocations == null ? [] : List<dynamic>.from(dashboardLocations!.map((x) => x.toJson())),
    "other_racks": otherRacks == null ? [] : List<dynamic>.from(otherRacks!.map((x) => x.toJson())),
    "total_suggested_qty": totalSuggestedQty,
  };
}

class DashboardLocation {
  String? rackId;
  String? rackName;
  String? batchNumber;
  int? qty;
  Status? status;
  List<String>? serialNumbers;

  DashboardLocation({this.rackId, this.rackName, this.batchNumber, this.qty, this.status, this.serialNumbers});

  factory DashboardLocation.fromJson(Map<String, dynamic> json) => DashboardLocation(
    rackId: json["rack_id"],
    rackName: json["rack_name"],
    batchNumber: json["batch_number"],
    qty: json["qty"],
    status: json["status"] == null ? null : statusValues.map[json["status"]],
    serialNumbers: json["serial_numbers"] == null ? [] : List<String>.from(json["serial_numbers"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "rack_id": rackId,
    "rack_name": rackName,
    "batch_number": batchNumber,
    "qty": qty,
    "status": status == null ? null : statusValues.reverse[status],
    "serial_numbers": serialNumbers == null ? [] : List<dynamic>.from(serialNumbers!.map((x) => x)),
  };
}

enum Status { BOOKED, LIVE }

final statusValues = EnumValues({"BOOKED": Status.BOOKED, "LIVE": Status.LIVE});

class Product {
  String? id;
  String? productName;
  String? productCode;
  String? unitOfMeasurment;
  List<String>? productImage;
  TrackingType? trackingType;
  Uom? purchaseUom;
  Uom? saleUom;
  String? description;
  String? descriptionSales;
  String? descriptionPurchase;
  String? poReqRemarks1;
  Uom? uom;
  String? remarks;

  Product({
    this.id,
    this.productName,
    this.productCode,
    this.unitOfMeasurment,
    this.productImage,
    this.trackingType,
    this.purchaseUom,
    this.saleUom,
    this.description,
    this.descriptionSales,
    this.descriptionPurchase,
    this.poReqRemarks1,
    this.uom,
    this.remarks,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    productName: json["product_name"],
    productCode: json["product_code"],
    unitOfMeasurment: json["unit_of_measurment"],
    productImage: json["product_image"] == null ? [] : List<String>.from(json["product_image"].map((x) => x)),
    trackingType: json["tracking_type"] == null ? null : trackingTypeValues.map[json["tracking_type"]],
    purchaseUom: json["purchase_uom"] == null ? null : uomValues.map[json["purchase_uom"]],
    saleUom: json["sale_uom"] == null ? null : uomValues.map[json["sale_uom"]],
    description: json["description"],
    descriptionSales: json["description_sales"],
    descriptionPurchase: json["description_purchase"],
    poReqRemarks1: json["po_req_remarks_1"],
    uom: json["uom"] == null ? null : uomValues.map[json["uom"]],
    remarks: json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "product_code": productCode,
    "unit_of_measurment": unitOfMeasurment,
    "product_image": productImage == null ? [] : List<dynamic>.from(productImage!.map((x) => x)),
    "tracking_type": trackingType == null ? null : trackingTypeValues.reverse[trackingType],
    "purchase_uom": purchaseUom == null ? null : uomValues.reverse[purchaseUom],
    "sale_uom": saleUom == null ? null : uomValues.reverse[saleUom],
    "description": description,
    "description_sales": descriptionSales,
    "description_purchase": descriptionPurchase,
    "po_req_remarks_1": poReqRemarks1,
    "uom": uom == null ? null : uomValues.reverse[uom],
    "remarks": remarks,
  };
}

enum Uom { NOS }

final uomValues = EnumValues({"Nos": Uom.NOS});

enum TrackingType { BATCH, SERIAL }

final trackingTypeValues = EnumValues({"BATCH": TrackingType.BATCH, "SERIAL": TrackingType.SERIAL});

class Log {
  String? id;
  String? entityType;
  String? entityId;
  String? parentType;
  String? parentId;
  String? rootType;
  String? rootId;
  String? notes;
  LogType? logType;
  Metadata? metadata;
  dynamic attachmentUrl;
  String? createdBy;
  String? tenantId;
  DateTime? createdAt;
  String? createdByName;

  Log({
    this.id,
    this.entityType,
    this.entityId,
    this.parentType,
    this.parentId,
    this.rootType,
    this.rootId,
    this.notes,
    this.logType,
    this.metadata,
    this.attachmentUrl,
    this.createdBy,
    this.tenantId,
    this.createdAt,
    this.createdByName,
  });

  factory Log.fromJson(Map<String, dynamic> json) => Log(
    id: json["id"],
    entityType: json["entity_type"],
    entityId: json["entity_id"],
    parentType: json["parent_type"],
    parentId: json["parent_id"],
    rootType: json["root_type"],
    rootId: json["root_id"],
    notes: json["notes"],
    logType: json["log_type"] == null ? null : logTypeValues.map[json["log_type"]],
    metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
    attachmentUrl: json["attachment_url"],
    createdBy: json["created_by"],
    tenantId: json["tenant_id"],
    createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"]),
    createdByName: json["created_by_name"],
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
    "log_type": logType == null ? null : logTypeValues.reverse[logType],
    "metadata": metadata?.toJson(),
    "attachment_url": attachmentUrl,
    "created_by": createdBy,
    "tenant_id": tenantId,
    "created_at": createdAt?.toIso8601String(),
    "created_by_name": createdByName,
  };
}

enum LogType { STATUS_CHANGE, SYSTEM }

final logTypeValues = EnumValues({"status_change": LogType.STATUS_CHANGE, "system": LogType.SYSTEM});

class Metadata {
  String? piNo;
  int? itemsCount;
  String? action;
  String? invoiceNo;
  double? totalAmount;
  String? confirmedBy;
  bool? proformaConfirmation;
  String? newStage;
  String? updatedBy;
  String? previousStage;
  String? customerName;
  String? quotationNo;
  String? status;

  Metadata({
    this.piNo,
    this.itemsCount,
    this.action,
    this.invoiceNo,
    this.totalAmount,
    this.confirmedBy,
    this.proformaConfirmation,
    this.newStage,
    this.updatedBy,
    this.previousStage,
    this.customerName,
    this.quotationNo,
    this.status,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    piNo: json["pi_no"],
    itemsCount: json["items_count"],
    action: json["action"],
    invoiceNo: json["invoice_no"],
    totalAmount: json["total_amount"] == null ? null : double.tryParse(json["total_amount"].toString()),
    confirmedBy: json["confirmed_by"],
    proformaConfirmation: json["proforma_confirmation"],
    newStage: json["new_stage"],
    updatedBy: json["updated_by"],
    previousStage: json["previous_stage"],
    customerName: json["customer_name"],
    quotationNo: json["quotation_no"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pi_no": piNo,
    "items_count": itemsCount,
    "action": action,
    "invoice_no": invoiceNo,
    "total_amount": totalAmount,
    "confirmed_by": confirmedBy,
    "proforma_confirmation": proformaConfirmation,
    "new_stage": newStage,
    "updated_by": updatedBy,
    "previous_stage": previousStage,
    "customer_name": customerName,
    "quotation_no": quotationNo,
    "status": status,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
