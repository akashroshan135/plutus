import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:intl/intl.dart';

// * Database packages
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

//* Custom Widgets
import 'package:plutus/widgets/edit/edit_expense.dart';

//* Data Classes
import 'package:plutus/data/expenseCat.dart';

class AllExpenseRoute extends StatefulWidget {
  AllExpenseRoute({Key key}) : super(key: key);

  @override
  _AllExpenseRouteState createState() => _AllExpenseRouteState();
}

class _AllExpenseRouteState extends State<AllExpenseRoute> {
  @override
  Widget build(BuildContext context) {
    // * calling expense database dao
    final expenseDao = Provider.of<ExpenseDao>(context);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: expenseDao.watchAllExpense(),
      builder: (context, AsyncSnapshot<List<Expense>> snapshot) {
        final expenses = snapshot.data ?? [];
        var list;

        if (expenses.isEmpty) {
          // TODO make good empty page
          list = Center(
            child: Text(
              'Nothing here',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        } else {
          list = ListView.builder(
            padding: EdgeInsets.all(0),
            primary: false,
            shrinkWrap: true,
            itemCount: expenses.length,
            itemBuilder: (_, index) {
              return _buildItem(expenses[index], expenseDao);
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
                  'All Expenses Transactions',
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
  Widget _buildItem(Expense expense, ExpenseDao expenseDao) {
    // * calling profile database dao
    final profileDao = Provider.of<ProfileDao>(context);

    var size = MediaQuery.of(context).size;

    return Dismissible(
      key: Key(expense.toString()),
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
                  'Are you sure want to edit this transaction?',
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
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _showEditSceen(expense);
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
      },
      onDismissed: (direction) async {
        final profiles = await profileDao.getAllProfile();
        final profile = profiles[0];

        profileDao.updateProfile(
          ProfilesCompanion(
            id: moor.Value(profile.id),
            name: moor.Value(profile.name),
            balance: moor.Value(profile.balance + expense.amount),
          ),
        );
        expenseDao.deleteExpense(expense);
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
                        ExpenseCategory.categoryIcon[expense.categoryIndex],
                        width: 35,
                        height: 35,
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
                        Row(
                          children: [
                            Text(
                              ExpenseCategory
                                      .categoryNames[expense.categoryIndex] +
                                  ' : ',
                              style: Theme.of(context).textTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Flexible(
                              child: Text(
                                expense.tags,
                                style: Theme.of(context).textTheme.bodyText2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          DateFormat('d MMM yyyy, hh:mm a')
                              .format(expense.date)
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
                    '- \₹' + expense.amount.toString() + ' ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.red),
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
            Icon(Icons.edit),
            Text(
              ' Edit',
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

  // * renders the edit screen
  void _showEditSceen(Expense expense) async {
    return await showSlidingBottomSheet(
      context,
      builder: (context) {
        return SlidingSheetDialog(
          elevation: 10,
          cornerRadius: 16,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [0.58, 0.7, 1.0],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          builder: (context, state) {
            return Container(
              height: 500,
              child: Center(
                child: Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: EditExpenseScreen(expense: expense),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
