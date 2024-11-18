import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String _selectedAccount = "Card";
  String _selectedCategory = "Shopping";
  String _note = "";
  String _amount = "0";
  DateTime? _selectedDate = DateTime.now();
  int _currentTab = 1; // Default to "Expense"

  final List<String> _accounts = ["Card", "Cash"];
  final List<String> _categories = ["Shopping", "Food","Education","Donation", "Travel", "Bills", "Miscellaneous"];

  void _updateAmount(String value) {
    setState(() {
      if (_amount == "0" && value != ".") {
        _amount = value;
      } else {
        _amount += value;
      }
    });
  }

  void _clearAmount() {
    setState(() {
      _amount = "0";
    });
  }

  void _backspaceAmount() {
    setState(() {
      if (_amount.length > 1) {
        _amount = _amount.substring(0, _amount.length - 1);
      } else {
        _amount = "0";
      }
    });
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _addExpense() {
    // Return the collected data to the previous screen
    if (_amount == "0") return; // Prevent submission with zero amount

    Navigator.pop(context, {
      "amount": _amount,
      "account": _selectedAccount,
      "category": _selectedCategory,
      "note": _note,
      "date": _selectedDate,
      "type": _currentTab == 0 ? "Income" : _currentTab == 1 ? "Expense" : "Transfer",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: Colors.green,
        actions: [
          TextButton(
            onPressed: _addExpense,
            child: const Text(
              "SAVE",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs for Income, Expense, and Transfer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTab("Income", 0),
                _buildTab("Expense", 1),
                _buildTab("Transfer", 2),
              ],
            ),
          ),

          // Account, Category, and Note Input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildSelectionCard("Account", _selectedAccount, _accounts, (value) {
                      setState(() {
                        _selectedAccount = value!;
                      });
                    }),
                    const SizedBox(width: 16),
                    _buildSelectionCard("Category", _selectedCategory, _categories, (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _note = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Add a note",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate != null
                            ? "Date: ${_selectedDate!.toLocal()}".split(' ')[0]
                            : "No date selected",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text("Choose Date"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Amount Display
          Expanded(
            child: Center(
              child: Text(
                _amount,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Calculator Buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCalcButton("7"),
                    _buildCalcButton("8"),
                    _buildCalcButton("9"),
                    _buildCalcButton("⌫", isOperator: true, onTap: _backspaceAmount),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCalcButton("4"),
                    _buildCalcButton("5"),
                    _buildCalcButton("6"),
                    _buildCalcButton("C", isOperator: true, onTap: _clearAmount),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCalcButton("1"),
                    _buildCalcButton("2"),
                    _buildCalcButton("3"),
                    _buildCalcButton(".", isOperator: true),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCalcButton("0", flex: 2),
                    _buildCalcButton("=", onTap: _addExpense),
                  ],
                ),
              ],
            ),
          ),

          // Add Expense Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: _addExpense,
              child: const Text("Add Expense"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isActive = _currentTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTab = index;
        });
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSelectionCard(String title, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value,
            items: options
                .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                .toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalcButton(String label, {bool isOperator = false, int flex = 1, VoidCallback? onTap}) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: onTap ??
                () {
              if (!isOperator) {
                _updateAmount(label);
              }
            },
        child: Container(
          margin: const EdgeInsets.all(4),
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isOperator ? Colors.orange : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isOperator ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
