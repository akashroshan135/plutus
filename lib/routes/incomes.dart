import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'package:plutus/data/moor_database.dart';
import 'package:plutus/widgets/new_income.dart';
import 'package:plutus/data/incomeCat.dart';

const _padding = EdgeInsets.all(16.0);

class IncomeRoute extends StatefulWidget {
  @override
  _IncomeRouteState createState() => _IncomeRouteState();
}

class _IncomeRouteState extends State<IncomeRoute> {
  final accentColor = Colors.cyan;

  @override
  Widget build(BuildContext context) {
    // * code for appbar
    final appBar = AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          // * Navigator pops the old screen from stack
          onPressed: () => Navigator.pop(context)),
      title: Text(
        "Income",
        style: Theme.of(context).textTheme.headline5,
      ),
      backgroundColor: accentColor,
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).backgroundColor,
      body: _buildList(context),
      floatingActionButton: _newIncomeBtn(context),
    );
  }

  Widget _buildList(BuildContext context) {
    // * calling database
    final database = Provider.of<AppDatabase>(context);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: database.watchAllIncome(),
      builder: (context, AsyncSnapshot<List<Income>> snapshot) {
        final incomes = snapshot.data ?? [];
        return ListView.builder(
          itemCount: incomes.length,
          itemBuilder: (_, index) {
            final income = incomes[index];
            return _buildItem(context, income, database);
          },
        );
      },
    );
  }

  // * one item widget
  // todo: add functionality to edit button
  // todo: improve design
  Widget _buildItem(BuildContext context, Income income, AppDatabase database) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.grey[400],
          icon: Icons.edit,
          onTap: () => print('updates'),
        ),
        IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              return showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text('Alert',
                        style: Theme.of(context).textTheme.button),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    content: Text(
                      'Are you sure want to delete this item?',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'CANCEL',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            database.deleteIncome(income);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'OK',
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
                    ],
                  );
                },
              );
            }),
      ],
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          height: 90,
          child: Material(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).secondaryHeaderColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              highlightColor: Colors.pink[400],
              splashColor: Colors.pink,
              onTap: () {},
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: _padding,
                    child: Icon(
                      IncomeCategory.categoryIcon[income.categoryIndex],
                      color: Theme.of(context).primaryIconTheme.color,
                      size: Theme.of(context).primaryIconTheme.size,
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: Column(
                      children: <Widget>[
                        Text(IncomeCategory.categoryNames[income.categoryIndex],
                            style: Theme.of(context).textTheme.button),
                        Spacer(),
                        Text(
                          'Tags: ' + income.tags,
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: _padding,
                    child: Text(
                      '₹ ' + income.amount.toString(),
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _newIncomeBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showNewIncomeSceen();
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.green,
    );
  }

  // * opens new income screen as a sliding sheet
  void showNewIncomeSceen() async {
    final result = await showSlidingBottomSheet(context, builder: (context) {
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
                  padding: _padding,
                  child: NewIncomeScreen(accentColor: accentColor),
                ),
              ),
            ),
          );
        },
      );
    });
    print(result); // This is the result.
  }
}
