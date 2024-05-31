import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/adminProfile/models/conversation_model.dart';
import 'package:bfootlearn/adminProfile/services/show_dialog_conversation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String convertGsUrlToHttp(String gsUrl) {
  const String baseUrl = 'https://firebasestorage.googleapis.com/v0/b/';
  final Uri uri = Uri.parse(gsUrl);
  final String bucketName = uri.authority;
  final String filePath = uri.path.substring(1).replaceAll('/', '%2F');
  return '$baseUrl$bucketName/o/$filePath?alt=media';
}

class ExistingConversationsListView extends StatelessWidget {
  final List<ConversationModel> conversations;
  const ExistingConversationsListView({super.key, required this.conversations});

  @override
  Widget build(BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final currentConversation = conversations[index];
        final uploadDate = DateFormat("dd MMMM, yyyy")
            .format(DateTime.parse(currentConversation.timestamp));

        // playback blackfoot audio
        void onPressedAudioButton() async {
          debugPrint(currentConversation.blackfootAudio);
          await audioPlayer.play(UrlSource(
              convertGsUrlToHttp(currentConversation.blackfootAudio)));
        }

        // edits the conversation
        void onPressedEditButton() {
          showDialogUpdatePhase(
            context: context,
            oldConversation: currentConversation,
          );
        }

        // deletes the conversation
        void onPressedDeleteButton() {
          showDialogDeletePhase(
            context: context,
            conversation: currentConversation,
          );
        }

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          title: Text(currentConversation.englishText),
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          subtitle: Column(
            children: [
              const SizedBox(height: 3),
              Row(
                children: [
                  const Icon(Icons.calendar_month),
                  const SizedBox(width: 5),
                  Text(uploadDate),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // playback audio of conversation
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: onPressedAudioButton,
                icon: const Icon(Icons.volume_up_rounded),
                iconSize: 25,
                color: Colors.purpleAccent,
              ),
              // edit conversation button
              IconButton(
                onPressed: onPressedEditButton,
                icon: const Icon(
                  Icons.mode_edit_rounded,
                  size: 25,
                  color: Colors.cyan,
                ),
              ),
              // delete conversation button
              IconButton(
                onPressed: onPressedDeleteButton,
                icon: const Icon(
                  Icons.delete_rounded,
                  size: 25,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
