import 'dart:convert';

import 'package:crm/config/app_shared_pref.dart';
import 'package:crm/module/inquiry_screen/model/pincode_model.dart';
import 'package:flutter/material.dart' hide State;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../config/app_colors.dart';
import '../../config/app_url.dart';
import '../../main.dart';
import '../../utils/api_handler.dart';
import '../../widget/toast_message.dart';
import 'model/Inquiry_list_response.dart';
import 'model/Inquiry_source_model.dart';
import 'model/Inquiry_submit_request.dart';
import 'model/Inquiry_view_response.dart';
import 'model/add_address_model.dart';
import 'model/city_model.dart';
import 'model/country_model.dart';
import 'model/customer_group_response.dart';
import 'model/state_model.dart';

class InquiryScreenController extends GetxController {
  RxInt totalCount = 1.obs;
  RxInt pageCount = 1.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxInt cityTotalCount = 1.obs;
  RxInt cityPageCount = 1.obs;
  Rx<TextEditingController> citySearchController = TextEditingController().obs;

  RxInt addAddressCityTotalCount = 1.obs;
  RxInt addAddressCityPageCount = 1.obs;
  Rx<TextEditingController> addAddressCitySearchController = TextEditingController().obs;

  RxInt pinCodeTotalCount = 1.obs;
  RxInt pinCodePageCount = 1.obs;
  Rx<TextEditingController> pinCodeSearchController = TextEditingController().obs;

  RxInt addAddressPinCodeTotalCount = 1.obs;
  RxInt addAddressPinCodePageCount = 1.obs;
  Rx<TextEditingController> addAddressPinCodeSearchController = TextEditingController().obs;

  Rx<TextEditingController> panNumberController = TextEditingController().obs;
  Rx<TextEditingController> gstTreatmentController = TextEditingController().obs;
  Rx<TextEditingController> gstInController = TextEditingController().obs;
  // Rx<TextEditingController> leadDateController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> projectNameController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  Rx<TextEditingController> emailIdController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberCountryCodeController = TextEditingController(text: "+91").obs;
  Rx<TextEditingController> phoneNumberCountryCodeController = TextEditingController(text: "+91").obs;
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> landlineNumberController = TextEditingController().obs;
  Rx<TextEditingController> webSiteController = TextEditingController().obs;
  Rx<TextEditingController> streetController = TextEditingController().obs;
  Rx<TextEditingController> tagsController = TextEditingController().obs;

  // Rx<TextEditingController> countryController = TextEditingController().obs;
  Rx<TextEditingController> stateController = TextEditingController().obs;
  Rx<TextEditingController> countryController = TextEditingController().obs;
  Rx<TextEditingController> cityController = TextEditingController().obs;
  Rx<TextEditingController> pinCodeNumberController = TextEditingController().obs;
  Rx<TextEditingController> priceTypeController = TextEditingController().obs;
  Rx<TextEditingController> remarksController = TextEditingController().obs;

  Rx<TextEditingController> countrySearchController = TextEditingController().obs;
  Rx<TextEditingController> stateSearchController = TextEditingController().obs;

  /// IMPORTANT — Controller MUST NOT be Rx
  MultiSelectController<LeadSourceItem> leadTagController = MultiSelectController<LeadSourceItem>();

  /// add Address Controller

  Rx<TextEditingController> addAddressNameController = TextEditingController().obs;
  Rx<TextEditingController> addAddressCompanyNameController = TextEditingController().obs;
  Rx<TextEditingController> addAddressMobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> addAddressMobileNumber2Controller = TextEditingController().obs;
  Rx<TextEditingController> addAddressMobile1CountryCodeController = TextEditingController(text: "+91").obs;
  Rx<TextEditingController> addAddressMobile2CountryCodeController = TextEditingController(text: "+91").obs;
  Rx<TextEditingController> addAddressDesignationController = TextEditingController().obs;
  Rx<TextEditingController> addAddressController = TextEditingController().obs;
  Rx<TextEditingController> addAddressCityController = TextEditingController().obs;
  Rx<TextEditingController> addAddressPinCodeNumberController = TextEditingController().obs;

  // Rx<TextEditingController> addAddressCountryController = TextEditingController().obs;
  Rx<TextEditingController> addAddressInternalNotesController = TextEditingController().obs;

  Rx<StateDatum?> selectedAddAddressState = Rx<StateDatum?>(null);
  Rx<CityDatum?> selectedAddAddressCity = Rx<CityDatum?>(null);
  Rx<PinCodeDatum?> selectedAddAddressPinCode = Rx<PinCodeDatum?>(null);
  Rx<CountryDatum?> selectedAddAddressCountry = Rx<CountryDatum?>(null);

  RxBool isMobile = false.obs;
  RxBool isActive = true.obs;
  RxString phoneType = 'Mobile'.obs;
  RxBool isLoading = false.obs;
  RxBool isLeadDataLoading = false.obs;
  RxBool isLeadViewLoading = false.obs;
  RxBool isLeadEditLoading = false.obs;
  RxBool isCityLoading = false.obs;
  RxBool isAddAddressCityLoading = false.obs;
  RxBool isPinCodeLoading = false.obs;
  RxBool isAddAddressPinCodeLoading = false.obs;

  RxList<String> gstTreatmentList = <String>["Registered Business", "Unregistered Business", "Composition", "Exeption"].obs;
  Rx<String?> selectedGstTreatmentType = Rx<String?>(null);

  /// lead list
  RxList<LeadListDatum> leadList = <LeadListDatum>[].obs;

  /// lead source
  RxList<LeadSourceItem> leadSourceItemList = <LeadSourceItem>[].obs;
  RxList<StateDatum> stateList = <StateDatum>[].obs;
  RxList<CityDatum> cityList = <CityDatum>[].obs;
  RxList<PinCodeDatum> pinCodeList = <PinCodeDatum>[].obs;
  RxList<CityDatum> addAddressCityList = <CityDatum>[].obs;
  RxList<PinCodeDatum> addAddressPinCodeList = <PinCodeDatum>[].obs;

  Rx<StateDatum?> selectedState = Rx<StateDatum?>(null);

  Rx<CityDatum?> selectedCity = Rx<CityDatum?>(null);

  Rx<PinCodeDatum?> selectedPinCode = Rx<PinCodeDatum?>(null);

  Rx<LeadSourceItem?> selectedLeadSourceItemType = Rx<LeadSourceItem?>(null);

  /// lead tag
  RxList<LeadSourceItem> leadTagsTypeList = <LeadSourceItem>[].obs;

  // Rx<LeadSourceItem?> selectedLeadTagsType = Rx<LeadSourceItem?>(null);
  RxList<LeadSourceItem> selectedLeadTagsType = <LeadSourceItem>[].obs;

  /// price type
  RxList<LeadSourceItem> priceTypeList = <LeadSourceItem>[].obs;
  Rx<LeadSourceItem?> selectedPriceType = Rx<LeadSourceItem?>(null);

  /// Address Type
  RxList<LeadSourceItem> addressTypeList = <LeadSourceItem>[].obs;
  Rx<LeadSourceItem?> selectedAddressType = Rx<LeadSourceItem?>(null);

  RxList<AddAddressModel> addAddressList = <AddAddressModel>[].obs;

  /// Country
  RxList<CountryDatum> countryList = <CountryDatum>[].obs;
  Rx<CountryDatum?> selectedCountry = Rx<CountryDatum?>(null);

  /// lead view
  Rxn<InquiryViewData> leadViewData = Rxn(null);

  /// Customer Brand
  RxList<CustomerGroupDatum> customerGroupDataList = <CustomerGroupDatum>[].obs;
  Rx<CustomerGroupDatum?> selectedCustomerGroupType = Rx<CustomerGroupDatum?>(null);

  /// Customer Brand
  RxList<CustomerGroupDatum> customerBrandDataList = <CustomerGroupDatum>[].obs;
  Rx<CustomerGroupDatum?> selectedCustomerBrandType = Rx<CustomerGroupDatum?>(null);

  void addAddress({bool isEdit = false, bool isNew = false, int? index}) {
    if (isEdit == false) {
      addAddressList.add(
        AddAddressModel(
          type: LeadSourceItem(id: selectedAddressType.value!.id, name: selectedAddressType.value!.name),
          contactName: addAddressNameController.value.text,
          companyName: addAddressCompanyNameController.value.text,
          email: "",
          mobile1: addAddressMobileNumberController.value.text,
          mobile2: addAddressMobileNumber2Controller.value.text,
          street: addAddressController.value.text,
          cityId: CityDatum(
            id: selectedAddAddressCity.value!.id,
            name: selectedAddAddressCity.value!.name,
            stateId: selectedAddAddressCity.value!.stateId,
            countryId: selectedAddAddressCity.value!.countryId,
          ),
          stateId: StateDatum(
            id: selectedAddAddressState.value!.id,
            name: selectedAddAddressState.value!.name,
            countryId: CountryId(id: selectedAddAddressCountry.value!.id, name: selectedAddAddressCountry.value!.name),
          ),
          pincodeId: PinCodeDatum(
            id: selectedAddAddressPinCode.value!.id,
            pinCode: selectedAddAddressPinCode.value!.pinCode,
            cityId: selectedAddAddressPinCode.value!.cityId,
            stateId: selectedAddAddressPinCode.value!.stateId,
            countryId: selectedAddAddressPinCode.value!.countryId,
          ),
          countryId: CountryDatum(id: selectedAddAddressCountry.value!.id, name: selectedAddAddressCountry.value!.name),
          remarks: addAddressInternalNotesController.value.text,
          isActive: isActive.value,
          designation: addAddressDesignationController.value.text,
        ),
      );
      selectedAddressType.value = null;
      addAddressNameController.value.clear();
      addAddressCompanyNameController.value.clear();
      addAddressMobileNumberController.value.clear();
      addAddressMobileNumber2Controller.value.clear();
      addAddressController.value.clear();
      addAddressPinCodeNumberController.value.clear();
      addAddressCityController.value.clear();
      selectedAddAddressCity.value = null;
      selectedAddAddressState.value = null;
      selectedAddAddressPinCode.value = null;
      selectedAddAddressCountry.value = null;
      addAddressInternalNotesController.value.clear();
      addAddressDesignationController.value.clear();
    } else {
      addAddressList[index!] = AddAddressModel(
        type: LeadSourceItem(id: selectedAddressType.value!.id, name: selectedAddressType.value!.name),
        contactName: addAddressNameController.value.text,
        companyName: addAddressCompanyNameController.value.text,
        email: "",
        mobile1: addAddressMobileNumberController.value.text,
        mobile2: addAddressMobileNumber2Controller.value.text,
        street: addAddressController.value.text,
        cityId: CityDatum(
          id: selectedAddAddressCity.value!.id,
          name: selectedAddAddressCity.value!.name,
          stateId: selectedAddAddressCity.value!.stateId,
          countryId: selectedAddAddressCity.value!.countryId,
        ),
        stateId: StateDatum(
          id: selectedAddAddressState.value!.id,
          name: selectedAddAddressState.value!.name,
          countryId: CountryId(id: selectedCountry.value!.id, name: selectedCountry.value!.name),
        ),
        pincodeId: PinCodeDatum(
          id: selectedAddAddressPinCode.value!.id,
          pinCode: selectedAddAddressPinCode.value!.pinCode,
          cityId: selectedAddAddressPinCode.value!.cityId,
          stateId: selectedAddAddressPinCode.value!.stateId,
          countryId: selectedAddAddressPinCode.value!.countryId,
        ),
        countryId: CountryDatum(id: selectedAddAddressCountry.value!.id, name: selectedAddAddressCountry.value!.name),
        remarks: addAddressInternalNotesController.value.text,
        isActive: isActive.value,
        designation: addAddressDesignationController.value.text,
      );
      if (isNew == true) {
        addAddressList.add(
          AddAddressModel(
            type: LeadSourceItem(id: selectedAddressType.value!.id, name: selectedAddressType.value!.name),
            contactName: addAddressNameController.value.text,
            companyName: addAddressCompanyNameController.value.text,
            email: "",
            mobile1: addAddressMobileNumberController.value.text,
            mobile2: addAddressMobileNumber2Controller.value.text,
            street: addAddressController.value.text,
            cityId: CityDatum(
              id: selectedAddAddressCity.value!.id,
              name: selectedAddAddressCity.value!.name,
              stateId: selectedAddAddressCity.value!.stateId,
              countryId: selectedAddAddressCity.value!.countryId,
            ),
            stateId: StateDatum(
              id: selectedAddAddressState.value!.id,
              name: selectedAddAddressState.value!.name,
              countryId: CountryId(id: selectedAddAddressCountry.value!.id, name: selectedAddAddressCountry.value!.name),
            ),
            pincodeId: PinCodeDatum(
              id: selectedAddAddressPinCode.value!.id,
              pinCode: selectedAddAddressPinCode.value!.pinCode,
              cityId: selectedAddAddressPinCode.value!.cityId,
              stateId: selectedAddAddressPinCode.value!.stateId,
              countryId: selectedAddAddressPinCode.value!.countryId,
            ),
            countryId: CountryDatum(id: selectedAddAddressCountry.value!.id, name: selectedAddAddressCountry.value!.name),
            remarks: addAddressInternalNotesController.value.text,
            isActive: isActive.value,
            designation: addAddressDesignationController.value.text,
          ),
        );
        selectedAddressType.value = null;
        addAddressNameController.value.clear();
        addAddressCompanyNameController.value.clear();
        addAddressMobileNumberController.value.clear();
        addAddressMobileNumber2Controller.value.clear();
        addAddressController.value.clear();
        addAddressPinCodeNumberController.value.clear();
        addAddressCityController.value.clear();
        selectedAddAddressCity.value = null;
        selectedAddAddressState.value = null;
        selectedAddAddressPinCode.value = null;
        selectedAddAddressCountry.value = null;
        addAddressInternalNotesController.value.clear();
        addAddressDesignationController.value.clear();
      }
    }
  }

  Future<void> getLeadSourceItem() async {
    var response = await ApiHandler.getRequest(ApiEndPoint.leadSource);
    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        InquirySourceModel leadSourceModel = InquirySourceModel.fromJson(json.decode(response.data));
        leadSourceItemList.addAll(leadSourceModel.inquirySourceDatum.first.leadSourceItems);
      }
    }
  }

  Future<void> getLeadTagsType() async {
    var response = await ApiHandler.getRequest(ApiEndPoint.leadTags);
    final data = json.decode(response.data);
    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        InquirySourceModel leadSourceModel = InquirySourceModel.fromJson(json.decode(response.data));
        leadTagsTypeList.addAll(leadSourceModel.inquirySourceDatum.first.leadSourceItems);
      }
    }
  }

  Future<void> getCountry({String? search}) async {
    var response = await ApiHandler.getRequest("${ApiEndPoint.country}?search=${search ?? ""}");
    final data = json.decode(response.data);
    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        CountryResponseModel countryResponseModel = CountryResponseModel.fromJson(json.decode(response.data));
        countryList.assignAll(countryResponseModel.countryData);
      }
    }
  }

  Future<void> getStateApi({String? search, String? countryId}) async {
    final response = await ApiHandler.getRequest("${ApiEndPoint.state}?search=${search ?? ""}&country_id=${countryId ?? ""}");

    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        States state = States.fromJson(json.decode(response.data));
        stateList.assignAll(state.data);
      }
    }
  }

  RxBool gstLoading = false.obs;
  void showGlobalLoader() {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) {
        return const Center(child: CircularProgressIndicator(color: Colors.white));
      },
    );
  }

  void hideGlobalLoader() {
    Get.back();
  }

  Future<void> getGst(String gstNo) async {
    GlobalLoader.show();
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.baseUrl}customer/check-gst?gst_number=$gstNo");
      var data = json.decode(response.data);

      if (data['success'] == true && data['data'] == false) {
        final loginResponse = await ApiHandler.postRequest(
          url: "https://services.cygnux.in/api/auth/login",
          body: {"email": "tms@cygnux.in", "password": "password123"},
        );

        if (loginResponse.statusCode == 200) {
          var loginData = loginResponse.data;
          String token = loginData['token'];

          final gstDetailsResponse = await ApiHandler.postRequest(
            url: "https://services.cygnux.in/api/gst",
            body: {"api_key": "3493b6157704060ebedf98b0ab432f62", "user_id": 10, "gst": gstNo},
            headers: {'Content-Type': 'application/json', 'Accept': '*/*', "Authorization": "Bearer $token"},
          );

          if (gstDetailsResponse.statusCode == 200) {
            var gstData = gstDetailsResponse.data;
            if (gstData['status'] == 1 && gstData['response'] != null && gstData['response']['data'] != null) {
              var d = gstData['response']['data'];

              nameController.value.text = d['lgnm'] ?? "";
              companyNameController.value.text = d['tradeNam'] ?? "";

              var addr = d['pradr']?['addr'];
              if (addr != null) {
                List<String> addressParts = [];
                if (addr['bno']?.toString().isNotEmpty == true) addressParts.add(addr['bno'].toString());
                if (addr['flno']?.toString().isNotEmpty == true) addressParts.add(addr['flno'].toString());
                if (addr['bnm']?.toString().isNotEmpty == true) addressParts.add(addr['bnm'].toString());
                if (addr['st']?.toString().isNotEmpty == true) addressParts.add(addr['st'].toString());
                if (addr['locality']?.toString().isNotEmpty == true) addressParts.add(addr['locality'].toString());
                if (addr['landMark']?.toString().isNotEmpty == true) addressParts.add(addr['landMark'].toString());
                if (addr['loc']?.toString().isNotEmpty == true) addressParts.add(addr['loc'].toString());
                if (addr['dst']?.toString().isNotEmpty == true) addressParts.add(addr['dst'].toString());
                if (addr['stcd']?.toString().isNotEmpty == true) addressParts.add(addr['stcd'].toString());
                if (addr['pncd']?.toString().isNotEmpty == true) addressParts.add(addr['pncd'].toString());

                streetController.value.text = addressParts.join(", ");
              }

              // Optional: Call multigst as per existing code
              await ApiHandler.postRequest(
                url: "https://services.cygnux.in/api/multigst",
                body: {"api_key": "f1af2edece05bbd40a8f98002286446e", "user_id": 17, "pan": gstNo.substring(2, 12)},
                headers: {'Content-Type': 'application/json', 'Accept': '*/*', "Authorization": "Bearer $token"},
              );
            }
          }
        }
      } else if (data['success'] == true && data['data'] == true) {
        toastMessage(text: "GST Number already exists", color: AppColors.redColor, isTop: false);
      }
    } catch (e) {
      debugPrint("Error in getGst: $e");
    } finally {
      GlobalLoader.hide();
    }
  }

  Future<void> getCityApi({required int page, String? search, String? stateId, bool fromPagination = true}) async {
    isCityLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.city}?search=${search ?? ""}&page=$page&limit=50&state_id=${stateId ?? ""}");

      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          if (!fromPagination) {
            cityList.clear();
          }
          City city = City.fromJson(json.decode(response.data));
          cityTotalCount.value = city.pagination.totalRecords;
          cityList.addAll(city.data);
          isCityLoading.value = false;
        } else {
          isCityLoading.value = false;
        }
      }
    } catch (e) {
      isCityLoading.value = false;
    }
  }

  Future<void> getAddAddressCityApi({required int page, String? search, String? stateId, bool fromPagination = true}) async {
    isAddAddressCityLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.city}?search=${search ?? ""}&page=$page&limit=50&state_id=${stateId ?? ""}");

      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          if (!fromPagination) {
            addAddressCityList.clear();
          }
          City city = City.fromJson(json.decode(response.data));
          addAddressCityTotalCount.value = city.pagination.totalRecords;
          addAddressCityList.addAll(city.data);
          isAddAddressCityLoading.value = false;
        } else {
          isAddAddressCityLoading.value = false;
        }
      }
    } catch (e) {
      isAddAddressCityLoading.value = false;
    }
  }

  Future<void> getPriceType() async {
    var response = await ApiHandler.getRequest(ApiEndPoint.priceType);
    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        InquirySourceModel leadSourceModel = InquirySourceModel.fromJson(json.decode(response.data));
        priceTypeList.assignAll(leadSourceModel.inquirySourceDatum.first.leadSourceItems);
        if (priceTypeList.isNotEmpty && selectedPriceType.value == null) {
          selectedPriceType.value = priceTypeList.first;
        }
      }
    }
  }

  Future<void> getAddressType() async {
    try {
      var response = await ApiHandler.getRequest(ApiEndPoint.addressType);
      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          InquirySourceModel leadSourceModel = InquirySourceModel.fromJson(json.decode(response.data));
          if (leadSourceModel.inquirySourceDatum.isNotEmpty) {
            addressTypeList.assignAll(leadSourceModel.inquirySourceDatum.first.leadSourceItems);

            // Auto-select first item if none selected
            if (selectedAddressType.value == null && addressTypeList.isNotEmpty) {
              selectedAddressType.value = addressTypeList.first;
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching address types: $e");
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

          isPinCodeLoading.value = false;
        } else {
          isPinCodeLoading.value = false;
        }
      }
    } catch (e) {
      isPinCodeLoading.value = false;
    }
  }

  Future<void> getAddAddressPinCodeApi({required int page, String? search, String? cityId, bool fromPagination = true}) async {
    isAddAddressPinCodeLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.pinCode}?search=${search ?? ""}&page=$page&limit=50&city_id=${cityId ?? ""}");

      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['success'] == true) {
          if (!fromPagination) {
            addAddressPinCodeList.clear();
            addAddressPinCodeTotalCount.value = 0;
          }
          PinCode pinCode = pinCodeFromJson(response.data);

          addAddressPinCodeList.addAll(pinCode.data);
          addAddressPinCodeTotalCount.value = pinCode.pagination.totalRecords;

          isAddAddressPinCodeLoading.value = false;
        } else {
          isAddAddressPinCodeLoading.value = false;
        }
      }
    } catch (e) {
      isAddAddressPinCodeLoading.value = false;
    }
  }

  Future<void> deleteLeadApi({required String id}) async {
    final response = await ApiHandler.deleteRequest("${ApiEndPoint.deleteLead}$id");

    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   ${data['message']}");
        leadList.clear();
        getLeadListApi(page: pageCount.value, search: searchController.value.text, fromPagination: false);
        Get.back();
      }
    }
  }

  Future<void> getLeadListApi({bool isLoading = true, bool fromPagination = true, required int page, String? search}) async {
    if (isLoading) {
      isLeadDataLoading.value = true;
    }
    try {
      final response = await ApiHandler.getRequest(
        "${ApiEndPoint.leadList}?search=${search ?? ""}&page=$page&limit=100&sortByCompanyName=false&exportData=false&type=inquiry&filterGroups=%5B%7B%22logic%22:%22AND%22,%22conditions%22:%5B%7B%22field%22:%22is_customer%22,%22operator%22:%22eq%22,%22value%22:false%7D%5D%7D%5D",
      );
      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          if (!fromPagination) {
            leadList.clear();
          }
          LeadListResponseModel leadListResponseModel = LeadListResponseModel.fromJson(json.decode(response.data));
          totalCount.value = leadListResponseModel.pagination!.totalRecords!;
          leadList.addAll(leadListResponseModel.data!);
          if (isLoading) {
            isLeadDataLoading.value = false;
          }
        } else {
          if (isLoading) {
            isLeadDataLoading.value = false;
          }
        }
      }
    } catch (e) {
      if (isLoading) {
        isLeadDataLoading.value = false;
      }
    }
  }

  Future<void> getInquiryView({required String id, bool isFromEdit = false}) async {
    if (isFromEdit) {
      isLeadEditLoading.value = true;
    } else {
      isLeadViewLoading.value = true;
    }
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.inquiryView}$id");
      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          InquiryViewResponse leadViewResponse = InquiryViewResponse.fromJson(json.decode(response.data));
          leadViewData.value = leadViewResponse.data;
          debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   ${leadViewResponse.data}");
          leadTagController.clearAll();
          selectedGstTreatmentType.value = leadViewData.value!.gstCategory;

          if (leadViewData.value!.gstNumber is List && (leadViewData.value!.gstNumber as List).isNotEmpty) {
            gstInController.value.text = (leadViewData.value!.gstNumber as List).first.toString();
          } else if (leadViewData.value!.gstNumber is String) {
            gstInController.value.text = leadViewData.value!.gstNumber;
          } else {
            gstInController.value.text = "";
          }

          panNumberController.value.text = leadViewData.value!.pan ?? "";

          nameController.value.text = leadViewData.value!.contactName ?? "";
          companyNameController.value.text = leadViewData.value!.companyName ?? "";
          emailIdController.value.text = leadViewData.value!.email ?? "";
          mobileNumberController.value.text = leadViewData.value!.mobile1 ?? "";
          mobileNumberCountryCodeController.value.text = leadViewData.value!.mobile1CountryCode ?? "+91";
          phoneNumberCountryCodeController.value.text = leadViewData.value!.mobile2CountryCode ?? "+91";
          phoneNumberController.value.text = leadViewData.value!.mobile2 ?? "";
          landlineNumberController.value.text = leadViewData.value!.landline ?? "";

          selectedLeadSourceItemType.value = leadViewData.value!.sourceId != null
              ? LeadSourceItem(id: leadViewData.value!.sourceId!, name: leadViewData.value!.sourceName ?? "")
              : null;

          webSiteController.value.text = leadViewData.value!.website ?? "";
          streetController.value.text = leadViewData.value!.address ?? "";
          projectNameController.value.text = leadViewData.value!.projectName ?? "";

          selectedCustomerGroupType.value = leadViewData.value!.customerGroupId != null
              ? CustomerGroupDatum(id: leadViewData.value!.customerGroupId!, name: leadViewData.value!.customerGroupName ?? "")
              : null;

          selectedCustomerBrandType.value = leadViewData.value!.customerBrandId != null
              ? CustomerGroupDatum(id: leadViewData.value!.customerBrandId!, name: leadViewData.value!.customerBrandName ?? "")
              : null;

          selectedCountry.value = leadViewData.value!.countryId != null
              ? CountryDatum(id: leadViewData.value!.countryId!, name: leadViewData.value!.countryName ?? "")
              : null;

          countryController.value.text = leadViewData.value!.countryName ?? "";
          stateController.value.text = leadViewData.value!.stateName ?? "";
          cityController.value.text = leadViewData.value!.cityName ?? "";
          pinCodeNumberController.value.text = leadViewData.value!.pincodeName ?? "";

          if (leadViewData.value!.stateId != null) {
            selectedState.value = StateDatum(
              id: leadViewData.value!.stateId!,
              name: leadViewData.value!.stateName ?? "",
              countryId: CountryId(id: leadViewData.value!.countryId ?? "", name: leadViewData.value!.countryName ?? ""),
            );
          }

          if (leadViewData.value!.cityId != null) {
            selectedCity.value = CityDatum(
              id: leadViewData.value!.cityId!,
              name: leadViewData.value!.cityName ?? "",
              stateId: StateId(id: leadViewData.value!.stateId ?? "", name: leadViewData.value!.stateName ?? ""),
              countryId: StateId(id: leadViewData.value!.countryId ?? "", name: leadViewData.value!.countryName ?? ""),
            );
          }

          if (leadViewData.value!.pincodeId != null) {
            selectedPinCode.value = PinCodeDatum(
              id: leadViewData.value!.pincodeId!,
              pinCode: leadViewData.value!.pincodeName ?? "",
              cityId: Id(id: leadViewData.value!.cityId ?? "", name: leadViewData.value!.cityName ?? ""),
              stateId: Id(id: leadViewData.value!.stateId ?? "", name: leadViewData.value!.stateName ?? ""),
              countryId: Id(id: leadViewData.value!.countryId ?? "", name: leadViewData.value!.countryName ?? ""),
            );
          }

          selectedPriceType.value = getPriceTypeItem(leadViewData.value!.defaultPriceType ?? "");
          remarksController.value.text = leadViewData.value!.remarks ?? "";

          final List<String> tagsList = leadViewData.value!.tags ?? [];
          selectedLeadTagsType.assignAll(leadTagsTypeList.where((item) => tagsList.contains(item.id)).toList());
          debugPrint("selectedLeadTagsType === $selectedLeadTagsType");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            leadTagController.selectWhere((dropdownItem) {
              return selectedLeadTagsType.map((e) => e.id).contains(dropdownItem.value.id);
            });
          });
          addAddressList.assignAll(
            (leadViewData.value!.addresses ?? [])
                .map(
                  (lead) => AddAddressModel(
                    type: LeadSourceItem(id: lead.addressTypeId ?? lead.type ?? "", name: lead.addressTypeName ?? ""),
                    contactName: lead.contactName ?? "",
                    companyName: lead.companyName?.toString() ?? "",
                    designation: lead.designation?.toString() ?? "",
                    email: lead.email?.toString() ?? "",
                    mobile1: lead.mobile1 ?? "",
                    mobile2: lead.mobile2?.toString() ?? "",
                    street: lead.street ?? "",
                    cityId: CityDatum(
                      id: lead.cityId ?? "",
                      name: lead.cityName ?? "",
                      stateId: StateId(id: lead.stateId ?? "", name: lead.stateName ?? ""),
                      countryId: StateId(id: lead.countryId ?? "", name: ""),
                    ),
                    stateId: StateDatum(
                      id: lead.stateId ?? "",
                      name: lead.stateName ?? "",
                      countryId: CountryId(id: lead.countryId ?? "", name: ""),
                    ),
                    pincodeId: PinCodeDatum(
                      id: lead.pincodeId ?? "",
                      pinCode: lead.pincodeName ?? "",
                      cityId: Id(id: lead.cityId ?? "", name: lead.cityName ?? ""),
                      stateId: Id(id: lead.stateId ?? "", name: lead.stateName ?? ""),
                      countryId: Id(id: lead.countryId ?? "", name: ""),
                    ),
                    countryId: CountryDatum(id: lead.countryId ?? "", name: ""),
                    remarks: lead.remarks?.toString() ?? "",
                    isActive: lead.isActive ?? true,
                  ),
                )
                .toList(),
          );
          if (isFromEdit) {
            isLeadEditLoading.value = false;
          } else {
            isLeadViewLoading.value = false;
          }
        } else {
          if (isFromEdit) {
            isLeadEditLoading.value = false;
          } else {
            isLeadViewLoading.value = false;
          }
        }
      }
    } catch (e) {
      if (isFromEdit) {
        isLeadEditLoading.value = false;
      } else {
        isLeadViewLoading.value = false;
      }
    }
  }

  LeadSourceItem getPriceTypeItem(String value) {
    try {
      return priceTypeList.firstWhere(
        (e) => e.id == value,
        orElse: () {
          return priceTypeList.firstWhere(
            (e) => e.name == value,
            orElse: () => LeadSourceItem(id: value, name: value),
          );
        },
      );
    } catch (e) {
      return LeadSourceItem(id: value, name: value);
    }
  }

  Future<void> getCustomerGroup() async {
    final response = await ApiHandler.getRequest("${ApiEndPoint.getCustomerGroup}?page=1&limit=200&level=0&include_inactive=true&exportData=false");
    final data = json.decode(response.data);
    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        CustomerGroupResponseModel customerGroupResponseModel = CustomerGroupResponseModel.fromJson(json.decode(response.data));
        customerGroupDataList.addAll(customerGroupResponseModel.customerGroupData);
        debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   ${customerGroupResponseModel.customerGroupData}");
      }
    }
  }

  Future<void> getCustomerBrand() async {
    final response = await ApiHandler.getRequest("${ApiEndPoint.getCustomerGroup}?page=1&limit=200&level=1&include_inactive=true&exportData=false");
    final data = json.decode(response.data);
    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        CustomerGroupResponseModel customerGroupResponseModel = CustomerGroupResponseModel.fromJson(json.decode(response.data));
        customerBrandDataList.addAll(customerGroupResponseModel.customerGroupData);

        debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   ${customerGroupResponseModel.customerGroupData}");
      }
    }
  }

  String getCurrentFinancialYear() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;

    if (month >= 4) {
      return "$year-${(year + 1).toString().substring(2)}";
    } else {
      return "${year - 1}-${year.toString().substring(2)}";
    }
  }

  Future<void> leadSubmit() async {
    isLoading.value = true;
    // try {
    var data111 = InquirySubmitRequestModel(
      isCustomer: false,
      contactName: nameController.value.text,
      address: streetController.value.text,
      gstCategory: "",
      taxPayerType: "",
      stateId: selectedState.value?.id ?? "",
      cityId: selectedCity.value?.id ?? "",
      countryId: selectedCountry.value?.id ?? "",
      pincodeId: selectedPinCode.value?.id ?? "",
      gstNumber: gstInController.value.text.isEmpty ? [] : [gstInController.value.text],
      pan: panNumberController.value.text,
      personName: "",
      jobPosition: "",
      mobile1CountryCode: mobileNumberCountryCodeController.value.text,
      mobile2CountryCode: phoneNumberCountryCodeController.value.text,
      mobile1: splitCountryCodeFromMobile(
        countryCodeController: mobileNumberCountryCodeController.value,
        mobileController: mobileNumberController.value,
      ),
      mobile2: splitCountryCodeFromMobile(
        countryCodeController: phoneNumberCountryCodeController.value,
        mobileController: phoneNumberController.value,
      ),
      landline: landlineNumberController.value.text,
      email: emailIdController.value.text,
      website: webSiteController.value.text,
      defaultPriceType: selectedPriceType.value?.id ?? "",
      leadDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      sourceId: selectedLeadSourceItemType.value!.id,
      remarks: remarksController.value.text,
      tags: selectedLeadTagsType.map((e) => e.id).toList(),
      projectName: projectNameController.value.text,
      companyName: companyNameController.value.text,
      customerGroupId: selectedCustomerGroupType.value?.id ?? "",
      customerBrandId: selectedCustomerBrandType.value?.id ?? "",
      locationId: Pref.getLocationId(),
      companyId: Pref.getCompanyId(),
      finYear: Pref.getFinancialYears(),
      addresses: addAddressList.isEmpty
          ? []
          : [
              for (var data in addAddressList)
                Address(
                  type: data.type.id,
                  contactName: data.contactName,
                  companyName: data.companyName,
                  email: data.email,
                  mobile1: data.mobile1,
                  mobile2: data.mobile2,
                  street: data.street,
                  cityId: data.cityId.id,
                  stateId: data.stateId.id,
                  pincodeId: data.pincodeId.id,
                  remarks: data.remarks,
                  isActive: data.isActive,
                  designation: data.designation,
                  countryId: data.countryId.id,
                ),
            ],
    );
    logger.i(JsonEncoder.withIndent(" " * 4).convert(data111.toJson()));
    var response = await ApiHandler.postTokenRequest(url: ApiEndPoint.leadSubmit, body: leadSubmitRequestModelToJson(data111));
    final data = response.data;
    if (response.statusCode == 201) {
      debugPrint("");
      if (data["status"] == 201) {
        isLoading.value = false;
        getLeadListApi(page: pageCount.value, search: searchController.value.text, fromPagination: false);
        Get.back();
        toastMessage(text: "Add Lead Successfully", color: AppColors.greenColor, isTop: false);
      } else {
        isLoading.value = false;
        toastMessage(text: response.statusMessage, color: AppColors.redColor, isTop: false);
        debugPrint("not done ${response.statusCode}");
      }
    } else {
      isLoading.value = false;
      toastMessage(text: response.statusMessage, color: AppColors.redColor, isTop: false);
      debugPrint("not done ${response.statusCode}");
    }
    isLoading.value = false;
    // } catch (e) {
    //   isLoading.value = false;
    //   toastMessage(text: "Something went wrong!", color: AppColors.redColor, isTop: false);
    // }
  }

  Future<void> leadUpdate({required String id}) async {
    isLoading.value = true;
    try {
      var response = await ApiHandler.patchTokenRequest(
        url: "${ApiEndPoint.editLead}$id",
        body: leadSubmitRequestModelToJson(
          InquirySubmitRequestModel(
            isCustomer: false,
            contactName: nameController.value.text,
            address: streetController.value.text,
            gstCategory: selectedGstTreatmentType.value ?? "",
            taxPayerType: selectedGstTreatmentType.value ?? "",
            stateId: selectedState.value?.id ?? "",
            cityId: selectedCity.value?.id ?? "",
            countryId: selectedCountry.value?.id ?? "",
            pincodeId: selectedPinCode.value?.id ?? "",
            gstNumber: gstInController.value.text.isEmpty ? [] : [gstInController.value.text],
            pan: panNumberController.value.text,
            personName: "",
            jobPosition: "",
            mobile1CountryCode: mobileNumberCountryCodeController.value.text,
            mobile2CountryCode: phoneNumberCountryCodeController.value.text,
            mobile1: splitCountryCodeFromMobile(
              countryCodeController: mobileNumberCountryCodeController.value,
              mobileController: mobileNumberController.value,
            ),
            mobile2: splitCountryCodeFromMobile(
              countryCodeController: phoneNumberCountryCodeController.value,
              mobileController: phoneNumberController.value,
            ),
            landline: landlineNumberController.value.text,
            email: emailIdController.value.text,
            website: webSiteController.value.text,
            defaultPriceType: selectedPriceType.value?.id ?? "",
            leadDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
            sourceId: selectedLeadSourceItemType.value!.id,
            remarks: remarksController.value.text,
            tags: selectedLeadTagsType.map((e) => e.id).toList(),
            projectName: projectNameController.value.text,
            companyName: companyNameController.value.text,
            customerGroupId: selectedCustomerGroupType.value?.id ?? "",
            customerBrandId: selectedCustomerBrandType.value?.id ?? "",
            locationId: Pref.getLocationId(),
            companyId: Pref.getCompanyId(),
            finYear: Pref.getFinancialYears(),
            addresses: addAddressList.isEmpty
                ? []
                : [
                    for (var data in addAddressList)
                      Address(
                        type: data.type.id,
                        contactName: data.contactName,
                        companyName: data.companyName,
                        email: data.email,
                        mobile1: data.mobile1,
                        mobile2: data.mobile2,
                        street: data.street,
                        cityId: data.cityId.id,
                        stateId: data.stateId.id,
                        pincodeId: data.pincodeId.id,
                        remarks: data.remarks,
                        isActive: data.isActive,
                        designation: data.designation,
                        countryId: data.countryId.id,
                      ),
                  ],
          ),
        ),
      );
      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data["status"] == 200) {
          pageCount.value = 1;
          Get.back();
          await getLeadListApi(page: pageCount.value, search: searchController.value.text, fromPagination: false, isLoading: true);
          isLoading.value = false;
          toastMessage(text: "Lead Update Successfully", color: AppColors.greenColor, isTop: false);
        } else {
          isLoading.value = false;
          toastMessage(text: response.statusMessage, color: AppColors.redColor, isTop: false);
          debugPrint("not done ${response.statusCode}");
        }
      } else {
        isLoading.value = false;
        toastMessage(text: response.statusMessage, color: AppColors.redColor, isTop: false);
        debugPrint("not done ${response.statusCode}");
      }
    } catch (e) {
      isLoading.value = false;
      toastMessage(text: "Something went wrong!", color: AppColors.redColor, isTop: false);
    }
  }

  String splitCountryCodeFromMobile({required TextEditingController countryCodeController, required TextEditingController mobileController}) {
    final countryCode = countryCodeController.text.replaceAll(' ', '').trim();

    String mobile = mobileController.text.replaceAll(RegExp(r'\s|-'), '').trim();
    if (mobile.isEmpty) {
      return "";
    }

    if (countryCode.isNotEmpty && mobile.startsWith(countryCode)) {
      mobile = mobile.substring(countryCode.length);
    }

    mobileController.text = mobile;
    return mobile;
  }
}

class GlobalLoader {
  static bool _isShowing = false;

  static void show() {
    if (_isShowing) return;

    final context = navigatorKey.currentContext;
    if (context == null) return;

    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      useRootNavigator: true,
      builder: (_) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (v, context) {},
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  static void hide() {
    if (!_isShowing) return;

    _isShowing = false;

    final navigator = navigatorKey.currentState;
    if (navigator?.canPop() == true) {
      navigator!.pop();
    }
  }
}
