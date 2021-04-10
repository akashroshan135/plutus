import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

// * Database packages
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

//* Custom Widgets
import 'package:plutus/widgets/new_expense.dart';

//* Data Classes
import 'package:plutus/data/expenseCat.dart';

class ExpenseRoute extends StatefulWidget {
  final DateTime selectedDate;

  const ExpenseRoute({Key key, this.selectedDate}) : super(key: key);

  @override
  _ExpenseRouteState createState() => _ExpenseRouteState();
}

class _ExpenseRouteState extends State<ExpenseRoute> {
  @override
  Widget build(BuildContext context) {
    // * calling database
    final expenseDao = Provider.of<ExpenseDao>(context);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: expenseDao.watchDayExpense(widget.selectedDate),
      builder: (context, AsyncSnapshot<List<Expense>> snapshot) {
        final expenses = snapshot.data ?? [];
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: expenses.length,
                  itemBuilder: (_, index) {
                    return _buildItem(context, expenses[index], expenseDao);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // * code to build one transaction item
  Widget _buildItem(
      BuildContext context, Expense expense, ExpenseDao expenseDao) {
    var size = MediaQuery.of(context).size;

    final editBtn = IconSlideAction(
      caption: 'Edit',
      color: Colors.grey[400],
      icon: Icons.edit,
      onTap: () => print('updates'),
    );

    final deleteBtn = IconSlideAction(
      caption: 'Delete',
      color: Colors.red,
      icon: Icons.delete,
      onTap: () {
        return showDialog(
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
                    expenseDao.deleteExpense(expense);
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
      },
    );

    return Column(
      children: [
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.20,
          secondaryActions: <Widget>[
            editBtn,
            deleteBtn,
          ],
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
              //             ExpenseCategory.categoryIcon[expense.categoryIndex],
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
                          ExpenseCategory.categoryIcon[expense.categoryIndex],
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
                            ExpenseCategory
                                .categoryNames[expense.categoryIndex],
                            style: Theme.of(context).textTheme.bodyText1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            expense.tags,
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
                      '- ₹' + expense.amount.toString() + ' ',
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
        Padding(
          padding: EdgeInsets.only(left: 65, top: 8),
          child: Divider(thickness: 0.8),
        ),
      ],
    );
  }

  // TODO implement whatever this is
  void showDetailsSceen() async {
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
                    child: NewExpenseScreen(),
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
