import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/http_error.dart';
import '../../../../core/network/sender.dart';
import 'auth_api.dart';
import 'auth_api_config.dart';

final authApiProvider = Provider<AuthApi>(
  (ref) => AuthApiImp(
    sender: Sender(
      httpApiConfig: AuthHttpApiConfig(),
      errorProcessing: ref.read(errorProcessingProvider),
    ),
  ),
);
