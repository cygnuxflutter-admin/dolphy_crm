import 'dart:convert';

import 'package:flutter/material.dart' hide State;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../config/app_colors.dart';
import '../../config/app_shared_pref.dart';
import '../../config/app_url.dart';
import '../../utils/api_handler.dart';
import '../../widget/toast_message.dart';
import '../inquiry_screen/model/Inquiry_source_model.dart';
import '../inquiry_screen/model/city_model.dart';
import '../inquiry_screen/model/country_model.dart';
import '../inquiry_screen/model/customer_group_response.dart';
import '../inquiry_screen/model/pincode_model.dart';
import '../inquiry_screen/model/state_model.dart';
import 'model/draft_inquiry_model.dart';

class DraftInquiryController extends GetxController {
  // ----------------------------------------------------
  // List / Search / Pagination
  // ----------------------------------------------------
  RxList<DraftInquiryItem> draftInquiryList = <DraftInquiryItem>[].obs;
  RxBool isListLoading = false.obs;
  RxInt totalCount = 0.obs;
  RxInt pageCount = 1.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  // ----------------------------------------------------
  // Form Controllers
  // ----------------------------------------------------
  // 1. Source (DropDown) - Non-mandatory
  RxList<LeadSourceItem> sourceList = <LeadSourceItem>[].obs;
  Rx<LeadSourceItem?> selectedSource = Rx<LeadSourceItem?>(null);
  RxBool isSourceLoading = false.obs;

  // 2. Person Name (TextField) - MANDATORY
  Rx<TextEditingController> personNameController = TextEditingController().obs;

  // 3. Company Name (TextField) - Non-mandatory
  Rx<TextEditingController> companyNameController = TextEditingController().obs;

  // 4. Mobile No (TextField) - Mutual mandatory with Email
  Rx<TextEditingController> mobileNoController = TextEditingController().obs;

  // 5. Email (TextField) - Mutual mandatory with Mobile
  Rx<TextEditingController> emailController = TextEditingController().obs;

  // 6. Designation (TextField) - Non-mandatory
  Rx<TextEditingController> designationController = TextEditingController().obs;

  // 7. Address, State, City, Pincode (Same as Add Inquiry Concept) - Non-mandatory
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> countryController = TextEditingController().obs;
  Rx<TextEditingController> stateController = TextEditingController().obs;
  Rx<TextEditingController> cityController = TextEditingController().obs;
  Rx<TextEditingController> pinCodeController = TextEditingController().obs;

  Rx<TextEditingController> countrySearchController = TextEditingController().obs;
  Rx<TextEditingController> stateSearchController = TextEditingController().obs;
  Rx<TextEditingController> citySearchController = TextEditingController().obs;
  Rx<TextEditingController> pinCodeSearchController = TextEditingController().obs;

  Rx<CountryDatum?> selectedCountry = Rx<CountryDatum?>(null);
  Rx<StateDatum?> selectedState = Rx<StateDatum?>(null);
  Rx<CityDatum?> selectedCity = Rx<CityDatum?>(null);
  Rx<PinCodeDatum?> selectedPinCode = Rx<PinCodeDatum?>(null);

  RxList<CountryDatum> countryList = <CountryDatum>[].obs;
  RxList<StateDatum> stateList = <StateDatum>[].obs;
  RxList<CityDatum> cityList = <CityDatum>[].obs;
  RxList<PinCodeDatum> pinCodeList = <PinCodeDatum>[].obs;

  RxBool isCityLoading = false.obs;
  RxBool isPinCodeLoading = false.obs;
  RxInt cityTotalCount = 0.obs;
  RxInt cityPageCount = 1.obs;
  RxInt pinCodeTotalCount = 0.obs;
  RxInt pinCodePageCount = 1.obs;

  // 8. Project Name (TextField) - Non-mandatory
  Rx<TextEditingController> projectNameController = TextEditingController().obs;

  // 9. Client Type (DropDown) - Non-mandatory
  RxList<LeadSourceItem> clientTypeList = <LeadSourceItem>[].obs;
  Rx<LeadSourceItem?> selectedClientType = Rx<LeadSourceItem?>(null);
  RxBool isClientTypeLoading = false.obs;

  // 10. Customer Group & Customer Brand (Both depend on each other) - Non-mandatory
  RxList<CustomerGroupDatum> customerGroupList = <CustomerGroupDatum>[].obs;
  Rx<CustomerGroupDatum?> selectedCustomerGroup = Rx<CustomerGroupDatum?>(null);

  RxList<CustomerGroupDatum> customerBrandList = <CustomerGroupDatum>[].obs;
  Rx<CustomerGroupDatum?> selectedCustomerBrand = Rx<CustomerGroupDatum?>(null);

  RxBool isCustomerGroupLoading = false.obs;
  RxBool isCustomerBrandLoading = false.obs;

  // 11. Remarks (TextField) - Non-mandatory
  Rx<TextEditingController> remarksController = TextEditingController().obs;

  // Global submit / edit loading
  RxBool isLoading = false.obs;
  RxBool isDetailLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initFormData();
  }

  void initFormData() {
    getDraftInquiryList(page: 1, search: searchController.value.text, fromPagination: false);
    getSourceList();
    getClientType();
    getCustomerGroup();
    getCustomerBrand();
    getCountry();
    getStateApi();
  }

  // ----------------------------------------------------
  // API 2: List / search / pagination (GET)
  // ----------------------------------------------------
  Future<void> getDraftInquiryList({bool isLoading = true, bool fromPagination = false, int? page, String? search}) async {
    final currentPage = page ?? pageCount.value;
    if (isLoading) {
      isListLoading.value = true;
    }

    try {
      final querySearch = search ?? searchController.value.text.trim();
      final url = "${ApiEndPoint.draftInquiryList}?search=$querySearch&page=$currentPage&limit=20&sortBy=created_at&sortOrder=DESC";

      final response = await ApiHandler.getRequest(url);
      final dynamic decoded = response.data is String ? json.decode(response.data) : response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final listResponse = DraftInquiryListResponse.fromJson(decoded);

        if (!fromPagination) {
          draftInquiryList.clear();
        }

        if (listResponse.data != null) {
          draftInquiryList.addAll(listResponse.data!);
        }

        if (listResponse.pagination != null) {
          totalCount.value = listResponse.pagination!.totalRecords;
        } else {
          totalCount.value = draftInquiryList.length;
        }
      } else {
        debugPrint("DraftInquiry: List failed status ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("DraftInquiryController: Error fetching draft inquiries: $e");
    } finally {
      if (isLoading) {
        isListLoading.value = false;
      }
    }
  }

  // ----------------------------------------------------
  // API 3: Get detail (GET)
  // ----------------------------------------------------
  Future<DraftInquiryItem?> getDraftInquiryDetail({required String id}) async {
    isDetailLoading.value = true;
    try {
      final url = "${ApiEndPoint.draftInquiryDetail}$id";
      final response = await ApiHandler.getRequest(url);
      final dynamic decoded = response.data is String ? json.decode(response.data) : response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final itemMap = decoded is Map && decoded.containsKey('data') && decoded['data'] is Map ? decoded['data'] : (decoded is Map ? decoded : null);

        if (itemMap != null) {
          final item = DraftInquiryItem.fromJson(Map<String, dynamic>.from(itemMap));
          prefillFromItem(item);
          return item;
        }
      }
    } catch (e) {
      debugPrint("DraftInquiryController: Error fetching draft inquiry detail: $e");
    } finally {
      isDetailLoading.value = false;
    }
    return null;
  }

  void prefillFromItem(DraftInquiryItem item) {
    personNameController.value.text = item.contactName ?? "";
    companyNameController.value.text = item.companyName ?? "";
    projectNameController.value.text = item.projectName ?? "";
    mobileNoController.value.text = item.mobile1 ?? "";
    emailController.value.text = item.email ?? "";
    designationController.value.text = item.designation ?? "";
    addressController.value.text = item.address ?? "";
    remarksController.value.text = item.remarks ?? "";

    if (item.sourceId != null && item.sourceId!.isNotEmpty) {
      selectedSource.value =
          sourceList.firstWhereOrNull((e) => e.id == item.sourceId) ?? LeadSourceItem(id: item.sourceId!, name: item.sourceName ?? "");
    }
    if (item.clientTypeId != null && item.clientTypeId!.isNotEmpty) {
      selectedClientType.value =
          clientTypeList.firstWhereOrNull((e) => e.id == item.clientTypeId) ??
          LeadSourceItem(id: item.clientTypeId!, name: item.clientTypeName ?? "");
    }
    if (item.customerGroupId != null && item.customerGroupId!.isNotEmpty) {
      selectedCustomerGroup.value =
          customerGroupList.firstWhereOrNull((e) => e.id == item.customerGroupId) ??
          CustomerGroupDatum(id: item.customerGroupId!, name: item.customerGroupName ?? "");
    }
    if (item.customerBrandId != null && item.customerBrandId!.isNotEmpty) {
      selectedCustomerBrand.value =
          customerBrandList.firstWhereOrNull((e) => e.id == item.customerBrandId) ??
          CustomerGroupDatum(id: item.customerBrandId!, name: item.customerBrandName ?? "");
    }
    if (item.countryName != null && item.countryName!.isNotEmpty) {
      countryController.value.text = item.countryName!;
    }
    if (item.stateName != null && item.stateName!.isNotEmpty) {
      stateController.value.text = item.stateName!;
    }
    if (item.cityName != null && item.cityName!.isNotEmpty) {
      cityController.value.text = item.cityName!;
    }
    if (item.pincode != null && item.pincode!.isNotEmpty) {
      pinCodeController.value.text = item.pincode!;
    }
    if (item.countryId != null && item.countryId!.isNotEmpty) {
      selectedCountry.value = CountryDatum(id: item.countryId!, name: item.countryName ?? "");
    }
    if (item.stateId != null && item.stateId!.isNotEmpty) {
      selectedState.value = StateDatum(
        id: item.stateId!,
        name: item.stateName ?? "",
        countryId: CountryId(id: item.countryId ?? "", name: item.countryName ?? ""),
      );
    }
    if (item.cityId != null && item.cityId!.isNotEmpty) {
      selectedCity.value = CityDatum(
        id: item.cityId!,
        name: item.cityName ?? "",
        stateId: StateId(id: item.stateId ?? "", name: item.stateName ?? ""),
        countryId: StateId(id: item.countryId ?? "", name: item.countryName ?? ""),
      );
    }
    if (item.pincodeId != null && item.pincodeId!.isNotEmpty) {
      selectedPinCode.value = PinCodeDatum(
        id: item.pincodeId!,
        pinCode: item.pincode ?? "",
        cityId: Id(id: item.cityId ?? "", name: item.cityName ?? ""),
        stateId: Id(id: item.stateId ?? "", name: item.stateName ?? ""),
        countryId: Id(id: item.countryId ?? "", name: item.countryName ?? ""),
      );
    }
  }

  // ----------------------------------------------------
  // API 1 & 4: Submit (Create POST / Update PATCH)
  // ----------------------------------------------------
  Future<void> submitDraftInquiry({bool isEdit = false, String? id}) async {
    final personName = personNameController.value.text.trim();
    final mobileNo = mobileNoController.value.text.trim();
    final email = emailController.value.text.trim();

    // 1. Person Name is mandatory
    if (personName.isEmpty) {
      toastMessage(text: "Person Name is required", color: AppColors.redColor, isTop: false);
      return;
    }

    // 2. Either Mobile No or Email is mandatory
    if (mobileNo.isEmpty && email.isEmpty) {
      toastMessage(text: "Either Mobile Number or Email is required", color: AppColors.redColor, isTop: false);
      return;
    }

    // 3. Format validations if entered
    if (mobileNo.isNotEmpty) {
      if (!RegExp(r'^\d{10}$').hasMatch(mobileNo)) {
        toastMessage(text: "Mobile number must be 10 digits", color: AppColors.redColor, isTop: false);
        return;
      }
      if (!RegExp(r'^[6-9]').hasMatch(mobileNo)) {
        toastMessage(text: "Indian mobile must start with 6, 7, 8, or 9", color: AppColors.redColor, isTop: false);
        return;
      }
    }

    if (email.isNotEmpty) {
      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
        toastMessage(text: "Please enter a valid email address", color: AppColors.redColor, isTop: false);
        return;
      }
    }

    isLoading.value = true;
    try {
      final designationText = designationController.value.text.trim();
      final payload = <String, dynamic>{
        "contact_name": personName,
        "person_name": personName,
        "sales_person_id": Pref.getUserId(),
        "company_name": companyNameController.value.text.trim(),
        "project_name": projectNameController.value.text.trim(),
        "designation": designationText,
        "job_position": designationText,
        "mobile1_country_code": "+91",
        "mobile1": mobileNo,
        "mobile2_country_code": "+91",
        "mobile2": "",
        "email": email,
        "website": "",
        "address": addressController.value.text.trim(),
        "inquiry_date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "remarks": remarksController.value.text.trim(),
        "tags": [],
      };

      // Optional metadata fields if available
      if (selectedSource.value != null && selectedSource.value!.id.isNotEmpty) {
        payload["source_id"] = selectedSource.value!.id;
      }
      if (selectedClientType.value != null && selectedClientType.value!.id.isNotEmpty) {
        payload["client_type_id"] = selectedClientType.value!.id;
      }
      if (selectedCustomerGroup.value != null && selectedCustomerGroup.value!.id.isNotEmpty) {
        payload["customer_group_id"] = selectedCustomerGroup.value!.id;
      }
      if (selectedCustomerBrand.value != null && selectedCustomerBrand.value!.id.isNotEmpty) {
        payload["customer_brand_id"] = selectedCustomerBrand.value!.id;
      }
      if (selectedCountry.value != null && selectedCountry.value!.id.isNotEmpty) {
        payload["country_id"] = selectedCountry.value!.id;
      }
      if (selectedState.value != null && selectedState.value!.id.isNotEmpty) {
        payload["state_id"] = selectedState.value!.id;
      }
      if (selectedCity.value != null && selectedCity.value!.id.isNotEmpty) {
        payload["city_id"] = selectedCity.value!.id;
      }
      if (selectedPinCode.value != null && selectedPinCode.value!.id.isNotEmpty) {
        payload["pincode_id"] = selectedPinCode.value!.id;
      }

      debugPrint("Draft Inquiry Payload: ${json.encode(payload)}");

      if (isEdit && id != null && id.isNotEmpty) {
        // PATCH update
        final url = "${ApiEndPoint.draftInquiryUpdate}$id";
        final response = await ApiHandler.patchTokenRequest(url: url, body: json.encode(payload));
        final dynamic decoded = response.data is String ? json.decode(response.data) : response.data;

        if (response.statusCode == 200 || response.statusCode == 201 || decoded?['status'] == 200) {
          toastMessage(text: "Draft Inquiry updated successfully", color: AppColors.greenColor, isTop: false);
          Get.back();
          pageCount.value = 1;
          await getDraftInquiryList(page: 1, fromPagination: false, isLoading: false);
        } else {
          final errorMsg = decoded?['message'] ?? response.statusMessage ?? "Failed to update draft inquiry";
          toastMessage(text: errorMsg.toString(), color: AppColors.redColor, isTop: false);
        }
      } else {
        // POST create
        final url = ApiEndPoint.draftInquiryCreate;
        final response = await ApiHandler.postRequest(url: url, body: payload);
        final dynamic decoded = response.data is String ? json.decode(response.data) : response.data;

        if (response.statusCode == 200 || response.statusCode == 201 || decoded?['status'] == 200 || decoded?['status'] == 201) {
          toastMessage(text: "Draft Inquiry created successfully", color: AppColors.greenColor, isTop: false);
          Get.back();
          pageCount.value = 1;
          await getDraftInquiryList(page: 1, fromPagination: false, isLoading: false);
        } else {
          final errorMsg = decoded?['message'] ?? response.statusMessage ?? "Failed to create draft inquiry";
          toastMessage(text: errorMsg.toString(), color: AppColors.redColor, isTop: false);
        }
      }
    } catch (e) {
      debugPrint("DraftInquiryController: Error submitting draft inquiry: $e");
      toastMessage(text: "Failed to submit draft inquiry: $e", color: AppColors.redColor, isTop: false);
    } finally {
      isLoading.value = false;
    }
  }

  // ----------------------------------------------------
  // API 5: Delete (soft delete) (DELETE)
  // ----------------------------------------------------
  Future<void> deleteDraftInquiry({required String id}) async {
    try {
      final url = "${ApiEndPoint.draftInquiryDelete}$id";
      final response = await ApiHandler.deleteRequest(url);
      final dynamic decoded = response.data is String ? json.decode(response.data) : response.data;

      if (response.statusCode == 200 || response.statusCode == 204 || decoded?['status'] == 200) {
        toastMessage(text: "Draft Inquiry deleted successfully", color: AppColors.greenColor, isTop: false);
        Get.back(); // close confirmation dialog
        draftInquiryList.removeWhere((item) => item.id == id);
        totalCount.value = draftInquiryList.length;
        // Refresh list
        getDraftInquiryList(page: 1, fromPagination: false, isLoading: false);
      } else {
        final errorMsg = decoded?['message'] ?? "Failed to delete draft inquiry";
        toastMessage(text: errorMsg.toString(), color: AppColors.redColor, isTop: false);
      }
    } catch (e) {
      debugPrint("DraftInquiryController: Error deleting draft inquiry: $e");
      toastMessage(text: "Failed to delete draft inquiry", color: AppColors.redColor, isTop: false);
    }
  }

  // ----------------------------------------------------
  // Dropdowns & Location APIs
  // ----------------------------------------------------
  Future<void> getSourceList() async {
    isSourceLoading.value = true;
    try {
      final response = await ApiHandler.getRequest(ApiEndPoint.leadSource);
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        InquirySourceModel sourceModel = InquirySourceModel.fromJson(json.decode(response.data));
        if (sourceModel.inquirySourceDatum.isNotEmpty) {
          sourceList.assignAll(sourceModel.inquirySourceDatum.first.leadSourceItems);
        }
      }
    } catch (e) {
      debugPrint("DraftInquiryController: Error loading sources: $e");
    } finally {
      isSourceLoading.value = false;
    }
  }

  Future<void> getClientType() async {
    isClientTypeLoading.value = true;
    try {
      if (clientTypeList.isEmpty) {
        clientTypeList.assignAll([
          LeadSourceItem(id: "1", name: "End User"),
          LeadSourceItem(id: "2", name: "Architect"),
          LeadSourceItem(id: "3", name: "Builder"),
          LeadSourceItem(id: "4", name: "Contractor"),
          LeadSourceItem(id: "5", name: "Dealer"),
          LeadSourceItem(id: "6", name: "Distributor"),
          LeadSourceItem(id: "7", name: "Corporate"),
        ]);
      }
    } catch (e) {
      debugPrint("DraftInquiryController: Error loading client types: $e");
    } finally {
      isClientTypeLoading.value = false;
    }
  }

  Future<void> getCustomerGroup() async {
    isCustomerGroupLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.getCustomerGroup}?page=1&limit=200&level=0&include_inactive=true&exportData=false");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        CustomerGroupResponseModel model = CustomerGroupResponseModel.fromJson(json.decode(response.data));
        customerGroupList.assignAll(model.customerGroupData);
      }
    } catch (e) {
      debugPrint("DraftInquiryController: Error loading customer groups: $e");
    } finally {
      isCustomerGroupLoading.value = false;
    }
  }

  Future<void> getCustomerBrand() async {
    isCustomerBrandLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.getCustomerGroup}?page=1&limit=200&level=1&include_inactive=true&exportData=false");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        CustomerGroupResponseModel model = CustomerGroupResponseModel.fromJson(json.decode(response.data));
        customerBrandList.assignAll(model.customerGroupData);
      }
    } catch (e) {
      debugPrint("DraftInquiryController: Error loading customer brands: $e");
    } finally {
      isCustomerBrandLoading.value = false;
    }
  }

  void onCustomerGroupSelected(CustomerGroupDatum? group) {
    selectedCustomerGroup.value = group;
    if (group == null) return;

    final currentBrand = selectedCustomerBrand.value;
    final currentBrandParentId = currentBrand?.parentId ?? currentBrand?.parent?.id;

    if (currentBrand != null && currentBrandParentId == group.id) {
      return;
    }

    final matchingBrand = customerBrandList.firstWhereOrNull((brand) => (brand.parentId == group.id || brand.parent?.id == group.id));
    if (matchingBrand != null) {
      selectedCustomerBrand.value = matchingBrand;
    }
  }

  void onCustomerBrandSelected(CustomerGroupDatum? brand) {
    selectedCustomerBrand.value = brand;
    if (brand == null) return;

    final parentGroupId = brand.parentId ?? brand.parent?.id;
    if (parentGroupId != null && parentGroupId.isNotEmpty) {
      if (selectedCustomerGroup.value?.id == parentGroupId) {
        return;
      }

      final matchingGroup = customerGroupList.firstWhereOrNull((group) => group.id == parentGroupId);
      if (matchingGroup != null) {
        selectedCustomerGroup.value = matchingGroup;
      } else if (brand.parent != null) {
        selectedCustomerGroup.value = CustomerGroupDatum(id: brand.parent!.id, name: brand.parent!.name);
      }
    }
  }

  Future<void> getCountry({String? search}) async {
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.country}?search=${search ?? ""}");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        CountryResponseModel countryResponseModel = CountryResponseModel.fromJson(json.decode(response.data));
        countryList.assignAll(countryResponseModel.countryData);
      }
    } catch (e) {
      debugPrint("DraftInquiryController: Error loading countries: $e");
    }
  }

  Future<void> getStateApi({String? search, String? countryId}) async {
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.state}?search=${search ?? ""}&country_id=${countryId ?? ""}");
      final data = json.decode(response.data);
      if (response.statusCode == 200 && data['status'] == 200) {
        States state = States.fromJson(json.decode(response.data));
        stateList.assignAll(state.data);
      }
    } catch (e) {
      debugPrint("DraftInquiryController: Error loading states: $e");
    }
  }

  Future<void> getCityApi({required int page, String? search, String? stateId, bool fromPagination = true}) async {
    isCityLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.city}?search=${search ?? ""}&page=$page&limit=50&state_id=${stateId ?? ""}");
      final data = json.decode(response.data);
      if (response.statusCode == 200) {
        if (data['success'] == true) {
          if (!fromPagination) {
            cityList.clear();
            cityTotalCount.value = 0;
          }
          City city = cityFromJson(response.data);
          cityList.addAll(city.data);
          cityTotalCount.value = city.pagination.totalRecords;
        }
      }
    } catch (e) {
      debugPrint("DraftInquiryController: Error loading cities: $e");
    } finally {
      isCityLoading.value = false;
    }
  }

  Future<void> getPinCodeApi({required int page, String? search, String? cityId, bool fromPagination = true}) async {
    isPinCodeLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.pinCode}?search=${search ?? ""}&page=$page&limit=50&city_id=${cityId ?? ""}");
      final data = json.decode(response.data);
      if (response.statusCode == 200) {
        if (data['success'] == true) {
          if (!fromPagination) {
            pinCodeList.clear();
            pinCodeTotalCount.value = 0;
          }
          PinCode pinCode = pinCodeFromJson(response.data);
          pinCodeList.addAll(pinCode.data);
          pinCodeTotalCount.value = pinCode.pagination.totalRecords;
        }
      }
    } catch (e) {
      debugPrint("DraftInquiryController: Error loading pincodes: $e");
    } finally {
      isPinCodeLoading.value = false;
    }
  }

  void resetForm() {
    selectedSource.value = null;
    personNameController.value.clear();
    companyNameController.value.clear();
    mobileNoController.value.clear();
    emailController.value.clear();
    designationController.value.clear();
    addressController.value.clear();
    countryController.value.clear();
    stateController.value.clear();
    cityController.value.clear();
    pinCodeController.value.clear();
    selectedCountry.value = null;
    selectedState.value = null;
    selectedCity.value = null;
    selectedPinCode.value = null;
    projectNameController.value.clear();
    selectedClientType.value = null;
    selectedCustomerGroup.value = null;
    selectedCustomerBrand.value = null;
    remarksController.value.clear();
  }
}
