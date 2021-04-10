import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: getPage(),
    );
  }

  Widget getPage() {
    return ListView(
      children: [
        getHeader(),
        // TODO implement the transactions screen
        // ExpenseRoute(selectedDate: selectedDate),
        // IncomeRoute(selectedDate: selectedDate),
      ],
    );
  }

  // TODO implement an interactive calendar
  Widget getHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.01),
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
                  'Calendar',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}
