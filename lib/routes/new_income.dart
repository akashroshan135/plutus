import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart';

import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

const _padding = EdgeInsets.all(16.0);

class NewIncomeScreen extends StatefulWidget {
  NewIncomeScreen({Key key}) : super(key: key);

  @override
  _NewIncomeScreenState createState() => _NewIncomeScreenState();
}

class _NewIncomeScreenState extends State<NewIncomeScreen> {
  final accentColor = Colors.cyan;
  final controllerTags = TextEditingController();
  final controllerAmount = TextEditingController();
  DateTime newIncomeDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    final appBar = AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          // * Navigator pops the old screen from stack
          onPressed: () => Navigator.pop(context)),
      title: Text(
        "New Income",
        style: Theme.of(context).textTheme.headline5,
      ),
      backgroundColor: accentColor,
    );

    // * input field for tags
    final inputTags = Padding(
      padding: _padding,
      child: TextField(
        controller: controllerTags,
        // keyboardType: TextInputType.number,
        cursorColor: accentColor,
        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 35),
        decoration: decoratorInputWidget('Tags'),
      ),
    );

    // * input field for amount
    final inputAmt = Padding(
      padding: _padding,
      child: TextField(
        controller: controllerAmount,
        keyboardType: TextInputType.number,
        cursorColor: accentColor,
        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 35),
        decoration: decoratorInputWidget('Amount'),
      ),
    );

    // * submit button. Submits data to db and goes to previous page
    final submit = Padding(
      padding: EdgeInsets.only(top: 16, left: 100, right: 100, bottom: 50),
      child: Container(
        height: 50,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: accentColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            highlightColor: Colors.pink[400],
            splashColor: Colors.pink,
            onTap: () {
              print(controllerTags.text);
              print(controllerAmount.text);
              database.addIncome(
                IncomesCompanion(
                  tags: Value(controllerTags.text),
                  amount: Value(double.parse(controllerAmount.text)),
                  date: Value(newIncomeDate),
                ),
              );
              Navigator.pop(context);
            },
            child: Center(
              child: Text('Submit',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 30)),
            ),
          ),
        ),
      ),
    );

    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: appBar,
        body: Container(
          // height: MediaQuery.of(context).size.height,
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: _padding,
          child: ListView(
            children: [
              inputTags,
              inputAmt,
              submit,
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration decoratorInputWidget(String text) {
    return InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: accentColor),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accentColor, width: 1)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accentColor, width: 1)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 1)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 1)),
    );
  }
}
