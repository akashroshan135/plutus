import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// * Database packages
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

//* Data Classes
import 'package:plutus/data/expenseCat.dart';
import 'package:plutus/data/incomeCat.dart';

import 'package:plutus/widgets/bar_graph.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int activeMonth = 5;
  DateTime selectedMonth = DateTime.now();
  List expenses;
  List income;

  Future _getDatai() async {
    final incomeDao = Provider.of<IncomeDao>(context, listen: false);
    income = await incomeDao.getMonthIncome(selectedMonth);
  }

  Future _getDatae() async {
    final expenseDao = Provider.of<ExpenseDao>(context, listen: false);
    expenses = await expenseDao.getMonthExpense(selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getPage(),
    );
  }

  Widget _getPage() {
    // print(expenses);
    Future.wait([_getDatae(), _getDatai()]).then((value) {});
    return SingleChildScrollView(
      child: Column(
        children: [
          _getHeader(),
          BarGraphScreen(
            selectedMonth: selectedMonth,
            transExpense: expenses,
            transIncome: income,
          ),
          _getPieExpense(),
        ],
      ),
    );
  }

  // * header consists of date list
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monthly Statistics',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _monthItem(),
            ),
          ],
        ),
      ),
    );
  }

  List<GestureDetector> _monthItem() {
    return List.generate(
      6,
      (index) {
        var month = Jiffy().subtract(months: 5);
        return GestureDetector(
          onTap: () async {
            setState(() {
              activeMonth = index;
              selectedMonth = month.dateTime;
            });
          },
          child: Container(
            width: (MediaQuery.of(context).size.width - 40) / 6,
            child: Column(
              children: [
                Text(
                  month.add(months: index).format('yyyy'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: 10),
                Container(
                  width: 45,
                  height: 35,
                  decoration: BoxDecoration(
                    color: activeMonth == index
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      month.format('MMM'),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getPieExpense() {
    final expenseDao = Provider.of<ExpenseDao>(context);

    return Padding(
      // padding: EdgeInsets.all(16),
      padding: EdgeInsets.only(bottom: 16, right: 16, left: 16),
      child: Container(
        width: double.infinity,
        // height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expenses for the first week",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\₹1000.00",
                      style: Theme.of(context).textTheme.headline2,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                // padding: EdgeInsets.only(top: 55),
                // width: (MediaQuery.of(context).size.width - 40),
                height: 240,
                child: DonutAutoLabelChart(
                  seriesList: _createSampleData2(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static List<charts.Series<PerDayExpense, int>> _createSampleData2() {
    final data = [
      new PerDayExpense(1, 100),
      new PerDayExpense(2, 75),
      new PerDayExpense(3, 25),
      new PerDayExpense(4, 5),
    ];

    return [
      new charts.Series<PerDayExpense, int>(
        id: 'Sales',
        domainFn: (PerDayExpense day, _) => day.categoryIndex,
        measureFn: (PerDayExpense day, _) => day.amount,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (PerDayExpense row, _) =>
            '${ExpenseCategory.categoryNames[row.categoryIndex]}: \₹${row.amount}',
      )
    ];
  }
}

class DonutAutoLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  const DonutAutoLabelChart({Key key, this.seriesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: true,
      defaultRenderer: new charts.ArcRendererConfig(
        arcWidth: 60,
        arcRendererDecorators: [
          new charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.outside,
            leaderLineColor: charts.ColorUtil.fromDartColor(
                Theme.of(context).textTheme.bodyText1.color),
            outsideLabelStyleSpec: charts.TextStyleSpec(
              fontSize: 13,
              color: charts.ColorUtil.fromDartColor(
                  Theme.of(context).textTheme.bodyText1.color),
            ),
          )
        ],
      ),
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection)
            print(
              model.selectedSeries[0].domainFn(model.selectedDatum[0].index),
            );
        })
      ],
    );
  }
}

class PerDayTransactions {
  final String date;
  final int amount;
  PerDayTransactions(this.date, this.amount);
}

class PerDayExpense {
  final int categoryIndex;
  final int amount;
  PerDayExpense(this.categoryIndex, this.amount);
}

class PerDayIncome {
  final int categoryIndex;
  final int amount;
  PerDayIncome(this.categoryIndex, this.amount);
}
