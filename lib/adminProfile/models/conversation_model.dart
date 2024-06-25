class ConversationModel {
  final String englishText;
  final String blackfootText;
  final String blackfootAudio;
  final String seriesName;
  final String conversationId;
  final String timestamp;
  bool selected;

  ConversationModel({
    required this.timestamp,
    required this.englishText,
    required this.blackfootText,
    required this.blackfootAudio,
    required this.seriesName,
    required this.conversationId,
    this.selected = false,
  });
}
