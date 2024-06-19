import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  const CommonAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      // centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 1,
      backgroundColor: Theme.of(context).canvasColor,
      shadowColor: Theme.of(context).canvasColor,
      surfaceTintColor: Theme.of(context).canvasColor,
    );
  }
}
