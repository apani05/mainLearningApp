import 'package:bfootlearn/adminProfile/models/category_model.dart';
import 'package:bfootlearn/adminProfile/models/conversation_model.dart';
import 'package:bfootlearn/adminProfile/services/show_dialog_conversation.dart';
import 'package:bfootlearn/adminProfile/services/show_dialog_export_batch.dart';
import 'package:bfootlearn/adminProfile/widgets/admin_searchbar.dart';
import 'package:bfootlearn/adminProfile/widgets/existing_conversations_listview.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
  bool _isMultiSelectMode = false;

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

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        for (var conversation in _conversations) {
          conversation.selected = false;
        }
      }
    });
  }

  void _deleteSelectedConversations() {
    final selectedConversations =
        _conversations.where((conversation) => conversation.selected).toList();

    for (var conversation in selectedConversations) {
      FirebaseFirestore.instance
          .collection('Conversations')
          .doc(conversation.conversationId)
          .delete();
    }

    setState(() {
      _conversations.removeWhere((conversation) => conversation.selected);
      _filteredConversations
          .removeWhere((conversation) => conversation.selected);
      _isMultiSelectMode = false;
    });
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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: customAppBar(context: context, title: categoryName),

      // add new phase to particular category
      floatingActionButton: !_isMultiSelectMode
          ? SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.add_rounded),
                  label: 'Add a new phrase',
                  onTap: () => showDialogAddPhase(
                    context: context,
                    categoryName: categoryName,
                  ),
                ),
                SpeedDialChild(
                  child: const Icon(Icons.delete_rounded),
                  label: 'Delete phrases',
                  onTap: _toggleMultiSelectMode,
                ),
                SpeedDialChild(
                  child: const Icon(Icons.import_export_rounded),
                  label: 'Import from excel',
                  onTap: () => showDialogExportBatch(
                    context: context,
                    categoryName: categoryName,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () => showDialogDeleteConversations(
                    context: context,
                    onPressedDelete: _deleteSelectedConversations,
                  ),
                  child: const Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: _toggleMultiSelectMode,
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            AdminSearchBar(
                hintText: 'Search phrases...', controller: _searchController),
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
                    conversations: _filteredConversations,
                    isMultiSelectMode: _isMultiSelectMode,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
