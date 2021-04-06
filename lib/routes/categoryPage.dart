import 'package:flutter/material.dart';
import 'package:plutus/widgets/category.dart';

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

    // test data. will be replaced later
    const categoryIcon = [
      Icons.timeline,
      Icons.landscape,
      Icons.add_outlined,
      Icons.add_outlined,
      Icons.access_time,
      Icons.sd_storage,
      Icons.electrical_services,
      Icons.monetization_on,
    ];

    const categoryNames = <String>[
      'Length',
      'Area',
      'Volume',
      'Mass',
      'Time',
      'Digital Storage',
      'Energy',
      'Currency',
    ];

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
      itemCount: categoryNames.length,
      itemBuilder: (BuildContext context, int index) {
        return Category(
          categoryName: categoryNames[index],
          categoryIcon: categoryIcon[index],
          categoryColor: baseColors[index],
        );
      },
    );
  }
}
