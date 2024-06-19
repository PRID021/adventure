import 'package:app_chat_proxy/core/common/result.dart';
import 'package:app_chat_proxy/data/repositories/chat_repository/di.dart';
import 'package:app_chat_proxy/data/source_storage/network/chat_api/chat_api.dart';
import 'package:app_chat_proxy/data/source_storage/network/chat_api/di.dart';
import 'package:app_chat_proxy/domain/entities/conversation.dart';
import 'package:app_chat_proxy/domain/entities/conversation_message.dart';
import 'package:app_chat_proxy/domain/entities/conversation_role.dart';
import 'package:app_chat_proxy/domain/repositories/chat_repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../common/create_container.dart';

class MockChatApi extends Mock implements ChatApi {}

void main() {
  group("Test Chat Repository GetUserConversation", () {
    late ChatApi chatApi;
    late ChatRepository chatRepository;
    ProviderContainer container;
    setUp(() {
      chatApi = MockChatApi();
      container = createContainer(
          overrides: [chatApiProvider.overrideWithValue(chatApi)]);
      chatRepository = container.read(chatRepositoryProvider);
    });
    test("Should return list conversation", () async {
      List<Conversation>? expectRs = List.generate(
          10, (index) => Conversation(id: index, title: "title$index}"));
      when(() => chatApi.getUserConversations()).thenAnswer(
        (invocation) async {
          return Future.value(Result.success(expectRs));
        },
      );
      final actuallyRs = await chatRepository.getUserConversations();
      expect(actuallyRs, isA<List<Conversation>?>());
      expect(actuallyRs, equals(expectRs));
    });

    test("Should return null", () async {
      when(() => chatApi.getUserConversations()).thenAnswer((invocation) async {
        return Future.value(Result.failure("Test Error"));
      });
      final rs = await chatRepository.getUserConversations();
      expect(rs, equals(null));
    });
  });

  group("Test Chat Repository GetUserConversationMessage", () {
    late ChatApi chatApi;
    late ChatRepository chatRepository;
    ProviderContainer container;
    const conversationId = 1;
    setUp(() {
      chatApi = MockChatApi();
      container = createContainer(
          overrides: [chatApiProvider.overrideWithValue(chatApi)]);
      chatRepository = container.read(chatRepositoryProvider);
    });

    test("Should return List<ConversationMessage>", () async {
      final expected = List.generate(
        10,
        (index) => ConversationMessage(
          sender: index.isEven ? ConversationRole.hu : ConversationRole.ai,
          id: index,
          conversationId: conversationId,
          createdAt: DateTime.now(),
          content: StringBuffer("Some content"),
        ),
      );
      when(() =>
              chatApi.getConversationMessages(conversationId: conversationId))
          .thenAnswer((invocation) async {
        return Future.value(Result.success(expected));
      });
      final rs = await chatRepository.getConversationMessages(conversationId);
      expect(rs, isA<List<ConversationMessage>>());
      expect(rs, equals(expected));
    });

    test("Should return null", () async {
      when(() =>
              chatApi.getConversationMessages(conversationId: conversationId))
          .thenAnswer((invocation) async {
        return Future.value(Result.failure("Some error"));
      });
      final rs = await chatRepository.getConversationMessages(conversationId);
      expect(rs, equals(null));
    });
  });

  group("Test Chat Repository CreateNewConversation", () {
    late ChatApi chatApi;
    late ChatRepository chatRepository;
    ProviderContainer container;

    setUp(() {
      chatApi = MockChatApi();
      container = createContainer(
          overrides: [chatApiProvider.overrideWithValue(chatApi)]);
      chatRepository = container.read(chatRepositoryProvider);
    });
    test("Should return a new Conversation model ", () async {
      const expected = Conversation(id: 1, title: "title");
      when(() => chatApi.createNewConversation())
          .thenAnswer((invocation) async {
        return Future.value(Result.success(expected));
      });
      final rs = await chatRepository.createNewConversation();
      expect(rs, isA<Conversation>());
      expect(rs, equals(expected));
    });

    test("Should return null as result of create new conversation failed",
        () async {
      when(() => chatApi.createNewConversation())
          .thenAnswer((invocation) async {
        return Future.value(Result.failure("Some error"));
      });
      final rs = await chatRepository.createNewConversation();
      expect(rs, equals(null));
    });
  });

  group("Test Chat Repository PostConversationMessage", () {
    late ChatApi chatApi;
    late ChatRepository chatRepository;
    ProviderContainer container;
    const conversationId = 1;
    const content = "Test content";
    setUp(() {
      chatApi = MockChatApi();
      container = createContainer(
          overrides: [chatApiProvider.overrideWithValue(chatApi)]);
      chatRepository = container.read(chatRepositoryProvider);
    });

    test("Should return Stream<String> of reply content.", () async {
      final expectSteam = Stream.fromIterable(["h", "e", "l", "l", "o"]);
      when(
        () => chatApi.getMessageResponse(
          conversationId: conversationId,
          content: content,
        ),
      ).thenAnswer((invocation) async {
        return Future.value(Result.success(expectSteam));
      });

      final rs = await chatRepository.postConversationMessage(
          conversationId: conversationId, content: content);
      expect(rs, isA<Stream<String>>());
      expect(rs, emitsInOrder(["h", "e", "l", "l", "o", emitsDone]));
    });

    test("Should return null as fail to conversation with ai", () async {
      when(() => chatApi.getMessageResponse(
          conversationId: conversationId,
          content: content)).thenAnswer((invocation) async {
        return Future.value(Result.failure("Some error"));
      });
      final rs = await chatRepository.postConversationMessage(
          conversationId: conversationId, content: content);
      expect(rs, equals(null));
    });
  });
}
