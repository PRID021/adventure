import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../router/app_router.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: TabBarView(
          children: [
            IconButton(
              icon: const Icon(Icons.rocket_launch),
              onPressed: () {
                context.router.push(const ChatHistoryRoute());
              },
            ),
            IconButton(
              icon: const Icon(Icons.directions_car),
              onPressed: () {
                context.router.push(const SettingRoute());
              },
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(color: Colors.grey),
          child: const TabBar(
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                icon: Icon(Icons.directions_transit),
              ),
              Tab(
                icon: Icon(Icons.directions_car),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.router.push(const AboutRoute());
          },
        ),
      ),
    );
  }
}
