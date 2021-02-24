import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';

import 'package:plutus/data/moor_database.dart';

const _padding = EdgeInsets.all(16.0);

class NewIncomeScreen extends StatefulWidget {
  NewIncomeScreen({Key key}) : super(key: key);

  @override
  _NewIncomeScreenState createState() => _NewIncomeScreenState();
}

class _NewIncomeScreenState extends State<NewIncomeScreen> {
  final categoryColor = Colors.cyan;
  DateTime newTaskDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          // * Navigator pops the old screen from stack
          onPressed: () => Navigator.pop(context)),
      title: Text(
        "New Income",
        style: Theme.of(context).textTheme.headline5,
      ),
      backgroundColor: categoryColor,
    );

    final input = Padding(
      padding: _padding,
      child: TextField(
        keyboardType: TextInputType.number,
        cursorColor: categoryColor,
        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 35),
        decoration: InputDecoration(
          labelText: 'Input',
          labelStyle: TextStyle(color: categoryColor),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: categoryColor, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: categoryColor, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 1)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red, width: 1)),
        ),
        onSubmitted: (inputdata) {
          print('done');
          setState(
            () {
              AppDatabase().addIncome(
                IncomesCompanion(
                  tags: Value('test'),
                  amount: Value(double.parse(inputdata)),
                  date: Value(newTaskDate),
                ),
              );
            },
          );
          // resetValuesAfterSubmit();
        },
        //onChanged: _updateInputValue,
      ),
    );

    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: appBar,
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: _padding,
          child: ListView(
            children: [
              input,
            ],
          ),
        ),
      ),
    );
  }
}
