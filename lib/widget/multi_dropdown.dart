import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../config/app_colors.dart';
import '../config/app_text_style.dart';

class CustomMultiDropdown<T extends Object> extends StatelessWidget {
  final String hintText;
  final MultiSelectController<T> controller;
  final List<DropdownItem<T>> items;
  final bool enabled;
  final bool searchEnabled;
  final String? prefixImage;
  final String? Function(List<DropdownItem<T>>?)? validator;
  final OnSelectionChanged<T>? onSelectionChange;
  final double? padding;

  const CustomMultiDropdown({
    super.key,
    required this.hintText,
    required this.controller,
    required this.items,
    this.enabled = true,
    this.searchEnabled = true,
    this.prefixImage,
    this.validator,
    this.onSelectionChange,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding ?? 16),
      child: Container(
        color: Colors.white,
        child: MultiDropdown<T>(
          controller: controller,
          items: items,
          enabled: enabled,
          searchEnabled: searchEnabled,
          fieldDecoration: FieldDecoration(
            hintText: hintText,
            labelText: hintText,
            hintStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.gray500, fontStyle: FontStyle.italic),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.indigo600Main, width: 1.5),
            ),
            showClearIcon: false,
          ),
          chipDecoration: const ChipDecoration(
            backgroundColor: AppColors.white,
            labelStyle: TextStyle(color: AppColors.black),
            wrap: true,
            spacing: 8,
            runSpacing: 6,
          ),
          dropdownDecoration: const DropdownDecoration(marginTop: 8, maxHeight: 240),

          dropdownItemDecoration: DropdownItemDecoration(
            selectedIcon: const Icon(Icons.check_box, color: Colors.green),
            disabledIcon: Icon(Icons.lock, color: Colors.grey),
          ),
          validator: validator,
          onSelectionChange: onSelectionChange,
        ),
      ),
    );
  }
}
