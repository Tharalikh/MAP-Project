import 'package:festquest/ui/ticket/view_model/my_event_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:festquest/firebase_options.dart';
import 'routing/festquest.dart';
import 'ui/register/view_model/register_viewModel.dart';
import 'ui/login/view_model/login_viewModel.dart';
import 'ui/dashboard/view_model/dashboard_viewModel.dart';
import 'ui/profile/view_model/profile_viewModel.dart';
import 'ui/profile/view_model/editProfile_viewModel.dart';
import 'package:festquest/ui/purchase/view_model/subscription_viewModel.dart';
import 'ui/notification/view_model/notification_viewModel.dart';
import 'ui/search/view_model/search_viewModel.dart';
import 'ui/ticket/view_model/ticket_viewModel.dart';
import 'ui/purchase/view_model/purchase_viewModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => EditProfileViewModel()),
        ChangeNotifierProvider(create: (_) => SubscriptionViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => TicketViewModel()),
        ChangeNotifierProvider(create: (_) => PurchaseViewModel()),
        ChangeNotifierProvider(create: (_) => MyEventsViewModel()),
      ],
      child: const FestQuestApp(),
    ),
  );
}
