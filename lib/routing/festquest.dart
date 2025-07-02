import 'package:festquest/view/ticket/edit_event_screen.dart';
import 'package:festquest/view/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import '../view/register/register_screen.dart';
import '../view/register/forgotPass_screen.dart';
import '../view/profile/profile_screen.dart';
import '../view/profile/editProfile_screen.dart';
import '../view/notification/notification_screen.dart';
import '../view/core/themes/main_scaffold.dart';
import '../view/purchase/event_detail_screen.dart';
import '../view/ticket/my_event_screen.dart';
import '../view/login/login_screen.dart';
import '../view/ticket/create_event_screen.dart';
import '../model/event_model.dart';


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
        '/forgot': (context) => const ForgotPassScreen(),
        '/dashboard': (context) => const MainScaffold(),
        '/profile': (context) => const ProfileScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/search': (context) => const MainScaffold(),
        '/my_event': (context) => const MyEventsScreen(),
        '/create_event': (context) => const CreateEventScreen(),
      },
      onGenerateRoute: (settings) {
        // Dynamic route for Event Detail Screen
        if (settings.name == '/event_detail') {
          final eventId = settings.arguments as String?;
          if (eventId != null) {
            return MaterialPageRoute(
              builder: (_) => EventDetailScreen(eventId: eventId),
            );
          }
        }

        // Dynamic route for Edit Event Screen
        if (settings.name == '/edit_event') {
          final event = settings.arguments as EventModel?;
          if (event != null) {
            return MaterialPageRoute(
              builder: (_) => EditEventScreen(event: event),
            );
          }
        }

        if (settings.name == '/ticket') {
          final initialTabIndex = settings.arguments as int ?? 0;
          return MaterialPageRoute(
            builder: (_) => TicketScreen(initialTabIndex: initialTabIndex),
          );
        }
        // Return null to let Flutter handle the route with the regular routes table
        return null;
      },
      // Add this to handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: const Center(
              child: Text('Page not found'),
            ),
          ),
        );
      },
    );
  }
}