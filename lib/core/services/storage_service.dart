import 'package:quick_share/core/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Добавьте этот импорт

class StorageService {
  static const String _userKey = 'current_user';
  static const String _isFirstLaunchKey = 'is_first_launch'; // Исправлена опечатка

  // Сохранить пользователя
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toMap()); // Используем jsonEncode
    await prefs.setString(_userKey, userJson);
  }

  // Получить пользователя
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson == null) return null;
    
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>; // Используем jsonDecode
      return User.fromMap(userMap);
    } catch (e) {
      print('Ошибка загрузки пользователя: $e');
      return null;
    }
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirst = prefs.getBool(_isFirstLaunchKey) ?? true;
    
    if (isFirst) {
      await prefs.setBool(_isFirstLaunchKey, false);
    }
    
    return isFirst;
  }


}