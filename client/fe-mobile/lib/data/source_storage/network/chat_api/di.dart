import 'package:app_chat_proxy/data/repositories/auth_repository/di.dart';
import 'package:app_chat_proxy/data/source_storage/network/chat_api/chat_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/http_error.dart';
import '../../../../core/network/sender.dart';
import 'chat_api_config.dart';

part 'di.g.dart';

@riverpod
ChatApi chatApi(ChatApiRef ref) {
  return ChatApiImp(
    sender: Sender(
      httpApiConfig: ChatHttpConfig(
        authRepository: ref.read(authRepositoryProvider),
      ),
      errorProcessing: ref.read(errorProcessingProvider),
    ),
  );
}
