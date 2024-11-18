import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners(); // Notifies the UI to rebuild.
  }

  void removeExpense(Expense expense) {
    _expenses.remove(expense);
    notifyListeners(); // Notifies the UI to rebuild.
  }
}
