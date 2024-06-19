import 'package:app_chat_proxy/dev/logger.dart';
import 'package:app_chat_proxy/presentation/common/providers/loading_manager_provider.dart';
import 'package:app_chat_proxy/presentation/pages/login/authenticate_provider.dart';
import 'package:app_chat_proxy/router/app_router.dart';
import 'package:app_chat_proxy/router/di.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'core/common/env_keys.dart';
import 'di.dart';
import 'eager_initialization.dart';
import 'firebase_options.dart';

final analyticsProvider = Provider((ref) => FirebaseAnalytics.instance);
late final PackageInfo packageInfo;
late final String? initialLink;

Future<void> initUniLinks() async {
  // Platform messages may fail, so we use a try/catch PlatformException.
  try {
    initialLink = await getInitialLink();
    // Parse the link and warn the user, if it is not correct,
    // but keep in mind it could be `null`.
  } on PlatformException {
    // Handle exception by warning the user their action did not succeed
    // return?
  }
}

void main() async {
  await dotenv.load(fileName: ".env");
  await EnvironmentLoader.load(dotenv);

  WidgetsFlutterBinding.ensureInitialized();
  await initUniLinks();
  OneSignal.initialize("c641c4e2-0fc0-4059-b054-c72bab45770e");
  await OneSignal.Notifications.requestPermission(true);
  packageInfo = await PackageInfo.fromPlatform();
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final analytics = FirebaseAnalytics.instanceFor(app: app);
  final analyticsProvider = Provider((ref) => analytics);
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://3ed1a9d63b4f1fec38f7592845d15296@o4506788251893760.ingest.sentry.io/4506788288004096';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      ProviderScope(
        overrides: [analyticsProvider],
        child: const MyApp(),
      ),
    ),
  );

  runApp(
    ProviderScope(
      overrides: [analyticsProvider],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return EagerInitialization(
      key: ref.read(appKeysProvider).appKey,
      builder: (context, ref) {
        late ThemeMode themeMode;
        final userReferences = ref.watch(userReferencesNotifierProvider);
        if (userReferences.isDarkMode == true) {
          themeMode = ThemeMode.dark;
        }
        if (userReferences.isDarkMode == false) {
          themeMode = ThemeMode.light;
        }
        if (userReferences.isDarkMode == null) {
          themeMode = ThemeMode.system;
        }
        ThemeData theme = ThemeData();
        logger.d(userReferences.isDarkMode);
        final authStatus = ref.watch(authenticateNotifierProvider);
        return MaterialApp.router(
          routerConfig: ref.watch(appRouterProvider).config(
              initialRoutes: authStatus == AuthStatus.authenticated
                  ? [const HomeRoute()]
                  : []),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: themeMode,
          locale: userReferences.locale,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return KeyedSubtree(
              child: Consumer(
                  child: child,
                  builder: (context, ref, child) {
                    ref.listen(authenticateNotifierProvider, (_, authStatus) {
                      if (authStatus == AuthStatus.unAuthenticate) {
                        ref
                            .read(appKeysProvider)
                            .navKey
                            .currentContext!
                            .router
                            .replaceAll([const LoginRoute()]);
                      } else {
                        ref
                            .read(appKeysProvider)
                            .navKey
                            .currentContext!
                            .router
                            .replaceAll([const HomeRoute()]);
                      }
                    });
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        child ?? const SizedBox.shrink(),
                        Consumer(builder: (context, ref, child) {
                          LoadingStatus status =
                              ref.watch(loadingStatusNotifierProvider);
                          if (status == LoadingStatus.stable) {
                            return const SizedBox.shrink();
                          }
                          return DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2)),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        })
                      ],
                    );
                  }),
            );
          },
        );
      },
    );
  }
}
