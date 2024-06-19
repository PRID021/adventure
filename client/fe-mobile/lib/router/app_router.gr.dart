// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AboutRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AboutScreen(),
      );
    },
    AskRoute.name: (routeData) {
      final args = routeData.argsAs<AskRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AskScreen(
          key: args.key,
          conversationId: args.conversationId,
        ),
      );
    },
    ChatHistoryRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChatHistoryScreen(),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChatScreen(
          key: args.key,
          title: args.title,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    OnBoardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnBoardScreen(),
      );
    },
    SettingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SettingScreen(),
      );
    },
  };
}

/// generated route for
/// [AboutScreen]
class AboutRoute extends PageRouteInfo<void> {
  const AboutRoute({List<PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [AskScreen]
class AskRoute extends PageRouteInfo<AskRouteArgs> {
  AskRoute({
    Key? key,
    required int conversationId,
    List<PageRouteInfo>? children,
  }) : super(
          AskRoute.name,
          args: AskRouteArgs(
            key: key,
            conversationId: conversationId,
          ),
          initialChildren: children,
        );

  static const String name = 'AskRoute';

  static const PageInfo<AskRouteArgs> page = PageInfo<AskRouteArgs>(name);
}

class AskRouteArgs {
  const AskRouteArgs({
    this.key,
    required this.conversationId,
  });

  final Key? key;

  final int conversationId;

  @override
  String toString() {
    return 'AskRouteArgs{key: $key, conversationId: $conversationId}';
  }
}

/// generated route for
/// [ChatHistoryScreen]
class ChatHistoryRoute extends PageRouteInfo<void> {
  const ChatHistoryRoute({List<PageRouteInfo>? children})
      : super(
          ChatHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatHistoryRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChatScreen]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    Key? key,
    required String title,
    List<PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            key: key,
            title: title,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static const PageInfo<ChatRouteArgs> page = PageInfo<ChatRouteArgs>(name);
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.title,
  });

  final Key? key;

  final String title;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, title: $title}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnBoardScreen]
class OnBoardRoute extends PageRouteInfo<void> {
  const OnBoardRoute({List<PageRouteInfo>? children})
      : super(
          OnBoardRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnBoardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SettingScreen]
class SettingRoute extends PageRouteInfo<void> {
  const SettingRoute({List<PageRouteInfo>? children})
      : super(
          SettingRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
