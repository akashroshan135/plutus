import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';

// * Data Classes
import 'package:plutus/data/expenseCat.dart';
import 'package:plutus/data/incomeCat.dart';

List myColors = <Color>[
  Colors.teal,
  Colors.orange,
  Colors.pinkAccent,
  Colors.blueAccent,
  Colors.yellow,
  Colors.greenAccent,
  Colors.purpleAccent,
  Colors.teal,
  Colors.orange,
  Colors.pinkAccent,
  Colors.blueAccent,
  Colors.cyan,
  Colors.greenAccent,
  Colors.purpleAccent,
  Colors.teal,
  Colors.orange,
  Colors.pinkAccent,
  Colors.blueAccent,
  Colors.yellow,
  Colors.greenAccent,
  Colors.purpleAccent,
  Colors.teal,
  Colors.orange,
  Colors.pinkAccent,
  Colors.blueAccent,
  Colors.yellow,
  Colors.greenAccent,
  Colors.purpleAccent,
];

class PieChartScreen extends StatefulWidget {
  final DateTime selectedMonth;
  final List transaction;
  final bool isIncome;

  PieChartScreen({
    Key key,
    this.selectedMonth,
    this.transaction,
    this.isIncome,
  }) : super(key: key);

  @override
  _PieChartScreenState createState() => _PieChartScreenState();
}

class _PieChartScreenState extends State<PieChartScreen> {
  int touchedIndex;

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
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  widget.isIncome
                      ? 'Income Breakdown of ' +
                          DateFormat('MMMM')
                              .format(widget.selectedMonth)
                              .toString()
                      : 'Expense Breakdown of ' +
                          DateFormat('MMMM')
                              .format(widget.selectedMonth)
                              .toString(),
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              SizedBox(height: 15),
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (pieTouchResponse) {
                        setState(() {
                          final desiredTouch = pieTouchResponse.touchInput
                                  is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;
                          if (desiredTouch &&
                              pieTouchResponse.touchedSection != null) {
                            touchedIndex = pieTouchResponse
                                .touchedSection.touchedSectionIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 30,
                    sections: showingSections(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    List<Data> data = [];
    double totalAmount = 0;
    int len = widget.isIncome
        ? IncomeCategory.categoryNames.length
        : ExpenseCategory.categoryNames.length;

    if (widget.transaction.isNotEmpty) {
      for (var item in widget.transaction) {
        totalAmount = totalAmount + item.amount;
      }
      for (var i = 0; i < len; i++) {
        double amount = 0;
        for (var item in widget.transaction) {
          if (item.categoryIndex == i) amount = amount + item.amount;
        }
        if (amount != 0) {
          data.add(
            new Data(
              name: widget.isIncome
                  ? IncomeCategory.categoryNames[i]
                  : ExpenseCategory.categoryNames[i],
              percent: (amount / totalAmount) * 100,
              icon: widget.isIncome
                  ? IncomeCategory.categoryIcon[i]
                  : ExpenseCategory.categoryIcon[i],
              color: myColors[i],
            ),
          );
        }
      }
    } else {
      data.add(
        new Data(
          name: widget.isIncome ? 'No Income' : 'No Expenses',
          percent: 100,
          icon: widget.isIncome
              ? 'assets/images/income.png'
              : 'assets/images/expense.png',
          color: widget.isIncome ? Colors.green : Colors.red,
        ),
      );
    }

    return data
        .asMap()
        .map<int, PieChartSectionData>(
          (index, data) {
            final width = MediaQuery.of(context).size.width;
            final isTouched = index == touchedIndex;
            final double fontSize = isTouched ? 20 : 16;
            final double radius = isTouched ? width / 3.2 + 10 : width / 3.2;
            final double widgetSize = isTouched ? 55 : 40;

            final value = PieChartSectionData(
              color: data.color,
              title: data.name,
              value: data.percent,
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              badgeWidget: _Badge(
                data.icon,
                size: widgetSize,
                borderColor: data.color,
              ),
              badgePositionPercentageOffset: .98,
            );
            return MapEntry(index, value);
          },
        )
        .values
        .toList();
  }
}

class _Badge extends StatelessWidget {
  final String image;
  final double size;
  final Color borderColor;

  const _Badge(
    this.image, {
    Key key,
    @required this.size,
    @required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Image.asset(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class Data {
  final String name;
  final String icon;
  final double percent;
  final Color color;

  Data({
    this.name,
    this.icon,
    this.percent,
    this.color,
  });
}
