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
    return _buildIncomeList(context);
  }

  StreamBuilder<List<Income>> _buildIncomeList(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
    print('here');

    return StreamBuilder(
      stream: database.watchAllIncome(),
      builder: (context, AsyncSnapshot<List<Income>> snapshot) {
        final transactions = snapshot.data ?? List();
        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (_, index) {
            final itemtransaction = transactions[index];
            return _buildItem(context, itemtransaction, database);
          },
        );
      },
    );
  }

  Widget _buildItem(
      BuildContext context, Income itemtransaction, AppDatabase database) {
    print(itemtransaction.tags);
    print('here2');
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        //height: 80,
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
                    itemtransaction.tags,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                Center(
                  child: Text(
                    itemtransaction.amount.toString(),
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
