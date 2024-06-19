import 'package:app_chat_proxy/data/repositories/chat_repository/chat_repository_imp.dart';
import 'package:app_chat_proxy/data/source_storage/network/chat_api/di.dart';
import 'package:app_chat_proxy/domain/repositories/chat_repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImp(
    api: ref.read(chatApiProvider),
  );
});
