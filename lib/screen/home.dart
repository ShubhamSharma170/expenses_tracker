import 'package:exppence_tracker/core/constant/app_colors.dart';
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
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.grey,
                        child: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("Hello,", style: TextStyle(fontSize: 22)),
                      SizedBox(width: 5),
                      Text(
                        "Shubham",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    color: Colors.black,
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: AppColors.grey),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.notifications_none_outlined, size: 25),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Balance Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    tileMode: TileMode.clamp,
                    transform: GradientRotation(0.5),
                    colors: [
                      AppColors.cardGradientStart,
                      AppColors.cardGradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total Balance",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "₹ ${totalBalance.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.background,
                              child: Icon(
                                Icons.arrow_upward,
                                color: AppColors.incomeGreen,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Income",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "₹ ${totalIncome.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.background,
                              child: Icon(
                                Icons.arrow_downward,
                                color: AppColors.expenseRed,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  "Expenses",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "₹ ${totalExpenses.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
              // Transaction List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Transactions",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        AppColors.white,
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: AppColors.grey),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.filter_alt_rounded,
                      size: 30,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Transaction List View
              Expanded(
                child: ListView.builder(
                  itemCount: transaction.length,
                  itemBuilder: (context, index) {
                    final item = transaction[index];
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(
                                  0,
                                  3,
                                ), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      border: Border.all(color: AppColors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.account_balance_wallet,
                                      size: 60,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.category,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  item.type == TransactionType.expense
                                      ? Text("- ₹${item.amount.toString()}")
                                      : Text("+ ₹${item.amount.toString()}"),
                                  Text(
                                    DateFormat("dd MMM yy").format(item.date),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),

              // Text("Good Morning, Shubham", style: TextStyle(fontSize: 22)),
              // SizedBox(height: 20),
              // Text("Total Balance", style: TextStyle(fontSize: 20)),
              // SizedBox(height: 10),
              // Text(
              //   "₹ ${totalBalance.toStringAsFixed(2)}",
              //   style: TextStyle(fontSize: 20),
              // ),
              // SizedBox(height: 30),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Container(
              //       padding: EdgeInsets.all(15),
              //       decoration: BoxDecoration(
              //         border: BoxBorder.all(color: Colors.black),
              //       ),
              //       child: Column(
              //         children: [
              //           Text("Income", style: TextStyle(fontSize: 20)),
              //           SizedBox(height: 10),
              //           Text(
              //             "₹ ${totalIncome.toStringAsFixed(2)}",
              //             style: TextStyle(fontSize: 20),
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(),
              //     Container(
              //       padding: EdgeInsets.all(15),
              //       decoration: BoxDecoration(
              //         border: BoxBorder.all(color: Colors.black),
              //       ),
              //       child: Column(
              //         children: [
              //           Text("Expenses", style: TextStyle(fontSize: 20)),
              //           SizedBox(height: 10),
              //           Text(
              //             "₹ ${totalExpenses.toStringAsFixed(2)}",
              //             style: TextStyle(fontSize: 20),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 30),
              // Text("Recent Transactions", style: TextStyle(fontSize: 20)),
              // SizedBox(height: 20),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: transaction.length,
              //     itemBuilder: (context, index) {
              //       final item = transaction[index];
              //       return Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             item.category,
              //             style: TextStyle(
              //               fontSize: 22,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text(item.title, style: TextStyle(fontSize: 20)),
              //               item.type == TransactionType.expense
              //                   ? Text(
              //                       "- ₹${item.amount.toString()}",
              //                       style: TextStyle(fontSize: 20),
              //                     )
              //                   : Text(
              //                       "+ ₹${item.amount.toString()}",
              //                       style: TextStyle(fontSize: 20),
              //                     ),
              //             ],
              //           ),
              //           Text(
              //             DateFormat("dd MMM yyyy").format(item.date),
              //             style: TextStyle(fontSize: 18),
              //           ),
              //           SizedBox(height: 10),
              //         ],
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
