import 'dart:io';

import 'package:bfootlearn/adminProfile/services/conversation_functions.dart';
import 'package:bfootlearn/components/color_file.dart';
import 'package:bfootlearn/components/text_style.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showDialogExportBatch({
  required BuildContext context,
  required String categoryName,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: purpleDark,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/export_batch_eg.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '''The file should be in XLSX or XLS format. The 1st Column should contain English Text and the 2nd Column should contain their respective Blackfoot Text.''',
              style: dialogBoxContentTextStyle.copyWith(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: actionButtonTextStyle,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              'Pick File',
              style: actionButtonTextStyle.copyWith(color: Colors.white),
            ),
            onPressed: () {
              pickFile(context: context, categoryName: categoryName);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

pickFile({required BuildContext context, required String categoryName}) async {
  final ConversationFucntions conversationFucntions = ConversationFucntions();

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
          seriesName: categoryName,
          blackfootAudio: 'noAudio',
          context: context,
        );
        data.add({
          'englishText': englishText.toString(),
          'blackfootText': blackfootText.toString(),
        });
      }
    }

    for (var item in data) {
      print(
          'English: ${item['englishText']}, Blackfoot: ${item['blackfootText']}');
    }
  } else {
    print('No file selected');
  }
}
