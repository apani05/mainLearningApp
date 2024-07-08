import 'dart:io';

import 'package:bfootlearn/adminProfile/models/category_model.dart';
import 'package:bfootlearn/adminProfile/models/conversation_model.dart';
import 'package:bfootlearn/adminProfile/services/conversation_functions.dart';
import 'package:bfootlearn/adminProfile/services/show_dialog_conversation.dart';
import 'package:bfootlearn/adminProfile/widgets/admin_searchbar.dart';
import 'package:bfootlearn/adminProfile/widgets/existing_conversations_listview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
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
  final ConversationFucntions conversationFucntions = ConversationFucntions();
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

  pickFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );

    if (pickedFile != null) {
      String? filePath = pickedFile.files.first.path;
      var bytes = File(filePath!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      var sheet = excel['Sheet1'];

      List<Map<String, String>> data = [];

      for (int row = 1; row < sheet.maxRows; row++) {
        var englishText = sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
            .value;
        var blackfootText = sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
            .value;

        if (englishText != null && blackfootText != null) {
          conversationFucntions.addConversation(
            blackfootText: blackfootText.toString(),
            englishText: englishText.toString(),
            seriesName: widget.category.categoryName,
            blackfootAudio: 'noAudio',
            context: context,
          );
          data.add({
            'englishText': englishText.toString(),
            'blackfootText': blackfootText.toString(),
          });
        }
      }

      // Now you have your data in the 'data' list
      for (var item in data) {
        print(
            'English: ${item['englishText']}, Blackfoot: ${item['blackfootText']}');
      }
    } else {
      // User canceled the picker
      print('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.category.categoryName;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          categoryName,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),

      // add new phase to particular category
      floatingActionButton: !_isMultiSelectMode
          ? SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.add_rounded),
                  label: 'Add',
                  onTap: () => showDialogAddPhase(
                    context: context,
                    categoryName: categoryName,
                  ),
                ),
                SpeedDialChild(
                  child: const Icon(Icons.delete_rounded),
                  label: 'Delete',
                  onTap: _toggleMultiSelectMode,
                ),
                SpeedDialChild(
                    child: const Icon(Icons.import_export_rounded),
                    label: 'Export',
                    onTap: () => pickFile()

                    // () async {
                    //   await importExcel(
                    //     context: context,
                    //     seriesName: categoryName,
                    //   );
                    // },
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
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
