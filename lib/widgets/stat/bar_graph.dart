import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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
  double interval;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
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
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width - 70,
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: _getData(),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: true,
                      interval: interval == 0 ? 100 : interval,
                      getTextStyles: (value) =>
                          Theme.of(context).textTheme.bodyText2,
                    ),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) =>
                          Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  gridData: FlGridData(
                    checkToShowHorizontalLine: (value) => value % interval == 0,
                  ),
                  borderData: FlBorderData(
                    border:
                        Border.all(color: Theme.of(context).iconTheme.color),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getData() {
    List<PerDayTransactions> incomeData = [];
    List<PerDayTransactions> expenseData = [];
    int endDate = widget.startDate + 7;
    double max = 0;

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
      max = max < amount ? amount : max;
      expenseData.add(PerDayTransactions(i.toString(), amount));
    }
    for (var i = widget.startDate; i < endDate; i++) {
      double amount = 0;
      if (widget.transIncome != null) {
        for (var item in widget.transIncome) {
          if (item.date.day == i) amount = amount + item.amount;
        }
      }
      max = max < amount ? amount : max;
      incomeData.add(PerDayTransactions(i.toString(), amount));
    }

    List<BarChartGroupData> data = [];
    int j = 0;
    for (var i = widget.startDate; i < endDate; i++) {
      data.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: expenseData[j].amount,
              colors: [Color(0xffe32012)],
              width: 15,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
            ),
            BarChartRodData(
              y: incomeData[j].amount,
              colors: [Colors.green],
              width: 15,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
                bottomLeft: Radius.zero,
                bottomRight: Radius.zero,
              ),
            )
          ],
        ),
      );
      j++;
    }

    interval = (((max / 5) / 50).floor() * 50).toDouble();
    return data;
  }
}

class PerDayTransactions {
  final String date;
  final double amount;
  PerDayTransactions(this.date, this.amount);
}
