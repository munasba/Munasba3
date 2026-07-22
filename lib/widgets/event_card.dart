import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/event_model.dart';
import '../theme/app_theme.dart';
import '../screens/event_detail_screen.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final bool isFeatured;
  const EventCard({super.key, required this.event, this.isFeatured = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.cardDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isFeatured) _buildFeaturedHeader(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [_buildTypeChip(), const Spacer(), _buildDaysBadge()]),
                      const SizedBox(height: 12),
                      Text(event.name, style: AppTextStyles.headline3, maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (event.description != null) ...[
                        const SizedBox(height: 4),
                        Text(event.description!, style: AppTextStyles.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                      const SizedBox(height: 12),
                      _buildInfoRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 400)).slideY(begin: 0.1);
  }

  Widget _buildFeaturedHeader() {
    return Container(
      height: 120,
      decoration: BoxDecoration(gradient: LinearGradient(colors: [_getTypeColor().withOpacity(0.8), _getTypeColor().withOpacity(0.4)])),
      child: Stack(
        children: [
          Positioned(right: -20, top: -20, child: Icon(_getTypeIcon(), size: 150, color: Colors.white.withOpacity(0.1))),
          Center(child: Icon(_getTypeIcon(), size: 48, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildTypeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: _getTypeColor().withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(_getTypeIcon(), size: 14, color: _getTypeColor()), const SizedBox(width: 6), Text(event.typeLabel, style: TextStyle(color: _getTypeColor(), fontSize: 12, fontWeight: FontWeight.w600))]),
    );
  }

  Widget _buildDaysBadge() {
    final days = event.daysUntil;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: days <= 7 ? AppColors.error.withOpacity(0.1) : AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
      child: Text(days == 0 ? 'اليوم!' : 'بعد $days يوم', style: TextStyle(color: days <= 7 ? AppColors.error : AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        _buildInfoItem(Icons.calendar_today_outlined, event.formattedDate),
        const SizedBox(width: 16),
        if (event.startTime != null) _buildInfoItem(Icons.access_time_outlined, event.startTime!),
        const SizedBox(width: 16),
        if (event.location != null) _buildInfoItem(Icons.location_on_outlined, event.location!, flex: 2),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: AppColors.textLight), const SizedBox(width: 4), Flexible(child: Text(text, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis))]),
    );
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
