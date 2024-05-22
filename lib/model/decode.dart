class Decode {
  String? morseMessage;
  String? processedMorse;
  String? decodedMessage;

  Decode({required this.processedMorse, required this.decodedMessage});

  Decode.fromJson(Map<String, dynamic> json)
      : this(
            processedMorse: json['processedMes'],
            decodedMessage: json['decodedMes']);

  Map<String, dynamic> toJson() => {
        'processedMes': processedMorse,
        'decodedMes': decodedMessage,
      };

  void getMorseMes() {
    String morse = processedMorse!.replaceAll('/', ' ');
    morseMessage = morse.replaceAll(';', '   ');
  }
}
