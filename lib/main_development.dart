import 'package:festquest/routing/festquest.dart';
import 'package:festquest/services/notification_service.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(FestQuestApp());
}