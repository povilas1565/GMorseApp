import 'package:get_it/get_it.dart';
import 'package:morse_code_app/decode/decode_viewmodel.dart';
import 'package:morse_code_app/encode/encode_viewmodel.dart';
import 'package:morse_code_app/services/decode_data_service.dart';
import 'package:morse_code_app/services/encode_data_service.dart';

import '../services/rest_service.dart';

GetIt service = GetIt.instance;

void init() {
  // Data service
  service.registerLazySingleton(() => RestService());
  service.registerLazySingleton(() => EncodeDataService());
  service.registerLazySingleton(() => EncodeViewModel());
  service.registerLazySingleton(() => DecodeDataService());
  service.registerLazySingleton(() => DecodeViewmodel());
}
