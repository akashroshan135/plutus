import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

//* Routes to other pages
import 'package:plutus/routes/components/incomes.dart';
import 'package:plutus/routes/components/expenses.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  // * selects the 3rd date item which will be the current date
  int activeDay = 3;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getPage(),
    );
  }

  Widget _getPage() {
    return SingleChildScrollView(
      child: ListView(
        primary: false,
        shrinkWrap: true,
        children: [
          _getHeader(),
          ExpenseRoute(selectedDate: selectedDate),
          IncomeRoute(selectedDate: selectedDate),
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
        padding: EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Transactions',
                  style: Theme.of(context).textTheme.headline1,
                ),
                // Icon(AntDesign.search1)
              ],
            ),
            SizedBox(height: 25),
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
  List<GestureDetector> _dateItem() {
    return List.generate(
      7,
      (index) {
        var date = Jiffy().subtract(days: 3);
        return GestureDetector(
          onTap: () {
            setState(() {
              activeDay = index;
              selectedDate = date.dateTime;
            });
          },
          child: Container(
            width: (MediaQuery.of(context).size.width - 40) / 7,
            child: Column(
              children: [
                Text(
                  date.add(days: index).format('EEE'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: 10),
                Container(
                  width: 38,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activeDay == index
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Center(
                    child: Text(
                      date.format('d'),
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
