import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

// * Database packages
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

//* Custom Widgets
import 'package:plutus/widgets/stat/bar_graph.dart';
import 'package:plutus/widgets/stat/pie_chart.dart';

class StatsDetailsPage extends StatefulWidget {
  final DateTime selectedMonth;

  StatsDetailsPage({Key key, this.selectedMonth}) : super(key: key);

  @override
  _StatsDetailsPageState createState() => _StatsDetailsPageState();
}

class _StatsDetailsPageState extends State<StatsDetailsPage> {
  List expenses;
  List income;
  int _index = 0;

  List labelText = [
    'First Week',
    'Second Week',
    'Third Week',
    'Fourth Week',
    'Fifth Week',
  ];

  @override
  Widget build(BuildContext context) {
    // * calling expense database dao
    final expenseDao = Provider.of<ExpenseDao>(context);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: expenseDao.watchMonthExpense(widget.selectedMonth),
      builder: (context, AsyncSnapshot<List<Expense>> snapshot) {
        expenses = snapshot.data ?? [];
        return _watchDataIncome();
      },
    );
  }

  Widget _watchDataIncome() {
    // * calling income database dao
    final incomeDao = Provider.of<IncomeDao>(context, listen: false);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: incomeDao.watchMonthIncome(widget.selectedMonth),
      builder: (context, AsyncSnapshot<List<Income>> snapshot) {
        income = snapshot.data ?? [];
        return _getPage();
      },
    );
  }

  Widget _getPage() {
    return Column(
      children: [
        Container(
          height: 310,
          child: PageView.builder(
            itemCount: widget.selectedMonth.month == 2 ? 4 : 5,
            onPageChanged: (int index) {
              setState(() {
                _index = index;
              });
            },
            itemBuilder: (_, i) {
              return Transform.scale(
                scale: i == _index ? 1 : 0.9,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: MediaQuery.of(context).size.width,
                  child: BarGraphScreen(
                    selectedMonth: widget.selectedMonth,
                    transExpense: expenses,
                    transIncome: income,
                    mainText: labelText[i],
                    startDate: (i * 7) + 1,
                  ),
                ),
              );
            },
          ),
        ),
        DotsIndicator(
          dotsCount: widget.selectedMonth.month == 2 ? 4 : 5,
          position: widget.selectedMonth.month == 2 && _index == 4
              ? 3
              : _index.toDouble(),
          decorator: DotsDecorator(
            spacing: const EdgeInsets.all(10.0),
          ),
        ),
        PieChartScreen(
          selectedMonth: widget.selectedMonth,
          transaction: expenses,
          isIncome: false,
        ),
        PieChartScreen(
          selectedMonth: widget.selectedMonth,
          transaction: income,
          isIncome: true,
        ),
        SizedBox(height: 60),
      ],
    );
  }
}
