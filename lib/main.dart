import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/user_provider.dart';
import 'screens/onboarding_screen.dart';
// import 'screens/profile_setup_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider()..initialize(),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return MaterialApp(
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp(
            title: 'QuickShare',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: userProvider.currentUser?.isDarkTheme == true
                ? ThemeMode.dark
                : ThemeMode.light,
            // Используем home вместо routes для корневого экрана
            home: userProvider.isLoggedIn 
                ? HomeScreen() 
                : OnboardingScreen(),
          );
        },
      ),
    );
  }
}