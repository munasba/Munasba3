import 'package:flutter/material.dart';

enum GuestStatus { invited, confirmed, declined, maybe, attended }
enum GuestType { family, friend, colleague, vip, other }

class GuestModel {
  final String id; final String eventId; final String name;
  final String? phone; final String? email;
  final GuestStatus status; final GuestType type;
  final int? numberOfGuests; final String? notes;
  final String? qrCode; final DateTime? invitedAt;
  final DateTime? respondedAt; final DateTime createdAt;

  GuestModel({
    required this.id, required this.eventId, required this.name,
    this.phone, this.email, this.status = GuestStatus.invited,
    this.type = GuestType.other, this.numberOfGuests,
    this.notes, this.qrCode, this.invitedAt,
    this.respondedAt, required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'eventId': eventId, 'name': name, 'phone': phone,
    'email': email, 'status': status.name, 'type': type.name,
    'numberOfGuests': numberOfGuests, 'notes': notes,
    'qrCode': qrCode, 'invitedAt': invitedAt?.toIso8601String(),
    'respondedAt': respondedAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory GuestModel.fromMap(Map<String, dynamic> map) => GuestModel(
    id: map['id'] ?? '', eventId: map['eventId'] ?? '', name: map['name'] ?? '',
    phone: map['phone'], email: map['email'],
    status: GuestStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => GuestStatus.invited),
    type: GuestType.values.firstWhere((e) => e.name == map['type'], orElse: () => GuestType.other),
    numberOfGuests: map['numberOfGuests']?.toInt(), notes: map['notes'],
    qrCode: map['qrCode'], invitedAt: map['invitedAt'] != null ? DateTime.parse(map['invitedAt']) : null,
    respondedAt: map['respondedAt'] != null ? DateTime.parse(map['respondedAt']) : null,
    createdAt: DateTime.parse(map['createdAt']),
  );

  String get statusLabel {
    switch (status) {
      case GuestStatus.invited: return 'تمت الدعوة';
      case GuestStatus.confirmed: return 'مؤكد';
      case GuestStatus.declined: return 'اعتذر';
      case GuestStatus.maybe: return 'ربما';
      case GuestStatus.attended: return 'حضر';
    }
  }

  String get typeLabel {
    switch (type) {
      case GuestType.family: return 'عائلة';
      case GuestType.friend: return 'صديق';
      case GuestType.colleague: return 'زميل';
      case GuestType.vip: return 'VIP';
      case GuestType.other: return 'أخرى';
    }
  }

  Color get statusColor {
    switch (status) {
      case GuestStatus.invited: return Colors.orange;
      case GuestStatus.confirmed: return Colors.green;
      case GuestStatus.declined: return Colors.red;
      case GuestStatus.maybe: return Colors.amber;
      case GuestStatus.attended: return Colors.blue;
    }
  }
}
