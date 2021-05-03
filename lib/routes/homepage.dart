import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'dart:math';

//* Routes to other pages
import 'package:plutus/routes/daily_page.dart';
import 'package:plutus/routes/stats_page.dart';
import 'package:plutus/routes/calendar_page.dart';
import 'package:plutus/routes/profile_page.dart';
import 'package:plutus/routes/new_custom.dart';

//* Custom Widgets
import 'package:plutus/widgets/category.dart';
import 'package:plutus/widgets/new_income.dart';
import 'package:plutus/widgets/new_expense.dart';

//* Data Classes
import 'package:plutus/data/colorData.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // * index for the pages
  int pageIndex = 0;
  // * list of the pages
  List<Widget> pages = [
    DailyPage(),
    StatsPage(),
    CalendarPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return _getBody();
  }

  // * returns one of the pages
  Widget _getBody() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: pageIndex,
        children: pages,
      ),
      bottomNavigationBar: _getFooter(),
      floatingActionButton: _getFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // * returns bottom navigation bar. Changes page when clicking the icons
  Widget _getFooter() {
    final _random = new Random();

    // * list of icon data
    List<IconData> iconItems = [
      MaterialCommunityIcons.calendar_week,
      Ionicons.md_stats,
      MaterialCommunityIcons.calendar_month,
      Ionicons.ios_person,
    ];

    return AnimatedBottomNavigationBar(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      activeColor: Theme.of(context).primaryIconTheme.color,
      inactiveColor: Theme.of(context).accentIconTheme.color,
      splashColor:
          ColorData.myColors[_random.nextInt(ColorData.myColors.length)],
      iconSize: Theme.of(context).primaryIconTheme.size,
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      rightCornerRadius: 10,
      onTap: (index) {
        setState(() {
          pageIndex = index;
        });
      },
    );
  }

  // * floating button to show new transaction
  Widget _getFloatingButton() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: () {
        if (pageIndex == 2)
          _showUpcoming();
        else
          _showInputs();
      },
      child: Icon(
        Icons.add,
        size: Theme.of(context).iconTheme.size,
        color: Theme.of(context).iconTheme.color,
      ),
      // child: NeumorphicIcon(
      //   Icons.add_circle,
      //   size: 50,
      // ),
    );
  }

  // * shows option to select transaction type
  // TODO make better one
  void _showInputs() async {
    var width = MediaQuery.of(context).size.width;
    List inputs = ['Income', 'Expense'];

    var result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        contentPadding: EdgeInsets.all(5),
        content: Builder(
          builder: (context) {
            return Container(
              height: 190,
              width: width - 50,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView.builder(
                itemCount: inputs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Category(
                    index: index,
                    categoryName: inputs[index],
                    categoryIcon: FontAwesome5.money_bill_alt,
                    categoryColor: Colors.pink,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
    setState(() {
      if (result == 0) _showNewInputSceen(NewIncomeScreen());
      if (result == 1) _showNewInputSceen(NewExpenseScreen());
    });
  }

  // * shows the new input screen, gets new transaction type
  void _showNewInputSceen(inputWidget) async {
    return await showSlidingBottomSheet(
      context,
      builder: (context) {
        return SlidingSheetDialog(
          elevation: 10,
          cornerRadius: 16,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [0.58, 0.7, 1.0],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          builder: (context, state) {
            return Container(
              height: 500,
              child: Center(
                child: Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: inputWidget,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showUpcoming() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomScreen()),
    );
  }
}
