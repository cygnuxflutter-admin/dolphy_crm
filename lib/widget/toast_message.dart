import 'package:fluttertoast/fluttertoast.dart';

import '../config/app_colors.dart';

void toastMessage({text, color, isTop = false}) {
  if (text.toString().isNotEmpty) {
    Fluttertoast.showToast(
      gravity: isTop ? ToastGravity.TOP : ToastGravity.BOTTOM,
      msg: text,
      backgroundColor: AppColors.indigo600Main,
      fontSize: 14,
      textColor: AppColors.white,
    );
  }
}
