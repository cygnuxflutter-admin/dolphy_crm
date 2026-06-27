class BoxConfiguration {
  final String id;
  final String boxName;
  final double weight;
  final int fromBox;
  final int toBox;
  final double length;
  final double width;
  final double height;
  final String dimUom;
  final double netWeight;
  final double grossWeight;
  final String weightUom;
  final String remarks;
  final List<BoxConfigItem> items;

  BoxConfiguration({
    required this.id,
    required this.boxName,
    required this.weight,
    this.fromBox = 0,
    this.toBox = 0,
    this.length = 0.0,
    this.width = 0.0,
    this.height = 0.0,
    this.dimUom = "cm",
    this.netWeight = 0.0,
    this.grossWeight = 0.0,
    this.weightUom = "g",
    this.remarks = "",
    required this.items,
  });

  BoxConfiguration copyWith({
    String? id,
    String? boxName,
    double? weight,
    int? fromBox,
    int? toBox,
    double? length,
    double? width,
    double? height,
    String? dimUom,
    double? netWeight,
    double? grossWeight,
    String? weightUom,
    String? remarks,
    List<BoxConfigItem>? items,
  }) {
    return BoxConfiguration(
      id: id ?? this.id,
      boxName: boxName ?? this.boxName,
      weight: weight ?? this.weight,
      fromBox: fromBox ?? this.fromBox,
      toBox: toBox ?? this.toBox,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      dimUom: dimUom ?? this.dimUom,
      netWeight: netWeight ?? this.netWeight,
      grossWeight: grossWeight ?? this.grossWeight,
      weightUom: weightUom ?? this.weightUom,
      remarks: remarks ?? this.remarks,
      items: items ?? this.items,
    );
  }
}

class BoxConfigItem {
  final String productId;
  final String productName;
  final int qty;

  BoxConfigItem({
    required this.productId,
    required this.productName,
    required this.qty,
  });

  BoxConfigItem copyWith({
    String? productId,
    String? productName,
    int? qty,
  }) {
    return BoxConfigItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      qty: qty ?? this.qty,
    );
  }
}
