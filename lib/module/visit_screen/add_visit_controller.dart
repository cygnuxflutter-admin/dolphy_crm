import 'dart:convert';

import 'package:crm/config/app_shared_pref.dart';
import 'package:crm/config/app_url.dart';
import 'package:crm/module/lead_screen/model/get_assign_partner.dart';
import 'package:crm/module/lead_screen/model/lead_type.dart';
import 'package:crm/module/visit_screen/model/visit_view_model.dart';
import 'package:crm/utils/api_handler.dart';
import 'package:crm/widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddVisitController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isSubmitLoading = false.obs;
  RxBool isComplaintLoading = false.obs;
  RxBool isTechnicianLoading = false.obs;
  RxBool isProductLoading = false.obs;

  // Edit Mode
  RxBool isEdit = false.obs;
  String? visitId;
  String? currentStatus;

  // Form Fields
  final complaintSearchController = TextEditingController().obs;
  final customerNameController = TextEditingController().obs;
  final visitPurposeController = TextEditingController().obs;
  final technicianSearchController = TextEditingController().obs;
  final remarkController = TextEditingController().obs;
  final startDateController = TextEditingController().obs;
  final endDateController = TextEditingController().obs;
  final contactPersonController = TextEditingController().obs;
  final mobileController = TextEditingController().obs;
  final addressController = TextEditingController().obs;

  String? customerId;
  String? addressId;
  String? mobileCountryCode;

  Rxn<dynamic> selectedComplaint = Rxn<dynamic>();
  Rxn<LeadItem> selectedVisitPurpose = Rxn<LeadItem>();
  Rxn<AssignSalesPerson> selectedPrimaryTechnician = Rxn<AssignSalesPerson>();
  RxList<AssignSalesPerson> selectedTechnicians = <AssignSalesPerson>[].obs;

  RxList<dynamic> complaintList = <dynamic>[].obs;
  RxList<LeadItem> visitPurposeList = <LeadItem>[].obs;
  RxList<AssignSalesPerson> technicianList = <AssignSalesPerson>[].obs;
  RxList<Product> complaintProducts = <Product>[].obs;

  RxList<dynamic> statusOptionsList = <dynamic>[].obs;
  Rxn<dynamic> selectedStatus = Rxn<dynamic>();

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  Future<void> initData() async {
    isLoading.value = true;
    await getVisitPurposes();
    await getTechnicians();
    await getStatusOptions();
    if (Get.arguments != null && Get.arguments is String) {
      isEdit.value = true;
      visitId = Get.arguments;
      await fetchVisitDetailForEdit(visitId!);
    }
    isLoading.value = false;
  }

  Future<void> fetchVisitDetailForEdit(String id) async {
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}service-visit/find/$id");
      final data = json.decode(response.data);

      if (response.statusCode == 200 && data['status'] == 200) {
        VisitViewModel res = VisitViewModel.fromJson(data);
        final visit = res.data;

        // Populate Form
        visitId = visit.id;
        currentStatus = visit.status;
        customerId = visit.customerId;
        addressId = visit.addressId;
        mobileCountryCode = visit.mobileCountryCode;

        selectedComplaint.value = {"id": visit.serviceQueryId, "complaint_no": visit.complaintNo, "customer_name": visit.customerName};
        complaintSearchController.value.text = visit.complaintNo;

        customerNameController.value.text = visit.customerName;
        contactPersonController.value.text = visit.contactPerson;
        mobileController.value.text = visit.mobile;
        addressController.value.text = visit.address;
        remarkController.value.text = visit.remark ?? "";

        selectedStatus.value = statusOptionsList.firstWhereOrNull((e) => e['value'] == visit.status);

        startDateController.value.text = DateFormat('yyyy-MM-dd HH:mm').format(visit.visitStartDatetime.toLocal());
        endDateController.value.text = DateFormat('yyyy-MM-dd HH:mm').format(visit.visitEndDatetime.toLocal());

        // Selection variables
        selectedVisitPurpose.value =
            visitPurposeList.firstWhereOrNull((e) => e.id == visit.visitPurpose) ?? LeadItem(id: visit.visitPurpose, name: visit.visitPurposeName);

        selectedTechnicians.clear();
        for (var tech in visit.technicians) {
          AssignSalesPerson? salesPerson = technicianList.firstWhereOrNull((e) => e.id == tech.id);
          if (salesPerson == null) {
            final names = tech.name.split(' ');
            final firstName = names.isNotEmpty ? names[0] : tech.name;
            final lastName = names.length > 1 ? names.sublist(1).join(' ') : "";
            salesPerson = AssignSalesPerson(id: tech.id, firstName: firstName, lastName: lastName);
          }
          selectedTechnicians.add(salesPerson);

          if (tech.id == visit.primaryTechnicianId) {
            selectedPrimaryTechnician.value = salesPerson;
          }
        }

        // Double check if primary was set
        if (selectedPrimaryTechnician.value == null && visit.primaryTechnicianId.isNotEmpty) {
          AssignSalesPerson? salesPerson = technicianList.firstWhereOrNull((e) => e.id == visit.primaryTechnicianId);
          if (salesPerson == null) {
            final names = visit.primaryTechnicianName.split(' ');
            final firstName = names.isNotEmpty ? names[0] : visit.primaryTechnicianName;
            final lastName = names.length > 1 ? names.sublist(1).join(' ') : "";
            salesPerson = AssignSalesPerson(id: visit.primaryTechnicianId, firstName: firstName, lastName: lastName);
          }
          selectedPrimaryTechnician.value = salesPerson;
        }

        // Products
        complaintProducts.assignAll(visit.products);
      }
    } catch (e) {
      debugPrint("Error fetching visit for edit: $e");
    }
  }

  Future<void> getComplaints(String search) async {
    isComplaintLoading.value = true;
    try {
      final response = await ApiHandler.getRequest(
        "${ApiEndPoint.baseUrl}service-query/find?page=1&rowsPerPage=20&search=$search&company_id=${Pref.getCompanyId()}&location_id=${Pref.getLocationId()}",
      );
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        complaintList.assignAll(data['data']);
      }
    } catch (e) {
      debugPrint("Error fetching complaints: $e");
    } finally {
      isComplaintLoading.value = false;
    }
  }

  Future<void> getVisitPurposes() async {
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}commonMaster/findByGroup?type=Visit+Purpose");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        LeadType res = LeadType.fromJson(data);
        if (res.data.isNotEmpty) {
          visitPurposeList.assignAll(res.data.first.items);
        }
      }
    } catch (e) {
      debugPrint("Error fetching visit purposes: $e");
    }
  }

  Future<void> getTechnicians({String search = ""}) async {
    isTechnicianLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.assignSalesPerson}?search=$search&limit=50");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        GetAssignSalesPersonResponseModel res = GetAssignSalesPersonResponseModel.fromJson(data);
        if (res.data != null) {
          technicianList.assignAll(res.data!);
        }
      }
    } catch (e) {
      debugPrint("Error fetching technicians: $e");
    } finally {
      isTechnicianLoading.value = false;
    }
  }

  Future<void> getStatusOptions() async {
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}service-visit/status-options");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true)) {
        statusOptionsList.assignAll(data['data']);
      }
    } catch (e) {
      debugPrint("Error fetching status options: $e");
    }
  }

  Future<void> onComplaintSelected(dynamic complaint) async {
    selectedComplaint.value = complaint;
    complaintSearchController.value.text = complaint['complaint_no'] ?? "";
    getComplaintPrefill(complaint['id']);
  }

  Future<void> getComplaintPrefill(String complaintId) async {
    isProductLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}service-visit/complaint-prefill/$complaintId");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        final prefillData = data['data'];
        if (prefillData != null) {
          customerId = prefillData['customer_id'];
          addressId = prefillData['address_id'];
          mobileCountryCode = prefillData['mobile_country_code'] ?? "+91";

          customerNameController.value.text = prefillData['customer_name'] ?? "";
          contactPersonController.value.text = prefillData['contact_person'] ?? "";
          mobileController.value.text = prefillData['mobile'] ?? "";
          addressController.value.text = prefillData['address'] ?? "";

          if (prefillData['visit_purpose'] != null) {
            selectedVisitPurpose.value = visitPurposeList.firstWhereOrNull((element) => element.id == prefillData['visit_purpose']);
          }

          if (prefillData['products'] != null) {
            complaintProducts.assignAll(List<Product>.from(prefillData['products'].map((x) => Product.fromJson(x))));
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching complaint prefill: $e");
    } finally {
      isProductLoading.value = false;
    }
  }

  Future<void> selectDateTime(BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        controller.text = DateFormat('yyyy-MM-dd HH:mm').format(finalDateTime);

        if (controller == startDateController.value) {
          final DateTime endDateTime = finalDateTime.add(const Duration(hours: 1));
          endDateController.value.text = DateFormat('yyyy-MM-dd HH:mm').format(endDateTime);
        }
      }
    }
  }

  void onPrimaryTechnicianSelected(AssignSalesPerson? technician) {
    selectedPrimaryTechnician.value = technician;
    if (technician != null) {
      if (!selectedTechnicians.any((e) => e.id == technician.id)) {
        selectedTechnicians.add(technician);
      }
    }
  }

  void onTechnicianSelected(AssignSalesPerson? technician) {
    if (technician != null) {
      if (!selectedTechnicians.any((e) => e.id == technician.id)) {
        selectedTechnicians.add(technician);
      }
    }
  }

  void removeTechnician(AssignSalesPerson technician) {
    selectedTechnicians.removeWhere((e) => e.id == technician.id);
    if (selectedPrimaryTechnician.value?.id == technician.id) {
      selectedPrimaryTechnician.value = null;
    }
  }

  Future<void> submitVisit() async {
    final complaint = selectedComplaint.value;
    if (complaint == null) {
      toastMessage(text: "Please select a complaint");
      return;
    }
    if (startDateController.value.text.isEmpty) {
      toastMessage(text: "Please select start date");
      return;
    }
    if (endDateController.value.text.isEmpty) {
      toastMessage(text: "Please select end date");
      return;
    }
    if (selectedVisitPurpose.value == null) {
      toastMessage(text: "Please select visit purpose");
      return;
    }
    if (selectedPrimaryTechnician.value == null) {
      toastMessage(text: "Please select primary technician");
      return;
    }

    isSubmitLoading.value = true;
    try {
      // Helper to convert yyyy-MM-dd HH:mm to ISO8601
      String formatToIso(String dateStr) {
        if (dateStr.isEmpty) return "";
        try {
          DateTime dt = DateFormat('yyyy-MM-dd HH:mm').parse(dateStr);
          return dt.toUtc().toIso8601String();
        } catch (e) {
          return "";
        }
      }

      final body = {
        "service_query_id": complaint['id'],
        "customer_id": customerId,
        "address_id": addressId,
        "visit_purpose": selectedVisitPurpose.value?.id,
        "visit_start_datetime": formatToIso(startDateController.value.text),
        "visit_end_datetime": formatToIso(endDateController.value.text),
        "remark": remarkController.value.text,
        "contact_person": contactPersonController.value.text,
        "mobile_country_code": mobileCountryCode ?? "+91",
        "mobile": mobileController.value.text,
        "technician_ids": selectedTechnicians.map((e) => e.id).toList(),
        "primary_technician_id": selectedPrimaryTechnician.value?.id,
      };

      if (isEdit.value) {
        body["status"] = selectedStatus.value?['value'] ?? currentStatus ?? "pending";
      }

      final url = isEdit.value ? "${ApiEndPoint.baseUrl}service-visit/update/$visitId" : "${ApiEndPoint.baseUrl}service-visit/create";

      final response = isEdit.value ? await ApiHandler.putRequest(url: url, body: body) : await ApiHandler.postRequest(url: url, body: body);

      final data = response.data;
      if (response.statusCode == 201 || (response.statusCode == 200 && (data['status'] == 200 || data['success'] == true))) {
        toastMessage(text: data['message'] ?? (isEdit.value ? "Visit updated successfully" : "Visit added successfully"));
        Get.back(result: true);
      } else {
        toastMessage(text: data['message'] ?? "Failed to save visit");
      }
    } catch (e) {
      debugPrint("Error submitting visit: $e");
      toastMessage(text: "Something went wrong");
    } finally {
      isSubmitLoading.value = false;
    }
  }
}
