import 'dart:math';

import 'package:flutter/material.dart';
import '../models/expense.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];

  void _addNewExpense(Map<String, dynamic> expenseData) {
    setState(() {
      _expenses.add(
        Expense(
          title: expenseData["note"],
          amount: double.parse(expenseData["amount"]),
          date: expenseData["date"],
          category: expenseData["category"],
        ),
      );
    });
  }

  void _navigateToAddExpense() async {
    final newExpense = await Navigator.pushNamed(context, "/add-expense");

    if (newExpense != null) {
      _addNewExpense(newExpense as Map<String, dynamic>);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Expense Tracker",
              style: TextStyle(fontSize: 25), // Main title
            ),
            const Text(
              "Track your daily spending",
              style: TextStyle(
                fontSize: 14, // Smaller font for subtitle
                color: Colors.white70, // Slightly lighter color
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),

      body: Stack(
        children: [
          // Chart Placeholder
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),

          // Expense List
          Expanded(
            child: _expenses.isEmpty
                ? const Center(
              child: Text(
                "No expenses added yet."
                    "Click the '+' icon to add Expenses",
                style: TextStyle(fontSize: 30, color: Colors.black87),
              ),
            )
                : ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final expense = _expenses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(
                      _getCategoryIcon(expense.category),
                      color: Colors.green,
                    ),
                    title: Text(expense.title),
                    subtitle: Text(
                        "${expense.date.month}/${expense.date.day}/${expense.date.year}"),
                    trailing: Text(
                      "\$${expense.amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExpense,
    shape: const CircleBorder(),
    child:Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
    colors:[
    Theme.of(context).colorScheme.tertiary,
    Theme.of(context).colorScheme.secondary,
    Theme.of(context).colorScheme.primary,
    ],
    transform: const GradientRotation(pi / 4),
    )
    ),


    child: const Icon(Icons.add),
    )
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Shopping':
        return Icons.shopping_cart;
      case 'Food':
        return Icons.fastfood;
      case 'Travel':
        return Icons.flight;
      case 'Bills':
        return Icons.receipt;
      case 'Miscellaneous':
        return Icons.more_horiz;
      default:
        return Icons.attach_money;
    }
  }
}
