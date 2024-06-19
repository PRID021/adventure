import 'package:app_chat_proxy/data/source_storage/local/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EagerInitialization extends ConsumerWidget {
  const EagerInitialization({super.key, required this.builder});
  final Widget Function(BuildContext context, WidgetRef ref) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Eagerly initialize providers by watching them.
    // By using "watch", the provider will stay alive and not be disposed.
    final dataStorage = ref.watch(dataStorageProvider);
    final doneInFuture = Future.wait([
      dataStorage.init(),
    ]);

    return FutureBuilder(
      future: doneInFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(context, ref);
        }
        if (snapshot.hasError) {
          return ErrorWidget.withDetails(
            message: "Init service failed",
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
