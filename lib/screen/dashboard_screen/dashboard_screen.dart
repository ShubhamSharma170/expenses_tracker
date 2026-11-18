import 'package:exppence_tracker/core/constant/app_colors.dart';
import 'package:exppence_tracker/helper/category_helper.dart';
import 'package:exppence_tracker/models/transaction_model.dart';
import 'package:exppence_tracker/screen/analytics/analytics_screen.dart';
import 'package:exppence_tracker/screen/home.dart';
import 'package:exppence_tracker/utils/transaction_helper.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = 'Food';
  IconData? _selectedIcon = Icons.fastfood_rounded;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<Widget> _screens = const [HomeScreen(), AnalyticsScreen()];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _addTransaction() {
    TransactionHelper.submitTransaction(
      context: context,
      title: _titleController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0.0,
      type: _selectedType,
      category: _selectedCategory,
      icon: _selectedIcon,
      onSuccess: () {
        _titleController.clear();
        _amountController.clear();
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => _buildAddTransactionSheet(),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: AppColors.cardGradientStart,
        child: const Icon(Icons.add, color: AppColors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 65,
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.white,
        elevation: 12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: _currentIndex == 0
                  ? AppColors.cardGradientStart
                  : AppColors.textGrey,
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart),
              color: _currentIndex == 1
                  ? AppColors.cardGradientStart
                  : AppColors.textGrey,
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            const SizedBox(width: 40), // Space for the floating action button
            IconButton(
              icon: const Icon(Icons.wallet),
              color: AppColors.textGrey,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Wallet screen coming soon!"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: AppColors.textGrey,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Profile screen coming soon!"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTransactionSheet() {
    final double mq = MediaQuery.of(context).size.width;

    return StatefulBuilder(
      builder: (BuildContext sheetContext, StateSetter setSheetState) {
        final bool isIncome = _selectedType == TransactionType.income;
        final bool isExpense = _selectedType == TransactionType.expense;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle indicator at the top of the bottom sheet
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Modal heading title
                  const Text(
                    "Add Transaction",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // Segmented toggle buttons for Income and Expense
                  SizedBox(
                    width: mq * 0.65,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setSheetState(() {
                                _selectedType = TransactionType.income;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: isIncome
                                    ? AppColors.incomeGreen
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isIncome
                                      ? AppColors.incomeGreen
                                      : AppColors.grey,
                                ),
                              ),
                              child: Text(
                                "Income",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isIncome
                                      ? AppColors.white
                                      : AppColors.textGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setSheetState(() {
                                _selectedType = TransactionType.expense;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: isExpense
                                    ? AppColors.red
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isExpense
                                      ? AppColors.red
                                      : AppColors.grey,
                                ),
                              ),
                              child: Text(
                                "Expense",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isExpense
                                      ? AppColors.white
                                      : AppColors.textGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title and Amount input fields container
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.grey, width: 1),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: "Title"),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            labelText: "Amount",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category dropdown selector
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.grey),
                      ),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: CategoryHelper.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.name,
                        child: Row(
                          children: [
                            Icon(category.icon, color: AppColors.textDark),
                            const SizedBox(width: 10),
                            Text(category.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setSheetState(() {
                          _selectedCategory = value;
                          _selectedIcon = CategoryHelper.getIcon(value);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Submit button to save the transaction
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardGradientStart,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _addTransaction,
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
      },
    );
  }
}
