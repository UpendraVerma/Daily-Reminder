import 'package:daily_reminder/constants/app_strings.dart';
import 'package:daily_reminder/models/reminder_model.dart';
import 'package:daily_reminder/services/db_helper.dart';
import 'package:daily_reminder/widgets/custom_button.dart';
import 'package:daily_reminder/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';

class AddReminderScreen extends StatefulWidget {
  final bool isForUpdate;
  final ReminderModel? reminderTaskData;

  const AddReminderScreen({
    super.key,
    this.isForUpdate = false,
    this.reminderTaskData,
  });

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay? _selectedTime;

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveReminder() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.pleaseFillAllFields)),
      );
      return;
    }

    // Save logic here
    if (widget.isForUpdate) {
      bool isDone = await DBHelper.sharedInstance.updateReminder(
        id: widget.reminderTaskData!.id,
        title: title,
        desc: description,
        time: _selectedTime!.format(context),
      );
      if (isDone) {
        Navigator.pop(context, true);
      }
    } else {
      bool isDone = await DBHelper.sharedInstance.addReminder(
        title: title,
        desc: description,
        time: _selectedTime!.format(context),
      );

      if (isDone) {
        Navigator.pop(context, true);
      }
    }
  }

  void setReminderData() {
    if (widget.isForUpdate) {
      _titleController.text = widget.reminderTaskData?.title ?? "";
      _descriptionController.text = widget.reminderTaskData?.desc ?? "";

      final timeString = widget.reminderTaskData?.time ?? ""; // e.g., "2:00 PM"
      if (timeString.isNotEmpty) {
        final format = DateFormat("h:mm a");
        final dateTime = format.parse(timeString);
        _selectedTime = TimeOfDay.fromDateTime(dateTime);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setReminderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.isForUpdate
              ? AppStrings.updateReminder
              : AppStrings.addNewReminder,
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _titleController,
                      hintText: AppStrings.title,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _descriptionController,
                      hintText: AppStrings.description,
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppColors.border),
                      ),
                      onTap: _pickTime,
                      leading: const Icon(Icons.access_time),
                      title: Text(
                        _selectedTime == null
                            ? AppStrings.selectTime
                            : _selectedTime!.format(context),
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              _selectedTime == null
                                  ? AppColors.secondary
                                  : AppColors.textDark,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                title:
                    widget.isForUpdate
                        ? AppStrings.updateReminder
                        : AppStrings.saveReminder,
                backgroundColor: AppColors.accent,
                textColor: AppColors.textDark,
                fontSize: 14,
                onPressed: _saveReminder,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
