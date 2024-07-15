class CardData {
  final String documentId;
  final String englishText;
  final String blackfootText;
  final String blackfootAudio;
  final String seriesName;

  CardData({
    required this.documentId,
    required this.englishText,
    required this.blackfootText,
    required this.blackfootAudio,
    required this.seriesName,
  });

  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'englishText': englishText,
      'blackfootText': blackfootText,
      'blackfootAudio': blackfootAudio,
      'seriesName': seriesName,
    };
  }

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      documentId: json['documentId']??'',
      englishText: json['englishText']??'',
      blackfootText: json['blackfootText']??'',
      blackfootAudio: json['blackfootAudio']??'',
      seriesName: json['seriesName']??'',
    );
  }
}
