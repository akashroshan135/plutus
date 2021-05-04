import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int activeMonth = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getPage(),
    );
  }

  Widget _getPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _getHeader(),
          _getBody(),
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
                // Icon(AntDesign.search1)
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
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: activeMonth == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey[500]),
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

  Widget _getBody() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Stack(
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
              Positioned(
                bottom: 0,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 20),
                  height: 150,
                  child: _lineChart(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lineChart() {
    // TODO add chart stuff here
    return Container();
  }

  // Widget _lineChart() {
  //   double maxX = 7;
  //   double maxY = 10;
  //   var rng = new Random();

  //   List<FlSpot> spots = List.generate(
  //     7,
  //     (index) => FlSpot(
  //       index.toDouble(),
  //       rng.nextInt(maxY.toInt()).toDouble(),
  //     ),
  //   );
  //   var date = Jiffy();
  //   print(date.format('E'));
  //   return LineChart(
  //     LineChartData(
  //       gridData: FlGridData(
  //         show: true,
  //         drawHorizontalLine: true,
  //         getDrawingHorizontalLine: (value) {
  //           return FlLine(
  //             color: Theme.of(context).iconTheme.color,
  //             strokeWidth: 0.1,
  //           );
  //         },
  //       ),
  //       titlesData: FlTitlesData(
  //         show: true,
  //         bottomTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 22,
  //           getTextStyles: (value) => Theme.of(context).textTheme.bodyText2,
  //           getTitles: (value) {
  //             switch (value.toInt()) {
  //               case 0:
  //                 return date.format('E');
  //               case 1:
  //                 return date.add(days: 1).format('E');
  //               case 2:
  //                 return date.add(days: 1).format('E');
  //               case 3:
  //                 return date.add(days: 1).format('E');
  //               case 4:
  //                 return date.add(days: 1).format('E');
  //               case 5:
  //                 return date.add(days: 1).format('E');
  //               case 6:
  //                 return date.add(days: 1).format('E');
  //             }
  //             return '';
  //           },
  //           margin: 8,
  //         ),
  //         leftTitles: SideTitles(
  //           showTitles: true,
  //           getTextStyles: (value) => Theme.of(context).textTheme.bodyText2,
  //           getTitles: (value) {
  //             switch (value.toInt()) {
  //               case 1:
  //                 return '10k';
  //               case 3:
  //                 return '50k';
  //               case 5:
  //                 return '100k';
  //             }
  //             return '';
  //           },
  //           reservedSize: 28,
  //           margin: 12,
  //         ),
  //       ),
  //       borderData: FlBorderData(
  //         show: true,
  //       ),
  //       minX: 0,
  //       maxX: maxX,
  //       minY: 0,
  //       maxY: maxY,
  //       lineBarsData: [
  //         LineChartBarData(
  //           spots: spots,
  //           isCurved: true,
  //           colors: gradientColors,
  //           barWidth: 3,
  //           isStrokeCapRound: true,
  //           dotData: FlDotData(
  //             show: true,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
