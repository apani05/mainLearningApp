import 'package:bfootlearn/adminProfile/models/category_model.dart';
import 'package:bfootlearn/adminProfile/models/conversation_model.dart';
import 'package:bfootlearn/adminProfile/services/show_dialog_conversation.dart';
import 'package:bfootlearn/adminProfile/widgets/admin_searchbar.dart';
import 'package:bfootlearn/adminProfile/widgets/existing_conversations_listview.dart';
import 'package:bfootlearn/adminProfile/widgets/recording_audio_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditCategoryPage extends ConsumerStatefulWidget {
  final CategoryModel category;
  const EditCategoryPage({super.key, required this.category});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCategoryPageState();
}

class _EditCategoryPageState extends ConsumerState<EditCategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<ConversationModel> _conversations = [];
  List<ConversationModel> _filteredConversations = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterConversations);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterConversations);
    _searchController.dispose();
    super.dispose();
  }

  void _filterConversations() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredConversations = _conversations.where((conversation) {
        return conversation.englishText.toLowerCase().contains(query) ||
            conversation.blackfootText.toLowerCase().contains(query) ||
            conversation.timestamp.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.category.categoryName;
    final timerService = ref.watch(timerServiceProvider);
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
          timerService: timerService,
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
            AdminSearchBar(
                hintText: 'Search conversation...',
                controller: _searchController),
            const SizedBox(height: 20),
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
                  _conversations = List.from(
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
                  _filteredConversations = _conversations.where((conversation) {
                    String query = _searchController.text.toLowerCase();
                    return conversation.englishText
                            .toLowerCase()
                            .contains(query) ||
                        conversation.blackfootText
                            .toLowerCase()
                            .contains(query) ||
                        conversation.timestamp.toLowerCase().contains(query);
                  }).toList();

                  return ExistingConversationsListView(
                      conversations: _filteredConversations);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
