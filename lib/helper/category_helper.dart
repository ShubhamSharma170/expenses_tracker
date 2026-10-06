import 'package:flutter/material.dart';

class CategoryItems {
  final String name;
  final IconData icon;

  CategoryItems({required this.name, required this.icon});
}

class CategoryHelper {
  static List<CategoryItems> categories = [
    CategoryItems(name: "Food", icon: Icons.fastfood_outlined),
    CategoryItems(name: "Transport", icon: Icons.directions_car_outlined),
    CategoryItems(name: "Entertainment", icon: Icons.movie_filter_outlined),
    CategoryItems(name: "Bills", icon: Icons.receipt_long_outlined),
    CategoryItems(name: "Clothes", icon: Icons.shopping_bag_outlined),
    CategoryItems(name: "Other", icon: Icons.attach_money_rounded),
  ];

  static IconData getIcon(String? categoryName) {
    if (categoryName == null || categoryName.trim().isEmpty) {
      return Icons.category_rounded;
    }
    final item = categories.firstWhere(
      (element) =>
          element.name.toLowerCase() == categoryName.trim().toLowerCase(),
      orElse: () =>
          CategoryItems(name: "Other", icon: Icons.more_horiz_outlined),
    );
    return item.icon;
  }
}
