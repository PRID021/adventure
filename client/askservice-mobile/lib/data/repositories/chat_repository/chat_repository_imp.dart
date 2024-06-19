import 'package:app_chat_proxy/data/source_storage/network/chat_api/chat_api.dart';
import 'package:app_chat_proxy/dev/logger.dart';
import 'package:app_chat_proxy/domain/entities/conversation.dart';
import 'package:app_chat_proxy/domain/entities/conversation_message.dart';

import '../../../domain/repositories/chat_repository/chat_repository.dart';

class ChatRepositoryImp implements ChatRepository {
  final ChatApi api;

  ChatRepositoryImp({required this.api});

  @override
  Future<List<Conversation>?> getUserConversations() async {
    final rs = await api.getUserConversations();
    logger.w(rs);
    if (rs.isSuccess()) {
      return rs.getOrThrow();
    }
    return null;
  }

  @override
  Future<List<ConversationMessage>?> getConversationMessages(
      int conversationId) async {
    final rs =
        await api.getConversationMessages(conversationId: conversationId);
    if (rs.isSuccess()) {
      return rs.getOrThrow();
    }
    return null;
  }

  @override
  Future<Stream<String>?> postConversationMessage(
      {required int conversationId, required String content}) async {
    final rs = await api.getMessageResponse(
        conversationId: conversationId, content: content);
    if (rs.isSuccess()) {
      return rs.getOrThrow();
    }
    return null;
  }

  @override
  Future<Conversation?> createNewConversation() async {
    final rs = await api.createNewConversation();
    if (rs.isSuccess()) {
      return rs.getOrThrow();
    }
    return null;
  }
}
