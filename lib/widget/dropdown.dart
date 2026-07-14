import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_style.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hintText;
  final DropdownSearchOnFind<T> items;
  final T? selectedItem;
  final String Function(T item) itemAsString;
  final void Function(T? value)? onChanged;
  final String? Function(T? value)? validator;
  final String? prefixImage;
  final bool showSearchBox;
  final bool enabled;
  final Function()? onClearTap;
  final double? padding;
  final bool Function(T?, T?)? compareFn;
  final InfiniteScrollProps? infiniteScrollProps;

  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.itemAsString,
    this.selectedItem,
    this.onChanged,
    this.validator,
    this.prefixImage,
    this.showSearchBox = true,
    this.enabled = true,
    this.onClearTap,
    this.padding,
    this.compareFn,
    this.infiniteScrollProps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding ?? 16),
      child: DropdownSearch<T>(
        enabled: enabled,
        itemAsString: itemAsString,
        compareFn: compareFn,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            errorStyle: const TextStyle(color: AppColors.redColor),
            prefixIcon: prefixImage != null
                ? Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Image.asset(prefixImage!, height: 20, width: 20))
                : null,
            hintText: hintText,
            hintStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.gray500),
            labelStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.indigo600Main, width: 1.6),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border.withValues(alpha: .6)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.redColor),
            ),
          ),
        ),
        popupProps: PopupProps.modalBottomSheet(
          showSearchBox: showSearchBox,
          fit: FlexFit.loose,
          infiniteScrollProps: infiniteScrollProps,
          disableFilter: infiniteScrollProps != null,
          containerBuilder: (context, popupWidget) {
            return SafeArea(child: popupWidget);
          },
          modalBottomSheetProps: ModalBottomSheetProps(
            showDragHandle: true,
            isScrollControlled: true,
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75, minHeight: MediaQuery.of(context).size.height * 0.5),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            backgroundColor: AppColors.white,
          ),
          loadingBuilder: (context, searchEntry) => const Center(
            child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()),
          ),
          emptyBuilder: (context, searchEntry) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline, size: 48, color: AppColors.gray300),
                  const SizedBox(height: 16),
                  Text("No data found", style: AppTextStyle.regular.copyWith(color: AppColors.gray500)),
                ],
              ),
            ),
          ),
          itemBuilder: (context, item, isDisabled, isSelected) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: isSelected ? AppColors.indigo600Main.withValues(alpha: 0.05) : Colors.transparent),
              child: Text(
                itemAsString(item),
                style: AppTextStyle.regular.copyWith(
                  fontSize: 14,
                  color: isSelected ? AppColors.indigo600Main : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
          searchFieldProps: TextFieldProps(
            padding: const EdgeInsets.all(12),
            decoration: InputDecoration(
              hintText: "Search...",
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.indigo600Main, width: 1.5),
              ),
            ),
          ),
        ),
        items: items,
        selectedItem: selectedItem,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

class CustomMultiDropdownSearch<T> extends StatelessWidget {
  final String hintText;
  final DropdownSearchOnFind<T> items;
  final List<T> selectedItems;
  final String Function(T item) itemAsString;
  final void Function(List<T> value)? onChanged;
  final String? Function(List<T>? value)? validator;
  final String? prefixImage;
  final bool showSearchBox;
  final bool enabled;
  final Function()? onClearTap;
  final double? padding;
  final bool Function(T?, T?)? compareFn;
  final bool Function(T item)? disabledItemFn;

  const CustomMultiDropdownSearch({
    super.key,
    required this.hintText,
    required this.items,
    required this.itemAsString,
    this.selectedItems = const [],
    this.onChanged,
    this.validator,
    this.prefixImage,
    this.showSearchBox = true,
    this.enabled = true,
    this.onClearTap,
    this.padding,
    this.compareFn,
    this.disabledItemFn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding ?? 16),
      child: DropdownSearch<T>.multiSelection(
        enabled: enabled,
        itemAsString: itemAsString,
        compareFn: compareFn,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            errorStyle: const TextStyle(color: AppColors.redColor),
            prefixIcon: prefixImage != null
                ? Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Image.asset(prefixImage!, height: 20, width: 20))
                : null,
            hintText: hintText,
            hintStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.gray500),
            labelStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.indigo600Main, width: 1.6),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border.withValues(alpha: .6)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.redColor),
            ),
          ),
        ),
        popupProps: PopupPropsMultiSelection.modalBottomSheet(
          showSearchBox: showSearchBox,
          fit: FlexFit.loose,
          disabledItemFn: disabledItemFn,
          containerBuilder: (context, popupWidget) {
            return SafeArea(child: popupWidget);
          },
          modalBottomSheetProps: ModalBottomSheetProps(
            showDragHandle: true,
            isScrollControlled: true,
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75, minHeight: MediaQuery.of(context).size.height * 0.5),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            backgroundColor: AppColors.white,
          ),
          loadingBuilder: (context, searchEntry) => const Center(
            child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()),
          ),
          emptyBuilder: (context, searchEntry) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline, size: 48, color: AppColors.gray300),
                  const SizedBox(height: 16),
                  Text("No data found", style: AppTextStyle.regular.copyWith(color: AppColors.gray500)),
                ],
              ),
            ),
          ),
          itemBuilder: (context, item, isDisabled, isSelected) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.indigo600Main.withValues(alpha: 0.05)
                    : isDisabled
                    ? AppColors.gray100
                    : Colors.transparent,
              ),
              child: Text(
                itemAsString(item),
                style: AppTextStyle.regular.copyWith(
                  fontSize: 14,
                  color: isDisabled
                      ? AppColors.gray400
                      : isSelected
                      ? AppColors.indigo600Main
                      : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
          searchFieldProps: TextFieldProps(
            padding: const EdgeInsets.all(12),
            decoration: InputDecoration(
              hintText: "Search...",
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.indigo600Main, width: 1.5),
              ),
            ),
          ),
        ),
        items: items,
        selectedItems: selectedItems,
        onChanged: onChanged,
        validator: validator,
        dropdownBuilder: (context, selectedItems) {
          // if (selectedItems.isEmpty) {
          //   return Text(hintText, style: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.gray500));
          // }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selectedItems.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.indigo600Main.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.indigo600Main.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Text(
                          itemAsString(item),
                          style: const TextStyle(fontSize: 13, color: AppColors.indigo600Main, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          if (onChanged != null) {
                            final newList = List<T>.from(selectedItems);
                            newList.remove(item);
                            onChanged!(newList);
                          }
                        },
                        child: const Icon(Icons.close, size: 14, color: AppColors.indigo600Main),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
