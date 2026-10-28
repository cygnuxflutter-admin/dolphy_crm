import 'dart:convert';
import 'visit_model.dart';

VisitHistoryModel visitHistoryModelFromJson(String str) => VisitHistoryModel.fromJson(json.decode(str));

String visitHistoryModelToJson(VisitHistoryModel data) => json.encode(data.toJson());

class VisitHistoryModel {
  bool? success;
  String? message;
  VisitHistoryData? data;
  int? status;
  dynamic error;

  VisitHistoryModel({
    this.success,
    this.message,
    this.data,
    this.status,
    this.error,
  });

  factory VisitHistoryModel.fromJson(Map<String, dynamic> json) => VisitHistoryModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : VisitHistoryData.fromJson(json["data"]),
        status: json["status"],
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

class VisitHistoryData {
  String? currentVisitId;
  bool? hasComplaint;
  ComplaintHistory? complaint;
  int? totalVisits;
  List<VisitDatum>? visits;

  VisitHistoryData({
    this.currentVisitId,
    this.hasComplaint,
    this.complaint,
    this.totalVisits,
    this.visits,
  });

  factory VisitHistoryData.fromJson(Map<String, dynamic> json) => VisitHistoryData(
        currentVisitId: json["current_visit_id"],
        hasComplaint: json["has_complaint"],
        complaint: json["complaint"] == null ? null : ComplaintHistory.fromJson(json["complaint"]),
        totalVisits: json["total_visits"] is int
            ? json["total_visits"]
            : int.tryParse(json["total_visits"]?.toString() ?? "0"),
        visits: json["visits"] == null
            ? []
            : List<VisitDatum>.from(json["visits"].map((x) => VisitDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_visit_id": currentVisitId,
        "has_complaint": hasComplaint,
        "complaint": complaint?.toJson(),
        "total_visits": totalVisits,
        "visits": visits == null ? [] : List<dynamic>.from(visits!.map((x) => x.toJson())),
      };
}

class ComplaintHistory {
  String? id;
  String? queryNo;
  String? customerId;
  String? customerName;
  String? contactPerson;
  String? mobileCountryCode;
  String? mobile;
  String? status;
  String? statusName;
  String? visitPurpose;
  String? visitPurposeName;
  dynamic visitPurposeOther;
  String? description;
  DateTime? createdAt;

  ComplaintHistory({
    this.id,
    this.queryNo,
    this.customerId,
    this.customerName,
    this.contactPerson,
    this.mobileCountryCode,
    this.mobile,
    this.status,
    this.statusName,
    this.visitPurpose,
    this.visitPurposeName,
    this.visitPurposeOther,
    this.description,
    this.createdAt,
  });

  factory ComplaintHistory.fromJson(Map<String, dynamic> json) => ComplaintHistory(
        id: json["id"],
        queryNo: json["query_no"],
        customerId: json["customer_id"],
        customerName: json["customer_name"],
        contactPerson: json["contact_person"],
        mobileCountryCode: json["mobile_country_code"],
        mobile: json["mobile"],
        status: json["status"],
        statusName: json["status_name"],
        visitPurpose: json["visit_purpose"],
        visitPurposeName: json["visit_purpose_name"],
        visitPurposeOther: json["visit_purpose_other"],
        description: json["description"],
        createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "query_no": queryNo,
        "customer_id": customerId,
        "customer_name": customerName,
        "contact_person": contactPerson,
        "mobile_country_code": mobileCountryCode,
        "mobile": mobile,
        "status": status,
        "status_name": statusName,
        "visit_purpose": visitPurpose,
        "visit_purpose_name": visitPurposeName,
        "visit_purpose_other": visitPurposeOther,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
      };
}
