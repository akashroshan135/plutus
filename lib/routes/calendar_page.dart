import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

//* Routes to other pages
import 'package:plutus/routes/components/expenses.dart';
import 'package:plutus/routes/components/incomes.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

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
        ExpenseRoute(selectedDate: _selectedDay),
        IncomeRoute(selectedDate: _selectedDay),
      ],
    );
  }

  Widget _getHeader() {
    final _calendarSytle = CalendarStyle(
      defaultTextStyle: Theme.of(context).textTheme.bodyText1,
      weekendTextStyle: Theme.of(context).textTheme.bodyText1,
      todayTextStyle: Theme.of(context).textTheme.bodyText1,
      selectedTextStyle: Theme.of(context).textTheme.bodyText1,
      outsideTextStyle:
          Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.grey),
      defaultDecoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.circle,
      ),
      weekendDecoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.circle,
      ),
      todayDecoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      selectedDecoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      outsideDecoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        shape: BoxShape.circle,
      ),
    );

    final _headerSytle = HeaderStyle(
      titleCentered: true,
      formatButtonVisible: false,
      titleTextStyle: Theme.of(context).textTheme.headline1,
      formatButtonTextStyle: Theme.of(context).textTheme.headline1,
    );

    final _daysSytle = DaysOfWeekStyle(
      weekdayStyle: Theme.of(context).textTheme.bodyText2,
      weekendStyle: Theme.of(context).textTheme.bodyText2,
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
                InkWell(
                  child: Icon(Icons.restore),
                  onTap: () {
                    setState(() {
                      _focusedDay = DateTime.now();
                      _selectedDay = DateTime.now();
                    });
                  },
                )
              ],
            ),
            // SizedBox(height: 20),
            Container(
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                // * functions
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
                // * styles
                calendarStyle: _calendarSytle,
                headerStyle: _headerSytle,
                daysOfWeekStyle: _daysSytle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
