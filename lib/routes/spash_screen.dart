import 'package:flutter/material.dart';
import 'dart:async';

// * Database packages
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

//* Routes to other pages
import 'package:plutus/routes/newPages/new_profile.dart';
import 'package:plutus/routes/homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _versionName = 'V. almost-done';
  final _splashDelay = 3;

  // * Sets a timer of _splashDelay seconds and pushes NewProfileScreen
  _loadNewProfileScreen() async {
    return Timer(
      Duration(seconds: _splashDelay),
      _newProfilePage,
    );
  }

  // * pushes NewProfileScreen to the navigator stack
  void _newProfilePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NewProfileScreen(),
      ),
    );
  }

  // * Sets a timer of _splashDelay seconds and pushes Homepage
  _loadHomepage() async {
    return Timer(
      Duration(seconds: _splashDelay),
      _newHomepage,
    );
  }

  // * pushes Homepage to the navigator stack
  void _newHomepage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Homepage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // * calling the database
    final profileDao = Provider.of<ProfileDao>(context);

    // * FutureBuilder used to check for get the data
    return FutureBuilder(
      future: profileDao.getAllProfile(),
      builder: (context, snapshot) {
        // * checks if the connectiion is waiting. returns a splash sceen until connection is done
        if (snapshot.connectionState == ConnectionState.done) {
          // * checks if the profile table has entries or not
          if (snapshot.hasData == false || snapshot.data.isEmpty) {
            // * renders new profile creation screen
            _loadNewProfileScreen();
          } else {
            // * renders homepage
            _loadHomepage();
          }
        }
        return _getBody();
      },
    );
  }

  Widget _getBody() {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/app_icon.png',
                        height: 250,
                        width: 250,
                      ),
                      SizedBox(height: 10),
                      Image.asset(
                        isDarkMode
                            ? 'assets/images/plutus_white.png'
                            : 'assets/images/plutus_black.png',
                        height: 60,
                        width: 200,
                      ),
                      SizedBox(height: 20),
                      // Text(
                      //   'Plutus',
                      //   style: Theme.of(context).textTheme.headline2,
                      // ),
                      Text(
                        _versionName,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Container(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).iconTheme.color),
                    ),
                  ),
                ),
                Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
