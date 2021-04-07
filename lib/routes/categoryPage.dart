import 'package:flutter/material.dart';
import 'package:plutus/widgets/category.dart';
import 'dart:math';

import 'package:plutus/data/incomeCat.dart';

// const _padding = EdgeInsets.all(16.0);

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    // final accentColor = Colors.cyan;
    final _random = new Random();

    const baseColors = <Color>[
      Colors.teal,
      Colors.orange,
      Colors.pinkAccent,
      Colors.blueAccent,
      Colors.yellow,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.red,
    ];

    return ListView.builder(
      itemCount: IncomeCategory.categoryNames.length,
      itemBuilder: (BuildContext context, int index) {
        return Category(
          index: index,
          categoryName: IncomeCategory.categoryNames[index],
          categoryIcon: IncomeCategory.categoryIcon[index],
          categoryColor: baseColors[_random.nextInt(baseColors.length)],
        );
      },
    );
  }
}
