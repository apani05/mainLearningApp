import 'package:bfootlearn/adminProfile/models/category_model.dart';
import 'package:bfootlearn/adminProfile/models/conversation_model.dart';
import 'package:bfootlearn/adminProfile/services/show_dialog_conversation.dart';
import 'package:bfootlearn/adminProfile/widgets/admin_searchbar.dart';
import 'package:bfootlearn/adminProfile/widgets/existing_conversations_listview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
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

  Future<void> importExcel(
      {required BuildContext context, required String seriesName}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null && result.files.isNotEmpty) {
      var bytes = result.files.single.bytes;
      debugPrint('bytes: $bytes');
      if (bytes != null) {
        var excel = Excel.decodeBytes(bytes);

        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table];
          if (sheet != null) {
            for (var row in sheet.rows.skip(1)) {
              // Assuming the first row is the header
              var englishText = row[0]?.value?.toString() ?? '';
              var blackfootText = row[1]?.value?.toString() ?? '';
              var blackfootAudio =
                  ''; // Assuming audio will be handled separately

              debugPrint('english: $englishText and blackfoot: $blackfootText');
              if (englishText.isNotEmpty && blackfootText.isNotEmpty) {
                conversationFucntions.addConversation(
                  blackfootText: blackfootText,
                  englishText: englishText,
                  seriesName: seriesName,
                  blackfootAudio: blackfootAudio,
                  context: context,
                );
              }
            }
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file selected or file is empty.'),
        ),
      );
    }
  }

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
        actions: [
          IconButton(
            onPressed: () async {
              await importExcel(
                context: context,
                seriesName: categoryName,
              );
            },
            icon: const Icon(
              Icons.import_export_rounded,
              size: 30,
            ),
          ),
          if (_isMultiSelectMode)
            IconButton(
              onPressed: _deleteSelectedConversations,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          else
            IconButton(
              onPressed: _toggleMultiSelectMode,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
        ],
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
