import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../utils/helpers.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});
  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _invitationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _selectedType = 'حفل زفاف';

  final List<String> _eventTypes = [
    'حفل زفاف', 'عيد ميلاد', 'تخرج', 'استقبال مولود', 'خطوبة', 'مناسبة رسمية', 'أخرى',
  ];

  static const Map<String, EventType> _typeMap = {
    'حفل زفاف': EventType.wedding,
    'عيد ميلاد': EventType.birthday,
    'تخرج': EventType.graduation,
    'استقبال مولود': EventType.babyShower,
    'خطوبة': EventType.engagement,
    'مناسبة رسمية': EventType.corporate,
    'أخرى': EventType.other,
  };

  String _formatTimeOfDay(TimeOfDay t) => '${t.hour}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء مناسبة جديدة'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildStepIndicator(),
            Expanded(child: _buildCurrentStep()),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildStepCircle(0, 'التفاصيل'),
          _buildStepLine(0),
          _buildStepCircle(1, 'الموقع'),
          _buildStepLine(1),
          _buildStepCircle(2, 'الدعوات'),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isActive = _currentStep >= step;
    final isCurrent = _currentStep == step;
    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.primaryLight,
              shape: BoxShape.circle,
              border: isCurrent ? Border.all(color: AppColors.primary, width: 3) : null,
            ),
            child: Center(
              child: isActive && _currentStep > step
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text('${step + 1}', style: TextStyle(color: isActive ? Colors.white : AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: isActive ? AppColors.primary : AppColors.textLight, fontSize: 12, fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildStepLine(int step) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 2,
        color: _currentStep > step ? AppColors.primary : AppColors.primaryLight,
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildDetailsStep();
      case 1: return _buildLocationStep();
      case 2: return _buildInvitationsStep();
      default: return const SizedBox();
    }
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, size: 40, color: AppColors.primary),
                    SizedBox(height: 8),
                    Text('صورة المناسبة', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'اسم المناسبة', prefixIcon: Icon(Icons.celebration_outlined)),
            validator: (value) => value == null || value.isEmpty ? 'الرجاء إدخال اسم المناسبة' : null,
          ),
          const SizedBox(height: 20),
          Text('نوع المناسبة', style: AppTextStyles.bodyLarge),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: const BorderRadius.all(Radius.circular(16)), border: Border.all(color: AppColors.primary.withOpacity(0.1))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true, value: _selectedType, icon: const Icon(Icons.keyboard_arrow_down),
                items: _eventTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('التاريخ والوقت', style: AppTextStyles.bodyLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDateTimeButton(icon: Icons.calendar_today_outlined, label: _selectedDate != null ? '${_selectedDate!.day}/${_selectedDate!.month}' : 'اليوم', onTap: _pickDate)),
              const SizedBox(width: 12),
              Expanded(child: _buildDateTimeButton(icon: Icons.access_time_outlined, label: _startTime != null ? '${_startTime!.hour}:${_startTime!.minute.toString().padLeft(2, '0')}' : 'البداية', onTap: _pickStartTime)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDateTimeButton(icon: Icons.notifications_outlined, label: 'التنبيه', onTap: () {})),
              const SizedBox(width: 12),
              Expanded(child: _buildDateTimeButton(icon: Icons.access_time_outlined, label: _endTime != null ? '${_endTime!.hour}:${_endTime!.minute.toString().padLeft(2, '0')}' : 'النهاية', onTap: _pickEndTime)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 300));
  }

  Widget _buildLocationStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اختر موقع المناسبة', style: AppTextStyles.headline3),
          const SizedBox(height: 16),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'الموقع', prefixIcon: Icon(Icons.location_on_outlined)),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: const Center(child: Icon(Icons.map_outlined, size: 80, color: AppColors.primary)),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 300));
  }

  Widget _buildInvitationsStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('رسالة الدعوة', style: AppTextStyles.headline3),
          const SizedBox(height: 16),
          TextField(controller: _invitationController, maxLines: 5, decoration: const InputDecoration(labelText: 'اكتب رسالة الدعوة...', alignLabelWithHint: true)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.cardDecoration,
            child: const Column(
              children: [
                Icon(Icons.qr_code_2, size: 120, color: AppColors.primary),
                SizedBox(height: 12),
                Text('QR Code للدعوة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Text('يمكن للضيوف مسح هذا الرمز للتأكيد', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: const Duration(milliseconds: 300));
  }

  Widget _buildDateTimeButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: const BorderRadius.all(Radius.circular(16)), border: Border.all(color: AppColors.primary.withOpacity(0.1))),
        child: Row(children: [Icon(icon, size: 20, color: AppColors.primary), const SizedBox(width: 8), Text(label, style: AppTextStyles.bodyLarge)]),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(child: OutlinedButton(onPressed: () => setState(() => _currentStep--), child: const Text('السابق'))),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentStep == 0 && !(_formKey.currentState?.validate() ?? false)) return;
                  if (_currentStep < 2) {
                    setState(() => _currentStep++);
                  } else {
                    _saveEvent();
                  }
                },
                child: Text(_currentStep < 2 ? 'التالي' : 'حفظ المناسبة'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365 * 2)));
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickStartTime() async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) setState(() => _startTime = time);
  }

  Future<void> _pickEndTime() async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) setState(() => _endTime = time);
  }

  void _saveEvent() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final now = DateTime.now();
    final event = EventModel(
      id: Helpers.generateId(),
      name: _nameController.text.trim(),
      type: _typeMap[_selectedType] ?? EventType.other,
      date: _selectedDate ?? now,
      startTime: _startTime != null ? _formatTimeOfDay(_startTime!) : null,
      endTime: _endTime != null ? _formatTimeOfDay(_endTime!) : null,
      location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      invitationMessage: _invitationController.text.trim().isEmpty ? null : _invitationController.text.trim(),
      createdAt: now,
      updatedAt: now,
    );
    context.read<EventProvider>().addEvent(event);
    Helpers.showSnackBar(context, 'تم إنشاء المناسبة بنجاح');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _invitationController.dispose();
    super.dispose();
  }
}
