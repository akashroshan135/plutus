import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plutus/data/moor_database.dart';

class IncomeRoute extends StatefulWidget {
  @override
  _IncomeRouteState createState() => _IncomeRouteState();
}

class _IncomeRouteState extends State<IncomeRoute> {
  @override
  Widget build(BuildContext context) {
    // * calling database
    final database = Provider.of<AppDatabase>(context);

    // * StreamBuilder used to build list of all objects
    // ! needs an app reload to show new data. Need to check
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
                Center(
                  child: Text(
                    income.tags,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                Center(
                  child: Text(
                    income.amount.toString(),
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
