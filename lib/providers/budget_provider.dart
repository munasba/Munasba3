import 'package:flutter/material.dart';
import '../models/budget_model.dart';

class BudgetProvider extends ChangeNotifier {
  List<BudgetItem> _items = [];
  List<BudgetItem> get items => _items;
  List<BudgetItem> getItemsByEvent(String eventId) => _items.where((i) => i.eventId == eventId).toList();

  BudgetSummary getSummary(String eventId) {
    final eventItems = getItemsByEvent(eventId);
    final totalEstimated = eventItems.fold<double>(0, (sum, i) => sum + i.estimatedCost);
    final totalActual = eventItems.fold<double>(0, (sum, i) => sum + (i.actualCost ?? 0));
    final totalPaid = eventItems.where((i) => i.isPaid).fold<double>(0, (sum, i) => sum + (i.actualCost ?? i.estimatedCost));
    return BudgetSummary(totalEstimated: totalEstimated, totalActual: totalActual, totalPaid: totalPaid, totalItems: eventItems.length, paidItems: eventItems.where((i) => i.isPaid).length);
  }

  void loadDummyBudget(String eventId) {
    _items = [
      BudgetItem(id: 'b1', eventId: eventId, name: 'حجز القاعة', category: BudgetCategory.venue, estimatedCost: 20000, actualCost: 22000, isPaid: true, createdAt: DateTime.now()),
      BudgetItem(id: 'b2', eventId: eventId, name: 'البوفيه', category: BudgetCategory.catering, estimatedCost: 15000, actualCost: 15000, isPaid: false, createdAt: DateTime.now()),
      BudgetItem(id: 'b3', eventId: eventId, name: 'الديكور', category: BudgetCategory.decoration, estimatedCost: 8000, actualCost: 7500, isPaid: true, createdAt: DateTime.now()),
      BudgetItem(id: 'b4', eventId: eventId, name: 'التصوير', category: BudgetCategory.photography, estimatedCost: 5000, createdAt: DateTime.now()),
    ];
    notifyListeners();
  }
}
