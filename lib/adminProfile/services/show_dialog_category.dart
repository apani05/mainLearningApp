import 'dart:io';

import 'package:bfootlearn/Phrases/provider/mediaProvider.dart';
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

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        final ImagePicker picker = ImagePicker();
        Future<File?> pickPhoto() async {
          final pickedFile =
              await picker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            setState(() {});
            return File(pickedFile.path);
          }
          return null;
        }

        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: Colors.purple.shade300,
          title: Text(
            'Add category',
            style: dialogBoxTitleTextStyle,
          ),
          content: SingleChildScrollView(
            child: Column(
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
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          pickedCategoryImage!,
                          fit: BoxFit.contain,
                          height: 250,
                          width: 250,
                        ),
                      ),
                const SizedBox(height: 10),
                DialogBoxTextField(
                  controller: categoryController,
                  hintText: 'Enter name of category',
                ),
                const SizedBox(height: 10),
              ],
            ),
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
                String categoryName = categoryController.text.trim();
                if (categoryName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Category name cannot be empty.'),
                    ),
                  );
                  return;
                }
                // uploads the image to firebase storage and gives the downloadUrl
                String iconImagePath;
                if (pickedCategoryImage == null) {
                  // if no picked image, then default image is taken
                  iconImagePath =
                      'gs://blackfootapplication.appspot.com/images/default_icon.png';
                } else {
                  iconImagePath = await categoryFunctions
                      .uploadImageFileToFirebaseStorage(pickedCategoryImage!);
                }
                // add category with iconImageDownloadUrls
                categoryFunctions.addCategory(
                  context: context,
                  iconImagePath: iconImagePath,
                  categoryName: categoryName,
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

void showDialogUpdateCategory({
  required BuildContext context,
  required CategoryModel oldCategory,
}) async {
  final TextEditingController categoryController = TextEditingController();
  categoryController.text = oldCategory.categoryName;
  debugPrint('iconImage : ${oldCategory.iconImage}');

  String? oldCategoryImageDownloadUrl =
      await getDownloadUrl(oldCategory.iconImage);
  String? pickedCategoryImagePath = oldCategoryImageDownloadUrl;

  final ImagePicker picker = ImagePicker();
  Future<File?> pickPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      debugPrint('pickedfile :: pickedFile.path');
      return File(pickedFile.path);
    }
    return null;
  }

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        Future<void> updateIconImage() async {
          final image = await pickPhoto();
          if (image != null) {
            setState(() {
              pickedCategoryImagePath = image.path;
            });
          }
        }

        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: Colors.purple.shade300,
          title: Text(
            'Update category',
            style: dialogBoxTitleTextStyle,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(height: 10),
                pickedCategoryImagePath == null
                    ? ElevatedButton.icon(
                        onPressed: () async {
                          final image = await pickPhoto();
                          if (image != null) {
                            setState(() {
                              pickedCategoryImagePath = image.path;
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
                    : GestureDetector(
                        onTap: updateIconImage,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: pickedCategoryImagePath!.startsWith('http')
                                ? Image.network(
                                    pickedCategoryImagePath!,
                                    fit: BoxFit.contain,
                                    height: 250,
                                    width: 250,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return const Padding(
                                        padding: EdgeInsets.all(5),
                                        child: CircularProgressIndicator(
                                            color: Colors.white),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Text('Error loading image');
                                    },
                                  )
                                : Image.file(
                                    File(pickedCategoryImagePath!),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                const SizedBox(height: 10),
                DialogBoxTextField(
                  controller: categoryController,
                  hintText: 'Enter name of category',
                ),
                const SizedBox(height: 10),
              ],
            ),
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
                String newName = categoryController.text.trim();
                if (newName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Category name cannot be empty.'),
                    ),
                  );
                  return;
                }

                // uploads the image to firebase storage and gives the downloadUrl
                String iconImagePath;
                // Check if the image path has changed
                if (pickedCategoryImagePath != oldCategoryImageDownloadUrl) {
                  // Upload the new image to Firebase Storage
                  iconImagePath =
                      await categoryFunctions.uploadImageFileToFirebaseStorage(
                          File(pickedCategoryImagePath!));
                } else {
                  // Use the existing image path
                  iconImagePath = oldCategory.iconImage;
                }
                categoryFunctions.updateCategory(
                  context: context,
                  categoryId: oldCategory.categoryId,
                  iconImagePath: iconImagePath,
                  newName: newName,
                );

                // also updates the seriesName of all conversations in this category
                categoryFunctions.updateConversationsSeriesName(
                  context: context,
                  oldSeriesName: oldCategory.categoryName,
                  newSeriesName: newName,
                );

                Navigator.of(context).pop();
                categoryController.clear();
              },
              child: Text(
                'Update',
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
  required CategoryModel categoryData,
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
                categoryId: categoryData.categoryId,
                context: context,
              );
              // deletes the conversations
              categoryFunctions.deleteConversationsBySeriesName(
                context: context,
                seriesName: categoryData.categoryName,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
