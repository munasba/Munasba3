import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class TasksScreen extends StatefulWidget {
  final String eventId;
  const TasksScreen({super.key, required this.eventId});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskProvider>().loadDummyTasks(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المهام')),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          final tasks = provider.getTasksByEvent(widget.eventId);
          final completed = provider.getCompletedCount(widget.eventId);
          final total = provider.getTotalCount(widget.eventId);

          return Column(
            children: [
              _buildProgressCard(completed, total),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskItem(tasks[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_task),
      ),
    );
  }

  Widget _buildProgressCard(int completed, int total) {
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('تقدم المهام', style: AppTextStyles.headline3),
              Text(
                '$completed / $total',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.primaryLight,
              valueColor: const AlwaysStoppedAnimation(AppColors.success),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(0)}% مكتمل',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildTaskItem(TaskModel task) {
    final isDone = task.status == TaskStatus.done;
    final isOverdue = task.isOverdue;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppDecorations.cardDecoration,
      child: ListTile(
        leading: Checkbox(
          value: isDone,
          onChanged: (value) {
            context.read<TaskProvider>().toggleTaskStatus(task.id);
          },
          activeColor: AppColors.success,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        title: Text(
          task.title,
          style: AppTextStyles.bodyLarge.copyWith(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? AppColors.textLight : AppColors.textPrimary,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                task.priorityLabel,
                style: TextStyle(
                  color: _getPriorityColor(task.priority),
                  fontSize: 11,
                ),
              ),
            ),
            if (isOverdue) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'متأخرة',
                  style: TextStyle(color: AppColors.error, fontSize: 11),
                ),
              ),
            ],
          ],
        ),
        trailing: isDone
            ? const Icon(Icons.check_circle, color: AppColors.success)
            : Icon(Icons.circle_outlined, color: AppColors.textLight.withOpacity(0.5)),
      ),
    ).animate().fadeIn().slideX();
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low: return Colors.blue;
      case TaskPriority.medium: return Colors.orange;
      case TaskPriority.high: return Colors.deepOrange;
      case TaskPriority.urgent: return Colors.red;
    }
  }
}
