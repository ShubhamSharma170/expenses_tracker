import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exppence_tracker/models/transaction_model.dart';

class FirestoreServices {
  // Base reference to the users collection in Firestore
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Helper method to get the transactions sub-collection for a specific user
  CollectionReference _userTransactionsRef(String uid) {
    return _usersCollection.doc(uid).collection('transactions');
  }

  // Add a new transaction document under the specific user's sub-collection
  Future<void> addTransaction(String uid, TransactionModel transaction) async {
    try {
      await _userTransactionsRef(uid).add(transaction.toMap());
    } catch (error) {
      rethrow;
    }
  }

  // Delete a specific transaction document from the user's sub-collection
  Future<void> deleteTransaction(String uid, String transactionId) async {
    try {
      await _userTransactionsRef(uid).doc(transactionId).delete();
    } catch (error) {
      rethrow;
    }
  }

  // Listen to a live stream of transactions belonging only to the given user
  Stream<List<TransactionModel>> getTransactions(String uid) {
    return _userTransactionsRef(uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TransactionModel.fromMap(
              doc.data() as Map<String, dynamic>,
              id: doc.id,
            );
          }).toList();
        });
  }
}