import 'dart:ui';

import '../../../data/source_storage/local/data_storage.dart';

abstract class UserRepository {
  Locale? getUserLocale();
  Future<bool> setUserReferLocale(Locale locale);
  bool? isDarkMode();
  Future<bool> setUserReferMode(bool isDarkMode);
  final DataStorage userReferenceDataStorage;
  UserRepository({required this.userReferenceDataStorage});
}
