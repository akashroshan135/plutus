import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
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
        onPressed: () => setState(() {}),
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
        onPressed: () => setState(() {}),
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => AboutScreen()),
        // ),
      ),
    );

    // * appbar code
    final appBar = AppBar(
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

    // * code for dashboard
    // todo: actual dasboard implementation
    final dashboard = Padding(
      padding: const EdgeInsets.all(16.0),
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

    // * renders actual homepage
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: appBar,
      body: Column(
        children: [dashboard],
      ),
    );
  }
}
