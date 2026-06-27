class PickingSuggestionsResponse {
  final int status;
  final String message;
  final SuggestionsData data;

  PickingSuggestionsResponse({required this.status, required this.message, required this.data});

  factory PickingSuggestionsResponse.fromJson(Map<String, dynamic> json) =>
      PickingSuggestionsResponse(status: json["status"] ?? 0, message: json["message"] ?? "", data: SuggestionsData.fromJson(json["data"] ?? {}));
}

class SuggestionsData {
  final List<Serial> serials;
  final List<RackSuggestion> byRack;

  SuggestionsData({required this.serials, required this.byRack});

  factory SuggestionsData.fromJson(Map<String, dynamic> json) => SuggestionsData(
    serials: List<Serial>.from((json["serials"] ?? []).map((x) => Serial.fromJson(x))),
    byRack: List<RackSuggestion>.from((json["by_rack"] ?? []).map((x) => RackSuggestion.fromJson(x))),
  );
}

class Serial {
  final String id;
  final String serialNo;
  final String batchNumber;
  final String expiryDate;
  final String rackId;

  Serial({required this.id, required this.serialNo, required this.batchNumber, required this.expiryDate, required this.rackId});

  factory Serial.fromJson(Map<String, dynamic> json) => Serial(
    id: json["serial_id"] ?? "",
    serialNo: json["serial_number"] ?? "",
    batchNumber: json["batch_number"] ?? "",
    expiryDate: json["expiry_date"] ?? "",
    rackId: json["rack_id"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "serial_id": id,
    "serial_number": serialNo,
    "batch_number": batchNumber,
    "expiry_date": expiryDate,
    "rack_id": rackId,
  };
}

class RackSuggestion {
  final String rackId;
  final String rackName;
  final String warehouseName;
  final double count;
  final bool isBatch;

  RackSuggestion({required this.rackId, required this.rackName, required this.warehouseName, required this.count, required this.isBatch});

  factory RackSuggestion.fromJson(Map<String, dynamic> json) => RackSuggestion(
    rackId: json["rack_id"] ?? "",
    rackName: json["rack_name"] ?? "",
    warehouseName: json["warehouse_name"] ?? "",
    count: (json["count"] ?? 0).toDouble(),
    isBatch: json["is_batch"] ?? false,
  );
}
