import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

//* Colors List
List myColors = <Color>[
  Colors.teal,
  Colors.orange,
  Colors.pinkAccent,
  Colors.blueAccent,
  Colors.yellow,
  Colors.greenAccent,
  Colors.purpleAccent,
];

class AboutScreen extends StatefulWidget {
  AboutScreen({Key key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _versionName = 'V. somewhere-alpha';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getPage(),
    );
  }

  Widget _getPage() {
    return SingleChildScrollView(
      child: ListView(
        primary: false,
        shrinkWrap: true,
        children: [
          _getHeader(),
          _getBody(),
        ],
      ),
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
        padding: EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 30),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Icon(Icons.arrow_back),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 25),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
            SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // TODO insert app logo here
                Image.asset(
                  'assets/images/app_icon.png',
                  height: 75,
                  width: 75,
                ),
                SizedBox(height: 15),
                Text(
                  'Plutus',
                  style: Theme.of(context).textTheme.headline2,
                ),
                Text(
                  _versionName,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBody() {
    final appDescription = Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Text(
        'A small and simple budget management app that you can use to keep track of your income and expenses',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );

    final appGithub = _buttonWidget(
      context,
      Icon(AntDesign.github),
      'Github',
      'https://github.com/akashroshan135/plutus',
    );

    final developers = <Widget>[
      Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Text(
          'Developers',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      _buttonWidget(
        context,
        Icon(AntDesign.github),
        'Akash Roshan',
        'https://github.com/akashroshan135',
      ),
      _buttonWidget(
        context,
        Icon(AntDesign.github),
        'Ratandeep Kaur Sodhi',
        'https://github.com/ratandeepkaur',
      ),
    ];

    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: [
            appDescription,
            appGithub,
            developers[0],
            developers[1],
            developers[2],
          ],
        ),
      ),
    );
  }

  Widget _buttonWidget(BuildContext context, Icon icon, mainText, subText) {
    final _random = new Random();
    var _inkwellColor = myColors[_random.nextInt(myColors.length)];

    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        height: 80,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).secondaryHeaderColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            highlightColor: _inkwellColor,
            splashColor: _inkwellColor,
            onTap: () => launch(subText),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: Center(
                      child: icon,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mainText,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      subText,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
