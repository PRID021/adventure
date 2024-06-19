import 'package:dio/dio.dart';

import '../../../../core/common/environment.dart';
import '../../../../core/network/http_api_config.dart';
import '../../../../domain/repositories/auth_repository/auth_repository.dart';

class ChatHttpConfig implements HttpApiConfig {
  final AuthRepository authRepository;

  ChatHttpConfig({required this.authRepository});
  @override
  Dio createDio() {
    final options = BaseOptions(
        connectTimeout: const Duration(seconds: 10000),
        receiveTimeout: const Duration(seconds: 10000),
        headers: {
          "Authorization":
              "Bearer ${authRepository.storageToken()?.accessToken}"
        },
        baseUrl: appEnv.getData());
    return Dio(options);
  }

  @override
  // TODO: implement path
  String get path => "/chat";
}
