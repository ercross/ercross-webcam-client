import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorage {
  static late final SharedPreferences _prefs;
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String _ipAddressKey = "ip_address";
  static const String _portKey = "port";

  static updateIpAddress(String value) {
    _prefs.setString(_ipAddressKey, value);
  }

  static updatePort(String value) {
    _prefs.setString(_portKey, value);
  }

  static String? get ipAddress => _prefs.getString(_ipAddressKey);

  static String? get port => _prefs.getString(_portKey);
}
