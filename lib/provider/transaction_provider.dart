import 'dart:async';

import 'package:exppence_tracker/models/transaction_model.dart';
import 'package:exppence_tracker/services/firebase_services.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  // constructor of transaction provider
  TransactionProvider() {
    listenToTransactions();
  }

  // constructor of firebase services
  FirestoreServices firestoreServices = FirestoreServices();
  List<TransactionModel> _transactions = [];

  // getter method to get all transactions and return an unmodifiable list (to prevent external modifications )
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

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

  // method to delete a transaction
  // void deleteTransaction(int index) {
  //   _transactions.removeAt(index);
  //   notifyListeners();
  // }

  // Remove a transaction from the local list immediately and delete it from Firestore
  Future<void> deleteTransaction(int index) async {
    final removedTx = _transactions[index];
    _transactions.removeAt(index);
    notifyListeners();

    if (removedTx.id.isNotEmpty) {
      try {
        await firestoreServices.deleteTransaction(removedTx.id);
      } catch (e) {
        // Restore the item locally if Firestore deletion fails
        _transactions.insert(index, removedTx);
        notifyListeners();
      }
    }
  }

  // method for inserting a transaction
  void insertTransaction(int index, TransactionModel tx) {
    _transactions.insert(index, tx);
    notifyListeners();
  }

  // method for add transaction in firebase
  Future<void> addTransactionToFirebase(TransactionModel transaction) async {
    await firestoreServices.addTransaction(transaction);
  }

  // Stream subscription to listen for changes in the transactions collection
  StreamSubscription<List<TransactionModel>>? _transactionSubscription;

  // method to start listening for changes in the transactions collection
  void listenToTransactions() {
    _transactionSubscription = firestoreServices.getTransactions().listen((
      updatedList,
    ) {
      _transactions = updatedList;
      notifyListeners();
    });
  }

  // dispose
  @override
  void dispose() {
    _transactionSubscription?.cancel();
    super.dispose();
  }
}
