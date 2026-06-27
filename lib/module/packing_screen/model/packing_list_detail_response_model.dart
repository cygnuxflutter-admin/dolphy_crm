import 'dart:convert';

PackingListDetailResponse packingListDetailResponseFromJson(String str) =>
    PackingListDetailResponse.fromJson(json.decode(str));

String packingListDetailResponseToJson(PackingListDetailResponse data) =>
    json.encode(data.toJson());

class PackingListDetailResponse {
  final bool? success;
  final String? message;
  final PackingListDetailData? data;
  final int? status;
  final dynamic error;

  PackingListDetailResponse({
    this.success,
    this.message,
    this.data,
    this.status,
    this.error,
  });

  factory PackingListDetailResponse.fromJson(Map<String, dynamic> json) =>
      PackingListDetailResponse(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        data: json["data"] == null
            ? null
            : PackingListDetailData.fromJson(json["data"] as Map<String, dynamic>),
        status: json["status"] as int?,
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

class PackingListDetailData {
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
  final bool? isPackingDetailSaved;
  final String? salesPerson;
  final String? customerName;
  final PackingListCustomer? customer;
  final PackingListPicking? picking;
  final PackingListInvoice? invoice;
  final dynamic shippingAddress;
  final dynamic billingAddress;
  final List<PackingListCustomerAddress>? customerAddresses;
  final List<PackingListDataItem>? items;
  final String? companyName;
  final String? locationName;
  final String? piRemarks;
  final dynamic dispatchStatus;
  final dynamic dispatchNo;
  final List<PackingListLog>? logs;

  PackingListDetailData({
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
    this.isPackingDetailSaved,
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
  });

  factory PackingListDetailData.fromJson(Map<String, dynamic> json) =>
      PackingListDetailData(
        id: json["id"] as String?,
        tenantId: json["tenant_id"] as String?,
        packingNo: json["packing_no"] as String?,
        packingDate: json["packing_date"] == null
            ? null
            : DateTime.tryParse(json["packing_date"] as String),
        pickingId: json["picking_id"] as String?,
        invoiceId: json["invoice_id"] as String?,
        pickRequestId: json["pick_request_id"] as String?,
        customerId: json["customer_id"] as String?,
        warehouseId: json["warehouse_id"],
        packedBy: json["packed_by"] as String?,
        packedAt: json["packed_at"] == null
            ? null
            : DateTime.tryParse(json["packed_at"] as String),
        totalPackages: json["total_packages"] as int?,
        totalWeight: json["total_weight"] as String?,
        totalVolume: json["total_volume"] as String?,
        remarks: json["remarks"] as String?,
        status: json["status"] as String?,
        rejectionReason: json["rejection_reason"],
        rejectedBy: json["rejected_by"],
        rejectedAt: json["rejected_at"],
        transportMode: json["transport_mode"],
        transporterId: json["transporter_id"],
        isManualTransporter: json["is_manual_transporter"] as bool?,
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
        isRequiredEwaybill: json["is_required_ewaybill"] as bool?,
        createdBy: json["created_by"] as String?,
        updatedBy: json["updated_by"] as String?,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] as String),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"] as String),
        isDeleted: json["is_deleted"] as bool?,
        deletedBy: json["deleted_by"],
        deletedAt: json["deleted_at"],
        companyId: json["company_id"] as String?,
        companyCode: json["company_code"] as String?,
        finYear: json["fin_year"] as String?,
        locationId: json["location_id"] as String?,
        locationCode: json["location_code"] as String?,
        isPackingDetailSaved: json["is_packing_detail_saved"] as bool?,
        salesPerson: json["sales_person"] as String?,
        customerName: json["customer_name"] as String?,
        customer: json["customer"] == null
            ? null
            : PackingListCustomer.fromJson(json["customer"] as Map<String, dynamic>),
        picking: json["picking"] == null
            ? null
            : PackingListPicking.fromJson(json["picking"] as Map<String, dynamic>),
        invoice: json["invoice"] == null
            ? null
            : PackingListInvoice.fromJson(json["invoice"] as Map<String, dynamic>),
        shippingAddress: json["shipping_address"],
        billingAddress: json["billing_address"],
        customerAddresses: json["customer_addresses"] == null
            ? null
            : List<PackingListCustomerAddress>.from(
                (json["customer_addresses"] as List).map(
                  (x) => PackingListCustomerAddress.fromJson(x as Map<String, dynamic>),
                ),
              ),
        items: json["items"] == null
            ? null
            : List<PackingListDataItem>.from(
                (json["items"] as List).map(
                  (x) => PackingListDataItem.fromJson(x as Map<String, dynamic>),
                ),
              ),
        companyName: json["company_name"] as String?,
        locationName: json["location_name"] as String?,
        piRemarks: json["pi_remarks"] as String?,
        dispatchStatus: json["dispatch_status"],
        dispatchNo: json["dispatch_no"],
        logs: json["logs"] == null
            ? null
            : List<PackingListLog>.from(
                (json["logs"] as List).map(
                  (x) => PackingListLog.fromJson(x as Map<String, dynamic>),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "packing_no": packingNo,
        "packing_date": packingDate?.toIso8601String(),
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
        "is_packing_detail_saved": isPackingDetailSaved,
        "sales_person": salesPerson,
        "customer_name": customerName,
        "customer": customer?.toJson(),
        "picking": picking?.toJson(),
        "invoice": invoice?.toJson(),
        "shipping_address": shippingAddress,
        "billing_address": billingAddress,
        "customer_addresses":
            customerAddresses?.map((x) => x.toJson()).toList(),
        "items": items?.map((x) => x.toJson()).toList(),
        "company_name": companyName,
        "location_name": locationName,
        "pi_remarks": piRemarks,
        "dispatch_status": dispatchStatus,
        "dispatch_no": dispatchNo,
        "logs": logs?.map((x) => x.toJson()).toList(),
      };
}

class PackingListCustomer {
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
  final String? email;
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

  PackingListCustomer({
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

  factory PackingListCustomer.fromJson(Map<String, dynamic> json) => PackingListCustomer(
        id: json["id"] as String?,
        tenantId: json["tenant_id"] as String?,
        customerCode: json["customer_code"] as String?,
        contactName: json["contact_name"] as String?,
        address: json["address"] as String?,
        stateId: json["state_id"] as String?,
        cityId: json["city_id"] as String?,
        pincodeId: json["pincode_id"] as String?,
        billToAddressId: json["bill_to_address_id"],
        shipToAddressId: json["ship_to_address_id"],
        countryId: json["country_id"] as String?,
        pan: json["pan"] as String?,
        personName: json["person_name"] as String?,
        jobPosition: json["job_position"] as String?,
        isMobile: json["is_mobile"] as bool?,
        mobile1CountryCode: json["mobile1_country_code"] as String?,
        mobile1: json["mobile1"] as String?,
        mobile2CountryCode: json["mobile2_country_code"] as String?,
        mobile2: json["mobile2"] as String?,
        landline: json["landline"] as String?,
        email: json["email"] as String?,
        website: json["website"] as String?,
        tags: json["tags"] as String?,
        companyName: json["company_name"] as String?,
        projectName: json["project_name"] as String?,
        remarks: json["remarks"] as String?,
        contactType: json["contact_type"] as String?,
        sourceId: json["source_id"],
        customerType: json["customer_type"],
        customerTypeCodeKey: json["customer_type_code_key"],
        creditLimit: json["credit_limit"] as String?,
        creditDays: json["credit_days"] as int?,
        temporaryCreditLimit: json["temporary_credit_limit"] as String?,
        outstandingAmount: json["outstanding_amount"] as String?,
        defaultPriceType: json["default_price_type"] as String?,
        defaultTaxType: json["default_tax_type"] as String?,
        specialDiscountPercent: json["special_discount_percent"] as String?,
        overdueInterestPercent: json["overdue_interest_percent"] as String?,
        isBlackListed: json["is_black_listed"] as bool?,
        mobileService: json["mobile_service"] as bool?,
        emailService: json["email_service"] as bool?,
        allowTransactionBeyondCredit:
            json["allow_transaction_beyond_credit"] as bool?,
        isSez: json["is_sez"] as bool?,
        gstCategory: json["gst_category"] as String?,
        gstCategoryId: json["gst_category_id"] as String?,
        gstCategoryCodeKey: json["gst_category_code_key"],
        aadhaarNumber: json["aadhaar_number"] as String?,
        gstNumber: json["gst_number"] as String?,
        gstDate: json["gst_date"],
        inquiryDate: json["inquiry_date"],
        cstNumber: json["cst_number"] as String?,
        cstDate: json["cst_date"],
        serviceTaxNumber: json["service_tax_number"] as String?,
        isOpportunityCreated: json["is_opportunity_created"] as bool?,
        createdBy: json["created_by"] as String?,
        updatedBy: json["updated_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] as String),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"] as String),
        customerGroupId: json["customer_group_id"] as String?,
        customerBrandId: json["customer_brand_id"],
        isCustomer: json["is_customer"] as bool?,
        isActive: json["is_active"] as bool?,
        isDeleted: json["is_deleted"] as bool?,
        deletedAt: json["deleted_at"],
        companyId: json["company_id"] as String?,
        companyCode: json["company_code"] as String?,
        finYear: json["fin_year"] as String?,
        locationId: json["location_id"] as String?,
        locationCode: json["location_code"] as String?,
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

class PackingListCustomerAddress {
  final String? id;
  final String? type;
  final String? contactName;
  final String? companyName;
  final String? email;
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

  PackingListCustomerAddress({
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

  factory PackingListCustomerAddress.fromJson(Map<String, dynamic> json) =>
      PackingListCustomerAddress(
        id: json["id"] as String?,
        type: json["type"] as String?,
        contactName: json["contact_name"] as String?,
        companyName: json["company_name"] as String?,
        email: json["email"] as String?,
        mobile1CountryCode: json["mobile1_country_code"] as String?,
        mobile1: json["mobile_1"] as String?,
        mobile2CountryCode: json["mobile2_country_code"] as String?,
        mobile2: json["mobile_2"] as String?,
        street: json["street"] as String?,
        cityId: json["city_id"] as String?,
        stateId: json["state_id"] as String?,
        pincodeId: json["pincode_id"] as String?,
        countryId: json["country_id"] as String?,
        designation: json["designation"] as String?,
        remarks: json["remarks"] as String?,
        source: json["source"],
        isActive: json["is_active"] as bool?,
        tenantId: json["tenant_id"] as String?,
        customerId: json["customer_id"] as String?,
        createdBy: json["created_by"] as String?,
        updatedBy: json["updated_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] as String),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"] as String),
        isDeleted: json["is_deleted"] as bool?,
        deletedAt: json["deleted_at"],
        stateName: json["state_name"] as String?,
        cityName: json["city_name"] as String?,
        pinCode: json["pin_code"] as String?,
        fullAddress: json["full_address"] as String?,
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

class PackingListInvoice {
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
  final List<dynamic>? charges;
  final String? paymentTermsName;
  final List<PackingListInvoiceItem>? items;

  PackingListInvoice({
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
    this.charges,
    this.paymentTermsName,
    this.items,
  });

  factory PackingListInvoice.fromJson(Map<String, dynamic> json) => PackingListInvoice(
        id: json["id"] as String?,
        tenantId: json["tenant_id"] as String?,
        invoiceNo: json["invoice_no"] as String?,
        invoiceType: json["invoice_type"] as String?,
        parentInvoiceId: json["parent_invoice_id"],
        stockLocationId: json["stock_location_id"],
        collectionType: json["collection_type"] as String?,
        collectionTypeId: json["collection_type_id"] as String?,
        quotationId: json["quotation_id"],
        customerId: json["customer_id"] as String?,
        opportunityId: json["opportunity_id"],
        invoiceDate: json["invoice_date"] == null
            ? null
            : DateTime.tryParse(json["invoice_date"] as String),
        dueDate: json["due_date"] == null
            ? null
            : DateTime.tryParse(json["due_date"] as String),
        subtotal: json["subtotal"] as String?,
        totalBeforeDiscountAmount:
            json["total_before_discount_amount"] as String?,
        taxAmount: json["tax_amount"] as String?,
        discountAmount: json["discount_amount"] as String?,
        totalAmount: json["total_amount"] as String?,
        totalTaxableAmount: json["total_taxable_amount"] as String?,
        totalTaxAmount: json["total_tax_amount"] as String?,
        overallDiscount: json["overall_discount"] as String?,
        overallDiscountAmount: json["overall_discount_amount"] as String?,
        totalDiscount: json["total_discount"] as String?,
        totalChargesAmount: json["total_charges_amount"] as String?,
        finalTotalAmount: json["final_total_amount"] as String?,
        roundOff: json["round_off"] as String?,
        totalCgstAmount: json["total_cgst_amount"] as String?,
        totalSgstAmount: json["total_sgst_amount"] as String?,
        totalIgstAmount: json["total_igst_amount"] as String?,
        paidAmount: json["paid_amount"] as String?,
        balanceAmount: json["balance_amount"] as String?,
        billingAddress: json["billing_address"] as String?,
        shippingAddress: json["shipping_address"] as String?,
        paymentStatus: json["payment_status"] as String?,
        deliveryStatus: json["delivery_status"] as String?,
        status: json["status"] as String?,
        isCancelled: json["is_cancelled"] as bool?,
        cancelledAt: json["cancelled_at"],
        cancelledBy: json["cancelled_by"],
        remarks: json["remarks"] as String?,
        termsConditions: json["terms_conditions"],
        paymentTerms: json["payment_terms"] as String?,
        gstTreatmentId: json["gst_treatment_id"] as String?,
        gstCategoryCodeKey: json["gst_category_code_key"],
        createdBy: json["created_by"] as String?,
        updatedBy: json["updated_by"] as String?,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] as String),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"] as String),
        isDeleted: json["is_deleted"] as bool?,
        deletedAt: json["deleted_at"],
        isApproval: json["is_approval"] as bool?,
        approvalStatus: json["approval_status"] as String?,
        approvedBy: json["approved_by"],
        approvedAt: json["approved_at"],
        approvalRemarks: json["approval_remarks"],
        isPiApproved: json["is_pi_approved"] as bool?,
        piApprovedBy: json["pi_approved_by"] as String?,
        piApprovedAt: json["pi_approved_at"] == null
            ? null
            : DateTime.tryParse(json["pi_approved_at"] as String),
        isPostedForPi: json["is_posted_for_pi"] as bool?,
        postedForPiBy: json["posted_for_pi_by"] as String?,
        postedForPiAt: json["posted_for_pi_at"] == null
            ? null
            : DateTime.tryParse(json["posted_for_pi_at"] as String),
        advanceReceived: json["advance_received"] as String?,
        netPayable: json["net_payable"] as String?,
        isAdvancePaymentTerm: json["is_advance_payment_term"] as bool?,
        advancePaymentsCount: json["advance_payments_count"] as int?,
        transporterId: json["transporter_id"],
        stockApprovalId: json["stock_approval_id"],
        isStockApproved: json["is_stock_approved"] as bool?,
        packingId: json["packing_id"],
        isRequiredEwaybill: json["is_required_ewaybill"] as bool?,
        ewayBillNo: json["eway_bill_no"],
        transporterGstin: json["transporter_gstin"],
        transporterName: json["transporter_name"],
        transportModeId: json["transport_mode_id"] as String?,
        transportMode: json["transport_mode"],
        lrNo: json["lr_no"],
        driverName: json["driver_name"],
        driverContact: json["driver_contact"],
        transportRemarks: json["transport_remarks"],
        vehicleNo: json["vehicle_no"],
        isConfirmed: json["is_confirmed"] as bool?,
        confirmedBy: json["confirmed_by"],
        confirmedAt: json["confirmed_at"],
        attachments: json["attachments"] as String?,
        advanceAmount: json["advance_amount"] as String?,
        advanceAttachment: json["advance_attachment"] as String?,
        siteVisitRemark: json["site_visit_remark"],
        siteVisitAttachment: json["site_visit_attachment"] as String?,
        creditAttachment: json["credit_attachment"] as String?,
        creditRemark: json["credit_remark"] as String?,
        priority: json["priority"] as String?,
        companyId: json["company_id"] as String?,
        companyCode: json["company_code"] as String?,
        finYear: json["fin_year"] as String?,
        finYearInt: json["fin_year_int"],
        receiverName: json["receiver_name"] as String?,
        receiverMobileNumber: json["receiver_mobile_number"] as String?,
        receiverCountryCode: json["receiver_country_code"] as String?,
        locationCode: json["location_code"] as String?,
        poDate: json["po_date"],
        poNumber: json["po_number"],
        creditRequestStatus: json["credit_request_status"] as String?,
        email: json["email"] as String?,
        isExport: json["is_export"] as bool?,
        currencyId: json["currency_id"],
        exchangeRate: json["exchange_rate"] as String?,
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
        totalReturnedQty: json["total_returned_qty"] as String?,
        totalReturnedAmount: json["total_returned_amount"] as String?,
        hasReturns: json["has_returns"] as bool?,
        isMigrated: json["is_migrated"] as bool?,
        isSalesMigrated: json["is_sales_migrated"] as bool?,
        migrationSource: json["migration_source"],
        migrationBatchId: json["migration_batch_id"],
        isAccounted: json["is_accounted"] as bool?,
        piAutoCancelAt: json["pi_auto_cancel_at"],
        taxInvoiceId: json["tax_invoice_id"],
        taxInvoiceNo: json["tax_invoice_no"],
        dcId: json["dc_id"],
        dcNo: json["dc_no"],
        isDcFlow: json["is_dc_flow"] as bool?,
        isSaleReturnTaxInvoice: json["is_sale_return_tax_invoice"] as bool?,
        saleReturnId: json["sale_return_id"],
        customerRemark: json["customer_remark"],
        outstandingRemarks: json["outstanding_remarks"],
        isEwayCancelled: json["is_eway_cancelled"] as bool?,
        ewayCancelledAt: json["eway_cancelled_at"],
        ewayCancelledBy: json["eway_cancelled_by"],
        ewayCancelRemarks: json["eway_cancel_remarks"],
        isIrnCancelled: json["is_irn_cancelled"] as bool?,
        irnCancelledAt: json["irn_cancelled_at"],
        irnCancelledBy: json["irn_cancelled_by"],
        irnCancelRemarks: json["irn_cancel_remarks"],
        cancelledTiRef: json["cancelled_ti_ref"],
        piTypeId: json["pi_type_id"] as String?,
        piType: json["pi_type"] as String?,
        charges: json["charges"] == null
            ? null
            : List<dynamic>.from(json["charges"] as List),
        paymentTermsName: json["payment_terms_name"] as String?,
        items: json["items"] == null
            ? null
            : List<PackingListInvoiceItem>.from(
                (json["items"] as List).map(
                  (x) => PackingListInvoiceItem.fromJson(x as Map<String, dynamic>),
                ),
              ),
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
        "invoice_date": invoiceDate?.toIso8601String(),
        "due_date": dueDate?.toIso8601String(),
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
        "charges": charges,
        "payment_terms_name": paymentTermsName,
        "items": items?.map((x) => x.toJson()).toList(),
      };
}

class PackingListInvoiceItem {
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

  PackingListInvoiceItem({
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

  factory PackingListInvoiceItem.fromJson(Map<String, dynamic> json) => PackingListInvoiceItem(
        id: json["id"] as String?,
        invoiceId: json["invoice_id"] as String?,
        productId: json["product_id"] as String?,
        description: json["description"],
        quantity: json["quantity"] as String?,
        unitPrice: json["unit_price"] as String?,
        discountPercent: json["discount_percent"] as String?,
        discountAmount: json["discount_amount"] as String?,
        taxPercent: json["tax_percent"] as String?,
        taxableAmount: json["taxable_amount"] as String?,
        taxAmount: json["tax_amount"] as String?,
        totalAmount: json["total_amount"] as String?,
        lineTotal: json["line_total"] as String?,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] as String),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"] as String),
        containerNo: json["container_no"],
        hsnCode: json["hsn_code"],
        cgst: json["cgst"],
        sgst: json["sgst"],
        igst: json["igst"] as String?,
        cgstAmount: json["cgst_amount"] as String?,
        sgstAmount: json["sgst_amount"] as String?,
        igstAmount: json["igst_amount"] as String?,
        finYearInt: json["fin_year_int"],
        liveQuantity: json["live_quantity"] as String?,
        advanceQuantity: json["advance_quantity"] as String?,
        advanceFulfilledQty: json["advance_fulfilled_qty"] as String?,
        expectedDate: json["expected_date"],
        foreignUnitPrice: json["foreign_unit_price"] as String?,
        foreignTotalAmount: json["foreign_total_amount"] as String?,
        beforeDiscountAmount: json["before_discount_amount"] as String?,
        inch: json["inch"],
        height: json["height"] as String?,
        width: json["width"] as String?,
        tileWidth: json["tile_width"] as String?,
        tileLength: json["tile_length"] as String?,
        sqft: json["sqft"] as String?,
        sqftRate: json["sqft_rate"] as String?,
        totalTiles: json["total_tiles"] as String?,
        tilesPerBox: json["tiles_per_box"] as String?,
        isLogNote: json["is_log_note"] as bool?,
        logNote: json["log_note"],
        isDeleted: json["is_deleted"] as bool?,
        donatedQty: json["donated_qty"] as String?,
        donationStatus: json["donation_status"],
        productName: json["product_name"] as String?,
        productCode: json["product_code"] as String?,
        imageUrl: json["image_url"] as String?,
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

class PackingListPicking {
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

  PackingListPicking({
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

  factory PackingListPicking.fromJson(Map<String, dynamic> json) => PackingListPicking(
        id: json["id"] as String?,
        tenantId: json["tenant_id"] as String?,
        pickingNo: json["picking_no"] as String?,
        pickingDate: json["picking_date"] == null
            ? null
            : DateTime.tryParse(json["picking_date"] as String),
        invoiceId: json["invoice_id"] as String?,
        pickRequestId: json["pick_request_id"] as String?,
        customerId: json["customer_id"] as String?,
        warehouseId: json["warehouse_id"],
        assignedTo: json["assigned_to"],
        assignedAt: json["assigned_at"],
        priority: json["priority"] as String?,
        remarks: json["remarks"],
        status: json["status"] as String?,
        startedAt: json["started_at"],
        completedAt: json["completed_at"] == null
            ? null
            : DateTime.tryParse(json["completed_at"] as String),
        createdBy: json["created_by"] as String?,
        updatedBy: json["updated_by"] as String?,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] as String),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"] as String),
        isDeleted: json["is_deleted"] as bool?,
        deletedBy: json["deleted_by"],
        deletedAt: json["deleted_at"],
        companyId: json["company_id"] as String?,
        companyCode: json["company_code"] as String?,
        finYear: json["fin_year"] as String?,
        locationId: json["location_id"] as String?,
        locationCode: json["location_code"] as String?,
        isViewed: json["is_viewed"] as bool?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "picking_no": pickingNo,
        "picking_date": pickingDate?.toIso8601String(),
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

class PackingListDataItem {
  final String? id;
  final String? tenantId;
  final String? packingId;
  final String? pickingItemId;
  final String? productId;
  final String? pickedQty;
  final String? packedQty;
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
  final PackingListProduct? product;
  final bool? isBatchWise;
  final List<String>? serialNumbers;
  final int? batchQuantity;
  final List<String>? batchNumbers;

  PackingListDataItem({
    this.id,
    this.tenantId,
    this.packingId,
    this.pickingItemId,
    this.productId,
    this.pickedQty,
    this.packedQty,
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

  factory PackingListDataItem.fromJson(Map<String, dynamic> json) => PackingListDataItem(
        id: json["id"] as String?,
        tenantId: json["tenant_id"] as String?,
        packingId: json["packing_id"] as String?,
        pickingItemId: json["picking_item_id"] as String?,
        productId: json["product_id"] as String?,
        pickedQty: json["picked_qty"] as String?,
        packedQty: json["packed_qty"] as String?,
        packageNo: json["package_no"],
        cartonNo: json["carton_no"],
        batchNo: json["batch_no"] as String?,
        serialIds: json["serial_ids"] == null
            ? null
            : List<String>.from(json["serial_ids"] as List),
        weight: json["weight"],
        remarks: json["remarks"],
        createdBy: json["created_by"] as String?,
        updatedBy: json["updated_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] as String),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"] as String),
        isDeleted: json["is_deleted"] as bool?,
        product: json["product"] == null
            ? null
            : PackingListProduct.fromJson(json["product"] as Map<String, dynamic>),
        isBatchWise: json["is_batch_wise"] as bool?,
        serialNumbers: json["serial_numbers"] == null
            ? null
            : List<String>.from(json["serial_numbers"] as List),
        batchQuantity: json["batch_quantity"] as int?,
        batchNumbers: json["batch_numbers"] == null
            ? null
            : List<String>.from(json["batch_numbers"] as List),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tenant_id": tenantId,
        "packing_id": packingId,
        "picking_item_id": pickingItemId,
        "product_id": productId,
        "picked_qty": pickedQty,
        "packed_qty": packedQty,
        "package_no": packageNo,
        "carton_no": cartonNo,
        "batch_no": batchNo,
        "serial_ids": serialIds,
        "weight": weight,
        "remarks": remarks,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_deleted": isDeleted,
        "product": product?.toJson(),
        "is_batch_wise": isBatchWise,
        "serial_numbers": serialNumbers,
        "batch_quantity": batchQuantity,
        "batch_numbers": batchNumbers,
      };
}

class PackingListProduct {
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
  final String? product3dModel;
  final String? youtubeVideoLink;
  final List<dynamic>? companyIds;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isActive;
  final bool? isDeleted;
  final dynamic deletedAt;

  PackingListProduct({
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
    this.product3dModel,
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

  factory PackingListProduct.fromJson(Map<String, dynamic> json) => PackingListProduct(
        id: json["id"] as String?,
        tenantId: json["tenant_id"] as String?,
        productGroupId: json["product_group_id"] as String?,
        productCode: json["product_code"] as String?,
        productLocationId: json["product_location_id"],
        warehouseLocationId: json["warehouse_location_id"],
        productName: json["product_name"] as String?,
        vendorId: json["vendor_id"] as String?,
        departmentId: json["department_id"] as String?,
        productBarcode: json["product_barcode"] as String?,
        brandId: json["brand_id"] as String?,
        hsnCode: json["hsn_code"] as String?,
        divisionId: json["division_id"] as String?,
        productCategoryId: json["product_category_id"] as String?,
        productTypeId: json["product_type_id"] as String?,
        unitOfMeasurment: json["unit_of_measurment"] as String?,
        purchaseUomId: json["purchase_uom_id"] as String?,
        purchaseUom: json["purchase_uom"] as String?,
        saleUomId: json["sale_uom_id"] as String?,
        saleUom: json["sale_uom"] as String?,
        uomConversionValue: json["uom_conversion_value"] as String?,
        modelNo: json["model_no"] as String?,
        features: json["features"] as String?,
        sizeId: json["size_id"] as String?,
        perBoxItemCount: json["per_box_item_count"] as int?,
        masterBoxId: json["master_box_id"],
        weight: json["weight"] as String?,
        netWeight: json["net_weight"] as String?,
        grossWeight: json["gross_weight"] as String?,
        minimumQty: json["minimum_qty"] as String?,
        minOrderQty: json["min_order_qty"] as String?,
        cbm: json["cbm"] as String?,
        itemLength: json["item_length"] as String?,
        itemWidth: json["item_width"] as String?,
        itemHeight: json["item_height"] as String?,
        storageTemperatureId: json["storage_temperature_id"],
        powerRequirementId: json["power_requirement_id"],
        countryOfOriginId: json["country_of_origin_id"] as String?,
        installationTypeId: json["installation_type_id"],
        leadTime: json["lead_time"] as int?,
        actualWeight: json["actual_weight"] as String?,
        packingWeight: json["packing_weight"] as String?,
        finishId: json["finish_id"] as String?,
        warrantyId: json["warranty_id"] as String?,
        material: json["material"] as String?,
        requireInstallation: json["require_installation"] as bool?,
        arc: json["arc"] as bool?,
        isWidth: json["is_width"] as bool?,
        description: json["description"] as String?,
        descriptionSales: json["description_sales"] as String?,
        descriptionPurchase: json["description_purchase"] as String?,
        poReqRemarks1: json["po_req_remarks_1"] as String?,
        poReqRemarks2: json["po_req_remarks_2"] as String?,
        poReqRemarks3: json["po_req_remarks_3"] as String?,
        trackingType: json["tracking_type"] as String?,
        trackingPrefix: json["tracking_prefix"] as String?,
        trackingStartNo: json["tracking_start_no"] as int?,
        trackingLastNo: json["tracking_last_no"] as int?,
        imageUrl: json["image_url"] as String?,
        productSpecSheet: json["product_spec_sheet"] as String?,
        product3dModel: json["product_3d_model"] as String?,
        youtubeVideoLink: json["youtube_video_link"] as String?,
        companyIds: json["company_ids"] == null
            ? null
            : List<dynamic>.from(json["company_ids"] as List),
        createdBy: json["created_by"] as String?,
        updatedBy: json["updated_by"] as String?,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] as String),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"] as String),
        isActive: json["is_active"] as bool?,
        isDeleted: json["is_deleted"] as bool?,
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
        "product_3d_model": product3dModel,
        "youtube_video_link": youtubeVideoLink,
        "company_ids": companyIds,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_active": isActive,
        "is_deleted": isDeleted,
        "deleted_at": deletedAt,
      };
}

class PackingListLog {
  final String? id;
  final String? entityType;
  final String? entityId;
  final String? parentType;
  final String? parentId;
  final dynamic rootType;
  final dynamic rootId;
  final String? notes;
  final String? logType;
  final dynamic metadata;
  final dynamic attachmentUrl;
  final String? createdBy;
  final String? tenantId;
  final DateTime? createdAt;
  final String? createdByName;

  PackingListLog({
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

  factory PackingListLog.fromJson(Map<String, dynamic> json) => PackingListLog(
        id: json["id"] as String?,
        entityType: json["entity_type"] as String?,
        entityId: json["entity_id"] as String?,
        parentType: json["parent_type"] as String?,
        parentId: json["parent_id"] as String?,
        rootType: json["root_type"],
        rootId: json["root_id"],
        notes: json["notes"] as String?,
        logType: json["log_type"] as String?,
        metadata: json["metadata"],
        attachmentUrl: json["attachment_url"],
        createdBy: json["created_by"] as String?,
        tenantId: json["tenant_id"] as String?,
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"] as String),
        createdByName: json["created_by_name"] as String?,
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
        "metadata": metadata,
        "attachment_url": attachmentUrl,
        "created_by": createdBy,
        "tenant_id": tenantId,
        "created_at": createdAt?.toIso8601String(),
        "created_by_name": createdByName,
      };
}
