import 'dart:typed_data';

import 'package:app_chat_proxy/core/common/env_keys.dart';
import 'package:app_chat_proxy/core/common/environment.dart';
import 'package:app_chat_proxy/core/common/result.dart';
import 'package:app_chat_proxy/core/network/http_api_config.dart';
import 'package:app_chat_proxy/core/network/http_error.dart';
import 'package:app_chat_proxy/core/network/sender.dart';
import 'package:app_chat_proxy/data/source_storage/network/chat_api/chat_api.dart';
import 'package:app_chat_proxy/domain/entities/conversation.dart';
import 'package:app_chat_proxy/domain/entities/conversation_message.dart';
import 'package:app_chat_proxy/domain/entities/conversation_role.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpApiConfig extends Mock implements HttpApiConfig {}

class MockErrorProcessing extends Mock implements ErrorProcessing {}

class MockDio extends Mock implements Dio {}

void main() {
  /// Parsers
  late ConversationParser conversationParser;
  late ConversationsParser conversationsParser;
  late ConversationRoleParse conversationRoleParse;
  late ConversationMessagesParser conversationMessagesParser;
  late BotMessageStreamParser botMessageStreamParser;
  group("Test Parsers", () {
    setUp(() {
      conversationParser = ConversationParser();
      conversationsParser = ConversationsParser();
      conversationRoleParse = ConversationRoleParse();
      conversationMessagesParser = ConversationMessagesParser();
      botMessageStreamParser = BotMessageStreamParser();
    });

    test("Should parse Map to Conversation Model", () {
      const expected = Conversation(id: 1, title: "title1");
      final json = {'id': 1, 'title': "title1"};
      final conversation = conversationParser.fromSource(json: json);
      expect(conversation, isA<Conversation>());
      expect(conversation, equals(expected));
    });

    test("Should parse Map to List Conversation Model", () {
      const expected = [
        Conversation(id: 1, title: "title1"),
        Conversation(id: 2, title: "title2")
      ];
      final json = [
        {'id': 1, 'title': "title1"},
        {'id': 2, 'title': "title2"}
      ];
      final conversations = conversationsParser.fromSource(json: json);
      expect(conversations, isA<List<Conversation>>());
      expect(conversations, equals(expected));
    });

    test("Should convert json to ConversationRole model", () {
      const expected = ConversationRole.hu;
      const json = 0;
      final rs = conversationRoleParse.fromSource(json: json);
      expect(rs, equals(expected));
    });

    test("Should return List[ConversationMessage] from json", () {
      final json = [
        {
          'sender': 1,
          'id': 1,
          'conversation_id': 1,
          'created_at': '20120227T132700',
          'content': 'some content1'
        },
        {
          'sender': 0,
          'id': 2,
          'conversation_id': 2,
          'created_at': '20120227T132700',
          'content': 'some content2'
        }
      ];
      final expected = [
        ConversationMessage(
          sender: ConversationRole.ai,
          id: 1,
          conversationId: 1,
          createdAt: DateTime.parse("20120227T132700"),
          content: StringBuffer("some content1"),
        ),
        ConversationMessage(
          sender: ConversationRole.hu,
          id: 2,
          conversationId: 2,
          createdAt: DateTime.parse("20120227T132700"),
          content: StringBuffer("some content2"),
        ),
      ];
      final rs = conversationMessagesParser.fromSource(json: json);
      expect(rs, isA<List<ConversationMessage>>());
      expect(rs, equals(expected));
    });

    test("Should convert stream binary to stream string", () {
      const hello = "Hello";
      const world = "World";
      final outputAsUint8Lists = [
        Uint8List.fromList(hello.codeUnits),
        Uint8List.fromList(world.codeUnits)
      ];
      final stream = Stream<Uint8List>.fromIterable(outputAsUint8Lists);
      final ResponseBody json = ResponseBody(stream, 200);
      final streamRs = botMessageStreamParser.fromSource(json: json);
      expect(streamRs, emitsInOrder([hello, world]));
    });
  });

  /// Test ChatApiImp
  late ErrorProcessing errorProcessing;
  late HttpApiConfig httpApiConfig;
  late Dio dio;
  late Sender sender;
  late BaseOptions baseOption;
  late String path;

  late ChatApiImp chatApi;
  group(
    "Test ChatApiImp",
    () {
      setUp(() async {
        await dotenv.load(fileName: ".env");
        EnvironmentLoader.load(dotenv);
        path = "/chat";
        baseOption = BaseOptions(baseUrl: appEnv.getData());
        dio = MockDio();
        errorProcessing = MockErrorProcessing();
        httpApiConfig = MockHttpApiConfig();
        sender = Sender(
            httpApiConfig: httpApiConfig, errorProcessing: errorProcessing);
        when(() => httpApiConfig.createDio()).thenReturn(dio);
        when(() => dio.options).thenReturn(baseOption);
        when(() => httpApiConfig.path).thenReturn(path);
        when(() => httpApiConfig.createDio()).thenReturn(dio);
        chatApi = ChatApiImp(sender: sender);
      });

      test("Should return List<Conversation>", () async {
        const pathParam = "conversation";
        final data = [
          {'id': 1, 'title': 'title1'},
          {'id': 2, 'title': "title2"}
        ];
        when(() => dio.get(
              "$path/$pathParam",
              data: any(named: "data"),
              queryParameters: any(named: "queryParameters"),
              options: any(named: "options"),
            )).thenAnswer((invocation) async {
          return Future.value(
            Response(
              requestOptions: RequestOptions(),
              data: data,
            ),
          );
        });
        final expectedRs = [
          const Conversation(id: 1, title: "title1"),
          const Conversation(id: 2, title: "title2")
        ];
        final rs = await chatApi.getUserConversations();
        expect(rs, isA<Success>());
        expect(rs.getOrThrow(), isA<List<Conversation>>());
        expect(rs.getOrThrow(), equals(expectedRs));
      });

      test(
        "Should return List<ConversationMessage>",
        () async {
          const conversationId = 1;
          const pathParam = "conversation/$conversationId";
          final data = [
            {
              'sender': 1,
              'id': 1,
              'conversation_id': 1,
              'created_at': '20120227T132700',
              'content': 'some content1'
            },
            {
              'sender': 0,
              'id': 2,
              'conversation_id': 2,
              'created_at': '20120227T132700',
              'content': 'some content2'
            }
          ];
          when(() => dio.get(
                "$path/$pathParam",
                data: any(named: "data"),
                queryParameters: any(named: "queryParameters"),
                options: any(named: "options"),
              )).thenAnswer(
            (invocation) async {
              return Future.value(
                Response(
                  requestOptions: RequestOptions(),
                  data: data,
                ),
              );
            },
          );
          final expected = [
            ConversationMessage(
              sender: ConversationRole.ai,
              id: 1,
              conversationId: 1,
              createdAt: DateTime.parse("20120227T132700"),
              content: StringBuffer("some content1"),
            ),
            ConversationMessage(
              sender: ConversationRole.hu,
              id: 2,
              conversationId: 2,
              createdAt: DateTime.parse("20120227T132700"),
              content: StringBuffer("some content2"),
            ),
          ];

          final rs = await chatApi.getConversationMessages(
              conversationId: conversationId);
          expect(rs, isA<Success>());
          expect(rs.getOrThrow(), isA<List<ConversationMessage>>());
          expect(rs.getOrThrow(), equals(expected));
        },
      );

      test(
        "Should return Stream<String> when post an message",
        () async {
          const conversationId = 1;
          const content = "Some content";

          const hello = "Hello";
          const world = "World";
          final outputAsUint8Lists = [
            Uint8List.fromList(hello.codeUnits),
            Uint8List.fromList(world.codeUnits)
          ];
          final stream = Stream<Uint8List>.fromIterable(outputAsUint8Lists);
          final ResponseBody data = ResponseBody(stream, 200);
          when(() => dio.get(path,
              queryParameters: {
                "conversation_id": conversationId,
                "message": content,
              },
              data: any(named: "data"),
              options: any(named: "options"))).thenAnswer((invocation) async {
            return Future.value(Response(
                requestOptions:
                    RequestOptions(responseType: ResponseType.stream),
                data: data));
          });
          final rs = await chatApi.getMessageResponse(
              conversationId: conversationId, content: content);
          expect(rs, isA<Success>());
          expect(rs.getOrThrow(), isA<Stream<String>>());
          expect(rs.getOrThrow(), emitsInOrder([hello, world]));
        },
      );

      test("Should create and return an new conversation", () async {
        const pathParam = "conversation";
        final data = {'id': 1, 'title': ""};
        when(() => dio.post("$path/$pathParam",
            data: any(named: "data"),
            queryParameters: any(named: "queryParameters"),
            options: any(named: 'options'))).thenAnswer((invocation) async {
          return Future.value(
              Response(requestOptions: RequestOptions(), data: data));
        });

        const expectedRs = Conversation(id: 1, title: "");
        final rs = await chatApi.createNewConversation();
        expect(rs, isA<Success>());
        expect(rs.getOrThrow(), equals(expectedRs));
      });
    },
  );
}
