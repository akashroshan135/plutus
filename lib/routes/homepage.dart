import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'package:plutus/routes/daily_page.dart';
import 'package:plutus/widgets/new_income.dart';
// import 'package:plutus/routes/incomes.dart';

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
    // BudgetPage(),
    // CreatBudgetPage(),
    // ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    // * renders actual homepage
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // appBar: _appbar(context),
      body: getBody(),
      bottomNavigationBar: getFooter(),
      floatingActionButton: getFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // * returns one of the pages
  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  // * returns the icons for the footer
  // TODO proper implementation
  Widget getFooter() {
    List<IconData> iconItems = [
      Ionicons.md_calendar,
      Ionicons.md_stats,
      Ionicons.md_wallet,
      Ionicons.ios_person,
    ];

    return AnimatedBottomNavigationBar(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      activeColor: Theme.of(context).primaryIconTheme.color,
      inactiveColor: Theme.of(context).accentIconTheme.color,
      splashColor: Color(0xFFFF2278),
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

  // * floating button data
  Widget getFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        showNewIncomeSceen();
      },
      child: Icon(
        Icons.add,
        size: Theme.of(context).iconTheme.size,
        color: Theme.of(context).iconTheme.color,
      ),
      backgroundColor: Colors.blue,
    );
  }

  // * shows the new income screen
  // TODO make one for expense
  void showNewIncomeSceen() async {
    final result = await showSlidingBottomSheet(
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
                    padding: EdgeInsets.all(16),
                    child: NewIncomeScreen(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    print(result);
  }
}
