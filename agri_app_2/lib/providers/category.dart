// providers/category_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agri_app_2/presentation/model/category.dart';

final categoryProvider1 = Provider<List<Category>>((ref) {
  return [
    Category(title: 'Vegetables'),
    Category(title: 'Fruits'),
    // Add other categories as needed
  ];
});

final categoryProvider2 = Provider<List<Category>>((ref) {
  return [
    Category(title: 'Grains'),
    Category(title: 'Herbs'),
    // Add other categories as needed
  ];
});
