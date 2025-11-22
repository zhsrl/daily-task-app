enum TaskStatus {
  inprocess,
  completed,
}

class Task {
  Task({
    this.text,
    this.status,
    this.id,
  });

  factory Task.fromJson(Map<String, dynamic> data) => Task(
    status: data['status'] != null
        ? TaskStatus.values.firstWhere((e) => e.name == data['status'])
        : TaskStatus.inprocess,
    text: data['text'],
    id: data['id'],
  );

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'status': status?.name,
      'id': id,
    };
  }

  String? text;
  TaskStatus? status;
  String? id;
}
