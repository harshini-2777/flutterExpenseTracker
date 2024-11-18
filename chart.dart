import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> recentExpenses;

  ExpenseChart({required this.recentExpenses});

  @override
  Widget build(BuildContext context) {
    final data = recentExpenses.map((e) => {
      'category': e.title,
      'amount': e.amount,
    }).toList();

    return charts.BarChart([charts.Series(
      id: 'Expenses',
      data: data,
      domainFn: (datum, _) => datum['category'],
      measureFn: (datum, _) => datum['amount'],
    )]);
  }
}
