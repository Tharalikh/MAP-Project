import 'package:festquest/ui/login/view_model/auth_gate.dart';
import 'package:festquest/ui/purchase/widgets/payment_form_screen.dart';
import 'package:festquest/ui/purchase/widgets/subs_payment_screen.dart';
import 'package:flutter/material.dart';
import '../ui/register/widgets/register_screen.dart';
import '../ui/register/widgets/forgotPass_screen.dart';
import '../ui/profile/widgets/profile_screen.dart';
import '../ui/profile/widgets/editProfile_screen.dart';
import '../ui/purchase/widgets/subscription_screen.dart';
import '../ui/profile/widgets/create_event_screen.dart';
import '../ui/notification/widgets/notification_screen.dart';
import '../ui/core/themes/main_scaffold.dart';
import '../ui/purchase/widgets/event_detail_screen.dart';
import '../ui/purchase/widgets/payment_confirm_screen.dart';
import '../ui/purchase/widgets/payment_screen.dart';
import '../ui/purchase/widgets/ticket_barcode_screen.dart';
import '../ui/ticket/widgets/my_event_screen.dart';

class FestQuestApp extends StatelessWidget {
  const FestQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FestQuest',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/register': (context) => const RegisterScreen(),
        '/forgot': (context) => const ForgotpassScreen(),
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
