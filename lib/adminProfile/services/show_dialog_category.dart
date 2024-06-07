import 'dart:io';

import 'package:bfootlearn/adminProfile/models/category_model.dart';
import 'package:bfootlearn/adminProfile/services/category_functions.dart';
import 'package:bfootlearn/adminProfile/widgets/dialogbox_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/text_style.dart';

final CategoryFunctions categoryFunctions = CategoryFunctions();

void showDialogAddCategory(
  BuildContext context,
) {
  File? pickedCategoryImage;
  TextEditingController categoryController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  Future<File?> pickPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: Colors.purple.shade300,
        title: Text(
          'Add category',
          style: dialogBoxTitleTextStyle,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 10),
            pickedCategoryImage == null
                ? ElevatedButton.icon(
                    onPressed: () async {
                      pickedCategoryImage = await pickPhoto();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple.shade300,
                    ),
                    icon: const Icon(Icons.image),
                    label: Text(
                      'Pick icon for category',
                      style: actionButtonTextStyle.copyWith(
                        color: Colors.purple.shade300,
                      ),
                    ),
                  )
                : Image.file(
                    pickedCategoryImage!,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(height: 10),
            DialogBoxTextField(
              controller: categoryController,
              hintText: 'Enter name of category',
            ),
            const SizedBox(height: 10),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: actionButtonTextStyle,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            onPressed: () async {
              // uploads the image to firebase storage and gives the downloadUrl
              final String iconImagePath = await categoryFunctions
                  .uploadImageFileToFirebaseStorage(pickedCategoryImage!);
              // add category with iconImageDownloadUrls
              categoryFunctions.addCategory(
                context: context,
                iconImagePath: iconImagePath,
                categoryName: categoryController.text,
              );
              Navigator.of(context).pop();
              categoryController.clear();
            },
            child: Text(
              'Add',
              style: actionButtonTextStyle,
            ),
          ),
        ],
      );
    },
  );
}

void showDialogUpdateCategory({
  required BuildContext context,
  required CategoryModel oldCategory,
}) {
  final TextEditingController categoryController = TextEditingController();
  categoryController.text = oldCategory.categoryName;
  File? pickedCategoryImage;

  final ImagePicker picker = ImagePicker();
  Future<File?> pickPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      debugPrint('pickedfile :: pickedFile.path');
      return File(pickedFile.path);
    }
    return null;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: Colors.purple.shade300,
          title: Text(
            'Update category',
            style: dialogBoxTitleTextStyle,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 10),
              pickedCategoryImage == null
                  ? ElevatedButton.icon(
                      onPressed: () async {
                        final image = await pickPhoto();
                        if (image != null) {
                          setState(() {
                            pickedCategoryImage = image;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple.shade300,
                      ),
                      icon: const Icon(Icons.image),
                      label: Text(
                        'Pick icon for category',
                        style: actionButtonTextStyle.copyWith(
                          color: Colors.purple.shade300,
                        ),
                      ),
                    )
                  : Image.file(
                      pickedCategoryImage!,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 10),
              DialogBoxTextField(
                controller: categoryController,
                hintText: 'Enter name of category',
              ),
              const SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: actionButtonTextStyle,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              onPressed: () async {
                // uploads the image to firebase storage and gives the downloadUrl
                final String iconImagePath = await categoryFunctions
                    .uploadImageFileToFirebaseStorage(pickedCategoryImage!);
                // add category with iconImageDownloadUrls
                categoryFunctions.updateCategory(
                  context: context,
                  categoryId: oldCategory.categoryId,
                  iconImagePath: iconImagePath,
                  newName: categoryController.text,
                );
                Navigator.of(context).pop();
                categoryController.clear();
              },
              child: Text(
                'Add',
                style: actionButtonTextStyle,
              ),
            ),
          ],
        );
      });
    },
  );
}

void showDialogDeleteCategory({
  required BuildContext context,
  required String categoryId,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.purple.shade300,
        content: Text(
          'Do you want to delete this category?',
          style: dialogBoxContentTextStyle,
        ),
        actions: [
          TextButton(
            child: Text(
              'No',
              style: actionButtonTextStyle,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              'Delete',
              style: actionButtonTextStyle.copyWith(color: Colors.red),
            ),
            onPressed: () {
              // deletes the category
              categoryFunctions.deleteCategory(
                categoryId: categoryId,
                context: context,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
