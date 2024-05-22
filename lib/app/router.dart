import 'package:flutter/material.dart';
import 'package:morse_code_app/codebook/code_book.dart';
import 'package:morse_code_app/decode/decode_page.dart';
import 'package:morse_code_app/encode/encode_page.dart';
import 'package:morse_code_app/main_menu/main_page.dart';
import 'package:morse_code_app/settings/settings_page.dart';

const String mainPageRoute = '/main_page';
const String encodeRoute = '/encode';
const String decodeRoute = '/decode';
const String codeBookRoute = '/code_book';
const String settingsRoute = '/settings';

Route<dynamic> createRoute(settings) {
  switch (settings.name) {
    case mainPageRoute:
      return MainPage.route();
    case encodeRoute:
      return EncodePage.route();
    case decodeRoute:
      return DecodePage.route();
    case codeBookRoute:
      return CodeBookPage.route();
    case settingsRoute:
      return SettingsPage.route();
  }

  return MaterialPageRoute(
      builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ));
}
