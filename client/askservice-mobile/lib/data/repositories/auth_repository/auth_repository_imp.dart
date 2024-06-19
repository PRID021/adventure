import 'package:app_chat_proxy/core/common/result.dart';
import 'package:app_chat_proxy/dev/logger.dart';
import 'package:app_chat_proxy/domain/entities/token.dart';

import '../../../domain/repositories/auth_repository/auth_repository.dart';
import '../../source_storage/local/data_storage.dart';
import '../../source_storage/network/auth_api/auth_api.dart';

class AuthKey {
  static String accessToken = "ACCESS_TOKEN";
  static String tokenType = "TOKEN_TYPE";
}

class AuthRepositoryImp implements AuthRepository {
  final AuthApi api;
  final DataStorage dataStorage;

  AuthRepositoryImp(this.api, this.dataStorage);

  @override
  Future<Token?> authenticate(
      {required String userName, required String password}) async {
    final rs = await api.authenticate(userName, password);

    if (rs is Success) {
      final token = rs.getOrThrow();
      try {
        final b1 =
            await dataStorage.write(AuthKey.accessToken, token.accessToken);
        final b2 = await dataStorage.write(AuthKey.tokenType, token.tokenType);
        if (!(b1 && b2)) {
          logger.e("Save token false");
        }
        logger.w("Save token success");
      } catch (e) {
        logger.e(e);
      }
      return token;
    } else {
      return null;
    }
  }

  @override
  Token? storageToken() {
    try {
      final accessToken = dataStorage.read(AuthKey.accessToken);
      final tokenType = dataStorage.read(AuthKey.tokenType);
      return Token(accessToken: accessToken, tokenType: tokenType);
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  @override
  Future<bool> clearStorage() async {
    return await dataStorage.delete(AuthKey.accessToken) &&
        await dataStorage.delete(AuthKey.tokenType);
  }
}
