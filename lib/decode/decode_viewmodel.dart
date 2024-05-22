import 'dart:io';
import 'package:morse_code_app/app/dependencies.dart';
import 'package:morse_code_app/model/decode.dart';
import 'package:morse_code_app/services/decode_data_service.dart';
import 'package:morse_code_app/viewmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/audio_morse.dart';

class DecodeViewmodel extends Viewmodel {
  Decode? decode;
  static bool decodeError = false;

  DecodeDataService get dataService => service();

  setDecode(Decode decode) {
    this.decode = decode;
  }

  Decode? get decode1 => decode;

  Future<Decode?> getDecodeMes(String morseMes, String processedMes) async {
    decodeError = false;
    Decode? d1 = await dataService.sendMorseMessage(processedMes);

    if (d1 != null) {
      d1.morseMessage = morseMes;
    }
    return d1;
  }

  Future<Decode?> decodeAudio(String path, String filename) async {
    decodeError = false;
    Decode? d2 = await dataService.decodeAudioMorse(path, filename);

    if (d2 != null) {
      d2.getMorseMes();
    }

    return d2;
  }

  Future<AudioMorse?> playMorseSound(String m) async {
    decodeError = false;
    int speed;
    int freq;

    // get shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.containsKey("frequency")
        ? freq = prefs.getInt("frequency")!
        : freq = 500;

    prefs.containsKey("speed") ? speed = prefs.getInt("speed")! : speed = 7;

    try {
      final response = await dataService.playMorseSound(
        morse: m,
        freq: freq,
        speed: speed,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = File('$tempPath/sound.wav');
        await file.writeAsBytes(response.bodyBytes);
        return AudioMorse(audioFile: file, path: file.path);
      }
    } catch (e) {
      decodeError = true;
      return null;
    }
    return null;
  }
}
