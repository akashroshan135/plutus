import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarGraphScreen extends StatefulWidget {
  final DateTime selectedMonth;
  final List transExpense;
  final List transIncome;
  final String mainText;
  final int startDate;

  BarGraphScreen({
    Key key,
    this.selectedMonth,
    this.transExpense,
    this.transIncome,
    this.mainText,
    this.startDate,
  }) : super(key: key);

  @override
  _BarGraphScreenState createState() => _BarGraphScreenState();
}

class _BarGraphScreenState extends State<BarGraphScreen> {
  List transIncome;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                widget.mainText +
                    ' of ' +
                    DateFormat('MMMM').format(widget.selectedMonth).toString(),
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 200,
              child: BarGraphWidget(
                seriesList: _getData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<charts.Series<PerDayTransactions, String>> _getData() {
    List<PerDayTransactions> incomeData = [];
    List<PerDayTransactions> expenseData = [];
    int endDate = widget.startDate + 7;

    if (widget.startDate == 29) {
      endDate = new DateTime(
              widget.selectedMonth.year, widget.selectedMonth.month + 1, 0)
          .day;
    }

    for (var i = widget.startDate; i < endDate; i++) {
      double amount = 0;
      if (widget.transExpense != null) {
        for (var item in widget.transExpense) {
          if (item.date.day == i) amount = amount + item.amount;
        }
      }
      expenseData.add(
        PerDayTransactions(
          i.toString() + '/' + widget.selectedMonth.month.toString(),
          amount,
        ),
      );
    }
    for (var i = widget.startDate; i < endDate; i++) {
      double amount = 0;
      if (widget.transIncome != null) {
        for (var item in widget.transIncome) {
          if (item.date.day == i) amount = amount + item.amount;
        }
      }
      incomeData.add(
        PerDayTransactions(
          i.toString() + '/' + widget.selectedMonth.month.toString(),
          amount,
        ),
      );
    }

    return [
      charts.Series<PerDayTransactions, String>(
        id: 'expense',
        domainFn: (PerDayTransactions transaction, _) => transaction.date,
        measureFn: (PerDayTransactions transaction, _) => transaction.amount,
        data: expenseData,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xffe32012)),
        displayName: 'Expense',
      ),
      charts.Series<PerDayTransactions, String>(
        id: 'income',
        domainFn: (PerDayTransactions transaction, _) => transaction.date,
        measureFn: (PerDayTransactions transaction, _) => transaction.amount,
        data: incomeData,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.green),
        displayName: 'Income',
      )
    ];
  }
}

class BarGraphWidget extends StatelessWidget {
  final List<charts.Series> seriesList;

  const BarGraphWidget({Key key, this.seriesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
      barGroupingType: charts.BarGroupingType.groupedStacked,
      defaultRenderer: charts.BarRendererConfig(
        cornerStrategy: charts.ConstCornerStrategy(50),
        strokeWidthPx: 5,
      ),
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            fontSize: 13,
            color: charts.ColorUtil.fromDartColor(
                Theme.of(context).textTheme.bodyText1.color),
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredMinTickCount: 6,
          desiredMaxTickCount: 10,
        ),
        renderSpec: new charts.GridlineRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            fontSize: 13,
            color: charts.ColorUtil.fromDartColor(
                Theme.of(context).textTheme.bodyText1.color),
          ),
        ),
      ),
      secondaryMeasureAxis: null,
      selectionModels: [
        charts.SelectionModelConfig(
          changedListener: (charts.SelectionModel model) {
            if (model.hasDatumSelection)
              print(
                model.selectedSeries[0].measureFn(model.selectedDatum[0].index),
              );
          },
        )
      ],
    );
  }
}

class PerDayTransactions {
  final String date;
  final double amount;
  PerDayTransactions(this.date, this.amount);
}
