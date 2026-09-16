import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final IconData? icon;

  TransactionModel({
    required this.id,
    required this.icon,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  });

  // convert Dart object to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'type': type.name,
      'category': category,
    };
  }

  // convert Map from database to Dart object
  factory TransactionModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return TransactionModel(
      id: id ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.expense,
      ),
      category: map['category'] ?? '',
      icon:
          null, //we can set the icon based on the category dynamically in the UI layer, so we can leave it as null here
    );
  }
}
