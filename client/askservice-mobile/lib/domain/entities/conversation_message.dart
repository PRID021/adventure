import 'package:app_chat_proxy/domain/entities/conversation_role.dart';
import 'package:equatable/equatable.dart';

class ConversationMessage extends Equatable {
  final ConversationRole sender;
  final int id;
  final int conversationId;
  final DateTime createdAt;
  final StringBuffer content;

  const ConversationMessage({
    required this.sender,
    required this.id,
    required this.conversationId,
    required this.createdAt,
    required this.content,
  });

  @override
  List<Object?> get props => [
        sender,
        id,
        conversationId,
        content.toString(),
        createdAt.toIso8601String()
      ];
}
