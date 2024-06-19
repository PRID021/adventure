import 'package:app_chat_proxy/domain/entities/token.dart';

abstract class AuthRepository {
  Future<Token?> authenticate(
      {required String userName, required String password});

  Token? storageToken();

  Future<bool> clearStorage();
}
