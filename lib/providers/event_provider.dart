import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventProvider extends ChangeNotifier {
  List<EventModel> _events = [];
  List<EventModel> get events => _events;
  List<EventModel> get upcomingEvents => _events.where((e) => e.status == EventStatus.upcoming).toList()..sort((a,b) => a.date.compareTo(b.date));
  List<EventModel> get eventsByDate { final s = List<EventModel>.from(_events); s.sort((a,b) => a.date.compareTo(b.date)); return s; }

  void loadDummyData() {
    _events = [
      EventModel(id: '1', name: 'حفل زفاف أحمد وسارة', type: EventType.wedding,
        description: 'حفل زفاف في قاعة الفيصلية',
        date: DateTime.now().add(const Duration(days: 15)),
        startTime: '07:00 مساءً', endTime: '11:00 مساءً',
        location: 'قاعة الفيصلية، الرياض', budget: 50000, expectedGuests: 200,
        status: EventStatus.upcoming, themeColor: '#F8BBD9',
        createdAt: DateTime.now().subtract(const Duration(days: 30)), updatedAt: DateTime.now()),
      EventModel(id: '2', name: 'عيد ميلاد ليلى', type: EventType.birthday,
        description: 'عيد ميلاد الـ 25',
        date: DateTime.now().add(const Duration(days: 5)),
        startTime: '08:00 مساءً', location: 'مطعم نارسيس، جدة',
        budget: 5000, expectedGuests: 30,
        status: EventStatus.upcoming, themeColor: '#FFF9C4',
        createdAt: DateTime.now().subtract(const Duration(days: 10)), updatedAt: DateTime.now()),
      EventModel(id: '3', name: 'حفل تخرج خالد', type: EventType.graduation,
        description: 'تخرج من جامعة الملك سعود',
        date: DateTime.now().subtract(const Duration(days: 10)),
        startTime: '06:00 مساءً', location: 'استراحة النخيل',
        budget: 8000, expectedGuests: 50,
        status: EventStatus.completed, themeColor: '#C8E6C9',
        createdAt: DateTime.now().subtract(const Duration(days: 45)), updatedAt: DateTime.now()),
    ];
    notifyListeners();
  }

  void addEvent(EventModel event) { _events.add(event); notifyListeners(); }
  void deleteEvent(String id) { _events.removeWhere((e) => e.id == id); notifyListeners(); }
}
