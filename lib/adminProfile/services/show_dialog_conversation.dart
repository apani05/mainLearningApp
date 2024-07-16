import 'package:bfootlearn/adminProfile/models/conversation_model.dart';
import 'package:bfootlearn/adminProfile/services/conversation_functions.dart';
import 'package:bfootlearn/adminProfile/services/flutter_sound_methods.dart';
import 'package:bfootlearn/adminProfile/widgets/dialogbox_textfield.dart';
import 'package:bfootlearn/adminProfile/widgets/old_audio_player.dart';
import 'package:bfootlearn/components/color_file.dart';
import 'package:flutter/material.dart';

import '../../components/text_style.dart';
import '../widgets/recording_audio_container.dart';

final ConversationFucntions conversationFucntions = ConversationFucntions();
final FlutterSoundMethods flutterSoundMethods = FlutterSoundMethods();

void showDialogDeleteConversations({
  required BuildContext context,
  required VoidCallback onPressedDelete,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Delete Phrases",
          style: dialogBoxTitleTextStyle,
        ),
        backgroundColor: purpleDark,
        content: Text(
          "Are you sure you want to delete the selected phrases?",
          style: dialogBoxContentTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: actionButtonTextStyle,
            ),
          ),
          TextButton(
            onPressed: () {
              onPressedDelete();
              Navigator.of(context).pop();
            },
            child: Text(
              "Delete",
              style: actionButtonTextStyle,
            ),
          ),
        ],
      );
    },
  );
}

void showDialogUpdatePhase({
  required BuildContext context,
  required ConversationModel oldConversation,
}) {
  final TextEditingController englishTextController = TextEditingController();
  final TextEditingController blackfootTextController = TextEditingController();
  englishTextController.text = oldConversation.englishText;
  blackfootTextController.text = oldConversation.blackfootText;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: purpleDark,
        title: Text(
          'Update Phrase',
          style: dialogBoxTitleTextStyle,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 15),
              DialogBoxTextField(
                controller: englishTextController,
                hintText: 'Enter English text',
              ),
              const SizedBox(height: 15),
              DialogBoxTextField(
                controller: blackfootTextController,
                hintText: 'Enter Blackfoot text',
              ),
              const SizedBox(height: 15),
              OldAudioPlayer(
                  oldBlackfootAudioPath: oldConversation.blackfootAudio),
              const SizedBox(height: 15),
              const RecordingAudioContainer(),
              const SizedBox(height: 15),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: actionButtonTextStyle,
            ),
            onPressed: () {
              flutterSoundMethods.dispose();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: () async {
              final blackfootText = blackfootTextController.text.trim();
              final englishText = englishTextController.text.trim();
              String blackfootAudioPath;

              if (blackfootText.isEmpty || englishText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Blackfoot text and English text cannot be empty.'),
                  ),
                );
                return;
              }

              try {
                final pathToSaveAudio =
                    await flutterSoundMethods.getPathToSave(context: context);
                debugPrint('Uploading audio file from path: $pathToSaveAudio');
                blackfootAudioPath = await conversationFucntions
                    .uploadAudioFileToFirebaseStorage(pathToSaveAudio);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Failed to upload audio file. Please try again.'),
                  ),
                );
                return;
              }

              conversationFucntions.updateConversation(
                context: context,
                oldConversationId: oldConversation.conversationId,
                newEnglishText: englishText,
                newBlackfootText: blackfootText,
                newBlackfootAudio: blackfootAudioPath,
              );
              Navigator.of(context).pop();
              flutterSoundMethods.dispose();
              englishTextController.clear();
              blackfootTextController.clear();
            },
            child: Text(
              'Update',
              style: actionButtonTextStyle,
            ),
          ),
        ],
      );
    },
  );
}

void showDialogAddPhase({
  required BuildContext context,
  required String categoryName,
}) {
  final TextEditingController englishTextController = TextEditingController();
  final TextEditingController blackfootTextController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: purpleDark,
        title: Text(
          'Add Phrase',
          style: dialogBoxTitleTextStyle,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 15),
              DialogBoxTextField(
                controller: englishTextController,
                hintText: 'Enter English text',
              ),
              const SizedBox(height: 15),
              DialogBoxTextField(
                controller: blackfootTextController,
                hintText: 'Enter Blackfoot text',
              ),
              const SizedBox(height: 15),
              const RecordingAudioContainer(),
              const SizedBox(height: 15),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Discard',
              style: actionButtonTextStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();

              flutterSoundMethods.dispose();
            },
          ),
          TextButton(
            onPressed: () async {
              final blackfootText = blackfootTextController.text.trim();
              final englishText = englishTextController.text.trim();
              String blackfootAudioPath;

              if (blackfootText.isEmpty || englishText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Blackfoot text and English text cannot be empty.'),
                  ),
                );
                return;
              }

              try {
                final pathToSaveAudio =
                    await flutterSoundMethods.getPathToSave(context: context);
                debugPrint('Uploading audio file from path: $pathToSaveAudio');
                blackfootAudioPath = await conversationFucntions
                    .uploadAudioFileToFirebaseStorage(pathToSaveAudio);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Failed to upload audio file. Please try again.'),
                  ),
                );
                return;
              }

              conversationFucntions.addConversation(
                context: context,
                seriesName: categoryName,
                englishText: englishTextController.text,
                blackfootText: blackfootTextController.text,
                blackfootAudio: blackfootAudioPath,
              );

              Navigator.of(context).pop();
              flutterSoundMethods.dispose();
              englishTextController.clear();
              blackfootTextController.clear();
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
