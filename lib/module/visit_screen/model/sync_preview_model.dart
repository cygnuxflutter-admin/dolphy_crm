import 'visit_view_model.dart';

class SyncPreviewModel {
  bool success;
  String message;
  SyncPreviewData? data;
  int status;

  SyncPreviewModel({required this.success, required this.message, this.data, required this.status});

  factory SyncPreviewModel.fromJson(Map<String, dynamic> json) => SyncPreviewModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: json["data"] != null ? SyncPreviewData.fromJson(json["data"]) : null,
    status: json["status"] ?? 0,
  );
}

class SyncPreviewData {
  SyncComplaintInfo complaint;
  SyncVisitInfo visit;
  List<Product> products;

  SyncPreviewData({required this.complaint, required this.visit, required this.products});

  factory SyncPreviewData.fromJson(Map<String, dynamic> json) => SyncPreviewData(
    complaint: SyncComplaintInfo.fromJson(json["complaint"] ?? {}),
    visit: SyncVisitInfo.fromJson(json["visit"] ?? {}),
    products: json["products"] != null ? List<Product>.from(json["products"].map((x) => Product.fromJson(x))) : [],
  );
}

class SyncComplaintInfo {
  String id;
  String complaintNo;

  SyncComplaintInfo({required this.id, required this.complaintNo});

  factory SyncComplaintInfo.fromJson(Map<String, dynamic> json) => SyncComplaintInfo(id: json["id"] ?? "", complaintNo: json["complaint_no"] ?? "");
}

class SyncVisitInfo {
  String id;
  String visitNo;

  SyncVisitInfo({required this.id, required this.visitNo});

  factory SyncVisitInfo.fromJson(Map<String, dynamic> json) => SyncVisitInfo(id: json["id"] ?? "", visitNo: json["visit_no"] ?? "");
}
