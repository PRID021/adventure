import 'package:app_chat_proxy/core/common/env_keys.dart';
import 'package:app_chat_proxy/data/source_storage/network/chat_api/chat_api.dart';
import 'package:app_chat_proxy/data/source_storage/network/chat_api/di.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/test.dart';

void main() {
  late ProviderContainer container;
  group("Test di chat api", () {
    setUp(() async {
      await dotenv.load(fileName: ".env");
      EnvironmentLoader.load(dotenv);
      container = ProviderContainer();
    });

    test("Should return chat api", () {
      final chatApi = container.read(chatApiProvider);
      expect(chatApi, isA<ChatApiImp>());
    });
  });
}
