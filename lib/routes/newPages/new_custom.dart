import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

// * Database packages
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

// *  Notification Service
import 'package:plutus/services/notification.dart';

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

  double xAlign;
  Color toggleColor;

  // * code to initialize notification plugin and current date & time
  @override
  void initState() {
    super.initState();
    controllerDate.text =
        DateFormat('d MMM yyyy, hh:mm a').format(selectedDate).toString();
    xAlign = -1;
    toggleColor = accentExpense;
  }

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
              onTap: () => Navigator.pop(context),
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
    // * calling profile, income, expense and pending database dao
    final profileDao = Provider.of<ProfileDao>(context);
    final incomeDao = Provider.of<IncomeDao>(context);
    final expenseDao = Provider.of<ExpenseDao>(context);
    final pendingDao = Provider.of<PendingDao>(context);

    // * field for category. shows a dialog box
    final inputCategory = Padding(
      padding: EdgeInsets.all(8),
      child: Container(
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
    final inputTags = Padding(
      padding: _padding,
      child: TextField(
        controller: controllerTags,
        cursorColor: isIncome ? accentIncome : accentExpense,
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
        cursorColor: isIncome ? accentIncome : accentExpense,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: _decoratorInputWidget('Amount'),
      ),
    );

    // * input field for date and time
    final dateTimePicker = InkWell(
      onTap: () {
        _selectDate(context);
        FocusScopeNode currentFocus = FocusScope.of(context);
        currentFocus.unfocus();
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
                return _getWarning('Please enter all the fields');
              } else {
                double amount;
                try {
                  amount = double.parse(controllerAmount.text);
                  if (amount > 100000) {
                    return _getEasterEgg();
                  } else {
                    if (selectedDate.compareTo(DateTime.now()) == 1) {
                      int id = await pendingDao.addPending(
                        PendingsCompanion(
                          tags: moor.Value(controllerTags.text),
                          amount: moor.Value(amount),
                          date: moor.Value(selectedDate),
                          categoryIndex: moor.Value(categoryIndex),
                          type: moor.Value(isIncome ? 'Income' : 'Expense'),
                        ),
                      );
                      var transaction = Transaction(
                          id: id,
                          tags: controllerTags.text,
                          amount: amount,
                          selectedDate: selectedDate,
                          categoryIndex: categoryIndex,
                          type: isIncome ? 'Income' : 'Expense');
                      return _getFuture(transaction);
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
                        if (amount > profile.balance) {
                          return _getWarning(
                              'You do not have enough balance to perform this transaction');
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
                          Fluttertoast.showToast(
                              msg: 'Transaction has been added');
                          Navigator.pop(context);
                        }
                      }
                    }
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

    return Column(
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
      counterStyle:
          TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
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
          color: isIncome ? accentIncome : accentExpense,
          width: 1,
        ),
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
        categoryIcon = ExpenseCategory.categoryIcon[result];
        categoryText = ExpenseCategory.categoryNames[result];
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

  Future _getFuture(Transaction transaction) {
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
                Fluttertoast.showToast(
                    msg: 'Pending Transaction has been added');
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            TextButton(
              onPressed: () {
                Fluttertoast.showToast(
                    msg: 'Pending Transaction has been added');
                NotificationService().setNotification(transaction);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
}

class Transaction {
  final int id;
  final String tags;
  final double amount;
  final DateTime selectedDate;
  final categoryIndex;
  final String type;

  Transaction({
    @required this.id,
    @required this.tags,
    @required this.amount,
    @required this.selectedDate,
    @required this.categoryIndex,
    @required this.type,
  });
}
