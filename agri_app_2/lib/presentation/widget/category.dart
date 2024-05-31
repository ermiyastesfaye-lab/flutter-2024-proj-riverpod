import 'package:agri_app_2/presentation/data/dummy_data.dart';
import 'package:agri_app_2/presentation/model/category.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key, required this.category});

  final Category category;

  @override
  Widget build(context) {
    return OutlinedButton(
        onPressed: () {},
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(const Size(100, 10)),
        ),
        child: Text(
          category.title,
          style: TextStyle(
              color: myColor.tertiary),
        ));
  }
}
