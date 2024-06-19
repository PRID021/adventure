import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LoadingStatus {
  onLoading,
  stable
}


final loadingStatusNotifierProvider = NotifierProvider<
    LoadingStatusNotifier,
    LoadingStatus>(() => LoadingStatusNotifier());


class LoadingStatusNotifier extends Notifier<LoadingStatus> {
  @override
  LoadingStatus build() {
    return LoadingStatus.stable;
  }

  void markLoadingDone() {
    state = LoadingStatus.stable;
  }

  void markLoading() {
    state = LoadingStatus.onLoading;
  }

}