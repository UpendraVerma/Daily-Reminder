class ReminderModel {
  final int id;
  final String title;
  final String desc;
  final String time;

  ReminderModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.time,
  });

  // Convert a ReminderModel to a Map (for DB insert/update)
  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'title': title,
      'desc': desc,
      'time': time,
    };
    return map;
  }

  // Convert a Map from DB into ReminderModel
  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      time: map['time'],
    );
  }
}
