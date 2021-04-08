import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moor_flutter/moor_flutter.dart';

import 'package:plutus/routes/categoryPage.dart';
import 'package:plutus/data/moor_database.dart';
import 'package:plutus/data/incomeCat.dart';

const _padding = EdgeInsets.all(16.0);

class NewIncomeScreen extends StatefulWidget {
  final accentColor;

  NewIncomeScreen({Key key, @required this.accentColor}) : super(key: key);

  @override
  _NewIncomeScreenState createState() => _NewIncomeScreenState();
}

class _NewIncomeScreenState extends State<NewIncomeScreen> {
  var accentColor;
  final controllerTags = TextEditingController();
  final controllerAmount = TextEditingController();
  DateTime newIncomeDate = DateTime.now();
  var categoryIcon = Icons.search;
  var categoryText = 'Select a Category';
  var categoryIndex;

  @override
  void initState() {
    super.initState();
    accentColor = widget.accentColor;
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    // * field for category. shows a dialog box
    final inputCategory = Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        // height: 80,
        decoration: BoxDecoration(
            border: Border.all(color: accentColor),
            borderRadius: BorderRadius.circular(15)),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).secondaryHeaderColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            highlightColor: Colors.pink[400],
            splashColor: Colors.pink,
            // todo: add option to change category
            onTap: () {
              showCategories();
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: _padding,
                  child: Icon(
                    categoryIcon,
                    color: Theme.of(context).primaryIconTheme.color,
                    size: Theme.of(context).primaryIconTheme.size,
                  ),
                ),
                Text(
                  categoryText,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: accentColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // * input field for tags
    final inputTags = Padding(
      padding: _padding,
      child: TextField(
        controller: controllerTags,
        // keyboardType: TextInputType.number,
        cursorColor: accentColor,
        style: Theme.of(context).textTheme.bodyText2,
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
        style: Theme.of(context).textTheme.bodyText2,
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
              if (controllerTags.text == '' ||
                  controllerAmount.text == '' ||
                  categoryIndex == null) {
                return showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text('Warning',
                            style: Theme.of(context).textTheme.button),
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        content: Text(
                          'Please enter all the fields',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      );
                    });
              } else {
                database.addIncome(
                  IncomesCompanion(
                    tags: Value(controllerTags.text),
                    amount: Value(double.parse(controllerAmount.text)),
                    date: Value(newIncomeDate),
                    categoryIndex: Value(categoryIndex),
                  ),
                );
              }
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

    return ListView(
      children: [
        inputCategory,
        inputTags,
        inputAmt,
        submit,
      ],
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

  void showCategories() async {
    var result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        contentPadding: EdgeInsets.all(5.0),
        content: Builder(
          builder: (context) {
            var width = MediaQuery.of(context).size.width;
            return Container(
              height: 580,
              width: width - 50,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: CategoryPage(),
            );
          },
        ),
      ),
    );
    setState(() {
      if (result != null) {
        categoryIndex = result;
        categoryIcon = IncomeCategory.categoryIcon[result];
        categoryText = IncomeCategory.categoryNames[result];
      }
    });
  }
}
