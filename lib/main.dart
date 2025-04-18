import 'package:daily_reminder/constants/app_colors.dart';
import 'package:daily_reminder/constants/app_strings.dart';
import 'package:daily_reminder/services/notification_service.dart';
import 'package:daily_reminder/views/reminder_list_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await NotificationService.sharedInstance.initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: ReminderListScreen(),
    );
  }
}
