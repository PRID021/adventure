import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  final int id;
  final String title;

  const Conversation({required this.id, required this.title});

  @override
  List<Object?> get props => [id, title];
}
