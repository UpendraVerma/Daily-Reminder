import 'package:daily_reminder/constants/app_colors.dart';
import 'package:daily_reminder/constants/app_strings.dart';
import 'package:daily_reminder/helper/platform_alert_dialog.dart';
import 'package:daily_reminder/models/reminder_model.dart';
import 'package:daily_reminder/services/db_helper.dart';
import 'package:daily_reminder/services/notification_service.dart';
import 'package:daily_reminder/views/add_reminder_screen.dart';
import 'package:daily_reminder/widgets/reminder_tile.dart';
import 'package:flutter/material.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  List<ReminderModel> arrReminders = [];

  void getReminderData() async {
    arrReminders = await DBHelper.sharedInstance.fetchReminders();
    setState(() {});
  }

  void deleteReminder(int id) async {
    bool isDone = await DBHelper.sharedInstance.deleteReminder(id: id);
    if (isDone) {
      NotificationService.sharedInstance.cancelPushNotification(id);
      getReminderData();
    }
  }

  @override
  void initState() {
    super.initState();
    getReminderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.yourReminders),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        actions: [
          arrReminders.isEmpty
              ? Text("")
              : TextButton(
                onPressed: () async {
                  final confirm = await PlatFormAlertDialog.showConfirmation(
                    context: context,
                    title: AppStrings.deleteAllReminder,
                    message: AppStrings.deleteAllReminderDesc,
                  );

                  if (confirm == true) {
                    DBHelper.sharedInstance.deleteAllReminder();
                    NotificationService.sharedInstance
                        .cancelAllPushNotification();
                    getReminderData();
                  }
                },
                child: Text(
                  AppStrings.deleteAll,
                  style: TextStyle(color: Colors.red),
                ),
              ),
        ],
      ),
      body:
          arrReminders.isEmpty
              ? Center(
                child: Text(
                  AppStrings.noReminderFound,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.secondary),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: arrReminders.length,
                itemBuilder: (context, index) {
                  final reminder = arrReminders[index];
                  return ReminderTile(
                    reminder: reminder,
                    onEdit: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AddReminderScreen(
                                isForUpdate: true,
                                reminderTaskData: reminder,
                              ),
                        ),
                      );

                      if (!context.mounted) return;
                      if (result == true) {
                        getReminderData();
                      }
                    },
                    onDelete: () async {
                      final isConform =
                          await PlatFormAlertDialog.showConfirmation(
                            context: context,
                            title: AppStrings.deleteReminder,
                            message: AppStrings.deleteReminderDesc,
                          );
                      if (isConform == true) {
                        deleteReminder(reminder.id);
                      }
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReminderScreen()),
          );

          if (!context.mounted) return;
          if (result == true) {
            getReminderData();
          }
        },
      ),
    );
  }
}
