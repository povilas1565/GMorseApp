import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:morse_code_app/decode/decode_viewmodel.dart';
import 'package:morse_code_app/model/decode.dart';

import 'rest_service.dart';

class DecodeDataService {
  static final DecodeDataService _instance = DecodeDataService._constructor();

  factory DecodeDataService() {
    return _instance;
  }

  DecodeDataService._constructor();
  final rest = RestService();

  Future<Decode?> sendMorseMessage(String processMes) async {
    try {
      final response = await rest.post('/decode_text', data: {
        'morse_mes': processMes,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return Decode.fromJson(json);
      }
    } catch (e) {
      DecodeViewmodel.decodeError = true;
      return null;
    }
    return null;
  }

  Future<Decode?> decodeAudioMorse(String path, String filename) async {
    try {
      final streamedRes = await rest.postAudio('/decode_audio', path, filename);
      if (streamedRes.statusCode == 200 || streamedRes.statusCode == 201) {
        var response = await http.Response.fromStream(streamedRes);
        final json = jsonDecode(response.body);
        return Decode.fromJson(json);
      }
    } catch (e) {
      DecodeViewmodel.decodeError = true;
      return null;
    }
    return null;
  }

  Future playMorseSound(
      {required String morse, required int freq, required int speed}) async {
    final response = await rest.postFile('/play_morse_audio', data: {
      "morse": morse,
      "freq": freq,
      "speed": speed,
    });
    return response;
  }
}
