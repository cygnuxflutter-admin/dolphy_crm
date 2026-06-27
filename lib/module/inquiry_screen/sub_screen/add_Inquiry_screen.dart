import 'package:crm/module/inquiry_screen/Inquiry_controller.dart';
import 'package:crm/module/inquiry_screen/model/city_model.dart';
import 'package:crm/module/inquiry_screen/model/customer_group_response.dart';
import 'package:crm/module/inquiry_screen/sub_screen/add_address_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../config/app_colors.dart';
import '../../../widget/dropdown.dart';
import '../../../widget/textfield.dart';
import '../model/Inquiry_source_model.dart';
import '../model/country_model.dart';
import '../model/state_model.dart';

class AddInquiryScreen extends StatefulWidget {
  final bool isEdit;
  final String? id;

  const AddInquiryScreen({super.key, this.isEdit = false, this.id});

  @override
  State<AddInquiryScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends State<AddInquiryScreen> {
  final InquiryScreenController inquiryScreenController = Get.find<InquiryScreenController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController pinCodeScrollController = ScrollController();
  final ScrollController cityScrollController = ScrollController();

  @override
  void initState() {
    pinCodeScrollController.addListener(() {
      if (pinCodeScrollController.position.pixels >= pinCodeScrollController.position.maxScrollExtent - 200) {
        if (inquiryScreenController.isPinCodeLoading.value == false &&
            inquiryScreenController.pinCodeList.length < inquiryScreenController.pinCodeTotalCount.value) {
          inquiryScreenController.pinCodePageCount.value++;
          inquiryScreenController.getPinCodeApi(
            page: inquiryScreenController.pinCodePageCount.value,
            search: inquiryScreenController.pinCodeSearchController.value.text,
            cityId: inquiryScreenController.selectedCity.value != null ? inquiryScreenController.selectedCity.value!.id : "",
          );
        }
      }
    });
    cityScrollController.addListener(() {
      if (cityScrollController.position.pixels >= cityScrollController.position.maxScrollExtent - 200) {
        if (inquiryScreenController.isCityLoading.value == false &&
            inquiryScreenController.cityList.length < inquiryScreenController.cityTotalCount.value) {
          inquiryScreenController.cityPageCount.value++;
          inquiryScreenController.getCityApi(
            page: inquiryScreenController.cityPageCount.value,
            search: inquiryScreenController.citySearchController.value.text,
            stateId: inquiryScreenController.selectedState.value != null ? inquiryScreenController.selectedState.value!.id : "",
            fromPagination: true,
          );
        }
      }
    });

    if (widget.isEdit == false) {
      inquiryScreenController.selectedGstTreatmentType.value = null;
      inquiryScreenController.gstInController.value.clear();
      inquiryScreenController.panNumberController.value.clear();
      inquiryScreenController.nameController.value.clear();
      inquiryScreenController.companyNameController.value.clear();
      inquiryScreenController.emailIdController.value.clear();
      inquiryScreenController.projectNameController.value.clear();
      inquiryScreenController.mobileNumberController.value.clear();
      inquiryScreenController.phoneNumberController.value.clear();
      inquiryScreenController.selectedLeadSourceItemType.value = null;
      inquiryScreenController.webSiteController.value.clear();
      inquiryScreenController.streetController.value.clear();
      inquiryScreenController.selectedCountry.value = null;
      inquiryScreenController.selectedState.value = null;
      inquiryScreenController.selectedCity.value = null;
      inquiryScreenController.countryController.value.clear();
      inquiryScreenController.stateController.value.clear();
      inquiryScreenController.cityController.value.clear();
      inquiryScreenController.pinCodeNumberController.value.clear();
      inquiryScreenController.selectedPinCode.value = null;
      inquiryScreenController.pinCodeSearchController.value.clear();
      inquiryScreenController.selectedLeadTagsType.value = [];
      inquiryScreenController.selectedPriceType.value = inquiryScreenController.priceTypeList.isNotEmpty
          ? inquiryScreenController.priceTypeList.first
          : null;
      inquiryScreenController.selectedCustomerBrandType.value = null;
      inquiryScreenController.selectedCustomerGroupType.value = null;
      inquiryScreenController.remarksController.value.clear();
      inquiryScreenController.addAddressList.clear();
    } else {
      inquiryScreenController.getInquiryView(id: widget.id!, isFromEdit: widget.isEdit).then((_) {
        inquiryScreenController.countryController.value.text = inquiryScreenController.selectedCountry.value?.name ?? "";
        inquiryScreenController.stateController.value.text = inquiryScreenController.selectedState.value?.name ?? "";
      });
    }
    inquiryScreenController.getCountry();
    inquiryScreenController.getStateApi();
    inquiryScreenController.getPriceType();
    inquiryScreenController.getLeadSourceItem();
    inquiryScreenController.getLeadTagsType();
    inquiryScreenController.getCustomerGroup();
    inquiryScreenController.getCustomerBrand();
    inquiryScreenController.getAddressType();
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
                  controller: inquiryScreenController.pinCodeSearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    if (value.length % 3 == 0) {
                      inquiryScreenController.pinCodePageCount.value = 1;
                      if (inquiryScreenController.selectedCity.value != null) {
                        inquiryScreenController.getPinCodeApi(
                          page: inquiryScreenController.pinCodePageCount.value,
                          search: value,
                          fromPagination: false,
                          cityId: inquiryScreenController.selectedCity.value!.id,
                        );
                      } else {
                        inquiryScreenController.getPinCodeApi(
                          page: inquiryScreenController.pinCodePageCount.value,
                          search: value,
                          fromPagination: false,
                        );
                      }
                    }
                  },
                ),
              ),

              /// 🔹 PRODUCT LIST
              Expanded(
                child: Obx(() {
                  final list = inquiryScreenController.pinCodeList;
                  final isLoading = inquiryScreenController.isPinCodeLoading.value;

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
                          inquiryScreenController.pinCodeNumberController.value.text = item.pinCode;
                          inquiryScreenController.cityController.value.text = item.cityId.name;
                          inquiryScreenController.stateController.value.text = item.stateId.name;
                          inquiryScreenController.countryController.value.text = item.countryId.name;
                          inquiryScreenController.selectedPinCode.value = item;
                          inquiryScreenController.selectedCity.value = CityDatum(
                            id: item.cityId.id,
                            name: item.cityId.name,
                            stateId: StateId(id: item.stateId.id, name: item.stateId.name),
                            countryId: StateId(id: item.countryId.id, name: item.countryId.name),
                          );
                          inquiryScreenController.selectedState.value = StateDatum(
                            id: item.stateId.id,
                            name: item.stateId.name,
                            countryId: CountryId(id: item.countryId.id, name: item.countryId.name),
                          );
                          inquiryScreenController.selectedCountry.value = CountryDatum(id: item.countryId.id, name: item.countryId.name);

                          Get.back();
                          inquiryScreenController.pinCodePageCount.value = 1;
                          inquiryScreenController.pinCodeSearchController.value.clear();
                          inquiryScreenController.getPinCodeApi(
                            page: inquiryScreenController.pinCodePageCount.value,
                            search: inquiryScreenController.pinCodeSearchController.value.text,
                            cityId: inquiryScreenController.selectedCity.value != null ? inquiryScreenController.selectedCity.value!.id : "",
                            fromPagination: false,
                          );
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
                  margin: EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppColors.gray300, borderRadius: BorderRadius.all(Radius.circular(2))),
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
                  controller: inquiryScreenController.citySearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    if (value.isEmpty || value.length % 3 == 0) {
                      inquiryScreenController.cityPageCount.value = 1;

                      if (inquiryScreenController.selectedState.value != null) {
                        inquiryScreenController.getCityApi(
                          page: inquiryScreenController.cityPageCount.value,
                          search: value,
                          fromPagination: false,
                          stateId: inquiryScreenController.selectedState.value!.id,
                        );
                      } else {
                        inquiryScreenController.getPinCodeApi(
                          page: inquiryScreenController.cityPageCount.value,
                          search: value,
                          fromPagination: false,
                        );
                      }
                    }
                  },
                ),
              ),

              /// 🔹 PRODUCT LIST
              Expanded(
                child: Obx(() {
                  final list = inquiryScreenController.cityList;
                  final isLoading = inquiryScreenController.isCityLoading.value;

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
                          inquiryScreenController.selectedCity.value = item;
                          inquiryScreenController.cityController.value.text = item.name;
                          inquiryScreenController.stateController.value.text = item.stateId.name;
                          inquiryScreenController.countryController.value.text = item.countryId.name;

                          inquiryScreenController.selectedPinCode.value = null;
                          inquiryScreenController.pinCodeNumberController.value.clear();
                          inquiryScreenController.pinCodePageCount.value = 1;
                          inquiryScreenController.pinCodeSearchController.value.clear();
                          inquiryScreenController.getPinCodeApi(
                            page: inquiryScreenController.pinCodePageCount.value,
                            search: inquiryScreenController.pinCodeSearchController.value.text,
                            cityId: item.id,
                            fromPagination: false,
                          );
                          inquiryScreenController.selectedState.value = StateDatum(
                            id: item.stateId.id,
                            name: item.stateId.name,
                            countryId: CountryId(id: item.countryId.id, name: item.countryId.name),
                          );
                          inquiryScreenController.selectedCountry.value = CountryDatum(id: item.countryId.id, name: item.countryId.name);
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
                  controller: inquiryScreenController.countrySearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    inquiryScreenController.getCountry(search: value);
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = inquiryScreenController.countryList;
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
                          inquiryScreenController.selectedCountry.value = item;
                          inquiryScreenController.countryController.value.text = item.name;

                          inquiryScreenController.selectedState.value = null;
                          inquiryScreenController.stateController.value.clear();
                          inquiryScreenController.selectedCity.value = null;
                          inquiryScreenController.cityController.value.clear();
                          inquiryScreenController.selectedPinCode.value = null;
                          inquiryScreenController.pinCodeNumberController.value.clear();

                          inquiryScreenController.getStateApi(countryId: item.id);
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
                  controller: inquiryScreenController.stateSearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    inquiryScreenController.getStateApi(search: value, countryId: inquiryScreenController.selectedCountry.value?.id);
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = inquiryScreenController.stateList;
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
                          inquiryScreenController.selectedState.value = item;
                          inquiryScreenController.stateController.value.text = item.name;
                          inquiryScreenController.selectedCountry.value = CountryDatum(id: item.countryId.id, name: item.countryId.name);
                          inquiryScreenController.countryController.value.text = item.countryId.name;

                          inquiryScreenController.selectedCity.value = null;
                          inquiryScreenController.cityController.value.clear();
                          inquiryScreenController.selectedPinCode.value = null;
                          inquiryScreenController.pinCodeNumberController.value.clear();

                          inquiryScreenController.getCityApi(page: 1, stateId: item.id, fromPagination: false);
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

  void commomBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    TextEditingController controller,
    dynamic Function(String)? onChange,
    String hintText,
    Function onTap,
    dynamic list,
  ) {
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
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: commonTextField(
                    prefixIcon: const Icon(Icons.search),
                    hintText: hintText,
                    controller: controller,
                    needValidation: false,
                    onChange: onChange,
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (list.isEmpty) {
                      return const Center(child: Text("No product found"));
                    }
                    return ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return GestureDetector(
                          onTap: () => onTap,
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
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
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
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
          "${widget.isEdit ? "Update" : "Add"} Inquiry",
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
          return widget.isEdit && inquiryScreenController.isLeadEditLoading.value
              ? const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _buildSection(
                          title: "Tax & Date Information",
                          icon: Icons.receipt_long_outlined,
                          children: [
                            /* CustomDropdown<String>(
                              enabled: false,
                              hintText: 'Select GST Treatment',
                              items: (String filter, LoadProps? loadProps) {
                                return inquiryScreenController.gstTreatmentList;
                              },
                              itemAsString: (item) => item,
                              selectedItem: inquiryScreenController.selectedGstTreatmentType.value,
                              onChanged: (value) {
                                inquiryScreenController.selectedGstTreatmentType.value = value!;
                              },
                            ),*/
                            commonTextField(
                              labelText: "GST IN",
                              hintText: "e.g. 22ABCDE1234F1Z5",
                              controller: inquiryScreenController.gstInController.value,
                              onChange: (v) {
                                if (v.length == 15) {
                                  inquiryScreenController.panNumberController.value.text = v.trim().substring(2, 12);
                                  inquiryScreenController.getGst(v);
                                }
                              },
                              isGstInputValidator: true,
                            ),
                            commonTextField(
                              labelText: "PAN",
                              hintText: "e.g. ABCDE1234F",
                              controller: inquiryScreenController.panNumberController.value,
                              isPanInputValidator: true,
                            ),
                            /* commonTextField(
                              needValidation: true,
                              validationMessage: "Lead Date",
                              labelText: "Lead Date*",
                              hintText: "Select Lead Date",
                              controller: inquiryScreenController.leadDateController.value,
                              suffixIcon: const Icon(Icons.calendar_month, color: AppColors.indigo600Main),
                              textInputType: TextInputType.none,
                              readOnly: true,
                              onTap: () => _selectDate(context),
                            ),*/
                          ],
                        ),
                        _buildSection(
                          title: "Personal Information",
                          icon: Icons.person_outline,
                          children: [
                            commonTextField(
                              labelText: "Person Name*",
                              hintText: "Enter Name",
                              controller: inquiryScreenController.nameController.value,
                              needValidation: true,
                              validationMessage: "Name is required",
                              prefixIcon: const Icon(Icons.person_outline, size: 20),
                            ),
                            commonTextField(
                              labelText: "Company Name",
                              hintText: "Enter Company Name",
                              controller: inquiryScreenController.companyNameController.value,
                              needValidation: false,
                              prefixIcon: const Icon(Icons.business_outlined, size: 20),
                            ),
                            commonTextField(
                              labelText: "Project Name",
                              hintText: "Enter Project Name",
                              controller: inquiryScreenController.projectNameController.value,
                              prefixIcon: const Icon(Icons.assignment_outlined, size: 20),
                            ),
                            commonTextField(
                              labelText: "Email",
                              hintText: "e.g. example@gmail.com",
                              controller: inquiryScreenController.emailIdController.value,
                              textInputType: TextInputType.emailAddress,
                              isEmailValidator: true,
                              prefixIcon: const Icon(Icons.email_outlined, size: 20),
                            ),
                            commonTextField(
                              labelText: "Website",
                              hintText: "e.g. www.example.com",
                              controller: inquiryScreenController.webSiteController.value,
                              prefixIcon: const Icon(Icons.language_outlined, size: 20),
                            ),
                          ],
                        ),
                        _buildSection(
                          title: "Contact Details",
                          icon: Icons.phone_outlined,
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
                                          groupValue: inquiryScreenController.phoneType.value,
                                          onChanged: (v) => inquiryScreenController.phoneType.value = v!,
                                          activeColor: AppColors.indigo600Main,
                                        ),
                                        const Text("Mobile"),
                                        const Spacer(),
                                        Radio(
                                          value: "Landline",
                                          groupValue: inquiryScreenController.phoneType.value,
                                          onChanged: (v) => inquiryScreenController.phoneType.value = v!,
                                          activeColor: AppColors.indigo600Main,
                                        ),
                                        const Text("Landline"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (inquiryScreenController.phoneType.value == "Mobile")
                              Column(
                                children: [
                                  IntlPhoneField(
                                    controller: inquiryScreenController.mobileNumberController.value,
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
                                        borderSide: const BorderSide(color: AppColors.indigo600Main, width: 1.6),
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
                                      inquiryScreenController.mobileNumberController.value.text = phone.number;
                                    },
                                    onCountryChanged: (country) {
                                      inquiryScreenController.mobileNumberCountryCodeController.value.text = country.code;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  IntlPhoneField(
                                    controller: inquiryScreenController.phoneNumberController.value,
                                    validator: (phone) {
                                      if (phone == null || phone.number.isEmpty) {
                                        return null;
                                      }
                                      if (phone.number.length < 7) {
                                        return "Please enter a valid mobile number";
                                      }
                                      return null;
                                    },
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
                                        borderSide: const BorderSide(color: AppColors.indigo600Main, width: 1.6),
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
                                      inquiryScreenController.phoneNumberController.value.text = phone.number;
                                    },
                                    onCountryChanged: (country) {
                                      inquiryScreenController.phoneNumberCountryCodeController.value.text = country.code;
                                    },
                                  ),
                                ],
                              )
                            else
                              commonTextField(
                                labelText: "Landline Number",
                                hintText: "Enter Landline Number",
                                controller: inquiryScreenController.landlineNumberController.value,
                                textInputType: TextInputType.number,
                                isPhoneNumberValidator: true,
                                prefixIcon: const Icon(Icons.phone_callback_outlined, size: 20),
                              ),
                          ],
                        ),
                        _buildSection(
                          title: "Lead Source & Classification",
                          icon: Icons.category_outlined,
                          children: [
                            CustomDropdown<LeadSourceItem>(
                              compareFn: (a, b) => a?.id == b?.id,
                              hintText: 'Select Source*',
                              items: (String filter, LoadProps? loadProps) {
                                return inquiryScreenController.leadSourceItemList;
                              },
                              selectedItem: inquiryScreenController.selectedLeadSourceItemType.value,
                              itemAsString: (item) {
                                if (item.name.isEmpty) {
                                  final match = inquiryScreenController.leadSourceItemList.firstWhere((e) => e.id == item.id, orElse: () => item);
                                  return match.name;
                                }
                                return item.name;
                              },
                              onChanged: (value) {
                                inquiryScreenController.selectedLeadSourceItemType.value = value!;
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Source is required';
                                }
                                return null;
                              },
                            ),
                            Obx(() {
                              return MultiDropdown<LeadSourceItem>(
                                controller: inquiryScreenController.leadTagController,
                                items: inquiryScreenController.leadTagsTypeList
                                    .map((item) => DropdownItem<LeadSourceItem>(label: item.name, value: item))
                                    .toList(),
                                onSelectionChange: (selectedItems) {
                                  inquiryScreenController.selectedLeadTagsType.value = selectedItems.map((e) => e).toList();
                                },
                                searchEnabled: true,
                                fieldDecoration: FieldDecoration(
                                  hintText: "Select Tag",
                                  labelText: 'Customer Tag',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.border, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.indigo600Main, width: 1.5),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.redColor, width: 1),
                                  ),
                                  showClearIcon: false,
                                ),
                                chipDecoration: const ChipDecoration(
                                  backgroundColor: AppColors.indigo50,
                                  labelStyle: TextStyle(color: AppColors.indigo600Main, fontWeight: FontWeight.bold, fontSize: 11),
                                  wrap: true,
                                  spacing: 4,
                                  runSpacing: 4,
                                ),
                                dropdownDecoration: const DropdownDecoration(marginTop: 8, maxHeight: 240),
                              );
                            }),
                            const SizedBox(height: 16),
                            CustomDropdown<CustomerGroupDatum>(
                              compareFn: (a, b) => a?.id == b?.id,
                              hintText: 'Customer Group',
                              items: (String filter, LoadProps? loadProps) {
                                return inquiryScreenController.customerGroupDataList;
                              },
                              selectedItem: inquiryScreenController.selectedCustomerGroupType.value,
                              itemAsString: (item) {
                                if (item.name.isEmpty) {
                                  final match = inquiryScreenController.customerGroupDataList.firstWhere((e) => e.id == item.id, orElse: () => item);
                                  return match.name;
                                }
                                return item.name;
                              },
                              onChanged: (value) {
                                inquiryScreenController.selectedCustomerGroupType.value = value!;
                              },
                            ),
                            CustomDropdown<CustomerGroupDatum>(
                              compareFn: (a, b) => a?.id == b?.id,
                              hintText: 'Customer Brand',
                              items: (String filter, LoadProps? loadProps) {
                                return inquiryScreenController.customerBrandDataList;
                              },
                              selectedItem: inquiryScreenController.selectedCustomerBrandType.value,
                              itemAsString: (item) {
                                if (item.name.isEmpty) {
                                  final match = inquiryScreenController.customerBrandDataList.firstWhere((e) => e.id == item.id, orElse: () => item);
                                  return match.name;
                                }
                                return item.name;
                              },
                              onChanged: (value) {
                                inquiryScreenController.selectedCustomerBrandType.value = value!;
                              },
                            ),
                            CustomDropdown<LeadSourceItem>(
                              compareFn: (a, b) => a?.id == b?.id,
                              hintText: 'Select Price Type',
                              items: (filter, loadProps) => inquiryScreenController.priceTypeList,
                              selectedItem: inquiryScreenController.selectedPriceType.value,
                              itemAsString: (item) => item.name,
                              onChanged: (value) {
                                inquiryScreenController.selectedPriceType.value = value!;
                              },
                            ),
                          ],
                        ),
                        _buildSection(
                          title: "Location Details",
                          icon: Icons.location_on_outlined,
                          children: [
                            commonTextField(
                              labelText: "Address",
                              hintText: "Address",
                              controller: inquiryScreenController.streetController.value,
                              needValidation: false,
                              maxLine: 3,
                              prefixIcon: const Icon(Icons.home_work_outlined, size: 20),
                            ),
                            commonTextField(
                              labelText: "Country",
                              hintText: "Select Country...",
                              controller: inquiryScreenController.countryController.value,
                              needValidation: false,
                              readOnly: true,
                              onTap: () => openCountryBottomSheet(context),
                              suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.indigo600Main),
                              prefixIcon: const Icon(Icons.public_outlined, size: 20),
                            ),
                            commonTextField(
                              labelText: "State",
                              hintText: "Select State...",
                              controller: inquiryScreenController.stateController.value,
                              needValidation: false,
                              readOnly: true,
                              onTap: () => openStateBottomSheet(context),
                              suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.indigo600Main),
                              prefixIcon: const Icon(Icons.map_outlined, size: 20),
                            ),
                            commonTextField(
                              labelText: "City",
                              hintText: "Select City...",
                              controller: inquiryScreenController.cityController.value,
                              needValidation: false,
                              readOnly: true,
                              onTap: () => openCityBottomSheet(context, cityScrollController),
                              suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.indigo600Main),
                              prefixIcon: const Icon(Icons.location_city_outlined, size: 20),
                            ),
                            commonTextField(
                              labelText: "Pincode",
                              hintText: "Select Pincode...",
                              controller: inquiryScreenController.pinCodeNumberController.value,
                              needValidation: false,
                              readOnly: true,
                              onTap: () => openPinCodeBottomSheet(context, pinCodeScrollController),
                              suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.indigo600Main),
                              prefixIcon: const Icon(Icons.pin_drop_outlined, size: 20),
                            ),
                          ],
                        ),
                        _buildSection(
                          title: "Additional Remarks",
                          icon: Icons.notes_outlined,
                          children: [
                            commonTextField(
                              labelText: "Remarks*",
                              hintText: "Enter Remarks",
                              controller: inquiryScreenController.remarksController.value,
                              needValidation: true,
                              validationMessage: "Remarks is required",
                              maxLine: 4,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.indigo600Main.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.indigo600Main.withValues(alpha: 0.1)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.map_outlined, color: AppColors.indigo600Main, size: 22),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      "Additional Addresses",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.indigo600Main),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      Get.to(() => AddAddressScreen());
                                      inquiryScreenController.addAddressPinCodeSearchController.value.clear();
                                      inquiryScreenController.addAddressCitySearchController.value.clear();
                                      inquiryScreenController.getAddAddressCityApi(page: 1, search: '', fromPagination: false);
                                      inquiryScreenController.getAddAddressPinCodeApi(page: 1, search: "", fromPagination: false);
                                    },
                                    icon: const Icon(Icons.add_circle_outline, size: 18),
                                    label: const Text("ADD", style: TextStyle(fontWeight: FontWeight.bold)),
                                    style: TextButton.styleFrom(foregroundColor: AppColors.indigo600Main),
                                  ),
                                ],
                              ),
                              if (inquiryScreenController.addAddressList.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: inquiryScreenController.addAddressList.length,
                                  itemBuilder: (context, index) {
                                    final item = inquiryScreenController.addAddressList[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.gray200),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: AppColors.indigo600Main.withValues(alpha: 0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.location_on, size: 14, color: AppColors.indigo600Main),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(item.contactName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () {
                                                  inquiryScreenController.selectedAddressType.value = null;
                                                  inquiryScreenController.addAddressNameController.value.clear();
                                                  inquiryScreenController.addAddressMobileNumberController.value.clear();
                                                  inquiryScreenController.addAddressController.value.clear();
                                                  inquiryScreenController.addAddressPinCodeNumberController.value.clear();
                                                  inquiryScreenController.addAddressCityController.value.clear();
                                                  inquiryScreenController.selectedAddAddressCity.value = null;
                                                  inquiryScreenController.selectedAddAddressState.value = null;
                                                  inquiryScreenController.selectedAddAddressPinCode.value = null;
                                                  inquiryScreenController.selectedAddAddressCountry.value = null;
                                                  inquiryScreenController.addAddressDesignationController.value.clear();
                                                  inquiryScreenController.addAddressInternalNotesController.value.clear();
                                                  Get.to(() => AddAddressScreen(isEdit: true, index: index));
                                                },
                                                icon: const Icon(Icons.edit_outlined, color: AppColors.indigo600Main, size: 20),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                              const SizedBox(width: 12),
                                              IconButton(
                                                onPressed: () => inquiryScreenController.addAddressList.removeAt(index),
                                                icon: const Icon(Icons.delete_outline, color: AppColors.red500, size: 20),
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8.0),
                                            child: Divider(height: 1, color: AppColors.gray100),
                                          ),
                                          Text(item.street, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                                          Text(
                                            "${item.pincodeId.pinCode} , ${item.countryId.name}",
                                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                          ),
                                          Text(
                                            "Phone : ${item.mobile1}",
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate() && !inquiryScreenController.isLoading.value) {
                                widget.isEdit
                                    ? inquiryScreenController.leadUpdate(id: inquiryScreenController.leadViewData.value!.id!)
                                    : inquiryScreenController.leadSubmit();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.indigo600Main,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                              shadowColor: AppColors.indigo600Main.withValues(alpha: 0.4),
                            ),
                            child: inquiryScreenController.isLoading.value
                                ? const CircularProgressIndicator(color: AppColors.white)
                                : Text(
                                    widget.isEdit ? "UPDATE INQUIRY" : "SUBMIT INQUIRY",
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1),
                                  ),
                          ),
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
