import 'package:exppence_tracker/core/constant/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryItems {
  final String name;
  final IconData icon;
  final Color color;

  CategoryItems({required this.name, required this.icon, required this.color});
}

class CategoryHelper {
  static List<CategoryItems> categories = [
    CategoryItems(
      name: "Food",
      icon: Icons.fastfood_outlined,
      color: AppColors.categoryFood,
    ),
    CategoryItems(
      name: "Transport",
      icon: Icons.directions_car_outlined,
      color: AppColors.categoryTransport,
    ),
    CategoryItems(
      name: "Entertainment",
      icon: Icons.movie_filter_outlined,
      color: AppColors.categoryEntertainment,
    ),
    CategoryItems(
      name: "Bills",
      icon: Icons.receipt_long_outlined,
      color: AppColors.categoryBills,
    ),
    CategoryItems(
      name: "Clothes",
      icon: Icons.shopping_bag_outlined,
      color: AppColors.categoryClothes,
    ),
    CategoryItems(
      name: "Other",
      icon: Icons.attach_money_rounded,
      color: AppColors.categoryOther,
    ),
  ];

  // Return the matching icon for a given category name
  static IconData getIcon(String? categoryName) {
    if (categoryName == null || categoryName.trim().isEmpty) {
      return Icons.category_rounded;
    }
    final item = categories.firstWhere(
      (element) =>
          element.name.toLowerCase() == categoryName.trim().toLowerCase(),
      orElse: () => CategoryItems(
        name: "Other",
        icon: Icons.more_horiz_outlined,
        color: AppColors.categoryOther,
      ),
    );
    return item.icon;
  }

  // Return the matching chart and badge color for a given category name
  static Color getColor(String? categoryName) {
    if (categoryName == null || categoryName.trim().isEmpty) {
      return AppColors.categoryOther;
    }
    final item = categories.firstWhere(
      (element) =>
          element.name.toLowerCase() == categoryName.trim().toLowerCase(),
      orElse: () => CategoryItems(
        name: "Other",
        icon: Icons.more_horiz_outlined,
        color: AppColors.categoryOther,
      ),
    );
    return item.color;
  }
}
