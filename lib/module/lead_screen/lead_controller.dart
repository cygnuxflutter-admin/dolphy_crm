import 'dart:convert';
import 'dart:io';

import 'package:crm/config/app_colors.dart';
import 'package:crm/config/app_shared_pref.dart';
import 'package:crm/config/app_url.dart';
import 'package:crm/main.dart';
import 'package:crm/module/lead_screen/model/get_assign_partner.dart';
import 'package:crm/module/lead_screen/model/lead_find_response_model.dart';
import 'package:crm/module/lead_screen/model/lead_model.dart';
import 'package:crm/module/lead_screen/model/lead_overview_model.dart';
import 'package:crm/module/lead_screen/model/lead_section_response.dart';
import 'package:crm/module/lead_screen/model/lead_update_request.dart';
import 'package:crm/module/lead_screen/model/search_suggestion_model.dart';
import 'package:crm/utils/api_handler.dart';
import 'package:crm/widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../inquiry_screen/model/city_model.dart';
import '../inquiry_screen/model/country_model.dart';
import '../inquiry_screen/model/pincode_model.dart';
import '../inquiry_screen/model/state_model.dart';
import 'model/activity_detail_model.dart';
import 'model/contactName_model.dart';
import 'model/contact_person_response_model.dart';
import 'model/lead_list_model.dart';
import 'model/lead_type.dart';
import 'model/opportunity_summary_model.dart';

class LeadController extends GetxController {
  RxInt totalCount = 1.obs;
  RxInt pageCount = 1.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxInt salesPersonTotalCount = 1.obs;
  RxInt salesPersonPageCount = 1.obs;
  RxBool isAssignSalesPersonLoading = false.obs;

  RxInt cityTotalCount = 1.obs;
  RxInt cityPageCount = 1.obs;
  Rx<TextEditingController> citySearchController = TextEditingController().obs;

  RxInt pinCodeTotalCount = 1.obs;
  RxInt pinCodePageCount = 1.obs;
  Rx<TextEditingController> pinCodeSearchController = TextEditingController().obs;

  RxInt productTotalCount = 1.obs;
  RxInt productPageCount = 1.obs;

  RxInt interestProductTotalCount = 1.obs;
  RxInt interestProductPageCount = 1.obs;
  RxBool isInterestProductLoading = false.obs;

  RxInt customerTotalCount = 1.obs;
  RxInt customerPageCount = 1.obs;
  RxBool isCustomerLoading = false.obs;

  Rx<TextEditingController> assignSalesPartnerSearchController = TextEditingController().obs;
  Rx<AssignSalesPerson?> selectedAssignSalesPerson = Rx<AssignSalesPerson?>(null);

  Rx<TextEditingController> leadNameController = TextEditingController().obs;
  Rx<TextEditingController> companyNameController = TextEditingController().obs;
  // Rx<TextEditingController> oppProductNameController = TextEditingController().obs;
  Rx<TextEditingController> interestProductController = TextEditingController().obs;
  Rx<TextEditingController> leadProductSearchController = TextEditingController().obs;
  Rx<TextEditingController> leadContactNameController = TextEditingController().obs;
  Rx<TextEditingController> customerSearchController = TextEditingController().obs;

  Rx<TextEditingController> mobileNumberCountryCodeController = TextEditingController(text: "+91").obs;
  Rx<TextEditingController> secondMobileNumberCountryCodeController = TextEditingController(text: "+91").obs;
  Rx<TextEditingController> secondMobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> stateController = TextEditingController().obs;
  Rx<TextEditingController> stateIdController = TextEditingController().obs;
  Rx<TextEditingController> cityController = TextEditingController().obs;
  Rx<TextEditingController> cityIdController = TextEditingController().obs;
  Rx<TextEditingController> pinCodeController = TextEditingController().obs;
  Rx<TextEditingController> pinCodeIdController = TextEditingController().obs;
  Rx<TextEditingController> countryController = TextEditingController().obs;
  Rx<TextEditingController> countrySearchController = TextEditingController().obs;
  Rx<TextEditingController> stateSearchController = TextEditingController().obs;

  Rx<TextEditingController> cpCitySearchController = TextEditingController().obs;
  Rx<TextEditingController> cpPinCodeSearchController = TextEditingController().obs;
  Rx<TextEditingController> cpCountrySearchController = TextEditingController().obs;
  Rx<TextEditingController> cpStateSearchController = TextEditingController().obs;

  RxBool isCityLoading = false.obs;
  RxBool isPinCodeLoading = false.obs;

  RxList<CountryDatum> countryList = <CountryDatum>[].obs;
  Rx<CountryDatum?> selectedCountry = Rx<CountryDatum?>(null);

  RxList<StateDatum> stateList = <StateDatum>[].obs;
  Rx<StateDatum?> selectedState = Rx<StateDatum?>(null);

  RxList<CityDatum> cityList = <CityDatum>[].obs;
  Rx<CityDatum?> selectedCity = Rx<CityDatum?>(null);

  RxList<PinCodeDatum> pinCodeList = <PinCodeDatum>[].obs;
  Rx<PinCodeDatum?> selectedPinCode = Rx<PinCodeDatum?>(null);

  Rx<TextEditingController> expectedRevenueController = TextEditingController().obs;

  // Rx<TextEditingController> probabilityController = TextEditingController().obs;
  Rx<TextEditingController> remarksController = TextEditingController().obs;
  Rx<TextEditingController> interestController = TextEditingController().obs;
  Rx<TextEditingController> expectedClosingController = TextEditingController().obs;
  Rx<TextEditingController> startController = TextEditingController().obs;
  Rx<TextEditingController> endController = TextEditingController().obs;
  Rx<TextEditingController> followUpDateController = TextEditingController().obs;
  Rx<TextEditingController> reminderTimeController = TextEditingController().obs;
  Rx<TextEditingController> subjectController = TextEditingController().obs;
  Rx<TextEditingController> addNotesController = TextEditingController().obs;
  Rx<TextEditingController> callMediumController = TextEditingController(text: "").obs;
  Rx<TextEditingController> assignSalesPersonController = TextEditingController().obs;
  Rx<TextEditingController> searchAssignSalesPersonController = TextEditingController().obs;

  Rx<TextEditingController> logDetailController = TextEditingController().obs;
  Rx<TextEditingController> reminderDateController = TextEditingController().obs;

  RxList<String> uploadedImageLink = <String>[].obs;
  RxString selectedStatus = "Opportunity".obs;
  RxString phoneType = "Mobile".obs;

  Rx<TextEditingController> opportunityLogDateController = TextEditingController().obs;
  Rx<TextEditingController> opportunityLogDetailsController = TextEditingController().obs;

  RxList<LeadItem> oppTagList = <LeadItem>[].obs;
  RxList<LeadSectionDatum> opportunitySectionList = <LeadSectionDatum>[].obs;
  RxList<LeadItem> oppLabelList = <LeadItem>[].obs;
  RxList<LeadItem> oppProbabilityList = <LeadItem>[].obs;
  RxList<LeadItem> oppSourceList = <LeadItem>[].obs;
  RxList<LeadItem> oppProductCategoryList = <LeadItem>[].obs;

  RxList<LeadTypeDatum> oppActivityTypeList = <LeadTypeDatum>[].obs;
  RxList<LeadItem> oppActivityStatusList = <LeadItem>[].obs;
  RxList<ContactNameDatum> customerNameList = <ContactNameDatum>[].obs;
  RxList<LeadItem> selectedTags = <LeadItem>[].obs;
  RxList<ProductDatum> oppProductList = <ProductDatum>[].obs;
  RxList<ProductDatum> oppInterestProductList = <ProductDatum>[].obs;
  RxList<AssignSalesPerson> assignSalesPersonList = <AssignSalesPerson>[].obs;
  RxList<Activity> activityList = <Activity>[].obs;

  Rx<LeadItem?> selectedLabel = Rx<LeadItem?>(null);
  Rx<LeadItem?> selectedSource = Rx<LeadItem?>(null);
  Rx<LeadItem?> selectedActivityType = Rx<LeadItem?>(null);
  Rx<LeadItem?> selectedActivityStatus = Rx<LeadItem?>(null);
  Rx<LeadItem?> selectedProbability = Rx<LeadItem?>(null);
  Rx<LeadSectionDatum?> selectedOpportunitySection = Rx<LeadSectionDatum?>(null);

  Rx<ContactNameDatum?> selectedContactName = Rx<ContactNameDatum?>(null);
  RxList<ContactPersonDatum> contactPersonList = <ContactPersonDatum>[].obs;
  Rx<ContactPersonDatum?> selectedContactPerson = Rx<ContactPersonDatum?>(null);
  RxBool isContactPersonLoading = false.obs;

  // Contact Person Creation Controllers
  Rx<TextEditingController> cpFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> cpLastNameController = TextEditingController().obs;
  Rx<TextEditingController> cpMobile1Controller = TextEditingController().obs;
  Rx<TextEditingController> cpMobile2Controller = TextEditingController().obs;
  Rx<TextEditingController> cpEmailController = TextEditingController().obs;
  Rx<TextEditingController> cpDesignationController = TextEditingController().obs;
  Rx<TextEditingController> cpAddressController = TextEditingController().obs;
  Rx<TextEditingController> cpInternalNotesController = TextEditingController().obs;
  RxBool cpIsActive = true.obs;

  // Contact Person Location Selection
  Rx<TextEditingController> cpStateController = TextEditingController().obs;
  Rx<TextEditingController> cpStateIdController = TextEditingController().obs;
  Rx<TextEditingController> cpCityController = TextEditingController().obs;
  Rx<TextEditingController> cpCityIdController = TextEditingController().obs;
  Rx<TextEditingController> cpPinCodeController = TextEditingController().obs;
  Rx<TextEditingController> cpPinCodeIdController = TextEditingController().obs;
  Rx<TextEditingController> cpCountryController = TextEditingController().obs;
  Rx<CountryDatum?> cpSelectedCountry = Rx<CountryDatum?>(null);
  Rx<StateDatum?> cpSelectedState = Rx<StateDatum?>(null);
  Rx<CityDatum?> cpSelectedCity = Rx<CityDatum?>(null);
  Rx<PinCodeDatum?> cpSelectedPinCode = Rx<PinCodeDatum?>(null);

  // CP Location Search Lists
  RxList<CountryDatum> cpCountryList = <CountryDatum>[].obs;
  RxList<StateDatum> cpStateList = <StateDatum>[].obs;
  RxList<CityDatum> cpCityList = <CityDatum>[].obs;
  RxList<PinCodeDatum> cpPinCodeList = <PinCodeDatum>[].obs;

  RxBool isCPCityLoading = false.obs;
  RxBool isCPPinCodeLoading = false.obs;

  RxInt cpCityTotalCount = 0.obs;
  RxInt cpCityPageCount = 1.obs;
  RxInt cpPinCodeTotalCount = 0.obs;
  RxInt cpPinCodePageCount = 1.obs;

  // RxList<ProductDatum> selectedProducts = <ProductDatum>[].obs;
  RxList<ProductDatum> selectedInterestProduct = <ProductDatum>[].obs;
  Rx<LeadItem?> selectedProductCategory = Rx<LeadItem?>(null);
  RxList<ProductDatum> filteredProductList = <ProductDatum>[].obs;

  RxList<Log> logsList = <Log>[].obs;

  /// Opportunity view
  Rxn<LeadViewData> leadViewData = Rxn(null);
  Rxn<OpportunityFindData> opportunityFiendData = Rxn(null);

  /// IMPORTANT — Controller MUST NOT be Rx
  MultiSelectController<LeadItem> opportunityTagController = MultiSelectController<LeadItem>();
  MultiSelectController<AssignSalesPerson> followerAndViewerController = MultiSelectController<AssignSalesPerson>();
  RxList<AssignSalesPerson> selectedFollowerAndViewer = <AssignSalesPerson>[].obs;

  RxBool isEnableSource = true.obs;
  RxBool isLogeNote = false.obs;
  RxBool isLoading = false.obs;
  RxBool isActivityCreateLoading = false.obs;
  RxBool isMarkDone = false.obs;
  RxBool isReminderSent = false.obs;
  RxBool isOpportunityDataLoading = false.obs;
  RxBool isOpportunityLoading = false.obs;
  RxBool isOpportunityFiend = false.obs;
  RxBool isAddLogLoading = false.obs;
  RxBool isAddAssignLoading = false.obs;
  RxBool isProductLoading = false.obs;
  RxBool isSummaryLoading = false.obs;
  RxBool isActivityDetailLoading = false.obs;
  Rxn<ActivityDetailData> activityDetailData = Rxn<ActivityDetailData>();

  RxList<OpportunityListDatum> leadList = <OpportunityListDatum>[].obs;
  RxList<OpportunitySummaryItem> opportunitySummaryList = <OpportunitySummaryItem>[].obs;
  Rxn<OpportunityActivitySummary> activitySummary = Rxn<OpportunityActivitySummary>();
  RxInt summaryTotalCount = 0.obs;
  RxInt summaryPageCount = 1.obs;
  RxString selectedActivityFilter = "".obs; // "", "call", "meeting"
  Rx<TextEditingController> activitySearchController = TextEditingController().obs;
  RxList<SuggestionCategory> searchSuggestions = <SuggestionCategory>[].obs;
  RxBool isSearchSuggestionsLoading = false.obs;
  RxString selectedFilterGroups = "".obs;
  bool ignoreSearchSuggestions = false;
  Rxn<SuggestionItem> selectedSearchSuggestion = Rxn<SuggestionItem>();
  RxString selectedSearchCategory = "".obs;

  // Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<File?> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  String formatDateTime(String input) {
    try {
      DateTime dateTime;

      if (input.contains('T')) {
        dateTime = DateTime.parse(input).toLocal();
      } else if (input.contains('-') && input.contains('PM') || input.contains('AM')) {
        dateTime = DateFormat('yyyy-MM-dd hh:mm a').parse(input);
      } else {
        return input;
      }

      return DateFormat('dd MMM yyyy, h:mm a').format(dateTime).toLowerCase();
    } catch (e) {
      return input;
    }
  }

  DateTime? parseDateTime(String input) {
    try {
      if (input.contains('T')) {
        return DateTime.parse(input).toLocal();
      } else if ((input.contains('AM') || input.contains('PM')) && input.contains('-')) {
        return DateFormat('yyyy-MM-dd hh:mm a').parse(input);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  int calculateDurationInMinutes(String startTime, String endTime) {
    try {
      final DateTime? start = parseDateTime(startTime);
      final DateTime? end = parseDateTime(endTime);

      if (start == null || end == null) return 0;
      if (end.isBefore(start)) return 0;

      return end.difference(start).inMinutes;
    } catch (e) {
      debugPrint("Duration parse error: $e");
      return 0;
    }
  }

  void openImagePickerSheet() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  File? img = await pickFromCamera();

                  http.Response response = await ApiHandler.uploadFile(img!);
                  var data = json.decode(response.body);
                  if (response.statusCode == 200 && data['success'] == true) {
                    uploadedImageLink.add(data['data']['url']);
                  } else {
                    toastMessage(text: "Image Upload Failed", color: AppColors.redColor);
                  }
                  uploadedImageLink.refresh();
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  final img = await pickFromGallery();

                  http.Response response = await ApiHandler.uploadFile(img!);
                  var data = json.decode(response.body);
                  if (response.statusCode == 200 && data['success'] == true) {
                    uploadedImageLink.add(data['data']['url']);
                  } else {
                    toastMessage(text: "Image Upload Failed", color: AppColors.redColor);
                  }
                  uploadedImageLink.refresh();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateSelectedProductText() {
    // oppProductNameController.value.text = selectedProductCategory.value?.name ?? "";
    interestProductController.value.text = selectedInterestProduct.map((e) => e.productName).join(", ");
  }

  String dateConverter(String? inputDate) {
    if (inputDate == null || inputDate.isEmpty) return "";

    DateTime parsedDate = DateFormat('d, MMMM, yyyy').parse(inputDate);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  void clearData() {
    leadContactNameController.value.clear();
    leadNameController.value.clear();
    companyNameController.value.clear();
    emailController.value.clear();
    mobileNumberController.value.clear();
    secondMobileNumberController.value.clear();
    stateController.value.clear();
    stateIdController.value.clear();
    cityController.value.clear();
    cityIdController.value.clear();
    pinCodeController.value.clear();
    pinCodeIdController.value.clear();
    countryController.value.clear();
    selectedCountry.value = null;
    selectedState.value = null;
    selectedCity.value = null;
    selectedPinCode.value = null;
    expectedRevenueController.value.clear();
    selectedProbability.value = null;
    remarksController.value.clear();
    interestController.value.clear();
    // selectedProducts.clear();
    selectedInterestProduct.clear();
    interestProductController.value.clear();
    selectedProductCategory.value = null;
    // oppProductNameController.value.clear();
    selectedContactName.value = null;
    contactPersonList.clear();
    selectedContactPerson.value = null;
    selectedSource.value = null;
    selectedAssignSalesPerson.value = null;
    assignSalesPersonController.value.clear();
    selectedTags.clear();
    selectedLabel.value = null;
    expectedClosingController.value.clear();
    phoneType.value = "Mobile";
    logsList.clear();
    activityList.clear();
    opportunityTagController.clearAll();
  }

  void clearCPData() {
    cpFirstNameController.value.clear();
    cpLastNameController.value.clear();
    cpMobile1Controller.value.clear();
    cpMobile2Controller.value.clear();
    cpEmailController.value.clear();
    cpDesignationController.value.clear();
    cpAddressController.value.clear();
    cpInternalNotesController.value.clear();
    cpIsActive.value = true;
    cpStateController.value.clear();
    cpStateIdController.value.clear();
    cpCityController.value.clear();
    cpCityIdController.value.clear();
    cpPinCodeController.value.clear();
    cpPinCodeIdController.value.clear();
    cpCountryController.value.clear();
    cpSelectedCountry.value = null;
    cpSelectedState.value = null;
    cpSelectedCity.value = null;
    cpSelectedPinCode.value = null;
    cpCitySearchController.value.clear();
    cpPinCodeSearchController.value.clear();
    cpCountrySearchController.value.clear();
    cpStateSearchController.value.clear();
    cpCountryList.clear();
    cpStateList.clear();
    cpCityList.clear();
    cpPinCodeList.clear();
    cpCityPageCount.value = 1;
    cpPinCodePageCount.value = 1;
  }

  Future<void> createContactPersonApi({required String customerId}) async {
    isLoading.value = true;
    try {
      final requestBody = {
        "customer_id": customerId,
        "first_name": cpFirstNameController.value.text,
        "last_name": cpLastNameController.value.text,
        "mobile_number": cpMobile1Controller.value.text,
        "mobile_alt": cpMobile2Controller.value.text,
        "email_id": cpEmailController.value.text,
        "designation": cpDesignationController.value.text,
        "address": cpAddressController.value.text,
        "pincode_id": cpPinCodeIdController.value.text,
        "city_id": cpCityIdController.value.text,
        "state_id": cpStateIdController.value.text,
        "country_id": cpSelectedCountry.value?.id ?? "",
        "notes": cpInternalNotesController.value.text,
        "is_active": cpIsActive.value,
      };

      final response = await ApiHandler.postRequest(url: ApiEndPoint.customerContactPersonCreate, body: requestBody);

      if (response.statusCode == 201 || response.statusCode == 200) {
        toastMessage(text: "Contact Person created successfully");
        Get.back();
        getContactPersonApi(customerId: customerId);
      } else {
        toastMessage(text: "Failed to create contact person");
      }
    } catch (e) {
      debugPrint("Create Contact Person Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTags() async {
    var response = await ApiHandler.getRequest(ApiEndPoint.oppTags);
    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        LeadType opportunityType = LeadType.fromJson(data);

        oppTagList.value = opportunityType.data.first.items;

        opportunityTagController.setItems(
          oppTagList.map((item) {
            return DropdownItem(label: item.name, value: item);
          }).toList(),
        );
      }
    }
  }

  Future<void> getOpportunitySection() async {
    var response = await ApiHandler.getRequest(ApiEndPoint.getOpportunitySection);
    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        LeadSectionResponse opportunitySectionData = LeadSectionResponse.fromJson(data);
        opportunitySectionList.value = opportunitySectionData.opportunitySectionData;
      }
    }
  }

  Future<void> updateOpportunitySection({required String id, required String sectionId, required String sectionName}) async {
    isLoading.value = true;
    try {
      var response = await ApiHandler.patchTokenRequest(
        url: "${ApiEndPoint.getOpportunitySectionUpdate}$id",
        body: jsonEncode({"section_id": sectionId, "section_name": sectionName}),
      );

      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          getOpportunityView(id: id);
          toastMessage(text: "Opportunity section updated successfully", color: AppColors.indigo600Main, isTop: false);
        } else {
          debugPrint("not done ${response.statusCode}");
          toastMessage(text: "Something went wrong!", color: AppColors.redColor, isTop: false);
        }
      } else {
        debugPrint("not done ${response.statusCode}");
        toastMessage(text: "Something went wrong!", color: AppColors.redColor, isTop: false);
      }
    } catch (e) {
      isLoading.value = false;
      toastMessage(text: "Something went wrong!", color: AppColors.redColor, isTop: false);
    }
  }

  Future<void> getLabel() async {
    var response = await ApiHandler.getRequest(ApiEndPoint.oppLabel);
    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        LeadType opportunityType = LeadType.fromJson(data);

        oppLabelList.value = opportunityType.data.first.items;
      }
    }
  }

  Future<void> getProbability() async {
    var response = await ApiHandler.getRequest(ApiEndPoint.getProbability);
    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        LeadType opportunityType = LeadType.fromJson(data);

        oppProbabilityList.value = opportunityType.data.first.items;
      }
    }
  }

  Future<void> getActivityType() async {
    var response = await ApiHandler.getRequest(ApiEndPoint.oppActivityType);
    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        LeadType opportunityType = LeadType.fromJson(data);
        oppActivityTypeList.value = opportunityType.data;
      }
    }
  }

  Future<void> getActivityStatus() async {
    var response = await ApiHandler.getRequest(ApiEndPoint.oppActivityStatus);
    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        LeadType opportunityType = LeadType.fromJson(data);

        oppActivityStatusList.value = opportunityType.data.first.items;
      }
    }
  }

  Future<void> getSource() async {
    var response = await ApiHandler.getRequest(ApiEndPoint.oppSource);
    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        LeadType opportunityType = LeadType.fromJson(data);

        oppSourceList.value = opportunityType.data.first.items;
      }
    }
  }

  Future<void> getProductCategory() async {
    var response = await ApiHandler.getRequest(ApiEndPoint.productCategory);
    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        LeadType opportunityType = LeadType.fromJson(data);
        oppProductCategoryList.value = opportunityType.data.first.items;
      }
    }
  }

  Future<void> getContactPersonApi({required String customerId}) async {
    isContactPersonLoading.value = true;
    try {
      var response = await ApiHandler.getRequest("${ApiEndPoint.customerContactPersonList}?customer_id=$customerId");
      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          ContactPersonResponseModel contactPersonResponseModel = ContactPersonResponseModel.fromJson(data);
          contactPersonList.assignAll(contactPersonResponseModel.data);
        }
      }
    } catch (e) {
      debugPrint("Get Contact Person Error: $e");
    } finally {
      isContactPersonLoading.value = false;
    }
  }

  Future<void> getContactName({int page = 1, String? search, bool fromPagination = true}) async {
    isCustomerLoading.value = true;
    var response = await ApiHandler.getRequest(
      "${ApiEndPoint.baseUrl}customer/find?search=${search ?? ""}&page=$page&limit=10&sortByCompanyName=false&exportData=false",
    );
    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        if (!fromPagination) {
          customerNameList.clear();
        }
        ContactNameModel contactNameModel = ContactNameModel.fromJson(json.decode(response.data));
        customerNameList.addAll(contactNameModel.data);
        customerTotalCount.value = contactNameModel.pagination.totalRecords;
      }
    }
    isCustomerLoading.value = false;
  }

  Future<void> getProduct({required int page}) async {
    isProductLoading.value = true;
    var response = await ApiHandler.getRequest("${ApiEndPoint.opportunityProduct}?page=$page&limit=10&exportData=false");
    final data = json.decode(response.data);
    if (response.statusCode == 200 && data['status'] == 200) {
      ProductModel productModel = ProductModel.fromJson(json.decode(response.data));
      productTotalCount.value = productModel.pagination.totalRecords;
      oppProductList.addAll(productModel.data);
      applySearchFilter();
      isProductLoading.value = false;
    } else {
      isProductLoading.value = false;
    }
  }

  Future<void> getInterestProduct({required int page, String? categoryId, bool fromPagination = true}) async {
    isInterestProductLoading.value = true;
    var response = await ApiHandler.getRequest(
      "${ApiEndPoint.opportunityProduct}?product_category_id=${categoryId ?? ""}&page=$page&limit=50&exportData=false",
    );
    final data = json.decode(response.data);
    if (response.statusCode == 200 && data['status'] == 200) {
      if (!fromPagination) {
        oppInterestProductList.clear();
      }
      ProductModel productModel = ProductModel.fromJson(json.decode(response.data));
      interestProductTotalCount.value = productModel.pagination.totalRecords;
      oppInterestProductList.addAll(productModel.data);
      isInterestProductLoading.value = false;
    } else {
      isInterestProductLoading.value = false;
    }
  }

  void applySearchFilter() {
    final searchText = leadProductSearchController.value.text.trim().toLowerCase();

    if (searchText.isEmpty) {
      filteredProductList.assignAll(oppProductList);
    } else {
      filteredProductList.assignAll(
        oppProductList.where(
          (item) =>
              item.productName.toLowerCase().contains(searchText) ||
              item.productCode.toLowerCase().contains(searchText) ||
              item.hsnDetails.hsnCode.toLowerCase().contains(searchText),
        ),
      );
    }
  }

  Future<void> getAssignSalesPerson({int page = 1, String? search, bool fromPagination = true}) async {
    isAssignSalesPersonLoading.value = true;
    var response = await ApiHandler.getRequest("${ApiEndPoint.assignSalesPerson}?page=$page&limit=50&search=${search ?? ""}");
    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        if (!fromPagination) {
          assignSalesPersonList.clear();
        }
        GetAssignSalesPersonResponseModel getAssignPartnerResponseModel = getAssignPartnerResponseModelFromJson(response.data);

        if (getAssignPartnerResponseModel.success == true) {
          assignSalesPersonList.value = getAssignPartnerResponseModel.data!;
          salesPersonTotalCount.value = getAssignPartnerResponseModel.pagination!.totalRecords!;
        }
      }
      isAssignSalesPersonLoading.value = false;
    } else {
      isAssignSalesPersonLoading.value = false;
    }
  }

  Future<void> getCountry({String? search, bool isCP = false}) async {
    var response = await ApiHandler.getRequest("${ApiEndPoint.country}?search=${search ?? ""}");
    final data = json.decode(response.data);
    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        CountryResponseModel countryResponseModel = CountryResponseModel.fromJson(json.decode(response.data));
        if (isCP) {
          cpCountryList.assignAll(countryResponseModel.countryData);
        } else {
          countryList.assignAll(countryResponseModel.countryData);
        }
      }
    }
  }

  Future<void> getStateApi({String? search, String? countryId, bool isCP = false}) async {
    final response = await ApiHandler.getRequest("${ApiEndPoint.state}?search=${search ?? ""}&country_id=${countryId ?? ""}");

    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        States state = States.fromJson(json.decode(response.data));
        if (isCP) {
          cpStateList.assignAll(state.data);
        } else {
          stateList.assignAll(state.data);
        }
      }
    }
  }

  Future<void> getCityApi({required int page, String? search, String? stateId, bool fromPagination = true, bool isCP = false}) async {
    if (isCP) {
      isCPCityLoading.value = true;
    } else {
      isCityLoading.value = true;
    }
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.city}?search=${search ?? ""}&page=$page&limit=50&state_id=${stateId ?? ""}");

      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          if (!fromPagination) {
            if (isCP) {
              cpCityList.clear();
            } else {
              cityList.clear();
            }
          }
          City city = City.fromJson(json.decode(response.data));
          if (isCP) {
            cpCityTotalCount.value = city.pagination.totalRecords;
            cpCityList.addAll(city.data);
            isCPCityLoading.value = false;
          } else {
            cityTotalCount.value = city.pagination.totalRecords;
            cityList.addAll(city.data);
            isCityLoading.value = false;
          }
        } else {
          if (isCP) {
            isCPCityLoading.value = false;
          } else {
            isCityLoading.value = false;
          }
        }
      }
    } catch (e) {
      if (isCP) {
        isCPCityLoading.value = false;
      } else {
        isCityLoading.value = false;
      }
    }
  }

  Future<void> getPinCodeApi({required int page, String? search, String? cityId, bool fromPagination = true, bool isCP = false}) async {
    if (isCP) {
      isCPPinCodeLoading.value = true;
    } else {
      isPinCodeLoading.value = true;
    }
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.pinCode}?search=${search ?? ""}&page=$page&limit=50&city_id=${cityId ?? ""}");

      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['success'] == true) {
          if (!fromPagination) {
            if (isCP) {
              cpPinCodeList.clear();
              cpPinCodeTotalCount.value = 0;
            } else {
              pinCodeList.clear();
              pinCodeTotalCount.value = 0;
            }
          }
          PinCode pinCode = pinCodeFromJson(response.data);

          if (isCP) {
            cpPinCodeList.addAll(pinCode.data);
            cpPinCodeTotalCount.value = pinCode.pagination.totalRecords;
            isCPPinCodeLoading.value = false;
          } else {
            pinCodeList.addAll(pinCode.data);
            pinCodeTotalCount.value = pinCode.pagination.totalRecords;
            isPinCodeLoading.value = false;
          }
        } else {
          if (isCP) {
            isCPPinCodeLoading.value = false;
          } else {
            isPinCodeLoading.value = false;
          }
        }
      }
    } catch (e) {
      if (isCP) {
        isCPPinCodeLoading.value = false;
      } else {
        isPinCodeLoading.value = false;
      }
    }
  }

  Future<void> opportunitySave({
    required bool loading,
    required String opportunityName,
    required List<String> productId,
    required String customerId,
    required String sourceId,
    required int expectedAmount,
    required String expectedClosingDate,
    required String remarks,
    required RxList<Log> logList,
    required RxList<Activity> activityList,
    required String probability,
    required String email,
    required String mobile1,
    required String mobile2,
    required String cityId,
    required String pinCodeId,
    required String stateId,
    required String labelId,
    required String salesPersonId,
    required List<String> tags,
    required List<String> secondarySalesPersonId,
    required String interest,
    required List<String> productCategory,
  }) async {
    if (loading) {
      isLoading.value = true;
    }

    String cleanMobile1 = splitCountryCodeFromMobile(
      countryCodeController: mobileNumberCountryCodeController.value,
      mobileController: mobileNumberController.value,
    );
    String cleanMobile2 = splitCountryCodeFromMobile(
      countryCodeController: secondMobileNumberCountryCodeController.value,
      mobileController: secondMobileNumberController.value,
    );

    final requestBody = {
      "opportunity_name": opportunityName,
      "product_ids": productId,
      "customer_id": customerId,
      "expected_amount": expectedAmount,
      "probability_id": probability,
      "email": email,
      "mobile1": cleanMobile1,
      "mobile2": cleanMobile2,
      "landline": phoneType.value == "Landline" ? cleanMobile1 : "",
      "mobile1_country_code": mobileNumberCountryCodeController.value.text,
      "mobile2_country_code": secondMobileNumberCountryCodeController.value.text,
      "city_id": cityId,
      "pincode_id": pinCodeId,
      "state_id": stateId,
      "source_id": sourceId,
      "label_id": labelId,
      "sales_person_id": salesPersonId,
      "secondary_sales_person_ids": secondarySalesPersonId,
      "isMobile": phoneType.value == "Mobile",
      "expected_closing_date": expectedClosingDate,
      "tags": tags,
      "logs": logList,
      "activities": activityList,
      "interest": interest,
      "is_bulk_requirement": false,
      "remarks": remarks,
      "contact_person_id": selectedContactPerson.value?.id ?? "",
      "product_category": productCategory,
      "location_id": Pref.getLocationId(),
      "company_id": Pref.getCompanyId(),
      "fin_year": Pref.getFinancialYears(),
    };

    logger.i(JsonEncoder.withIndent(" " * 4).convert(requestBody));

    final response = await ApiHandler.postRequest(url: ApiEndPoint.opportunitySave, body: requestBody);

    if (response.statusCode == 201) {
      isLoading.value = false;
      pageCount.value = 1;
      getLeadListApi(page: pageCount.value, search: searchController.value.text);
      Get.back();
      toastMessage(text: "Opportunity Added Successfully");
    } else {
      isLoading.value = false;
      toastMessage(text: "Something went wrong");
    }
  }

  Future<void> activityCreate({
    required String opportunityId,
    required String activityStatusId,
    required String activityTypeId,
    required String callMedium,
    required String subject,
    required String description,
    required String startTime,
    required String endTime,
    required String reminderTime,
    required String followUpDate,
    required String invitationStatus,
    required bool isReminderSent,
  }) async {
    isActivityCreateLoading.value = true;
    final requestBody = {
      "opportunity_id": opportunityId,
      "activity_status_id": activityStatusId,
      "activity_type_id": activityTypeId,
      "call_medium": callMedium,
      "description": description,
      "start_time": startTime /*DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateFormat('yyyy-MM-dd hh:mm a').parse(startTime).toUtc())*/,
      "end_time": endTime /* DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateFormat('yyyy-MM-dd hh:mm a').parse(endTime).toUtc())*/,
      "follow_up_date": followUpDate.isEmpty ? null : followUpDate,
      "reminder_time": reminderTime.isEmpty ? null : reminderTime,
      "invitation_status": invitationStatus,
      "is_reminder_sent": isReminderSent,
      "subject": subject,
    };

    final response = await ApiHandler.postRequest(url: ApiEndPoint.activityCreate, body: requestBody);

    if (response.statusCode == 201) {
      toastMessage(text: "Activity created Successfully");
      Get.back();
      isActivityCreateLoading.value = false;
    } else {
      isActivityCreateLoading.value = false;
      toastMessage(text: "Something went wrong");
    }
  }

  Future<void> getLeadListApi({bool isLoading = true, required int page, String? search}) async {
    if (isLoading) {
      isOpportunityDataLoading.value = true;
    }
    try {
      final response = await ApiHandler.getRequest(
        "${ApiEndPoint.opportunityList}?search=${search ?? ""}&page=$page&limit=10&exportData=false&location_id=${Pref.getLocationId()}&company_id=${Pref.getCompanyId()}",
      );
      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          leadList.clear();
          LeadListResponseModel opportunityListResponseModel = LeadListResponseModel.fromJson(json.decode(response.data));
          leadList.addAll(opportunityListResponseModel.leadListData);
          totalCount.value = opportunityListResponseModel.pagination!.totalRecords;
          if (isLoading) {
            isOpportunityDataLoading.value = false;
          }
        } else {
          if (isLoading) {
            isOpportunityDataLoading.value = false;
          }
        }
      }
    } catch (e) {
      if (isLoading) {
        isOpportunityDataLoading.value = false;
      }
    }
  }

  Future<void> getOpportunityView({required String id}) async {
    isOpportunityLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.opportunityOverview}$id");
      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          leadViewData.value = null;
          LeadViewResponseModel opportunityViewResponseModel = LeadViewResponseModel.fromJson(json.decode(response.data));
          leadViewData.value = opportunityViewResponseModel.leadViewData;
          selectedOpportunitySection.value = opportunitySectionList.firstWhereOrNull(
            (element) => element.id == leadViewData.value!.opportunity.sectionId,
          );
          isOpportunityLoading.value = false;
        } else {
          isOpportunityLoading.value = false;
        }
      }
    } catch (e) {
      isOpportunityLoading.value = false;
    }
  }

  Future<void> getLeadDetail({required String id}) async {
    isOpportunityFiend.value = true;
    try {
      debugPrint("Fetching lead detail for ID: $id");
      // Ensure all master data is loaded before populating the edit form
      await Future.wait([
        getProbability().catchError((e) => debugPrint("Error loading probability: $e")),
        getSource().catchError((e) => debugPrint("Error loading source: $e")),
        getLabel().catchError((e) => debugPrint("Error loading label: $e")),
        getTags().catchError((e) => debugPrint("Error loading tags: $e")),
        getAssignSalesPerson(page: 1, fromPagination: false).catchError((e) => debugPrint("Error loading sales persons: $e")),
        getOpportunitySection().catchError((e) => debugPrint("Error loading sections: $e")),
        getProduct(page: 1).catchError((e) => debugPrint("Error loading products: $e")),
        getContactName(page: 1, fromPagination: false).catchError((e) => debugPrint("Error loading contact names: $e")),
        getInterestProduct(page: 1, fromPagination: false).catchError((e) => debugPrint("Error loading interest products: $e")),
        getStateApi().catchError((e) => debugPrint("Error loading states: $e")),
        getCityApi(page: 1, fromPagination: false).catchError((e) => debugPrint("Error loading cities: $e")),
        getPinCodeApi(page: 1, fromPagination: false).catchError((e) => debugPrint("Error loading pin codes: $e")),
        getProductCategory().catchError((e) => debugPrint("Error loading categories: $e")),
        getActivityType().catchError((e) => debugPrint("Error loading activity types: $e")),
        getActivityStatus().catchError((e) => debugPrint("Error loading activity status: $e")),
      ]);

      final response = await ApiHandler.getRequest("${ApiEndPoint.leadDetail}$id");
      debugPrint("Lead Detail Response: ${response.statusCode}");

      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          LeadFindResponseModel leadFindResponseModel = leadFindResponseModelFromJson(response.data);
          opportunityFiendData.value = leadFindResponseModel.opportunityFindData;

          clearData();
          final oppData = opportunityFiendData.value!;
          debugPrint("oppData.opportunityName === ${oppData.opportunityName}");
          leadNameController.value.text = oppData.customerName;
          leadContactNameController.value.text = oppData.opportunityName;
          emailController.value.text = oppData.email;
          phoneType.value = oppData.isMobile ? "Mobile" : "Landline";

          if (phoneType.value == "Landline") {
            mobileNumberController.value.text = oppData.landline;
          } else {
            mobileNumberController.value.text = oppData.mobile1;
          }

          mobileNumberCountryCodeController.value.text = oppData.mobile1CountryCode.isEmpty ? "+91" : oppData.mobile1CountryCode;
          secondMobileNumberCountryCodeController.value.text = oppData.mobile2CountryCode.isEmpty ? "+91" : oppData.mobile2CountryCode;
          secondMobileNumberController.value.text = oppData.mobile2;

          stateController.value.text = oppData.stateName;
          stateIdController.value.text = oppData.stateId;
          cityController.value.text = oppData.cityName;
          cityIdController.value.text = oppData.cityId;
          pinCodeController.value.text = oppData.pincodeName;
          pinCodeIdController.value.text = oppData.pincodeId;

          expectedRevenueController.value.text = double.tryParse(oppData.expectedAmount)?.toInt().toString() ?? oppData.expectedAmount;
          selectedProbability.value = oppProbabilityList.firstWhereOrNull((element) => element.id == oppData.probabilityId);
          remarksController.value.text = oppData.remarks;
          interestController.value.text = oppData.interest;

          selectedProductCategory.value = oppProductCategoryList.firstWhereOrNull((element) => oppData.productCategory.contains(element.id));

          if (selectedProductCategory.value != null) {
            await getInterestProduct(page: 1, categoryId: selectedProductCategory.value!.id, fromPagination: false);
          }

          final productIds = oppData.productIds;
          // selectedProducts.assignAll(oppProductList.where((e) => productIds.contains(e.id)).toList());
          // oppProductNameController.value.text = selectedProducts.map((e) => e.productName).join(", ");

          // Load interest products (multi-selection)
          selectedInterestProduct.assignAll(oppInterestProductList.where((e) => productIds.contains(e.id)));
          updateSelectedProductText();

          // Ensure the customer is in the list or add it
          selectedContactName.value = customerNameList.firstWhereOrNull((element) => element.id == oppData.customerId);
          if (oppData.customerId.isNotEmpty) {
            await getContactPersonApi(customerId: oppData.customerId);
            selectedContactPerson.value = contactPersonList.firstWhereOrNull((element) => element.id == oppData.contactPersonId);
          }

          if (selectedContactName.value == null && oppData.customerId.isNotEmpty) {
            selectedContactName.value = ContactNameDatum(
              id: oppData.customerId,
              companyName: oppData.customerName,
              defaultPriceType: oppData.customerPriceType,
              tenantId: '',
              customerCode: '',
              contactName: '',
              address: '',
              stateId: '',
              cityId: '',
              pincodeId: '',
              pan: '',
              personName: '',
              jobPosition: '',
              isMobile: false,
              mobile1CountryCode: '',
              mobile1: '',
              mobile2CountryCode: '',
              mobile2: '',
              landline: '',
              email: '',
              website: '',
              tags: [],
              projectName: '',
              remarks: '',
              sourceId: '',
              creditLimit: '',
              creditDays: 0,
              gstCategory: '',
              gstNumber: '',
              createdBy: '',
              createdAt: '',
              updatedAt: '',
              customerGroupId: '',
              isCustomer: false,
              isActive: false,
              stateName: '',
              cityName: '',
              pincodeName: '',
              sourceName: '',
              countryName: '',
              addresses: [],
            );
            customerNameList.insert(0, selectedContactName.value!);
          }

          selectedSource.value = oppSourceList.firstWhereOrNull((element) => element.id == oppData.sourceId);

          selectedAssignSalesPerson.value = assignSalesPersonList.firstWhereOrNull((element) => element.id == oppData.assignedBy);
          if (selectedAssignSalesPerson.value != null) {
            assignSalesPersonController.value.text = "${selectedAssignSalesPerson.value!.firstName} ${selectedAssignSalesPerson.value!.lastName}";
          }

          selectedFollowerAndViewer.assignAll(
            assignSalesPersonList.where((u) => oppData.opportunitySecondarySalesPerson.any((a) => a.user!.id == u.userId)).toList(),
          );

          selectedTags.assignAll(oppTagList.where((item) => oppData.tags.contains(item.name)).toList());

          opportunityTagController.clearAll();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (selectedTags.isNotEmpty) {
              opportunityTagController.selectWhere((dropdownItem) {
                return selectedTags.any((e) => e.id == dropdownItem.value.id);
              });
            }
          });

          selectedLabel.value = oppLabelList.firstWhereOrNull((element) => element.id == oppData.labelId);
          selectedOpportunitySection.value = opportunitySectionList.firstWhereOrNull((element) => element.id == oppData.sectionId);

          if (oppData.expectedClosingDate.isNotEmpty) {
            try {
              DateTime date = DateTime.parse(oppData.expectedClosingDate);
              expectedClosingController.value.text = DateFormat('d, MMMM, yyyy').format(date);
            } catch (e) {
              expectedClosingController.value.text = oppData.expectedClosingDate;
            }
          }

          logsList.assignAll(
            oppData.opportunityFindLog
                .map(
                  (value) =>
                      Log(notes: value.notes, reminderDate: value.metadata.reminderDate, opportunityId: value.id, attachmentUrl: value.attachmentUrl),
                )
                .toList(),
          );

          activityList.assignAll(
            oppData.opportunityFindActivity
                .map(
                  (value) => Activity(
                    id: value.id,
                    activityType: value.activityType,
                    activityStatus: value.activityStatus,
                    callMedium: value.callMedium,
                    subject: value.subject,
                    description: value.description,
                    startTime: value.startTime,
                    endTime: value.endTime,
                    link: value.link,
                    reminderTime: value.reminderTime,
                    followUpDate: value.followUpDate,
                  ),
                )
                .toList(),
          );

          debugPrint("Successfully populated lead details");
          isOpportunityFiend.value = false;
        } else {
          debugPrint("Error: API status is not 200: ${data['status']}");
          toastMessage(text: data['message'] ?? "Failed to load lead details", color: AppColors.redColor);
          isOpportunityFiend.value = false;
        }
      } else {
        debugPrint("Error: HTTP status is not 200: ${response.statusCode}");
        toastMessage(text: "Failed to fetch lead data", color: AppColors.redColor);
        isOpportunityFiend.value = false;
      }
    } catch (e, stack) {
      debugPrint("Exception in getLeadDetail: $e");
      debugPrint(stack.toString());
      toastMessage(text: "An error occurred while loading lead details", color: AppColors.redColor);
      isOpportunityFiend.value = false;
    }
  }

  Future<void> opportunityUpdate({
    required String id,
    required bool loading,
    required String opportunityName,
    required List<String> productId,
    required String customerId,
    required String sourceId,
    required int expectedAmount,
    required String expectedClosingDate,
    required String remarks,
    required RxList<Log> logList,
    required RxList<Activity> activityList,
    required String probability,
    required String email,
    required String mobile1,
    required String mobile2,
    required String cityId,
    required String pinCodeId,
    required String stateId,
    required String labelId,
    required String salesPersonId,
    required List<String> tags,
    required List<String> secondarySalesPersonId,
    required String interest,
    required List<String> productCategory,
  }) async {
    isLoading.value = true;
    String cleanMobile1 = splitCountryCodeFromMobile(
      countryCodeController: mobileNumberCountryCodeController.value,
      mobileController: mobileNumberController.value,
    );
    String cleanMobile2 = splitCountryCodeFromMobile(
      countryCodeController: secondMobileNumberCountryCodeController.value,
      mobileController: secondMobileNumberController.value,
    );

    final requestBody = {
      "opportunity_name": opportunityName,
      "product_ids": productId,
      "customer_id": customerId,
      "expected_amount": expectedAmount,
      "probability_id": probability,
      "email": email,
      "mobile1": cleanMobile1,
      "mobile2": cleanMobile2,
      "landline": phoneType.value == "Landline" ? cleanMobile1 : "",
      "mobile1_country_code": mobileNumberCountryCodeController.value.text,
      "mobile2_country_code": secondMobileNumberCountryCodeController.value.text,
      "city_id": cityId,
      "pincode_id": pinCodeId,
      "state_id": stateId,
      "source_id": sourceId,
      "label_id": labelId,
      "sales_person_id": salesPersonId,
      "secondary_sales_person_ids": secondarySalesPersonId,
      "isMobile": phoneType.value == "Mobile",
      "expected_closing_date": expectedClosingDate,
      "tags": tags,
      "logs": logList,
      "activities": activityList,
      "interest": interest,
      "is_bulk_requirement": false,
      "remarks": remarks,
      "contact_person_id": selectedContactPerson.value?.id ?? "",
      "product_category": productCategory,
      "location_id": Pref.getLocationId(),
      "company_id": Pref.getCompanyId(),
      "fin_year": Pref.getFinancialYears(),
    };

    logger.i(JsonEncoder.withIndent(" " * 4).convert(requestBody));
    try {
      var response = await ApiHandler.patchTokenRequest(url: "${ApiEndPoint.leadUpdate}$id", body: jsonEncode(requestBody));

      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          isLoading.value = false;
          pageCount.value = 1;
          getLeadListApi(page: pageCount.value, search: searchController.value.text);
          Get.back();
          toastMessage(text: "Opportunity Update Successfully", color: AppColors.greenColor, isTop: false);
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

  Future<void> deleteLeadApi({required String id}) async {
    final response = await ApiHandler.deleteRequest("${ApiEndPoint.opportunityDelete}$id");

    final data = json.decode(response.data);

    if (response.statusCode == 200) {
      if (data['status'] == 200) {
        debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   ${data['message']}");
        leadList.clear();
        getLeadListApi(page: pageCount.value, search: searchController.value.text);
        Get.back();
      }
    }
  }

  Future<void> addLog({required String id, bool isAddList = false}) async {
    isAddLogLoading.value = true;
    try {
      final response = await ApiHandler.postTokenRequest(
        url: ApiEndPoint.addLog,
        body: jsonEncode({
          "entity_type": "Opportunity",
          "entity_id": id,
          "parent_type": null,
          "parent_id": null,
          "root_type": "Opportunity",
          "root_id": id,
          "notes": opportunityLogDetailsController.value.text,
          "log_type": "user",
          "metadata": opportunityLogDateController.value.text.isNotEmpty
              ? {"reminder_date": DateFormat('yyyy-MM-dd').format(DateFormat('dd MMM yyyy').parse(opportunityLogDateController.value.text))}
              : null,
          "attachment_url": uploadedImageLink,
        }),
      );
      final data = response.data;
      if (response.statusCode == 201 && data['status'] == 201) {
        if (isAddList) {
          pageCount.value = 1;
          getLeadListApi(page: pageCount.value, search: searchController.value.text);
          Get.back();
        } else {
          getOpportunityView(id: id);
        }
        opportunityLogDetailsController.value.clear();
        opportunityLogDateController.value.clear();
        uploadedImageLink.clear();
      }
    } catch (e) {
      debugPrint("Add Log Error: $e");
    } finally {
      isAddLogLoading.value = false;
    }
  }

  Future<void> addAssign({required String id}) async {
    isAddAssignLoading.value = true;
    try {
      final response = await ApiHandler.patchTokenRequest(
        url: "${ApiEndPoint.opportunityAssign}$id",
        body: json.encode({"is_assigned": true, "sales_person_id": selectedAssignSalesPerson.value!.id}),
      );
      final data = json.decode(response.data);
      if (response.statusCode == 200) {
        if (data['status'] == 200) {
          pageCount.value = 1;
          getLeadListApi(page: pageCount.value, search: searchController.value.text);
          selectedAssignSalesPerson.value = null;
          Get.back();
          isAddAssignLoading.value = false;
        } else {
          isAddAssignLoading.value = false;
        }
      }
    } catch (e) {
      isAddAssignLoading.value = false;
    }
  }

  Future<void> getActivityDetailApi({required String id}) async {
    isActivityDetailLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.activityDetail}$id");
      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['success'] == true || data['status'] == 200) {
          ActivityDetailModel detailModel = ActivityDetailModel.fromJson(data);
          activityDetailData.value = detailModel.data;
        }
      }
    } catch (e) {
      debugPrint("Get Activity Detail Error: $e");
    } finally {
      isActivityDetailLoading.value = false;
    }
  }

  Future<void> getOpportunitySummaryApi({bool isLoading = true, required int page, String? search}) async {
    if (page == 1) {
      opportunitySummaryList.clear();
      activitySummary.value = null; // Clear summary to show it's refreshing
    }
    if (isLoading) {
      isSummaryLoading.value = true;
    }
    try {
      String url =
          "${ApiEndPoint.opportunitySummary}?company_id=${Pref.getCompanyId()}&location_id=${Pref.getLocationId()}&page=$page&limit=20&search=${search ?? ""}";
      if (selectedActivityFilter.value.isNotEmpty) {
        url += "&activity_type=${selectedActivityFilter.value}";
      }
      if (selectedFilterGroups.value.isNotEmpty) {
        url += "&filterGroups=${selectedFilterGroups.value}";
      }
      final response = await ApiHandler.getRequest(url);
      final data = json.decode(response.data);

      if (response.statusCode == 200) {
        if (data['success'] == true || data['status'] == 200) {
          OpportunitySummaryModel summaryModel = OpportunitySummaryModel.fromJson(data);
          opportunitySummaryList.addAll(summaryModel.data.items);
          activitySummary.value = summaryModel.data.summary;
          summaryTotalCount.value = summaryModel.data.pagination.totalItems;
        }
      }
    } catch (e) {
      debugPrint("Get Summary Error: $e");
    } finally {
      if (isLoading) {
        isSummaryLoading.value = false;
      }
    }
  }

  Future<void> getSearchSuggestions(String query) async {
    if (query.isEmpty) {
      searchSuggestions.clear();
      return;
    }
    isSearchSuggestionsLoading.value = true;
    try {
      final response = await ApiHandler.getRequest("${ApiEndPoint.opportunitySearchSuggestions}?q=$query");
      final data = json.decode(response.data);

      if (response.statusCode == 200 && data['success'] == true) {
        SearchSuggestionModel suggestionModel = SearchSuggestionModel.fromJson(data);
        searchSuggestions.assignAll(suggestionModel.data.suggestions);
      }
    } catch (e) {
      debugPrint("Search Suggestions Error: $e");
    } finally {
      isSearchSuggestionsLoading.value = false;
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
