
enum EventType { wedding, birthday, graduation, babyShower, corporate, engagement, other }
enum EventStatus { upcoming, ongoing, completed, cancelled }

class EventModel {
  final String id;
  final String name;
  final EventType type;
  final String? description;
  final DateTime date;
  final DateTime? endDate;
  final String? startTime;
  final String? endTime;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? coverImage;
  final List<String> images;
  final EventStatus status;
  final double? budget;
  final int? expectedGuests;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? themeColor;
  final bool isPublic;
  final String? invitationMessage;
  final String? qrCode;

  EventModel({
    required this.id, required this.name, required this.type,
    this.description, required this.date, this.endDate,
    this.startTime, this.endTime, this.location,
    this.latitude, this.longitude, this.coverImage,
    this.images = const [], this.status = EventStatus.upcoming,
    this.budget, this.expectedGuests, this.notes,
    required this.createdAt, required this.updatedAt,
    this.themeColor, this.isPublic = false,
    this.invitationMessage, this.qrCode,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'type': type.name, 'description': description,
    'date': date.toIso8601String(), 'endDate': endDate?.toIso8601String(),
    'startTime': startTime, 'endTime': endTime, 'location': location,
    'latitude': latitude, 'longitude': longitude, 'coverImage': coverImage,
    'images': images, 'status': status.name, 'budget': budget,
    'expectedGuests': expectedGuests, 'notes': notes,
    'createdAt': createdAt.toIso8601String(), 'updatedAt': updatedAt.toIso8601String(),
    'themeColor': themeColor, 'isPublic': isPublic,
    'invitationMessage': invitationMessage, 'qrCode': qrCode,
  };

  factory EventModel.fromMap(Map<String, dynamic> map) => EventModel(
    id: map['id'] ?? '', name: map['name'] ?? '',
    type: EventType.values.firstWhere((e) => e.name == map['type'], orElse: () => EventType.other),
    description: map['description'],
    date: DateTime.parse(map['date']),
    endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    startTime: map['startTime'], endTime: map['endTime'],
    location: map['location'], latitude: map['latitude']?.toDouble(),
    longitude: map['longitude']?.toDouble(), coverImage: map['coverImage'],
    images: List<String>.from(map['images'] ?? []),
    status: EventStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => EventStatus.upcoming),
    budget: map['budget']?.toDouble(), expectedGuests: map['expectedGuests']?.toInt(),
    notes: map['notes'], createdAt: DateTime.parse(map['createdAt']),
    updatedAt: DateTime.parse(map['updatedAt']),
    themeColor: map['themeColor'], isPublic: map['isPublic'] ?? false,
    invitationMessage: map['invitationMessage'], qrCode: map['qrCode'],
  );

  String get typeLabel {
    switch (type) {
      case EventType.wedding: return 'زفاف';
      case EventType.birthday: return 'عيد ميلاد';
      case EventType.graduation: return 'تخرج';
      case EventType.babyShower: return 'استقبال مولود';
      case EventType.corporate: return 'مناسبة رسمية';
      case EventType.engagement: return 'خطوبة';
      case EventType.other: return 'أخرى';
    }
  }

  String get statusLabel {
    switch (status) {
      case EventStatus.upcoming: return 'قادمة';
      case EventStatus.ongoing: return 'جارية';
      case EventStatus.completed: return 'منتهية';
      case EventStatus.cancelled: return 'ملغاة';
    }
  }

  int get daysUntil {
    final difference = date.difference(DateTime.now());
    return difference.inDays;
  }

  String get formattedDate {
    final months = ['يناير','فبراير','مارس','إبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
