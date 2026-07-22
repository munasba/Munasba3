import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';

class LoadingShimmer extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;
  const LoadingShimmer({super.key, required this.height, this.width, this.borderRadius = 16});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primaryLight,
      highlightColor: AppColors.surface,
      child: Container(height: height, width: width ?? double.infinity, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(borderRadius))),
    );
  }
}
