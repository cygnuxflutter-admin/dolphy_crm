import 'dart:convert';

BoxSuggestionResponseModel boxSuggestionResponseModelFromJson(String str) =>
    BoxSuggestionResponseModel.fromJson(json.decode(str));

String boxSuggestionResponseModelToJson(BoxSuggestionResponseModel data) =>
    json.encode(data.toJson());

class BoxSuggestionResponseModel {
  final bool? success;
  final String? message;
  final BoxSuggestionData? data;
  final int? status;
  final dynamic error;

  BoxSuggestionResponseModel({
    this.success,
    this.message,
    this.data,
    this.status,
    this.error,
  });

  factory BoxSuggestionResponseModel.fromJson(Map<String, dynamic> json) =>
      BoxSuggestionResponseModel(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        data: json["data"] == null
            ? null
            : BoxSuggestionData.fromJson(json["data"] as Map<String, dynamic>),
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

class BoxSuggestionData {
  final String? boxSuggestionId;
  final String? packingId;
  final String? packingNo;
  final String? packingDate;
  final List<BoxSuggestionItem>? items;
  final String? piRemarks;
  final BoxSuggestionSummary? summary;

  BoxSuggestionData({
    this.boxSuggestionId,
    this.packingId,
    this.packingNo,
    this.packingDate,
    this.items,
    this.piRemarks,
    this.summary,
  });

  factory BoxSuggestionData.fromJson(Map<String, dynamic> json) =>
      BoxSuggestionData(
        boxSuggestionId: json["box_suggestion_id"] as String?,
        packingId: json["packing_id"] as String?,
        packingNo: json["packing_no"] as String?,
        packingDate: json["packing_date"] as String?,
        items: json["items"] == null
            ? null
            : List<BoxSuggestionItem>.from(
                (json["items"] as List).map(
                  (x) => BoxSuggestionItem.fromJson(x as Map<String, dynamic>),
                ),
              ),
        piRemarks: json["pi_remarks"] as String?,
        summary: json["summary"] == null
            ? null
            : BoxSuggestionSummary.fromJson(json["summary"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "box_suggestion_id": boxSuggestionId,
        "packing_id": packingId,
        "packing_no": packingNo,
        "packing_date": packingDate,
        "items": items?.map((x) => x.toJson()).toList(),
        "pi_remarks": piRemarks,
        "summary": summary?.toJson(),
      };
}

class BoxSuggestionItem {
  final String? packingItemId;
  final String? productId;
  final String? productName;
  final String? productCode;
  final String? imageUrl;
  final int? packedQty;
  final int? actualPackedQty;
  final int? orderedQty;
  final int? perBoxCount;
  final int? fullBoxes;
  final int? remainingItems;
  final int? suggestedBoxes;
  final String? boxBreakdown;
  final String? boxSuggestionItemId;
  final int? actualBoxes;
  final String? itemRemarks;

  BoxSuggestionItem({
    this.packingItemId,
    this.productId,
    this.productName,
    this.productCode,
    this.imageUrl,
    this.packedQty,
    this.actualPackedQty,
    this.orderedQty,
    this.perBoxCount,
    this.fullBoxes,
    this.remainingItems,
    this.suggestedBoxes,
    this.boxBreakdown,
    this.boxSuggestionItemId,
    this.actualBoxes,
    this.itemRemarks,
  });

  factory BoxSuggestionItem.fromJson(Map<String, dynamic> json) =>
      BoxSuggestionItem(
        packingItemId: json["packing_item_id"] as String?,
        productId: json["product_id"] as String?,
        productName: json["product_name"] as String?,
        productCode: json["product_code"] as String?,
        imageUrl: json["image_url"] as String?,
        packedQty: json["packed_qty"] as int?,
        actualPackedQty: json["actual_packed_qty"] as int?,
        orderedQty: json["ordered_qty"] as int?,
        perBoxCount: json["per_box_count"] as int?,
        fullBoxes: json["full_boxes"] as int?,
        remainingItems: json["remaining_items"] as int?,
        suggestedBoxes: json["suggested_boxes"] as int?,
        boxBreakdown: json["box_breakdown"] as String?,
        boxSuggestionItemId: json["box_suggestion_item_id"] as String?,
        actualBoxes: json["actual_boxes"] as int?,
        itemRemarks: json["item_remarks"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "packing_item_id": packingItemId,
        "product_id": productId,
        "product_name": productName,
        "product_code": productCode,
        "image_url": imageUrl,
        "packed_qty": packedQty,
        "actual_packed_qty": actualPackedQty,
        "ordered_qty": orderedQty,
        "per_box_count": perBoxCount,
        "full_boxes": fullBoxes,
        "remaining_items": remainingItems,
        "suggested_boxes": suggestedBoxes,
        "box_breakdown": boxBreakdown,
        "box_suggestion_item_id": boxSuggestionItemId,
        "actual_boxes": actualBoxes,
        "item_remarks": itemRemarks,
      };
}

class BoxSuggestionSummary {
  final int? totalProducts;
  final int? totalPackedQty;
  final int? totalSuggestedBoxes;
  final int? totalActualBoxes;

  BoxSuggestionSummary({
    this.totalProducts,
    this.totalPackedQty,
    this.totalSuggestedBoxes,
    this.totalActualBoxes,
  });

  factory BoxSuggestionSummary.fromJson(Map<String, dynamic> json) =>
      BoxSuggestionSummary(
        totalProducts: json["total_products"] as int?,
        totalPackedQty: json["total_packed_qty"] as int?,
        totalSuggestedBoxes: json["total_suggested_boxes"] as int?,
        totalActualBoxes: json["total_actual_boxes"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "total_products": totalProducts,
        "total_packed_qty": totalPackedQty,
        "total_suggested_boxes": totalSuggestedBoxes,
        "total_actual_boxes": totalActualBoxes,
      };
}
