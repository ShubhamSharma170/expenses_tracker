import 'package:exppence_tracker/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

   // getter methods for getting total income
  double get totalIncome {
    return transactions
        .where((items) => items.type == TransactionType.income)
        .fold(0.0, (previousValue, item) => previousValue + item.amount);
  }

  // getter methods for getting total expenses
  double get totalExpenses {
    return transactions
        .where((items) => items.type == TransactionType.expense)
        .fold(0.0, (previousValue, item) => previousValue + item.amount);
  }

  // getter methods for getting total balance
  double get totalBalance {
    return totalIncome - totalExpenses;
  }

  // method to add a transaction
  void addTransaction(TransactionModel tx) {
    _transactions.insert(0, tx);
    notifyListeners(); 
  }

}