import 'package:flutter/material.dart';
import '../ui/login/widgets/login_screen.dart';
import '../ui/register/widgets/register_screen.dart';
import '../ui/dashboard/widgets/dashboard_screen.dart';
import '../ui/profile/widgets/profile_screen.dart';
import '../ui/profile/widgets/editProfile_screen.dart';

class FestQuestApp extends StatelessWidget {
  const FestQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FestQuest',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
      },
    );
  }
}
