import 'package:bfootlearn/adminProfile/models/category_model.dart';
import 'package:bfootlearn/adminProfile/models/conversation_model.dart';
import 'package:bfootlearn/adminProfile/services/show_dialog_conversation.dart';
import 'package:bfootlearn/adminProfile/widgets/existing_conversations_listview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCategoryPage extends StatefulWidget {
  final CategoryModel category;
  const EditCategoryPage({super.key, required this.category});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  @override
  Widget build(BuildContext context) {
    final categoryName = widget.category.categoryName;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          categoryName,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),

      // add new phase to particular category
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialogAddPhase(
          context: context,
          categoryName: categoryName,
        ),
        child: const Icon(
          Icons.add_rounded,
          size: 30,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Conversations')
                    .where('seriesName', isEqualTo: categoryName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<ConversationModel> conversations = List.from(
                    snapshot.data!.docs.map(
                      (doc) => ConversationModel(
                        timestamp: doc['timestamp'],
                        englishText: doc['englishText'],
                        blackfootText: doc['blackfootText'],
                        blackfootAudio: doc['blackfootAudio'],
                        seriesName: doc['seriesName'],
                        conversationId: doc.id,
                      ),
                    ),
                  );

                  // conversations =
                  //     snapshot.data!.docs; // Populate conversations list
                  // debugPrint(conversations[0]['englishText'].toString());

                  return ExistingConversationsListView(
                      conversations: conversations);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
