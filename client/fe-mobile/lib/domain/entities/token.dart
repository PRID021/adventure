import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String accessToken;
  final String tokenType;

  const Token({
    required this.accessToken,
    required this.tokenType,
  });

  @override
  List<Object> get props => [accessToken, tokenType];
}
