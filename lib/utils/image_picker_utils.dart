import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../config/app_colors.dart';

class ImagePickerUtils {
  static final ImagePicker _picker = ImagePicker();

  static void showOptions({
    required Function(File) onImageSelected,
    bool multiImage = false,
    Function(List<File>)? onMultiImageSelected,
  }) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Select Option',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.indigo600Main),
                title: const Text('Camera'),
                onTap: () async {
                  Get.back();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 70,
                  );
                  if (image != null) {
                    onImageSelected(File(image.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.indigo600Main),
                title: const Text('Phone'),
                onTap: () async {
                  Get.back();
                  if (multiImage && onMultiImageSelected != null) {
                    final List<XFile> images = await _picker.pickMultiImage(
                      imageQuality: 70,
                    );
                    if (images.isNotEmpty) {
                      onMultiImageSelected(images.map((e) => File(e.path)).toList());
                    }
                  } else {
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
                    );
                    if (image != null) {
                      onImageSelected(File(image.path));
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
