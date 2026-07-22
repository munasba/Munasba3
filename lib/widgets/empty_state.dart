import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  const EmptyState({super.key, required this.icon, required this.title, this.subtitle, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 100, height: 100, decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle), child: Icon(icon, size: 50, color: AppColors.primary.withOpacity(0.5))),
            const SizedBox(height: 24),
            Text(title, style: AppTextStyles.headline3.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
            if (subtitle != null) ...[const SizedBox(height: 8), Text(subtitle!, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center)],
            if (actionLabel != null && onAction != null) ...[const SizedBox(height: 24), ElevatedButton(onPressed: onAction, child: Text(actionLabel!))],
          ],
        ),
      ),
    );
  }
}
