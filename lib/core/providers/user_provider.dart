import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  final StorageService _storage = StorageService();
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Инициализация при запуске
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Загружаем сохраненного пользователя
      _currentUser = await _storage.getUser();
      print('Загружен пользователь ${_currentUser?.name ?? "null"} ');
    } catch (e) {
      print('Ошибка инициализации UserProvider: $e');
      // Сбрасываем некорректные данные
      _currentUser = null;
      await _storage.clearUser();
    } finally {
      _isLoading = false;
      print('Инициализация завершена ${_currentUser?.name != null}');
      notifyListeners();
    }
  }

  // Регистрация нового пользователя
  Future<void> registerUser(String name, int avatarIndex) async {
    // Валидация
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw Exception('Имя не может быть пустым');
    }
    
    if (avatarIndex < 0) {
      throw Exception('Неверный индекс аватара');
    }
    
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: trimmedName,
      avatarIndex: avatarIndex,
      isDarkTheme: false,
      createdAt: DateTime.now(),
      lastSeen: DateTime.now(),
    );
    
    try {
      await _storage.saveUser(newUser);
      _currentUser = newUser;
      notifyListeners();
    } catch (e) {
      print('Ошибка сохранения пользователя: $e');
      rethrow;
    }
  }

  // Обновление имени
  Future<void> updateName(String newName) async {
    final trimmedName = newName.trim();
    if (trimmedName.isEmpty) {
      throw Exception('Имя не может быть пустым');
    }
    
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(name: trimmedName);
      try {
        await _storage.saveUser(updatedUser);
        _currentUser = updatedUser;
        notifyListeners();
      } catch (e) {
        print('Ошибка обновления имени: $e');
        rethrow;
      }
    }
  }

  // Обновление аватара
  Future<void> updateAvatar(int newAvatarIndex) async {
    if (newAvatarIndex < 0) {
      throw Exception('Неверный индекс аватара');
    }
    
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(avatarIndex: newAvatarIndex);
      try {
        await _storage.saveUser(updatedUser);
        _currentUser = updatedUser;
        notifyListeners();
      } catch (e) {
        print('Ошибка обновления аватара: $e');
        rethrow;
      }
    }
  }

  // Переключение темы
  Future<void> toggleTheme() async {
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(
        isDarkTheme: !_currentUser!.isDarkTheme,
      );
      try {
        await _storage.saveUser(updatedUser);
        _currentUser = updatedUser;
        notifyListeners();
      } catch (e) {
        print('Ошибка переключения темы: $e');
        rethrow;
      }
    }
  }

  // Обновить время последней активности
  Future<void> updateLastSeen() async {
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(
        lastSeen: DateTime.now(),
      );
      try {
        await _storage.saveUser(updatedUser);
        _currentUser = updatedUser;
        // Не уведомляем слушателей - это фоновое обновление
      } catch (e) {
        print('Ошибка обновления lastSeen: $e');
      }
    }
  }

  // Выход
  Future<void> logout() async {
    try {
      await _storage.clearUser();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('Ошибка при выходе: $e');
      // Даже если очистка не удалась, сбрасываем пользователя
      _currentUser = null;
      notifyListeners();
      rethrow;
    }
  }

  // Сброс провайдера (для тестов)
  void reset() {
    _currentUser = null;
    _isLoading = true;
    notifyListeners();
  }
}