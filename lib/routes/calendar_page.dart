import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getPage(),
    );
  }

  Widget _getPage() {
    return ListView(
      children: [
        _getHeader(),
        // TODO implement the transactions screen
        // ExpenseRoute(selectedDate: selectedDate),
        // IncomeRoute(selectedDate: selectedDate),
      ],
    );
  }

  // TODO implement an interactive calendar
  Widget _getHeader() {
    final _calendarSytle = CalendarStyle(
      defaultTextStyle: Theme.of(context).textTheme.bodyText1,
      weekendTextStyle: Theme.of(context).textTheme.bodyText1,
      todayTextStyle: Theme.of(context).textTheme.bodyText1,
      selectedTextStyle: Theme.of(context).textTheme.bodyText1,
      outsideTextStyle:
          Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey),
      defaultDecoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      weekendDecoration: BoxDecoration(
        color: Colors.yellow,
        shape: BoxShape.circle,
      ),
      todayDecoration: BoxDecoration(
        color: Colors.brown,
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: Colors.pink,
        shape: BoxShape.circle,
      ),
      outsideDecoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
    );

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
                  'Calendar',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
            // SizedBox(height: 20),
            Container(
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                calendarStyle: _calendarSytle,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
