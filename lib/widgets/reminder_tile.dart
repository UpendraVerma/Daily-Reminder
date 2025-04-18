import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/reminder_model.dart';

class ReminderTile extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ReminderTile({
    super.key,
    required this.reminder,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
                onTap: onEdit,
                child: Icon(
                  Icons.edit,
                  size: 25,
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(width: 5),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.delete,
                  size: 25,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
