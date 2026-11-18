import 'package:exppence_tracker/core/constant/app_colors.dart';
import 'package:exppence_tracker/helper/category_helper.dart';
import 'package:exppence_tracker/models/transaction_model.dart';
import 'package:exppence_tracker/provider/transaction_provider.dart';
import 'package:exppence_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size.width;
    final authProvider = context.watch<AuthClassProvider>();
    final displayName = authProvider.userName.isNotEmpty
        ? authProvider.userName
        : "User";

    final txProvider = context.watch<TransactionProvider>();
    final transactions = txProvider.filteredTransactions;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.grey,
                          child: Icon(Icons.person, color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        const Text("Hello,", style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    color: Colors.black,
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: AppColors.grey),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await context.read<AuthClassProvider>().logout();
                    },
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 25,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
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
                    const Text(
                      "Total Balance",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Text(
                        "₹${txProvider.totalBalance.toStringAsFixed(2)}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.background,
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: AppColors.incomeGreen,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Income",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: mq * 0.25,
                                      child: Text(
                                        "₹${txProvider.totalIncome.toStringAsFixed(2)}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
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
                              const CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.background,
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: AppColors.expenseRed,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Expenses",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: mq * 0.25,
                                      child: Text(
                                        "₹${txProvider.totalExpenses.toStringAsFixed(2)}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
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

              const SizedBox(height: 25),
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
                            style: const TextStyle(
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
                    initialValue: txProvider.selectedFilter,
                    onSelected: (TransactionFilter filter) {
                      context.read<TransactionProvider>().setFilter(filter);
                    },
                    itemBuilder: (BuildContext context) => const [
                      PopupMenuItem(
                        value: TransactionFilter.all,
                        child: Text("All Transactions"),
                      ),
                      PopupMenuItem(
                        value: TransactionFilter.income,
                        child: Text("Income Only"),
                      ),
                      PopupMenuItem(
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
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Transaction List View
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final item = transactions[index];
                    return Column(
                      children: [
                        Dismissible(
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
                                    context
                                        .read<TransactionProvider>()
                                        .addTransactionToFirebase(deletedItem);
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.grey,
                                  spreadRadius: 0,
                                  blurRadius: 1,
                                  offset: Offset(0, 1),
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
                                      const SizedBox(width: 20),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.category,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textDark,
                                              ),
                                            ),
                                            Text(
                                              item.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
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
                                        style: const TextStyle(
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
                        const SizedBox(height: 20),
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
