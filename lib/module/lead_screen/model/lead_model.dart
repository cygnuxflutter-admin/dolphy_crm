import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  final bool success;
  final String message;
  final List<ProductDatum> data;
  final int status;
  final dynamic error;
  final Pagination pagination;

  ProductModel({
    required this.success,
    required this.message,
    required this.data,
    required this.status,
    required this.error,
    required this.pagination,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    success: json["success"] ?? false,
    message: json["message"] ?? '',
    data: (json["data"] != null)
        ? List<ProductDatum>.from(
        json["data"].map((x) => ProductDatum.fromJson(x)))
        : [],
    status: json["status"] ?? 0,
    error: json["error"],
    pagination: Pagination.fromJson(json["pagination"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
    "error": error,
    "pagination": pagination.toJson(),
  };
}

class ProductDatum {
  final String id;
  final String tenantId;
  final String productGroupId;
  final String productCode;
  final String productLocationId;
  final String productName;
  final String vendorId;
  final String departmentId;
  final String productBarcode;
  final String brandId;
  final String hsnCode;
  final String divisionId;
  final String productCategoryId;
  final String unitOfMeasurment;
  final String modelNo;
  final String features;
  final String sizeId;
  final String weight;
  final String cbm;
  final String actualWeight;
  final String packingWeight;
  final String finishId;
  final String material;
  final bool requireInstallation;
  final String description;
  final String descriptionSales;
  final String descriptionPurchase;
  final List<String> imageUrl;
  final String createdBy;
  final String updatedBy;
  final String createdAt;
  final String updatedAt;
  final bool isActive;
  final bool isDeleted;
  final dynamic deletedAt;
  final dynamic brandName;
  final dynamic productCategoryName;
  final dynamic departmentName;
  final HsnDetails hsnDetails;
  final List<Price> prices;
  final String currentStock;
  final String availableStock;

  ProductDatum({
    required this.id,
    required this.tenantId,
    required this.productGroupId,
    required this.productCode,
    required this.productLocationId,
    required this.productName,
    required this.vendorId,
    required this.departmentId,
    required this.productBarcode,
    required this.brandId,
    required this.hsnCode,
    required this.divisionId,
    required this.productCategoryId,
    required this.unitOfMeasurment,
    required this.modelNo,
    required this.features,
    required this.sizeId,
    required this.weight,
    required this.cbm,
    required this.actualWeight,
    required this.packingWeight,
    required this.finishId,
    required this.material,
    required this.requireInstallation,
    required this.description,
    required this.descriptionSales,
    required this.descriptionPurchase,
    required this.imageUrl,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.isDeleted,
    required this.deletedAt,
    required this.brandName,
    required this.productCategoryName,
    required this.departmentName,
    required this.hsnDetails,
    required this.prices,
    required this.currentStock,
    required this.availableStock,
  });

  factory ProductDatum.fromJson(Map<String, dynamic> json) => ProductDatum(
    id: json["id"] ?? '',
    tenantId: json["tenant_id"] ?? '',
    productGroupId: json["product_group_id"] ?? '',
    productCode: json["product_code"] ?? '',
    productLocationId: json["product_location_id"] ?? '',
    productName: json["product_name"] ?? '',
    vendorId: json["vendor_id"] ?? '',
    departmentId: json["department_id"] ?? '',
    productBarcode: json["product_barcode"] ?? '',
    brandId: json["brand_id"] ?? '',
    hsnCode: json["hsn_code"] ?? '',
    divisionId: json["division_id"] ?? '',
    productCategoryId: json["product_category_id"] ?? '',
    unitOfMeasurment: json["unit_of_measurment"] ?? '',
    modelNo: json["model_no"] ?? '',
    features: json["features"] ?? '',
    sizeId: json["size_id"] ?? '',
    weight: json["weight"] ?? '',
    cbm: json["cbm"] ?? '',
    actualWeight: json["actual_weight"] ?? '',
    packingWeight: json["packing_weight"] ?? '',
    finishId: json["finish_id"] ?? '',
    material: json["material"] ?? '',
    requireInstallation: json["require_installation"] ?? false,
    description: json["description"] ?? '',
    descriptionSales: json["description_sales"] ?? '',
    descriptionPurchase: json["description_purchase"] ?? '',
    imageUrl: List<String>.from(json["image_url"]?.map((x) => x) ?? []),
    createdBy: json["created_by"] ?? '',
    updatedBy: json["updated_by"] ?? '',
    createdAt: json["created_at"] ?? '',
    updatedAt: json["updated_at"] ?? '',
    isActive: json["is_active"] ?? false,
    isDeleted: json["is_deleted"] ?? false,
    deletedAt: json["deleted_at"],
    brandName: json["brand_name"],
    productCategoryName: json["product_category_name"],
    departmentName: json["department_name"],
    hsnDetails: HsnDetails.fromJson(json["hsn_details"] ?? {}),
    prices: (json["prices"] != null)
        ? List<Price>.from(json["prices"].map((x) => Price.fromJson(x)))
        : [],
    currentStock: json["current_stock"] ?? '',
    availableStock: json["available_stock"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "product_group_id": productGroupId,
    "product_code": productCode,
    "product_location_id": productLocationId,
    "product_name": productName,
    "vendor_id": vendorId,
    "department_id": departmentId,
    "product_barcode": productBarcode,
    "brand_id": brandId,
    "hsn_code": hsnCode,
    "division_id": divisionId,
    "product_category_id": productCategoryId,
    "unit_of_measurment": unitOfMeasurment,
    "model_no": modelNo,
    "features": features,
    "size_id": sizeId,
    "weight": weight,
    "cbm": cbm,
    "actual_weight": actualWeight,
    "packing_weight": packingWeight,
    "finish_id": finishId,
    "material": material,
    "require_installation": requireInstallation,
    "description": description,
    "description_sales": descriptionSales,
    "description_purchase": descriptionPurchase,
    "image_url": List<dynamic>.from(imageUrl.map((x) => x)),
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_active": isActive,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
    "brand_name": brandName,
    "product_category_name": productCategoryName,
    "department_name": departmentName,
    "hsn_details": hsnDetails.toJson(),
    "prices": List<dynamic>.from(prices.map((x) => x.toJson())),
    "current_stock": currentStock,
    "available_stock": availableStock,
  };
}

class HsnDetails {
  final String hsnCode;
  final String hsnDescription;
  final String taxRate;
  final String cessRate;
  final String customDutyRate;
  final dynamic hsnChapter;
  final dynamic hsnHeading;
  final dynamic hsnSubHeading;
  final dynamic uqc;

  HsnDetails({
    required this.hsnCode,
    required this.hsnDescription,
    required this.taxRate,
    required this.cessRate,
    required this.customDutyRate,
    required this.hsnChapter,
    required this.hsnHeading,
    required this.hsnSubHeading,
    required this.uqc,
  });

  factory HsnDetails.fromJson(Map<String, dynamic> json) => HsnDetails(
    hsnCode: json["hsn_code"] ?? '',
    hsnDescription: json["hsn_description"] ?? '',
    taxRate: json["tax_rate"] ?? '',
    cessRate: json["cess_rate"] ?? '',
    customDutyRate: json["custom_duty_rate"] ?? '',
    hsnChapter: json["hsn_chapter"],
    hsnHeading: json["hsn_heading"],
    hsnSubHeading: json["hsn_sub_heading"],
    uqc: json["uqc"],
  );

  Map<String, dynamic> toJson() => {
    "hsn_code": hsnCode,
    "hsn_description": hsnDescription,
    "tax_rate": taxRate,
    "cess_rate": cessRate,
    "custom_duty_rate": customDutyRate,
    "hsn_chapter": hsnChapter,
    "hsn_heading": hsnHeading,
    "hsn_sub_heading": hsnSubHeading,
    "uqc": uqc,
  };
}

class Price {
  final String id;
  final String tenantId;
  final String productId;
  final String priceTypeId;
  final String basePrice;
  final String sellingPrice;
  final String discountType;
  final String discountValue;
  final String discountAmount;
  final bool isTaxInclusive;
  final dynamic effectiveFrom;
  final dynamic effectiveTo;
  final String minOrderQuantity;
  final dynamic maxOrderQuantity;
  final dynamic customerGroupId;
  final dynamic locationId;
  final String currency;
  final int priority;
  final String remarks;
  final String createdBy;
  final dynamic updatedBy;
  final String createdAt;
  final String updatedAt;
  final bool isActive;
  final bool isDeleted;
  final dynamic deletedAt;

  Price({
    required this.id,
    required this.tenantId,
    required this.productId,
    required this.priceTypeId,
    required this.basePrice,
    required this.sellingPrice,
    required this.discountType,
    required this.discountValue,
    required this.discountAmount,
    required this.isTaxInclusive,
    required this.effectiveFrom,
    required this.effectiveTo,
    required this.minOrderQuantity,
    required this.maxOrderQuantity,
    required this.customerGroupId,
    required this.locationId,
    required this.currency,
    required this.priority,
    required this.remarks,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.isDeleted,
    required this.deletedAt,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    id: json["id"] ?? '',
    tenantId: json["tenant_id"] ?? '',
    productId: json["product_id"] ?? '',
    priceTypeId: json["price_type_id"] ?? '',
    basePrice: json["base_price"] ?? '',
    sellingPrice: json["selling_price"] ?? '',
    discountType: json["discount_type"] ?? '',
    discountValue: json["discount_value"] ?? '',
    discountAmount: json["discount_amount"] ?? '',
    isTaxInclusive: json["is_tax_inclusive"] ?? false,
    effectiveFrom: json["effective_from"],
    effectiveTo: json["effective_to"],
    minOrderQuantity: json["min_order_quantity"] ?? '',
    maxOrderQuantity: json["max_order_quantity"],
    customerGroupId: json["customer_group_id"],
    locationId: json["location_id"],
    currency: json["currency"] ?? '',
    priority: json["priority"] ?? 0,
    remarks: json["remarks"] ?? '',
    createdBy: json["created_by"] ?? '',
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] ?? '',
    updatedAt: json["updated_at"] ?? '',
    isActive: json["is_active"] ?? false,
    isDeleted: json["is_deleted"] ?? false,
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tenant_id": tenantId,
    "product_id": productId,
    "price_type_id": priceTypeId,
    "base_price": basePrice,
    "selling_price": sellingPrice,
    "discount_type": discountType,
    "discount_value": discountValue,
    "discount_amount": discountAmount,
    "is_tax_inclusive": isTaxInclusive,
    "effective_from": effectiveFrom,
    "effective_to": effectiveTo,
    "min_order_quantity": minOrderQuantity,
    "max_order_quantity": maxOrderQuantity,
    "customer_group_id": customerGroupId,
    "location_id": locationId,
    "currency": currency,
    "priority": priority,
    "remarks": remarks,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_active": isActive,
    "is_deleted": isDeleted,
    "deleted_at": deletedAt,
  };
}
class Pagination {
  final int page;
  final int limit;
  final int totalRecords;
  final int totalPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.totalRecords,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"] ?? 0,
    limit: json["limit"] ?? 0,
    totalRecords: json["totalRecords"] ?? 0,
    totalPages: json["totalPages"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "totalRecords": totalRecords,
    "totalPages": totalPages,
  };
}
