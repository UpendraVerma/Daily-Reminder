import 'package:daily_reminder/constants/app_colors.dart';
import 'package:daily_reminder/constants/app_strings.dart';
import 'package:daily_reminder/models/reminder_model.dart';
import 'package:daily_reminder/services/db_helper.dart';
import 'package:daily_reminder/views/add_reminder_screen.dart';
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
      ),
      body: arrReminders.isEmpty ? Center(
        child: Text(
          "No reminders yet!\nTap + to add your first one.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.secondary,
          ),
        ),
      ) : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: arrReminders.length,
        itemBuilder: (context, index) {
          final reminder = arrReminders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            color: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              //side: BorderSide(color: AppColors.border),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Icon(Icons.alarm, color: AppColors.primary),
              title: Text(
                reminder.title,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.time,
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    reminder.desc,
                    style: TextStyle(color: AppColors.textDark),
                  ),
                ],
              ),
              trailing: SizedBox(
                width: 55,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
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
                       if (result) {
                         getReminderData();
                       }
                      },
                      child: Icon(
                        Icons.edit,
                        size: 25,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                          deleteReminder(reminder.id);
                      },
                      child: Icon(Icons.delete, size: 25, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
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
          if (result) {
            getReminderData();
          }

        },
      ),
    );
  }
}
