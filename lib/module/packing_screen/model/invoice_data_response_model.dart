// To parse this JSON data, do
//
//     final viewInvoiceResponceModel = viewInvoiceResponceModelFromJson(jsonString);

import 'dart:convert';

ViewInvoiceResponceModel viewInvoiceResponceModelFromJson(String str) => ViewInvoiceResponceModel.fromJson(json.decode(str));

String viewInvoiceResponceModelToJson(ViewInvoiceResponceModel data) => json.encode(data.toJson());

class ViewInvoiceResponceModel {
  bool? success;
  String? message;
  InvoiceData? data;
  int? status;
  dynamic error;

  ViewInvoiceResponceModel({this.success, this.message, this.data, this.status, this.error});

  factory ViewInvoiceResponceModel.fromJson(Map<String, dynamic> json) => ViewInvoiceResponceModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] != null ? InvoiceData.fromJson(json["data"]) : null,
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data?.toJson(), "status": status, "error": error};
}

class InvoiceData {
  String? id;
  String? tenantId;
  String? invoiceNo;
  String? invoiceType;
  dynamic parentInvoiceId;
  dynamic stockLocationId;
  String? collectionType;
  String? collectionTypeId;
  String? quotationId;
  String? customerId;
  String? opportunityId;
  DateTime? invoiceDate;
  DateTime? dueDate;
  String? subtotal;
  String? totalBeforeDiscountAmount;
  String? taxAmount;
  String? discountAmount;
  String? totalAmount;
  String? totalTaxableAmount;
  String? totalTaxAmount;
  String? overallDiscount;
  String? overallDiscountAmount;
  String? totalDiscount;
  String? averageDiscountRate;
  String? averageDiscountAmount;
  String? totalEffectiveDiscountAmount;
  String? totalExtraMarginAmount;
  String? totalChargesAmount;
  String? finalTotalAmount;
  String? roundOff;
  String? totalCgstAmount;
  String? totalSgstAmount;
  String? totalIgstAmount;
  String? paidAmount;
  String? balanceAmount;
  dynamic balancePast;
  dynamic totalPast;
  dynamic taxPast;
  String? otherAdjSettledAmount;
  String? otherAdjInvoiceWriteOffAmount;
  String? billingAddress;
  String? shippingAddress;
  String? paymentStatus;
  String? paidType;
  String? deliveryStatus;
  String? status;
  dynamic discountRequestStatus;
  bool? isCancelled;
  dynamic cancelledAt;
  dynamic cancelledBy;
  dynamic piCancelRemarks;
  dynamic remarks;
  dynamic termsConditions;
  String? paymentTerms;
  String? gstTreatmentId;
  String? gstCategoryCodeKey;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isDeleted;
  dynamic deletedAt;
  bool? isApproval;
  String? approvalStatus;
  dynamic approvedBy;
  dynamic approvedAt;
  dynamic approvalRemarks;
  bool? isPiApproved;
  String? piApprovedBy;
  dynamic piApprovedAt;
  bool? isPostedForPi;
  String? postedForPiBy;
  dynamic postedForPiAt;
  String? advanceReceived;
  String? netPayable;
  bool? isAdvancePaymentTerm;
  int? advancePaymentsCount;
  dynamic transporterId;
  dynamic stockApprovalId;
  bool? isStockApproved;
  dynamic stockBookingValidUntil;
  dynamic stockBookingApprovalId;
  bool? isStockBookingApproved;
  dynamic packingId;
  bool? isRequiredEwaybill;
  dynamic ewayBillNo;
  dynamic transporterGstin;
  dynamic transporterName;
  String? transportModeId;
  dynamic transportMode;
  dynamic lrNo;
  dynamic driverName;
  dynamic driverContact;
  dynamic transportRemarks;
  dynamic vehicleNo;
  bool? isConfirmed;
  dynamic confirmedBy;
  dynamic confirmedAt;
  List<dynamic>? attachments;
  String? advanceAmount;
  List<String>? advanceAttachment;
  dynamic siteVisitRemark;
  List<dynamic>? siteVisitAttachment;
  List<dynamic>? creditAttachment;
  dynamic creditRemark;
  String? priority;
  String? companyId;
  String? companyCode;
  String? finYear;
  dynamic finYearInt;
  String? locationId;
  String? receiverName;
  String? receiverMobileNumber;
  String? receiverCountryCode;
  String? locationCode;
  dynamic poDate;
  dynamic poNumber;
  dynamic creditRequestStatus;
  String? email;
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
  dynamic ewayPdfUrl;
  dynamic irn;
  dynamic einvoicePdfUrl;
  String? totalReturnedQty;
  String? totalReturnedAmount;
  bool? hasReturns;
  bool? isMigrated;
  bool? isSalesMigrated;
  dynamic salesMigAmount;
  dynamic migrationSource;
  dynamic migrationBatchId;
  bool? isAccounted;
  dynamic piAutoCancelAt;
  dynamic taxInvoiceId;
  dynamic taxInvoiceNo;
  dynamic dcId;
  dynamic dcNo;
  bool? isDcFlow;
  bool? isSaleReturnTaxInvoice;
  dynamic saleReturnId;
  dynamic customerRemark;
  dynamic outstandingRemarks;
  bool? isEwayCancelled;
  dynamic ewayCancelledAt;
  dynamic ewayCancelledBy;
  dynamic ewayCancelRemarks;
  bool? isIrnCancelled;
  dynamic irnCancelledAt;
  dynamic irnCancelledBy;
  dynamic irnCancelRemarks;
  dynamic cancelledTiRef;
  dynamic revisedFromPiId;
  dynamic supersededByPiId;
  dynamic piTypeId;
  dynamic piType;
  dynamic receiverDocumentTypeId;
  dynamic receiverDocumentType;
  dynamic receiverDocumentTypeCodeKey;
  List<Log>? logs;
  List<dynamic>? activities;
  List<Item>? items;
  List<dynamic>? bookingRejectedItems;
  List<Charge>? charges;
  int? freightCharge;
  IngAddressDetail? billingAddressDetail;
  IngAddressDetail? shippingAddressDetail;
  String? customerName;
  dynamic contactPersonData;
  String? customerCompanyName;
  String? customerEmail;
  String? source;
  bool? isSez;
  String? customerMobile;
  String? customerGstNumber;
  String? customerPanNumber;
  String? customerState;
  String? customerCity;
  String? customerPincode;
  dynamic transporterGst;
  String? paymentTermsName;
  String? gstTreatmentName;
  String? gstTreatmentCodeKey;
  dynamic currencyName;
  dynamic currencyCode;
  dynamic codeKey;
  dynamic destinationCountryName;
  String? companyName;
  String? companyGst;
  CompanyAddress? companyAddress;
  LocationAddressDetail? locationAddressDetail;
  String? createdByName;
  String? createdByEmail;
  String? createdByMobile;
  String? updatedByName;
  List<SalesPersonsSplit>? salesPersonsSplit;
  List<dynamic>? creditRequests;
  List<dynamic>? piDiscountApprovalRequests;
  dynamic discountApprovalRejectionReason;
  bool? isFollower;
  bool? isReportingManager;
  Summary? summary;
  List<dynamic>? stockBookingApprovals;
  List<dynamic>? donationRequests;

  InvoiceData({
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
    this.averageDiscountRate,
    this.averageDiscountAmount,
    this.totalEffectiveDiscountAmount,
    this.totalExtraMarginAmount,
    this.totalChargesAmount,
    this.finalTotalAmount,
    this.roundOff,
    this.totalCgstAmount,
    this.totalSgstAmount,
    this.totalIgstAmount,
    this.paidAmount,
    this.balanceAmount,
    this.balancePast,
    this.totalPast,
    this.taxPast,
    this.otherAdjSettledAmount,
    this.otherAdjInvoiceWriteOffAmount,
    this.billingAddress,
    this.shippingAddress,
    this.paymentStatus,
    this.paidType,
    this.deliveryStatus,
    this.status,
    this.discountRequestStatus,
    this.isCancelled,
    this.cancelledAt,
    this.cancelledBy,
    this.piCancelRemarks,
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
    this.stockBookingValidUntil,
    this.stockBookingApprovalId,
    this.isStockBookingApproved,
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
    this.salesMigAmount,
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
    this.revisedFromPiId,
    this.supersededByPiId,
    this.piTypeId,
    this.piType,
    this.receiverDocumentTypeId,
    this.receiverDocumentType,
    this.receiverDocumentTypeCodeKey,
    this.logs,
    this.activities,
    this.items,
    this.bookingRejectedItems,
    this.charges,
    this.freightCharge,
    this.billingAddressDetail,
    this.shippingAddressDetail,
    this.customerName,
    this.contactPersonData,
    this.customerCompanyName,
    this.customerEmail,
    this.source,
    this.isSez,
    this.customerMobile,
    this.customerGstNumber,
    this.customerPanNumber,
    this.customerState,
    this.customerCity,
    this.customerPincode,
    this.transporterGst,
    this.paymentTermsName,
    this.gstTreatmentName,
    this.gstTreatmentCodeKey,
    this.currencyName,
    this.currencyCode,
    this.codeKey,
    this.destinationCountryName,
    this.companyName,
    this.companyGst,
    this.companyAddress,
    this.locationAddressDetail,
    this.createdByName,
    this.createdByEmail,
    this.createdByMobile,
    this.updatedByName,
    this.salesPersonsSplit,
    this.creditRequests,
    this.piDiscountApprovalRequests,
    this.discountApprovalRejectionReason,
    this.isFollower,
    this.isReportingManager,
    this.summary,
    this.stockBookingApprovals,
    this.donationRequests,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
    id: json["id"]?.toString() ?? "",
    tenantId: json["tenant_id"]?.toString() ?? "",
    invoiceNo: json["invoice_no"]?.toString() ?? "",
    invoiceType: json["invoice_type"]?.toString() ?? "",
    parentInvoiceId: json["parent_invoice_id"],
    stockLocationId: json["stock_location_id"],
    collectionType: json["collection_type"]?.toString() ?? "",
    collectionTypeId: json["collection_type_id"]?.toString() ?? "",
    quotationId: json["quotation_id"]?.toString() ?? "",
    customerId: json["customer_id"]?.toString() ?? "",
    opportunityId: json["opportunity_id"]?.toString() ?? "",
    invoiceDate: json["invoice_date"] != null ? DateTime.tryParse(json["invoice_date"].toString()) : null,
    dueDate: json["due_date"] != null ? DateTime.tryParse(json["due_date"].toString()) : null,
    subtotal: json["subtotal"]?.toString() ?? "0.00",
    totalBeforeDiscountAmount: json["total_before_discount_amount"]?.toString() ?? "0.00",
    taxAmount: json["tax_amount"]?.toString() ?? "0.00",
    discountAmount: json["discount_amount"]?.toString() ?? "0.00",
    totalAmount: json["total_amount"]?.toString() ?? "0.00",
    totalTaxableAmount: json["total_taxable_amount"]?.toString() ?? "0.00",
    totalTaxAmount: json["total_tax_amount"]?.toString() ?? "0.00",
    overallDiscount: json["overall_discount"]?.toString() ?? "0",
    overallDiscountAmount: json["overall_discount_amount"]?.toString() ?? "0.00",
    totalDiscount: json["total_discount"]?.toString() ?? "0.00",
    averageDiscountRate: json["average_discount_rate"]?.toString() ?? "0",
    averageDiscountAmount: json["average_discount_amount"]?.toString() ?? "0.00",
    totalEffectiveDiscountAmount: json["total_effective_discount_amount"]?.toString() ?? "0.00",
    totalExtraMarginAmount: json["total_extra_margin_amount"]?.toString() ?? "0.00",
    totalChargesAmount: json["total_charges_amount"]?.toString() ?? "0.00",
    finalTotalAmount: json["final_total_amount"]?.toString() ?? "0.00",
    roundOff: json["round_off"]?.toString() ?? "0.00",
    totalCgstAmount: json["total_cgst_amount"]?.toString() ?? "0.00",
    totalSgstAmount: json["total_sgst_amount"]?.toString() ?? "0.00",
    totalIgstAmount: json["total_igst_amount"]?.toString() ?? "0.00",
    paidAmount: json["paid_amount"]?.toString() ?? "0.00",
    balanceAmount: json["balance_amount"]?.toString() ?? "0.00",
    balancePast: json["balance_past"],
    totalPast: json["total_past"],
    taxPast: json["tax_past"],
    otherAdjSettledAmount: json["other_adj_settled_amount"]?.toString() ?? "0.00",
    otherAdjInvoiceWriteOffAmount: json["other_adj_invoice_write_off_amount"]?.toString() ?? "0.00",
    billingAddress: json["billing_address"]?.toString() ?? "",
    shippingAddress: json["shipping_address"]?.toString() ?? "",
    paymentStatus: json["payment_status"]?.toString() ?? "",
    paidType: json["paid_type"]?.toString() ?? "",
    deliveryStatus: json["delivery_status"]?.toString() ?? "",
    status: json["status"]?.toString() ?? "",
    discountRequestStatus: json["discount_request_status"],
    isCancelled: json["is_cancelled"],
    cancelledAt: json["cancelled_at"],
    cancelledBy: json["cancelled_by"],
    piCancelRemarks: json["pi_cancel_remarks"],
    remarks: json["remarks"],
    termsConditions: json["terms_conditions"],
    paymentTerms: json["payment_terms"]?.toString() ?? "",
    gstTreatmentId: json["gst_treatment_id"]?.toString() ?? "",
    gstCategoryCodeKey: json["gst_category_code_key"]?.toString() ?? "",
    createdBy: json["created_by"]?.toString() ?? "",
    updatedBy: json["updated_by"]?.toString() ?? "",
    createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"].toString()) : null,
    updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"].toString()) : null,
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    isApproval: json["is_approval"],
    approvalStatus: json["approval_status"]?.toString() ?? "",
    approvedBy: json["approved_by"],
    approvedAt: json["approved_at"],
    approvalRemarks: json["approval_remarks"],
    isPiApproved: json["is_pi_approved"],
    piApprovedBy: json["pi_approved_by"]?.toString() ?? "",
    piApprovedAt: json["pi_approved_at"],
    isPostedForPi: json["is_posted_for_pi"],
    postedForPiBy: json["posted_for_pi_by"]?.toString() ?? "",
    postedForPiAt: json["posted_for_pi_at"],
    advanceReceived: json["advance_received"]?.toString() ?? "0.00",
    netPayable: json["net_payable"]?.toString() ?? "0.00",
    isAdvancePaymentTerm: json["is_advance_payment_term"],
    advancePaymentsCount: json["advance_payments_count"],
    transporterId: json["transporter_id"],
    stockApprovalId: json["stock_approval_id"],
    isStockApproved: json["is_stock_approved"],
    stockBookingValidUntil: json["stock_booking_valid_until"],
    stockBookingApprovalId: json["stock_booking_approval_id"],
    isStockBookingApproved: json["is_stock_booking_approved"],
    packingId: json["packing_id"],
    isRequiredEwaybill: json["is_required_ewaybill"],
    ewayBillNo: json["eway_bill_no"],
    transporterGstin: json["transporter_gstin"],
    transporterName: json["transporter_name"],
    transportModeId: json["transport_mode_id"]?.toString() ?? "",
    transportMode: json["transport_mode"],
    lrNo: json["lr_no"],
    driverName: json["driver_name"],
    driverContact: json["driver_contact"],
    transportRemarks: json["transport_remarks"],
    vehicleNo: json["vehicle_no"],
    isConfirmed: json["is_confirmed"],
    confirmedBy: json["confirmed_by"],
    confirmedAt: json["confirmed_at"],
    attachments: json["attachments"] == null ? [] : List<dynamic>.from(json["attachments"].map((x) => x)),
    advanceAmount: json["advance_amount"]?.toString() ?? "0.00",
    advanceAttachment: json["advance_attachment"] == null ? [] : List<String>.from(json["advance_attachment"].map((x) => x.toString())),
    siteVisitRemark: json["site_visit_remark"],
    siteVisitAttachment: json["site_visit_attachment"] == null ? [] : List<dynamic>.from(json["site_visit_attachment"].map((x) => x)),
    creditAttachment: json["credit_attachment"] == null ? [] : List<dynamic>.from(json["credit_attachment"].map((x) => x)),
    creditRemark: json["credit_remark"],
    priority: json["priority"]?.toString() ?? "",
    companyId: json["company_id"]?.toString() ?? "",
    companyCode: json["company_code"]?.toString() ?? "",
    finYear: json["fin_year"]?.toString() ?? "",
    finYearInt: json["fin_year_int"],
    locationId: json["location_id"]?.toString() ?? "",
    receiverName: json["receiver_name"]?.toString() ?? "",
    receiverMobileNumber: json["receiver_mobile_number"]?.toString() ?? "",
    receiverCountryCode: json["receiver_country_code"]?.toString() ?? "",
    locationCode: json["location_code"]?.toString() ?? "",
    poDate: json["po_date"],
    poNumber: json["po_number"],
    creditRequestStatus: json["credit_request_status"],
    email: json["email"]?.toString() ?? "",
    isExport: json["is_export"],
    currencyId: json["currency_id"],
    exchangeRate: json["exchange_rate"]?.toString() ?? "1",
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
    totalReturnedQty: json["total_returned_qty"]?.toString() ?? "0",
    totalReturnedAmount: json["total_returned_amount"]?.toString() ?? "0.00",
    hasReturns: json["has_returns"],
    isMigrated: json["is_migrated"],
    isSalesMigrated: json["is_sales_migrated"],
    salesMigAmount: json["sales_mig_amount"],
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
    revisedFromPiId: json["revised_from_pi_id"],
    supersededByPiId: json["superseded_by_pi_id"],
    piTypeId: json["pi_type_id"],
    piType: json["pi_type"],
    receiverDocumentTypeId: json["receiver_document_type_id"],
    receiverDocumentType: json["receiver_document_type"],
    receiverDocumentTypeCodeKey: json["receiver_document_type_code_key"],
    logs: json["logs"] == null ? [] : List<Log>.from(json["logs"].map((x) => Log.fromJson(x))),
    activities: json["activities"] == null ? [] : List<dynamic>.from(json["activities"].map((x) => x)),
    items: json["items"] == null ? [] : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    bookingRejectedItems: json["booking_rejected_items"] == null ? [] : List<dynamic>.from(json["booking_rejected_items"].map((x) => x)),
    charges: json["charges"] == null ? [] : List<Charge>.from(json["charges"].map((x) => Charge.fromJson(x))),
    freightCharge: json["freight_charge"] ?? 0,
    billingAddressDetail: json["billing_address_detail"] != null ? IngAddressDetail.fromJson(json["billing_address_detail"]) : null,
    shippingAddressDetail: json["shipping_address_detail"] != null ? IngAddressDetail.fromJson(json["shipping_address_detail"]) : null,
    customerName: json["customer_name"]?.toString() ?? "",
    contactPersonData: json["contact_person_data"],
    customerCompanyName: json["customer_company_name"]?.toString(),
    customerEmail: json["customer_email"]?.toString(),
    source: json["source"]?.toString(),
    isSez: json["is_sez"],
    customerMobile: json["customer_mobile"]?.toString(),
    customerGstNumber: json["customer_gst_number"]?.toString(),
    customerPanNumber: json["customer_pan_number"]?.toString(),
    customerState: json["customer_state"]?.toString() ?? "",
    customerCity: json["customer_city"]?.toString() ?? "",
    customerPincode: json["customer_pincode"]?.toString() ?? "",
    transporterGst: json["transporter_gst"],
    paymentTermsName: json["payment_terms_name"]?.toString(),
    gstTreatmentName: json["gst_treatment_name"]?.toString(),
    gstTreatmentCodeKey: json["gst_treatment_code_key"]?.toString(),
    currencyName: json["currency_name"],
    currencyCode: json["currency_code"],
    codeKey: json["code_key"],
    destinationCountryName: json["destination_country_name"],
    companyName: json["company_name"]?.toString(),
    companyGst: json["company_gst"]?.toString(),
    companyAddress: json["company_address"] != null ? CompanyAddress.fromJson(json["company_address"]) : null,
    locationAddressDetail: json["location_address_detail"] != null ? LocationAddressDetail.fromJson(json["location_address_detail"]) : null,
    createdByName: json["created_by_name"] ?? "",
    createdByEmail: json["created_by_email"] ?? "",
    createdByMobile: json["created_by_mobile"] ?? "",
    updatedByName: json["updated_by_name"] ?? "",
    salesPersonsSplit: json["sales_persons_split"] == null
        ? []
        : List<SalesPersonsSplit>.from(json["sales_persons_split"].map((x) => SalesPersonsSplit.fromJson(x))),
    creditRequests: json["credit_requests"] == null ? [] : List<dynamic>.from(json["credit_requests"].map((x) => x)),
    piDiscountApprovalRequests: json["pi_discount_approval_requests"] == null
        ? []
        : List<dynamic>.from(json["pi_discount_approval_requests"].map((x) => x)),
    discountApprovalRejectionReason: json["discount_approval_rejection_reason"],
    isFollower: json["is_follower"],
    isReportingManager: json["is_reporting_manager"],
    summary: json["summary"] != null ? Summary.fromJson(json["summary"]) : null,
    stockBookingApprovals: json["stock_booking_approvals"] == null ? [] : List<dynamic>.from(json["stock_booking_approvals"].map((x) => x)),
    donationRequests: json["donation_requests"] == null ? [] : List<dynamic>.from(json["donation_requests"].map((x) => x)),
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
    "invoice_date": invoiceDate != null
        ? "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}"
        : null,
    "due_date": dueDate != null
        ? "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}"
        : null,
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
    "average_discount_rate": averageDiscountRate,
    "average_discount_amount": averageDiscountAmount,
    "total_effective_discount_amount": totalEffectiveDiscountAmount,
    "total_extra_margin_amount": totalExtraMarginAmount,
    "total_charges_amount": totalChargesAmount,
    "final_total_amount": finalTotalAmount,
    "round_off": roundOff,
    "total_cgst_amount": totalCgstAmount,
    "total_sgst_amount": totalSgstAmount,
    "total_igst_amount": totalIgstAmount,
    "paid_amount": paidAmount,
    "balance_amount": balanceAmount,
    "balance_past": balancePast,
    "total_past": totalPast,
    "tax_past": taxPast,
    "other_adj_settled_amount": otherAdjSettledAmount,
    "other_adj_invoice_write_off_amount": otherAdjInvoiceWriteOffAmount,
    "billing_address": billingAddress,
    "shipping_address": shippingAddress,
    "payment_status": paymentStatus,
    "paid_type": paidType,
    "delivery_status": deliveryStatus,
    "status": status,
    "discount_request_status": discountRequestStatus,
    "is_cancelled": isCancelled,
    "cancelled_at": cancelledAt,
    "cancelled_by": cancelledBy,
    "pi_cancel_remarks": piCancelRemarks,
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
    "pi_approved_at": piApprovedAt,
    "is_posted_for_pi": isPostedForPi,
    "posted_for_pi_by": postedForPiBy,
    "posted_for_pi_at": postedForPiAt,
    "advance_received": advanceReceived,
    "net_payable": netPayable,
    "is_advance_payment_term": isAdvancePaymentTerm,
    "advance_payments_count": advancePaymentsCount,
    "transporter_id": transporterId,
    "stock_approval_id": stockApprovalId,
    "is_stock_approved": isStockApproved,
    "stock_booking_valid_until": stockBookingValidUntil,
    "stock_booking_approval_id": stockBookingApprovalId,
    "is_stock_booking_approved": isStockBookingApproved,
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
    "attachments": attachments != null ? List<dynamic>.from(attachments!.map((x) => x)) : null,
    "advance_amount": advanceAmount,
    "advance_attachment": advanceAttachment != null ? List<dynamic>.from(advanceAttachment!.map((x) => x)) : null,
    "site_visit_remark": siteVisitRemark,
    "site_visit_attachment": siteVisitAttachment != null ? List<dynamic>.from(siteVisitAttachment!.map((x) => x)) : null,
    "credit_attachment": creditAttachment != null ? List<dynamic>.from(creditAttachment!.map((x) => x)) : null,
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
    "sales_mig_amount": salesMigAmount,
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
    "revised_from_pi_id": revisedFromPiId,
    "superseded_by_pi_id": supersededByPiId,
    "pi_type_id": piTypeId,
    "pi_type": piType,
    "receiver_document_type_id": receiverDocumentTypeId,
    "receiver_document_type": receiverDocumentType,
    "receiver_document_type_code_key": receiverDocumentTypeCodeKey,
    "logs": logs != null ? List<dynamic>.from(logs!.map((x) => x.toJson())) : null,
    "activities": activities != null ? List<dynamic>.from(activities!.map((x) => x)) : null,
    "items": items != null ? List<dynamic>.from(items!.map((x) => x.toJson())) : null,
    "booking_rejected_items": bookingRejectedItems != null ? List<dynamic>.from(bookingRejectedItems!.map((x) => x)) : null,
    "charges": charges != null ? List<dynamic>.from(charges!.map((x) => x.toJson())) : null,
    "freight_charge": freightCharge,
    "billing_address_detail": billingAddressDetail?.toJson(),
    "shipping_address_detail": shippingAddressDetail?.toJson(),
    "customer_name": customerName,
    "contact_person_data": contactPersonData,
    "customer_company_name": customerCompanyName,
    "customer_email": customerEmail,
    "source": source,
    "is_sez": isSez,
    "customer_mobile": customerMobile,
    "customer_gst_number": customerGstNumber,
    "customer_pan_number": customerPanNumber,
    "customer_state": customerState,
    "customer_city": customerCity,
    "customer_pincode": customerPincode,
    "transporter_gst": transporterGst,
    "payment_terms_name": paymentTermsName,
    "gst_treatment_name": gstTreatmentName,
    "gst_treatment_code_key": gstTreatmentCodeKey,
    "currency_name": currencyName,
    "currency_code": currencyCode,
    "codeKey": codeKey,
    "destination_country_name": destinationCountryName,
    "company_name": companyName,
    "company_gst": companyGst,
    "company_address": companyAddress?.toJson(),
    "location_address_detail": locationAddressDetail?.toJson(),
    "created_by_name": createdByName,
    "created_by_email": createdByEmail,
    "created_by_mobile": createdByMobile,
    "updated_by_name": updatedByName,
    "sales_persons_split": salesPersonsSplit != null ? List<dynamic>.from(salesPersonsSplit!.map((x) => x.toJson())) : null,
    "credit_requests": creditRequests != null ? List<dynamic>.from(creditRequests!.map((x) => x)) : null,
    "pi_discount_approval_requests": piDiscountApprovalRequests != null ? List<dynamic>.from(piDiscountApprovalRequests!.map((x) => x)) : null,
    "discount_approval_rejection_reason": discountApprovalRejectionReason,
    "is_follower": isFollower,
    "is_reporting_manager": isReportingManager,
    "summary": summary?.toJson(),
    "stock_booking_approvals": stockBookingApprovals != null ? List<dynamic>.from(stockBookingApprovals!.map((x) => x)) : null,
    "donation_requests": donationRequests != null ? List<dynamic>.from(donationRequests!.map((x) => x)) : null,
  };
}

class IngAddressDetail {
  String? id;
  String? type;
  String? contactName;
  String? companyName;
  dynamic email;
  dynamic mobile1CountryCode;
  dynamic mobile1;
  bool? mobile1IsMobile;
  dynamic mobile2CountryCode;
  dynamic mobile2;
  String? street;
  String? cityId;
  String? stateId;
  String? pincodeId;
  String? countryId;
  String? designation;
  String? remarks;
  dynamic source;
  bool? isActive;
  String? tenantId;
  String? customerId;
  String? createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isDeleted;
  dynamic deletedAt;
  String? stateName;
  String? stateCode;
  String? cityName;
  String? pincodeName;

  IngAddressDetail({
    this.id,
    this.type,
    this.contactName,
    this.companyName,
    this.email,
    this.mobile1CountryCode,
    this.mobile1,
    this.mobile1IsMobile,
    this.mobile2CountryCode,
    this.mobile2,
    this.street,
    this.cityId,
    this.stateId,
    this.pincodeId,
    this.countryId,
    this.designation,
    this.remarks,
    this.source,
    this.isActive,
    this.tenantId,
    this.customerId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deletedAt,
    this.stateName,
    this.stateCode,
    this.cityName,
    this.pincodeName,
  });

  factory IngAddressDetail.fromJson(Map<String, dynamic> json) => IngAddressDetail(
    id: json["id"]?.toString() ?? "",
    type: json["type"]?.toString() ?? "",
    contactName: json["contact_name"]?.toString() ?? "",
    companyName: json["company_name"]?.toString() ?? "",
    email: json["email"],
    mobile1CountryCode: json["mobile1_country_code"],
    mobile1: json["mobile_1"],
    mobile1IsMobile: json["mobile1_is_mobile"],
    mobile2CountryCode: json["mobile2_country_code"],
    mobile2: json["mobile_2"],
    street: json["street"]?.toString() ?? "",
    cityId: json["city_id"]?.toString() ?? "",
    stateId: json["state_id"]?.toString() ?? "",
    pincodeId: json["pincode_id"]?.toString() ?? "",
    countryId: json["country_id"]?.toString() ?? "",
    designation: json["designation"]?.toString() ?? "",
    remarks: json["remarks"]?.toString(),
    source: json["source"],
    isActive: json["is_active"],
    tenantId: json["tenant_id"]?.toString() ?? "",
    customerId: json["customer_id"]?.toString() ?? "",
    createdBy: json["created_by"]?.toString() ?? "",
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"].toString()) : null,
    updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"].toString()) : null,
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    stateName: json["state_name"]?.toString() ?? "",
    stateCode: json["state_code"]?.toString() ?? "",
    cityName: json["city_name"]?.toString() ?? "",
    pincodeName: json["pincode_name"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "contact_name": contactName,
    "company_name": companyName,
    "email": email,
    "mobile1_country_code": mobile1CountryCode,
    "mobile_1": mobile1,
    "mobile1_is_mobile": mobile1IsMobile,
    "mobile2_country_code": mobile2CountryCode,
    "mobile_2": mobile2,
    "street": street,
    "city_id": cityId,
    "state_id": stateId,
    "pincode_id": pincodeId,
    "country_id": countryId,
    "designation": designation,
    "remarks": remarks,
    "source": source,
    "is_active": isActive,
    "tenant_id": tenantId,
    "customer_id": customerId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "state_name": stateName,
    "state_code": stateCode,
    "city_name": cityName,
    "pincode_name": pincodeName,
  };
}

class Charge {
  String? id;
  String? tenantId;
  String? invoiceId;
  String? quotationId;
  String? chargeTypeId;
  String? chargeName;
  String? chargeOperation;
  String? amount;
  bool? isActive;
  String? gstPercent;
  String? gstAmount;
  dynamic remarks;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isDeleted;
  dynamic deletedAt;
  String? sacCode;
  String? taxRate;

  Charge({
    this.id,
    this.tenantId,
    this.invoiceId,
    this.quotationId,
    this.chargeTypeId,
    this.chargeName,
    this.chargeOperation,
    this.amount,
    this.isActive,
    this.gstPercent,
    this.gstAmount,
    this.remarks,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deletedAt,
    this.sacCode,
    this.taxRate,
  });

  factory Charge.fromJson(Map<String, dynamic> json) => Charge(
    id: json["id"]?.toString() ?? "",
    tenantId: json["tenant_id"]?.toString() ?? "",
    invoiceId: json["invoice_id"]?.toString() ?? "",
    quotationId: json["quotation_id"]?.toString() ?? "",
    chargeTypeId: json["charge_type_id"]?.toString() ?? "",
    chargeName: json["charge_name"]?.toString() ?? "",
    chargeOperation: json["charge_operation"]?.toString() ?? "",
    amount: json["amount"]?.toString() ?? "0",
    isActive: json["is_active"],
    gstPercent: json["gst_percent"]?.toString() ?? "0",
    gstAmount: json["gst_amount"]?.toString() ?? "0",
    remarks: json["remarks"],
    createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"].toString()) : null,
    updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"].toString()) : null,
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    sacCode: json["sac_code"]?.toString() ?? "",
    taxRate: json["tax_rate"]?.toString() ?? "0",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "invoice_id": invoiceId,
    "quotation_id": quotationId,
    "charge_type_id": chargeTypeId,
    "charge_name": chargeName,
    "charge_operation": chargeOperation,
    "amount": amount,
    "is_active": isActive,
    "gst_percent": gstPercent,
    "gst_amount": gstAmount,
    "remarks": remarks,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "sac_code": sacCode,
    "tax_rate": taxRate,
  };
}

class CompanyAddress {
  String? address;
  String? cityName;
  String? stateName;
  String? stateCode;
  String? pincodeName;

  CompanyAddress({this.address, this.cityName, this.stateName, this.stateCode, this.pincodeName});

  factory CompanyAddress.fromJson(Map<String, dynamic> json) => CompanyAddress(
    address: json["address"]?.toString() ?? "",
    cityName: json["city_name"]?.toString() ?? "",
    stateName: json["state_name"]?.toString() ?? "",
    stateCode: json["state_code"]?.toString() ?? "",
    pincodeName: json["pincode_name"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "city_name": cityName,
    "state_name": stateName,
    "state_code": stateCode,
    "pincode_name": pincodeName,
  };
}

class Item {
  String? id;
  String? invoiceId;
  String? productId;
  dynamic description;
  String? quantity;
  String? unitPrice;
  String? discountPercent;
  String? discountAmount;
  String? taxPercent;
  String? taxableAmount;
  String? taxAmount;
  String? totalAmount;
  String? lineTotal;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic containerNo;
  String? hsnCode;
  dynamic cgst;
  dynamic sgst;
  String? igst;
  String? cgstAmount;
  String? sgstAmount;
  String? igstAmount;
  dynamic finYearInt;
  String? liveQuantity;
  String? advanceQuantity;
  String? advanceFulfilledQty;
  dynamic expectedDate;
  String? foreignUnitPrice;
  String? foreignTotalAmount;
  String? beforeDiscountAmount;
  dynamic inch;
  String? height;
  String? width;
  String? tileWidth;
  String? tileLength;
  String? sqft;
  String? sqftRate;
  String? totalTiles;
  String? tilesPerBox;
  bool? isLogNote;
  dynamic logNote;
  bool? isDeleted;
  String? donatedQty;
  dynamic donationStatus;
  String? actualPrice;
  dynamic donationRemarks;
  dynamic taxPast;
  dynamic remarks;
  String? productName;
  String? productCode;
  String? imageUrl;
  String? unitOfMeasurment;
  String? uom;
  String? purchaseUom;
  String? saleUom;
  bool? isWidth;
  String? itemWidth;
  dynamic currencyId;
  dynamic currencyName;
  dynamic currencyCode;
  dynamic codeKey;
  String? taxPercentage;
  bool? isDiscount;

  Item({
    this.id,
    this.invoiceId,
    this.productId,
    this.description,
    this.quantity,
    this.unitPrice,
    this.discountPercent,
    this.discountAmount,
    this.taxPercent,
    this.taxableAmount,
    this.taxAmount,
    this.totalAmount,
    this.lineTotal,
    this.createdAt,
    this.updatedAt,
    this.containerNo,
    this.hsnCode,
    this.cgst,
    this.sgst,
    this.igst,
    this.cgstAmount,
    this.sgstAmount,
    this.igstAmount,
    this.finYearInt,
    this.liveQuantity,
    this.advanceQuantity,
    this.advanceFulfilledQty,
    this.expectedDate,
    this.foreignUnitPrice,
    this.foreignTotalAmount,
    this.beforeDiscountAmount,
    this.inch,
    this.height,
    this.width,
    this.tileWidth,
    this.tileLength,
    this.sqft,
    this.sqftRate,
    this.totalTiles,
    this.tilesPerBox,
    this.isLogNote,
    this.logNote,
    this.isDeleted,
    this.donatedQty,
    this.donationStatus,
    this.actualPrice,
    this.donationRemarks,
    this.taxPast,
    this.remarks,
    this.productName,
    this.productCode,
    this.imageUrl,
    this.unitOfMeasurment,
    this.uom,
    this.purchaseUom,
    this.saleUom,
    this.isWidth,
    this.itemWidth,
    this.currencyId,
    this.currencyName,
    this.currencyCode,
    this.codeKey,
    this.taxPercentage,
    this.isDiscount,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"]?.toString() ?? "",
    invoiceId: json["invoice_id"]?.toString() ?? "",
    productId: json["product_id"]?.toString() ?? "",
    description: json["description"],
    quantity: json["quantity"]?.toString() ?? "0",
    unitPrice: json["unit_price"]?.toString() ?? "0",
    discountPercent: json["discount_percent"]?.toString() ?? "0",
    discountAmount: json["discount_amount"]?.toString() ?? "0",
    taxPercent: json["tax_percent"]?.toString() ?? "0",
    taxableAmount: json["taxable_amount"]?.toString() ?? "0",
    taxAmount: json["tax_amount"]?.toString() ?? "0",
    totalAmount: json["total_amount"]?.toString() ?? "0",
    lineTotal: json["line_total"]?.toString() ?? "0",
    createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"].toString()) : null,
    updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"].toString()) : null,
    containerNo: json["container_no"],
    hsnCode: json["hsn_code"]?.toString() ?? "",
    cgst: json["cgst"],
    sgst: json["sgst"],
    igst: json["igst"]?.toString() ?? "0.0",
    cgstAmount: json["cgst_amount"]?.toString() ?? "0",
    sgstAmount: json["sgst_amount"]?.toString() ?? "0",
    igstAmount: json["igst_amount"]?.toString() ?? "0",
    finYearInt: json["fin_year_int"],
    liveQuantity: json["live_quantity"]?.toString() ?? "0",
    advanceQuantity: json["advance_quantity"]?.toString() ?? "0",
    advanceFulfilledQty: json["advance_fulfilled_qty"]?.toString() ?? "0",
    expectedDate: json["expected_date"],
    foreignUnitPrice: json["foreign_unit_price"]?.toString() ?? "0",
    foreignTotalAmount: json["foreign_total_amount"]?.toString() ?? "0",
    beforeDiscountAmount: json["before_discount_amount"]?.toString() ?? "0",
    inch: json["inch"],
    height: json["height"]?.toString() ?? "0",
    width: json["width"]?.toString() ?? "0",
    tileWidth: json["tile_width"]?.toString() ?? "0",
    tileLength: json["tile_length"]?.toString() ?? "0",
    sqft: json["sqft"]?.toString() ?? "0",
    sqftRate: json["sqft_rate"]?.toString() ?? "0",
    totalTiles: json["total_tiles"]?.toString() ?? "0",
    tilesPerBox: json["tiles_per_box"]?.toString() ?? "0",
    isLogNote: json["is_log_note"],
    logNote: json["log_note"],
    isDeleted: json["is_deleted"],
    donatedQty: json["donated_qty"]?.toString() ?? "0",
    donationStatus: json["donation_status"],
    actualPrice: json["actual_price"]?.toString() ?? "0",
    donationRemarks: json["donation_remarks"],
    taxPast: json["tax_past"],
    remarks: json["remarks"],
    productName: json["product_name"]?.toString() ?? "",
    productCode: json["product_code"]?.toString() ?? "",
    imageUrl: json["image_url"]?.toString() ?? "",
    unitOfMeasurment: json["unit_of_measurment"]?.toString() ?? "",
    uom: json["uom"]?.toString() ?? "",
    purchaseUom: json["purchase_uom"]?.toString() ?? "",
    saleUom: json["sale_uom"]?.toString() ?? "",
    isWidth: json["is_width"],
    itemWidth: json["item_width"]?.toString() ?? "0",
    currencyId: json["currency_id"],
    currencyName: json["currency_name"],
    currencyCode: json["currency_code"],
    codeKey: json["code_key"],
    taxPercentage: json["tax_percentage"]?.toString() ?? "0",
    isDiscount: json["is_discount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_id": invoiceId,
    "product_id": productId,
    "description": description,
    "quantity": quantity,
    "unit_price": unitPrice,
    "discount_percent": discountPercent,
    "discount_amount": discountAmount,
    "tax_percent": taxPercent,
    "taxable_amount": taxableAmount,
    "tax_amount": taxAmount,
    "total_amount": totalAmount,
    "line_total": lineTotal,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "container_no": containerNo,
    "hsn_code": hsnCode,
    "cgst": cgst,
    "sgst": sgst,
    "igst": igst,
    "cgst_amount": cgstAmount,
    "sgst_amount": sgstAmount,
    "igst_amount": igstAmount,
    "fin_year_int": finYearInt,
    "live_quantity": liveQuantity,
    "advance_quantity": advanceQuantity,
    "advance_fulfilled_qty": advanceFulfilledQty,
    "expected_date": expectedDate,
    "foreign_unit_price": foreignUnitPrice,
    "foreign_total_amount": foreignTotalAmount,
    "before_discount_amount": beforeDiscountAmount,
    "inch": inch,
    "height": height,
    "width": width,
    "tile_width": tileWidth,
    "tile_length": tileLength,
    "sqft": sqft,
    "sqft_rate": sqftRate,
    "total_tiles": totalTiles,
    "tiles_per_box": tilesPerBox,
    "is_log_note": isLogNote,
    "log_note": logNote,
    "is_deleted": isDeleted,
    "donated_qty": donatedQty,
    "donation_status": donationStatus,
    "actual_price": actualPrice,
    "donation_remarks": donationRemarks,
    "tax_past": taxPast,
    "remarks": remarks,
    "product_name": productName,
    "product_code": productCode,
    "image_url": imageUrl,
    "unit_of_measurment": unitOfMeasurment,
    "uom": uom,
    "purchase_uom": purchaseUom,
    "sale_uom": saleUom,
    "is_width": isWidth,
    "item_width": itemWidth,
    "currency_id": currencyId,
    "currency_name": currencyName,
    "currency_code": currencyCode,
    "codeKey": codeKey,
    "tax_percentage": taxPercentage,
    "is_discount": isDiscount,
  };
}

class LocationAddressDetail {
  String? companyName;
  String? address;
  String? cityName;
  String? stateName;
  String? stateCode;
  String? pincodeName;
  String? gstNo;
  String? gstCompanyName;

  LocationAddressDetail({
    this.companyName,
    this.address,
    this.cityName,
    this.stateName,
    this.stateCode,
    this.pincodeName,
    this.gstNo,
    this.gstCompanyName,
  });

  factory LocationAddressDetail.fromJson(Map<String, dynamic> json) => LocationAddressDetail(
    companyName: json["company_name"]?.toString() ?? "",
    address: json["address"]?.toString() ?? "",
    cityName: json["city_name"]?.toString() ?? "",
    stateName: json["state_name"]?.toString() ?? "",
    stateCode: json["state_code"]?.toString() ?? "",
    pincodeName: json["pincode_name"]?.toString() ?? "",
    gstNo: json["gst_no"]?.toString() ?? "",
    gstCompanyName: json["gst_company_name"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "company_name": companyName,
    "address": address,
    "city_name": cityName,
    "state_name": stateName,
    "state_code": stateCode,
    "pincode_name": pincodeName,
    "gst_no": gstNo,
    "gst_company_name": gstCompanyName,
  };
}

class Log {
  String? id;
  String? entityType;
  String? entityId;
  String? parentType;
  String? parentId;
  String? rootType;
  String? rootId;
  String? notes;
  String? logType;
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
    id: json["id"]?.toString() ?? "",
    entityType: json["entity_type"]?.toString() ?? "",
    entityId: json["entity_id"]?.toString() ?? "",
    parentType: json["parent_type"]?.toString() ?? "",
    parentId: json["parent_id"]?.toString() ?? "",
    rootType: json["root_type"]?.toString() ?? "",
    rootId: json["root_id"]?.toString() ?? "",
    notes: json["notes"]?.toString() ?? "",
    logType: json["log_type"]?.toString() ?? "",
    metadata: json["metadata"] != null && json["metadata"] is Map<String, dynamic> ? Metadata.fromJson(json["metadata"]) : null,
    attachmentUrl: json["attachment_url"],
    createdBy: json["created_by"]?.toString() ?? "",
    tenantId: json["tenant_id"]?.toString() ?? "",
    createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"].toString()) : null,
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
    "metadata": metadata?.toJson(),
    "attachment_url": attachmentUrl,
    "created_by": createdBy,
    "tenant_id": tenantId,
    "created_at": createdAt?.toIso8601String(),
    "created_by_name": createdByName,
  };
}

class Metadata {
  String? action;
  String? customerName;
  String? quotationNo;
  double? totalAmount;
  String? status;
  String? confirmedBy;
  String? invoiceNo;
  String? newStage;
  String? updatedBy;
  String? previousStage;
  bool? proformaConfirmation;

  Metadata({
    this.action,
    this.customerName,
    this.quotationNo,
    this.totalAmount,
    this.status,
    this.confirmedBy,
    this.invoiceNo,
    this.newStage,
    this.updatedBy,
    this.previousStage,
    this.proformaConfirmation,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    action: json["action"]?.toString(),
    customerName: json["customer_name"]?.toString(),
    quotationNo: json["quotation_no"]?.toString(),
    totalAmount: json["total_amount"] != null ? double.tryParse(json["total_amount"].toString()) : null,
    status: json["status"]?.toString(),
    confirmedBy: json["confirmed_by"]?.toString(),
    invoiceNo: json["invoice_no"]?.toString(),
    newStage: json["new_stage"]?.toString(),
    updatedBy: json["updated_by"]?.toString(),
    previousStage: json["previous_stage"]?.toString(),
    proformaConfirmation: json["proforma_confirmation"] is bool
        ? json["proforma_confirmation"]
        : (json["proforma_confirmation"]?.toString().toLowerCase() == 'true'),
  );

  Map<String, dynamic> toJson() => {
    "action": action,
    "customer_name": customerName,
    "quotation_no": quotationNo,
    "total_amount": totalAmount,
    "status": status,
    "confirmed_by": confirmedBy,
    "invoice_no": invoiceNo,
    "new_stage": newStage,
    "updated_by": updatedBy,
    "previous_stage": previousStage,
    "proforma_confirmation": proformaConfirmation,
  };
}

class SalesPersonsSplit {
  String? id;
  String? invoiceId;
  String? salesPersonId;
  bool? isPrimary;
  String? contributionPercentage;
  String? tenantId;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isDeleted;
  dynamic deletedAt;
  String? userId;
  String? userName;
  String? mobileNumber;
  String? email;
  String? salesPersonEmail;

  SalesPersonsSplit({
    this.id,
    this.invoiceId,
    this.salesPersonId,
    this.isPrimary,
    this.contributionPercentage,
    this.tenantId,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.deletedAt,
    this.userId,
    this.userName,
    this.mobileNumber,
    this.email,
    this.salesPersonEmail,
  });

  factory SalesPersonsSplit.fromJson(Map<String, dynamic> json) => SalesPersonsSplit(
    id: json["id"]?.toString() ?? "",
    invoiceId: json["invoice_id"]?.toString() ?? "",
    salesPersonId: json["sales_person_id"]?.toString() ?? "",
    isPrimary: json["is_primary"],
    contributionPercentage: json["contribution_percentage"]?.toString() ?? "0",
    tenantId: json["tenant_id"]?.toString() ?? "",
    createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"].toString()) : null,
    updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"].toString()) : null,
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    userId: json["user_id"]?.toString() ?? "",
    userName: json["user_name"]?.toString() ?? "",
    mobileNumber: json["mobile_number"]?.toString() ?? "",
    email: json["email"]?.toString() ?? "",
    salesPersonEmail: json["sales_person_email"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "invoice_id": invoiceId,
    "sales_person_id": salesPersonId,
    "is_primary": isPrimary,
    "contribution_percentage": contributionPercentage,
    "tenant_id": tenantId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "user_id": userId,
    "user_name": userName,
    "mobile_number": mobileNumber,
    "email": email,
    "sales_person_email": salesPersonEmail,
  };
}

class Summary {
  int? totalInvoices;

  Summary({this.totalInvoices});

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(totalInvoices: int.tryParse(json["total_invoices"]?.toString() ?? "0") ?? 0);

  Map<String, dynamic> toJson() => {"total_invoices": totalInvoices};
}
