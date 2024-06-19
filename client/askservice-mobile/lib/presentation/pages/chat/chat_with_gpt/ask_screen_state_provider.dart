import 'package:app_chat_proxy/core/common/errors.dart';
import 'package:app_chat_proxy/data/repositories/chat_repository/di.dart';
import 'package:app_chat_proxy/presentation/pages/chat/chat_with_gpt/states.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/conversation_message.dart';
import '../../../../domain/entities/conversation_role.dart';

final askScreenStateNotifierProvider =
    NotifierProvider.family<AskScreenStateNotifier, AskScreenState, int>(
        AskScreenStateNotifier.new);

class AskScreenStateNotifier extends FamilyNotifier<AskScreenState, int> {
  late int conversationId;

  AskScreenStateNotifier();

  void loadingMessageHistory() async {
    final messages = await ref
        .read(chatRepositoryProvider)
        .getConversationMessages(conversationId);
    if (messages != null) {
      state = InConversationState(messages: messages!);
    } else {
      state = ErrorState(
        const UnknownError("Some error happened please try again later."),
      );
    }
  }

  void postConversationMessage(String messageContent) async {
    final humanMessage = ConversationMessage(
      sender: ConversationRole.hu,
      id: -1,
      conversationId: conversationId,
      createdAt: DateTime.now(),
      content: StringBuffer(messageContent),
    );
    final botAnswerBuffer = StringBuffer();
    final botReply = ConversationMessage(
      sender: ConversationRole.ai,
      id: -1,
      conversationId: conversationId,
      createdAt: DateTime.now(),
      content: botAnswerBuffer,
    );
    final oldMessages = (state as InConversationState).messages;
    oldMessages.addAll([humanMessage, botReply]);
    state = InConversationState(messages: oldMessages);
    final streamAnswer = await ref
        .read(chatRepositoryProvider)
        .postConversationMessage(
            conversationId: conversationId, content: messageContent);
    streamAnswer?.listen((event) {
      // logger.w(event);
      botAnswerBuffer.write(event);
      state = InConversationState(messages: oldMessages);
    });
  }

  @override
  build(arg) {
    conversationId = arg;
    return const InitState();
  }
}
