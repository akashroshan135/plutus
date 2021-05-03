import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

// * Database packages
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

// * Notifications Packages
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//* Custom Widgets
import 'package:plutus/widgets/edit_income.dart';

//* Data Classes
import 'package:plutus/data/incomeCat.dart';

class IncomeRoute extends StatefulWidget {
  final DateTime selectedDate;

  const IncomeRoute({Key key, this.selectedDate}) : super(key: key);

  @override
  _IncomeRouteState createState() => _IncomeRouteState();
}

class _IncomeRouteState extends State<IncomeRoute> {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    // * calling database
    final incomeDao = Provider.of<IncomeDao>(context);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: incomeDao.watchDayIncome(widget.selectedDate),
      builder: (context, AsyncSnapshot<List<Income>> snapshot) {
        final incomes = snapshot.data ?? [];
        if (incomes.isEmpty) {
          // TODO make good empty page
          return Container(
            child: Center(
              child: Text(
                'No Incomes',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 8, left: 18),
                child: Text(
                  'Income',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: incomes.length,
                itemBuilder: (_, index) {
                  return _buildItem(context, incomes[index], incomeDao);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _cancelNotification() async {
    await notificationsPlugin.cancel(0);
  }

  // * code to build one transaction item
  Widget _buildItem(BuildContext context, Income income, IncomeDao incomeDao) {
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
                  'Are you sure want to delete this item?',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'CANCEL',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      'OK',
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
                  'Are you sure want to edit this item?',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'CANCEL',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _showEditSceen(income);
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
      },
      onDismissed: (direction) {
        incomeDao.deleteIncome(income);
        // _cancelNotification();
      },
      child: Container(
        padding: EdgeInsets.only(top: 12, left: 18, right: 18, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container(
            //   child: Center(
            //     child: Container(
            //       width: 50,
            //       height: 50,
            //       child: Neumorphic(
            //         style: NeumorphicStyle(
            //             shape: NeumorphicShape.concave,
            //             boxShape: NeumorphicBoxShape.circle(),
            //             depth: 3,
            //             intensity: 0.4,
            //             lightSource: LightSource.bottom,
            //             color: Theme.of(context).iconTheme.color),
            //         child: Center(
            //           child: NeumorphicIcon(
            //             IncomeCategory.categoryIcon[income.categoryIndex],
            //             style: NeumorphicStyle(
            //               shape: NeumorphicShape.flat,
            //               depth: 5,
            //               intensity: 0.6,
            //               lightSource: LightSource.top,
            //               color: Theme.of(context).primaryIconTheme.color,
            //             ),
            //             size: Theme.of(context).primaryIconTheme.size,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              // height: 80,
              width: (size.width - 40) * 0.7,
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
                      child: Icon(
                        IncomeCategory.categoryIcon[income.categoryIndex],
                        color: Theme.of(context).iconTheme.color,
                        size: Theme.of(context).iconTheme.size,
                      ),
                      // child: Image.asset(
                      //   'assets/images/bank.png',
                      //   width: 30,
                      //   height: 30,
                      // ),
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
                          IncomeCategory.categoryNames[income.categoryIndex],
                          style: Theme.of(context).textTheme.bodyText1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          income.tags,
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
                    '+ ₹' + income.amount.toString() + ' ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.green),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(Icons.edit),
            Text(
              ' Edit',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  // * adds background data for sliding from left to right
  Widget _slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete),
            Text(
              ' Delete',
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
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
