import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final IconData? icon;

  TransactionModel({
    required this.icon,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  });
}
