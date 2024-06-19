import 'package:app_chat_proxy/core/common/env_keys.dart';
import 'package:app_chat_proxy/core/common/environment.dart';
import 'package:app_chat_proxy/data/source_storage/network/chat_api/chat_api_config.dart';
import 'package:app_chat_proxy/domain/entities/token.dart';
import 'package:app_chat_proxy/domain/repositories/auth_repository/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ChatHttpConfig chatHttpConfig;
  late AuthRepository authRepository;
  group("Test ChatHttpApiConfig", () {
    setUp(() async {
      await dotenv.load(fileName: ".env");
      EnvironmentLoader.load(dotenv);
      authRepository = MockAuthRepository();
      chatHttpConfig = ChatHttpConfig(authRepository: authRepository);
    });

    test("Path should be `/chat`", () {
      expect(chatHttpConfig.path, equals("/chat"));
    });

    test("Should create new dio base on current environment", () {
      when(() => authRepository.storageToken()).thenReturn(
          const Token(accessToken: "accessToken", tokenType: "tokenType"));
      final dio = chatHttpConfig.createDio();
      expect(dio, isA<Dio>());
      expect(dio.options.baseUrl, equals(appEnv.getData()));
    });
  });
}
