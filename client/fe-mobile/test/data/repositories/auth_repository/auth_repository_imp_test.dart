import 'package:app_chat_proxy/core/common/result.dart';
import 'package:app_chat_proxy/data/repositories/auth_repository/auth_repository_imp.dart';
import 'package:app_chat_proxy/data/repositories/auth_repository/di.dart';
import 'package:app_chat_proxy/data/source_storage/local/data_storage.dart';
import 'package:app_chat_proxy/data/source_storage/local/di.dart';
import 'package:app_chat_proxy/data/source_storage/network/auth_api/auth_api.dart';
import 'package:app_chat_proxy/data/source_storage/network/auth_api/di.dart';
import 'package:app_chat_proxy/domain/entities/token.dart';
import 'package:app_chat_proxy/domain/repositories/auth_repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../common/create_container.dart';

class FakeAuthApi extends Mock implements AuthApi {}

class FakeDataStorage extends Mock implements DataStorage {}

void main() {
  group("Test Authenticate", () {
    late FakeAuthApi authApi;
    late FakeDataStorage dataStorage;
    late ProviderContainer container;
    late AuthRepository authRepository;
    const userName = "userName";
    const password = "password";
    setUp(() {
      authApi = FakeAuthApi();
      dataStorage = FakeDataStorage();
      container = createContainer(overrides: [
        authApiProvider.overrideWithValue(authApi),
        dataStorageProvider.overrideWithValue(dataStorage)
      ]);
      authRepository = container.read(authRepositoryProvider);
    });
    test("Test authenticate success expect return token data.", () async {
      const expectResult =
          Token(accessToken: "accessToken", tokenType: "tokenType");
      // Setup auth api response success
      when(() => authApi.authenticate(userName, password))
          .thenAnswer((invocation) async {
        return Future.value(
          Result.success(expectResult),
        );
      });
      when(() => dataStorage.write(AuthKey.accessToken, "accessToken"))
          .thenAnswer((invocation) async {
        return Future.value(true);
      });
      when(() => dataStorage.write(AuthKey.tokenType, "tokenType"))
          .thenAnswer((invocation) async {
        return Future.value(true);
      });

      final actuallyRs = await authRepository.authenticate(
          userName: userName, password: password);
      expect(actuallyRs, equals(expectResult));
    });
    test(
        "Test authenticate success expect return token data with storage token fail.",
        () async {
      const expectResult =
          Token(accessToken: "accessToken", tokenType: "tokenType");
      // Setup auth api response success
      when(() => authApi.authenticate(userName, password))
          .thenAnswer((invocation) async {
        return Future.value(
          Result.success(expectResult),
        );
      });
      when(() => dataStorage.write(AuthKey.accessToken, "accessToken"))
          .thenAnswer((invocation) async {
        return Future.value(false);
      });
      when(() => dataStorage.write(AuthKey.tokenType, "tokenType"))
          .thenAnswer((invocation) async {
        return Future.value(true);
      });

      final actuallyRs = await authRepository.authenticate(
          userName: userName, password: password);
      expect(actuallyRs, equals(expectResult));
    });

    test("Test authenticate fail expect to return null", () async {
      // Setup auth api response success
      when(() => authApi.authenticate(userName, password))
          .thenAnswer((invocation) async {
        return Future.value(
          Result.failure("Error"),
        );
      });
      when(() => dataStorage.write(AuthKey.accessToken, "accessToken"))
          .thenAnswer((invocation) async {
        return Future.value(true);
      });
      const expectRs = null;
      final actuallyRs = await authRepository.authenticate(
          userName: userName, password: password);
      expect(actuallyRs, equals(expectRs));
    });

    test("Test authenticate success expect to return token with some log",
        () async {
      const expectResult =
          Token(accessToken: "accessToken", tokenType: "tokenType");
      // Setup auth api response success
      when(() => authApi.authenticate(userName, password))
          .thenAnswer((invocation) async {
        return Future.value(
          Result.success(expectResult),
        );
      });
      when(() => dataStorage.write(AuthKey.accessToken, "accessToken"))
          .thenAnswer((invocation) async {
        return Future.value(false);
      });
      final actuallyRs = await authRepository.authenticate(
          userName: userName, password: password);
      expect(actuallyRs, equals(expectResult));
    });
  });

  group("Test Storage Token", () {
    late FakeAuthApi authApi;
    late FakeDataStorage dataStorage;
    late ProviderContainer container;
    late AuthRepository authRepository;
    setUp(() {
      authApi = FakeAuthApi();
      dataStorage = FakeDataStorage();
      container = createContainer(overrides: [
        authApiProvider.overrideWithValue(authApi),
        dataStorageProvider.overrideWithValue(dataStorage)
      ]);
      authRepository = container.read(authRepositoryProvider);
    });

    test("Should success return token data.", () async {
      const expectRs =
          Token(accessToken: "accessToken", tokenType: "tokenType");
      when(() => dataStorage.read(AuthKey.accessToken))
          .thenAnswer((invocation) {
        return "accessToken";
      });
      when(() => dataStorage.read(AuthKey.tokenType)).thenReturn("tokenType");
      when(() => dataStorage.read(AuthKey.accessToken))
          .thenReturn("accessToken");
      final actuallyRs = authRepository.storageToken();
      expect(actuallyRs, equals(expectRs));
    });

    test("Should  return null", () async {
      when(() => dataStorage.read(AuthKey.accessToken))
          .thenAnswer((invocation) {
        return "accessToken";
      });
      when(() => dataStorage.read(AuthKey.tokenType)).thenReturn("tokenType");
      when(() => dataStorage.read(AuthKey.accessToken))
          .thenAnswer((invocation) {
        throw "Some error";
      });
      final actuallyRs = authRepository.storageToken();
      expect(actuallyRs, equals(null));
    });

    test("Should clear storage token and return success", () async {
      when(() => dataStorage.delete(AuthKey.tokenType))
          .thenAnswer((invocation) async {
        return Future.value(true);
      });
      when(() => dataStorage.delete(AuthKey.accessToken))
          .thenAnswer((invocation) async {
        return Future.value(true);
      });

      const expectRs = true;
      final actuallyRs = await authRepository.clearStorage();
      expect(expectRs, equals(actuallyRs));
    });
  });
}
