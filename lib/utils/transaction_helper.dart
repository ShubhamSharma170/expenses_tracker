import 'package:exppence_tracker/core/constant/app_colors.dart';
import 'package:exppence_tracker/models/transaction_model.dart';
import 'package:exppence_tracker/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionHelper {
  // function for submit transaction
  static Future<void> submitTransaction({
    required BuildContext context,
    required String title,
    required double amount,
    required TransactionType type,
    required String category,
    IconData? icon,
    required VoidCallback onSuccess,
  }) async {
    final finalTitle = title.trim();
    final finalAmount = amount;

    if (finalTitle.isEmpty || finalAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid title and amount.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }
    final newTx = TransactionModel(
      id: "",
      title: finalTitle,
      amount: finalAmount,
      type: type,
      category: category,
      date: DateTime.now(),
    );

    try {
      await context.read<TransactionProvider>().addTransactionToFirebase(newTx);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaction added successfully.'),
          backgroundColor: AppColors.green,
        ),
      );

      onSuccess();

      Navigator.of(context).pop();
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add transaction. Please try again.'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }
}
