import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/adminProfile/models/conversation_model.dart';
import 'package:bfootlearn/adminProfile/services/show_dialog_conversation.dart';
import 'package:bfootlearn/components/color_file.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String convertGsUrlToHttp(String gsUrl) {
  const String baseUrl = 'https://firebasestorage.googleapis.com/v0/b/';
  final Uri uri = Uri.parse(gsUrl);
  final String bucketName = uri.authority;
  final String filePath = uri.path.substring(1).replaceAll('/', '%2F');
  return '$baseUrl$bucketName/o/$filePath?alt=media';
}

class ExistingConversationsListView extends StatefulWidget {
  final List<ConversationModel> conversations;
  final bool isMultiSelectMode;
  const ExistingConversationsListView({
    super.key,
    required this.conversations,
    required this.isMultiSelectMode,
  });

  @override
  State<ExistingConversationsListView> createState() =>
      _ExistingConversationsListViewState();
}

class _ExistingConversationsListViewState
    extends State<ExistingConversationsListView> {
  @override
  Widget build(BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = screenHeight * 0.1;

    return ListView.builder(
      itemCount: widget.conversations.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.conversations.length) {
          return SizedBox(height: bottomPadding);
        }

        final currentConversation = widget.conversations[index];
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

        void selectConversation(ConversationModel conversation) {
          setState(() {
            conversation.selected = !conversation.selected;
          });
        }

        return ListTile(
          leading: widget.isMultiSelectMode
              ? Checkbox(
                  value: currentConversation.selected,
                  onChanged: (value) {
                    selectConversation(currentConversation);
                  },
                )
              : null,
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
          trailing: !widget.isMultiSelectMode
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // playback audio of conversation
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: onPressedAudioButton,
                      icon: const Icon(Icons.volume_up_rounded),
                      iconSize: 25,
                      color: purpleDark,
                    ),
                    // edit and delete conversation buttons
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: onPressedEditButton,
                      icon: const Icon(Icons.mode_edit_rounded),
                      iconSize: 25,
                      color: purpleDark,
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }
}
