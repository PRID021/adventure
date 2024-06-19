import 'package:app_chat_proxy/core/common/env_keys.dart';
import 'package:app_chat_proxy/core/common/environment.dart';
import 'package:app_chat_proxy/data/source_storage/network/auth_api/auth_api_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthHttpApiConfig authHttpApiConfig;
  late Dio dio;
  group("AuthHttpApiConfig Test", () {
    setUp(() async {
      authHttpApiConfig = AuthHttpApiConfig();
      await dotenv.load(fileName: ".env");
      EnvironmentLoader.load(dotenv);
      dio = authHttpApiConfig.createDio();
      return Future.value(0);
    });

    test("Should have path is /token ", () {
      expect(authHttpApiConfig.path, equals("/token"));
    });

    test("Create dio instance have the same baseUrl as environment", () {
      expect(dio.options.baseUrl, equals(appEnv.getData()));
    });
  });
}
