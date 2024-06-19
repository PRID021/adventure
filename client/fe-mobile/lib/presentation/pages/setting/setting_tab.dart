import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import '../login/authenticate_provider.dart';

@RoutePage()
class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SettingSection(
                  title: "Appearance",
                ),
                const Spacer(),
                const Divider(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Consumer(builder: (context, ref, _) {
                    return TextButton(
                      onPressed: () {
                        ref
                            .read(authenticateNotifierProvider.notifier)
                            .clearStorage();
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.logout), Gap(8), Text("Logout")],
                      ),
                    );
                  }),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class SettingSection extends StatelessWidget {
  final String title;

  const SettingSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Light mode",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer,
                                ),
                      ),
                      SizedBox(
                        height: 32,
                        child: LiteRollingSwitch(
                          width: 88,
                          value: true,
                          colorOn: Theme.of(context).colorScheme.primary,
                          colorOff: Theme.of(context).colorScheme.tertiary,
                          textOn: 'Light',
                          textOff: 'Dark',
                          iconOn: Icons.sunny,
                          iconOff: Icons.mode_night_rounded,
                          textSize: 12,
                          onChanged: (bool state) {},
                          onTap: () {},
                          onDoubleTap: () {},
                          onSwipe: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Language",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer,
                                ),
                      ),
                      SizedBox(
                        height: 32,
                        child: LiteRollingSwitch(
                          width: 88,
                          value: true,
                          colorOn: Theme.of(context).colorScheme.primary,
                          colorOff: Theme.of(context).colorScheme.tertiary,
                          textOn: 'En',
                          textOff: 'Vi',
                          iconOn: Icons.done,
                          iconOff: Icons.remove_circle_outline,
                          textSize: 12,
                          onChanged: (bool state) {},
                          onTap: () {},
                          onDoubleTap: () {},
                          onSwipe: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
