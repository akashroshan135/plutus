import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:math';

// * Database packages
import 'package:moor_flutter/moor_flutter.dart';
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

// * Notifications Packages
// ! timezone latest_all.dart is used as latest.dart doesn't work on emulator
// TODO use latest.dart in export builds
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//* Custom Widgets
import 'package:plutus/widgets/category.dart';

//* Data Classes
import 'package:plutus/data/expenseCat.dart';
import 'package:plutus/data/incomeCat.dart';
import 'package:plutus/data/colorData.dart';

class UpcomingScreen extends StatefulWidget {
  UpcomingScreen({Key key}) : super(key: key);

  @override
  _UpcomingScreenState createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  final _padding = EdgeInsets.all(16);
  final _random = new Random();

  final controllerTags = TextEditingController();
  final controllerAmount = TextEditingController();

  var categoryIcon = AntDesign.search1;
  var categoryText = 'Select a Category';
  var categoryIndex;

  final accentExpense = Color(0xffe32012);
  final accentIncome = Colors.green;

  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  // * code to initialize notification plugin
  @override
  void initState() {
    super.initState();
    var androidInit = AndroidInitializationSettings('app_icon');
    var initSettings = InitializationSettings(android: androidInit);
    notificationsPlugin.initialize(
      initSettings,
      onSelectNotification: selectNotification,
    );
    _configureLocalTimeZone();
  }

  // * code to configure and set timezone
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
  }

  // * code that gets executed when the notification is pressed
  // TODO implement some use for this
  Future selectNotification(String payload) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getPage(),
    );
  }

  Widget _getPage() {
    return ListView(
      children: [
        _getHeader(),
        // TODO button that switches between income and expense
        _getBodyIncome(),
        // _getBodyExpense(),
      ],
    );
  }

  Widget _getHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 10,
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 30),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Icon(Icons.arrow_back),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 25),
            Text(
              'New Upcoming Transaction',
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ),
    );
  }

/* --------------------------------------------------------------
  Income
-------------------------------------------------------------- */
  Widget _getBodyIncome() {
    final incomeDao = Provider.of<IncomeDao>(context);

    // * field for category. shows a dialog box
    final inputCategory = Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        // height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: accentIncome),
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
              showCategoriesIncome();
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    categoryIcon,
                    color: accentIncome,
                    size: Theme.of(context).primaryIconTheme.size,
                  ),
                ),
                Text(
                  categoryText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: accentIncome),
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
        cursorColor: accentIncome,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: decoratorInputWidgetIncome('Tags'),
      ),
    );

    // * input field for amount
    final inputAmt = Padding(
      padding: _padding,
      child: TextField(
        controller: controllerAmount,
        keyboardType: TextInputType.number,
        cursorColor: accentIncome,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: decoratorInputWidgetIncome('Amount'),
      ),
    );

    // * submit button. Submits data to db and goes to previous page
    final submit = Padding(
      padding: EdgeInsets.only(top: 16, left: 100, right: 100, bottom: 50),
      child: Container(
        height: 50,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: accentIncome,
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
                  incomeDao.addIncome(
                    IncomesCompanion(
                      tags: Value(controllerTags.text),
                      amount: Value(amount),
                      date: Value(DateTime.now()),
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
      shrinkWrap: true,
      children: [
        Center(
          child: Text(
            'Add New Income',
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: accentIncome),
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

  InputDecoration decoratorInputWidgetIncome(String text) {
    return InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: accentIncome),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: accentIncome, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: accentIncome, width: 1),
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

  void showCategoriesIncome() async {
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

/* --------------------------------------------------------------
  Expense
-------------------------------------------------------------- */
  Widget _getBodyExpense() {
    final expenseDao = Provider.of<ExpenseDao>(context);

    // * field for category. shows a dialog box
    final inputCategory = Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        // height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: accentExpense),
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
              showCategoriesExpense();
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: _padding,
                  child: Icon(
                    categoryIcon,
                    color: accentExpense,
                    size: Theme.of(context).primaryIconTheme.size,
                  ),
                ),
                Text(
                  categoryText,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: accentExpense),
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
        cursorColor: accentExpense,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: decoratorInputWidgetExpense('Tags'),
      ),
    );

    // * input field for amount
    final inputAmt = Padding(
      padding: _padding,
      child: TextField(
        controller: controllerAmount,
        keyboardType: TextInputType.number,
        cursorColor: accentExpense,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: decoratorInputWidgetExpense('Amount'),
      ),
    );

    // * submit button. Submits data to db and goes to previous page
    final submit = Padding(
      padding: EdgeInsets.only(top: 16, left: 100, right: 100, bottom: 50),
      child: Container(
        height: 50,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: accentExpense,
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
                  expenseDao.addExpense(
                    ExpensesCompanion(
                      tags: Value(controllerTags.text),
                      amount: Value(amount),
                      date: Value(DateTime.now()),
                      categoryIndex: Value(categoryIndex),
                    ),
                  );
                  _setNotification(controllerTags.text, amount);
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
      shrinkWrap: true,
      children: [
        Center(
          child: Text(
            'Add New Expense',
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: accentExpense),
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

  InputDecoration decoratorInputWidgetExpense(String text) {
    return InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: accentExpense),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: accentExpense, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: accentExpense, width: 1),
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

  void showCategoriesExpense() async {
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
        categoryIcon = IncomeCategory.categoryIcon[result];
        categoryText = IncomeCategory.categoryNames[result];
      }
    });
  }

/* --------------------------------------------------------------
  Common stuff
-------------------------------------------------------------- */
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

  // * creates a new notification instance
  Future _setNotification(String text, double amount) async {
    final androidDetails = new AndroidNotificationDetails(
      '1',
      'Plutus',
      'Upcoming Transactions',
      importance: Importance.max,
    );
    final notificationDetails =
        new NotificationDetails(android: androidDetails);
    // TODO set date dynamically
    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 10));

    await notificationsPlugin.zonedSchedule(
      0,
      text,
      amount.toString(),
      scheduledDate,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}