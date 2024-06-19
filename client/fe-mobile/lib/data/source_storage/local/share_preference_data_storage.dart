import 'package:app_chat_proxy/data/source_storage/local/data_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareReferenceDataStorage extends DataStorage {
  static final ShareReferenceDataStorage _instance =
      ShareReferenceDataStorage._internal();

  ShareReferenceDataStorage._internal();

  static ShareReferenceDataStorage get instance => _instance;

  // Obtain shared preferences.
  SharedPreferences? _prefs;

  @override
  T read<T>(String key) {
    if (_prefs == null) {
      throw "ShareReferenceDataStorage not initialize";
    }
    final prefs = (_prefs as SharedPreferences);
    try {
      final value = (prefs.get(key) as T);
      return value;
    } catch (e) {
      throw "Can't find value for $key with type $T with exception : $e";
    }
  }

  @override
  Future<bool> write<T>(String key, T data) async {
    if (_prefs == null) {
      throw "ShareReferenceDataStorage not initialize";
    }
    final prefs = (_prefs as SharedPreferences);
    if (T == int) {
      return await prefs.setInt(key, data as int);
    }
    if (T == bool) {
      return await prefs.setBool(key, data as bool);
    }
    if (T == double) {
      return await prefs.setDouble(key, data as double);
    }
    if (T == String) {
      return await prefs.setString(key, data as String);
    }
    if (T == List<String>) {
      return await prefs.setStringList(key, data as List<String>);
    }
    throw UnsupportedError("$T is not supported");
  }

  @override
  Future init() async {
    _prefs = _instance._prefs ?? await SharedPreferences.getInstance();
  }

  @override
  Future<bool> delete(String key) {
    return _prefs!.remove(key);
  }
}
