import 'package:crm/config/app_colors.dart';
import 'package:crm/module/inquiry_screen/model/city_model.dart';
import 'package:crm/module/inquiry_screen/model/country_model.dart';
import 'package:crm/module/inquiry_screen/model/state_model.dart';
import 'package:crm/module/lead_screen/lead_controller.dart';
import 'package:crm/widget/textfield.dart';
import 'package:crm/widget/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateContactPersonScreen extends StatefulWidget {
  final String customerId;

  const CreateContactPersonScreen({super.key, required this.customerId});

  @override
  State<CreateContactPersonScreen> createState() => _CreateContactPersonScreenState();
}

class _CreateContactPersonScreenState extends State<CreateContactPersonScreen> {
  final LeadController leadController = Get.find<LeadController>();
  final ScrollController pinCodeScrollController = ScrollController();
  final ScrollController cityScrollController = ScrollController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    leadController.clearCPData();

    pinCodeScrollController.addListener(() {
      if (pinCodeScrollController.position.pixels >= pinCodeScrollController.position.maxScrollExtent - 200) {
        if (leadController.isCPPinCodeLoading.value == false && leadController.cpPinCodeList.length < leadController.cpPinCodeTotalCount.value) {
          leadController.cpPinCodePageCount.value++;
          leadController.getPinCodeApi(
            page: leadController.cpPinCodePageCount.value,
            search: leadController.cpPinCodeSearchController.value.text,
            cityId: leadController.cpSelectedCity.value != null ? leadController.cpSelectedCity.value!.id : "",
            isCP: true,
          );
        }
      }
    });

    cityScrollController.addListener(() {
      if (cityScrollController.position.pixels >= cityScrollController.position.maxScrollExtent - 200) {
        if (leadController.isCPCityLoading.value == false && leadController.cpCityList.length < leadController.cpCityTotalCount.value) {
          leadController.cpCityPageCount.value++;
          leadController.getCityApi(
            page: leadController.cpCityPageCount.value,
            search: leadController.cpCitySearchController.value.text,
            stateId: leadController.cpSelectedState.value != null ? leadController.cpSelectedState.value!.id : "",
            fromPagination: true,
            isCP: true,
          );
        }
      }
    });

    leadController.getCountry(isCP: true);
    leadController.getStateApi(isCP: true);
    leadController.getCityApi(page: 1, fromPagination: false, isCP: true);
    leadController.getPinCodeApi(page: 1, fromPagination: false, isCP: true);
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
                  controller: leadController.cpPinCodeSearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    if (value.length % 3 == 0) {
                      leadController.cpPinCodePageCount.value = 1;
                      final cityId = leadController.cpSelectedCity.value?.id;

                      if (cityId != null) {
                        leadController.getPinCodeApi(
                          page: leadController.cpPinCodePageCount.value,
                          search: value,
                          fromPagination: false,
                          cityId: cityId,
                          isCP: true,
                        );
                      } else {
                        leadController.getPinCodeApi(page: leadController.cpPinCodePageCount.value, search: value, fromPagination: false, isCP: true);
                      }
                    }
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = leadController.cpPinCodeList;
                  final isLoading = leadController.isCPPinCodeLoading.value;

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
                          leadController.cpPinCodeController.value.text = item.pinCode;
                          leadController.cpPinCodeIdController.value.text = item.id;
                          leadController.cpCityController.value.text = item.cityId.name;
                          leadController.cpCityIdController.value.text = item.cityId.id;
                          leadController.cpStateController.value.text = item.stateId.name;
                          leadController.cpStateIdController.value.text = item.stateId.id;
                          leadController.cpCountryController.value.text = item.countryId.name;
                          leadController.cpSelectedPinCode.value = item;
                          leadController.cpSelectedCountry.value = CountryDatum(id: item.countryId.id, name: item.countryId.name);
                          leadController.cpSelectedCity.value = CityDatum(
                            id: item.cityId.id,
                            name: item.cityId.name,
                            stateId: StateId(id: item.stateId.id, name: item.stateId.name),
                            countryId: StateId(id: item.countryId.id, name: item.countryId.name),
                          );
                          leadController.cpSelectedState.value = StateDatum(
                            id: item.stateId.id,
                            name: item.stateId.name,
                            countryId: CountryId(id: item.countryId.id, name: item.countryId.name),
                          );

                          Get.back();
                          leadController.cpPinCodePageCount.value = 1;
                          leadController.cpPinCodeSearchController.value.clear();
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
                  controller: leadController.cpCitySearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    if (value.isEmpty || value.length % 3 == 0) {
                      leadController.cpCityPageCount.value = 1;

                      final stateId = leadController.cpSelectedState.value?.id;

                      if (stateId != null) {
                        leadController.getCityApi(
                          page: leadController.cpCityPageCount.value,
                          search: value,
                          fromPagination: false,
                          stateId: stateId,
                          isCP: true,
                        );
                      } else {
                        leadController.getCityApi(page: leadController.cpCityPageCount.value, search: value, fromPagination: false, isCP: true);
                      }
                    }
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = leadController.cpCityList;
                  final isLoading = leadController.isCPCityLoading.value;

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
                          leadController.cpSelectedCity.value = item;
                          leadController.cpCityController.value.text = item.name;
                          leadController.cpCityIdController.value.text = item.id;
                          leadController.cpStateController.value.text = item.stateId.name;
                          leadController.cpStateIdController.value.text = item.stateId.id;

                          leadController.cpSelectedPinCode.value = null;
                          leadController.cpPinCodeController.value.clear();
                          leadController.cpPinCodeIdController.value.clear();
                          leadController.cpPinCodePageCount.value = 1;
                          leadController.cpPinCodeSearchController.value.clear();
                          leadController.getPinCodeApi(
                            page: leadController.cpPinCodePageCount.value,
                            search: leadController.cpPinCodeSearchController.value.text,
                            cityId: item.id,
                            fromPagination: false,
                            isCP: true,
                          );
                          leadController.cpSelectedState.value = StateDatum(
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
                  controller: leadController.cpCountrySearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    leadController.getCountry(search: value, isCP: true);
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = leadController.cpCountryList;
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
                          leadController.cpSelectedCountry.value = item;
                          leadController.cpCountryController.value.text = item.name;

                          leadController.cpSelectedState.value = null;
                          leadController.cpStateController.value.clear();
                          leadController.cpStateIdController.value.clear();
                          leadController.cpSelectedCity.value = null;
                          leadController.cpCityController.value.clear();
                          leadController.cpCityIdController.value.clear();
                          leadController.cpSelectedPinCode.value = null;
                          leadController.cpPinCodeController.value.clear();
                          leadController.cpPinCodeIdController.value.clear();

                          leadController.getStateApi(countryId: item.id, isCP: true);
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
                  controller: leadController.cpStateSearchController.value,
                  needValidation: false,
                  onChange: (value) {
                    leadController.getStateApi(search: value, countryId: leadController.cpSelectedCountry.value?.id, isCP: true);
                  },
                ),
              ),
              Expanded(
                child: Obx(() {
                  final list = leadController.cpStateList;
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
                          leadController.cpSelectedState.value = item;
                          leadController.cpStateController.value.text = item.name;
                          leadController.cpStateIdController.value.text = item.id;

                          leadController.cpSelectedCity.value = null;
                          leadController.cpCityController.value.clear();
                          leadController.cpCityIdController.value.clear();
                          leadController.cpSelectedPinCode.value = null;
                          leadController.cpPinCodeController.value.clear();
                          leadController.cpPinCodeIdController.value.clear();

                          leadController.getCityApi(page: 1, stateId: item.id, fromPagination: false, isCP: true);
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
      appBar: AppBar(
        title: const Text("Create Contact Person", style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.indigo600Main,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonTextField(
                labelText: "First Name*",
                hintText: "First Name",
                controller: leadController.cpFirstNameController.value,
                needValidation: true,
              ),
              const SizedBox(height: 16),
              commonTextField(labelText: "Last Name", hintText: "Last Name", controller: leadController.cpLastNameController.value),
              const SizedBox(height: 16),
              commonTextField(
                labelText: "Mobile 1*",
                hintText: "Enter 10 digit mobile",
                controller: leadController.cpMobile1Controller.value,
                needValidation: true,
                textInputType: TextInputType.phone,
                isPhoneNumberValidator: true,
              ),
              const SizedBox(height: 16),
              commonTextField(
                labelText: "Mobile 2",
                hintText: "Enter 10 digit mobile",
                controller: leadController.cpMobile2Controller.value,
                textInputType: TextInputType.phone,
                isPhoneNumberValidator: true,
              ),
              const SizedBox(height: 16),
              commonTextField(
                labelText: "Email ID",
                hintText: "Enter email address",
                controller: leadController.cpEmailController.value,
                isEmailValidator: true,
              ),
              const SizedBox(height: 16),
              commonTextField(labelText: "Designation", hintText: "Enter designation", controller: leadController.cpDesignationController.value),
              const SizedBox(height: 16),
              commonTextField(
                labelText: "Address*",
                hintText: "Address",
                controller: leadController.cpAddressController.value,
                needValidation: true,
                maxLine: 2,
              ),
              const SizedBox(height: 16),
              commonTextField(
                labelText: "Pincode*",
                hintText: "Select Pincode",
                controller: leadController.cpPinCodeController.value,
                needValidation: true,
                readOnly: true,
                onTap: () => openPinCodeBottomSheet(context, pinCodeScrollController),
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(height: 16),
              commonTextField(
                labelText: "City*",
                hintText: "Select City",
                controller: leadController.cpCityController.value,
                needValidation: true,
                readOnly: true,
                onTap: () => openCityBottomSheet(context, cityScrollController),
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(height: 16),
              commonTextField(
                labelText: "State*",
                hintText: "Select State",
                controller: leadController.cpStateController.value,
                needValidation: true,
                readOnly: true,
                onTap: () => openStateBottomSheet(context),
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(height: 16),
              commonTextField(
                labelText: "Country*",
                hintText: "Select Country",
                controller: leadController.cpCountryController.value,
                needValidation: true,
                readOnly: true,
                onTap: () => openCountryBottomSheet(context),
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(height: 16),
              commonTextField(
                labelText: "Internal notes",
                hintText: "Notes...",
                controller: leadController.cpInternalNotesController.value,
                maxLine: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: leadController.cpIsActive.value,
                      onChanged: (v) => leadController.cpIsActive.value = v!,
                      activeColor: AppColors.indigo600Main,
                    ),
                  ),
                  const Text("Active", style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      return ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (leadController.cpPinCodeIdController.value.text.isEmpty ||
                                leadController.cpCityIdController.value.text.isEmpty ||
                                leadController.cpStateIdController.value.text.isEmpty ||
                                leadController.cpCountryController.value.text.isEmpty) {
                              toastMessage(text: "Please select valid location details");
                              return;
                            }
                            leadController.createContactPersonApi(customerId: widget.customerId);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.indigo600Main,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: leadController.isLoading.value
                            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text(
                                "Save",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                      );
                    }),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        foregroundColor: AppColors.gray600,
                      ),
                      child: const Text("Discard", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
