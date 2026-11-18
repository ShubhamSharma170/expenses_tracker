import 'package:exppence_tracker/core/constant/app_colors.dart';
import 'package:exppence_tracker/helper/category_helper.dart';
import 'package:exppence_tracker/models/transaction_model.dart';
import 'package:exppence_tracker/provider/transaction_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  TransactionType _selectedType = TransactionType.expense;
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final categoryBreakdown = txProvider.getCategoryBreakdown(_selectedType);
    final totalAmount = _selectedType == TransactionType.expense
        ? txProvider.totalExpenses
        : txProvider.totalIncome;

    final entries = categoryBreakdown.entries.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Header
              const Text(
                "Analytics",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Track where your money goes by category",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 20),

              // Expense vs Income Toggle Switch
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.grey.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    _buildTypeToggleButton(
                      label: "Expenses",
                      type: TransactionType.expense,
                      activeColor: AppColors.expenseRed,
                    ),
                    _buildTypeToggleButton(
                      label: "Income",
                      type: TransactionType.income,
                      activeColor: AppColors.incomeGreen,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Chart Card or Empty State
              if (entries.isEmpty || totalAmount <= 0)
                _buildEmptyState()
              else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 230,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        _touchedIndex = -1;
                                        return;
                                      }
                                      _touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  },
                                ),
                                borderData: FlBorderData(show: false),
                                sectionsSpace: 3,
                                centerSpaceRadius: 68,
                                sections: List.generate(entries.length, (index) {
                                  final entry = entries[index];
                                  final isTouched = index == _touchedIndex;
                                  final percentage =
                                      (entry.value / totalAmount) * 100;

                                  return PieChartSectionData(
                                    color: CategoryHelper.getColor(entry.key),
                                    value: entry.value,
                                    title: percentage >= 8
                                        ? '${percentage.toStringAsFixed(0)}%'
                                        : '',
                                    radius: isTouched ? 44 : 36,
                                    titleStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white,
                                    ),
                                  );
                                }),
                              ),
                            ),
                            // Center Total Summary inside Donut
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedType == TransactionType.expense
                                      ? "Total Expense"
                                      : "Total Income",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "₹${totalAmount.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Category Breakdown Section Header
                const Text(
                  "Category Breakdown",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),

                // Category Breakdown List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final categoryName = entry.key;
                    final amount = entry.value;
                    final percentage = (amount / totalAmount) * 100;
                    final color = CategoryHelper.getColor(categoryName);

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  CategoryHelper.getIcon(categoryName),
                                  color: color,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      categoryName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "${percentage.toStringAsFixed(1)}% of total",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "₹${amount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              minHeight: 6,
                              backgroundColor: color.withValues(alpha: 0.14),
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Toggle button for switching between Expenses and Income
  Widget _buildTypeToggleButton({
    required String label,
    required TransactionType type,
    required Color activeColor,
  }) {
    final isSelected = _selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedType != type) {
            setState(() {
              _selectedType = type;
              _touchedIndex = -1;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : AppColors.trans,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.textGrey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Clean fallback UI when there are no transactions for the selected type
  Widget _buildEmptyState() {
    final label =
        _selectedType == TransactionType.expense ? "expenses" : "income";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.pie_chart_outline_rounded,
            size: 56,
            color: AppColors.textGrey.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 12),
          Text(
            "No $label data yet",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Tap the + button below to add your first transaction and see your breakdown here.",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}