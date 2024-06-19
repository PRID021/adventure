import 'package:app_chat_proxy/data/repositories/auth_repository/di.dart';
import 'package:app_chat_proxy/dev/logger.dart';
import 'package:app_chat_proxy/presentation/pages/about/states.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final aboutScreenStateNotifierProvider =
    NotifierProvider<AboutScreenStateNotifier, AboutScreenState>(() {
  return AboutScreenStateNotifier();
});

class AboutScreenStateNotifier extends Notifier<AboutScreenState> {
  @override
  AboutScreenState build() {
    return const InitState();
  }

  void setUpCookie({required WebUri uri}) async {
    logger.w("setUpCookie");
    state = const InitState();
    try {
      final token = ref.read(authRepositoryProvider).storageToken();
      final expiresDate =
          DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch;
      CookieManager cookieManager = CookieManager.instance();
      if (token != null) {
        await cookieManager.setCookie(
            url: uri,
            name: "access_token",
            value: token.accessToken,
            expiresDate: expiresDate,
            isSecure: true);
        await cookieManager.setCookie(
            url: uri,
            name: "token_type",
            value: "token.tokenType",
            expiresDate: expiresDate,
            isSecure: true);
      }
    } catch (e) {
      logger.e(e);
    }
    logger.w("setDone");
    state = const StableState();
  }
}
