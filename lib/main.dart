import 'package:festquest/services/paymentGateway_service.dart';
import 'package:festquest/view_model/my_event_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:festquest/firebase_options.dart';
import 'routing/festquest.dart';
import 'view_model/register_viewModel.dart';
import 'view_model/forgot_viewModel.dart';
import 'view_model/login_viewModel.dart';
import 'view_model/dashboard_viewModel.dart';
import 'view_model/profile_viewModel.dart';
import 'view_model/editProfile_viewModel.dart';
import 'package:festquest/view_model/subscription_viewModel.dart';
import 'view_model/notification_viewModel.dart';
import 'view_model/search_viewModel.dart';
import 'view_model/ticket_viewModel.dart';
import 'view_model/purchase_viewModel.dart';
import 'view_model/createEvent_viewModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future<void> setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    Stripe.publishableKey = stripePublishableKey;
  }
  await setup();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => CreateEventViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => EditProfileViewModel()),
        ChangeNotifierProvider(create: (_) => SubscriptionViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => TicketViewModel()),
        ChangeNotifierProvider(create: (_) => PurchaseViewModel()),
        ChangeNotifierProvider(create: (_) => MyEventsViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
      ],
      child: const FestQuestApp(),
    ),
  );
}
