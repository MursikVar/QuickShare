import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_share/screens/onboarding_screen.dart';
import 'package:quick_share/screens/profile_setup_screen.dart';
import '../core/providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final avatarOptions = [
      '😊',
      '🤠',
      '😎',
      '🧐',
      '🤩',
      '🥳',
      '🤖',
      '👾',
      '🐱',
      '🐶',
    ];

    // Защита от null - показываем загрузку если пользователь не загружен
    if (userProvider.currentUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Загружаем профиль...'),
            ],
          ),
        ),
      );
    }

    // Теперь безопасно используем !
    final user = userProvider.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.deepPurple[100],
              child: Text(avatarOptions[user.avatarIndex]),
            ),
            SizedBox(width: 12),
            Text(user.name),
          ],
        ),
        actions: [
          // Переключатель темы
          IconButton(
            icon: Icon(user.isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => userProvider.toggleTheme(),
          ),
          // Настройки
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Изменить профиль'),
                ),
                onTap: () {
                  // Закрываем меню и переходим через небольшой delay
                  Future.delayed(Duration.zero, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSetupScreen(),
                      ),
                    );
                  });
                },
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Выйти', style: TextStyle(color: Colors.red)),
                ),
                onTap: () {
                  // Закрываем меню и показываем диалог через небольшой delay
                  Future.delayed(Duration.zero, () {
                    _showLogoutDialog(context, userProvider);
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Информационная карточка
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.nfc_rounded,
                        size: 64,
                        color: Color.fromARGB(255, 21, 94, 252),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Готов к обмену файлами',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Нажмите кнопку ниже, чтобы найти\nближайшие устройства для обмена',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Реализовать поиск устройств
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Поиск устройств...')),
                          );
                        },
                        icon: Icon(Icons.search),
                        label: Text('Найти устройства'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildStatCard(BuildContext context, String value, String label) {
  //   return Column(
  //     children: [
  //       Text(
  //         value,
  //         style: Theme.of(context).textTheme.headlineMedium?.copyWith(
  //           fontWeight: FontWeight.bold,
  //           color: Colors.deepPurple,
  //         ),
  //       ),
  //       SizedBox(height: 4),
  //       Text(label, style: TextStyle(color: Colors.grey[600])),
  //     ],
  //   );
  // }

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Выйти из аккаунта?'),
        content: Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              userProvider.logout();
              Navigator.pop(context); // Закрываем диалог
              // Переходим на экран онбординга с очисткой стека навигации
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => OnboardingScreen()),
                (route) => false, // Удаляем все предыдущие маршруты
              );
            },
            child: Text('Выйти', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
