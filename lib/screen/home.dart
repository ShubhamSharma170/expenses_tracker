import 'package:exppence_tracker/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //  final List<Map<String, dynamic>>  _transactions = [
  //   {"title": "Grocery", "amount": 35200},
  //   {"title": "Travel", "amount": 524},
  //   {"title": "Salary", "amount": 60000},
  // ];

  final transaction = [
    TransactionModel(
      title: "Food",
      amount: 250,
      date: DateTime.now(),
      type: TransactionType.expense,
      category: "Grocery",
    ),
    TransactionModel(
      title: "Uber",
      amount: 524,
      date: DateTime.now(),
      type: TransactionType.expense,
      category: "Travel",
    ),
    TransactionModel(
      title: "Salary",
      amount: 60000,
      date: DateTime.now(),
      type: TransactionType.income,
      category: "Salary",
    ),
  ];

  // getter methods for getting total income
  double get totalIncome {
    return transaction
        .where((items) => items.type == TransactionType.income)
        .fold(0.0, (previousValue, item) => previousValue + item.amount);
  }

  // getter methods for getting total expenses
  double get totalExpenses {
    return transaction
        .where((items) => items.type == TransactionType.expense)
        .fold(0.0, (previousValue, item) => previousValue + item.amount);
  }

  // getter methods for getting total balance
  double get totalBalance {
    return totalIncome - totalExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good Morning, Shubham", style: TextStyle(fontSize: 22)),
              SizedBox(height: 20),
              Text("Total Balance", style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text(
                "₹ ${totalBalance.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Colors.black),
                    ),
                    child: Column(
                      children: [
                        Text("Income", style: TextStyle(fontSize: 20)),
                        SizedBox(height: 10),
                        Text(
                          "₹ ${totalIncome.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Colors.black),
                    ),
                    child: Column(
                      children: [
                        Text("Expenses", style: TextStyle(fontSize: 20)),
                        SizedBox(height: 10),
                        Text(
                          "₹ ${totalExpenses.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text("Recent Transactions", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: transaction.length,
                  itemBuilder: (context, index) {
                    final item = transaction[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.category,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.title, style: TextStyle(fontSize: 20)),
                            item.type == TransactionType.expense
                                ? Text(
                                    "- ₹${item.amount.toString()}",
                                    style: TextStyle(fontSize: 20),
                                  )
                                : Text(
                                    "+ ₹${item.amount.toString()}",
                                    style: TextStyle(fontSize: 20),
                                  ),
                          ],
                        ),
                        Text(
                          DateFormat("dd MMM yyyy").format(item.date),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
