
enum TaskPriority { low, medium, high, urgent }
enum TaskStatus { todo, inProgress, done, cancelled }

class TaskModel {
  final String id; final String eventId; final String title;
  final String? description; final TaskPriority priority;
  final TaskStatus status; final DateTime? dueDate;
  final String? assignedTo; final List<String> subtasks;
  final DateTime createdAt; final DateTime? completedAt;

  TaskModel({
    required this.id, required this.eventId, required this.title,
    this.description, this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo, this.dueDate,
    this.assignedTo, this.subtasks = const [],
    required this.createdAt, this.completedAt,
  });

  TaskModel copyWith({
    String? id, String? eventId, String? title, String? description,
    TaskPriority? priority, TaskStatus? status, DateTime? dueDate,
    String? assignedTo, List<String>? subtasks, DateTime? createdAt,
    DateTime? completedAt,
  }) => TaskModel(
    id: id ?? this.id, eventId: eventId ?? this.eventId,
    title: title ?? this.title, description: description ?? this.description,
    priority: priority ?? this.priority, status: status ?? this.status,
    dueDate: dueDate ?? this.dueDate, assignedTo: assignedTo ?? this.assignedTo,
    subtasks: subtasks ?? this.subtasks, createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt ?? this.completedAt,
  );

  Map<String, dynamic> toMap() => {
    'id': id, 'eventId': eventId, 'title': title,
    'description': description, 'priority': priority.name,
    'status': status.name, 'dueDate': dueDate?.toIso8601String(),
    'assignedTo': assignedTo, 'subtasks': subtasks,
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
    id: map['id'] ?? '', eventId: map['eventId'] ?? '', title: map['title'] ?? '',
    description: map['description'],
    priority: TaskPriority.values.firstWhere((e) => e.name == map['priority'], orElse: () => TaskPriority.medium),
    status: TaskStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => TaskStatus.todo),
    dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
    assignedTo: map['assignedTo'], subtasks: List<String>.from(map['subtasks'] ?? []),
    createdAt: DateTime.parse(map['createdAt']),
    completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
  );

  String get priorityLabel {
    switch (priority) {
      case TaskPriority.low: return 'منخفضة';
      case TaskPriority.medium: return 'متوسطة';
      case TaskPriority.high: return 'عالية';
      case TaskPriority.urgent: return 'عاجلة';
    }
  }

  String get statusLabel {
    switch (status) {
      case TaskStatus.todo: return 'للقيام به';
      case TaskStatus.inProgress: return 'قيد التنفيذ';
      case TaskStatus.done: return 'مكتمل';
      case TaskStatus.cancelled: return 'ملغاة';
    }
  }

  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.done) return false;
    return DateTime.now().isAfter(dueDate!);
  }
}
