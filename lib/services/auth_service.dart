import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final _storage = FlutterSecureStorage();
  static const _keyUsername = 'username';
  static const _keyPassword = 'password';

  static Future<void> saveUser(String username, String password) async {
    await _storage.write(key: _keyUsername, value: username);
    await _storage.write(key: _keyPassword, value: password);
  }

  static Future<bool> validateUser(String username, String password) async {
    String? storedUsername = await _storage.read(key: _keyUsername);
    String? storedPassword = await _storage.read(key: _keyPassword);
    return storedUsername == username && storedPassword == password;
  }

  static Future<bool> userExists() async {
    String? storedUsername = await _storage.read(key: _keyUsername);
    return storedUsername != null;
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}
