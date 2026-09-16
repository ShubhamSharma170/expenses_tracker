import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exppence_tracker/models/transaction_model.dart';

class FirestoreServices {
  // Transaction Collection Reference
  final CollectionReference transactionCollection = FirebaseFirestore.instance
      .collection('transactions');

  // Add Transaction to Firestore
    Future<void> addTransaction(TransactionModel transaction) async {
      try {
        await transactionCollection.add(transaction.toMap());
      } catch (error) {
        rethrow;
      }
    }

  // live stream of transactions
  Stream<List<TransactionModel>> getTransactions() {
    return transactionCollection
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
