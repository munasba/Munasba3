import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  List<TaskModel> getTasksByEvent(String eventId) {
    return _tasks.where((t) => t.eventId == eventId).toList()..sort((a, b) {
      if (a.status == TaskStatus.done && b.status != TaskStatus.done) return 1;
      if (a.status != TaskStatus.done && b.status == TaskStatus.done) return -1;
      return (a.dueDate ?? DateTime.now()).compareTo(b.dueDate ?? DateTime.now());
    });
  }

  int getCompletedCount(String eventId) => _tasks.where((t) => t.eventId == eventId && t.status == TaskStatus.done).length;
  int getTotalCount(String eventId) => _tasks.where((t) => t.eventId == eventId).length;

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final newStatus = task.status == TaskStatus.done ? TaskStatus.todo : TaskStatus.done;
      _tasks[index] = task.copyWith(status: newStatus, completedAt: newStatus == TaskStatus.done ? DateTime.now() : null);
      notifyListeners();
    }
  }

  void loadDummyTasks(String eventId) {
    _tasks = [
      TaskModel(id: 't1', eventId: eventId, title: 'حجز القاعة', priority: TaskPriority.high, status: TaskStatus.done, dueDate: DateTime.now().subtract(const Duration(days: 5)), createdAt: DateTime.now().subtract(const Duration(days: 20))),
      TaskModel(id: 't2', eventId: eventId, title: 'إرسال الدعوات', priority: TaskPriority.high, status: TaskStatus.inProgress, dueDate: DateTime.now().add(const Duration(days: 3)), createdAt: DateTime.now().subtract(const Duration(days: 15))),
      TaskModel(id: 't3', eventId: eventId, title: 'حجز المصور', priority: TaskPriority.medium, status: TaskStatus.todo, dueDate: DateTime.now().add(const Duration(days: 7)), createdAt: DateTime.now().subtract(const Duration(days: 10))),
      TaskModel(id: 't4', eventId: eventId, title: 'تأكيد قائمة الطعام', priority: TaskPriority.urgent, status: TaskStatus.todo, dueDate: DateTime.now().add(const Duration(days: 2)), createdAt: DateTime.now().subtract(const Duration(days: 8))),
    ];
    notifyListeners();
  }
}
