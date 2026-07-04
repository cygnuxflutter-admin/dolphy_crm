import 'dart:convert';

TechnicianExpenseModel technicianExpenseModelFromJson(String str) => TechnicianExpenseModel.fromJson(json.decode(str));

String technicianExpenseModelToJson(TechnicianExpenseModel data) => json.encode(data.toJson());

class TechnicianExpenseModel {
  bool success;
  String message;
  List<TechnicianExpense> data;
  int status;
  dynamic error;
  Pagination? pagination;

  TechnicianExpenseModel({required this.success, required this.message, required this.data, required this.status, this.error, this.pagination});

  factory TechnicianExpenseModel.fromJson(Map<String, dynamic> json) => TechnicianExpenseModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: json["data"] != null ? List<TechnicianExpense>.from(json["data"].map((x) => TechnicianExpense.fromJson(x))) : [],
    status: json["status"] ?? 0,
    error: json["error"],
    pagination: json["pagination"] != null ? Pagination.fromJson(json["pagination"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
    "error": error,
    "pagination": pagination?.toJson(),
  };
}

class TechnicianExpense {
  String id;
  String expenseNo;
  String technicianName;
  String totalRequestAmount;
  String totalApproveAmount;
  String status;
  DateTime? expenseDate;

  TechnicianExpense({
    required this.id,
    required this.expenseNo,
    required this.technicianName,
    required this.totalRequestAmount,
    required this.totalApproveAmount,
    required this.status,
    this.expenseDate,
  });

  factory TechnicianExpense.fromJson(Map<String, dynamic> json) => TechnicianExpense(
    id: json["id"] ?? "",
    expenseNo: json["expense_no"] ?? "",
    technicianName: json["technician_name"] ?? "",
    totalRequestAmount: json["total_request_amount"]?.toString() ?? "0.00",
    totalApproveAmount: json["total_approve_amount"]?.toString() ?? "0.00",
    status: json["status"] ?? "",
    expenseDate: json["expense_date"] != null ? DateTime.parse(json["expense_date"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "expense_no": expenseNo,
    "technician_name": technicianName,
    "total_request_amount": totalRequestAmount,
    "total_approve_amount": totalApproveAmount,
    "status": status,
    "expense_date": expenseDate?.toIso8601String(),
  };
}

class Pagination {
  int page;
  int limit;
  int totalRecords;
  int totalPages;

  Pagination({required this.page, required this.limit, required this.totalRecords, required this.totalPages});

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      Pagination(page: json["page"] ?? 0, limit: json["limit"] ?? 0, totalRecords: json["totalRecords"] ?? 0, totalPages: json["totalPages"] ?? 0);

  Map<String, dynamic> toJson() => {"page": page, "limit": limit, "totalRecords": totalRecords, "totalPages": totalPages};
}
