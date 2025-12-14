import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_share/screens/home_screen.dart';
import '../core/providers/user_provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedAvatarIndex = 0;
  final List<String> _avatarOptions = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройка профиля'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Заполните свой профиль',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 10),
            Text(
              'Эта информация будет видна другим пользователям при подключении',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 20),

            // Выбор аватара
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color.fromARGB(255, 55, 159, 244),
                child: Text(
                  _avatarOptions[_selectedAvatarIndex],
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),

            SizedBox(height: 30),

            // Поле для имени
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Отображаемое имя',
                hintText: 'Введите ваше имя',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),

            SizedBox(height: 30),

            // Сетка аватаров
            Text('Выберите аватар:'),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _avatarOptions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatarIndex = index;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: _selectedAvatarIndex == index
                        ? Color.fromARGB(255, 190, 219, 255)
                        : Colors.grey[200],
                    child: Text(
                      _avatarOptions[index],
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 40),

            // Информационный блок
            Card(
              color: Color.fromARGB(255, 190, 219, 255),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ваша цифровая личность',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 28, 56, 142),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ваш профиль помогает другим идентифицировать вас при обмене файлов. Вы всегда можете изменить его позже в настройках.',
                      style: TextStyle(
                        color: Color.fromARGB(255, 55, 159, 244),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Кнопка продолжения
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Пожалуйста, введите имя')),
                    );
                    return;
                  }

                  final userProvider = Provider.of<UserProvider>(
                    context,
                    listen: false,
                  );

                  userProvider.registerUser(
                    _nameController.text.trim(),
                    _selectedAvatarIndex,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromARGB(255, 21, 94, 252),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  )
                ),
                child: Text(
                  'Продолжить',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
