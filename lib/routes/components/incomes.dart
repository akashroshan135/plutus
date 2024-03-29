import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

// * Database packages
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

//* Routes to other pages
import 'package:plutus/routes/individual/transaction.dart';

//* Custom Widgets
import 'package:plutus/widgets/edit/edit_income.dart';

//* Data Classes
import 'package:plutus/data/incomeCat.dart';

class IncomeRoute extends StatefulWidget {
  final DateTime selectedDate;

  const IncomeRoute({Key key, this.selectedDate}) : super(key: key);

  @override
  _IncomeRouteState createState() => _IncomeRouteState();
}

class _IncomeRouteState extends State<IncomeRoute> {
  @override
  Widget build(BuildContext context) {
    // * calling income database dao
    final incomeDao = Provider.of<IncomeDao>(context);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: incomeDao.watchDayIncome(widget.selectedDate),
      builder: (context, AsyncSnapshot<List<Income>> snapshot) {
        final incomes = snapshot.data ?? [];
        var list;

        if (incomes.isEmpty) {
          list = Container(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/mobile.png',
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'No Transactions Found',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                SizedBox(height: 75),
              ],
            ),
          );
        } else {
          list = ListView.builder(
            padding: EdgeInsets.all(0),
            primary: false,
            shrinkWrap: true,
            itemCount: incomes.length,
            itemBuilder: (_, index) {
              return _buildItem(incomes[index], incomeDao);
            },
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 8, left: 18),
              child: Text(
                'Income',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            list
          ],
        );
      },
    );
  }

  // * code to build one transaction item
  Widget _buildItem(Income income, IncomeDao incomeDao) {
    // * calling profile database dao
    final profileDao = Provider.of<ProfileDao>(context);
    var size = MediaQuery.of(context).size;

    return Dismissible(
      key: Key(income.toString()),
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
                      _showEditSceen(income);
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
            balance: moor.Value(profile.balance - income.amount),
          ),
        );
        incomeDao.deleteIncome(income);
        Fluttertoast.showToast(msg: 'Transaction has been deleted');
      },
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionScreen(
              transaction: income,
              isIncome: true,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 12, left: 18, right: 18, bottom: 12),
          child: Row(
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
                          IncomeCategory.categoryIcon[income.categoryIndex],
                          width: 35,
                          height: 35,
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
                          Flexible(
                            child: Text(
                              IncomeCategory
                                  .categoryNames[income.categoryIndex],
                              style: Theme.of(context).textTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              income.tags,
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
              Spacer(),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '+ \₹ ' + income.amount.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.green),
                    ),
                    Text(
                      DateFormat('hh:mm a').format(income.date).toString(),
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
  void _showEditSceen(Income income) async {
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
                    child: EditIncomeScreen(income: income),
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
