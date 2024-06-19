import 'package:app_chat_proxy/presentation/common/providers/loading_manager_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/auth_repository/di.dart';
import '../../../dev/logger.dart';

enum AuthStatus {
  unAuthenticate,
  authenticated,
}

final authenticateNotifierProvider =
    NotifierProvider<AuthenticateNotifier, AuthStatus>(() {
  return AuthenticateNotifier();
});

class AuthenticateNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    final authRepository = ref.read(authRepositoryProvider);
    final token = authRepository.storageToken();
    if (token == null) {
      return AuthStatus.unAuthenticate;
    }
    return AuthStatus.authenticated;
  }

  Future<void> performAuthenticate(
      {required String userName, required String password}) async {
    ref.read(loadingStatusNotifierProvider.notifier).markLoading();
    final authRepository = ref.read(authRepositoryProvider);
    final rs = await authRepository.authenticate(
        userName: userName, password: password);
    logger.w(rs);
    if (rs != null) {
      state = AuthStatus.authenticated;
    } else {
      state = AuthStatus.unAuthenticate;
    }
    ref.read(loadingStatusNotifierProvider.notifier).markLoadingDone();
  }

  Future<void> clearStorage() async {
    ref.read(authRepositoryProvider).clearStorage().then((value) {
      state = AuthStatus.unAuthenticate;
    });
  }
}
