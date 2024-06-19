import 'dart:ui';

import 'package:app_chat_proxy/domain/repositories/user_repository/user_repository.dart';

abstract class UserReferenceKeys {
  static String localeKey = "USER_LOCALE";
  static String lightMode = "IS_DARK_MODE";
}

class UserRepositoryImp extends UserRepository {
  UserRepositoryImp({required super.userReferenceDataStorage});

  @override
  Locale? getUserLocale() {
    try {
      final localeCode =
          userReferenceDataStorage.read<String>(UserReferenceKeys.localeKey);
      if (localeCode == 'vi') {
        return const Locale('vi', 'VN');
      }
      if (localeCode == 'en') {
        return const Locale('en', 'EN');
      }
    } catch (e) {
      return null;
    }

    throw Error();
  }

  @override
  bool? isDarkMode() {
    try {
      final isDarkMode =
          userReferenceDataStorage.read<bool>(UserReferenceKeys.lightMode);
      return isDarkMode;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setUserReferLocale(Locale locale) async {
    if (locale.languageCode == 'vi' || locale.languageCode == 'en') {
      final success = await userReferenceDataStorage.write<String>(
          UserReferenceKeys.localeKey, locale.languageCode);
      return success;
    }
    return false;
  }

  @override
  Future<bool> setUserReferMode(bool isDarkMode) async {
    final success = await userReferenceDataStorage.write(
        UserReferenceKeys.lightMode, isDarkMode);
    return success;
  }
}
