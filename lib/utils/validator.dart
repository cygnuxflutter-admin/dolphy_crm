class TextFieldValidation {
  TextFieldValidation._();

  static String? validation(
      {String? value,
      String? newPassValue2,
      String? startTime,
      String? countryCode,
      String? message,
      bool isEmailValidator = false,
      bool isPasswordValidator = false,
      bool isTimeValidator = false,
      bool isCountryCode = false,
      bool isPhoneNumberValidator = false,
      bool isCardValidator = false,
      bool isCVCValidator = false,
      bool isExpiryYearValidator = false,
      bool isExpiryMonthValidator = false,
      bool isSamePasswordValidator = false}) {
    if (value!.isEmpty) {
      return "$message";
    }

    if (isTimeValidator == true) {

      if (value.isEmpty) {
        return "$message";
      }
      if (((int.parse(value.split(":").first) * 60) + (int.parse(value.split(":").last))) <= ((int.parse(startTime!.split(":").first) * 60) + (int.parse(startTime.split(":").last))) ) {
        return "End Time must be after Start Time";
      }
    }


    if(isCountryCode == true){
      if(value == "+"){
        return "$message";
      }
    }
    if (isPhoneNumberValidator == true) {
      if (value.isEmpty) {
        return "$message";
      } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
        return 'Phone number must be 10 digits';
      }

      // If country code is +91, number must start with 6-9
      if (countryCode == '+91') {
        if (!RegExp(r'^[6-9]').hasMatch(value)) {
          return 'Indian numbers must start with digits 6, 7, 8, or 9';
        }
      }

      // Check no digit repeats 5 times continuously
      if (RegExp(r'(\d)\1{4}').hasMatch(value)) {
        return 'Number cannot contain the same digit 5 times consecutively';
      }

      return null; // valid number
    }
    if (isCardValidator == true) {
      if (value.isEmpty) {
        return "$message";
      } else if (value.length < 16) {
        return 'Card number must be 16 digit';
      }
    }
    if (isCVCValidator == true) {
      if (value.isEmpty) {
        return "$message";
      } else if (value.length < 3) {
        return 'Enter valid CVC';
      }
    }
    if (isExpiryYearValidator == true) {
      if (value.isEmpty) {
        return "$message";
      } else if (value.length < 4) {
        return 'Enter valid year';
      } else if (DateTime.now().year > int.parse(value)) {
        return 'Enter valid year';
      }
    }
    if (isExpiryMonthValidator == true) {
      if (value.isEmpty) {
        return "$message";
      }
    }
    if (isEmailValidator == true) {
      if (value.isEmpty) {
        return "$message";
      } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
        return 'Enter Valid $message';
      }
    }
    if (isSamePasswordValidator == true) {
      if (value.isEmpty) {
        return "$message";
      }
      if (value != newPassValue2!.trim()) {
        return "Please enter same confirm password";
      }
    } else if (isPasswordValidator == true) {
      if (value.isEmpty) {
        return "$message";
      } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value)) {
        if (value.length < 8) {
          return 'Password must have at least 8 characters';
        } else if (!value.contains(RegExp(r'[A-Za-z]'))) {
          return 'Password must have at least one alphabet characters';
        } else if (!value.contains(RegExp(r'[0-9]'))) {
          return 'Password must have at least one number characters';
        } else if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
          return 'Password must have at least one special characters';
        }
      }
    }
    return null;
  }
}
