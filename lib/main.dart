import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/register/view_model/register_viewModel.dart';
import 'ui/login/view_model/login_viewModel.dart';
import 'ui/dashboard/view_model/dashboard_viewModel.dart';
import 'ui/profile/view_model/profile_viewModel.dart';
import 'ui/profile/view_model/editProfile_viewModel.dart';
import 'config/festQuest_app.dart'; // assuming you moved the app widget into this file

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => EditProfileViewModel()),

      ],
      child: const FestQuestApp(),
    ),
  );
}
