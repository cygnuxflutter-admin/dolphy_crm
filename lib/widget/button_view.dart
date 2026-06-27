import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../config/app_colors.dart';
import '../config/app_text_style.dart';

Widget commonButton({
  required String name,
  double? height,
  double? width,
  Color? textColor,
  Color? bgColor,
  Color? borderColor,
  double? size,
  VoidCallback? onTap,
  double? radius,
  List<Color>? gradientColor,
  bool isLoader = false,
  bool loaderColorWhite = false,

  // 🔹 NEW (optional)
  IconData? icon,
  double? iconSize,
  Color? iconColor,
  double iconSpacing = 8,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Center(
      child: SizedBox(
        height: Get.width > 767.00 ? height ?? 80 : height ?? 50,
        width: width ?? Get.width,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? AppColors.transparent),
            borderRadius: BorderRadius.circular(radius ?? 12),
            color: bgColor ?? AppColors.transparent,
          ),
          child: Center(
            child: isLoader
                ? CupertinoActivityIndicator(color: !loaderColorWhite ? AppColors.black : AppColors.white)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: iconSize ?? 18, color: iconColor ?? textColor ?? AppColors.white),
                        SizedBox(width: iconSpacing),
                      ],
                      Text(
                        name,
                        style: AppTextStyle.bold.copyWith(fontSize: size ?? 16, color: textColor ?? AppColors.white),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ),
  );
}
