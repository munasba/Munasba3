import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/guest_model.dart';
import '../providers/guest_provider.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';

class GuestListScreen extends StatefulWidget {
  final String eventId;
  const GuestListScreen({super.key, required this.eventId});

  @override
  State<GuestListScreen> createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GuestProvider>().loadDummyGuests(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الضيوف'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showAddGuestDialog(),
          ),
        ],
      ),
      body: Consumer<GuestProvider>(
        builder: (context, provider, child) {
          final guests = provider.getGuestsByEvent(widget.eventId);
          final confirmed = provider.getConfirmedCount(widget.eventId);
          final total = provider.getTotalGuestsCount(widget.eventId);

          return Column(
            children: [
              _buildStatsCard(confirmed, total),
              Expanded(
                child: guests.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: guests.length,
                        itemBuilder: (context, index) {
                          return _buildGuestCard(guests[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(int confirmed, int total) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.cardDecoration,
      child: Row(
        children: [
          _buildStat('مؤكد', confirmed, Colors.green),
          const VerticalDivider(),
          _buildStat('إجمالي', total, AppColors.primary),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildStat(String label, int value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.toString(),
            style: AppTextStyles.headline1.copyWith(color: color),
          ),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildGuestCard(GuestModel guest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppDecorations.cardDecoration,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: guest.statusColor.withOpacity(0.2),
          child: Icon(Icons.person, color: guest.statusColor),
        ),
        title: Text(guest.name, style: AppTextStyles.bodyLarge),
        subtitle: Text(
          '${guest.typeLabel} • ${guest.statusLabel}',
          style: AppTextStyles.bodySmall,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: guest.statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            guest.statusLabel,
            style: TextStyle(
              color: guest.statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: AppColors.primary.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text('لا يوجد ضيوف بعد', style: AppTextStyles.headline3.copyWith(color: AppColors.textLight)),
        ],
      ),
    );
  }

  void _showAddGuestDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AddGuestSheet(eventId: widget.eventId),
    );
  }
}

class AddGuestSheet extends StatefulWidget {
  final String eventId;
  const AddGuestSheet({super.key, required this.eventId});

  @override
  State<AddGuestSheet> createState() => _AddGuestSheetState();
}

class _AddGuestSheetState extends State<AddGuestSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      Helpers.showSnackBar(context, 'الرجاء إدخال اسم الضيف', isError: true);
      return;
    }
    context.read<GuestProvider>().addGuest(GuestModel(
          id: Helpers.generateId(),
          eventId: widget.eventId,
          name: name,
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          createdAt: DateTime.now(),
        ));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('إضافة ضيف', style: AppTextStyles.headline2),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'الاسم',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'رقم الجوال',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text('إضافة'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
