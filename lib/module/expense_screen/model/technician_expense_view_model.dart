import 'dart:convert';

TechnicianExpenseViewModel technicianExpenseViewModelFromJson(String str) => TechnicianExpenseViewModel.fromJson(json.decode(str));

String technicianExpenseViewModelToJson(TechnicianExpenseViewModel data) => json.encode(data.toJson());

class TechnicianExpenseViewModel {
    bool success;
    String message;
    TechnicianExpenseViewData data;
    int status;
    dynamic error;

    TechnicianExpenseViewModel({
        required this.success,
        required this.message,
        required this.data,
        required this.status,
        this.error,
    });

    factory TechnicianExpenseViewModel.fromJson(Map<String, dynamic> json) => TechnicianExpenseViewModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: TechnicianExpenseViewData.fromJson(json["data"] ?? {}),
        status: json["status"] ?? 0,
        error: json["error"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
        "status": status,
        "error": error,
    };
}

class TechnicianExpenseViewData {
    String id;
    String expenseNo;
    String serviceVisitId;
    List<String> serviceVisitIds;
    String serviceQueryId;
    String customerId;
    String technicianId;
    DateTime? expenseDate;
    String status;
    String totalAmount;
    String totalRequestAmount;
    String totalApproveAmount;
    String totalClientAmount;
    String netTotalAmount;
    String pendingAmount;
    String paidAmount;
    String currencyCode;
    String remarks;
    DateTime? submittedAt;
    String? submittedBy;
    DateTime? approvedAt;
    String? approvedBy;
    String? approvalRemarks;
    DateTime? rejectedAt;
    String? rejectedBy;
    String? rejectionRemarks;
    DateTime? cancelledAt;
    String? cancelledBy;
    String? cancelRemarks;
    String createdBy;
    DateTime? createdAt;
    List<Visit> visits;
    String visitNo;
    String complaintNo;
    String customerName;
    String technicianName;
    String createdByName;
    List<Line> lines;
    List<StatusHistory> statusHistory;

    TechnicianExpenseViewData({
        required this.id,
        required this.expenseNo,
        required this.serviceVisitId,
        required this.serviceVisitIds,
        required this.serviceQueryId,
        required this.customerId,
        required this.technicianId,
        this.expenseDate,
        required this.status,
        required this.totalAmount,
        required this.totalRequestAmount,
        required this.totalApproveAmount,
        required this.totalClientAmount,
        required this.netTotalAmount,
        required this.pendingAmount,
        required this.paidAmount,
        required this.currencyCode,
        required this.remarks,
        this.submittedAt,
        this.submittedBy,
        this.approvedAt,
        this.approvedBy,
        this.approvalRemarks,
        this.rejectedAt,
        this.rejectedBy,
        this.rejectionRemarks,
        this.cancelledAt,
        this.cancelledBy,
        this.cancelRemarks,
        required this.createdBy,
        this.createdAt,
        required this.visits,
        required this.visitNo,
        required this.complaintNo,
        required this.customerName,
        required this.technicianName,
        required this.createdByName,
        required this.lines,
        required this.statusHistory,
    });

    factory TechnicianExpenseViewData.fromJson(Map<String, dynamic> json) => TechnicianExpenseViewData(
        id: json["id"] ?? "",
        expenseNo: json["expense_no"] ?? "",
        serviceVisitId: json["service_visit_id"] ?? "",
        serviceVisitIds: List<String>.from(json["service_visit_ids"]?.map((x) => x) ?? []),
        serviceQueryId: json["service_query_id"] ?? "",
        customerId: json["customer_id"] ?? "",
        technicianId: json["technician_id"] ?? "",
        expenseDate: json["expense_date"] == null ? null : DateTime.parse(json["expense_date"]),
        status: json["status"] ?? "",
        totalAmount: json["total_amount"]?.toString() ?? "0.00",
        totalRequestAmount: json["total_request_amount"]?.toString() ?? "0.00",
        totalApproveAmount: json["total_approve_amount"]?.toString() ?? "0.00",
        totalClientAmount: json["total_client_amount"]?.toString() ?? "0.00",
        netTotalAmount: json["net_total_amount"]?.toString() ?? "0.00",
        pendingAmount: json["pending_amount"]?.toString() ?? "0.00",
        paidAmount: json["paid_amount"]?.toString() ?? "0.00",
        currencyCode: json["currency_code"] ?? "",
        remarks: json["remarks"] ?? "",
        submittedAt: json["submitted_at"] == null ? null : DateTime.parse(json["submitted_at"]),
        submittedBy: json["submitted_by"],
        approvedAt: json["approved_at"] == null ? null : DateTime.parse(json["approved_at"]),
        approvedBy: json["approved_by"],
        approvalRemarks: json["approval_remarks"],
        rejectedAt: json["rejected_at"] == null ? null : DateTime.parse(json["rejected_at"]),
        rejectedBy: json["rejected_by"],
        rejectionRemarks: json["rejection_remarks"],
        cancelledAt: json["cancelled_at"] == null ? null : DateTime.parse(json["cancelled_at"]),
        cancelledBy: json["cancelled_by"],
        cancelRemarks: json["cancel_remarks"],
        createdBy: json["created_by"] ?? "",
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        visits: List<Visit>.from(json["visits"]?.map((x) => Visit.fromJson(x)) ?? []),
        visitNo: json["visit_no"] ?? "",
        complaintNo: json["complaint_no"] ?? "",
        customerName: json["customer_name"] ?? "",
        technicianName: json["technician_name"] ?? "",
        createdByName: json["created_by_name"] ?? "",
        lines: List<Line>.from(json["lines"]?.map((x) => Line.fromJson(x)) ?? []),
        statusHistory: List<StatusHistory>.from(json["status_history"]?.map((x) => StatusHistory.fromJson(x)) ?? []),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "expense_no": expenseNo,
        "service_visit_id": serviceVisitId,
        "service_visit_ids": List<dynamic>.from(serviceVisitIds.map((x) => x)),
        "service_query_id": serviceQueryId,
        "customer_id": customerId,
        "technician_id": technicianId,
        "expense_date": expenseDate?.toIso8601String(),
        "status": status,
        "total_amount": totalAmount,
        "total_request_amount": totalRequestAmount,
        "total_approve_amount": totalApproveAmount,
        "total_client_amount": totalClientAmount,
        "net_total_amount": netTotalAmount,
        "pending_amount": pendingAmount,
        "paid_amount": paidAmount,
        "currency_code": currencyCode,
        "remarks": remarks,
        "submitted_at": submittedAt?.toIso8601String(),
        "submitted_by": submittedBy,
        "approved_at": approvedAt?.toIso8601String(),
        "approved_by": approvedBy,
        "approval_remarks": approvalRemarks,
        "rejected_at": rejectedAt?.toIso8601String(),
        "rejected_by": rejectedBy,
        "rejection_remarks": rejectionRemarks,
        "cancelled_at": cancelledAt?.toIso8601String(),
        "cancelled_by": cancelledBy,
        "cancel_remarks": cancelRemarks,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "visits": List<dynamic>.from(visits.map((x) => x.toJson())),
        "visit_no": visitNo,
        "complaint_no": complaintNo,
        "customer_name": customerName,
        "technician_name": technicianName,
        "created_by_name": createdByName,
        "lines": List<dynamic>.from(lines.map((x) => x.toJson())),
        "status_history": List<dynamic>.from(statusHistory.map((x) => x.toJson())),
    };
}

class Line {
    String id;
    int lineNo;
    String expenseIdentifier;
    String amount;
    String requestAmount;
    String approveAmount;
    bool isPaidByClient;
    String clientAmount;
    String description;
    String expenseTypeName;
    String travelTypeName;
    String? kilometre;

    Line({
        required this.id,
        required this.lineNo,
        required this.expenseIdentifier,
        required this.amount,
        required this.requestAmount,
        required this.approveAmount,
        required this.isPaidByClient,
        required this.clientAmount,
        required this.description,
        required this.expenseTypeName,
        required this.travelTypeName,
        this.kilometre,
    });

    factory Line.fromJson(Map<String, dynamic> json) => Line(
        id: json["id"] ?? "",
        lineNo: json["line_no"] ?? 0,
        expenseIdentifier: json["expense_identifier"] ?? "",
        amount: json["amount"]?.toString() ?? "0.00",
        requestAmount: json["request_amount"]?.toString() ?? "0.00",
        approveAmount: json["approve_amount"]?.toString() ?? "0.00",
        isPaidByClient: json["is_paid_by_client"] ?? false,
        clientAmount: json["client_amount"]?.toString() ?? "0.00",
        description: json["description"] ?? "",
        expenseTypeName: json["expense_type_name"] ?? "",
        travelTypeName: json["travel_type_name"] ?? "",
        kilometre: json["kilometre"]?.toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "line_no": lineNo,
        "expense_identifier": expenseIdentifier,
        "amount": amount,
        "request_amount": requestAmount,
        "approve_amount": approveAmount,
        "is_paid_by_client": isPaidByClient,
        "client_amount": clientAmount,
        "description": description,
        "expense_type_name": expenseTypeName,
        "travel_type_name": travelTypeName,
        "kilometre": kilometre,
    };
}

class StatusHistory {
    String id;
    String action;
    String? fromStatus;
    String toStatus;
    String remarks;
    DateTime createdAt;
    String actedByName;

    StatusHistory({
        required this.id,
        required this.action,
        this.fromStatus,
        required this.toStatus,
        required this.remarks,
        required this.createdAt,
        required this.actedByName,
    });

    factory StatusHistory.fromJson(Map<String, dynamic> json) => StatusHistory(
        id: json["id"] ?? "",
        action: json["action"] ?? "",
        fromStatus: json["from_status"],
        toStatus: json["to_status"] ?? "",
        remarks: json["remarks"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        actedByName: json["acted_by_name"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "action": action,
        "from_status": fromStatus,
        "to_status": toStatus,
        "remarks": remarks,
        "created_at": createdAt.toIso8601String(),
        "acted_by_name": actedByName,
    };
}

class Visit {
    String serviceVisitId;
    String visitNo;
    String visitStatus;
    String complaintNo;
    String customerName;

    Visit({
        required this.serviceVisitId,
        required this.visitNo,
        required this.visitStatus,
        required this.complaintNo,
        required this.customerName,
    });

    factory Visit.fromJson(Map<String, dynamic> json) => Visit(
        serviceVisitId: json["service_visit_id"] ?? "",
        visitNo: json["visit_no"] ?? "",
        visitStatus: json["visit_status"] ?? "",
        complaintNo: json["complaint_no"] ?? "",
        customerName: json["customer_name"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "service_visit_id": serviceVisitId,
        "visit_no": visitNo,
        "visit_status": visitStatus,
        "complaint_no": complaintNo,
        "customer_name": customerName,
    };
}
