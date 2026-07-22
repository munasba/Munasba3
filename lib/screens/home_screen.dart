import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/event_card.dart';
import '../widgets/countdown_widget.dart';
import 'create_event_screen.dart';
import 'guest_list_screen.dart';
import 'tasks_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            _buildUpcomingEvents(context),
            _buildQuickActions(context),
            _buildRecentEvents(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50, height: 50,
                  decoration: const BoxDecoration(gradient: AppColors.goldGradient, borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: const Icon(Icons.celebration_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مرحباً بك 👋', style: AppTextStyles.bodyMedium),
                      Text('مناسباتك القادمة', style: AppTextStyles.headline3),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined), color: AppColors.textPrimary),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        final upcoming = provider.upcomingEvents;
        if (upcoming.isEmpty) return const SliverToBoxAdapter(child: SizedBox());
        final nextEvent = upcoming.first;
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('المناسبة القادمة', style: AppTextStyles.headline3),
                const SizedBox(height: 16),
                EventCard(event: nextEvent, isFeatured: true),
                const SizedBox(height: 16),
                CountdownWidget(targetDate: nextEvent.date),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final upcoming = context.read<EventProvider>().upcomingEvents;
    final firstEventId = upcoming.isNotEmpty ? upcoming.first.id : null;

    void needEventFirst() => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('أنشئ مناسبة أولاً للوصول لهذه الميزة')),
        );

    final actions = [
      _ActionItem(Icons.add_circle_outline, 'مناسبة جديدة', AppColors.primary,
          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEventScreen()))),
      _ActionItem(Icons.people_outline, 'الضيوف', AppColors.secondary,
          () => firstEventId == null ? needEventFirst() : Navigator.push(context, MaterialPageRoute(builder: (_) => GuestListScreen(eventId: firstEventId)))),
      _ActionItem(Icons.task_alt, 'المهام', AppColors.accent,
          () => firstEventId == null ? needEventFirst() : Navigator.push(context, MaterialPageRoute(builder: (_) => TasksScreen(eventId: firstEventId)))),
      _ActionItem(Icons.qr_code_scanner, 'الماسح', AppColors.success,
          () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ميزة الماسح قيد التطوير')))),
    ];
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('إجراءات سريعة', style: AppTextStyles.headline3),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: actions.map((action) => _buildActionButton(action)).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(_ActionItem action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: action.color.withOpacity(0.1), borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Icon(action.icon, color: action.color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(action.label, style: AppTextStyles.bodySmall),
        ],
      ),
    ).animate().scale(delay: const Duration(milliseconds: 100));
  }

  Widget _buildRecentEvents(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        final events = provider.events.take(5).toList();
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(padding: const EdgeInsets.only(bottom: 12), child: EventCard(event: events[index])),
              childCount: events.length,
            ),
          ),
        );
      },
    );
  }
}

class _ActionItem {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  _ActionItem(this.icon, this.label, this.color, this.onTap);
}
