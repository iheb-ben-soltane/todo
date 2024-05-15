class Task {
  String id = '';
  String userId = '';
  String name = ' ';
  String description = '';
  String date = '';
  String time = '';
  String state = '';
  String priority = '';
  Task(
    String taskname,
    String taskDescription,
    String taskDate,
    String taskTime,
    String taskState,
    String taskPriority,
    String userId,
  ) {
    this.name = taskname;
    this.description = taskDescription;
    this.date = taskDate;
    this.time = taskTime;
    this.state = taskState;
    this.priority = taskPriority;
    this.userId = userId;
  }

  Task.empty();

  Task.fromMap(Map<String, dynamic> map) {
    id = map["Id"] ?? '';
    name = map['name'] ?? '';
    description = map['description'] ?? '';
    date = map['date'] ?? '';
    time = map['time'] ?? '';
    state = map['state'] ?? '';
    userId = map['userId'] ?? '';
    priority = map['priority'] ?? '';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['date'] = this.date;
    data['time'] = this.time;
    data['state'] = this.state;
    data['userId'] = this.userId;
    data['priority'] = this.priority;

    return data;
  }
}
