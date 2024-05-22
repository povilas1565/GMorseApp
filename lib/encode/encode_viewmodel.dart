import 'dart:io';
import 'package:morse_code_app/model/audio_morse.dart';
import 'package:path_provider/path_provider.dart';

import 'package:morse_code_app/model/encode.dart';
import 'package:morse_code_app/services/encode_data_service.dart';
import 'package:morse_code_app/viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/dependencies.dart';

class EncodeViewModel extends Viewmodel {
  Encode? encode;
  static bool encodeError = false;

  EncodeDataService get dataService => service();

  setEncode(Encode encode) {
    this.encode = encode;
  }

  Encode? get encode1 => encode;

  Future<Encode?> getEncodedMes(String textMes) async {
    encodeError = false;
    //turnBusy();
    Encode? e1 = await dataService.sendTextMessage(textMes);
    if (e1 != null) {
      String? changedMes = e1.encodedMessage;
      changedMes = changedMes!.replaceAll("/", " ");
      changedMes = changedMes.replaceAll(";", "   ");
      //print("changed message = " + changedMes);
      e1.changedMessage = changedMes;
    }

    return e1;
    //turnIdle();
  }

  Future<AudioMorse?> playMorseSound(String m) async {
    encodeError = false;
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
      encodeError = true;
      return null;
    }
    return null;
  }
}
