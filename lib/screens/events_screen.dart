import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مناسباتي'), actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})]),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          final events = provider.eventsByDate;
          if (events.isEmpty) return _buildEmptyState();
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: events.length,
            itemBuilder: (context, index) => Padding(padding: const EdgeInsets.only(bottom: 12), child: EventCard(event: events[index])),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_outlined, size: 80, color: AppColors.primary.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text('لا توجد مناسبات بعد', style: AppTextStyles.headline3.copyWith(color: AppColors.textLight)),
          const SizedBox(height: 8),
          Text('أنشئ مناسبتك الأولى الآن!', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
