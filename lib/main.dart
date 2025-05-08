import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/festquest.dart';
import 'ui/register/view_model/register_viewModel.dart';
import 'ui/login/view_model/login_viewModel.dart';
import 'ui/dashboard/view_model/dashboard_viewModel.dart';
import 'ui/profile/view_model/profile_viewModel.dart';
import 'ui/profile/view_model/editProfile_viewModel.dart';
import 'ui/notification/view_model/notification_viewModel.dart';
import 'ui/search/view_model/search_viewModel.dart';
import 'ui/ticket/view_model/ticket_viewModel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => EditProfileViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => TicketViewModel()),
      ],
      child: const FestQuestApp(),
    ),
  );
}
