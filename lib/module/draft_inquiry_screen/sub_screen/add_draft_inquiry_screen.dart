import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../widget/button_view.dart';
import '../../../widget/dropdown.dart';
import '../../../widget/textfield.dart';
import '../../inquiry_screen/model/Inquiry_source_model.dart';
import '../../inquiry_screen/model/city_model.dart';
import '../../inquiry_screen/model/country_model.dart';
import '../../inquiry_screen/model/customer_group_response.dart';
import '../../inquiry_screen/model/state_model.dart';
import '../draft_inquiry_controller.dart';
import '../model/draft_inquiry_model.dart';

class AddDraftInquiryScreen extends StatefulWidget {
  final bool isEdit;
  final String? id;
  final DraftInquiryItem? item;

  const AddDraftInquiryScreen({super.key, this.isEdit = false, this.id, this.item});

  @override
  State<AddDraftInquiryScreen> createState() => _AddDraftInquiryScreenState();
}

class _AddDraftInquiryScreenState extends State<AddDraftInquiryScreen> {
  final DraftInquiryController controller = Get.find<DraftInquiryController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ScrollController pinCodeScrollController = ScrollController();
  final ScrollController cityScrollController = ScrollController();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      if (widget.item != null) {
        controller.prefillFromItem(widget.item!);
      }
      if (widget.id != null) {
        controller.getDraftInquiryDetail(id: widget.id!);
      }
    } else {
      controller.resetForm();
    }

    // Pincode pagination listener
    pinCodeScrollController.addListener(() {
      if (pinCodeScrollController.position.pixels >= pinCodeScrollController.position.maxScrollExtent - 200) {
        if (!controller.isPinCodeLoading.value && controller.pinCodeList.length < controller.pinCodeTotalCount.value) {
          controller.pinCodePageCount.value++;
          controller.getPinCodeApi(
            page: controller.pinCodePageCount.value,
            search: controller.pinCodeSearchController.value.text,
            cityId: controller.selectedCity.value != null ? controller.selectedCity.value!.id : "",
          );
        }
      }
    });

    // City pagination listener
    cityScrollController.addListener(() {
      if (cityScrollController.position.pixels >= cityScrollController.position.maxScrollExtent - 200) {
        if (!controller.isCityLoading.value && controller.cityList.length < controller.cityTotalCount.value) {
          controller.cityPageCount.value++;
          controller.getCityApi(
            page: controller.cityPageCount.value,
            search: controller.citySearchController.value.text,
            stateId: controller.selectedState.value != null ? controller.selectedState.value!.id : "",
            fromPagination: true,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    pinCodeScrollController.dispose();
    cityScrollController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------
  // Custom Validation: Either Mobile OR Email is mandatory
  // ----------------------------------------------------
  String? _validateMobile(String? value) {
    final mobile = value?.trim() ?? '';
    final email = controller.emailController.value.text.trim();

    if (mobile.isEmpty && email.isEmpty) {
      return 'Mobile or Email is required';
    }

    if (mobile.isNotEmpty) {
      if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
        return 'Mobile number must be 10 digits';
      }
      if (!RegExp(r'^[6-9]').hasMatch(mobile)) {
        return 'Indian mobile must start with 6, 7, 8, or 9';
      }
      if (RegExp(r'(\d)\1{4}').hasMatch(mobile)) {
        return 'Invalid mobile number';
      }
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    final mobile = controller.mobileNoController.value.text.trim();

    if (email.isEmpty && mobile.isEmpty) {
      return 'Mobile or Email is required';
    }

    if (email.isNotEmpty) {
      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
        return 'Please enter a valid email address';
      }
    }

    return null;
  }

  // ----------------------------------------------------
  // BottomSheets for Address Concept (Same as Add Inquiry)
  // ----------------------------------------------------
  void openPinCodeBottomSheet(BuildContext context, ScrollController scrollController) {
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
                  controller: controller.pinCodeSearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    if (value.length % 3 == 0) {
                      controller.pinCodePageCount.value = 1;
                      if (controller.selectedCity.value != null) {
                        controller.getPinCodeApi(
                          page: controller.pinCodePageCount.value,
                          search: value,
                          fromPagination: false,
                          cityId: controller.selectedCity.value!.id,
                        );
                      } else {
                        controller.getPinCodeApi(
                          page: controller.pinCodePageCount.value,
                          search: value,
                          fromPagination: false,
                        );
                      }
                    }
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = controller.pinCodeList;
                  final isLoading = controller.isPinCodeLoading.value;

                  if (isLoading && list.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
                  }

                  if (list.isEmpty && !isLoading) {
                    return const Center(child: Text("No data found"));
                  }

                  return ListView.separated(
                    controller: scrollController,
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
                          controller.pinCodeController.value.text = item.pinCode;
                          controller.cityController.value.text = item.cityId.name;
                          controller.stateController.value.text = item.stateId.name;
                          controller.countryController.value.text = item.countryId.name;
                          controller.selectedPinCode.value = item;
                          controller.selectedCity.value = CityDatum(
                            id: item.cityId.id,
                            name: item.cityId.name,
                            stateId: StateId(id: item.stateId.id, name: item.stateId.name),
                            countryId: StateId(id: item.countryId.id, name: item.countryId.name),
                          );
                          controller.selectedState.value = StateDatum(
                            id: item.stateId.id,
                            name: item.stateId.name,
                            countryId: CountryId(id: item.countryId.id, name: item.countryId.name),
                          );
                          controller.selectedCountry.value = CountryDatum(id: item.countryId.id, name: item.countryId.name);

                          Get.back();
                          controller.pinCodePageCount.value = 1;
                          controller.pinCodeSearchController.value.clear();
                          controller.getPinCodeApi(
                            page: controller.pinCodePageCount.value,
                            search: controller.pinCodeSearchController.value.text,
                            cityId: controller.selectedCity.value != null ? controller.selectedCity.value!.id : "",
                            fromPagination: false,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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

  void openCityBottomSheet(BuildContext context, ScrollController scrollController) {
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
                  controller: controller.citySearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    if (value.isEmpty || value.length % 3 == 0) {
                      controller.cityPageCount.value = 1;

                      if (controller.selectedState.value != null) {
                        controller.getCityApi(
                          page: controller.cityPageCount.value,
                          search: value,
                          fromPagination: false,
                          stateId: controller.selectedState.value!.id,
                        );
                      } else {
                        controller.getCityApi(
                          page: controller.cityPageCount.value,
                          search: value,
                          fromPagination: false,
                        );
                      }
                    }
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = controller.cityList;
                  final isLoading = controller.isCityLoading.value;

                  if (isLoading && list.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
                  }

                  if (list.isEmpty && !isLoading) {
                    return const Center(child: Text("No city found"));
                  }

                  return ListView.separated(
                    controller: scrollController,
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
                          controller.selectedCity.value = item;
                          controller.cityController.value.text = item.name;
                          controller.stateController.value.text = item.stateId.name;
                          controller.countryController.value.text = item.countryId.name;

                          controller.selectedPinCode.value = null;
                          controller.pinCodeController.value.clear();
                          controller.pinCodePageCount.value = 1;
                          controller.pinCodeSearchController.value.clear();
                          controller.getPinCodeApi(
                            page: controller.pinCodePageCount.value,
                            search: controller.pinCodeSearchController.value.text,
                            cityId: item.id,
                            fromPagination: false,
                          );
                          controller.selectedState.value = StateDatum(
                            id: item.stateId.id,
                            name: item.stateId.name,
                            countryId: CountryId(id: item.countryId.id, name: item.countryId.name),
                          );
                          controller.selectedCountry.value = CountryDatum(id: item.countryId.id, name: item.countryId.name);
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                  controller: controller.stateSearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    controller.getStateApi(search: value, countryId: controller.selectedCountry.value?.id);
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = controller.stateList;
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
                          controller.selectedState.value = item;
                          controller.stateController.value.text = item.name;
                          controller.selectedCountry.value = CountryDatum(id: item.countryId.id, name: item.countryId.name);
                          controller.countryController.value.text = item.countryId.name;

                          controller.selectedCity.value = null;
                          controller.cityController.value.clear();
                          controller.selectedPinCode.value = null;
                          controller.pinCodeController.value.clear();

                          controller.getCityApi(page: 1, stateId: item.id, fromPagination: false);
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                  controller: controller.countrySearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    controller.getCountry(search: value);
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = controller.countryList;
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
                          controller.selectedCountry.value = item;
                          controller.countryController.value.text = item.name;

                          controller.selectedState.value = null;
                          controller.stateController.value.clear();
                          controller.selectedCity.value = null;
                          controller.cityController.value.clear();
                          controller.selectedPinCode.value = null;
                          controller.pinCodeController.value.clear();

                          controller.getStateApi(countryId: item.id);
                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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

  Widget _buildSection({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 8))],
        border: Border.all(color: AppColors.gray100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.indigo600Main.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.indigo600Main, size: 20),
                const SizedBox(width: 10),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.indigo600Main, letterSpacing: 0.8),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.indigo600Main,
        title: Text(
          widget.isEdit ? "Update Draft Inquiry" : "Add Draft Inquiry",
          style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 20),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isDetailLoading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              autovalidateMode: _autoValidateMode,
              child: Column(
                children: [
                  // ----------------------------------------------------
                  // Section 1: Lead Source & Classification (Non-mandatory)
                  // Fields: 1. Source, 9. Client Type, 10. Customer Group & Customer Brand
                  // ----------------------------------------------------
                  _buildSection(
                    title: "Source & Classification",
                    icon: Icons.category_outlined,
                    children: [
                      // 1. Source (DropDown) - Non-mandatory
                      CustomDropdown<LeadSourceItem>(
                        compareFn: (a, b) => a?.id == b?.id,
                        hintText: 'Select Source',
                        items: (String filter, LoadProps? loadProps) {
                          if (filter.isEmpty) {
                            return controller.sourceList;
                          }
                          return controller.sourceList
                              .where((item) => item.name.toLowerCase().contains(filter.toLowerCase()))
                              .toList();
                        },
                        selectedItem: controller.selectedSource.value,
                        itemAsString: (item) {
                          if (item.name.isEmpty) {
                            final match = controller.sourceList.firstWhereOrNull((e) => e.id == item.id);
                            return match?.name ?? item.name;
                          }
                          return item.name;
                        },
                        onChanged: (value) {
                          controller.selectedSource.value = value;
                        },
                      ),

                      // 9. Client Type (DropDown) - Non-mandatory
                      CustomDropdown<LeadSourceItem>(
                        compareFn: (a, b) => a?.id == b?.id,
                        hintText: 'Select Client Type',
                        items: (String filter, LoadProps? loadProps) {
                          if (filter.isEmpty) {
                            return controller.clientTypeList;
                          }
                          return controller.clientTypeList
                              .where((item) => item.name.toLowerCase().contains(filter.toLowerCase()))
                              .toList();
                        },
                        selectedItem: controller.selectedClientType.value,
                        itemAsString: (item) {
                          if (item.name.isEmpty) {
                            final match = controller.clientTypeList.firstWhereOrNull((e) => e.id == item.id);
                            return match?.name ?? item.name;
                          }
                          return item.name;
                        },
                        onChanged: (value) {
                          controller.selectedClientType.value = value;
                        },
                      ),

                      // 10. Customer Group (DropDown) - Non-mandatory, Interdependent with Brand
                      CustomDropdown<CustomerGroupDatum>(
                        compareFn: (a, b) => a?.id == b?.id,
                        hintText: 'Select Customer Group',
                        items: (String filter, LoadProps? loadProps) {
                          if (filter.isEmpty) {
                            return controller.customerGroupList;
                          }
                          return controller.customerGroupList
                              .where((item) => item.name.toLowerCase().contains(filter.toLowerCase()))
                              .toList();
                        },
                        selectedItem: controller.selectedCustomerGroup.value,
                        itemAsString: (item) {
                          if (item.name.isEmpty) {
                            final match = controller.customerGroupList.firstWhereOrNull((e) => e.id == item.id);
                            return match?.name ?? item.name;
                          }
                          return item.name;
                        },
                        onChanged: (value) {
                          controller.onCustomerGroupSelected(value);
                        },
                      ),

                      // 10. Customer Brand (DropDown) - Non-mandatory, Interdependent with Group
                      CustomDropdown<CustomerGroupDatum>(
                        compareFn: (a, b) => a?.id == b?.id,
                        hintText: 'Select Customer Brand',
                        items: (String filter, LoadProps? loadProps) {
                          if (filter.isEmpty) {
                            return controller.customerBrandList;
                          }
                          return controller.customerBrandList
                              .where((item) => item.name.toLowerCase().contains(filter.toLowerCase()))
                              .toList();
                        },
                        selectedItem: controller.selectedCustomerBrand.value,
                        itemAsString: (item) {
                          if (item.name.isEmpty) {
                            final match = controller.customerBrandList.firstWhereOrNull((e) => e.id == item.id);
                            return match?.name ?? item.name;
                          }
                          return item.name;
                        },
                        onChanged: (value) {
                          controller.onCustomerBrandSelected(value);
                        },
                      ),
                    ],
                  ),

                  // ----------------------------------------------------
                  // Section 2: Contact & Company Details
                  // Mandatory: Person Name* AND (Either Mobile No OR Email)
                  // Non-mandatory: Company Name, Designation, Project Name
                  // ----------------------------------------------------
                  _buildSection(
                    title: "Contact & Company Details",
                    icon: Icons.person_outline,
                    children: [
                      // 2. Person Name (TextField) - MANDATORY
                      commonTextField(
                        labelText: "Person Name*",
                        hintText: "Enter Person Name",
                        controller: controller.personNameController.value,
                        needValidation: true,
                        validationMessage: "Person Name is required",
                        prefixIcon: const Icon(Icons.person_outline, size: 20),
                      ),

                      // 6. Designation (TextField) - Non-mandatory
                      commonTextField(
                        labelText: "Designation",
                        hintText: "Enter Designation",
                        controller: controller.designationController.value,
                        needValidation: false,
                        prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                      ),

                      // 3. Company Name (TextField) - Non-mandatory
                      commonTextField(
                        labelText: "Company Name",
                        hintText: "Enter Company Name",
                        controller: controller.companyNameController.value,
                        needValidation: false,
                        prefixIcon: const Icon(Icons.business_outlined, size: 20),
                      ),

                      // 8. Project Name (TextField) - Non-mandatory
                      commonTextField(
                        labelText: "Project Name",
                        hintText: "Enter Project Name",
                        controller: controller.projectNameController.value,
                        needValidation: false,
                        prefixIcon: const Icon(Icons.assignment_outlined, size: 20),
                      ),

                      const Padding(
                        padding: EdgeInsets.only(bottom: 10, top: 4),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: AppColors.indigo600Main),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Either Mobile Number or Email is mandatory",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.indigo600Main,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 4. Mobile No (TextField) - Mutual mandatory with Email
                      commonTextField(
                        labelText: "Mobile No",
                        hintText: "Enter 10-digit Mobile Number",
                        controller: controller.mobileNoController.value,
                        textInputType: TextInputType.phone,
                        isPhoneNumberValidator: true,
                        isOnlyInputDigits: true,
                        validator: _validateMobile,
                        onChange: (v) {
                          if (_autoValidateMode == AutovalidateMode.onUserInteraction) {
                            formKey.currentState?.validate();
                          }
                        },
                        prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                      ),

                      // 5. Email (TextField) - Mutual mandatory with Mobile
                      commonTextField(
                        labelText: "Email",
                        hintText: "e.g. example@gmail.com",
                        controller: controller.emailController.value,
                        textInputType: TextInputType.emailAddress,
                        isNoSpaceAllow: true,
                        validator: _validateEmail,
                        onChange: (v) {
                          if (_autoValidateMode == AutovalidateMode.onUserInteraction) {
                            formKey.currentState?.validate();
                          }
                        },
                        prefixIcon: const Icon(Icons.email_outlined, size: 20),
                      ),
                    ],
                  ),

                  // ----------------------------------------------------
                  // Section 3: Location Details (Non-mandatory, same as Add Inquiry concept)
                  // Fields: 7. Address, State, City, Pincode
                  // ----------------------------------------------------
                  _buildSection(
                    title: "Location Details",
                    icon: Icons.location_on_outlined,
                    children: [
                      // Address (Street) - Non-mandatory
                      commonTextField(
                        labelText: "Address",
                        hintText: "Enter Address",
                        controller: controller.addressController.value,
                        needValidation: false,
                        maxLine: 3,
                        prefixIcon: const Icon(Icons.home_work_outlined, size: 20),
                      ),

                      // Country - Non-mandatory
                      commonTextField(
                        labelText: "Country",
                        hintText: "Select Country...",
                        controller: controller.countryController.value,
                        needValidation: false,
                        readOnly: true,
                        onTap: () => openCountryBottomSheet(context),
                        suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.indigo600Main),
                        prefixIcon: const Icon(Icons.public_outlined, size: 20),
                      ),

                      // State - Non-mandatory
                      commonTextField(
                        labelText: "State",
                        hintText: "Select State...",
                        controller: controller.stateController.value,
                        needValidation: false,
                        readOnly: true,
                        onTap: () => openStateBottomSheet(context),
                        suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.indigo600Main),
                        prefixIcon: const Icon(Icons.map_outlined, size: 20),
                      ),

                      // City - Non-mandatory
                      commonTextField(
                        labelText: "City",
                        hintText: "Select City...",
                        controller: controller.cityController.value,
                        needValidation: false,
                        readOnly: true,
                        onTap: () => openCityBottomSheet(context, cityScrollController),
                        suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.indigo600Main),
                        prefixIcon: const Icon(Icons.location_city_outlined, size: 20),
                      ),

                      // Pincode - Non-mandatory
                      commonTextField(
                        labelText: "Pincode",
                        hintText: "Select Pincode...",
                        controller: controller.pinCodeController.value,
                        needValidation: false,
                        readOnly: true,
                        onTap: () => openPinCodeBottomSheet(context, pinCodeScrollController),
                        suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.indigo600Main),
                        prefixIcon: const Icon(Icons.pin_drop_outlined, size: 20),
                      ),
                    ],
                  ),

                  // ----------------------------------------------------
                  // Section 4: Remarks (Non-mandatory)
                  // Field: 11. Remarks
                  // ----------------------------------------------------
                  _buildSection(
                    title: "Additional Information",
                    icon: Icons.notes_outlined,
                    children: [
                      // 11. Remarks (TextField) - Non-mandatory
                      commonTextField(
                        labelText: "Remarks",
                        hintText: "Enter Remarks",
                        controller: controller.remarksController.value,
                        needValidation: false,
                        maxLine: 3,
                        prefixIcon: const Icon(Icons.notes_outlined, size: 20),
                      ),
                    ],
                  ),

                  // ----------------------------------------------------
                  // Submit Button
                  // ----------------------------------------------------
                  commonButton(
                    name: widget.isEdit ? "UPDATE DRAFT INQUIRY" : "SUBMIT DRAFT INQUIRY",
                    bgColor: AppColors.indigo600Main,
                    textColor: AppColors.white,
                    isLoader: controller.isLoading.value,
                    loaderColorWhite: true,
                    radius: 16,
                    height: 52,
                    onTap: () {
                      setState(() {
                        _autoValidateMode = AutovalidateMode.onUserInteraction;
                      });
                      if (formKey.currentState!.validate() && !controller.isLoading.value) {
                        controller.submitDraftInquiry(isEdit: widget.isEdit, id: widget.id);
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
