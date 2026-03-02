// lib/services/pref_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  // 1. Singleton pattern
  static final PrefService _instance = PrefService._internal();
  factory PrefService() => _instance;
  PrefService._internal();

  late SharedPreferences _prefs;

  // 2. Inicialización asíncrona (llamar en el main)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 3. Métodos Genéricos
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  String? getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  int? getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  // 4. Eliminar y limpiar
  Future<bool> remove(String key) => _prefs.remove(key);

  Future<void> clearAll() => _prefs.clear();
}
