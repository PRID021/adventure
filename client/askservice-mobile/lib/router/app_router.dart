import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../presentation/pages/about/about_screen.dart';
import '../presentation/pages/chat/chat_history/chat_history_screen.dart';
import '../presentation/pages/chat/chat_with_gemini/chat_screen.dart';
import '../presentation/pages/chat/chat_with_gpt/ask_screen.dart';
import '../presentation/pages/home/home.dart';
import '../presentation/pages/login/login.dart';
import '../presentation/pages/on_board/on_board.dart';
import '../presentation/pages/setting/setting_tab.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  AppRouter({super.navigatorKey});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: OnBoardRoute.page, path: "/"),
        AutoRoute(page: LoginRoute.page, path: "/login"),
        AutoRoute(page: HomeRoute.page, path: "/home"),
        AutoRoute(page: ChatRoute.page, path: "/home/history/chat"),
        AutoRoute(page: AskRoute.page, path: "/home/history/ask"),
        AutoRoute(page: ChatHistoryRoute.page, path: "/home/history"),
        AutoRoute(page: SettingRoute.page, path: "/home/setting"),
        AutoRoute(page: AboutRoute.page, path: "/home/about")
      ];
}
