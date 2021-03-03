import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plutus/data/moor_database.dart';

import 'package:plutus/routes/new_income.dart';

class IncomeRoute extends StatefulWidget {
  @override
  _IncomeRouteState createState() => _IncomeRouteState();
}

class _IncomeRouteState extends State<IncomeRoute> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          // * Navigator pops the old screen from stack
          onPressed: () => Navigator.pop(context)),
      title: Text(
        "Income",
        style: Theme.of(context).textTheme.headline5,
      ),
      backgroundColor: Colors.cyan,
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
        final incomes = snapshot.data ?? List();
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
  // todo: better design. maybe use slidable
  Widget _buildItem(BuildContext context, Income income, AppDatabase database) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        // height: 80,
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
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    Icons.ac_unit,
                    color: Theme.of(context).primaryIconTheme.color,
                    size: Theme.of(context).primaryIconTheme.size,
                  ),
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      income.tags,
                      style: Theme.of(context).textTheme.button,
                    ),
                    Text(
                      '₹ ' + income.amount.toString(),
                      style: Theme.of(context).textTheme.button,
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

  Widget _newIncomeBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // * opens new income screen
        // ! try to make it a backdrop
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewIncomeScreen()),
        );
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.green,
    );
  }
}

/*
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => database.deleteTask(itemTask),
        )
      ],
      child: CheckboxListTile(
        title: Text(itemTask.name),
        subtitle: Text(itemTask.dueDate?.toString() ?? 'No date'),
        value: itemTask.completed,
        onChanged: (newValue) {
          database.updateTask(itemTask.copyWith(completed: newValue));
        },
      ),
    );
  }*/
