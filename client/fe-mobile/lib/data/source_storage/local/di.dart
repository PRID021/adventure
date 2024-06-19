import 'package:app_chat_proxy/data/source_storage/local/share_preference_data_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data_storage.dart';

final Provider<DataStorage> dataStorageProvider = Provider((ref) {
  return ShareReferenceDataStorage.instance;
});
