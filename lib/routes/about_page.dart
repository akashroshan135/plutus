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
  String _versionName = 'V. almost-done';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getPage(),
    );
  }

  Widget _getPage() {
    return SingleChildScrollView(
      child: Column(
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
        padding: EdgeInsets.only(top: 50, right: 20, left: 20, bottom: 30),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Icon(Icons.arrow_back),
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(width: 25),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/app_icon.png',
                  height: 130,
                  width: 130,
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
    final _random = new Random();
    var _inkwellColor = myColors[_random.nextInt(myColors.length)];
    final iconsCreditList = [
      'Bills Icon by Rizky Mardika (Iconscout)',
      'Tax Icon by Iconscout Freebies',
      'EMI Icon by Iconscout Freebies',
      'Snack Icon by Iconscout Freebies',
      'Hoodie Icon by Thossawat Jaikum (IconScout)',
      'Education Board Icon By Delesign Graphics (Iconscout)',
      'Multimedia Icon By Blakyta Design (Iconscout)',
      'Medical Icon By Mohit Gandhi (Iconscout)',
      'Insurance Icon By Md Moniruzzaman (Iconscout)',
      'Shopping Bag Icon By Mario Köstl (Iconscout)',
      'Dog Icon By Iconscout Freebies',
      'Economy Icon (Income) By Debruder Studio (Iconscout)',
      'Money Icon (Miscellaneous) By ToZ Icon (Iconscout)',
    ];

    final appDescription = Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Text(
        'An open source budget management app that I made for a college project. Even though it started as a college project, I really loved working on this app. So, expect more updates, features and other cool stuff in the future.',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );

    final appGithub = _buttonWidget(
      Icon(AntDesign.github),
      'Github',
      'https://github.com/akashroshan135/plutus',
      'https://github.com/akashroshan135/plutus',
    );

    final developer = <Widget>[
      Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Text(
          'Developer',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 16, bottom: 8),
        alignment: Alignment.centerLeft,
        child: Text(
          'Akash Roshan',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      _buttonWidget(
        Icon(AntDesign.github),
        'Github',
        '@akashroshan135',
        'https://github.com/akashroshan135',
      ),
      _buttonWidget(
        Icon(AntDesign.twitter),
        'Twitter',
        '@akashroshan135',
        'https://twitter.com/akashroshan135',
      ),
    ];

    final contributors = <Widget>[
      Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Text(
          'Contributors',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      _buttonWidget(
        Icon(AntDesign.github),
        'Ratandeep Kaur Sodhi',
        '@ratandeepkaur',
        'https://github.com/ratandeepkaur',
      ),
      _buttonWidget(
        Icon(AntDesign.twitter),
        'Subramanium Sai Marei',
        '@subbu_tutnh',
        'https://twitter.com/subbu_tutnh',
      ),
      Padding(
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
              onTap: () {
                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      title: Text(
                        'Icon Credits',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      content: Container(
                        height: MediaQuery.of(context).size.height - 300,
                        width: MediaQuery.of(context).size.width - 60,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: iconsCreditList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                iconsCreditList[index],
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: Text(
                          'Icon Credits',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          appDescription,
          appGithub,
          developer[0],
          developer[1],
          developer[2],
          developer[3],
          contributors[0],
          contributors[1],
          contributors[2],
          contributors[3],
        ],
      ),
    );
  }

  Widget _buttonWidget(Icon icon, mainText, subText, link) {
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
            onTap: () => launch(link),
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
                    Flexible(
                      child: Text(
                        mainText,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        subText,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
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
