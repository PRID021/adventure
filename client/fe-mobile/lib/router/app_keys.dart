import 'package:flutter/material.dart';

abstract class AppKeys {
  final GlobalKey appKey;
  final GlobalKey<NavigatorState> navKey;

  AppKeys({required this.appKey, required this.navKey});

  forceRebuild();
}

class AppChatProxyKeys extends AppKeys {
  AppChatProxyKeys({required super.appKey, required super.navKey});

  @override
  forceRebuild() => (appKey.currentContext as Element).markNeedsBuild();
}
