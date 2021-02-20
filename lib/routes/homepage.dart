import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    // * renders actual homepage
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appbar(context),
      body: Column(children: [
        _dashboard(context),
        _calenderStrip(context),
      ]),
    );
  }

  // * appbar code
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

  // * code for dashboard
  // todo: actual dasboard implementation
  Widget _dashboard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 1.0, right: 1.0),
      child: Container(
        height: 180,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).secondaryHeaderColor,
          child: Center(
            child: Text(
              'todo Dashboard',
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ),
      ),
    );
  }

  Widget _calenderStrip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        child: Container(
          height: 80,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < 10; i++) _dataContainer(i),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dataContainer(int index) {
    return Container(
      width: 80,
      color: Theme.of(context).secondaryHeaderColor,
      child: Column(
        children: [
          Text(
            'Month',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            index.toString(),
            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 30),
          ),
        ],
      ),
    );
  }
}
