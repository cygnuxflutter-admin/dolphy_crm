import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/app_text_style.dart';
import '../config/app_colors.dart';
import '../utils/validator.dart';

Widget commonTextField({
  String? labelText,
  String? hintText,
  String? newPassValue2,
  String? startTime,
  String? countryCode,
  EdgeInsetsGeometry? horizontalPadding,
  TextEditingController? controller,
  ScrollController? scrollController,
  String? validationMessage,
  bool needValidation = false,
  bool isEmailValidator = false,
  bool isPasswordValidator = false,
  bool isCardValidator = false,
  bool isCVCValidator = false,
  bool isExpiryYearValidator = false,
  bool isExpiryMonthValidator = false,
  bool isPhoneNumberValidator = false,
  bool isSamePasswordValidator = false,
  bool isUpperCaseValidator = false,
  bool isPanInputValidator = false,
  bool isGstInputValidator = false,
  bool isCountryCode = false,
  bool obscureText = false,
  String? errorText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Color? focusedBorderColor,
  int? maxLine,
  int? minLine,
  int? maxLength,
  bool readOnly = false,
  bool expands = false,
  TextInputType? textInputType,
  List<TextInputFormatter>? inputFormatters,
  Function(String v)? onChange,
  Function()? onTap,
  Color? bgColor,
  Color? textColor,
  double? padding,
  Color? hintColor,
  TextInputAction? action,
  FocusNode? focusNode,
  ContentInsertionConfiguration? configuration,
  bool? autoFocus,
  bool? enable,
  bool isShortTextField = false,
  bool isOnlyInputCharacter = false,
  bool isOnlyInputDigits = false,
  bool isNoLeadingZero = false,
  bool isMandatory = false,
  bool isOnlyDecimal = false,
  bool isNoSpaceAllow = false,
  bool isTimeValidator = false,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: padding ?? 16),
    child: TextFormField(
      enabled: enable ?? true,
      controller: controller,
      scrollController: scrollController,
      focusNode: focusNode,
      autofocus: autoFocus ?? false,
      obscureText: obscureText,
      contentInsertionConfiguration: configuration,
      textInputAction: action,
      onTap: onTap,
      readOnly: readOnly,
      expands: expands,
      onChanged: onChange,
      maxLines: maxLine ?? 1,
      minLines: minLine,
      maxLength: maxLength,
      keyboardType: textInputType ?? TextInputType.text,
      cursorColor: AppColors.indigo600Main,

      style: AppTextStyle.regular.copyWith(fontSize: 15, color: textColor ?? AppColors.textPrimary),

      inputFormatters:
          inputFormatters ??
          [
            NoLeadingSpacesFormatter(),
            if (isPhoneNumberValidator) LengthLimitingTextInputFormatter(10),
            if (isCountryCode)
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (!newValue.text.startsWith("+")) return oldValue;
                return newValue;
              }),
            if (isUpperCaseValidator) UpperCaseTextFormatter(),
            if (isPanInputValidator) PanInputFormatter(),
            if (isGstInputValidator) GstInputFormatter(),
            if (isOnlyInputCharacter) FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
            if (isOnlyInputDigits) FilteringTextInputFormatter.digitsOnly,
            if (isNoLeadingZero) NoLeadingZeroFormatter(),
            if (isOnlyDecimal) FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?')),
            if (isNoSpaceAllow) FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],

      decoration: InputDecoration(
        counterText: "",
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        errorStyle: TextStyle(color: AppColors.redColor),
        floatingLabelBehavior: FloatingLabelBehavior.auto,

        labelStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.textSecondary),

        hintStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: hintColor ?? AppColors.gray500),

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        filled: true,
        fillColor: bgColor ?? AppColors.white,

        contentPadding: horizontalPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focusedBorderColor ?? AppColors.indigo600Main, width: 1.6),
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

      validator: needValidation
          ? (v) {
              return TextFieldValidation.validation(
                countryCode: countryCode,
                isEmailValidator: isEmailValidator,
                isCountryCode: isCountryCode,
                isPasswordValidator: isPasswordValidator,
                isPhoneNumberValidator: isPhoneNumberValidator,
                isCVCValidator: isCVCValidator,
                isExpiryMonthValidator: isExpiryMonthValidator,
                isCardValidator: isCardValidator,
                isExpiryYearValidator: isExpiryYearValidator,
                message: validationMessage,
                value: v!.trim(),
                newPassValue2: newPassValue2,
                isSamePasswordValidator: isSamePasswordValidator,
                isTimeValidator: isTimeValidator,
                startTime: startTime,
              );
            }
          : null,
    ),
  );
}

class NoLeadingSpacesFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith(' ') || newValue.text.startsWith('.') || newValue.text.startsWith(',')) {
      return oldValue;
    }
    return newValue;
  }
}

class NoLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '0') {
      return oldValue;
    } else if (newValue.text.startsWith('0')) {
      return newValue.copyWith(
        text: newValue.text.replaceFirst(RegExp('^0+'), ''),
        selection: TextSelection.collapsed(offset: newValue.text.length),
      );
    }
    return newValue;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class PanInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.toUpperCase();
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      String char = text[i];

      if (i < 5) {
        if (RegExp(r'[A-Z]').hasMatch(char)) buffer.write(char);
      } else if (i < 9) {
        if (RegExp(r'[0-9]').hasMatch(char)) buffer.write(char);
      } else if (i < 10) {
        if (RegExp(r'[A-Z]').hasMatch(char)) buffer.write(char);
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class GstInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.toUpperCase();
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      String char = text[i];

      if (i < 2) {
        if (RegExp(r'[0-9]').hasMatch(char)) buffer.write(char);
      } else if (i < 7) {
        if (RegExp(r'[A-Z]').hasMatch(char)) buffer.write(char);
      } else if (i < 11) {
        if (RegExp(r'[0-9]').hasMatch(char)) buffer.write(char);
      } else if (i == 11) {
        if (RegExp(r'[A-Z]').hasMatch(char)) buffer.write(char);
      } else if (i == 12) {
        if (RegExp(r'[1-9A-Z]').hasMatch(char)) buffer.write(char);
      } else if (i == 13) {
        if (RegExp(r'[Z0-9]').hasMatch(char)) buffer.write(char);
      } else if (i == 14) {
        if (RegExp(r'[0-9A-Z]').hasMatch(char)) buffer.write(char);
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
