import 'package:bfootlearn/adminProfile/models/conversation_model.dart';
import 'package:bfootlearn/adminProfile/services/conversation_functions.dart';
import 'package:bfootlearn/adminProfile/services/flutter_sound_methods.dart';
import 'package:bfootlearn/adminProfile/services/timer_methods.dart';
import 'package:bfootlearn/adminProfile/widgets/dialogbox_textfield.dart';
import 'package:bfootlearn/adminProfile/widgets/old_audio_player.dart';
import 'package:flutter/material.dart';

import '../../components/text_style.dart';
import '../widgets/recording_audio_container.dart';

final ConversationFucntions conversationFucntions = ConversationFucntions();

void showDialogDeletePhase({
  required BuildContext context,
  required ConversationModel conversation,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.purple.shade300,
        content: Text(
          'Do you want to delete this conversation?',
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
              conversationFucntions.deleteConversation(
                conversationId: conversation.conversationId,
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
        backgroundColor: Colors.purple.shade300,
        title: Text(
          'Update Phase',
          style: dialogBoxTitleTextStyle,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 15),
            // english text
            DialogBoxTextField(
              controller: englishTextController,
              hintText: 'Enter English text',
            ),
            const SizedBox(height: 15),
            // blackfoot text
            DialogBoxTextField(
              controller: blackfootTextController,
              hintText: 'Enter Blackfoot text',
            ),
            const SizedBox(height: 15),
            OldAudioPlayer(
                oldBlackfootAudioPath: oldConversation.blackfootAudio),
            const SizedBox(height: 15),
            // blackfoot audio
            const RecordingAudioContainer(),
            const SizedBox(height: 15),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: actionButtonTextStyle,
            ),
            onPressed: () {
              FlutterSoundMethods().dispose();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: () async {
              // Trim the text fields to remove leading and trailing spaces
              final blackfootText = blackfootTextController.text.trim();
              final englishText = englishTextController.text.trim();
              String blackfootAudioPath;

              // Validate the fields
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
                blackfootAudioPath = await ConversationFucntions()
                    .uploadAudioFileToFirebaseStorage(
                        FlutterSoundMethods().pathToSaveAudio);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Failed to upload audio file. Please try again.'),
                  ),
                );
                return;
              }

              ConversationFucntions().updateConversation(
                context: context,
                oldConversationId: oldConversation.conversationId,
                newEnglishText: englishText,
                newBlackfootText: blackfootText,
                newBlackfootAudio: blackfootAudioPath,
              );
              Navigator.of(context).pop();
              FlutterSoundMethods().dispose();
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
  required TimerServiceProvider timerService,
}) {
  final TextEditingController englishTextController = TextEditingController();
  final TextEditingController blackfootTextController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: Colors.purple.shade300,
        title: Text(
          'Add Phase',
          style: dialogBoxTitleTextStyle,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 15),
            // english text
            DialogBoxTextField(
              controller: englishTextController,
              hintText: 'Enter English text',
            ),
            const SizedBox(height: 15),
            // blackfoot text
            DialogBoxTextField(
              controller: blackfootTextController,
              hintText: 'Enter Blackfoot text',
            ),
            const SizedBox(height: 15),
            // blackfoot audio
            const RecordingAudioContainer(),
            const SizedBox(height: 15),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Discard',
              style: actionButtonTextStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              timerService.resetTimerForRecorder();
              FlutterSoundMethods().dispose();
            },
          ),
          TextButton(
            onPressed: () async {
              // Trim the text fields to remove leading and trailing spaces
              final blackfootText = blackfootTextController.text.trim();
              final englishText = englishTextController.text.trim();
              String blackfootAudioPath;

              // Validate the fields
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
                blackfootAudioPath = await ConversationFucntions()
                    .uploadAudioFileToFirebaseStorage(
                        FlutterSoundMethods().pathToSaveAudio);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Failed to upload audio file. Please try again.'),
                  ),
                );
                return;
              }

              ConversationFucntions().addConversation(
                context: context,
                seriesName: categoryName,
                englishText: englishTextController.text,
                blackfootText: blackfootTextController.text,
                blackfootAudio: blackfootAudioPath,
              );

              Navigator.of(context).pop();
              FlutterSoundMethods().dispose();
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
