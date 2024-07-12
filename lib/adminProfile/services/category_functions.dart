import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CategoryFunctions {
  List<DocumentSnapshot> categories = [];
  List<DocumentSnapshot> filteredCategories = [];

  Future<String> uploadImageFileToFirebaseStorage(File pickedImage) async {
    // Create a reference to the Firebase Storage location
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('images/${pickedImage.uri.pathSegments.last}');
    // Upload the file
    UploadTask uploadTask = storageRef.putFile(pickedImage);
    TaskSnapshot taskSnapshot = await uploadTask;

    String bucketUrl = taskSnapshot.ref.bucket;
    String fullPath = taskSnapshot.ref.fullPath;
    String downloadURL = 'gs://$bucketUrl/$fullPath';

    return downloadURL;
  }

  // Function to add a new category to Firestore
  void addCategory({
    required BuildContext context,
    required String categoryName,
    required String iconImagePath,
  }) {
    if (categoryName.isNotEmpty) {
      FirebaseFirestore.instance.collection('ConversationTypes').add({
        'seriesName': categoryName,
        'iconImage': iconImagePath,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category added successfully.'),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add category. $error'),
          ),
        );
      });
    }
  }

  // Function to delete a category from Firestore
  void deleteCategory({
    required String categoryId,
    required BuildContext context,
  }) {
    FirebaseFirestore.instance
        .collection('ConversationTypes')
        .doc(categoryId)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category deleted successfully.'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete category. $error'),
        ),
      );
    });
  }

  // Function to update the name of a category in Firestore
  void updateCategory({
    required BuildContext context,
    required String categoryId,
    required String newName,
    required String iconImagePath,
  }) {
    FirebaseFirestore.instance
        .collection('ConversationTypes')
        .doc(categoryId)
        .update({
      'seriesName': newName,
      'iconImage': iconImagePath,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category updated successfully.'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update category. $error'),
        ),
      );
    });
  }

  // update all conversations which have the given seriesName
  Future<void> updateConversationsSeriesName({
    required BuildContext context,
    required String oldSeriesName,
    required String newSeriesName,
  }) async {
    final conversationsCollection =
        FirebaseFirestore.instance.collection('Conversations');

    try {
      final snapshot = await conversationsCollection
          .where('seriesName', isEqualTo: oldSeriesName)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.update({'seriesName': newSeriesName});
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update phrases. $error'),
        ),
      );
    }
  }

  // delete all conversations which have the given seriesName
  Future<void> deleteConversationsBySeriesName({
    required BuildContext context,
    required String seriesName,
  }) async {
    final conversationsCollection =
        FirebaseFirestore.instance.collection('Conversations');

    try {
      final snapshot = await conversationsCollection
          .where('seriesName', isEqualTo: seriesName)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phrases deleted successfully.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete Phrases. $error'),
        ),
      );
    }
  }
}
