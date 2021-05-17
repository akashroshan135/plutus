import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// * Database packages
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

//* Notification Service
import 'package:plutus/services/notification.dart';

//* Routes to other pages
import 'package:plutus/routes/individual/transPending.dart';

//* Data Classes
import 'package:plutus/data/expenseCat.dart';
import 'package:plutus/data/incomeCat.dart';

class AllPendingRoute extends StatefulWidget {
  AllPendingRoute({Key key}) : super(key: key);

  @override
  _AllPendingRouteState createState() => _AllPendingRouteState();
}

class _AllPendingRouteState extends State<AllPendingRoute> {
  @override
  Widget build(BuildContext context) {
    // * calling expense database dao
    final pendingDao = Provider.of<PendingDao>(context);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: pendingDao.watchAllPending(),
      builder: (context, AsyncSnapshot<List<Pending>> snapshot) {
        final pending = snapshot.data ?? [];
        var list;

        if (pending.isEmpty) {
          list = Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/mobile.png',
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'No Transactions Found',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
              ],
            ),
          );
        } else {
          list = ListView.builder(
            padding: EdgeInsets.all(0),
            primary: false,
            shrinkWrap: true,
            itemCount: pending.length,
            itemBuilder: (_, index) {
              return _buildItem(pending[index], pendingDao);
            },
          );
        }
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getHeader(),
                list,
              ],
            ),
          ),
        );
      },
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
                  'All Pending Transactions',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // * code to build one transaction item
  Widget _buildItem(Pending pending, PendingDao pendingDao) {
    // * calling profile database dao
    final profileDao = Provider.of<ProfileDao>(context);
    final incomeDao = Provider.of<IncomeDao>(context);
    final expenseDao = Provider.of<ExpenseDao>(context);

    var size = MediaQuery.of(context).size;
    var isIncome;

    if (pending.type == 'Income')
      isIncome = true;
    else
      isIncome = false;

    return Dismissible(
      key: Key(pending.toString()),
      background: _slideRightBackground(),
      secondaryBackground: _slideLeftBackground(),
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
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
                  'Are you sure want to delete this transaction?',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'No',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      'Yes',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              );
            },
          );
        } else {
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
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'No',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
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
      },
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final profiles = await profileDao.getAllProfile();
          final profile = profiles[0];

          if (isIncome) {
            profileDao.updateProfile(
              ProfilesCompanion(
                id: moor.Value(profile.id),
                name: moor.Value(profile.name),
                balance: moor.Value(profile.balance + pending.amount),
              ),
            );
            incomeDao.addIncome(
              IncomesCompanion(
                tags: moor.Value(pending.tags),
                amount: moor.Value(pending.amount),
                date: moor.Value(pending.date),
                categoryIndex: moor.Value(pending.categoryIndex),
              ),
            );
          } else {
            profileDao.updateProfile(
              ProfilesCompanion(
                id: moor.Value(profile.id),
                name: moor.Value(profile.name),
                balance: moor.Value(profile.balance - pending.amount),
              ),
            );
            expenseDao.addExpense(
              ExpensesCompanion(
                tags: moor.Value(pending.tags),
                amount: moor.Value(pending.amount),
                date: moor.Value(pending.date),
                categoryIndex: moor.Value(pending.categoryIndex),
              ),
            );
          }
        }
        NotificationService().cancelNotification(pending);
        pendingDao.deletePending(pending);
      },
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionPendingScreen(
              transactionId: pending.id.toString(),
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 12, left: 18, right: 18, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Image.asset(
                          isIncome
                              ? 'assets/images/income.png'
                              : 'assets/images/expense.png',
                          width: 45,
                          height: 45,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Container(
                      height: 50,
                      width: size.width / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isIncome
                                ? 'Income : ' +
                                    IncomeCategory
                                        .categoryNames[pending.categoryIndex]
                                : 'Expense : ' +
                                    ExpenseCategory
                                        .categoryNames[pending.categoryIndex],
                            style: Theme.of(context).textTheme.bodyText1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Flexible(
                            child: Text(
                              pending.tags,
                              style: Theme.of(context).textTheme.bodyText2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\₹ ' + pending.amount.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.grey),
                    ),
                    Text(
                      DateFormat('hh:mm a').format(pending.date).toString(),
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // * adds background data for sliding from right to left
  Widget _slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 20),
            Icon(Icons.check),
            Text(
              ' Mark as Completed',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  // * adds background data for sliding from left to right
  Widget _slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete),
            Text(
              ' Delete',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.right,
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
