import 'package:app_chat_proxy/core/common/result.dart';
import 'package:app_chat_proxy/core/network/http_api_config.dart';
import 'package:app_chat_proxy/core/network/http_error.dart';
import 'package:app_chat_proxy/core/network/sender.dart';
import 'package:app_chat_proxy/data/source_storage/network/auth_api/auth_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpApiConfig extends Mock implements HttpApiConfig {}

class MockErrorProcessing extends Mock implements ErrorProcessing {}

class MockDio extends Mock implements Dio {}

void main() {
  group("Test Auth Api", () {
    const userName = "userName";
    const password = "password";
    const data = {"access_token": "access_token", "token_type": "token_type"};
    const baseUrl = "http://localhost:8080";
    const path = "/token";

    late BaseOptions baseOption;
    late HttpApiConfig httpApiConfig;
    late ErrorProcessing errorProcessing;
    late Dio dio;
    late Sender sender;
    late AuthApiImp authApi;

    setUp(() {
      baseOption = BaseOptions(baseUrl: baseUrl);
      httpApiConfig = MockHttpApiConfig();
      errorProcessing = MockErrorProcessing();
      dio = MockDio();
      when(() => dio.options).thenReturn(baseOption);
      when(() => httpApiConfig.path).thenReturn(path);
      when(() => httpApiConfig.createDio()).thenReturn(dio);
      sender = Sender(
          httpApiConfig: httpApiConfig, errorProcessing: errorProcessing);
      authApi = AuthApiImp(sender: sender);
    });

    test("Should return Token", () async {
      when(
        () => dio.post(
          path,
          data: any(named: "data"),
          queryParameters: any(named: "queryParameters"),
          options: any(named: "options"),
        ),
      ).thenAnswer((invocation) async {
        return Future.value(
          Response(
            requestOptions: RequestOptions(),
            data: data,
          ),
        );
      });
      final rs = await authApi.authenticate(userName, password);
      expect(rs, isA<Result>());
    });
  });
}
