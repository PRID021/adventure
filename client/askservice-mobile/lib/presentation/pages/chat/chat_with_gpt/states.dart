import 'package:app_chat_proxy/core/common/errors.dart';
import 'package:app_chat_proxy/domain/entities/conversation_message.dart';

abstract class AskScreenState {
  const AskScreenState();
}

class InitState extends AskScreenState {
  const InitState();
}

class InConversationState extends AskScreenState {
  final List<ConversationMessage> messages;
  const InConversationState({required this.messages});
}

class ErrorState extends AskScreenState {
  final CatchError? error;
  ErrorState([this.error]);
}
