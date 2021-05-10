import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

//* Routes to other pages
import 'package:plutus/routes/components/expenses.dart';
import 'package:plutus/routes/components/incomes.dart';
import 'package:plutus/routes/components/upcoming.dart';

//* Custom Widgets
import 'package:plutus/routes/components/stats.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  bool isCalendar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getPage(),
    );
  }

  Widget _getPage() {
    final calendar = Column(
      children: [
        _getHeader(),
        UpcomingRoute(selectedDate: _selectedDay),
        ExpenseRoute(selectedDate: _selectedDay),
        IncomeRoute(selectedDate: _selectedDay),
      ],
    );

    final month = Column(
      children: [
        _getHeader(),
        StatsDetailsPage(selectedMonth: _selectedDay),
      ],
    );

    return SingleChildScrollView(
      child: isCalendar ? calendar : month,
    );
  }

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
        padding: EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Calendar',
                  style: Theme.of(context).textTheme.headline1,
                ),
                Spacer(),
                Tooltip(
                  message: 'Change View',
                  child: Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isCalendar = !isCalendar;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).iconTheme.color,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 2, bottom: 2, left: 5, right: 5),
                          child: Text(
                            isCalendar ? 'Month' : 'Day',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Tooltip(
                    message: 'Go back to Today',
                    child: Icon(Icons.restore),
                  ),
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
            isCalendar ? _getCalendar() : _getMonthPicker(),
          ],
        ),
      ),
    );
  }

  Widget _getCalendar() {
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
      padding: EdgeInsets.only(bottom: 30),
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
    );
  }

  Widget _getMonthPicker() {
    dp.DatePickerStyles styles = dp.DatePickerStyles(
      displayedPeriodTitle: Theme.of(context).textTheme.headline1,
      defaultDateTextStyle: Theme.of(context).textTheme.bodyText1,
      currentDateStyle:
          Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.green),
      selectedDateStyle: Theme.of(context).textTheme.bodyText1,
      selectedSingleDateDecoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(60),
        border: Border.all(
          color: Theme.of(context).secondaryHeaderColor,
          width: 5,
        ),
      ),
    );

    return Container(
      child: dp.MonthPicker(
        selectedDate: _selectedDay,
        onChanged: (DateTime newDate) {
          setState(() {
            _selectedDay = newDate;
          });
        },
        firstDate: DateTime.utc(2010, 10, 16),
        lastDate: DateTime.utc(2030, 3, 14),
        datePickerStyles: styles,
        datePickerLayoutSettings:
            dp.DatePickerLayoutSettings(monthPickerPortraitWidth: 360),
      ),
    );
  }
}
