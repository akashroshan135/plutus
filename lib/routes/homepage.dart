import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:fluttertoast/fluttertoast.dart';

//* Routes to other pages
import 'package:plutus/routes/daily_page.dart';
import 'package:plutus/routes/stats_page.dart';
import 'package:plutus/routes/calendar_page.dart';
import 'package:plutus/routes/profile_page.dart';
import 'package:plutus/routes/newPages/new_custom.dart';

//* Custom Widgets
import 'package:plutus/widgets/categoryMain.dart';
import 'package:plutus/widgets/new/new_income.dart';
import 'package:plutus/widgets/new/new_expense.dart';

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
  // * used for back to exit
  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: _getBody(), onWillPop: onWillPop);
  }

  // * returns one of the pages
  Widget _getBody() {
    return Scaffold(
      extendBody: true,
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
      inactiveColor: Theme.of(context).disabledColor,
      splashColor: Theme.of(context).primaryColor,
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
      onPressed: () => _showInputs(),
      child: Icon(
        Icons.add,
        size: Theme.of(context).iconTheme.size,
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }

  // * shows option to select transaction type
  void _showInputs() async {
    var width = MediaQuery.of(context).size.width;
    List inputTitle = ['Income', 'Expense', 'Custom Transaction'];
    List inputIcon = [
      'assets/images/income.png',
      'assets/images/expense.png',
      'assets/images/custom_transaction.png',
    ];
    List inputColor = [Colors.green, Colors.red, Colors.grey];

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
              width: width - 50,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: inputTitle.length,
                itemBuilder: (BuildContext context, int index) {
                  return CategoryMain(
                    index: index,
                    categoryName: inputTitle[index],
                    categoryIcon: inputIcon[index],
                    categoryColor: inputColor[index],
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
      if (result == 2) _showCustomInput();
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
              height: MediaQuery.of(context).size.height / 1.5,
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

  void _showCustomInput() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomScreen()),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press back again to exit');
      return Future.value(false);
    }
    return Future.value(true);
  }
}
