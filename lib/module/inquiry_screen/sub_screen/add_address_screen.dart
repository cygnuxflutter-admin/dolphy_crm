import 'package:crm/config/app_colors.dart';
import 'package:crm/module/inquiry_screen/Inquiry_controller.dart';
import 'package:crm/widget/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:get/get.dart';

import '../../../widget/textfield.dart';
import '../model/city_model.dart';
import '../model/country_model.dart';
import '../model/state_model.dart';

class AddAddressScreen extends StatefulWidget {
  final bool isEdit;
  final int? index;

  const AddAddressScreen({super.key, this.isEdit = false, this.index});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final InquiryScreenController inquiryScreenController = Get.find<InquiryScreenController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController pinCodeScrollController = ScrollController();
  final ScrollController cityScrollController = ScrollController();

  @override
  void initState() {
    pinCodeScrollController.addListener(() {
      if (pinCodeScrollController.position.pixels >= pinCodeScrollController.position.maxScrollExtent - 200) {
        if (inquiryScreenController.isAddAddressPinCodeLoading.value == false &&
            inquiryScreenController.addAddressPinCodeList.length < inquiryScreenController.addAddressPinCodeTotalCount.value) {
          inquiryScreenController.addAddressPinCodePageCount.value++;
          inquiryScreenController.getAddAddressPinCodeApi(
            page: inquiryScreenController.addAddressPinCodePageCount.value,
            search: inquiryScreenController.addAddressPinCodeSearchController.value.text,
            cityId: inquiryScreenController.selectedAddAddressCity.value != null ? inquiryScreenController.selectedAddAddressCity.value!.id : "",
          );
        }
      }
    });
    cityScrollController.addListener(() {
      if (cityScrollController.position.pixels >= cityScrollController.position.maxScrollExtent - 200) {
        if (inquiryScreenController.isAddAddressCityLoading.value == false &&
            inquiryScreenController.addAddressCityList.length < inquiryScreenController.addAddressCityTotalCount.value) {
          inquiryScreenController.addAddressCityPageCount.value++;
          inquiryScreenController.getAddAddressCityApi(
            page: inquiryScreenController.addAddressCityPageCount.value,
            search: inquiryScreenController.addAddressCitySearchController.value.text,
            stateId: inquiryScreenController.selectedAddAddressState.value != null ? inquiryScreenController.selectedAddAddressState.value!.id : "",
            fromPagination: false,
          );
        }
      }
    });
    if (widget.isEdit == false) {
      if (inquiryScreenController.addressTypeList.isNotEmpty) {
        inquiryScreenController.selectedAddressType.value = inquiryScreenController.addressTypeList.first;
      } else {
        inquiryScreenController.selectedAddressType.value = null;
      }
      inquiryScreenController.addAddressNameController.value.clear();
      inquiryScreenController.addAddressCompanyNameController.value.clear();
      inquiryScreenController.addAddressMobileNumberController.value.clear();
      inquiryScreenController.addAddressMobileNumber2Controller.value.clear();
      inquiryScreenController.addAddressController.value.clear();
      inquiryScreenController.addAddressPinCodeNumberController.value.clear();
      inquiryScreenController.addAddressCityController.value.clear();
      inquiryScreenController.selectedAddAddressCity.value = null;
      inquiryScreenController.selectedAddAddressState.value = null;
      inquiryScreenController.selectedAddAddressPinCode.value = null;
      inquiryScreenController.selectedAddAddressCountry.value = null;
      inquiryScreenController.addAddressInternalNotesController.value.clear();
      inquiryScreenController.addAddressDesignationController.value.clear();
    } else {
      inquiryScreenController.getAddAddressCityApi(
        page: 1,
        search: '',
        fromPagination: false,
        stateId: inquiryScreenController.addAddressList[widget.index!].stateId.id,
      );
      inquiryScreenController.getAddAddressPinCodeApi(
        page: 1,
        search: "",
        fromPagination: false,
        cityId: inquiryScreenController.addAddressList[widget.index!].cityId.id,
      );
      inquiryScreenController.selectedAddressType.value = inquiryScreenController.addAddressList[widget.index!].type;
      inquiryScreenController.addAddressNameController.value.text = inquiryScreenController.addAddressList[widget.index!].contactName;
      inquiryScreenController.addAddressCompanyNameController.value.text = inquiryScreenController.addAddressList[widget.index!].companyName ?? "";
      inquiryScreenController.addAddressDesignationController.value.text = inquiryScreenController.addAddressList[widget.index!].designation ?? "";
      inquiryScreenController.addAddressMobileNumberController.value.text = inquiryScreenController.addAddressList[widget.index!].mobile1;
      inquiryScreenController.addAddressMobileNumber2Controller.value.text = inquiryScreenController.addAddressList[widget.index!].mobile2 ?? "";
      inquiryScreenController.addAddressController.value.text = inquiryScreenController.addAddressList[widget.index!].street;
      inquiryScreenController.addAddressPinCodeNumberController.value.text = inquiryScreenController.addAddressList[widget.index!].pincodeId.pinCode;
      inquiryScreenController.addAddressCityController.value.text = inquiryScreenController.addAddressList[widget.index!].cityId.name;
      inquiryScreenController.selectedAddAddressCity.value = inquiryScreenController.addAddressList[widget.index!].cityId;
      inquiryScreenController.selectedAddAddressState.value = inquiryScreenController.addAddressList[widget.index!].stateId;
      inquiryScreenController.selectedAddAddressPinCode.value = inquiryScreenController.addAddressList[widget.index!].pincodeId;
      inquiryScreenController.selectedAddAddressCountry.value = inquiryScreenController.addAddressList[widget.index!].countryId;
      inquiryScreenController.addAddressInternalNotesController.value.text = inquiryScreenController.addAddressList[widget.index!].remarks ?? "";
      inquiryScreenController.isActive.value = inquiryScreenController.addAddressList[widget.index!].isActive;
    }
    if (inquiryScreenController.addressTypeList.isEmpty) {
      inquiryScreenController.getAddressType();
    }
    super.initState();
  }

  void openPinCodeBottomSheet(BuildContext context, ScrollController controller) {
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
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Select PinCode", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: commonTextField(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search PinCode...",
                    controller: inquiryScreenController.addAddressPinCodeSearchController.value,
                    needValidation: false,
                    onChange: (value) {
                      if (value.length % 3 == 0) {
                        inquiryScreenController.addAddressPinCodePageCount.value = 1;
                        if (inquiryScreenController.selectedAddAddressCity.value != null) {
                          inquiryScreenController.getAddAddressPinCodeApi(
                            page: inquiryScreenController.addAddressPinCodePageCount.value,
                            search: value,
                            fromPagination: false,
                            cityId: inquiryScreenController.selectedAddAddressCity.value!.id,
                          );
                        } else {
                          inquiryScreenController.getAddAddressPinCodeApi(
                            page: inquiryScreenController.addAddressPinCodePageCount.value,
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
                    final list = inquiryScreenController.addAddressPinCodeList;
                    final isLoading = inquiryScreenController.isAddAddressPinCodeLoading.value;

                    if (isLoading && list.isEmpty) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.indigo600Main));
                    }

                    if (list.isEmpty && !isLoading) {
                      return const Center(child: Text("No data found"));
                    }

                    return ListView.separated(
                      controller: controller,
                      padding: EdgeInsets.zero,
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = list[index];

                        return GestureDetector(
                          onTap: () {
                            inquiryScreenController.addAddressPinCodeNumberController.value.text = item.pinCode;
                            inquiryScreenController.addAddressCityController.value.text = item.cityId.name;
                            inquiryScreenController.selectedAddAddressPinCode.value = item;
                            inquiryScreenController.selectedAddAddressCity.value = CityDatum(
                              id: item.cityId.id,
                              name: item.cityId.name,
                              stateId: StateId(id: item.stateId.id, name: item.stateId.name),
                              countryId: StateId(id: item.countryId.id, name: item.countryId.name),
                            );
                            inquiryScreenController.selectedAddAddressState.value = StateDatum(
                              id: item.stateId.id,
                              name: item.stateId.name,
                              countryId: CountryId(id: item.countryId.id, name: item.countryId.name),
                            );
                            inquiryScreenController.selectedAddAddressCountry.value = CountryDatum(id: item.countryId.id, name: item.countryId.name);

                            Get.back();
                            inquiryScreenController.addAddressPinCodePageCount.value = 1;
                            inquiryScreenController.getAddAddressPinCodeApi(
                              page: inquiryScreenController.addAddressPinCodePageCount.value,
                              search: inquiryScreenController.addAddressPinCodeSearchController.value.text,
                              cityId: inquiryScreenController.selectedAddAddressCity.value != null
                                  ? inquiryScreenController.selectedAddAddressCity.value!.id
                                  : "",
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Select City", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: commonTextField(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search City...",
                    controller: inquiryScreenController.addAddressCitySearchController.value,
                    needValidation: false,
                    onChange: (value) {
                      if (value.isEmpty || value.length % 3 == 0) {
                        inquiryScreenController.addAddressCityPageCount.value = 1;

                        if (inquiryScreenController.selectedAddAddressState.value != null) {
                          inquiryScreenController.getAddAddressCityApi(
                            page: inquiryScreenController.addAddressCityPageCount.value,
                            search: value,
                            fromPagination: false,
                            stateId: inquiryScreenController.selectedAddAddressState.value!.id,
                          );
                        } else {
                          inquiryScreenController.getAddAddressPinCodeApi(
                            page: inquiryScreenController.addAddressCityPageCount.value,
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
                    final list = inquiryScreenController.addAddressCityList;
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
                        return GestureDetector(
                          onTap: () {
                            inquiryScreenController.selectedAddAddressCity.value = null;
                            inquiryScreenController.selectedAddAddressCity.value = item;
                            inquiryScreenController.addAddressCityController.value.text = item.name;
                            inquiryScreenController.selectedAddAddressPinCode.value = null;
                            inquiryScreenController.addAddressPinCodeNumberController.value.clear();
                            inquiryScreenController.addAddressPinCodePageCount.value = 1;
                            inquiryScreenController.addAddressPinCodeSearchController.value.clear();
                            inquiryScreenController.getAddAddressPinCodeApi(
                              page: inquiryScreenController.addAddressPinCodePageCount.value,
                              search: inquiryScreenController.addAddressPinCodeSearchController.value.text,
                              cityId: item.id,
                              fromPagination: false,
                            );
                            inquiryScreenController.selectedAddAddressState.value = StateDatum(
                              id: item.stateId.id,
                              name: item.stateId.name,
                              countryId: CountryId(id: item.countryId.id, name: item.countryId.name),
                            );
                            inquiryScreenController.selectedAddAddressCountry.value = CountryDatum(id: item.countryId.id, name: item.countryId.name);
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
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Create Contact Address",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
        backgroundColor: AppColors.indigo600Main,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close, color: AppColors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Address Type", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Obx(() {
                    if (inquiryScreenController.addressTypeList.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Loading address types...", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      );
                    }
                    return Wrap(
                      spacing: 0,
                      runSpacing: 0,
                      children: inquiryScreenController.addressTypeList.map((type) {
                        return InkWell(
                          onTap: () {
                            inquiryScreenController.selectedAddressType.value = type;
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio<String>(
                                value: type.id,
                                groupValue: inquiryScreenController.selectedAddressType.value?.id,
                                onChanged: (value) {
                                  inquiryScreenController.selectedAddressType.value = type;
                                },
                                activeColor: AppColors.indigo600Main,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              Text(type.name, style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 12),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 8),
                  const Text(
                    "Preferred address for all deliveries. Selected by default when you deliver an order that belongs to this company.",
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  commonTextField(
                    labelText: "Person Name*",
                    hintText: "Name",
                    controller: inquiryScreenController.addAddressNameController.value,
                    needValidation: true,
                    validationMessage: "Person Name is required",
                    padding: 12,
                  ),
                  commonTextField(
                    labelText: "Company Name",
                    hintText: "Company Name",
                    controller: inquiryScreenController.addAddressCompanyNameController.value,
                    padding: 12,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Phone Type",
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      Obx(
                        () => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: "Mobile",
                              groupValue: inquiryScreenController.phoneType.value,
                              onChanged: (value) => inquiryScreenController.phoneType.value = value!,
                              activeColor: AppColors.indigo600Main,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            const Text("Mobile", style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 8),
                            Radio<String>(
                              value: "Landline",
                              groupValue: inquiryScreenController.phoneType.value,
                              onChanged: (value) => inquiryScreenController.phoneType.value = value!,
                              activeColor: AppColors.indigo600Main,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            const Text("Landline", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => RichText(
                      text: TextSpan(
                        text: "${inquiryScreenController.phoneType.value} 1",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),
                        children: [
                          const TextSpan(
                            text: " *",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => IntlPhoneField(
                      controller: inquiryScreenController.addAddressMobileNumberController.value,
                      decoration: InputDecoration(
                        hintText: "${inquiryScreenController.phoneType.value} 1",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.indigo600Main, width: 1.6),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        counterText: "",
                      ),
                      style: const TextStyle(fontSize: 14),
                      initialCountryCode: 'IN',
                      onChanged: (phone) {
                        inquiryScreenController.addAddressMobile1CountryCodeController.value.text = phone.countryCode;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Mobile 2", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  IntlPhoneField(
                    controller: inquiryScreenController.addAddressMobileNumber2Controller.value,
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
                      hintText: "Mobile 2",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.indigo600Main, width: 1.6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      counterText: "",
                    ),
                    style: const TextStyle(fontSize: 14),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      inquiryScreenController.addAddressMobile2CountryCodeController.value.text = phone.countryCode;
                    },
                  ),
                  const SizedBox(height: 16),
                  commonTextField(
                    labelText: "Designation",
                    hintText: "Designation",
                    controller: inquiryScreenController.addAddressDesignationController.value,
                    padding: 12,
                  ),
                  commonTextField(
                    labelText: "Address*",
                    hintText: "Address",
                    controller: inquiryScreenController.addAddressController.value,
                    needValidation: true,
                    validationMessage: "Address is required",
                    padding: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: commonTextField(
                          labelText: "PIN*",
                          hintText: "Select PIN",
                          controller: inquiryScreenController.addAddressPinCodeNumberController.value,
                          needValidation: true,
                          readOnly: true,
                          onTap: () => openPinCodeBottomSheet(context, pinCodeScrollController),
                          suffixIcon: const Icon(Icons.keyboard_arrow_down),
                          padding: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: commonTextField(
                          labelText: "City*",
                          hintText: "Select City",
                          controller: inquiryScreenController.addAddressCityController.value,
                          needValidation: true,
                          readOnly: true,
                          onTap: () => openCityBottomSheet(context, cityScrollController),
                          suffixIcon: const Icon(Icons.keyboard_arrow_down),
                          padding: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Obx(
                          () => CustomDropdown<StateDatum>(
                            hintText: 'State*',
                            items: (filter, loadProps) => inquiryScreenController.stateList,
                            selectedItem: inquiryScreenController.selectedAddAddressState.value,
                            itemAsString: (item) => item.name,
                            compareFn: (a, b) => a?.id == b?.id,
                            padding: 12,
                            onChanged: (value) {
                              inquiryScreenController.selectedAddAddressState.value = value;
                              inquiryScreenController.selectedAddAddressCity.value = null;
                              inquiryScreenController.selectedAddAddressPinCode.value = null;
                              inquiryScreenController.addAddressCityController.value.clear();
                              inquiryScreenController.addAddressPinCodeNumberController.value.clear();
                              inquiryScreenController.getAddAddressCityApi(page: 1, stateId: value!.id, fromPagination: false);
                              inquiryScreenController.getAddAddressPinCodeApi(page: 1, fromPagination: false);
                              inquiryScreenController.selectedAddAddressCountry.value = CountryDatum(
                                id: value.countryId.id,
                                name: value.countryId.name,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => CustomDropdown<CountryDatum>(
                            hintText: 'Country*',
                            items: (filter, loadProps) => inquiryScreenController.countryList,
                            selectedItem: inquiryScreenController.selectedAddAddressCountry.value,
                            itemAsString: (item) => item.name,
                            compareFn: (a, b) => a?.id == b?.id,
                            padding: 12,
                            onChanged: (value) {
                              inquiryScreenController.selectedAddAddressCountry.value = value;
                              inquiryScreenController.selectedAddAddressState.value = null;
                              inquiryScreenController.selectedAddAddressCity.value = null;
                              inquiryScreenController.selectedAddAddressPinCode.value = null;
                              inquiryScreenController.addAddressCityController.value.clear();
                              inquiryScreenController.addAddressPinCodeNumberController.value.clear();
                              inquiryScreenController.getAddAddressCityApi(page: 1, fromPagination: false);
                              inquiryScreenController.getAddAddressPinCodeApi(page: 1, fromPagination: false);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  commonTextField(
                    labelText: "Internal notes",
                    hintText: "Notes",
                    controller: inquiryScreenController.addAddressInternalNotesController.value,
                    maxLine: 3,
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    return Row(
                      children: [
                        Checkbox(
                          value: inquiryScreenController.isActive.value,
                          activeColor: AppColors.indigo600Main,
                          onChanged: (value) {
                            inquiryScreenController.isActive.value = value!;
                          },
                        ),
                        const Text("Active", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    );
                  }),
                  const SizedBox(height: 24),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              inquiryScreenController.addAddress(isNew: false, isEdit: widget.isEdit, index: widget.isEdit ? widget.index : null);
                              Get.back();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.indigo600Main,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(widget.isEdit ? "Update & Close" : "Save & Close"),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              inquiryScreenController.addAddress(isNew: true, isEdit: widget.isEdit, index: widget.isEdit ? widget.index : null);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.indigo600Main,
                            side: const BorderSide(color: AppColors.indigo600Main),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(widget.isEdit ? "Update & New" : "Save & New"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Discard"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
