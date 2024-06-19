import 'package:app_chat_proxy/domain/entities/conversation_message.dart';
import 'package:app_chat_proxy/presentation/common/components/wild_card.dart';
import 'package:app_chat_proxy/presentation/pages/chat/chat_with_gpt/states.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../domain/entities/conversation_role.dart';
import '../utils/code_element_builder.dart';
import 'ask_screen_state_provider.dart';

@RoutePage()
class AskScreen extends StatefulHookConsumerWidget {
  final int conversationId;

  const AskScreen({super.key, required this.conversationId});

  @override
  ConsumerState<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends ConsumerState<AskScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final _scrollController = ScrollController();
  var ableScrollToEnd = true;
  late int conversationId;

  @override
  void initState() {
    super.initState();
    conversationId = widget.conversationId;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref
        .watch<AskScreenState>(askScreenStateNotifierProvider(conversationId));

    useEffect(() {
      final notifier =
          ref.read(askScreenStateNotifierProvider(conversationId).notifier);
      notifier.loadingMessageHistory();
      return () {
        _scrollController.dispose();
        textEditingController.dispose();
      };
    }, [conversationId]);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (ableScrollToEnd && state is InConversationState) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.bounceInOut,
        );
      }
    });

    Widget? body;
    if (state is InitState) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is InConversationState) {
      body = _buildConversationBody(state.messages);
    }
    return Scaffold(
      body: SafeArea(
        child: body ?? const WildCard(),
      ),
    );
  }

  Widget _buildConversationBody(List<ConversationMessage> messages) {
    return Column(
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
              itemCount: messages.length,
              itemBuilder: (context, idx) {
                final message = messages[idx];
                bool isHuman = message.sender == ConversationRole.hu;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isHuman
                      ? HumanMessage(message: message)
                      : BotMessage(message: message),
                );
              },
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
                  onPressed: _postMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _postMessage() {
    final huMessageContent = textEditingController.text;
    textEditingController.clear();
    ableScrollToEnd = true;
    ref
        .read(askScreenStateNotifierProvider(conversationId).notifier)
        .postConversationMessage(huMessageContent);
  }
}

class HumanMessage extends StatelessWidget {
  final ConversationMessage message;

  const HumanMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
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
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purpleAccent.withOpacity(0.25),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                message.content.toString(),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BotMessage extends StatelessWidget {
  final ConversationMessage message;

  const BotMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
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
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
                  data: message.content.toString()),
            ),
          ),
        ),
      ],
    );
  }
}
