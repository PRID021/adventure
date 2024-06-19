import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends PreferredSize {
  final Widget? title;

  const CommonAppBar({
    super.key,
    this.title,
    super.preferredSize = const Size.fromHeight(56.0),
    super.child = const SizedBox.shrink(),
  });

  @override
  PreferredSize build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        title: title,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            context.router.pop();
          },
          child: Center(
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).colorScheme.background,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
