import 'dart:async';
import 'package:exppence_tracker/models/transaction_model.dart';
import 'package:exppence_tracker/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  final FirestoreServices _firestoreServices = FirestoreServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<TransactionModel> _transactions = [];
  StreamSubscription<List<TransactionModel>>? _transactionSubscription;
  StreamSubscription<User?>? _authSubscription;

  // Automatically react to user login and logout events
  TransactionProvider() {
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        listenToTransactions(user.uid);
      } else {
        // Clear previous user's data and stop listening on logout
        _transactionSubscription?.cancel();
        _transactions = [];
        notifyListeners();
      }
    });
  }

  // Return an unmodifiable list to prevent accidental external mutations
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  // Calculate total income from the current user's transactions
  double get totalIncome {
    return transactions
        .where((item) => item.type == TransactionType.income)
        .fold(0.0, (previousValue, item) => previousValue + item.amount);
  }

  // Calculate total expenses from the current user's transactions
  double get totalExpenses {
    return transactions
        .where((item) => item.type == TransactionType.expense)
        .fold(0.0, (previousValue, item) => previousValue + item.amount);
  }

  // Calculate net balance by subtracting total expenses from total income
  double get totalBalance {
    return totalIncome - totalExpenses;
  }

  // Save a new transaction under the currently signed-in user's UID
  Future<void> addTransactionToFirebase(TransactionModel transaction) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('No authenticated user found.');
    }
    await _firestoreServices.addTransaction(uid, transaction);
  }

  // Remove a transaction locally for instant feedback and delete from Firestore
  Future<void> deleteTransaction(int index) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final removedTx = _transactions[index];
    _transactions.removeAt(index);
    notifyListeners();

    if (removedTx.id.isNotEmpty) {
      try {
        await _firestoreServices.deleteTransaction(uid, removedTx.id);
      } catch (e) {
        // Restore the item locally if Firestore deletion fails
        _transactions.insert(index, removedTx);
        notifyListeners();
      }
    }
  }

  // Subscribe to real-time transaction updates for the given user UID
  void listenToTransactions(String uid) {
    _transactionSubscription?.cancel();
    _transactionSubscription =
        _firestoreServices.getTransactions(uid).listen((updatedList) {
      _transactions = updatedList;
      notifyListeners();
    });
  }

  // Cancel all active stream subscriptions when the provider is disposed
  @override
  void dispose() {
    _transactionSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}