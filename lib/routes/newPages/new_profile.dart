import 'package:flutter/material.dart';

// * Database packages
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

//* Routes to other pages
import 'package:plutus/routes/homepage.dart';

class NewProfileScreen extends StatefulWidget {
  @override
  _NewProfileScreenState createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  final controllerName = TextEditingController();
  final controllerAmount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
    );
  }

  // * prints the background screen
  Widget _getBody() {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/profile_top.png',
              width: size.width * 0.35,
            ),
          ),
          _getInputScreen(),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/profile_bottom.png',
              width: size.width * 0.4,
            ),
          ),
        ],
      ),
    );
  }

  // * renders the input screen
  Widget _getInputScreen() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'PLUTUS',
              style:
                  Theme.of(context).textTheme.headline1.copyWith(fontSize: 30),
            ),
            SizedBox(height: 10),
            Text(
              'Create a profile',
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 20),
            Image.asset(
              'assets/images/app_icon.png',
              fit: BoxFit.fitWidth,
              width: 220,
              alignment: Alignment.bottomCenter,
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: controllerName,
                maxLength: 50,
                cursorColor: Theme.of(context).buttonColor,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: _decoratorInputWidget('Name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: controllerAmount,
                keyboardType: TextInputType.number,
                cursorColor: Theme.of(context).buttonColor,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: _decoratorInputWidget('Savings'),
              ),
            ),
            _getSubmit(),
          ],
        ),
      ),
    );
  }

  // * submit button. Submits data to db and opens the homepage again
  Widget _getSubmit() {
    final profileeDao = Provider.of<ProfileDao>(context);

    return Padding(
      padding: EdgeInsets.only(top: 16, left: 100, right: 100),
      child: Container(
        height: 50,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).primaryColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              if (controllerName.text == '' || controllerAmount.text == '') {
                return _getWarning('Please enter all the fields');
              } else {
                double amount;
                try {
                  amount = double.parse(controllerAmount.text);
                  if (amount > 100000) {
                    return _getEasterEgg();
                  } else {
                    profileeDao.addProfile(
                      ProfilesCompanion(
                        name: moor.Value(controllerName.text),
                        balance:
                            moor.Value(double.parse(controllerAmount.text)),
                      ),
                    );
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Homepage(),
                    ),
                  );
                } catch (FormatException) {
                  return _getWarning('Please enter number data for amount');
                }
              }
            },
            child: Center(
              child: Text(
                'Let\'s get started',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoratorInputWidget(String text) {
    return InputDecoration(
      labelText: text,
      counterStyle:
          TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
      labelStyle: TextStyle(color: Theme.of(context).buttonColor),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).buttonColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).buttonColor, width: 1),
      ),
    );
  }

  // * renders a warning dialog box
  Future _getWarning(String text) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Warning',
            style: Theme.of(context).textTheme.headline1,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        );
      },
    );
  }

  // * renders an easter egg
  Future _getEasterEgg() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Get an Accountant',
            style: Theme.of(context).textTheme.headline1,
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Text(
            'If you\'re dealing with so much money then you need an accountant, not an app',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        );
      },
    );
  }
}
