import 'package:app_chat_proxy/data/repositories/auth_repository/di.dart';
import 'package:app_chat_proxy/domain/entities/token.dart';
import 'package:app_chat_proxy/domain/repositories/auth_repository/auth_repository.dart';
import 'package:app_chat_proxy/presentation/common/providers/loading_manager_provider.dart';
import 'package:app_chat_proxy/presentation/pages/login/authenticate_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../common/create_container.dart';
import '../../../common/mocks/listener.dart';
import '../../../common/mocks/mock_auth_repository.dart';

void main() {
  late ProviderContainer providerContainer;
  late AuthRepository authRepository;
  late Listener<AuthStatus> authStateListener;
  late Listener<LoadingStatus> loadingStatusListener;
  late AuthenticateNotifier authenticateNotifier;
  group("Test screen state notifier provider", () {
    setUp(() {
      authRepository = MockAuthRepository();
      authStateListener = Listener<AuthStatus>();
      loadingStatusListener = Listener<LoadingStatus>();
      providerContainer = createContainer(overrides: [
        authRepositoryProvider.overrideWithValue(authRepository)
      ]);
      providerContainer.listen(
        authenticateNotifierProvider,
        authStateListener,
        fireImmediately: true,
      );
      providerContainer.listen(
        loadingStatusNotifierProvider,
        loadingStatusListener,
        fireImmediately: true,
      );

      authenticateNotifier =
          providerContainer.read(authenticateNotifierProvider.notifier);
    });
    test("Verify init value of build method", () {
      verify(() => authStateListener(null, AuthStatus.unAuthenticate));
      verify(() => loadingStatusListener(null, LoadingStatus.stable));
    });

    test("Verify when sign in success the state change to authenticated",
        () async {
      when(() => authRepository.authenticate(
          userName: any(named: "userName"),
          password: any(named: "password"))).thenAnswer((invocation) {
        return Future.value(
            const Token(accessToken: 'accessToken', tokenType: 'tokenType'));
      });
      verify(() => authStateListener(null, AuthStatus.unAuthenticate));
      verify(() => loadingStatusListener(null, LoadingStatus.stable));

      await authenticateNotifier.performAuthenticate(
          userName: "userName", password: "password");

      verifyInOrder([
        () => loadingStatusListener(
            LoadingStatus.stable, LoadingStatus.onLoading),
        () => authStateListener(
            AuthStatus.unAuthenticate, AuthStatus.authenticated),
        () => loadingStatusListener(
            LoadingStatus.onLoading, LoadingStatus.stable),
      ]);
      verifyNoMoreInteractions(authStateListener);
      verifyNoMoreInteractions(loadingStatusListener);
      verify(() => authRepository.authenticate(
          userName: "userName", password: "password")).called(1);
    });

    test("Should in unAuthenticated state when perform authenticate fail",
        () async {
      when(() => authRepository.authenticate(
          userName: any(named: "userName"),
          password: any(named: "password"))).thenAnswer((invocation) {
        return Future.value(null);
      });
      verify(() => authStateListener(null, AuthStatus.unAuthenticate));
      verify(() => loadingStatusListener(null, LoadingStatus.stable));

      await authenticateNotifier.performAuthenticate(
          userName: "userName", password: "password");
      verifyInOrder([
        () => loadingStatusListener(
            LoadingStatus.stable, LoadingStatus.onLoading),
        () => loadingStatusListener(
            LoadingStatus.onLoading, LoadingStatus.stable),
      ]);
      expect(authenticateNotifier.state, equals(AuthStatus.unAuthenticate));
      verifyNoMoreInteractions(authStateListener);
      verifyNoMoreInteractions(loadingStatusListener);
      verify(() => authRepository.authenticate(
          userName: "userName", password: "password")).called(1);
    });

    test("Should in auAuthenticated state after clean storage", () async {
      authenticateNotifier.state = AuthStatus.authenticated;
      when(() => authRepository.clearStorage()).thenAnswer((invocation) async {
        return Future.value(true);
      });
      verify(() => authStateListener(null, AuthStatus.unAuthenticate));
      verify(() => authStateListener(
          AuthStatus.unAuthenticate, AuthStatus.authenticated));
      await authenticateNotifier.clearStorage();
      verify(() => authStateListener(
          AuthStatus.authenticated, AuthStatus.unAuthenticate));
    });
  });
}
