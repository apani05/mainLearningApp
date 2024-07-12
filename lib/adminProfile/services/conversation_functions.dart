import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ConversationFucntions {
  Future<String> uploadAudioFileToFirebaseStorage(String audioFilePath) async {
    File audioFile = File(audioFilePath);
    if (!audioFile.existsSync()) {
      throw Exception("File does not exist at path: $audioFilePath");
    }

    try {
      // Create a reference to the Firebase Storage location
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('audio_files/${const Uuid().v4()}');

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(audioFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL
      String bucketUrl = taskSnapshot.ref.bucket;
      String fullPath = taskSnapshot.ref.fullPath;
      String downloadURL = 'gs://$bucketUrl/$fullPath';

      return downloadURL;
    } catch (e) {
      throw Exception("Failed to upload file: $e");
    }
  }

  void deleteConversation({
    required String conversationId,
    required BuildContext context,
  }) {
    FirebaseFirestore.instance
        .collection('Conversations')
        .doc(conversationId)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phrases deleted successfully.'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete Phrases. $error'),
        ),
      );
    });
  }

  void updateConversation({
    required BuildContext context,
    required String oldConversationId,
    required String newEnglishText,
    required String newBlackfootText,
    required String newBlackfootAudio,
  }) {
    FirebaseFirestore.instance
        .collection('Conversations')
        .doc(oldConversationId)
        .update({
      'englishText': newEnglishText,
      'blackfootText': newBlackfootText,
      'blackfootAudio': newBlackfootAudio,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phrase updated successfully.'),
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

  void addConversation({
    required String blackfootText,
    required String englishText,
    required String seriesName,
    required String blackfootAudio,
    required BuildContext context,
  }) {
    if (blackfootText.isNotEmpty &&
        englishText.isNotEmpty &&
        seriesName.isNotEmpty &&
        blackfootAudio.isNotEmpty) {
      debugPrint('blackfootText: $blackfootText');
      debugPrint('englishText: $englishText');
      debugPrint('seriesName: $seriesName');
      debugPrint('blackfootAudio: $blackfootAudio');
      FirebaseFirestore.instance.collection('Conversations').add({
        'blackfootText': blackfootText,
        'englishText': englishText,
        'seriesName': seriesName,
        'blackfootAudio': blackfootAudio,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phrase added successfully.'),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add phrases. $error'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required.'),
        ),
      );
    }
  }
}
