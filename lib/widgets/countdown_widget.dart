import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CountdownWidget extends StatelessWidget {
  final DateTime targetDate;
  const CountdownWidget({super.key, required this.targetDate});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = targetDate.difference(now);
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.gradientCard,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTimeUnit(days, 'يوم'),
          _buildSeparator(),
          _buildTimeUnit(hours, 'ساعة'),
          _buildSeparator(),
          _buildTimeUnit(minutes, 'دقيقة'),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(int value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(12)),
          child: Text(value.toString().padLeft(2, '0'), style: AppTextStyles.headline1.copyWith(color: AppColors.primary, fontSize: 32)),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildSeparator() {
    return Text(':', style: AppTextStyles.headline1.copyWith(color: AppColors.primary.withOpacity(0.5)));
  }
}
