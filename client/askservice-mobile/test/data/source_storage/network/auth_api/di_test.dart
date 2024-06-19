import 'package:app_chat_proxy/data/source_storage/network/auth_api/auth_api.dart';
import 'package:app_chat_proxy/data/source_storage/network/auth_api/di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../common/create_container.dart';

void main() {
  late AuthApi authApi;
  late ProviderContainer container;

  group("Test auth api di", () {
    setUp(() {
      container = createContainer();
      authApi = container.read(authApiProvider);
    });

    test("AuthApi must be AuthApiImp", () {
      expect(authApi, isA<AuthApiImp>());
    });
  });
}
