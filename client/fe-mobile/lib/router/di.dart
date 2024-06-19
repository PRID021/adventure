import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_keys.dart';
import 'app_router.dart';

final Provider<AppKeys> appKeysProvider = Provider((ref) {
  return AppChatProxyKeys(
    appKey: GlobalKey(),
    navKey: GlobalKey<NavigatorState>(),
  );
});

final Provider<AppRouter> appRouterProvider = Provider((ref) {
  return AppRouter(navigatorKey: ref.read(appKeysProvider).navKey);
});
