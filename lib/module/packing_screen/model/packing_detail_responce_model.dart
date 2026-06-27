// To parse this JSON data, do
//
//     final packingCountResponseModel = packingCountResponseModelFromJson(jsonString);

import 'dart:convert';

PackingDetailResponseModel packingCountResponseModelFromJson(String str) => PackingDetailResponseModel.fromJson(json.decode(str));

String packingCountResponseModelToJson(PackingDetailResponseModel data) => json.encode(data.toJson());

class PackingDetailResponseModel {
  final bool? success;
  final String? message;
  final PackingDetailData? data;
  final int? status;
  final dynamic error;

  PackingDetailResponseModel({this.success, this.message, this.data, this.status, this.error});

  factory PackingDetailResponseModel.fromJson(Map<String, dynamic> json) => PackingDetailResponseModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : PackingDetailData.fromJson(json["data"]),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data?.toJson(), "status": status, "error": error};
}

class PackingDetailData {
  final String? id;
  final String? tenantId;
  final String? packingNo;
  final DateTime? packingDate;
  final String? pickingId;
  final String? invoiceId;
  final String? pickRequestId;
  final String? customerId;
  final dynamic warehouseId;
  final String? packedBy;
  final DateTime? packedAt;
  final int? totalPackages;
  final String? totalWeight;
  final String? totalVolume;
  final String? remarks;
  final String? status;
  final dynamic rejectionReason;
  final dynamic rejectedBy;
  final dynamic rejectedAt;
  final dynamic transportMode;
  final dynamic transporterId;
  final bool? isManualTransporter;
  final dynamic transporterName;
  final dynamic vehicleNo;
  final dynamic lrNo;
  final dynamic lrDate;
  final dynamic driverName;
  final dynamic driverContact;
  final dynamic transportRemarks;
  final dynamic ewayBillNo;
  final dynamic transporterGstin;
  final dynamic transporterPan;
  final bool? isRequiredEwaybill;
  final String? createdBy;
  final dynamic updatedBy;
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
  final String? salesPerson;
  final String? customerName;
  final Customer? customer;
  final Picking? picking;
  final Invoice? invoice;
  final dynamic shippingAddress;
  final dynamic billingAddress;
  final List<CustomerAddress>? customerAddresses;
  final List<DataItem>? items;
  final String? companyName;
  final String? locationName;
  final String? piRemarks;
  final dynamic dispatchStatus;
  final dynamic dispatchNo;
  final List<Log>? logs;
  final bool? isRegularInvoiceApproved;

  PackingDetailData({
    this.id,
    this.tenantId,
    this.packingNo,
    this.packingDate,
    this.pickingId,
    this.invoiceId,
    this.pickRequestId,
    this.customerId,
    this.warehouseId,
    this.packedBy,
    this.packedAt,
    this.totalPackages,
    this.totalWeight,
    this.totalVolume,
    this.remarks,
    this.status,
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
    this.salesPerson,
    this.customerName,
    this.customer,
    this.picking,
    this.invoice,
    this.shippingAddress,
    this.billingAddress,
    this.customerAddresses,
    this.items,
    this.companyName,
    this.locationName,
    this.piRemarks,
    this.dispatchStatus,
    this.dispatchNo,
    this.logs,
    this.isRegularInvoiceApproved,
  });

  factory PackingDetailData.fromJson(Map<String, dynamic> json) => PackingDetailData(
    id: json["id"],
    tenantId: json["tenant_id"],
    packingNo: json["packing_no"],
    packingDate: json["packing_date"] == null ? null : DateTime.parse(json["packing_date"]),
    pickingId: json["picking_id"],
    invoiceId: json["invoice_id"],
    pickRequestId: json["pick_request_id"],
    customerId: json["customer_id"],
    warehouseId: json["warehouse_id"],
    packedBy: json["packed_by"],
    packedAt: json["packed_at"] == null ? null : DateTime.parse(json["packed_at"]),
    totalPackages: json["total_packages"],
    totalWeight: json["total_weight"],
    totalVolume: json["total_volume"],
    remarks: json["remarks"],
    status: json["status"],
    rejectionReason: json["rejection_reason"],
    rejectedBy: json["rejected_by"],
    rejectedAt: json["rejected_at"],
    transportMode: json["transport_mode"],
    transporterId: json["transporter_id"],
    isManualTransporter: json["is_manual_transporter"],
    transporterName: json["transporter_name"],
    vehicleNo: json["vehicle_no"],
    lrNo: json["lr_no"],
    lrDate: json["lr_date"],
    driverName: json["driver_name"],
    driverContact: json["driver_contact"],
    transportRemarks: json["transport_remarks"],
    ewayBillNo: json["eway_bill_no"],
    transporterGstin: json["transporter_gstin"],
    transporterPan: json["transporter_pan"],
    isRequiredEwaybill: json["is_required_ewaybill"],
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
    salesPerson: json["sales_person"],
    customerName: json["customer_name"],
    customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    picking: json["picking"] == null ? null : Picking.fromJson(json["picking"]),
    invoice: json["invoice"] == null ? null : Invoice.fromJson(json["invoice"]),
    shippingAddress: json["shipping_address"],
    billingAddress: json["billing_address"],
    customerAddresses: json["customer_addresses"] == null
        ? []
        : List<CustomerAddress>.from(json["customer_addresses"]!.map((x) => CustomerAddress.fromJson(x))),
    items: json["items"] == null ? [] : List<DataItem>.from(json["items"]!.map((x) => DataItem.fromJson(x))),
    companyName: json["company_name"],
    locationName: json["location_name"],
    piRemarks: json["pi_remarks"],
    dispatchStatus: json["dispatch_status"],
    dispatchNo: json["dispatch_no"],
    logs: json["logs"] == null ? [] : List<Log>.from(json["logs"]!.map((x) => Log.fromJson(x))),
    isRegularInvoiceApproved: json["is_regular_invoice_approved"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "packing_no": packingNo,
    "packing_date":
        "${packingDate!.year.toString().padLeft(4, '0')}-${packingDate!.month.toString().padLeft(2, '0')}-${packingDate!.day.toString().padLeft(2, '0')}",
    "picking_id": pickingId,
    "invoice_id": invoiceId,
    "pick_request_id": pickRequestId,
    "customer_id": customerId,
    "warehouse_id": warehouseId,
    "packed_by": packedBy,
    "packed_at": packedAt?.toIso8601String(),
    "total_packages": totalPackages,
    "total_weight": totalWeight,
    "total_volume": totalVolume,
    "remarks": remarks,
    "status": status,
    "rejection_reason": rejectionReason,
    "rejected_by": rejectedBy,
    "rejected_at": rejectedAt,
    "transport_mode": transportMode,
    "transporter_id": transporterId,
    "is_manual_transporter": isManualTransporter,
    "transporter_name": transporterName,
    "vehicle_no": vehicleNo,
    "lr_no": lrNo,
    "lr_date": lrDate,
    "driver_name": driverName,
    "driver_contact": driverContact,
    "transport_remarks": transportRemarks,
    "eway_bill_no": ewayBillNo,
    "transporter_gstin": transporterGstin,
    "transporter_pan": transporterPan,
    "is_required_ewaybill": isRequiredEwaybill,
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
    "sales_person": salesPerson,
    "customer_name": customerName,
    "customer": customer?.toJson(),
    "picking": picking?.toJson(),
    "invoice": invoice?.toJson(),
    "shipping_address": shippingAddress,
    "billing_address": billingAddress,
    "customer_addresses": customerAddresses == null ? [] : List<dynamic>.from(customerAddresses!.map((x) => x.toJson())),
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "company_name": companyName,
    "location_name": locationName,
    "pi_remarks": piRemarks,
    "dispatch_status": dispatchStatus,
    "dispatch_no": dispatchNo,
    "logs": logs == null ? [] : List<dynamic>.from(logs!.map((x) => x.toJson())),
    "is_regular_invoice_approved": isRegularInvoiceApproved,
  };
}

class Customer {
  final String? id;
  final String? tenantId;
  final String? customerCode;
  final String? contactName;
  final String? address;
  final String? stateId;
  final String? cityId;
  final String? pincodeId;
  final dynamic billToAddressId;
  final dynamic shipToAddressId;
  final String? countryId;
  final String? pan;
  final String? personName;
  final String? jobPosition;
  final bool? isMobile;
  final String? mobile1CountryCode;
  final String? mobile1;
  final String? mobile2CountryCode;
  final String? mobile2;
  final String? landline;
  final dynamic email;
  final String? website;
  final String? tags;
  final String? companyName;
  final String? projectName;
  final String? remarks;
  final String? contactType;
  final dynamic sourceId;
  final dynamic customerType;
  final dynamic customerTypeCodeKey;
  final String? creditLimit;
  final int? creditDays;
  final String? temporaryCreditLimit;
  final String? outstandingAmount;
  final String? defaultPriceType;
  final String? defaultTaxType;
  final String? specialDiscountPercent;
  final String? overdueInterestPercent;
  final bool? isBlackListed;
  final bool? mobileService;
  final bool? emailService;
  final bool? allowTransactionBeyondCredit;
  final bool? isSez;
  final String? gstCategory;
  final String? gstCategoryId;
  final dynamic gstCategoryCodeKey;
  final String? aadhaarNumber;
  final String? gstNumber;
  final dynamic gstDate;
  final dynamic inquiryDate;
  final String? cstNumber;
  final dynamic cstDate;
  final String? serviceTaxNumber;
  final bool? isOpportunityCreated;
  final String? createdBy;
  final dynamic updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? customerGroupId;
  final dynamic customerBrandId;
  final bool? isCustomer;
  final bool? isActive;
  final bool? isDeleted;
  final dynamic deletedAt;
  final String? companyId;
  final String? companyCode;
  final String? finYear;
  final String? locationId;
  final String? locationCode;

  Customer({
    this.id,
    this.tenantId,
    this.customerCode,
    this.contactName,
    this.address,
    this.stateId,
    this.cityId,
    this.pincodeId,
    this.billToAddressId,
    this.shipToAddressId,
    this.countryId,
    this.pan,
    this.personName,
    this.jobPosition,
    this.isMobile,
    this.mobile1CountryCode,
    this.mobile1,
    this.mobile2CountryCode,
    this.mobile2,
    this.landline,
    this.email,
    this.website,
    this.tags,
    this.companyName,
    this.projectName,
    this.remarks,
    this.contactType,
    this.sourceId,
    this.customerType,
    this.customerTypeCodeKey,
    this.creditLimit,
    this.creditDays,
    this.temporaryCreditLimit,
    this.outstandingAmount,
    this.defaultPriceType,
    this.defaultTaxType,
    this.specialDiscountPercent,
    this.overdueInterestPercent,
    this.isBlackListed,
    this.mobileService,
    this.emailService,
    this.allowTransactionBeyondCredit,
    this.isSez,
    this.gstCategory,
    this.gstCategoryId,
    this.gstCategoryCodeKey,
    this.aadhaarNumber,
    this.gstNumber,
    this.gstDate,
    this.inquiryDate,
    this.cstNumber,
    this.cstDate,
    this.serviceTaxNumber,
    this.isOpportunityCreated,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.customerGroupId,
    this.customerBrandId,
    this.isCustomer,
    this.isActive,
    this.isDeleted,
    this.deletedAt,
    this.companyId,
    this.companyCode,
    this.finYear,
    this.locationId,
    this.locationCode,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    tenantId: json["tenant_id"],
    customerCode: json["customer_code"],
    contactName: json["contact_name"],
    address: json["address"],
    stateId: json["state_id"],
    cityId: json["city_id"],
    pincodeId: json["pincode_id"],
    billToAddressId: json["bill_to_address_id"],
    shipToAddressId: json["ship_to_address_id"],
    countryId: json["country_id"],
    pan: json["pan"],
    personName: json["person_name"],
    jobPosition: json["job_position"],
    isMobile: json["is_mobile"],
    mobile1CountryCode: json["mobile1_country_code"],
    mobile1: json["mobile1"],
    mobile2CountryCode: json["mobile2_country_code"],
    mobile2: json["mobile2"],
    landline: json["landline"],
    email: json["email"],
    website: json["website"],
    tags: json["tags"],
    companyName: json["company_name"],
    projectName: json["project_name"],
    remarks: json["remarks"],
    contactType: json["contact_type"],
    sourceId: json["source_id"],
    customerType: json["customer_type"],
    customerTypeCodeKey: json["customer_type_code_key"],
    creditLimit: json["credit_limit"],
    creditDays: json["credit_days"],
    temporaryCreditLimit: json["temporary_credit_limit"],
    outstandingAmount: json["outstanding_amount"],
    defaultPriceType: json["default_price_type"],
    defaultTaxType: json["default_tax_type"],
    specialDiscountPercent: json["special_discount_percent"],
    overdueInterestPercent: json["overdue_interest_percent"],
    isBlackListed: json["is_black_listed"],
    mobileService: json["mobile_service"],
    emailService: json["email_service"],
    allowTransactionBeyondCredit: json["allow_transaction_beyond_credit"],
    isSez: json["is_sez"],
    gstCategory: json["gst_category"],
    gstCategoryId: json["gst_category_id"],
    gstCategoryCodeKey: json["gst_category_code_key"],
    aadhaarNumber: json["aadhaar_number"],
    gstNumber: json["gst_number"],
    gstDate: json["gst_date"],
    inquiryDate: json["inquiry_date"],
    cstNumber: json["cst_number"],
    cstDate: json["cst_date"],
    serviceTaxNumber: json["service_tax_number"],
    isOpportunityCreated: json["is_opportunity_created"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    customerGroupId: json["customer_group_id"],
    customerBrandId: json["customer_brand_id"],
    isCustomer: json["is_customer"],
    isActive: json["is_active"],
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    companyId: json["company_id"],
    companyCode: json["company_code"],
    finYear: json["fin_year"],
    locationId: json["location_id"],
    locationCode: json["location_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "customer_code": customerCode,
    "contact_name": contactName,
    "address": address,
    "state_id": stateId,
    "city_id": cityId,
    "pincode_id": pincodeId,
    "bill_to_address_id": billToAddressId,
    "ship_to_address_id": shipToAddressId,
    "country_id": countryId,
    "pan": pan,
    "person_name": personName,
    "job_position": jobPosition,
    "is_mobile": isMobile,
    "mobile1_country_code": mobile1CountryCode,
    "mobile1": mobile1,
    "mobile2_country_code": mobile2CountryCode,
    "mobile2": mobile2,
    "landline": landline,
    "email": email,
    "website": website,
    "tags": tags,
    "company_name": companyName,
    "project_name": projectName,
    "remarks": remarks,
    "contact_type": contactType,
    "source_id": sourceId,
    "customer_type": customerType,
    "customer_type_code_key": customerTypeCodeKey,
    "credit_limit": creditLimit,
    "credit_days": creditDays,
    "temporary_credit_limit": temporaryCreditLimit,
    "outstanding_amount": outstandingAmount,
    "default_price_type": defaultPriceType,
    "default_tax_type": defaultTaxType,
    "special_discount_percent": specialDiscountPercent,
    "overdue_interest_percent": overdueInterestPercent,
    "is_black_listed": isBlackListed,
    "mobile_service": mobileService,
    "email_service": emailService,
    "allow_transaction_beyond_credit": allowTransactionBeyondCredit,
    "is_sez": isSez,
    "gst_category": gstCategory,
    "gst_category_id": gstCategoryId,
    "gst_category_code_key": gstCategoryCodeKey,
    "aadhaar_number": aadhaarNumber,
    "gst_number": gstNumber,
    "gst_date": gstDate,
    "inquiry_date": inquiryDate,
    "cst_number": cstNumber,
    "cst_date": cstDate,
    "service_tax_number": serviceTaxNumber,
    "is_opportunity_created": isOpportunityCreated,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "customer_group_id": customerGroupId,
    "customer_brand_id": customerBrandId,
    "is_customer": isCustomer,
    "is_active": isActive,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "company_id": companyId,
    "company_code": companyCode,
    "fin_year": finYear,
    "location_id": locationId,
    "location_code": locationCode,
  };
}

class CustomerAddress {
  final String? id;
  final String? type;
  final String? contactName;
  final String? companyName;
  final dynamic email;
  final String? mobile1CountryCode;
  final String? mobile1;
  final String? mobile2CountryCode;
  final String? mobile2;
  final String? street;
  final String? cityId;
  final String? stateId;
  final String? pincodeId;
  final String? countryId;
  final String? designation;
  final String? remarks;
  final dynamic source;
  final bool? isActive;
  final String? tenantId;
  final String? customerId;
  final String? createdBy;
  final dynamic updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;
  final dynamic deletedAt;
  final String? stateName;
  final String? cityName;
  final String? pinCode;
  final String? fullAddress;

  CustomerAddress({
    this.id,
    this.type,
    this.contactName,
    this.companyName,
    this.email,
    this.mobile1CountryCode,
    this.mobile1,
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
    this.cityName,
    this.pinCode,
    this.fullAddress,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) => CustomerAddress(
    id: json["id"],
    type: json["type"],
    contactName: json["contact_name"],
    companyName: json["company_name"],
    email: json["email"],
    mobile1CountryCode: json["mobile1_country_code"],
    mobile1: json["mobile_1"],
    mobile2CountryCode: json["mobile2_country_code"],
    mobile2: json["mobile_2"],
    street: json["street"],
    cityId: json["city_id"],
    stateId: json["state_id"],
    pincodeId: json["pincode_id"],
    countryId: json["country_id"],
    designation: json["designation"],
    remarks: json["remarks"],
    source: json["source"],
    isActive: json["is_active"],
    tenantId: json["tenant_id"],
    customerId: json["customer_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isDeleted: json["is_deleted"],
    deletedAt: json["deleted_at"],
    stateName: json["state_name"],
    cityName: json["city_name"],
    pinCode: json["pin_code"],
    fullAddress: json["full_address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "contact_name": contactName,
    "company_name": companyName,
    "email": email,
    "mobile1_country_code": mobile1CountryCode,
    "mobile_1": mobile1,
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
    "city_name": cityName,
    "pin_code": pinCode,
    "full_address": fullAddress,
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
  final String? remarks;
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
  final dynamic siteVisitRemark;
  final String? siteVisitAttachment;
  final String? creditAttachment;
  final String? creditRemark;
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
  final String? creditRequestStatus;
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
  final List<dynamic>? charges;
  final String? paymentTermsName;
  final List<InvoiceItem>? items;

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
    this.charges,
    this.paymentTermsName,
    this.items,
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
    charges: json["charges"] == null ? [] : List<dynamic>.from(json["charges"]!.map((x) => x)),
    paymentTermsName: json["payment_terms_name"],
    items: json["items"] == null ? [] : List<InvoiceItem>.from(json["items"]!.map((x) => InvoiceItem.fromJson(x))),
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
    "charges": charges == null ? [] : List<dynamic>.from(charges!.map((x) => x)),
    "payment_terms_name": paymentTermsName,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class InvoiceItem {
  final String? id;
  final String? invoiceId;
  final String? productId;
  final dynamic description;
  final String? quantity;
  final String? unitPrice;
  final String? discountPercent;
  final String? discountAmount;
  final String? taxPercent;
  final String? taxableAmount;
  final String? taxAmount;
  final String? totalAmount;
  final String? lineTotal;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic containerNo;
  final dynamic hsnCode;
  final dynamic cgst;
  final dynamic sgst;
  final String? igst;
  final String? cgstAmount;
  final String? sgstAmount;
  final String? igstAmount;
  final dynamic finYearInt;
  final String? liveQuantity;
  final String? advanceQuantity;
  final String? advanceFulfilledQty;
  final dynamic expectedDate;
  final String? foreignUnitPrice;
  final String? foreignTotalAmount;
  final String? beforeDiscountAmount;
  final dynamic inch;
  final String? height;
  final String? width;
  final String? tileWidth;
  final String? tileLength;
  final String? sqft;
  final String? sqftRate;
  final String? totalTiles;
  final String? tilesPerBox;
  final bool? isLogNote;
  final dynamic logNote;
  final bool? isDeleted;
  final String? donatedQty;
  final dynamic donationStatus;
  final String? productName;
  final String? productCode;
  final String? imageUrl;

  InvoiceItem({
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
    this.productName,
    this.productCode,
    this.imageUrl,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
    id: json["id"],
    invoiceId: json["invoice_id"],
    productId: json["product_id"],
    description: json["description"],
    quantity: json["quantity"],
    unitPrice: json["unit_price"],
    discountPercent: json["discount_percent"],
    discountAmount: json["discount_amount"],
    taxPercent: json["tax_percent"],
    taxableAmount: json["taxable_amount"],
    taxAmount: json["tax_amount"],
    totalAmount: json["total_amount"],
    lineTotal: json["line_total"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    containerNo: json["container_no"],
    hsnCode: json["hsn_code"],
    cgst: json["cgst"],
    sgst: json["sgst"],
    igst: json["igst"],
    cgstAmount: json["cgst_amount"],
    sgstAmount: json["sgst_amount"],
    igstAmount: json["igst_amount"],
    finYearInt: json["fin_year_int"],
    liveQuantity: json["live_quantity"],
    advanceQuantity: json["advance_quantity"],
    advanceFulfilledQty: json["advance_fulfilled_qty"],
    expectedDate: json["expected_date"],
    foreignUnitPrice: json["foreign_unit_price"],
    foreignTotalAmount: json["foreign_total_amount"],
    beforeDiscountAmount: json["before_discount_amount"],
    inch: json["inch"],
    height: json["height"],
    width: json["width"],
    tileWidth: json["tile_width"],
    tileLength: json["tile_length"],
    sqft: json["sqft"],
    sqftRate: json["sqft_rate"],
    totalTiles: json["total_tiles"],
    tilesPerBox: json["tiles_per_box"],
    isLogNote: json["is_log_note"],
    logNote: json["log_note"],
    isDeleted: json["is_deleted"],
    donatedQty: json["donated_qty"],
    donationStatus: json["donation_status"],
    productName: json["product_name"],
    productCode: json["product_code"],
    imageUrl: json["image_url"],
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
    "product_name": productName,
    "product_code": productCode,
    "image_url": imageUrl,
  };
}

class DataItem {
  final String? id;
  final String? tenantId;
  final String? packingId;
  final String? pickingItemId;
  final String? productId;
  final String? pickedQty;
  final String? packedQty;
  final String? orderedQty;
  final dynamic packageNo;
  final dynamic cartonNo;
  final String? batchNo;
  final List<String>? serialIds;
  final dynamic weight;
  final dynamic remarks;
  final String? createdBy;
  final dynamic updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isDeleted;
  final Product? product;
  final bool? isBatchWise;
  final List<String>? serialNumbers;
  final int? batchQuantity;
  final List<String>? batchNumbers;

  DataItem({
    this.id,
    this.tenantId,
    this.packingId,
    this.pickingItemId,
    this.productId,
    this.pickedQty,
    this.packedQty,
    this.orderedQty,
    this.packageNo,
    this.cartonNo,
    this.batchNo,
    this.serialIds,
    this.weight,
    this.remarks,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.product,
    this.isBatchWise,
    this.serialNumbers,
    this.batchQuantity,
    this.batchNumbers,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) => DataItem(
    id: json["id"],
    tenantId: json["tenant_id"],
    packingId: json["packing_id"],
    pickingItemId: json["picking_item_id"],
    productId: json["product_id"],
    pickedQty: json["picked_qty"],
    packedQty: json["packed_qty"],
    orderedQty: json["ordered_qty"],
    packageNo: json["package_no"],
    cartonNo: json["carton_no"],
    batchNo: json["batch_no"],
    serialIds: json["serial_ids"] == null ? [] : List<String>.from(json["serial_ids"]!.where((x) => x != null).map((x) => x)),
    weight: json["weight"],
    remarks: json["remarks"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isDeleted: json["is_deleted"],
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    isBatchWise: json["is_batch_wise"],
    serialNumbers: json["serial_numbers"] == null ? [] : List<String>.from(json["serial_numbers"]!.where((x) => x != null).map((x) => x)),
    batchQuantity: json["batch_quantity"],
    batchNumbers: json["batch_numbers"] == null ? [] : List<String>.from(json["batch_numbers"]!.where((x) => x != null).map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "packing_id": packingId,
    "picking_item_id": pickingItemId,
    "product_id": productId,
    "picked_qty": pickedQty,
    "packed_qty": packedQty,
    "ordered_qty": orderedQty,
    "package_no": packageNo,
    "carton_no": cartonNo,
    "batch_no": batchNo,
    "serial_ids": serialIds == null ? [] : List<dynamic>.from(serialIds!.map((x) => x)),
    "weight": weight,
    "remarks": remarks,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_deleted": isDeleted,
    "product": product?.toJson(),
    "is_batch_wise": isBatchWise,
    "serial_numbers": serialNumbers == null ? [] : List<dynamic>.from(serialNumbers!.map((x) => x)),
    "batch_quantity": batchQuantity,
    "batch_numbers": batchNumbers == null ? [] : List<dynamic>.from(batchNumbers!.map((x) => x)),
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
  final dynamic storageTemperatureId;
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
  final String? imageUrl;
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
    imageUrl: json["image_url"],
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
    "image_url": imageUrl,
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
  final String? invoiceType;
  final int? totalAmount;

  Metadata({
    this.to,
    this.from,
    this.field,
    this.invoiceNo,
    this.pickingNo,
    this.autoCreated,
    this.confirmedBy,
    this.proformaConfirmation,
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
    "invoice_type": invoiceType,
    "total_amount": totalAmount,
  };
}

class Picking {
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

  Picking({
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
  });

  factory Picking.fromJson(Map<String, dynamic> json) => Picking(
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
  };
}
