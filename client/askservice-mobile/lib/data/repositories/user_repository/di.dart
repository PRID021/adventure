import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/repositories/user_repository/user_repository.dart';
import '../../source_storage/local/di.dart';
import 'user_repository_imp.dart';

final userReferenceRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImp(
    userReferenceDataStorage: ref.watch(dataStorageProvider),
  );
});
