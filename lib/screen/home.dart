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
  String _selectedCategory = 'Food';
  IconData? _selectedIcon = Icons.fastfood_rounded;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'icon': Icons.fastfood_rounded},
    {'name': 'Clothes', 'icon': Icons.shopping_bag_rounded},
    {'name': 'Transport', 'icon': Icons.directions_car_rounded},
    {'name': 'Bills', 'icon': Icons.receipt_long_rounded},
    {'name': 'Entertainment', 'icon': Icons.movie_rounded},
    {'name': 'Others', 'icon': Icons.account_balance_wallet_rounded},
  ];
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
      icon: Icons.fastfood_rounded,
    ),
    TransactionModel(
      icon: Icons.directions_car_rounded,
      title: "Uber",
      amount: 524,
      date: DateTime.now(),
      type: TransactionType.expense,
      category: "Travel",
    ),
    TransactionModel(
      icon: Icons.account_balance_wallet_rounded,
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

  //

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
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
                        radius: 27,
                        backgroundColor: AppColors.grey,
                        child: Icon(
                          Icons.person,
                          // size: 30,
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
                    // SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Text(
                        "₹${totalBalance.toStringAsFixed(2)}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.background,
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: AppColors.incomeGreen,
                                  // size: 30,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Income",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // SizedBox(height: 5),
                                    SizedBox(
                                      width: mq * 0.25,
                                      child: Text(
                                        "₹${totalIncome.toStringAsFixed(2)}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.background,
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: AppColors.expenseRed,
                                  // size: 30,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      "Expenses",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    // SizedBox(height: 10),
                                    SizedBox(
                                      width: mq * 0.25,
                                      child: Text(
                                        "₹${totalExpenses.toStringAsFixed(2)}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),
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
                      size: 25,
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
                            vertical: 12,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grey,
                                spreadRadius: -0,
                                blurRadius: 1,
                                offset: Offset(
                                  0,
                                  1,
                                ), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        border: Border.all(
                                          color: AppColors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        item.icon,
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
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      item.type == TransactionType.expense
                                          ? "- ₹${item.amount.toStringAsFixed(2)}"
                                          : "+ ₹${item.amount.toStringAsFixed(2)}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color:
                                            item.type == TransactionType.expense
                                            ? AppColors.red
                                            : AppColors.incomeGreen,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      DateFormat("dd MMM yy").format(item.date),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                  ],
                                ),
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => _buildAddTransactionSheet(),
          );
        },
        shape: CircleBorder(),
        backgroundColor: AppColors.cardGradientStart,
        child: Icon(Icons.add, color: AppColors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.white,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              color: AppColors.cardGradientStart,
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.bar_chart),
              color: AppColors.textGrey,
              onPressed: () {},
            ),
            SizedBox(width: 40), // Space for the floating action button
            IconButton(
              icon: Icon(Icons.wallet),
              color: AppColors.textGrey,
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person),
              color: AppColors.textGrey,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  TransactionType _selectedType = TransactionType.expense;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // function for add transaction sheet
  addTransaction() {
    var finalTitle = _titleController.text.trim();
    var finalAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (finalTitle.isEmpty || finalAmount <= 0) {
      return;
    }
    final newTx = TransactionModel(
      title: finalTitle,
      amount: finalAmount,
      date: DateTime.now(),
      type: _selectedType,
      category: _selectedCategory,
      icon: _selectedIcon,
    );

    setState(() {
      transaction.insert(0, newTx);
    });
    _titleController.clear();
    _amountController.clear();
    Navigator.of(context).pop();
    setState(() {});
  }

  Widget _buildAddTransactionSheet() {
    double mq = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Heading Text
              const Text(
                "Add Transaction",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              // toggle buttons for income and expense
              SizedBox(
                // color: Colors.red,
                width: mq * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = TransactionType.income;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.incomeGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Income",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = TransactionType.expense;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Expense",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.grey, width: 1),
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: "Title"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(labelText: "Amount"),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.grey),
                  ),
                ),
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['name'],
                    child: Row(
                      children: [
                        Icon(category['icon'], color: AppColors.textDark),
                        SizedBox(width: 10),
                        Text(category['name']),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                      _selectedIcon = _categories.firstWhere(
                        (category) => category['name'] == value,
                      )['icon'];
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cardGradientStart,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  addTransaction();
                },
                child: const Text(
                  "Save Transaction",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
