import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

// * Database packages
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

//* Custom Widgets
import 'package:plutus/widgets/stat/bar_graph.dart';
import 'package:plutus/widgets/stat/pie_chart.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int activeMonth = 5;
  DateTime selectedMonth = DateTime.now();
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
      stream: expenseDao.watchMonthExpense(selectedMonth),
      builder: (context, AsyncSnapshot<List<Expense>> snapshot) {
        expenses = snapshot.data ?? [];
        return _watchDataIncome();
      },
    );
  }

  Widget _watchDataIncome() {
    // * calling expense database dao
    final incomeDao = Provider.of<IncomeDao>(context, listen: false);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: incomeDao.watchMonthIncome(selectedMonth),
      builder: (context, AsyncSnapshot<List<Income>> snapshot) {
        income = snapshot.data ?? [];
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: _getPage(),
        );
      },
    );
  }

  Widget _getPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _getHeader(),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            child: PageView.builder(
              itemCount: selectedMonth.month == 2 ? 4 : 5,
              onPageChanged: (int index) {
                setState(() {
                  _index = index;
                });
              },
              itemBuilder: (_, i) {
                return Transform.scale(
                  scale: i == _index ? 1 : 0.9,
                  child: Card(
                    // elevation: 6,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: MediaQuery.of(context).size.width,
                      child: BarGraphScreen(
                        selectedMonth: selectedMonth,
                        transExpense: expenses,
                        transIncome: income,
                        mainText: labelText[i],
                        startDate: (i * 7) + 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          PieChartScreen(
            selectedMonth: selectedMonth,
            transaction: expenses,
            isIncome: false,
          ),
          PieChartScreen(
            selectedMonth: selectedMonth,
            transaction: income,
            isIncome: true,
          ),
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
                  'Statistics',
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
          onTap: () {
            setState(() {
              activeMonth = index;
              selectedMonth = month.dateTime;
              // _index = 0;
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
}
