import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:plutus/routes/incomes.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  // * selects the 3rd date which will be the current date
  int activeDay = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      children: [
        getHeader(),
        IncomeRoute(),
      ],
    );
  }

  // * header consists of date list
  Widget getHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        boxShadow: [
          BoxShadow(
            // changes position of shadow
            color: Colors.grey.withOpacity(0.01),
            spreadRadius: 10,
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Daily Transactions",
                  style: Theme.of(context).textTheme.headline1,
                ),
                // Icon(AntDesign.search1)
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _dateItem(),
            ),
          ],
        ),
      ),
    );
  }

  // * generates the list of dates. Includes 3 previous days, current day and next 3 days
  // TODO change colors to use theme data
  List<GestureDetector> _dateItem() {
    var date = DateTime.now().subtract(Duration(days: 3));
    return List.generate(
      7,
      (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              activeDay = index;
            });
          },
          child: Container(
            width: (MediaQuery.of(context).size.width - 40) / 7,
            child: Column(
              children: [
                Text(
                  DateFormat('EEE').format(date.add(Duration(days: index))),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: activeDay == index
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: activeDay == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey[500])),
                  child: Center(
                    child: Text(
                      DateFormat('d').format(date.add(Duration(days: index))),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
