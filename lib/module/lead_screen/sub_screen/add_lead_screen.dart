import 'package:crm/config/app_shared_pref.dart';
import 'package:crm/module/inquiry_screen/Inquiry_controller.dart';
import 'package:crm/module/inquiry_screen/sub_screen/Inquiry_view_screen.dart';
import 'package:crm/module/lead_screen/model/get_assign_partner.dart';
import 'package:crm/widget/dropdown.dart';
import 'package:crm/widget/textfield.dart';
import 'package:crm/widget/toast_message.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../widget/button_view.dart';
import '../../inquiry_screen/model/city_model.dart';
import '../../inquiry_screen/model/country_model.dart';
import '../../inquiry_screen/model/pincode_model.dart';
import '../../inquiry_screen/model/state_model.dart';
import '../lead_controller.dart';
import '../model/contactName_model.dart';
import '../model/contact_person_response_model.dart';
import '../model/lead_model.dart';
import '../model/lead_type.dart';
import '../widget/tab_screen.dart';
import 'create_contact_person_screen.dart';

import 'package:crm/module/inquiry_screen/model/Inquiry_view_response.dart';

class AddLeadScreen extends StatefulWidget {
  final bool isEdit;
  final String? id;
  final InquiryViewData? prefillFromInquiry;

  const AddLeadScreen({super.key, this.isEdit = false, this.id, this.prefillFromInquiry});

  @override
  State<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddLeadScreen> {
  LeadController leadController = Get.find<LeadController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController assignSalesPersonScrollController = ScrollController();
  final ScrollController productScrollController = ScrollController();
  final ScrollController interestProductScrollController = ScrollController();
  final ScrollController pinCodeScrollController = ScrollController();
  final ScrollController cityScrollController = ScrollController();
  final ScrollController customerScrollController = ScrollController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      leadController.expectedClosingController.value.text = DateFormat('d, MMMM, y').format(picked);
    }
  }

  @override
  void initState() {
    leadController.assignSalesPartnerSearchController.value.clear();
    pinCodeScrollController.addListener(() {
      if (pinCodeScrollController.position.pixels >= pinCodeScrollController.position.maxScrollExtent - 200) {
        if (leadController.isPinCodeLoading.value == false && leadController.pinCodeList.length < leadController.pinCodeTotalCount.value) {
          leadController.pinCodePageCount.value++;
          leadController.getPinCodeApi(
            page: leadController.pinCodePageCount.value,
            search: leadController.pinCodeSearchController.value.text,
            cityId: leadController.selectedCity.value != null ? leadController.selectedCity.value!.id : "",
          );
        }
      }
    });
    cityScrollController.addListener(() {
      if (cityScrollController.position.pixels >= cityScrollController.position.maxScrollExtent - 200) {
        if (leadController.isCityLoading.value == false && leadController.cityList.length < leadController.cityTotalCount.value) {
          leadController.cityPageCount.value++;
          leadController.getCityApi(
            page: leadController.cityPageCount.value,
            search: leadController.citySearchController.value.text,
            stateId: leadController.selectedState.value != null ? leadController.selectedState.value!.id : "",
            fromPagination: true,
          );
        }
      }
    });
    assignSalesPersonScrollController.addListener(() {
      if (assignSalesPersonScrollController.position.pixels >= assignSalesPersonScrollController.position.maxScrollExtent - 200) {
        if (leadController.isAssignSalesPersonLoading.value == false &&
            leadController.assignSalesPersonList.length < leadController.salesPersonTotalCount.value) {
          leadController.salesPersonPageCount.value++;
          leadController.getAssignSalesPerson(
            page: leadController.salesPersonPageCount.value,
            search: leadController.assignSalesPartnerSearchController.value.text,
          );
        }
      }
    });
    productScrollController.addListener(() {
      if (productScrollController.position.pixels >= productScrollController.position.maxScrollExtent - 200) {
        if (!leadController.isProductLoading.value && leadController.oppProductList.length < leadController.productTotalCount.value) {
          leadController.productPageCount.value++;
          leadController.getProduct(page: leadController.productPageCount.value);
        }
      }
    });
    interestProductScrollController.addListener(() {
      if (interestProductScrollController.position.pixels >= interestProductScrollController.position.maxScrollExtent - 200) {
        if (!leadController.isInterestProductLoading.value &&
            leadController.oppInterestProductList.length < leadController.interestProductTotalCount.value) {
          leadController.interestProductPageCount.value++;
          leadController.getInterestProduct(
            page: leadController.interestProductPageCount.value,
            categoryId: leadController.selectedProductCategory.value?.id,
          );
        }
      }
    });
    customerScrollController.addListener(() {
      if (customerScrollController.position.pixels >= customerScrollController.position.maxScrollExtent - 200) {
        if (!leadController.isCustomerLoading.value && leadController.customerNameList.length < leadController.customerTotalCount.value) {
          leadController.customerPageCount.value++;
          leadController.getContactName(page: leadController.customerPageCount.value, search: leadController.customerSearchController.value.text);
        }
      }
    });
    if (widget.isEdit == false) {
      leadController.clearData();
      
      if (widget.prefillFromInquiry != null) {
        final inquiry = widget.prefillFromInquiry!;
        
        if (inquiry.id != null && inquiry.id!.isNotEmpty) {
          leadController.selectedContactName.value = ContactNameDatum(
            id: inquiry.id ?? "",
            companyName: inquiry.companyName ?? "",
            contactName: inquiry.contactName ?? "",
            defaultPriceType: inquiry.defaultPriceType ?? "",
            tenantId: inquiry.tenantId ?? '',
            customerCode: inquiry.customerCode ?? '',
            address: inquiry.address ?? '',
            stateId: inquiry.stateId ?? '',
            cityId: inquiry.cityId ?? '',
            pincodeId: inquiry.pincodeId ?? '',
            pan: inquiry.pan ?? '',
            personName: inquiry.personName ?? '',
            jobPosition: inquiry.jobPosition ?? '',
            isMobile: inquiry.isMobile ?? false,
            mobile1CountryCode: inquiry.mobile1CountryCode ?? '',
            mobile1: inquiry.mobile1 ?? '',
            mobile2CountryCode: inquiry.mobile2CountryCode ?? '',
            mobile2: inquiry.mobile2 ?? '',
            landline: inquiry.landline ?? '',
            email: inquiry.email ?? '',
            website: inquiry.website ?? '',
            tags: inquiry.tags ?? [],
            projectName: inquiry.projectName ?? '',
            remarks: inquiry.remarks ?? '',
            sourceId: inquiry.sourceId ?? '',
            creditLimit: inquiry.creditLimit ?? '',
            creditDays: inquiry.creditDays ?? 0,
            gstCategory: inquiry.gstCategory ?? '',
            gstNumber: inquiry.gstNumber ?? '',
            createdBy: inquiry.createdBy ?? '',
            createdAt: inquiry.createdAt?.toString() ?? '',
            updatedAt: inquiry.updatedAt?.toString() ?? '',
            customerGroupId: inquiry.customerGroupId ?? '',
            isCustomer: inquiry.isCustomer ?? false,
            isActive: inquiry.isActive ?? false,
            stateName: inquiry.stateName ?? '',
            cityName: inquiry.cityName ?? '',
            pincodeName: inquiry.pincodeName ?? '',
            sourceName: inquiry.sourceName ?? '',
            countryName: inquiry.countryName ?? '',
            addresses: [],
          );
          if (!leadController.customerNameList.any((e) => e.id == inquiry.id)) {
            leadController.customerNameList.insert(0, leadController.selectedContactName.value!);
          }
          leadController.getContactPersonApi(customerId: inquiry.id!);
        }

        leadController.companyNameController.value.text = inquiry.companyName ?? "";
        leadController.leadContactNameController.value.text = inquiry.companyName ?? "";
        leadController.leadNameController.value.text = inquiry.contactName ?? "";
        leadController.emailController.value.text = inquiry.email ?? "";
        leadController.mobileNumberController.value.text = inquiry.mobile1 ?? "";
        leadController.secondMobileNumberController.value.text = inquiry.mobile2 ?? "";
        
        leadController.stateController.value.text = inquiry.stateName ?? "";
        leadController.stateIdController.value.text = inquiry.stateId ?? "";
        leadController.cityController.value.text = inquiry.cityName ?? "";
        leadController.cityIdController.value.text = inquiry.cityId ?? "";
        leadController.pinCodeController.value.text = inquiry.pincodeName ?? "";
        leadController.pinCodeIdController.value.text = inquiry.pincodeId ?? "";
        
        if (inquiry.sourceId != null && inquiry.sourceId!.isNotEmpty) {
            leadController.selectedSource.value = LeadItem(id: inquiry.sourceId!, name: inquiry.sourceName ?? "");
            leadController.isEnableSource.value = false;
        } else {
            leadController.selectedSource.value = null;
            leadController.isEnableSource.value = true;
        }
        
        if (inquiry.stateId != null && inquiry.stateId!.isNotEmpty) {
            leadController.selectedState.value = StateDatum(id: inquiry.stateId!, name: inquiry.stateName ?? "", countryId: CountryId(id: inquiry.countryId ?? "", name: inquiry.countryName ?? ""));
        }
        if (inquiry.cityId != null && inquiry.cityId!.isNotEmpty) {
            leadController.selectedCity.value = CityDatum(id: inquiry.cityId!, name: inquiry.cityName ?? "", stateId: StateId(id: inquiry.stateId ?? "", name: inquiry.stateName ?? ""), countryId: StateId(id: inquiry.countryId ?? "", name: inquiry.countryName ?? ""));
        }
        if (inquiry.pincodeId != null && inquiry.pincodeId!.isNotEmpty) {
            leadController.selectedPinCode.value = PinCodeDatum(id: inquiry.pincodeId!, pinCode: inquiry.pincodeName ?? "", cityId: Id(id: inquiry.cityId ?? "", name: inquiry.cityName ?? ""), stateId: Id(id: inquiry.stateId ?? "", name: inquiry.stateName ?? ""), countryId: Id(id: inquiry.countryId ?? "", name: inquiry.countryName ?? ""));
        }
        
        leadController.remarksController.value.text = inquiry.remarks ?? "";
      }

      Future.wait([
        leadController.getProbability().catchError((e) => debugPrint("Error loading probability: $e")),
        leadController.getSource().catchError((e) => debugPrint("Error loading source: $e")),
        leadController.getLabel().catchError((e) => debugPrint("Error loading label: $e")),
        leadController.getTags().catchError((e) => debugPrint("Error loading tags: $e")),
        leadController.getAssignSalesPerson(page: 1, fromPagination: false).catchError((e) => debugPrint("Error loading sales persons: $e")),
        leadController.getOpportunitySection().catchError((e) => debugPrint("Error loading sections: $e")),
        leadController.getProduct(page: 1).catchError((e) => debugPrint("Error loading products: $e")),
        leadController.getContactName(page: 1, fromPagination: false).catchError((e) => debugPrint("Error loading contact names: $e")),
        leadController.getInterestProduct(page: 1, fromPagination: false).catchError((e) => debugPrint("Error loading interest products: $e")),
        leadController.getStateApi().catchError((e) => debugPrint("Error loading states: $e")),
        leadController.getCityApi(page: 1, fromPagination: false).catchError((e) => debugPrint("Error loading cities: $e")),
        leadController.getPinCodeApi(page: 1, fromPagination: false).catchError((e) => debugPrint("Error loading pin codes: $e")),
        leadController.getProductCategory().catchError((e) => debugPrint("Error loading categories: $e")),
      ]);
    } else {
      leadController.getLeadDetail(id: widget.id!);
    }

    super.initState();
  }

  void openPinCodeBottomSheet(BuildContext context, ScrollController controller) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(color: AppColors.gray300, borderRadius: BorderRadius.all(Radius.circular(2))),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                child: Text(
                  "Select PinCode",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: commonTextField(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search PinCode...",
                  controller: leadController.pinCodeSearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    if (value.length % 3 == 0) {
                      leadController.pinCodePageCount.value = 1;
                      final cityId = leadController.selectedCity.value?.id;

                      if (cityId != null) {
                        leadController.getPinCodeApi(
                          page: leadController.pinCodePageCount.value,
                          search: value,
                          fromPagination: false,
                          cityId: cityId,
                        );
                      } else {
                        leadController.getPinCodeApi(page: leadController.pinCodePageCount.value, search: value, fromPagination: false);
                      }
                    }
                  },
                ),
              ),

              /// 🔹 PRODUCT LIST
              Expanded(
                child: Obx(() {
                  final list = leadController.pinCodeList;
                  final isLoading = leadController.isPinCodeLoading.value;

                  if (isLoading && list.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
                  }

                  if (list.isEmpty && !isLoading) {
                    return const Center(child: Text("No data found"));
                  }

                  return ListView.separated(
                    controller: controller,
                    padding: EdgeInsets.zero,
                    itemCount: list.length + (isLoading ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index == list.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(color: AppColors.indigo600Main),
                          ),
                        );
                      }
                      final item = list[index];

                      return GestureDetector(
                        onTap: () {
                          leadController.pinCodeController.value.text = item.pinCode;
                          leadController.pinCodeIdController.value.text = item.id;
                          leadController.cityController.value.text = item.cityId.name;
                          leadController.cityIdController.value.text = item.cityId.id;
                          leadController.stateController.value.text = item.stateId.name;
                          leadController.stateIdController.value.text = item.stateId.id;
                          leadController.countryController.value.text = item.countryId.name;
                          leadController.selectedPinCode.value = item;
                          leadController.selectedCountry.value = CountryDatum(id: item.countryId.id, name: item.countryId.name);
                          leadController.selectedCity.value = CityDatum(
                            id: item.cityId.id,
                            name: item.cityId.name,
                            stateId: StateId(id: item.stateId.id, name: item.stateId.name),
                            countryId: StateId(id: item.countryId.id, name: item.countryId.name),
                          );
                          leadController.selectedState.value = StateDatum(
                            id: item.stateId.id,
                            name: item.stateId.name,
                            countryId: CountryId(id: item.countryId.id, name: item.countryId.name),
                          );

                          Get.back();
                          leadController.pinCodePageCount.value = 1;
                          leadController.pinCodeSearchController.value.clear();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.pinCode, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void openCityBottomSheet(BuildContext context, ScrollController controller) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(color: AppColors.gray300, borderRadius: BorderRadius.all(Radius.circular(2))),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                child: Text(
                  "Select City",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: commonTextField(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search City...",
                  controller: leadController.citySearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    if (value.isEmpty || value.length % 3 == 0) {
                      leadController.cityPageCount.value = 1;

                      final stateId = leadController.selectedState.value?.id;

                      if (stateId != null) {
                        leadController.getCityApi(page: leadController.cityPageCount.value, search: value, fromPagination: false, stateId: stateId);
                      } else {
                        leadController.getCityApi(page: leadController.cityPageCount.value, search: value, fromPagination: false);
                      }
                    }
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = leadController.cityList;
                  final isLoading = leadController.isCityLoading.value;

                  if (isLoading && list.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
                  }

                  if (list.isEmpty && !isLoading) {
                    return const Center(child: Text("No city found"));
                  }

                  return ListView.separated(
                    controller: controller,
                    padding: EdgeInsets.zero,
                    itemCount: list.length + (isLoading ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index == list.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(color: AppColors.indigo600Main),
                          ),
                        );
                      }
                      final item = list[index];
                      return GestureDetector(
                        onTap: () {
                          leadController.selectedCity.value = item;
                          leadController.cityController.value.text = item.name;
                          leadController.cityIdController.value.text = item.id;
                          leadController.stateController.value.text = item.stateId.name;
                          leadController.stateIdController.value.text = item.stateId.id;

                          leadController.selectedPinCode.value = null;
                          leadController.pinCodeController.value.clear();
                          leadController.pinCodeIdController.value.clear();
                          leadController.pinCodePageCount.value = 1;
                          leadController.pinCodeSearchController.value.clear();
                          leadController.getPinCodeApi(
                            page: leadController.pinCodePageCount.value,
                            search: leadController.pinCodeSearchController.value.text,
                            cityId: item.id,
                            fromPagination: false,
                          );
                          leadController.selectedState.value = StateDatum(
                            id: item.stateId.id,
                            name: item.stateId.name,
                            countryId: CountryId(id: item.countryId.id, name: item.countryId.name),
                          );
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void openCountryBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(color: AppColors.gray300, borderRadius: BorderRadius.all(Radius.circular(2))),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                child: Text(
                  "Select Country",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: commonTextField(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search Country...",
                  controller: leadController.countrySearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    leadController.getCountry(search: value);
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = leadController.countryList;
                  if (list.isEmpty) {
                    return const Center(child: Text("No country found"));
                  }
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return GestureDetector(
                        onTap: () {
                          leadController.selectedCountry.value = item;
                          leadController.countryController.value.text = item.name;

                          leadController.selectedState.value = null;
                          leadController.stateController.value.clear();
                          leadController.stateIdController.value.clear();
                          leadController.selectedCity.value = null;
                          leadController.cityController.value.clear();
                          leadController.cityIdController.value.clear();
                          leadController.selectedPinCode.value = null;
                          leadController.pinCodeController.value.clear();
                          leadController.pinCodeIdController.value.clear();

                          leadController.getStateApi(countryId: item.id);
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void openStateBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(color: AppColors.gray300, borderRadius: BorderRadius.all(Radius.circular(2))),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                child: Text(
                  "Select State",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: commonTextField(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search State...",
                  controller: leadController.stateSearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    leadController.getStateApi(search: value, countryId: leadController.selectedCountry.value?.id);
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = leadController.stateList;
                  if (list.isEmpty) {
                    return const Center(child: Text("No state found"));
                  }
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return GestureDetector(
                        onTap: () {
                          leadController.selectedState.value = item;
                          leadController.stateController.value.text = item.name;
                          leadController.stateIdController.value.text = item.id;

                          leadController.selectedCity.value = null;
                          leadController.cityController.value.clear();
                          leadController.cityIdController.value.clear();
                          leadController.selectedPinCode.value = null;
                          leadController.pinCodeController.value.clear();
                          leadController.pinCodeIdController.value.clear();

                          leadController.getCityApi(page: 1, stateId: item.id, fromPagination: false);
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.indigo600Main,
        title: Text("${widget.isEdit ? "Update" : "Add"} Lead", style: const TextStyle(color: AppColors.white)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (widget.isEdit && leadController.isOpportunityFiend.isTrue) {
            return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
          } else {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Customer Name*",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Obx(
                            () => leadController.selectedContactName.value != null
                                ? GestureDetector(
                                    onTap: () async {
                                      final InquiryScreenController inquiryScreenController = Get.find<InquiryScreenController>();
                                      await inquiryScreenController.getInquiryView(id: leadController.selectedContactName.value!.id);
                                      Get.to(() => InquiryDetailScreen());
                                    },
                                    child: const Icon(Icons.visibility_outlined, color: AppColors.indigo600Main, size: 20),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      commonTextField(
                        hintText: "Search and select customer",
                        controller: leadController.leadNameController.value,
                        needValidation: true,
                        readOnly: true,
                        onTap: () {
                          leadController.customerSearchController.value.clear();
                          Get.bottomSheet(
                            Container(
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                              ),
                              height: Get.height * 0.75,
                              child: SafeArea(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: commonTextField(
                                        prefixIcon: const Icon(Icons.search),
                                        labelText: "Search",
                                        hintText: "Search customer",
                                        controller: leadController.customerSearchController.value,
                                        needValidation: false,
                                        onChange: (value) {
                                          if (value.isEmpty || value.length % 3 == 0) {
                                            leadController.customerPageCount.value = 1;
                                            leadController.getContactName(page: 1, search: value, fromPagination: false);
                                          }
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Obx(() {
                                        final list = leadController.customerNameList;
                                        final isLoading = leadController.isCustomerLoading.value;

                                        if (isLoading && list.isEmpty) {
                                          return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
                                        }

                                        if (list.isEmpty && !isLoading) {
                                          return const Center(child: Text("No customer found"));
                                        }

                                        return ListView.separated(
                                          controller: customerScrollController,
                                          padding: EdgeInsets.zero,
                                          itemCount: list.length + (isLoading ? 1 : 0),
                                          separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.gray200),
                                          itemBuilder: (context, index) {
                                            if (index == list.length) {
                                              return const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: CircularProgressIndicator(color: AppColors.indigo600Main),
                                                ),
                                              );
                                            }
                                            final item = list[index];
                                            return ListTile(
                                              title: Text(item.contactName),
                                              subtitle: Text("${item.companyName} ${item.stateName.isNotEmpty ? "- ${item.stateName}" : ""}"),
                                              onTap: () {
                                                leadController.selectedContactName.value = item;
                                                leadController.selectedContactPerson.value = null;
                                                leadController.getContactPersonApi(customerId: item.id);
                                                leadController.companyNameController.value.text = item.companyName;
                                                leadController.leadContactNameController.value.text = item.companyName;
                                                leadController.leadNameController.value.text = item.contactName;
                                                leadController.emailController.value.text = item.email;
                                                leadController.mobileNumberController.value.text = item.mobile1;
                                                leadController.secondMobileNumberController.value.text = item.mobile2;
                                                leadController.stateController.value.text = item.stateName;
                                                leadController.stateIdController.value.text = item.stateId;
                                                leadController.cityController.value.text = item.cityName;
                                                leadController.cityIdController.value.text = item.cityId;
                                                leadController.pinCodeController.value.text = item.pincodeName;
                                                leadController.pinCodeIdController.value.text = item.pincodeId;
                                                if (item.sourceId.isNotEmpty || item.sourceName.isNotEmpty) {
                                                  leadController.selectedSource.value = LeadItem(id: item.sourceId, name: item.sourceName);
                                                  leadController.isEnableSource = false.obs;
                                                } else {
                                                  leadController.selectedSource.value = null;
                                                  leadController.isEnableSource = true.obs;
                                                }
                                                Get.back();
                                              },
                                            );
                                          },
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        validationMessage: "Contact Name is required",
                        suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                      ),
                      commonTextField(
                        labelText: "Company Name",
                        hintText: "Enter Company Name",
                        controller: leadController.companyNameController.value,
                        readOnly: true,
                        needValidation: false,
                      ),
                      Obx(
                        () => CustomDropdown<LeadItem>(
                          hintText: 'Product Category',
                          items: (filter, loadProps) => leadController.oppProductCategoryList,
                          itemAsString: (item) => item.name,
                          selectedItem: leadController.selectedProductCategory.value,
                          compareFn: (a, b) => a?.id == b?.id,
                          onChanged: (value) {
                            leadController.selectedProductCategory.value = value;
                            leadController.updateSelectedProductText();
                            leadController.selectedInterestProduct.clear();
                            leadController.interestProductController.value.clear();
                            if (value != null) {
                              leadController.getInterestProduct(page: 1, categoryId: value.id, fromPagination: false);
                            }
                          },
                        ),
                      ),
                      CustomMultiDropdownSearch<ProductDatum>(
                        hintText: 'Interest Product',
                        items: (filter, loadProps) => leadController.oppInterestProductList,
                        itemAsString: (item) => item.productName,
                        selectedItems: leadController.selectedInterestProduct,
                        compareFn: (a, b) => a?.id == b?.id,
                        onChanged: (values) {
                          leadController.selectedInterestProduct.assignAll(values);
                          leadController.updateSelectedProductText();
                        },
                      ),
                      commonTextField(
                        labelText: "Lead Name*",
                        hintText: "Enter Lead Name",
                        controller: leadController.leadContactNameController.value,
                        needValidation: true,
                        validationMessage: "Lead Name is required",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Contact Person",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (leadController.selectedContactName.value == null) {
                                toastMessage(text: "Please select customer first");
                                return;
                              }
                              Get.to(() => CreateContactPersonScreen(customerId: leadController.selectedContactName.value!.id));
                            },
                            child: const Text(
                              "+ Add Contact",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.indigo600Main),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          if (leadController.selectedContactName.value == null) {
                            toastMessage(text: "Please select customer first");
                          }
                        },
                        child: Obx(
                          () => CustomDropdown<ContactPersonDatum>(
                            enabled: leadController.selectedContactName.value != null,
                            hintText: 'Select Contact Person',
                            items: (filter, loadProps) => leadController.contactPersonList,
                            itemAsString: (item) => item.fullName,
                            selectedItem: leadController.selectedContactPerson.value,
                            compareFn: (a, b) => a?.id == b?.id,
                            onChanged: (value) {
                              leadController.selectedContactPerson.value = value;
                              if (value != null) {
                                leadController.emailController.value.text = value.emailId;
                                leadController.mobileNumberController.value.text = value.mobileNumber;
                              }
                            },
                          ),
                        ),
                      ),

                      commonTextField(
                        labelText: "Email",
                        hintText: "e.g. example@gmail.com",
                        controller: leadController.emailController.value,
                        textInputType: TextInputType.text,
                        readOnly: true,
                      ),
                      Obx(
                        () => Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.gray50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    "Type:",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: "Mobile",
                                          groupValue: leadController.phoneType.value,
                                          onChanged: (v) => leadController.phoneType.value = v!,
                                          activeColor: AppColors.indigo600Main,
                                        ),
                                        const Text("Mobile"),
                                        const Spacer(),
                                        Radio(
                                          value: "Landline",
                                          groupValue: leadController.phoneType.value,
                                          onChanged: (v) => leadController.phoneType.value = v!,
                                          activeColor: AppColors.indigo600Main,
                                        ),
                                        const Text("Landline"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (leadController.phoneType.value == "Mobile")
                              Column(
                                children: [
                                  IntlPhoneField(
                                    controller: leadController.mobileNumberController.value,
                                    validator: (phone) {
                                      if (phone == null || phone.number.isEmpty) {
                                        return 'Mobile number is required';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Mobile Number*',
                                      fillColor: AppColors.white,
                                      filled: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: AppColors.border, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: AppColors.indigo600Main, width: 1.6),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: AppColors.red500),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: AppColors.red500, width: 1.6),
                                      ),
                                    ),
                                    languageCode: "en",
                                    initialCountryCode: 'IN',
                                    onChanged: (phone) {
                                      leadController.mobileNumberController.value.text = phone.number;
                                    },
                                    onCountryChanged: (country) {
                                      leadController.mobileNumberCountryCodeController.value.text = "+${country.dialCode}";
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  IntlPhoneField(
                                    controller: leadController.secondMobileNumberController.value,
                                    decoration: InputDecoration(
                                      labelText: 'Alternative Phone',
                                      fillColor: AppColors.white,
                                      filled: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: AppColors.border, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: AppColors.indigo600Main, width: 1.6),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: AppColors.red500),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: AppColors.red500, width: 1.6),
                                      ),
                                    ),
                                    languageCode: "en",
                                    initialCountryCode: 'IN',
                                    onChanged: (phone) {
                                      leadController.secondMobileNumberController.value.text = phone.number;
                                    },
                                    onCountryChanged: (country) {
                                      leadController.secondMobileNumberCountryCodeController.value.text = "+${country.dialCode}";
                                    },
                                  ),
                                ],
                              )
                            else
                              commonTextField(
                                labelText: "Landline Number",
                                hintText: "Enter Landline Number",
                                controller: leadController.mobileNumberController.value,
                                textInputType: TextInputType.number,
                                isPhoneNumberValidator: true,
                                prefixIcon: const Icon(Icons.phone_callback_outlined, size: 20),
                              ),
                          ],
                        ),
                      ),
                      Obx(
                        () => CustomDropdown<LeadItem>(
                          hintText: 'Select Source*',
                          // enabled: leadController.isEnableSource.value,
                          items: (String filter, LoadProps? loadProps) {
                            return leadController.oppSourceList;
                          },
                          itemAsString: (item) => item.name,
                          selectedItem: leadController.selectedSource.value,
                          compareFn: (a, b) => a?.id == b?.id,
                          onChanged: (value) {
                            leadController.selectedSource.value = value;
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Source is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      commonTextField(
                        labelText: "Pincode",
                        hintText: "Select Pincode...",
                        controller: leadController.pinCodeController.value,
                        needValidation: false,
                        readOnly: true,
                        onTap: () => openPinCodeBottomSheet(context, pinCodeScrollController),
                        suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.indigo600Main),
                      ),
                      commonTextField(
                        labelText: "City",
                        hintText: "Select City...",
                        controller: leadController.cityController.value,
                        needValidation: false,
                        readOnly: true,
                        onTap: () => openCityBottomSheet(context, cityScrollController),
                        suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.indigo600Main),
                      ),
                      commonTextField(
                        labelText: "State",
                        hintText: "Select State...",
                        controller: leadController.stateController.value,
                        needValidation: false,
                        readOnly: true,
                        onTap: () => openStateBottomSheet(context),
                        suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.indigo600Main),
                      ),

                      commonTextField(
                        countryCode: leadController.expectedRevenueController.value.text,
                        labelText: "Expected Revenue*",
                        hintText: "Enter Expected Revenue",
                        controller: leadController.expectedRevenueController.value,
                        textInputType: TextInputType.number,
                        needValidation: true,
                        validationMessage: "Expected Revenue is required",
                        prefixIcon: const Icon(Icons.currency_rupee, color: AppColors.black, size: 18),
                      ),
                      Obx(
                        () => CustomDropdown<LeadItem>(
                          hintText: 'Select Probability',
                          items: (String filter, LoadProps? loadProps) {
                            return leadController.oppProbabilityList;
                          },
                          itemAsString: (item) => item.name,
                          selectedItem: leadController.selectedProbability.value,
                          compareFn: (a, b) => a?.id == b?.id,
                          onChanged: (value) {
                            leadController.selectedProbability.value = value;
                          },
                        ),
                      ),
                      commonTextField(
                        labelText: "Expected Closing*",
                        hintText: "Select Date",
                        controller: leadController.expectedClosingController.value,
                        suffixIcon: const Icon(Icons.calendar_month),
                        textInputType: TextInputType.text,
                        needValidation: true,
                        validationMessage: "Expected closing is required",
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                      Obx(
                        () => CustomDropdown<AssignSalesPerson>(
                          hintText: 'Assign Sales Person',
                          items: (filter, loadProps) => leadController.assignSalesPersonList,
                          itemAsString: (item) => "${item.firstName} ${item.lastName}",
                          selectedItem: leadController.selectedAssignSalesPerson.value,
                          compareFn: (a, b) => a?.id == b?.id,
                          onChanged: (value) {
                            leadController.selectedAssignSalesPerson.value = value;
                            leadController.assignSalesPersonController.value.text = value != null ? "${value.firstName} ${value.lastName}" : "";
                          },
                        ),
                      ),
                      CustomMultiDropdownSearch<AssignSalesPerson>(
                        hintText: 'Follower / Viewer',
                        items: (filter, loadProps) => leadController.assignSalesPersonList,
                        itemAsString: (item) => "${item.firstName} ${item.lastName}",
                        selectedItems: leadController.selectedFollowerAndViewer,
                        compareFn: (a, b) => a?.id == b?.id,
                        onChanged: (values) {
                          leadController.selectedFollowerAndViewer.assignAll(values);
                        },
                      ),

                      CustomMultiDropdownSearch<LeadItem>(
                        hintText: 'Select Tag*',
                        items: (filter, loadProps) => leadController.oppTagList,
                        itemAsString: (item) => item.name,
                        selectedItems: leadController.selectedTags,
                        compareFn: (a, b) => a?.id == b?.id,
                        onChanged: (values) {
                          leadController.selectedTags.assignAll(values);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tags are required';
                          }
                          return null;
                        },
                      ),

                      Obx(
                        () => CustomDropdown<LeadItem>(
                          hintText: 'Select Label',
                          items: (String filter, LoadProps? loadProps) {
                            return leadController.oppLabelList;
                          },
                          itemAsString: (item) => item.name,
                          selectedItem: leadController.selectedLabel.value,
                          compareFn: (a, b) => a?.id == b?.id,
                          onChanged: (value) {
                            leadController.selectedLabel.value = value;
                          },
                        ),
                      ),
                      commonTextField(
                        labelText: "Remarks",
                        hintText: "Enter Remarks",
                        controller: leadController.remarksController.value,
                        textInputType: TextInputType.text,
                        needValidation: false,
                      ),
                      SizedBox(height: 500, child: LeadDetailsMobile(leadController: leadController)),
                      Obx(() {
                        return commonButton(
                          name: widget.isEdit ? "Update" : 'Save',
                          isLoader: leadController.isLoading.value,
                          loaderColorWhite: true,
                          bgColor: AppColors.indigo600Main,
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              // if (leadController.logsList.isEmpty) {
                              //   toastMessage(text: "Please add logs");
                              //   return;
                              // }
                              // if (leadController.activityList.isEmpty) {
                              //   toastMessage(text: "Please add activity");
                              //   return;
                              // }
                              if (widget.isEdit) {
                                leadController.opportunityUpdate(
                                  id: widget.id!,
                                  opportunityName: leadController.leadContactNameController.value.text,
                                  customerId: leadController.selectedContactName.value!.id,
                                  productId: [
                                    ...leadController.selectedInterestProduct.map((e) => e.id),
                                    // ...leadController.selectedProducts.map((e) => e.id),
                                  ],
                                  expectedAmount: leadController.expectedRevenueController.value.text.isEmpty
                                      ? 0
                                      : double.tryParse(leadController.expectedRevenueController.value.text)?.toInt() ?? 0,
                                  probability: leadController.selectedProbability.value?.id ?? "",
                                  email: leadController.emailController.value.text,
                                  mobile1: leadController.mobileNumberController.value.text,
                                  mobile2: leadController.secondMobileNumberController.value.text,
                                  cityId: leadController.cityIdController.value.text,
                                  pinCodeId: leadController.pinCodeIdController.value.text,
                                  stateId: leadController.stateIdController.value.text,
                                  sourceId: leadController.selectedSource.value?.id ?? '',
                                  labelId: leadController.selectedLabel.value?.id ?? '',
                                  salesPersonId: leadController.selectedAssignSalesPerson.value?.id ?? Pref.getUserId(),
                                  expectedClosingDate: leadController.dateConverter(leadController.expectedClosingController.value.text),
                                  tags: leadController.selectedTags.map((e) => e.name).toList(),
                                  interest: leadController.interestController.value.text,
                                  remarks: leadController.remarksController.value.text,
                                  logList: leadController.logsList,
                                  activityList: leadController.activityList,
                                  secondarySalesPersonId: leadController.selectedFollowerAndViewer.map((e) => e.id!).toList(),
                                  productCategory: leadController.selectedProductCategory.value != null
                                      ? [leadController.selectedProductCategory.value!.id]
                                      : [],
                                  loading: true /*leadController.opportunityFiendData.value!*/,
                                );
                              } else {
                                leadController.opportunitySave(
                                  loading: true,
                                  opportunityName: leadController.leadContactNameController.value.text,
                                  customerId: leadController.selectedContactName.value!.id,
                                  productId: [
                                    ...leadController.selectedInterestProduct.map((e) => e.id),
                                    // ...leadController.selectedProducts.map((e) => e.id),
                                  ],
                                  expectedAmount: leadController.expectedRevenueController.value.text.isEmpty
                                      ? 0
                                      : double.tryParse(leadController.expectedRevenueController.value.text)?.toInt() ?? 0,
                                  probability: leadController.selectedProbability.value?.id ?? "",
                                  email: leadController.emailController.value.text,
                                  mobile1: leadController.mobileNumberController.value.text,
                                  mobile2: leadController.secondMobileNumberController.value.text,
                                  cityId: leadController.cityIdController.value.text,
                                  pinCodeId: leadController.pinCodeIdController.value.text,
                                  stateId: leadController.stateIdController.value.text,
                                  sourceId: leadController.selectedSource.value?.id ?? '',
                                  labelId: leadController.selectedLabel.value?.id ?? '',
                                  salesPersonId: leadController.selectedAssignSalesPerson.value?.id ?? Pref.getUserId(),
                                  expectedClosingDate: leadController.dateConverter(leadController.expectedClosingController.value.text),
                                  tags: leadController.selectedTags.map((e) => e.name).toList(),
                                  interest: leadController.interestController.value.text,
                                  remarks: leadController.remarksController.value.text,
                                  logList: leadController.logsList,
                                  activityList: leadController.activityList,
                                  secondarySalesPersonId: leadController.selectedFollowerAndViewer.map((e) => e.id!).toList(),
                                  productCategory: leadController.selectedProductCategory.value != null
                                      ? [leadController.selectedProductCategory.value!.id]
                                      : [],
                                );
                              }
                            }
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  void openProductCategoryBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Select Product Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = leadController.oppProductCategoryList;

                  if (list.isEmpty) {
                    return const Center(child: Text("No categories found"));
                  }

                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = list[index];

                      return Obx(() {
                        final isSelected = leadController.selectedProductCategory.value?.id == item.id;

                        return GestureDetector(
                          onTap: () {
                            leadController.selectedProductCategory.value = item;
                            leadController.updateSelectedProductText();
                            leadController.selectedInterestProduct.clear();
                            leadController.interestProductController.value.clear();
                            leadController.getInterestProduct(page: 1, categoryId: item.id, fromPagination: false);
                            Get.back();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.indigo600Main.withValues(alpha: 0.12) : AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSelected ? AppColors.indigo600Main : AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                ),
                                if (isSelected) const Icon(Icons.check_circle, color: AppColors.indigo600Main),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void openInterestProductBottomSheet(BuildContext context, ScrollController controller) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(
                        "Select Interest Product (${leadController.selectedInterestProduct.length})",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(onPressed: () => Get.back(), child: const Text("Done")),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = leadController.oppInterestProductList;
                  final isLoading = leadController.isInterestProductLoading.value;

                  if (isLoading && list.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
                  }

                  if (list.isEmpty && !isLoading) {
                    return const Center(child: Text("No product found"));
                  }

                  return ListView.separated(
                    controller: controller,
                    padding: EdgeInsets.zero,
                    itemCount: list.length + (isLoading ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index == list.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(color: AppColors.indigo600Main),
                          ),
                        );
                      }
                      final item = list[index];

                      return Obx(() {
                        final isSelected = leadController.selectedInterestProduct.any((e) => e.id == item.id);

                        return GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              leadController.selectedInterestProduct.removeWhere((e) => e.id == item.id);
                            } else {
                              leadController.selectedInterestProduct.add(item);
                            }
                            leadController.updateSelectedProductText();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.indigo600Main.withValues(alpha: 0.12) : AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSelected ? AppColors.indigo600Main : AppColors.border),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.imageUrl.isEmpty ? "" : item.imageUrl.first,
                                    height: 55,
                                    width: 55,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 50),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      Text("Code: ${item.productCode}", style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                if (isSelected) const Icon(Icons.check_circle, color: AppColors.indigo600Main),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void openAssignSalesPersonBottomSheet(BuildContext context, ScrollController controller, {bool isMulti = false}) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.75,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: commonTextField(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search Sales Person...",
                    controller: leadController.assignSalesPartnerSearchController.value,
                    needValidation: false,
                    onChange: (value) {
                      if (value.isEmpty || value.length % 3 == 0) {
                        leadController.salesPersonPageCount.value = 1;
                        leadController.getAssignSalesPerson(
                          page: leadController.salesPersonPageCount.value,
                          search: leadController.assignSalesPartnerSearchController.value.text,
                          fromPagination: false,
                        );
                      }
                    },
                  ),
                ),

                /// 🔹 PRODUCT LIST
                Expanded(
                  child: Obx(() {
                    final list = leadController.assignSalesPersonList;
                    if (list.isEmpty) {
                      return const Center(child: Text("No product found"));
                    }
                    return ListView.separated(
                      controller: controller,
                      padding: EdgeInsets.zero,
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = list[index];

                        return Obx(() {
                          final isSelected = leadController.selectedFollowerAndViewer.any((e) => e.id == item.id);
                          return GestureDetector(
                            onTap: () {
                              if (isMulti) {
                                if (isSelected) {
                                  leadController.selectedFollowerAndViewer.removeWhere((e) => e.id == item.id);
                                } else {
                                  leadController.selectedFollowerAndViewer.add(item);
                                }
                              } else {
                                leadController.selectedAssignSalesPerson.value = item;
                                leadController.assignSalesPersonController.value.text = "${item.firstName} ${item.lastName}";
                                Get.back();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text("${item.firstName!} ${item.lastName!}", style: const TextStyle(fontWeight: FontWeight.w600)),
                                  Spacer(),
                                  if (isMulti && isSelected) const Icon(Icons.check, color: AppColors.green500Success),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  bool isSelected(AssignSalesPerson item) {
    return leadController.selectedFollowerAndViewer.any((e) => e.id == item.id);
  }
}
