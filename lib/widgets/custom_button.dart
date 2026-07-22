import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isLoading;
  final IconData? icon;
  const CustomButton({super.key, required this.text, required this.onPressed, this.isOutlined = false, this.isLoading = false, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: isOutlined
        ? OutlinedButton(onPressed: isLoading ? null : onPressed, child: _buildChild())
        : ElevatedButton(onPressed: isLoading ? null : onPressed, child: _buildChild()),
    );
  }

  Widget _buildChild() {
    if (isLoading) return const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)], Text(text)]);
  }
}
