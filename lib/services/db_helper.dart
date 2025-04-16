import 'dart:io';

import 'package:daily_reminder/models/reminder_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper sharedInstance = DBHelper._();

  final String TABLE_REMINDER = "reminder";
  final String COLUMN_REMINDER_ID = "id";
  final String COLUMN_REMINDER_TITLE = "title";
  final String COLUMN_REMINDER_DESC = "desc";
  final String COLUMN_REMINDER_TIME = "time";

  Database? database;

  // get the database
  Future<Database> getDB() async {
    return database = database ?? await openDB();
  }

  // create the table
  Future<Database> openDB() async {
    Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocumentsDir.path, "Reminder.db");

    return await openDatabase(
      databasePath,
      onCreate: (db, version) async {
        await db.execute(
          "create table $TABLE_REMINDER ($COLUMN_REMINDER_ID integer primary key autoincrement, $COLUMN_REMINDER_TITLE text, $COLUMN_REMINDER_DESC text, $COLUMN_REMINDER_TIME text)",
        );
      },
      version: 1,
    );
  }

  // insert into the reminder table
  Future<bool> addReminder({
    required String title,
    required String desc,
    required String time,
  }) async {
    var database = await getDB();

    int rowEffected = await database.insert(TABLE_REMINDER, {
      COLUMN_REMINDER_TITLE: title,
      COLUMN_REMINDER_DESC: desc,
      COLUMN_REMINDER_TIME: time,
    });
    return rowEffected > 0;
  }

  // fetch the reminder data
  Future<List<ReminderModel>> fetchReminders() async {
    var database = await getDB();
    List<Map<String, dynamic>> reminderData = await database.query(
      TABLE_REMINDER,
    );
    return reminderData.map((map) => ReminderModel.fromMap(map)).toList();
  }

  // update the reminder data
  Future<bool> updateReminder({
    required int id,
    required String title,
    required String desc,
    required String time,
  }) async {
    var database = await getDB();

    int rowEffected = await database.update(
      TABLE_REMINDER,
      {
        COLUMN_REMINDER_TITLE: title,
        COLUMN_REMINDER_DESC: desc,
        COLUMN_REMINDER_TIME: time,
      },
      where: '$COLUMN_REMINDER_ID = ?',
      whereArgs: [id],
    );
    return rowEffected > 0;
  }

  // delete the reminder data
  Future<bool> deleteReminder({required int id}) async {
    var database = await getDB();

    int rowEffected = await database.delete(
      TABLE_REMINDER,
      where: '$COLUMN_REMINDER_ID = ?',
      whereArgs: [id],
    );
    return rowEffected > 0;
  }
}
