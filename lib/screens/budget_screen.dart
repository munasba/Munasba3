import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/budget_provider.dart';
import '../theme/app_theme.dart';

class BudgetScreen extends StatefulWidget {
  final String eventId;
  const BudgetScreen({super.key, required this.eventId});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BudgetProvider>().loadDummyBudget(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الميزانية')),
      body: Consumer<BudgetProvider>(
        builder: (context, provider, child) {
          final summary = provider.getSummary(widget.eventId);
          final items = provider.getItemsByEvent(widget.eventId);

          return Column(
            children: [
              _buildSummaryCard(summary),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _buildBudgetItem(items[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(var summary) {
    final percentage = summary.percentageUsed / 100;
    final isOver = summary.isOverBudget;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAmountColumn('الميزانية', summary.totalEstimated, AppColors.primary),
              _buildAmountColumn('المصروف', summary.totalActual,
                  isOver ? AppColors.error : AppColors.success),
              _buildAmountColumn('المتبقي', summary.remaining,
                  summary.remaining >= 0 ? AppColors.success : AppColors.error),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0),
              backgroundColor: AppColors.primaryLight,
              valueColor: AlwaysStoppedAnimation(
                isOver ? AppColors.error : AppColors.primary,
              ),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${summary.percentageUsed.toStringAsFixed(1)}% مستخدم',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildAmountColumn(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          '${amount.toStringAsFixed(0)} ر.س',
          style: AppTextStyles.headline3.copyWith(color: color),
        ),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }

  Widget _buildBudgetItem(var item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppDecorations.cardDecoration,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.receipt_outlined, color: AppColors.primary),
        ),
        title: Text(item.name, style: AppTextStyles.bodyLarge),
        subtitle: Text(item.categoryLabel, style: AppTextStyles.bodySmall),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${item.estimatedCost.toStringAsFixed(0)} ر.س',
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            ),
            if (item.actualCost != null)
              Text(
                'فعلي: ${item.actualCost!.toStringAsFixed(0)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: item.variance > 0 ? AppColors.error : AppColors.success,
                ),
              ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }
}
