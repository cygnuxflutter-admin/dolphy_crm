// To parse this JSON data, do
//
//     final physicalBoxStatusResponse = physicalBoxStatusResponseFromJson(jsonString);

import 'dart:convert';

PhysicalBoxStatusResponse physicalBoxStatusResponseFromJson(String str) => PhysicalBoxStatusResponse.fromJson(json.decode(str));

String physicalBoxStatusResponseToJson(PhysicalBoxStatusResponse data) => json.encode(data.toJson());

class PhysicalBoxStatusResponse {
  final bool? success;
  final String? message;
  final PhysicalBoxData? data;
  final int? status;
  final dynamic error;

  PhysicalBoxStatusResponse({this.success, this.message, this.data, this.status, this.error});

  factory PhysicalBoxStatusResponse.fromJson(Map<String, dynamic> json) => PhysicalBoxStatusResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : PhysicalBoxData.fromJson(json["data"]),
    status: json["status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data?.toJson(), "status": status, "error": error};
}

class PhysicalBoxData {
  final String? packingId;
  final String? packingNo;
  final String? customerName;
  final String? piNumber;
  final List<Config>? configs;
  final List<ProductSummary>? productSummary;
  final int? nextSuggestedBoxNo;
  final int? totalConfigs;

  PhysicalBoxData({
    this.packingId,
    this.packingNo,
    this.customerName,
    this.piNumber,
    this.configs,
    this.productSummary,
    this.nextSuggestedBoxNo,
    this.totalConfigs,
  });

  factory PhysicalBoxData.fromJson(Map<String, dynamic> json) => PhysicalBoxData(
    packingId: json["packing_id"],
    packingNo: json["packing_no"],
    customerName: json["customer_name"],
    piNumber: json["PI_number"],
    configs: json["configs"] == null ? [] : List<Config>.from(json["configs"]!.map((x) => Config.fromJson(x))),
    productSummary: json["product_summary"] == null ? [] : List<ProductSummary>.from(json["product_summary"]!.map((x) => ProductSummary.fromJson(x))),
    nextSuggestedBoxNo: json["next_suggested_box_no"],
    totalConfigs: json["total_configs"],
  );

  Map<String, dynamic> toJson() => {
    "packing_id": packingId,
    "packing_no": packingNo,
    "customer_name": customerName,
    "PI_number": piNumber,
    "configs": configs == null ? [] : List<dynamic>.from(configs!.map((x) => x.toJson())),
    "product_summary": productSummary == null ? [] : List<dynamic>.from(productSummary!.map((x) => x.toJson())),
    "next_suggested_box_no": nextSuggestedBoxNo,
    "total_configs": totalConfigs,
  };
}

class Config {
  final String? id;
  final int? boxRangeStart;
  final int? boxRangeEnd;
  final int? rangeStart;
  final int? rangeEnd;
  final int? boxCount;
  final String? weightPerBox;
  final int? length;
  final int? width;
  final int? height;
  final String? dimensionUom;
  final int? totalVolume;
  final String? netWeight;
  final String? grossWeight;
  final String? weightUom;
  final dynamic dimensions;
  final String? remarks;
  final List<PhysicalBoxItem>? items;

  Config({
    this.id,
    this.boxRangeStart,
    this.boxRangeEnd,
    this.rangeStart,
    this.rangeEnd,
    this.boxCount,
    this.weightPerBox,
    this.length,
    this.width,
    this.height,
    this.dimensionUom,
    this.totalVolume,
    this.netWeight,
    this.grossWeight,
    this.weightUom,
    this.dimensions,
    this.remarks,
    this.items,
  });

  factory Config.fromJson(Map<String, dynamic> json) => Config(
    id: json["id"],
    boxRangeStart: json["box_range_start"],
    boxRangeEnd: json["box_range_end"],
    rangeStart: json["range_start"],
    rangeEnd: json["range_end"],
    boxCount: json["box_count"],
    weightPerBox: json["weight_per_box"],
    length: json["length"],
    width: json["width"],
    height: json["height"],
    dimensionUom: json["dimension_uom"],
    totalVolume: json["total_volume"],
    netWeight: json["net_weight"],
    grossWeight: json["gross_weight"],
    weightUom: json["weight_uom"],
    dimensions: json["dimensions"],
    remarks: json["remarks"],
    items: json["items"] == null ? [] : List<PhysicalBoxItem>.from(json["items"]!.map((x) => PhysicalBoxItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "box_range_start": boxRangeStart,
    "box_range_end": boxRangeEnd,
    "range_start": rangeStart,
    "range_end": rangeEnd,
    "box_count": boxCount,
    "weight_per_box": weightPerBox,
    "length": length,
    "width": width,
    "height": height,
    "dimension_uom": dimensionUom,
    "total_volume": totalVolume,
    "net_weight": netWeight,
    "gross_weight": grossWeight,
    "weight_uom": weightUom,
    "dimensions": dimensions,
    "remarks": remarks,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class PhysicalBoxItem {
  final String? id;
  final String? productId;
  final String? productName;
  final String? productCode;
  final int? quantityPerBox;
  final int? qtyPerBox;
  final int? totalQuantity;
  final int? totalQty;

  PhysicalBoxItem({
    this.id,
    this.productId,
    this.productName,
    this.productCode,
    this.quantityPerBox,
    this.qtyPerBox,
    this.totalQuantity,
    this.totalQty,
  });

  factory PhysicalBoxItem.fromJson(Map<String, dynamic> json) => PhysicalBoxItem(
    id: json["id"],
    productId: json["product_id"],
    productName: json["product_name"],
    productCode: json["product_code"],
    quantityPerBox: json["quantity_per_box"],
    qtyPerBox: json["qty_per_box"],
    totalQuantity: json["total_quantity"],
    totalQty: json["total_qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "product_name": productName,
    "product_code": productCode,
    "quantity_per_box": quantityPerBox,
    "qty_per_box": qtyPerBox,
    "total_quantity": totalQuantity,
    "total_qty": totalQty,
  };
}

class ProductSummary {
  final String? productId;
  final String? productName;
  final String? itemCode;
  final String? piNumber;
  final String? packingItemId;
  final int? totalQtyOrdered;
  final int? totalQtyPacked;
  final int? remainingQty;
  final String? status;

  ProductSummary({
    this.productId,
    this.productName,
    this.itemCode,
    this.piNumber,
    this.packingItemId,
    this.totalQtyOrdered,
    this.totalQtyPacked,
    this.remainingQty,
    this.status,
  });

  factory ProductSummary.fromJson(Map<String, dynamic> json) => ProductSummary(
    productId: json["product_id"],
    productName: json["product_name"],
    itemCode: json["item_code"],
    piNumber: json["pi_number"],
    packingItemId: json["packing_item_id"],
    totalQtyOrdered: json["total_qty_ordered"],
    totalQtyPacked: json["total_qty_packed"],
    remainingQty: json["remaining_qty"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "product_name": productName,
    "item_code": itemCode,
    "pi_number": piNumber,
    "packing_item_id": packingItemId,
    "total_qty_ordered": totalQtyOrdered,
    "total_qty_packed": totalQtyPacked,
    "remaining_qty": remainingQty,
    "status": status,
  };
}
