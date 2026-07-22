import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استكشاف')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: const BorderRadius.all(Radius.circular(16))),
              child: const TextField(decoration: InputDecoration(hintText: 'ابحث عن قاعات، خدمات...', prefixIcon: Icon(Icons.search), border: InputBorder.none)),
            ),
            const SizedBox(height: 24),
            Text('الخدمات', style: AppTextStyles.headline3),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12, runSpacing: 12,
              children: [
                _buildCategory('قاعات', Icons.meeting_room),
                _buildCategory('بوفيه', Icons.restaurant),
                _buildCategory('تصوير', Icons.camera_alt),
                _buildCategory('ديكور', Icons.palette),
                _buildCategory('موسيقى', Icons.music_note),
                _buildCategory('نقل', Icons.local_taxi),
              ],
            ),
            const SizedBox(height: 24),
            Text('قاعات مميزة', style: AppTextStyles.headline3),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => Container(
                  width: 280,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: AppDecorations.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        decoration: const BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        child: const Center(child: Icon(Icons.image, color: AppColors.primary)),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('قاعة الفيصلية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            Text('الرياض - 500 ضيف', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: AppColors.primary, size: 20), const SizedBox(width: 8), Text(label, style: AppTextStyles.bodyLarge)]),
    );
  }
}
