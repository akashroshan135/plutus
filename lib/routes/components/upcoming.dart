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

class UpcomingRoute extends StatefulWidget {
  final DateTime selectedDate;

  UpcomingRoute({Key key, this.selectedDate}) : super(key: key);

  @override
  _UpcomingRouteState createState() => _UpcomingRouteState();
}

class _UpcomingRouteState extends State<UpcomingRoute> {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    // * calling expense database dao
    final upcomingDao = Provider.of<UpcomingDao>(context);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: upcomingDao.watchDayUpcoming(widget.selectedDate),
      builder: (context, AsyncSnapshot<List<Upcoming>> snapshot) {
        final upcoming = snapshot.data ?? [];
        if (upcoming.isEmpty) {
          return Container();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 8, left: 18),
              child: Text(
                'Upcoming',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.all(0),
              primary: false,
              shrinkWrap: true,
              itemCount: upcoming.length,
              itemBuilder: (_, index) {
                return _buildItem(upcoming[index], upcomingDao);
              },
            ),
          ],
        );
      },
    );
  }

  Future _cancelNotification(Upcoming upcoming) async {
    await notificationsPlugin.cancel(upcoming.id);
  }

  // * code to build one transaction item
  Widget _buildItem(Upcoming upcoming, UpcomingDao upcomingDao) {
    // * calling profile database dao
    final profileDao = Provider.of<ProfileDao>(context);
    final incomeDao = Provider.of<IncomeDao>(context);
    final expenseDao = Provider.of<ExpenseDao>(context);

    var size = MediaQuery.of(context).size;
    var isIncome;

    if (upcoming.type == 'Income')
      isIncome = true;
    else
      isIncome = false;

    return Dismissible(
      key: Key(upcoming.toString()),
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
                balance: moor.Value(profile.balance + upcoming.amount),
              ),
            );
            incomeDao.addIncome(
              IncomesCompanion(
                tags: moor.Value(upcoming.tags),
                amount: moor.Value(upcoming.amount),
                date: moor.Value(upcoming.date),
                categoryIndex: moor.Value(upcoming.categoryIndex),
              ),
            );
          } else {
            profileDao.updateProfile(
              ProfilesCompanion(
                id: moor.Value(profile.id),
                name: moor.Value(profile.name),
                balance: moor.Value(profile.balance - upcoming.amount),
              ),
            );
            expenseDao.addExpense(
              ExpensesCompanion(
                tags: moor.Value(upcoming.tags),
                amount: moor.Value(upcoming.amount),
                date: moor.Value(upcoming.date),
                categoryIndex: moor.Value(upcoming.categoryIndex),
              ),
            );
          }
        }
        _cancelNotification(upcoming);
        upcomingDao.deleteUpcoming(upcoming);
      },
      child: Container(
        padding: EdgeInsets.only(top: 12, left: 18, right: 18, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
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
                    width: (size.width - 90) * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isIncome ? 'Income' : 'Expense',
                          style: Theme.of(context).textTheme.bodyText1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              isIncome
                                  ? IncomeCategory.categoryNames[
                                          upcoming.categoryIndex] +
                                      ' : '
                                  : ExpenseCategory.categoryNames[
                                          upcoming.categoryIndex] +
                                      ' : ',
                              style: Theme.of(context).textTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Flexible(
                              child: Text(
                                upcoming.tags,
                                style: Theme.of(context).textTheme.bodyText2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 5),
                        Text(
                          DateFormat('hh:mm a')
                              .format(upcoming.date)
                              .toString(),
                          style: Theme.of(context).textTheme.bodyText2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: (size.width - 40) * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    upcoming.amount.toString() + ' ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
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
