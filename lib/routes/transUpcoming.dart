import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// * Database packages
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

// * Notifications Packages
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//* Data Classes
import 'package:plutus/data/expenseCat.dart';
import 'package:plutus/data/incomeCat.dart';

class TransactionUpcomingScreen extends StatefulWidget {
  final transUpcoming;

  TransactionUpcomingScreen({Key key, this.transUpcoming}) : super(key: key);

  @override
  _TransactionUpcomingScreenState createState() =>
      _TransactionUpcomingScreenState();
}

class _TransactionUpcomingScreenState extends State<TransactionUpcomingScreen> {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool isIncome;

  @override
  void initState() {
    super.initState();
    if (widget.transUpcoming.type == 'Income')
      isIncome = true;
    else
      isIncome = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getPage(),
    );
  }

  Future _cancelNotification(Upcoming upcoming) async {
    await notificationsPlugin.cancel(upcoming.id);
  }

  Widget _getPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _getHeader(),
          _getBody(),
        ],
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
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Icon(Icons.arrow_back),
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(width: 25),
                Text(
                  'Upcoming Transaction Details',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  isIncome
                      ? IncomeCategory
                          .categoryIcon[widget.transUpcoming.categoryIndex]
                      : ExpenseCategory
                          .categoryIcon[widget.transUpcoming.categoryIndex],
                  height: MediaQuery.of(context).size.height / 4.5,
                  width: MediaQuery.of(context).size.width / 2,
                ),
                Flexible(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isIncome ? 'Income' : 'Expense',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: 20),
                        Text(
                          isIncome
                              ? IncomeCategory.categoryNames[
                                  widget.transUpcoming.categoryIndex]
                              : ExpenseCategory.categoryNames[
                                  widget.transUpcoming.categoryIndex],
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBody() {
    final upcomingDao = Provider.of<UpcomingDao>(context);
    final profileDao = Provider.of<ProfileDao>(context);
    final incomeDao = Provider.of<IncomeDao>(context);
    final expenseDao = Provider.of<ExpenseDao>(context);

    final submit = Padding(
      padding: EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 50),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).primaryColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            // highlightColor: isIncome ? Colors.green[700] : Colors.red,
            // splashColor: isIncome ? Colors.green[700] : Colors.red,
            onTap: () async {
              return await showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text(
                      'Alert',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    content: Text(
                      'Are you sure want to mark this transUpcoming as Completed?',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'No',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final profiles = await profileDao.getAllProfile();
                          final profile = profiles[0];

                          if (isIncome) {
                            profileDao.updateProfile(
                              ProfilesCompanion(
                                id: moor.Value(profile.id),
                                name: moor.Value(profile.name),
                                balance: moor.Value(profile.balance +
                                    widget.transUpcoming.amount),
                              ),
                            );
                            incomeDao.addIncome(
                              IncomesCompanion(
                                tags: moor.Value(widget.transUpcoming.tags),
                                amount: moor.Value(widget.transUpcoming.amount),
                                date: moor.Value(widget.transUpcoming.date),
                                categoryIndex: moor.Value(
                                    widget.transUpcoming.categoryIndex),
                              ),
                            );
                          } else {
                            profileDao.updateProfile(
                              ProfilesCompanion(
                                id: moor.Value(profile.id),
                                name: moor.Value(profile.name),
                                balance: moor.Value(profile.balance -
                                    widget.transUpcoming.amount),
                              ),
                            );
                            expenseDao.addExpense(
                              ExpensesCompanion(
                                tags: moor.Value(widget.transUpcoming.tags),
                                amount: moor.Value(widget.transUpcoming.amount),
                                date: moor.Value(widget.transUpcoming.date),
                                categoryIndex: moor.Value(
                                    widget.transUpcoming.categoryIndex),
                              ),
                            );
                          }
                          _cancelNotification(widget.transUpcoming);
                          upcomingDao.deleteUpcoming(widget.transUpcoming);
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
            },
            child: Center(
              child: Text(
                'Mark as Completed',
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

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: ListView(
        primary: false,
        shrinkWrap: true,
        children: [
          _buttonWidget(
            'Tags',
            widget.transUpcoming.tags,
          ),
          _buttonWidget(
            'Amount',
            widget.transUpcoming.amount.toString(),
          ),
          _buttonWidget(
            'Date and Time',
            DateFormat('d MMM yyyy, hh:mm a')
                .format(widget.transUpcoming.date)
                .toString(),
          ),
          SizedBox(height: 30),
          submit,
        ],
      ),
    );
  }

  Widget _buttonWidget(mainText, subText) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        height: 80,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).secondaryHeaderColor,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mainText,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      subText,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
