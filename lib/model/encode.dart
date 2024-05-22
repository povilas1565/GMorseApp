class Encode {
  String? encodedMessage;
  String? textMessage;
  String? changedMessage;

  Encode({this.textMessage, this.encodedMessage});

  Encode.fromJson(Map<String, dynamic> json)
      : this(textMessage: json['textMes'], encodedMessage: json['encodedMes']);

  Map<String, dynamic> toJson() => {
        'textMes': textMessage,
        'encodedMes': encodedMessage,
      };
}
