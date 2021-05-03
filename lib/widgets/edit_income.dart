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
import 'package:plutus/data/incomeCat.dart';
import 'package:plutus/data/colorData.dart';

class EditIncomeScreen extends StatefulWidget {
  final Income income;

  EditIncomeScreen({Key key, @required this.income}) : super(key: key);

  @override
  _EditIncomeScreenState createState() => _EditIncomeScreenState();
}

class _EditIncomeScreenState extends State<EditIncomeScreen> {
  final _padding = EdgeInsets.all(16);
  final _random = new Random();

  final controllerTags = TextEditingController();
  final controllerAmount = TextEditingController();

  var categoryIcon = AntDesign.search1;
  var categoryText = 'Select a Category';
  var categoryIndex;

  final accentColor = Colors.green;

  @override
  void initState() {
    super.initState();
    controllerTags.text = widget.income.tags;
    controllerAmount.text = widget.income.amount.toString();
    categoryIndex = widget.income.categoryIndex;
    categoryIcon = IncomeCategory.categoryIcon[categoryIndex];
    categoryText = IncomeCategory.categoryNames[categoryIndex];
  }

  @override
  Widget build(BuildContext context) {
    return _getProfileDao();
  }

  // * gets the profile data from the database
  Widget _getProfileDao() {
    // * calling database
    final profileDao = Provider.of<ProfileDao>(context);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: profileDao.watchAllProfile(),
      builder: (context, AsyncSnapshot<List<Profile>> snapshot) {
        final profile = snapshot.data ?? [];
        return ListView.builder(
          itemCount: profile.length,
          itemBuilder: (_, index) {
            return _getIncomeDao(context, profileDao, profile[0]);
          },
        );
      },
    );
  }

  Widget _getIncomeDao(
      BuildContext context, ProfileDao profileDao, Profile profile) {
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
            highlightColor: Colors.pink[400],
            splashColor: Colors.pink,
            onTap: () {
              _showCategories();
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: _padding,
                  child: Icon(
                    categoryIcon,
                    color: accentColor,
                    size: Theme.of(context).primaryIconTheme.size,
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
    // TODO add character limit
    final inputTags = Padding(
      padding: _padding,
      child: TextField(
        controller: controllerTags,
        cursorColor: accentColor,
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
            highlightColor: Colors.pink[400],
            splashColor: Colors.pink,
            onTap: () {
              if (controllerTags.text == '' ||
                  controllerAmount.text == '' ||
                  categoryIndex == null) {
                return _getWarning();
              } else {
                double amount = double.parse(controllerAmount.text);
                if (amount > 1000000) {
                  return _getEasterEgg();
                } else {
                  profileDao.updateProfile(
                    ProfilesCompanion(
                      id: Value(profile.id),
                      name: Value(profile.name),
                      balance: Value(
                          (profile.balance - widget.income.amount) + amount),
                    ),
                  );
                  incomeDao.updateIncome(
                    IncomesCompanion(
                      id: Value(widget.income.id),
                      tags: Value(controllerTags.text),
                      amount: Value(amount),
                      date: Value(widget.income.date),
                      categoryIndex: Value(categoryIndex),
                    ),
                  );
                }
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
      primary: false,
      shrinkWrap: true,
      children: [
        Center(
          child: Text(
            'Edit Income',
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
      labelStyle: TextStyle(color: accentColor),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: accentColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: accentColor, width: 1),
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
                itemCount: IncomeCategory.categoryNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return Category(
                    index: index,
                    categoryName: IncomeCategory.categoryNames[index],
                    categoryIcon: IncomeCategory.categoryIcon[index],
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
        categoryIcon = IncomeCategory.categoryIcon[result];
        categoryText = IncomeCategory.categoryNames[result];
      }
    });
  }

  // * renders a warning dialog box
  Future _getWarning() {
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
      },
    );
  }
}
