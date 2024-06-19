import '../../../../domain/entities/conversation.dart';

abstract class HistoryScreenState {
  const HistoryScreenState();
}

class InitState extends HistoryScreenState {
  const InitState();
}

class LoadingState extends HistoryScreenState {
  const LoadingState();
}

class LoadingDone extends HistoryScreenState {
  final List<Conversation> conversations;

  LoadingDone({required this.conversations});
}

class ErrorState extends HistoryScreenState {
  final dynamic extendData;

  ErrorState({required this.extendData});
}
