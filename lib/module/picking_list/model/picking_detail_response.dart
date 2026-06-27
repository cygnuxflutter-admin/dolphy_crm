// To parse this JSON data, do
//
//     final pickingDetailResponse = pickingDetailResponseFromJson(jsonString);

import 'dart:convert';

PickingDetailResponse pickingDetailResponseFromJson(String str) => PickingDetailResponse.fromJson(json.decode(str));

String pickingDetailResponseToJson(PickingDetailResponse data) => json.encode(data.toJson());

class PickingDetailResponse {
  final bool? success;
  final String? message;
  final PickingDetailData? data;
  final int? status;
  final dynamic error;

  PickingDetailResponse({this.success, this.message, this.data, this.status, this.error});

  factory PickingDetailResponse.fromJson(Map<String, dynamic> json) => PickingDetailResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : PickingDetailData.fromJson(json["data"]),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data?.toJson(), "status": status, "error": error};
}

class PickingDetailData {
  final String? id;
  final String? tenantId;
  final String? pickingNo;
  final DateTime? pickingDate;
  final String? invoiceId;
  final String? pickRequestId;
  final String? customerId;
  final dynamic warehouseId;
  final dynamic assignedTo;
  final dynamic assignedAt;
  final String? priority;
  final dynamic remarks;
  final String? status;
  final dynamic startedAt;
  final DateTime? completedAt;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;
  final dynamic deletedBy;
  final dynamic deletedAt;
  final String? companyId;
  final String? companyCode;
  final String? finYear;
  final String? locationId;
  final String? locationCode;
  final bool? isViewed;
  final List<Item>? items;
  final dynamic customerName;
  final Invoice? invoice;
  final List<String>? invoiceIds;
  final String? companyName;
  final String? locationName;
  final List<Log>? logs;
  final bool? hasPackingList;

  PickingDetailData({
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
    this.items,
    this.customerName,
    this.invoice,
    this.invoiceIds,
    this.companyName,
    this.locationName,
    this.logs,
    this.hasPackingList,
  });

  factory PickingDetailData.fromJson(Map<String, dynamic> json) => PickingDetailData(
    id: json["id"],
    tenantId: json["tenant_id"],
    pickingNo: json["picking_no"],
    pickingDate: json["picking_date"] == null ? null : DateTime.parse(json["picking_date"]),
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
    completedAt: json["completed_at"] == null ? null : DateTime.parse(json["completed_at"]),
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isDeleted: json["is_deleted"],
    deletedBy: json["deleted_by"],
    deletedAt: json["deleted_at"],
    companyId: json["company_id"],
    companyCode: json["company_code"],
    finYear: json["fin_year"],
    locationId: json["location_id"],
    locationCode: json["location_code"],
    isViewed: json["is_viewed"],
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    customerName: json["customer_name"],
    invoice: json["invoice"] == null ? null : Invoice.fromJson(json["invoice"]),
    invoiceIds: json["invoice_ids"] == null ? [] : List<String>.from(json["invoice_ids"]!.map((x) => x)),
    companyName: json["company_name"],
    locationName: json["location_name"],
    logs: json["logs"] == null ? [] : List<Log>.from(json["logs"]!.map((x) => Log.fromJson(x))),
    hasPackingList: json["has_packing_list"],
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
    "assigned_at": assignedAt,
    "priority": priority,
    "remarks": remarks,
    "status": status,
    "started_at": startedAt,
    "completed_at": completedAt?.toIso8601String(),
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
    "customer_name": customerName,
    "invoice": invoice?.toJson(),
    "invoice_ids": invoiceIds == null ? [] : List<dynamic>.from(invoiceIds!.map((x) => x)),
    "company_name": companyName,
    "location_name": locationName,
    "logs": logs == null ? [] : List<dynamic>.from(logs!.map((x) => x.toJson())),
    "has_packing_list": hasPackingList,
  };
}

class Invoice {
  final String? id;
  final String? tenantId;
  final String? invoiceNo;
  final String? invoiceType;
  final dynamic parentInvoiceId;
  final dynamic stockLocationId;
  final String? collectionType;
  final String? collectionTypeId;
  final dynamic quotationId;
  final String? customerId;
  final dynamic opportunityId;
  final DateTime? invoiceDate;
  final DateTime? dueDate;
  final String? subtotal;
  final String? totalBeforeDiscountAmount;
  final String? taxAmount;
  final String? discountAmount;
  final String? totalAmount;
  final String? totalTaxableAmount;
  final String? totalTaxAmount;
  final String? overallDiscount;
  final String? overallDiscountAmount;
  final String? totalDiscount;
  final String? totalChargesAmount;
  final String? finalTotalAmount;
  final String? roundOff;
  final String? totalCgstAmount;
  final String? totalSgstAmount;
  final String? totalIgstAmount;
  final String? paidAmount;
  final String? balanceAmount;
  final String? billingAddress;
  final String? shippingAddress;
  final String? paymentStatus;
  final String? deliveryStatus;
  final String? status;
  final bool? isCancelled;
  final dynamic cancelledAt;
  final dynamic cancelledBy;
  final dynamic remarks;
  final dynamic termsConditions;
  final String? paymentTerms;
  final String? gstTreatmentId;
  final dynamic gstCategoryCodeKey;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;
  final dynamic deletedAt;
  final bool? isApproval;
  final String? approvalStatus;
  final dynamic approvedBy;
  final dynamic approvedAt;
  final dynamic approvalRemarks;
  final bool? isPiApproved;
  final String? piApprovedBy;
  final DateTime? piApprovedAt;
  final bool? isPostedForPi;
  final String? postedForPiBy;
  final DateTime? postedForPiAt;
  final String? advanceReceived;
  final String? netPayable;
  final bool? isAdvancePaymentTerm;
  final int? advancePaymentsCount;
  final dynamic transporterId;
  final dynamic stockApprovalId;
  final bool? isStockApproved;
  final dynamic packingId;
  final bool? isRequiredEwaybill;
  final dynamic ewayBillNo;
  final dynamic transporterGstin;
  final dynamic transporterName;
  final String? transportModeId;
  final dynamic transportMode;
  final dynamic lrNo;
  final dynamic driverName;
  final dynamic driverContact;
  final dynamic transportRemarks;
  final dynamic vehicleNo;
  final bool? isConfirmed;
  final dynamic confirmedBy;
  final dynamic confirmedAt;
  final String? attachments;
  final String? advanceAmount;
  final String? advanceAttachment;
  final String? siteVisitRemark;
  final String? siteVisitAttachment;
  final String? creditAttachment;
  final dynamic creditRemark;
  final String? priority;
  final String? companyId;
  final String? companyCode;
  final String? finYear;
  final dynamic finYearInt;
  final String? locationId;
  final String? receiverName;
  final String? receiverMobileNumber;
  final String? receiverCountryCode;
  final String? locationCode;
  final dynamic poDate;
  final dynamic poNumber;
  final dynamic creditRequestStatus;
  final String? email;
  final bool? isExport;
  final dynamic currencyId;
  final String? exchangeRate;
  final dynamic exportType;
  final dynamic shippingBillNo;
  final dynamic shippingBillDate;
  final dynamic portOfLoading;
  final dynamic portOfDischarge;
  final dynamic vesselFlightNo;
  final dynamic destinationCountryId;
  final dynamic ewayPdfUrl;
  final dynamic irn;
  final dynamic einvoicePdfUrl;
  final String? totalReturnedQty;
  final String? totalReturnedAmount;
  final bool? hasReturns;
  final bool? isMigrated;
  final bool? isSalesMigrated;
  final dynamic migrationSource;
  final dynamic migrationBatchId;
  final bool? isAccounted;
  final dynamic piAutoCancelAt;
  final dynamic taxInvoiceId;
  final dynamic taxInvoiceNo;
  final dynamic dcId;
  final dynamic dcNo;
  final bool? isDcFlow;
  final bool? isSaleReturnTaxInvoice;
  final dynamic saleReturnId;
  final dynamic customerRemark;
  final dynamic outstandingRemarks;
  final bool? isEwayCancelled;
  final dynamic ewayCancelledAt;
  final dynamic ewayCancelledBy;
  final dynamic ewayCancelRemarks;
  final bool? isIrnCancelled;
  final dynamic irnCancelledAt;
  final dynamic irnCancelledBy;
  final dynamic irnCancelRemarks;
  final dynamic cancelledTiRef;
  final String? piTypeId;
  final String? piType;
  final dynamic customerName;
  final dynamic customerMobile;
  final dynamic customerEmail;
  final IngAddressDetails? billingAddressDetails;
  final IngAddressDetails? shippingAddressDetails;
  final String? paymentTermsName;
  final String? createdByName;
  final String? updatedByName;
  final String? piApprovedByName;

  Invoice({
    this.id,
    this.tenantId,
    this.invoiceNo,
    this.invoiceType,
    this.parentInvoiceId,
    this.stockLocationId,
    this.collectionType,
    this.collectionTypeId,
    this.quotationId,
    this.customerId,
    this.opportunityId,
    this.invoiceDate,
    this.dueDate,
    this.subtotal,
    this.totalBeforeDiscountAmount,
    this.taxAmount,
    this.discountAmount,
    this.totalAmount,
    this.totalTaxableAmount,
    this.totalTaxAmount,
    this.overallDiscount,
    this.overallDiscountAmount,
    this.totalDiscount,
    this.totalChargesAmount,
    this.finalTotalAmount,
    this.roundOff,
    this.totalCgstAmount,
    this.totalSgstAmount,
    this.totalIgstAmount,
    this.paidAmount,
    this.balanceAmount,
    this.billingAddress,
    this.shippingAddress,
    this.paymentStatus,
    this.deliveryStatus,
    this.status,
    this.isCancelled,
    this.cancelledAt,
    this.cancelledBy,
    this.remarks,
    this.termsConditions,
    this.paymentTerms,
    this.gstTreatmentId,
    this.gstCategoryCodeKey,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deletedAt,
    this.isApproval,
    this.approvalStatus,
    this.approvedBy,
    this.approvedAt,
    this.approvalRemarks,
    this.isPiApproved,
    this.piApprovedBy,
    this.piApprovedAt,
    this.isPostedForPi,
    this.postedForPiBy,
    this.postedForPiAt,
    this.advanceReceived,
    this.netPayable,
    this.isAdvancePaymentTerm,
    this.advancePaymentsCount,
    this.transporterId,
    this.stockApprovalId,
    this.isStockApproved,
    this.packingId,
    this.isRequiredEwaybill,
    this.ewayBillNo,
    this.transporterGstin,
    this.transporterName,
    this.transportModeId,
    this.transportMode,
    this.lrNo,
    this.driverName,
    this.driverContact,
    this.transportRemarks,
    this.vehicleNo,
    this.isConfirmed,
    this.confirmedBy,
    this.confirmedAt,
    this.attachments,
    this.advanceAmount,
    this.advanceAttachment,
    this.siteVisitRemark,
    this.siteVisitAttachment,
    this.creditAttachment,
    this.creditRemark,
    this.priority,
    this.companyId,
    this.companyCode,
    this.finYear,
    this.finYearInt,
    this.locationId,
    this.receiverName,
    this.receiverMobileNumber,
    this.receiverCountryCode,
    this.locationCode,
    this.poDate,
    this.poNumber,
    this.creditRequestStatus,
    this.email,
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
    this.ewayPdfUrl,
    this.irn,
    this.einvoicePdfUrl,
    this.totalReturnedQty,
    this.totalReturnedAmount,
    this.hasReturns,
    this.isMigrated,
    this.isSalesMigrated,
    this.migrationSource,
    this.migrationBatchId,
    this.isAccounted,
    this.piAutoCancelAt,
    this.taxInvoiceId,
    this.taxInvoiceNo,
    this.dcId,
    this.dcNo,
    this.isDcFlow,
    this.isSaleReturnTaxInvoice,
    this.saleReturnId,
    this.customerRemark,
    this.outstandingRemarks,
    this.isEwayCancelled,
    this.ewayCancelledAt,
    this.ewayCancelledBy,
    this.ewayCancelRemarks,
    this.isIrnCancelled,
    this.irnCancelledAt,
    this.irnCancelledBy,
    this.irnCancelRemarks,
    this.cancelledTiRef,
    this.piTypeId,
    this.piType,
    this.customerName,
    this.customerMobile,
    this.customerEmail,
    this.billingAddressDetails,
    this.shippingAddressDetails,
    this.paymentTermsName,
    this.createdByName,
    this.updatedByName,
    this.piApprovedByName,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    id: json["id"],
    tenantId: json["tenant_id"],
    invoiceNo: json["invoice_no"],
    invoiceType: json["invoice_type"],
    parentInvoiceId: json["parent_invoice_id"],
    stockLocationId: json["stock_location_id"],
    collectionType: json["collection_type"],
    collectionTypeId: json["collection_type_id"],
    quotationId: json["quotation_id"],
    customerId: json["customer_id"],
    opportunityId: json["opportunity_id"],
    invoiceDate: json["invoice_date"] == null ? null : DateTime.parse(json["invoice_date"]),
    dueDate: json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
    subtotal: json["subtotal"],
    totalBeforeDiscountAmount: json["total_before_discount_amount"],
    taxAmount: json["tax_amount"],
    discountAmount: json["discount_amount"],
    totalAmount: json["total_amount"],
    totalTaxableAmount: json["total_taxable_amount"],
    totalTaxAmount: json["total_tax_amount"],
    overallDiscount: json["overall_discount"],
    overallDiscountAmount: json["overall_discount_amount"],
    totalDiscount: json["total_discount"],
    totalChargesAmount: json["total_charges_amount"],
    finalTotalAmount: json["final_total_amount"],
    roundOff: json["round_off"],
    totalCgstAmount: json["total_cgst_amount"],
    totalSgstAmount: json["total_sgst_amount"],
    totalIgstAmount: json["total_igst_amount"],
    paidAmount: json["paid_amount"],
    balanceAmount: json["balance_amount"],
    billingAddress: json["billing_address"],
    shippingAddress: json["shipping_address"],
    paymentStatus: json["payment_status"],
    deliveryStatus: json["delivery_status"],
    status: json["status"],
    isCancelled: json["is_cancelled"],
    cancelledAt: json["cancelled_at"],
    cancelledBy: json["cancelled_by"],
    remarks: json["remarks"],
    termsConditions: json["terms_conditions"],
    paymentTerms: json["payment_terms"],
    gstTreatmentId: json["gst_treatment_id"],
    gstCategoryCodeKey: json["gst_category_code_key"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    isApproval: json["is_approval"],
    approvalStatus: json["approval_status"],
    approvedBy: json["approved_by"],
    approvedAt: json["approved_at"],
    approvalRemarks: json["approval_remarks"],
    isPiApproved: json["is_pi_approved"],
    piApprovedBy: json["pi_approved_by"],
    piApprovedAt: json["pi_approved_at"] == null ? null : DateTime.parse(json["pi_approved_at"]),
    isPostedForPi: json["is_posted_for_pi"],
    postedForPiBy: json["posted_for_pi_by"],
    postedForPiAt: json["posted_for_pi_at"] == null ? null : DateTime.parse(json["posted_for_pi_at"]),
    advanceReceived: json["advance_received"],
    netPayable: json["net_payable"],
    isAdvancePaymentTerm: json["is_advance_payment_term"],
    advancePaymentsCount: json["advance_payments_count"],
    transporterId: json["transporter_id"],
    stockApprovalId: json["stock_approval_id"],
    isStockApproved: json["is_stock_approved"],
    packingId: json["packing_id"],
    isRequiredEwaybill: json["is_required_ewaybill"],
    ewayBillNo: json["eway_bill_no"],
    transporterGstin: json["transporter_gstin"],
    transporterName: json["transporter_name"],
    transportModeId: json["transport_mode_id"],
    transportMode: json["transport_mode"],
    lrNo: json["lr_no"],
    driverName: json["driver_name"],
    driverContact: json["driver_contact"],
    transportRemarks: json["transport_remarks"],
    vehicleNo: json["vehicle_no"],
    isConfirmed: json["is_confirmed"],
    confirmedBy: json["confirmed_by"],
    confirmedAt: json["confirmed_at"],
    attachments: json["attachments"],
    advanceAmount: json["advance_amount"],
    advanceAttachment: json["advance_attachment"],
    siteVisitRemark: json["site_visit_remark"],
    siteVisitAttachment: json["site_visit_attachment"],
    creditAttachment: json["credit_attachment"],
    creditRemark: json["credit_remark"],
    priority: json["priority"],
    companyId: json["company_id"],
    companyCode: json["company_code"],
    finYear: json["fin_year"],
    finYearInt: json["fin_year_int"],
    locationId: json["location_id"],
    receiverName: json["receiver_name"],
    receiverMobileNumber: json["receiver_mobile_number"],
    receiverCountryCode: json["receiver_country_code"],
    locationCode: json["location_code"],
    poDate: json["po_date"],
    poNumber: json["po_number"],
    creditRequestStatus: json["credit_request_status"],
    email: json["email"],
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
    ewayPdfUrl: json["eway_pdf_url"],
    irn: json["irn"],
    einvoicePdfUrl: json["einvoice_pdf_url"],
    totalReturnedQty: json["total_returned_qty"],
    totalReturnedAmount: json["total_returned_amount"],
    hasReturns: json["has_returns"],
    isMigrated: json["is_migrated"],
    isSalesMigrated: json["is_sales_migrated"],
    migrationSource: json["migration_source"],
    migrationBatchId: json["migration_batch_id"],
    isAccounted: json["is_accounted"],
    piAutoCancelAt: json["pi_auto_cancel_at"],
    taxInvoiceId: json["tax_invoice_id"],
    taxInvoiceNo: json["tax_invoice_no"],
    dcId: json["dc_id"],
    dcNo: json["dc_no"],
    isDcFlow: json["is_dc_flow"],
    isSaleReturnTaxInvoice: json["is_sale_return_tax_invoice"],
    saleReturnId: json["sale_return_id"],
    customerRemark: json["customer_remark"],
    outstandingRemarks: json["outstanding_remarks"],
    isEwayCancelled: json["is_eway_cancelled"],
    ewayCancelledAt: json["eway_cancelled_at"],
    ewayCancelledBy: json["eway_cancelled_by"],
    ewayCancelRemarks: json["eway_cancel_remarks"],
    isIrnCancelled: json["is_irn_cancelled"],
    irnCancelledAt: json["irn_cancelled_at"],
    irnCancelledBy: json["irn_cancelled_by"],
    irnCancelRemarks: json["irn_cancel_remarks"],
    cancelledTiRef: json["cancelled_ti_ref"],
    piTypeId: json["pi_type_id"],
    piType: json["pi_type"],
    customerName: json["customer_name"],
    customerMobile: json["customer_mobile"],
    customerEmail: json["customer_email"],
    billingAddressDetails: json["billing_address_details"] == null ? null : IngAddressDetails.fromJson(json["billing_address_details"]),
    shippingAddressDetails: json["shipping_address_details"] == null ? null : IngAddressDetails.fromJson(json["shipping_address_details"]),
    paymentTermsName: json["payment_terms_name"],
    createdByName: json["created_by_name"],
    updatedByName: json["updated_by_name"],
    piApprovedByName: json["pi_approved_by_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "invoice_no": invoiceNo,
    "invoice_type": invoiceType,
    "parent_invoice_id": parentInvoiceId,
    "stock_location_id": stockLocationId,
    "collection_type": collectionType,
    "collection_type_id": collectionTypeId,
    "quotation_id": quotationId,
    "customer_id": customerId,
    "opportunity_id": opportunityId,
    "invoice_date":
        "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
    "due_date": "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
    "subtotal": subtotal,
    "total_before_discount_amount": totalBeforeDiscountAmount,
    "tax_amount": taxAmount,
    "discount_amount": discountAmount,
    "total_amount": totalAmount,
    "total_taxable_amount": totalTaxableAmount,
    "total_tax_amount": totalTaxAmount,
    "overall_discount": overallDiscount,
    "overall_discount_amount": overallDiscountAmount,
    "total_discount": totalDiscount,
    "total_charges_amount": totalChargesAmount,
    "final_total_amount": finalTotalAmount,
    "round_off": roundOff,
    "total_cgst_amount": totalCgstAmount,
    "total_sgst_amount": totalSgstAmount,
    "total_igst_amount": totalIgstAmount,
    "paid_amount": paidAmount,
    "balance_amount": balanceAmount,
    "billing_address": billingAddress,
    "shipping_address": shippingAddress,
    "payment_status": paymentStatus,
    "delivery_status": deliveryStatus,
    "status": status,
    "is_cancelled": isCancelled,
    "cancelled_at": cancelledAt,
    "cancelled_by": cancelledBy,
    "remarks": remarks,
    "terms_conditions": termsConditions,
    "payment_terms": paymentTerms,
    "gst_treatment_id": gstTreatmentId,
    "gst_category_code_key": gstCategoryCodeKey,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "is_approval": isApproval,
    "approval_status": approvalStatus,
    "approved_by": approvedBy,
    "approved_at": approvedAt,
    "approval_remarks": approvalRemarks,
    "is_pi_approved": isPiApproved,
    "pi_approved_by": piApprovedBy,
    "pi_approved_at": piApprovedAt?.toIso8601String(),
    "is_posted_for_pi": isPostedForPi,
    "posted_for_pi_by": postedForPiBy,
    "posted_for_pi_at": postedForPiAt?.toIso8601String(),
    "advance_received": advanceReceived,
    "net_payable": netPayable,
    "is_advance_payment_term": isAdvancePaymentTerm,
    "advance_payments_count": advancePaymentsCount,
    "transporter_id": transporterId,
    "stock_approval_id": stockApprovalId,
    "is_stock_approved": isStockApproved,
    "packing_id": packingId,
    "is_required_ewaybill": isRequiredEwaybill,
    "eway_bill_no": ewayBillNo,
    "transporter_gstin": transporterGstin,
    "transporter_name": transporterName,
    "transport_mode_id": transportModeId,
    "transport_mode": transportMode,
    "lr_no": lrNo,
    "driver_name": driverName,
    "driver_contact": driverContact,
    "transport_remarks": transportRemarks,
    "vehicle_no": vehicleNo,
    "is_confirmed": isConfirmed,
    "confirmed_by": confirmedBy,
    "confirmed_at": confirmedAt,
    "attachments": attachments,
    "advance_amount": advanceAmount,
    "advance_attachment": advanceAttachment,
    "site_visit_remark": siteVisitRemark,
    "site_visit_attachment": siteVisitAttachment,
    "credit_attachment": creditAttachment,
    "credit_remark": creditRemark,
    "priority": priority,
    "company_id": companyId,
    "company_code": companyCode,
    "fin_year": finYear,
    "fin_year_int": finYearInt,
    "location_id": locationId,
    "receiver_name": receiverName,
    "receiver_mobile_number": receiverMobileNumber,
    "receiver_country_code": receiverCountryCode,
    "location_code": locationCode,
    "po_date": poDate,
    "po_number": poNumber,
    "credit_request_status": creditRequestStatus,
    "email": email,
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
    "eway_pdf_url": ewayPdfUrl,
    "irn": irn,
    "einvoice_pdf_url": einvoicePdfUrl,
    "total_returned_qty": totalReturnedQty,
    "total_returned_amount": totalReturnedAmount,
    "has_returns": hasReturns,
    "is_migrated": isMigrated,
    "is_sales_migrated": isSalesMigrated,
    "migration_source": migrationSource,
    "migration_batch_id": migrationBatchId,
    "is_accounted": isAccounted,
    "pi_auto_cancel_at": piAutoCancelAt,
    "tax_invoice_id": taxInvoiceId,
    "tax_invoice_no": taxInvoiceNo,
    "dc_id": dcId,
    "dc_no": dcNo,
    "is_dc_flow": isDcFlow,
    "is_sale_return_tax_invoice": isSaleReturnTaxInvoice,
    "sale_return_id": saleReturnId,
    "customer_remark": customerRemark,
    "outstanding_remarks": outstandingRemarks,
    "is_eway_cancelled": isEwayCancelled,
    "eway_cancelled_at": ewayCancelledAt,
    "eway_cancelled_by": ewayCancelledBy,
    "eway_cancel_remarks": ewayCancelRemarks,
    "is_irn_cancelled": isIrnCancelled,
    "irn_cancelled_at": irnCancelledAt,
    "irn_cancelled_by": irnCancelledBy,
    "irn_cancel_remarks": irnCancelRemarks,
    "cancelled_ti_ref": cancelledTiRef,
    "pi_type_id": piTypeId,
    "pi_type": piType,
    "customer_name": customerName,
    "customer_mobile": customerMobile,
    "customer_email": customerEmail,
    "billing_address_details": billingAddressDetails?.toJson(),
    "shipping_address_details": shippingAddressDetails?.toJson(),
    "payment_terms_name": paymentTermsName,
    "created_by_name": createdByName,
    "updated_by_name": updatedByName,
    "pi_approved_by_name": piApprovedByName,
  };
}

class IngAddressDetails {
  final String? id;
  final String? street;
  final String? cityId;
  final String? stateId;
  final String? pincodeId;
  final String? contactName;
  final dynamic mobile1;
  final String? companyName;
  final String? cityName;
  final String? stateName;
  final String? pincode;

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
  final String? id;
  final String? tenantId;
  final String? pickingId;
  final String? invoiceId;
  final String? invoiceItemId;
  final String? productId;
  final String? orderedQty;
  final String? pickedQty;
  final String? pendingQty;
  final dynamic batchNo;
  final List<String>? serialIds;
  final String? rackLocationId;
  final dynamic binLocation;
  final dynamic pickedBy;
  final dynamic pickedAt;
  final String? status;
  final dynamic remarks;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;
  final Product? product;
  final RackLocation? rackLocation;
  final List<dynamic>? suggestedSerials;

  Item({
    this.id,
    this.tenantId,
    this.pickingId,
    this.invoiceId,
    this.invoiceItemId,
    this.productId,
    this.orderedQty,
    this.pickedQty,
    this.pendingQty,
    this.batchNo,
    this.serialIds,
    this.rackLocationId,
    this.binLocation,
    this.pickedBy,
    this.pickedAt,
    this.status,
    this.remarks,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.product,
    this.rackLocation,
    this.suggestedSerials,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    tenantId: json["tenant_id"],
    pickingId: json["picking_id"],
    invoiceId: json["invoice_id"],
    invoiceItemId: json["invoice_item_id"],
    productId: json["product_id"],
    orderedQty: json["ordered_qty"],
    pickedQty: json["picked_qty"],
    pendingQty: json["pending_qty"],
    batchNo: json["batch_no"],
    serialIds: json["serial_ids"] == null ? [] : List<String>.from(json["serial_ids"]!.map((x) => x)),
    rackLocationId: json["rack_location_id"],
    binLocation: json["bin_location"],
    pickedBy: json["picked_by"],
    pickedAt: json["picked_at"],
    status: json["status"],
    remarks: json["remarks"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isDeleted: json["is_deleted"],
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    rackLocation: json["rack_location"] == null ? null : RackLocation.fromJson(json["rack_location"]),
    suggestedSerials: json["suggested_serials"] == null ? [] : List<dynamic>.from(json["suggested_serials"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "picking_id": pickingId,
    "invoice_id": invoiceId,
    "invoice_item_id": invoiceItemId,
    "product_id": productId,
    "ordered_qty": orderedQty,
    "picked_qty": pickedQty,
    "pending_qty": pendingQty,
    "batch_no": batchNo,
    "serial_ids": serialIds == null ? [] : List<dynamic>.from(serialIds!.map((x) => x)),
    "rack_location_id": rackLocationId,
    "bin_location": binLocation,
    "picked_by": pickedBy,
    "picked_at": pickedAt,
    "status": status,
    "remarks": remarks,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_deleted": isDeleted,
    "product": product?.toJson(),
    "rack_location": rackLocation?.toJson(),
    "suggested_serials": suggestedSerials == null ? [] : List<dynamic>.from(suggestedSerials!.map((x) => x)),
  };
}

class Product {
  final String? id;
  final String? tenantId;
  final String? productGroupId;
  final String? productCode;
  final dynamic productLocationId;
  final dynamic warehouseLocationId;
  final String? productName;
  final String? vendorId;
  final String? departmentId;
  final String? productBarcode;
  final String? brandId;
  final String? hsnCode;
  final String? divisionId;
  final String? productCategoryId;
  final String? productTypeId;
  final String? unitOfMeasurment;
  final String? purchaseUomId;
  final String? purchaseUom;
  final String? saleUomId;
  final String? saleUom;
  final String? uomConversionValue;
  final String? modelNo;
  final String? features;
  final String? sizeId;
  final int? perBoxItemCount;
  final dynamic masterBoxId;
  final String? weight;
  final String? netWeight;
  final String? grossWeight;
  final String? minimumQty;
  final String? minOrderQty;
  final String? cbm;
  final String? itemLength;
  final String? itemWidth;
  final String? itemHeight;
  final String? storageTemperatureId;
  final dynamic powerRequirementId;
  final String? countryOfOriginId;
  final dynamic installationTypeId;
  final int? leadTime;
  final String? actualWeight;
  final String? packingWeight;
  final String? finishId;
  final String? warrantyId;
  final String? material;
  final bool? requireInstallation;
  final bool? arc;
  final bool? isWidth;
  final String? description;
  final String? descriptionSales;
  final String? descriptionPurchase;
  final String? poReqRemarks1;
  final String? poReqRemarks2;
  final String? poReqRemarks3;
  final String? trackingType;
  final String? trackingPrefix;
  final int? trackingStartNo;
  final int? trackingLastNo;
  final List<String>? imageUrl;
  final String? productSpecSheet;
  final String? product3DModel;
  final String? youtubeVideoLink;
  final List<dynamic>? companyIds;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;
  final bool? isDeleted;
  final dynamic deletedAt;

  Product({
    this.id,
    this.tenantId,
    this.productGroupId,
    this.productCode,
    this.productLocationId,
    this.warehouseLocationId,
    this.productName,
    this.vendorId,
    this.departmentId,
    this.productBarcode,
    this.brandId,
    this.hsnCode,
    this.divisionId,
    this.productCategoryId,
    this.productTypeId,
    this.unitOfMeasurment,
    this.purchaseUomId,
    this.purchaseUom,
    this.saleUomId,
    this.saleUom,
    this.uomConversionValue,
    this.modelNo,
    this.features,
    this.sizeId,
    this.perBoxItemCount,
    this.masterBoxId,
    this.weight,
    this.netWeight,
    this.grossWeight,
    this.minimumQty,
    this.minOrderQty,
    this.cbm,
    this.itemLength,
    this.itemWidth,
    this.itemHeight,
    this.storageTemperatureId,
    this.powerRequirementId,
    this.countryOfOriginId,
    this.installationTypeId,
    this.leadTime,
    this.actualWeight,
    this.packingWeight,
    this.finishId,
    this.warrantyId,
    this.material,
    this.requireInstallation,
    this.arc,
    this.isWidth,
    this.description,
    this.descriptionSales,
    this.descriptionPurchase,
    this.poReqRemarks1,
    this.poReqRemarks2,
    this.poReqRemarks3,
    this.trackingType,
    this.trackingPrefix,
    this.trackingStartNo,
    this.trackingLastNo,
    this.imageUrl,
    this.productSpecSheet,
    this.product3DModel,
    this.youtubeVideoLink,
    this.companyIds,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.isDeleted,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    tenantId: json["tenant_id"],
    productGroupId: json["product_group_id"],
    productCode: json["product_code"],
    productLocationId: json["product_location_id"],
    warehouseLocationId: json["warehouse_location_id"],
    productName: json["product_name"],
    vendorId: json["vendor_id"],
    departmentId: json["department_id"],
    productBarcode: json["product_barcode"],
    brandId: json["brand_id"],
    hsnCode: json["hsn_code"],
    divisionId: json["division_id"],
    productCategoryId: json["product_category_id"],
    productTypeId: json["product_type_id"],
    unitOfMeasurment: json["unit_of_measurment"],
    purchaseUomId: json["purchase_uom_id"],
    purchaseUom: json["purchase_uom"],
    saleUomId: json["sale_uom_id"],
    saleUom: json["sale_uom"],
    uomConversionValue: json["uom_conversion_value"],
    modelNo: json["model_no"],
    features: json["features"],
    sizeId: json["size_id"],
    perBoxItemCount: json["per_box_item_count"],
    masterBoxId: json["master_box_id"],
    weight: json["weight"],
    netWeight: json["net_weight"],
    grossWeight: json["gross_weight"],
    minimumQty: json["minimum_qty"],
    minOrderQty: json["min_order_qty"],
    cbm: json["cbm"],
    itemLength: json["item_length"],
    itemWidth: json["item_width"],
    itemHeight: json["item_height"],
    storageTemperatureId: json["storage_temperature_id"],
    powerRequirementId: json["power_requirement_id"],
    countryOfOriginId: json["country_of_origin_id"],
    installationTypeId: json["installation_type_id"],
    leadTime: json["lead_time"],
    actualWeight: json["actual_weight"],
    packingWeight: json["packing_weight"],
    finishId: json["finish_id"],
    warrantyId: json["warranty_id"],
    material: json["material"],
    requireInstallation: json["require_installation"],
    arc: json["arc"],
    isWidth: json["is_width"],
    description: json["description"],
    descriptionSales: json["description_sales"],
    descriptionPurchase: json["description_purchase"],
    poReqRemarks1: json["po_req_remarks_1"],
    poReqRemarks2: json["po_req_remarks_2"],
    poReqRemarks3: json["po_req_remarks_3"],
    trackingType: json["tracking_type"],
    trackingPrefix: json["tracking_prefix"],
    trackingStartNo: json["tracking_start_no"],
    trackingLastNo: json["tracking_last_no"],
    imageUrl: json["image_url"] == null ? [] : List<String>.from(json["image_url"]!.map((x) => x)),
    productSpecSheet: json["product_spec_sheet"],
    product3DModel: json["product_3d_model"],
    youtubeVideoLink: json["youtube_video_link"],
    companyIds: json["company_ids"] == null ? [] : List<dynamic>.from(json["company_ids"]!.map((x) => x)),
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isActive: json["is_active"],
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "product_group_id": productGroupId,
    "product_code": productCode,
    "product_location_id": productLocationId,
    "warehouse_location_id": warehouseLocationId,
    "product_name": productName,
    "vendor_id": vendorId,
    "department_id": departmentId,
    "product_barcode": productBarcode,
    "brand_id": brandId,
    "hsn_code": hsnCode,
    "division_id": divisionId,
    "product_category_id": productCategoryId,
    "product_type_id": productTypeId,
    "unit_of_measurment": unitOfMeasurment,
    "purchase_uom_id": purchaseUomId,
    "purchase_uom": purchaseUom,
    "sale_uom_id": saleUomId,
    "sale_uom": saleUom,
    "uom_conversion_value": uomConversionValue,
    "model_no": modelNo,
    "features": features,
    "size_id": sizeId,
    "per_box_item_count": perBoxItemCount,
    "master_box_id": masterBoxId,
    "weight": weight,
    "net_weight": netWeight,
    "gross_weight": grossWeight,
    "minimum_qty": minimumQty,
    "min_order_qty": minOrderQty,
    "cbm": cbm,
    "item_length": itemLength,
    "item_width": itemWidth,
    "item_height": itemHeight,
    "storage_temperature_id": storageTemperatureId,
    "power_requirement_id": powerRequirementId,
    "country_of_origin_id": countryOfOriginId,
    "installation_type_id": installationTypeId,
    "lead_time": leadTime,
    "actual_weight": actualWeight,
    "packing_weight": packingWeight,
    "finish_id": finishId,
    "warranty_id": warrantyId,
    "material": material,
    "require_installation": requireInstallation,
    "arc": arc,
    "is_width": isWidth,
    "description": description,
    "description_sales": descriptionSales,
    "description_purchase": descriptionPurchase,
    "po_req_remarks_1": poReqRemarks1,
    "po_req_remarks_2": poReqRemarks2,
    "po_req_remarks_3": poReqRemarks3,
    "tracking_type": trackingType,
    "tracking_prefix": trackingPrefix,
    "tracking_start_no": trackingStartNo,
    "tracking_last_no": trackingLastNo,
    "image_url": imageUrl == null ? [] : List<dynamic>.from(imageUrl!.map((x) => x)),
    "product_spec_sheet": productSpecSheet,
    "product_3d_model": product3DModel,
    "youtube_video_link": youtubeVideoLink,
    "company_ids": companyIds == null ? [] : List<dynamic>.from(companyIds!.map((x) => x)),
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_active": isActive,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
  };
}

class RackLocation {
  final String? id;
  final String? rackCode;
  final String? rackName;
  final dynamic rackDescription;
  final String? rackSide;
  final String? warehouseLocationId;
  final dynamic warehouseId;
  final dynamic locationId;
  final String? tenantId;
  final String? storageType;
  final String? length;
  final String? breadth;
  final String? height;
  final String? unitOfMeasure;
  final String? totalCbm;
  final String? usedCbm;
  final String? availableCbm;
  final String? totalCft;
  final String? usedCft;
  final dynamic noOfRows;
  final dynamic noOfColumns;
  final dynamic noOfPallatesPerCell;
  final String? usableSpacePercent;
  final dynamic rackBarcode;
  final dynamic floorId;
  final String? createdBy;
  final dynamic updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;
  final bool? isDeleted;
  final dynamic deletedAt;

  RackLocation({
    this.id,
    this.rackCode,
    this.rackName,
    this.rackDescription,
    this.rackSide,
    this.warehouseLocationId,
    this.warehouseId,
    this.locationId,
    this.tenantId,
    this.storageType,
    this.length,
    this.breadth,
    this.height,
    this.unitOfMeasure,
    this.totalCbm,
    this.usedCbm,
    this.availableCbm,
    this.totalCft,
    this.usedCft,
    this.noOfRows,
    this.noOfColumns,
    this.noOfPallatesPerCell,
    this.usableSpacePercent,
    this.rackBarcode,
    this.floorId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.isDeleted,
    this.deletedAt,
  });

  factory RackLocation.fromJson(Map<String, dynamic> json) => RackLocation(
    id: json["id"],
    rackCode: json["rack_code"],
    rackName: json["rack_name"],
    rackDescription: json["rack_description"],
    rackSide: json["rack_side"],
    warehouseLocationId: json["warehouse_location_id"],
    warehouseId: json["warehouse_id"],
    locationId: json["location_id"],
    tenantId: json["tenant_id"],
    storageType: json["storage_type"],
    length: json["length"],
    breadth: json["breadth"],
    height: json["height"],
    unitOfMeasure: json["unit_of_measure"],
    totalCbm: json["total_cbm"],
    usedCbm: json["used_cbm"],
    availableCbm: json["available_cbm"],
    totalCft: json["total_cft"],
    usedCft: json["used_cft"],
    noOfRows: json["no_of_rows"],
    noOfColumns: json["no_of_columns"],
    noOfPallatesPerCell: json["no_of_pallates_per_cell"],
    usableSpacePercent: json["usable_space_percent"],
    rackBarcode: json["rack_barcode"],
    floorId: json["floor_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isActive: json["is_active"],
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rack_code": rackCode,
    "rack_name": rackName,
    "rack_description": rackDescription,
    "rack_side": rackSide,
    "warehouse_location_id": warehouseLocationId,
    "warehouse_id": warehouseId,
    "location_id": locationId,
    "tenant_id": tenantId,
    "storage_type": storageType,
    "length": length,
    "breadth": breadth,
    "height": height,
    "unit_of_measure": unitOfMeasure,
    "total_cbm": totalCbm,
    "used_cbm": usedCbm,
    "available_cbm": availableCbm,
    "total_cft": totalCft,
    "used_cft": usedCft,
    "no_of_rows": noOfRows,
    "no_of_columns": noOfColumns,
    "no_of_pallates_per_cell": noOfPallatesPerCell,
    "usable_space_percent": usableSpacePercent,
    "rack_barcode": rackBarcode,
    "floor_id": floorId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_active": isActive,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
  };
}

class Log {
  final String? id;
  final String? entityType;
  final String? entityId;
  final String? parentType;
  final String? parentId;
  final String? rootType;
  final String? rootId;
  final String? notes;
  final String? logType;
  final Metadata? metadata;
  final dynamic attachmentUrl;
  final String? createdBy;
  final String? tenantId;
  final DateTime? createdAt;
  final String? createdByName;

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
    logType: json["log_type"],
    metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
    attachmentUrl: json["attachment_url"],
    createdBy: json["created_by"],
    tenantId: json["tenant_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
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
    "log_type": logType,
    "metadata": metadata?.toJson(),
    "attachment_url": attachmentUrl,
    "created_by": createdBy,
    "tenant_id": tenantId,
    "created_at": createdAt?.toIso8601String(),
    "created_by_name": createdByName,
  };
}

class Metadata {
  final String? to;
  final String? from;
  final String? field;
  final String? invoiceNo;
  final String? pickingNo;
  final bool? autoCreated;
  final String? confirmedBy;
  final bool? proformaConfirmation;
  final String? piNo;
  final int? itemsCount;
  final String? invoiceType;
  final num? totalAmount;

  Metadata({
    this.to,
    this.from,
    this.field,
    this.invoiceNo,
    this.pickingNo,
    this.autoCreated,
    this.confirmedBy,
    this.proformaConfirmation,
    this.piNo,
    this.itemsCount,
    this.invoiceType,
    this.totalAmount,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    to: json["to"],
    from: json["from"],
    field: json["field"],
    invoiceNo: json["invoice_no"],
    pickingNo: json["picking_no"],
    autoCreated: json["auto_created"],
    confirmedBy: json["confirmed_by"],
    proformaConfirmation: json["proforma_confirmation"],
    piNo: json["pi_no"],
    itemsCount: json["items_count"],
    invoiceType: json["invoice_type"],
    totalAmount: json["total_amount"],
  );

  Map<String, dynamic> toJson() => {
    "to": to,
    "from": from,
    "field": field,
    "invoice_no": invoiceNo,
    "picking_no": pickingNo,
    "auto_created": autoCreated,
    "confirmed_by": confirmedBy,
    "proforma_confirmation": proformaConfirmation,
    "pi_no": piNo,
    "items_count": itemsCount,
    "invoice_type": invoiceType,
    "total_amount": totalAmount,
  };
}
