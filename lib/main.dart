import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('remember_me') ?? false;
  final savedEmail = prefs.getString('saved_email') ?? '';
  final savedFirstName = prefs.getString('saved_first_name') ?? 'User';
  final savedLastName = prefs.getString('saved_last_name') ?? '';

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    savedEmail: savedEmail,
    savedFirstName: savedFirstName,
    savedLastName: savedLastName,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String savedEmail;
  final String savedFirstName;
  final String savedLastName;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.savedEmail,
    required this.savedFirstName,
    required this.savedLastName,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: isLoggedIn
          ? DashboardScreen(
              user: UserModel(
                firstName: savedFirstName,
                lastName: savedLastName,
                email: savedEmail,
                gender: Gender.other,
              ),
            )
          : const LoginScreen(),
    );
  }
}
