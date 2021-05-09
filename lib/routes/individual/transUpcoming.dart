import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// * Database packages
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

// * Notifications Service
import 'package:plutus/services/notification.dart';

//* Data Classes
import 'package:plutus/data/expenseCat.dart';
import 'package:plutus/data/incomeCat.dart';

class TransactionUpcomingScreen extends StatefulWidget {
  final String transactionId;

  TransactionUpcomingScreen({Key key, this.transactionId}) : super(key: key);

  @override
  _TransactionUpcomingScreenState createState() =>
      _TransactionUpcomingScreenState();
}

class _TransactionUpcomingScreenState extends State<TransactionUpcomingScreen> {
  Upcoming transaction;

  @override
  Widget build(BuildContext context) {
    final upcomingDao = Provider.of<UpcomingDao>(context);

    return FutureBuilder(
      future: upcomingDao.getUpcoming(int.parse(widget.transactionId)),
      builder: (BuildContext context, AsyncSnapshot<Upcoming> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          transaction = snapshot.data;
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: _getPage(),
          );
        }
        return Container();
      },
    );
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
                  transaction.type == 'Income'
                      ? IncomeCategory.categoryIcon[transaction.categoryIndex]
                      : ExpenseCategory.categoryIcon[transaction.categoryIndex],
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
                          transaction.type == 'Income' ? 'Income' : 'Expense',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: 20),
                        Text(
                          transaction.type == 'Income'
                              ? IncomeCategory
                                  .categoryNames[transaction.categoryIndex]
                              : ExpenseCategory
                                  .categoryNames[transaction.categoryIndex],
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
                      'Are you sure want to mark this transaction as Completed?',
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

                          if (transaction.type == 'Income') {
                            profileDao.updateProfile(
                              ProfilesCompanion(
                                id: moor.Value(profile.id),
                                name: moor.Value(profile.name),
                                balance: moor.Value(
                                    profile.balance + transaction.amount),
                              ),
                            );
                            incomeDao.addIncome(
                              IncomesCompanion(
                                tags: moor.Value(transaction.tags),
                                amount: moor.Value(transaction.amount),
                                date: moor.Value(transaction.date),
                                categoryIndex:
                                    moor.Value(transaction.categoryIndex),
                              ),
                            );
                          } else {
                            profileDao.updateProfile(
                              ProfilesCompanion(
                                id: moor.Value(profile.id),
                                name: moor.Value(profile.name),
                                balance: moor.Value(
                                    profile.balance - transaction.amount),
                              ),
                            );
                            expenseDao.addExpense(
                              ExpensesCompanion(
                                tags: moor.Value(transaction.tags),
                                amount: moor.Value(transaction.amount),
                                date: moor.Value(transaction.date),
                                categoryIndex:
                                    moor.Value(transaction.categoryIndex),
                              ),
                            );
                          }
                          NotificationService().cancelNotification(transaction);
                          upcomingDao.deleteUpcoming(transaction);
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
            'Tags:',
            transaction.tags,
          ),
          _buttonWidget(
            'Amount:',
            '₹ ' + transaction.amount.toString(),
          ),
          _buttonWidget(
            'Date and Time:',
            DateFormat('d MMM yyyy, hh:mm a')
                .format(transaction.date)
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18),
                    ),
                    Text(
                      subText,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 15),
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
