import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:math';

// * Database packages
import 'package:moor_flutter/moor_flutter.dart';
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

//* Custom Widgets
import 'package:plutus/widgets/category.dart';

//* Data Classes
import 'package:plutus/data/expenseCat.dart';
import 'package:plutus/data/colorData.dart';

class NewExpenseScreen extends StatefulWidget {
  NewExpenseScreen({Key key}) : super(key: key);

  @override
  _NewExpenseScreenState createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  final _padding = EdgeInsets.all(16);
  final _random = new Random();

  final controllerTags = TextEditingController();
  final controllerAmount = TextEditingController();

  var categoryIcon = AntDesign.search1;
  var categoryText = 'Select a Category';
  var categoryIndex;

  @override
  Widget build(BuildContext context) {
    final expenseDao = Provider.of<ExpenseDao>(context);
    final accentColor = Theme.of(context).buttonColor;

    // * field for category. shows a dialog box
    final inputCategory = Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        // height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: accentColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).secondaryHeaderColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            highlightColor: Colors.pink[400],
            splashColor: Colors.pink,
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
                        title: Text(
                          'Warning',
                          style: Theme.of(context).textTheme.headline1,
                        ),
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
                expenseDao.addExpense(
                  ExpensesCompanion(
                    tags: Value(controllerTags.text),
                    amount: Value(double.parse(controllerAmount.text)),
                    date: Value(DateTime.now()),
                    categoryIndex: Value(categoryIndex),
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: Center(
              child: Text(
                'Submit',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );

    return ListView(
      children: [
        Text('Add New Expense', style: Theme.of(context).textTheme.bodyText1),
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
      labelStyle: TextStyle(color: Theme.of(context).buttonColor),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).buttonColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).buttonColor, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
    );
  }

  void showCategories() async {
    var width = MediaQuery.of(context).size.width;

    var result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        contentPadding: EdgeInsets.all(5),
        content: Builder(
          builder: (context) {
            return Container(
              height: 580,
              width: width - 50,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView.builder(
                itemCount: ExpenseCategory.categoryNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return Category(
                    index: index,
                    categoryName: ExpenseCategory.categoryNames[index],
                    categoryIcon: ExpenseCategory.categoryIcon[index],
                    categoryColor: ColorData
                        .myColors[_random.nextInt(ColorData.myColors.length)],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
    setState(() {
      if (result != null) {
        categoryIndex = result;
        categoryIcon = ExpenseCategory.categoryIcon[result];
        categoryText = ExpenseCategory.categoryNames[result];
      }
    });
  }
}
