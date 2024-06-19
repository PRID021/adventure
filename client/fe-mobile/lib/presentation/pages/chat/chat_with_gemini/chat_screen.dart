import 'dart:async';
import 'dart:convert';

import 'package:app_chat_proxy/dev/logger.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../../../../core/common/env_keys.dart';
import '../../../../../../data/repositories/auth_repository/di.dart';
import '../utils/code_element_builder.dart';

class QuestionAnswer {
  final String question;
  final StringBuffer answer;

  QuestionAnswer({required this.question, required this.answer});
}

@RoutePage()
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final List<QuestionAnswer> conversationChats = [];
  final TextEditingController textEditingController = TextEditingController();
  final _scrollController = ScrollController();
  var ableScrollToEnd = true;

  void requestAnswer() async {
    try {
      String question = textEditingController.text;

      setState(() {
        ableScrollToEnd = true;
        textEditingController.clear();
      });
      if (question.isEmpty) {
        return;
      }
      final requestModel =
          QuestionAnswer(question: question, answer: StringBuffer());
      conversationChats.add(requestModel);
      final request = http.StreamedRequest(
        "GET",
        Uri(
            scheme: EnvironmentLoader.geminiScheme,
            host: EnvironmentLoader.geminiHost,
            path: "/chat-with-gemi/gemi",
            queryParameters: {"message": question}),
      );
      request.headers.addAll({
        'Authorization':
            'Bearer ${ref.read(authRepositoryProvider).storageToken()?.accessToken}',
      });

      unawaited(request.sink.close());
      final response = await request.send();
      response.stream.listen((value) {
        setState(() {
          final chunk = utf8.decode(value);
          requestModel.answer.write(chunk);
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (ableScrollToEnd) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 250),
                curve: Curves.bounceInOut,
              );
            }
          });
        });
      });
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification is UserScrollNotification) {
                    ableScrollToEnd = false;
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, idx) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black12,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.person,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const Gap(8),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.purpleAccent.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    conversationChats[idx].question,
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black12,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.rocket_launch_sharp,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const Gap(8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black12,
                                  ),
                                  child: MarkdownBody(
                                      shrinkWrap: true,
                                      builders: {
                                        'code': CodeElementBuilder(),
                                      },
                                      data: conversationChats[idx]
                                          .answer
                                          .toString()),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: conversationChats.length,
                ),
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    IconButton(
                      iconSize: 24,
                      color: Colors.blue,
                      onPressed: requestAnswer,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
