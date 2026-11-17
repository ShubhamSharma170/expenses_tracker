import 'package:exppence_tracker/core/constant/app_colors.dart';
import 'package:exppence_tracker/helper/category_helper.dart';
import 'package:exppence_tracker/models/transaction_model.dart';
import 'package:exppence_tracker/provider/transaction_provider.dart';
import 'package:exppence_tracker/services/auth_service.dart';
import 'package:exppence_tracker/utils/transaction_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Food';
  IconData? _selectedIcon = Icons.fastfood_rounded;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    final authProvider = context.watch<AuthClassProvider>();
    final displayName = authProvider.userName.isNotEmpty
        ? authProvider.userName
        : "User";

    final txProvider = context.watch<TransactionProvider>();
    final transactions = txProvider
        .filteredTransactions; // Use filtered transactions based on the selected filter
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
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.grey,
                          child: Icon(
                            Icons.person,
                            // size: 30,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("Hello,", style: TextStyle(fontSize: 20)),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    onPressed: () async {
                      await context.read<AuthClassProvider>().logout();
                    },
                    icon: Icon(Icons.notifications_none_outlined, size: 22),
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
                        "₹${txProvider.totalBalance.toStringAsFixed(2)}",
                        // "₹${totalBalance.toStringAsFixed(2)}",
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
                                        "₹${txProvider.totalIncome.toStringAsFixed(2)}",
                                        // "₹${totalIncome.toStringAsFixed(2)}",
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
                                        "₹${txProvider.totalExpenses.toStringAsFixed(2)}",
                                        // "₹${totalExpenses.toStringAsFixed(2)}",
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
              // Transaction List Header with Filter Menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Recent Transactions",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (txProvider.selectedFilter !=
                          TransactionFilter.all) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardGradientStart.withValues(
                              alpha: 0.12,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            txProvider.selectedFilter.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.cardGradientStart,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  PopupMenuButton<TransactionFilter>(
                    // [UPDATED]
                    initialValue: txProvider.selectedFilter,
                    onSelected: (TransactionFilter filter) {
                      context.read<TransactionProvider>().setFilter(filter);
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: TransactionFilter.all,
                        child: Text("All Transactions"),
                      ),
                      const PopupMenuItem(
                        value: TransactionFilter.income,
                        child: Text("Income Only"),
                      ),
                      const PopupMenuItem(
                        value: TransactionFilter.expense,
                        child: Text("Expense Only"),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: AppColors.grey),
                      ),
                      child: Icon(
                        Icons.filter_alt_rounded,
                        size: 25,
                        color:
                            txProvider.selectedFilter == TransactionFilter.all
                            ? AppColors.textDark
                            : AppColors.cardGradientStart,
                      ),
                    ),
                  ), // [UPDATED]
                ],
              ),
              SizedBox(height: 20),

              // Transaction List View
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final item = transactions[index];
                    return Column(
                      children: [
                        Dismissible(
                          // Use the unique Firestore document ID as the widget key
                          key: ValueKey(
                            item.id.isNotEmpty
                                ? item.id
                                : '${item.title}_${item.date.microsecondsSinceEpoch}',
                          ),
                          background: Container(
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete_outline_outlined,
                              color: AppColors.white,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            final deletedItem = transactions[index];
                            final deletedIndex = index;

                            // Delete from local state and Firestore
                            context
                                .read<TransactionProvider>()
                                .deleteTransaction(deletedIndex);

                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${deletedItem.title} deleted",
                                  style: const TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                                duration: const Duration(seconds: 4),
                                action: SnackBarAction(
                                  label: "Undo",
                                  onPressed: () {
                                    // Re-save the deleted transaction back to Firestore
                                    context
                                        .read<TransactionProvider>()
                                        .addTransactionToFirebase(deletedItem);
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            CategoryHelper.getIcon(
                                              item.category,
                                            ),
                                            size: 30,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.category,
                                              maxLines: 1,
                                              // overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textDark,
                                              ),
                                            ),
                                            Text(
                                              item.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: AppColors.textGrey,
                                              ),
                                            ),
                                          ],
                                        ),
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
                                              item.type ==
                                                  TransactionType.expense
                                              ? AppColors.red
                                              : AppColors.incomeGreen,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        DateFormat(
                                          "dd MMM yy",
                                        ).format(item.date),
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

  void addTransaction() {
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
        // Navigator.of(context).pop();
      },
    );
  }

  Widget _buildAddTransactionSheet() {
    double mq = MediaQuery.of(context).size.width;

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
                              // Rebuild only the bottom sheet when Income is selected
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
                              // Rebuild only the bottom sheet when Expense is selected
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
                        // Update selected category and icon inside the bottom sheet
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
      },
    );
  }
}
