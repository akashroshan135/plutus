import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// * Database packages
import 'package:moor_flutter/moor_flutter.dart';
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

//* Custom Widgets
import 'package:plutus/widgets/category.dart';

//* Data Classes
import 'package:plutus/data/incomeCat.dart';

class NewIncomeScreen extends StatefulWidget {
  NewIncomeScreen({Key key}) : super(key: key);

  @override
  _NewIncomeScreenState createState() => _NewIncomeScreenState();
}

class _NewIncomeScreenState extends State<NewIncomeScreen> {
  final _padding = EdgeInsets.all(16);

  final controllerTags = TextEditingController();
  final controllerAmount = TextEditingController();

  var categoryIcon = 'assets/images/search.png';
  var categoryText = 'Select a Category';
  var categoryIndex;

  final accentColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return _getBody();
  }

  Widget _getBody() {
    // * calling profile and income database dao
    final profileDao = Provider.of<ProfileDao>(context);
    final incomeDao = Provider.of<IncomeDao>(context);

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
          color: Theme.of(context).scaffoldBackgroundColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => _showCategories(),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: _padding,
                  child: Image.asset(
                    categoryIcon,
                    height: 30,
                    width: 30,
                  ),
                ),
                Text(
                  categoryText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
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
        maxLength: 50,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: _decoratorInputWidget('Tags'),
      ),
    );

    // * input field for amount
    final inputAmt = Padding(
      padding: _padding,
      child: TextField(
        controller: controllerAmount,
        keyboardType: TextInputType.number,
        cursorColor: accentColor,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: _decoratorInputWidget('Amount'),
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
            highlightColor: Colors.green[700],
            splashColor: Colors.green[700],
            onTap: () async {
              if (controllerTags.text == '' ||
                  controllerAmount.text == '' ||
                  categoryIndex == null) {
                return _getWarning('Please enter all the fields');
              } else {
                double amount;
                try {
                  amount = double.parse(controllerAmount.text);
                  if (amount > 100000) {
                    return _getEasterEgg();
                  } else {
                    final profiles = await profileDao.getAllProfile();
                    final profile = profiles[0];

                    profileDao.updateProfile(
                      ProfilesCompanion(
                        id: Value(profile.id),
                        name: Value(profile.name),
                        balance: Value(profile.balance + amount),
                      ),
                    );
                    incomeDao.addIncome(
                      IncomesCompanion(
                        tags: Value(controllerTags.text),
                        amount: Value(amount),
                        date: Value(DateTime.now()),
                        categoryIndex: Value(categoryIndex),
                      ),
                    );
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: 'Income Transaction Added');
                  }
                } on FormatException catch (_) {
                  return _getWarning('Please enter number data for amount');
                }
              }
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
        Center(
          child: Text(
            'Add New Income',
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: accentColor),
          ),
        ),
        SizedBox(height: 10),
        inputCategory,
        inputTags,
        inputAmt,
        submit,
      ],
    );
  }

  InputDecoration _decoratorInputWidget(String text) {
    return InputDecoration(
      labelText: text,
      counterStyle:
          TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
      labelStyle: TextStyle(color: accentColor),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: accentColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: accentColor, width: 1),
      ),
    );
  }

  // * renders the categories list
  void _showCategories() async {
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
                primary: false,
                shrinkWrap: true,
                itemCount: IncomeCategory.categoryNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return Category(
                    index: index,
                    categoryName: IncomeCategory.categoryNames[index],
                    categoryIcon: IncomeCategory.categoryIcon[index],
                    categoryColor: accentColor,
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
        categoryIcon = IncomeCategory.categoryIcon[result];
        categoryText = IncomeCategory.categoryNames[result];
      }
    });
  }

  // * renders a warning dialog box
  Future _getWarning(String text) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Warning',
            style: Theme.of(context).textTheme.headline1,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        );
      },
    );
  }

  // * renders an easter egg
  Future _getEasterEgg() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Get an Accountant',
            style: Theme.of(context).textTheme.headline1,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Text(
            'If you\'re dealing with so much money then you need an accountant, not an app',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        );
      },
    );
  }
}
