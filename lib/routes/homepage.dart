import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:plutus/routes/daily_page.dart';
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
      backgroundColor: Theme.of(context).backgroundColor,
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

    // TODO change colors to use theme data
    return AnimatedBottomNavigationBar(
      activeColor: Color(0xFF28c2ff),
      splashColor: Color(0xFFFF2278),
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );
  }

  Widget getFloatingButton() {
    return FloatingActionButton(
        onPressed: () {
          // selectedTab(4);
        },
        child: Icon(
          Icons.add,
          size: 25,
        ),
        backgroundColor: Colors.blue
        //params
        );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }

/*
  // * appbar code
  // todo: add menu
  Widget _appbar(BuildContext context) {
    // * has the menu button on the left side of the appbar
    final menuBtn = Padding(
      padding: EdgeInsets.all(8),
      child: IconButton(
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).iconTheme.color,
          size: Theme.of(context).iconTheme.size,
        ),
        // * Navigator pushes the new screen to stack
        onPressed: () => print('menu page btn is pressed'),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AboutScreen()),
        // ),
      ),
    );

    // * has about button on the right side of the appbar
    // ? might change this to options or settings
    final aboutBtn = Padding(
      padding: EdgeInsets.all(8),
      child: IconButton(
        icon: Icon(
          Icons.info_outline_rounded,
          color: Theme.of(context).iconTheme.color,
          size: Theme.of(context).iconTheme.size,
        ),
        // * Navigator pushes the new screen to stack
        onPressed: () => print('about page btn is pressed'),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AboutScreen()),
        // ),
      ),
    );

    // * returns appbar code
    return AppBar(
      title: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            'Plutus',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      leading: menuBtn,
      actions: [aboutBtn],
    );
  }
*/

}
