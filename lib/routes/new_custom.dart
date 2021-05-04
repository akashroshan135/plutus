import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// * Database packages
import 'package:moor_flutter/moor_flutter.dart' as moor;
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

class CustomScreen extends StatefulWidget {
  CustomScreen({Key key}) : super(key: key);

  @override
  _CustomScreenState createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
  final _padding = EdgeInsets.all(16);

  bool isIncome = false;
  final accentExpense = Color(0xffe32012);
  final accentIncome = Colors.green;

  var categoryIcon = 'assets/images/search.png';
  var categoryText = 'Select a Category';
  var categoryIndex;

  final controllerTags = TextEditingController();
  final controllerAmount = TextEditingController();
  final controllerDate = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isDateChanged = false;

  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  double xAlign;
  Color toggleColor;

  // * code to initialize notification plugin and current date & time
  @override
  void initState() {
    super.initState();
    var androidInit = AndroidInitializationSettings('app_icon');
    var initSettings = InitializationSettings(android: androidInit);
    notificationsPlugin.initialize(
      initSettings,
      onSelectNotification: _selectNotification,
    );
    _configureLocalTimeZone();
    controllerDate.text =
        DateFormat('d MMM yyyy, hh:mm a').format(selectedDate).toString();
    xAlign = -1;
    toggleColor = accentExpense;
  }

  // * code to configure and set timezone
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
  }

  // * code that gets executed when the notification is pressed
  // TODO implement some use for this
  Future _selectNotification(String payload) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _getHeader(),
            _getBody(),
          ],
        ),
      ),
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
        padding: EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 30),
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
              'New Custom Transaction',
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBody() {
    // * calling profile, income and expense database dao
    final profileDao = Provider.of<ProfileDao>(context);
    final incomeDao = Provider.of<IncomeDao>(context);
    final expenseDao = Provider.of<ExpenseDao>(context);

    // * field for category. shows a dialog box
    final inputCategory = Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        // height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: isIncome ? accentIncome : accentExpense),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              if (isIncome)
                _showCategoriesIncome();
              else
                _showCategoriesExpense();
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
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
                      .copyWith(color: isIncome ? accentIncome : accentExpense),
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
        cursorColor: isIncome ? accentIncome : accentExpense,
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
        cursorColor: isIncome ? accentIncome : accentExpense,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: _decoratorInputWidget('Amount'),
      ),
    );

    // * input field for date and time
    final dateTimePicker = InkWell(
      onTap: () {
        _selectDate(context);
      },
      child: Padding(
        padding: _padding,
        child: TextField(
          controller: controllerDate,
          enabled: false,
          cursorColor: isIncome ? accentIncome : accentExpense,
          style: isDateChanged
              ? Theme.of(context).textTheme.bodyText1
              : Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: isIncome ? accentIncome : accentExpense),
          decoration: _decoratorInputWidget('Date and Time'),
        ),
      ),
    );

    // * submit button. Submits data to db and goes to previous page
    final submit = Padding(
      padding: EdgeInsets.only(top: 16, left: 100, right: 100, bottom: 50),
      child: Container(
        height: 50,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: isIncome ? accentIncome : accentExpense,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            highlightColor: isIncome ? Colors.green[700] : Colors.red,
            splashColor: isIncome ? Colors.green[700] : Colors.red,
            onTap: () async {
              if (controllerTags.text == '' ||
                  controllerAmount.text == '' ||
                  categoryIndex == null) {
                return _getWarning();
              } else {
                double amount = double.parse(controllerAmount.text);
                if (amount > 1000000) {
                  return _getEasterEgg();
                } else {
                  final profiles = await profileDao.getAllProfile();
                  final profile = profiles[0];
                  if (isIncome) {
                    profileDao.updateProfile(
                      ProfilesCompanion(
                        id: moor.Value(profile.id),
                        name: moor.Value(profile.name),
                        balance: moor.Value(profile.balance + amount),
                      ),
                    );
                    incomeDao.addIncome(
                      IncomesCompanion(
                        tags: moor.Value(controllerTags.text),
                        amount: moor.Value(amount),
                        date: moor.Value(selectedDate),
                        categoryIndex: moor.Value(categoryIndex),
                      ),
                    );
                  } else {
                    profileDao.updateProfile(
                      ProfilesCompanion(
                        id: moor.Value(profile.id),
                        name: moor.Value(profile.name),
                        balance: moor.Value(profile.balance - amount),
                      ),
                    );
                    expenseDao.addExpense(
                      ExpensesCompanion(
                        tags: moor.Value(controllerTags.text),
                        amount: moor.Value(amount),
                        date: moor.Value(selectedDate),
                        categoryIndex: moor.Value(categoryIndex),
                      ),
                    );
                  }
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

    final toggle = Padding(
      padding: EdgeInsets.only(top: 25, bottom: 15),
      child: Center(
        child: Container(
          width: 225,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                alignment: Alignment(xAlign, 0),
                duration: Duration(milliseconds: 300),
                child: Container(
                  width: 200 * 0.5,
                  height: 50,
                  decoration: BoxDecoration(
                    color: toggleColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    xAlign = -1;
                    toggleColor = accentExpense;
                    isIncome = false;
                    categoryIcon = 'assets/images/search.png';
                    categoryText = 'Select a Category';
                    categoryIndex = null;
                  });
                },
                child: Align(
                  alignment: Alignment(-1, 0),
                  child: Container(
                    width: 200 * 0.5,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      'Expense',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    xAlign = 1;
                    toggleColor = accentIncome;
                    isIncome = true;
                    categoryIcon = 'assets/images/search.png';
                    categoryText = 'Select a Category';
                    categoryIndex = null;
                  });
                },
                child: Align(
                  alignment: Alignment(1, 0),
                  child: Container(
                    width: 200 * 0.5,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      'Income',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return ListView(
      primary: false,
      shrinkWrap: true,
      children: [
        toggle,
        inputCategory,
        inputTags,
        inputAmt,
        dateTimePicker,
        submit,
      ],
    );
  }

  InputDecoration _decoratorInputWidget(String text) {
    return InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: isIncome ? accentIncome : accentExpense),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isIncome ? accentIncome : accentExpense, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isIncome ? accentIncome : accentExpense, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isIncome ? accentIncome : accentExpense, width: 1),
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

  void _showCategoriesIncome() async {
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
                    categoryColor: Colors.green,
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

  void _showCategoriesExpense() async {
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
                itemCount: ExpenseCategory.categoryNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return Category(
                    index: index,
                    categoryName: ExpenseCategory.categoryNames[index],
                    categoryIcon: ExpenseCategory.categoryIcon[index],
                    categoryColor: Colors.red,
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      isDateChanged = true;
      _selectTime(context);
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null)
      setState(() {
        selectedDate = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, selectedTime.hour, selectedTime.minute);
        controllerDate.text =
            DateFormat('d MMM yyyy, hh:mm a').format(selectedDate).toString();
      });
  }

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

  Future _getFuture() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Upcoming Transaction',
            style: Theme.of(context).textTheme.headline1,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Text(
            'This is an upcoming transaction. Would you like to keep a reminder on the specified date?',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            TextButton(
              onPressed: () {
                // _setNotification();
              },
              child: Text(
                'Yes',
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
