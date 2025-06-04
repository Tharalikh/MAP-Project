import 'package:festquest/view/purchase/widgets/payment_form_screen.dart';
import 'package:festquest/view/purchase/widgets/subs_payment_screen.dart';
import 'package:flutter/material.dart';
import '../view/register/widgets/register_screen.dart';
import '../view/register/widgets/forgotPass_screen.dart';
import '../view/profile/widgets/profile_screen.dart';
import '../view/profile/widgets/editProfile_screen.dart';
import '../view/purchase/widgets/subscription_screen.dart';
import '../view/profile/widgets/create_event_screen.dart';
import '../view/notification/widgets/notification_screen.dart';
import '../view/core/themes/main_scaffold.dart';
import '../view/purchase/widgets/event_detail_screen.dart';
import '../view/purchase/widgets/payment_confirm_screen.dart';
import '../view/purchase/widgets/payment_screen.dart';
import '../view/purchase/widgets/ticket_barcode_screen.dart';
import '../view/ticket/widgets/my_event_screen.dart';
import '../view/login/widgets/login_screen.dart';

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
        '/subscription': (context) => const SubscriptionScreen(),
        '/subscription/payment_method':
            (context) => const SubscriptionPaymentMethodScreen(),
        '/subscription/payment_form':
            (context) => const SubscriptionPaymentFormScreen(),
        '/create_event': (context) => const CreateEventScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/ticket': (context) => const MainScaffold(),
        '/search': (context) => const MainScaffold(),
        '/event_detail': (context) => const EventDetailScreen(),
        '/payment_type': (context) => const PaymentMethodScreen(),
        '/payment_confirm': (context) => const ConfirmPaymentScreen(),
        '/barcode': (context) => const TicketSuccessScreen(),
        '/my_event': (context) => const MyEventsScreen(),
      },
    );
  }
}
