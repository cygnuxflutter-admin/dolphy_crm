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
  String visitNo;
  String complaintNo;
  String customerName;
  String technicianName;
  DateTime? expenseDate;
  String totalRequestAmount;
  String totalApproveAmount;
  String pendingAmount;
  String paidAmount;
  String totalClientAmount;
  String status;
  DateTime? createdAt;

  TechnicianExpense({
    required this.id,
    required this.expenseNo,
    required this.visitNo,
    required this.complaintNo,
    required this.customerName,
    required this.technicianName,
    this.expenseDate,
    required this.totalRequestAmount,
    required this.totalApproveAmount,
    required this.pendingAmount,
    required this.paidAmount,
    required this.totalClientAmount,
    required this.status,
    this.createdAt,
  });

  factory TechnicianExpense.fromJson(Map<String, dynamic> json) => TechnicianExpense(
    id: json["id"] ?? "",
    expenseNo: json["expense_no"] ?? "",
    visitNo: json["visit_no"] ?? "",
    complaintNo: json["complaint_no"] ?? "",
    customerName: json["customer_name"] ?? "",
    technicianName: json["technician_name"] ?? "",
    expenseDate: json["expense_date"] != null ? DateTime.parse(json["expense_date"]) : null,
    totalRequestAmount: json["total_request_amount"]?.toString() ?? "0.00",
    totalApproveAmount: json["total_approve_amount"]?.toString() ?? "0.00",
    pendingAmount: json["pending_amount"]?.toString() ?? "0.00",
    paidAmount: json["paid_amount"]?.toString() ?? "0.00",
    totalClientAmount: json["total_client_amount"]?.toString() ?? "0.00",
    status: json["status"] ?? "",
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "expense_no": expenseNo,
    "visit_no": visitNo,
    "complaint_no": complaintNo,
    "customer_name": customerName,
    "technician_name": technicianName,
    "expense_date": expenseDate?.toIso8601String(),
    "total_request_amount": totalRequestAmount,
    "total_approve_amount": totalApproveAmount,
    "pending_amount": pendingAmount,
    "paid_amount": paidAmount,
    "total_client_amount": totalClientAmount,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
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
