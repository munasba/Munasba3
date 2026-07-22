import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/event_model.dart';
import '../theme/app_theme.dart';
import 'guest_list_screen.dart';
import 'tasks_screen.dart';
import 'budget_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: LinearGradient(colors: [_getTypeColor().withOpacity(0.8), _getTypeColor().withOpacity(0.3)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Center(child: Icon(_getTypeIcon(), size: 80, color: Colors.white.withOpacity(0.3))),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildInfoSection(),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: _getTypeColor().withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text(event.typeLabel, style: TextStyle(color: _getTypeColor(), fontWeight: FontWeight.w600))),
        const SizedBox(height: 12),
        Text(event.name, style: AppTextStyles.headline1),
        if (event.description != null) ...[const SizedBox(height: 8), Text(event.description!, style: AppTextStyles.bodyMedium)],
      ],
    ).animate().fadeIn().slideY();
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        children: [
          _buildInfoRow(Icons.calendar_today, 'التاريخ', event.formattedDate),
          const Divider(),
          if (event.startTime != null) _buildInfoRow(Icons.access_time, 'الوقت', '${event.startTime} - ${event.endTime ?? ''}'),
          if (event.location != null) ...[const Divider(), _buildInfoRow(Icons.location_on, 'الموقع', event.location!)],
          if (event.budget != null) ...[const Divider(), _buildInfoRow(Icons.account_balance_wallet, 'الميزانية', '${event.budget?.toStringAsFixed(0)} ر.س')],
          if (event.expectedGuests != null) ...[const Divider(), _buildInfoRow(Icons.people, 'الضيوف المتوقعين', '${event.expectedGuests} شخص')],
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 200));
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.primary, size: 20)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: AppTextStyles.bodySmall), Text(value, style: AppTextStyles.bodyLarge)])),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = <(String, IconData, Color, VoidCallback)>[
      ('الضيوف', Icons.people, Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => GuestListScreen(eventId: event.id)))),
      ('الميزانية', Icons.account_balance_wallet, Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => BudgetScreen(eventId: event.id)))),
      ('المهام', Icons.task_alt, Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => TasksScreen(eventId: event.id)))),
      ('المشاركة', Icons.share, Colors.purple, () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ميزة المشاركة قيد التطوير')))),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('إدارة المناسبة', style: AppTextStyles.headline3),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return Container(decoration: AppDecorations.cardDecoration, child: InkWell(onTap: action.$4, borderRadius: BorderRadius.circular(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(action.$2, color: action.$3, size: 32), const SizedBox(height: 8), Text(action.$1, style: AppTextStyles.bodyLarge)])));
          },
        ),
      ],
    ).animate().fadeIn(delay: const Duration(milliseconds: 400));
  }

  Color _getTypeColor() {
    switch (event.type) {
      case EventType.wedding: return const Color(0xFFE91E63);
      case EventType.birthday: return const Color(0xFFFF9800);
      case EventType.graduation: return const Color(0xFF4CAF50);
      case EventType.babyShower: return const Color(0xFF03A9F4);
      case EventType.corporate: return const Color(0xFF9C27B0);
      case EventType.engagement: return const Color(0xFFE91E63);
      case EventType.other: return AppColors.primary;
    }
  }

  IconData _getTypeIcon() {
    switch (event.type) {
      case EventType.wedding: return Icons.favorite_rounded;
      case EventType.birthday: return Icons.cake_rounded;
      case EventType.graduation: return Icons.school_rounded;
      case EventType.babyShower: return Icons.child_care_rounded;
      case EventType.corporate: return Icons.business_rounded;
      case EventType.engagement: return Icons.diamond_rounded;
      case EventType.other: return Icons.celebration_rounded;
    }
  }
}
