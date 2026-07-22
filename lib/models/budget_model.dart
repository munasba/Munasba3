
enum BudgetCategory {
  venue, catering, decoration, photography, music,
  transportation, invitations, gifts, clothing, other
}

class BudgetItem {
  final String id; final String eventId; final String name;
  final BudgetCategory category; final double estimatedCost;
  final double? actualCost; final bool isPaid;
  final DateTime? paidAt; final String? notes;
  final DateTime createdAt;

  BudgetItem({
    required this.id, required this.eventId, required this.name,
    required this.category, required this.estimatedCost,
    this.actualCost, this.isPaid = false, this.paidAt,
    this.notes, required this.createdAt,
  });

  double get remaining => estimatedCost - (actualCost ?? 0);
  double get variance => (actualCost ?? 0) - estimatedCost;

  String get categoryLabel {
    switch (category) {
      case BudgetCategory.venue: return 'المكان';
      case BudgetCategory.catering: return 'الضيافة';
      case BudgetCategory.decoration: return 'الديكور';
      case BudgetCategory.photography: return 'التصوير';
      case BudgetCategory.music: return 'الموسيقى';
      case BudgetCategory.transportation: return 'المواصلات';
      case BudgetCategory.invitations: return 'الدعوات';
      case BudgetCategory.gifts: return 'الهدايا';
      case BudgetCategory.clothing: return 'الملابس';
      case BudgetCategory.other: return 'أخرى';
    }
  }

  Map<String, dynamic> toMap() => {
    'id': id, 'eventId': eventId, 'name': name,
    'category': category.name, 'estimatedCost': estimatedCost,
    'actualCost': actualCost, 'isPaid': isPaid,
    'paidAt': paidAt?.toIso8601String(), 'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory BudgetItem.fromMap(Map<String, dynamic> map) => BudgetItem(
    id: map['id'] ?? '', eventId: map['eventId'] ?? '', name: map['name'] ?? '',
    category: BudgetCategory.values.firstWhere((e) => e.name == map['category'], orElse: () => BudgetCategory.other),
    estimatedCost: map['estimatedCost']?.toDouble() ?? 0,
    actualCost: map['actualCost']?.toDouble(),
    isPaid: map['isPaid'] ?? false,
    paidAt: map['paidAt'] != null ? DateTime.parse(map['paidAt']) : null,
    notes: map['notes'], createdAt: DateTime.parse(map['createdAt']),
  );
}

class BudgetSummary {
  final double totalEstimated; final double totalActual;
  final double totalPaid; final int totalItems; final int paidItems;

  BudgetSummary({
    required this.totalEstimated, required this.totalActual,
    required this.totalPaid, required this.totalItems,
    required this.paidItems,
  });

  double get remaining => totalEstimated - totalActual;
  double get percentageUsed => totalEstimated > 0 ? (totalActual / totalEstimated) * 100 : 0;
  bool get isOverBudget => totalActual > totalEstimated;
}
