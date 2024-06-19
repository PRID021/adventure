import 'package:app_chat_proxy/data/source_storage/local/di.dart';
import 'package:app_chat_proxy/data/source_storage/network/auth_api/di.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/repositories/auth_repository/auth_repository.dart';
import 'auth_repository_imp.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImp(
    ref.read(authApiProvider),
    ref.read(dataStorageProvider),
  ),
);
