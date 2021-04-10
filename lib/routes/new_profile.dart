import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/basic.dart' as basic;

// * Database packages
import 'package:moor_flutter/moor_flutter.dart';
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
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final profileeDao = Provider.of<ProfileDao>(context);

    // * submit button. Submits data to db and goes to previous page
    final submit = Padding(
      padding: EdgeInsets.only(top: 16, left: 100, right: 100, bottom: 50),
      child: Container(
        height: 50,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).primaryColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            highlightColor: Colors.pink[400],
            splashColor: Colors.pink,
            onTap: () {
              if (controllerName.text == '' || controllerAmount.text == '') {
                return showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text('Warning',
                            style: Theme.of(context).textTheme.headline1),
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        content: Text(
                          'Please enter all the fields',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      );
                    });
              } else {
                profileeDao.addProfile(
                  ProfilesCompanion(
                    name: Value(controllerName.text),
                    balance: Value(double.parse(controllerAmount.text)),
                  ),
                );
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Homepage(),
                ),
              );
              // Navigator.pop(context);
            },
            child: Center(
              child: Text(
                'Submit',
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
              'assets/images/main_top.png',
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/login_bottom.png',
              width: size.width * 0.4,
            ),
          ),
          SingleChildScrollView(
            child: basic.Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'PLUTUS',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 30),
                ),
                SizedBox(height: size.height * 0.03),
                Text(
                  'Create a profile',
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(height: size.height * 0.03),
                Image.asset(
                  'assets/images/login_center.png',
                  fit: BoxFit.fitWidth,
                  width: 220.0,
                  alignment: Alignment.bottomCenter,
                ),
                SizedBox(height: size.height * 0.03),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: controllerName,
                    // keyboardType: TextInputType.number,
                    cursorColor: Theme.of(context).buttonColor,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: decoratorInputWidget(context, 'Name'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: controllerAmount,
                    keyboardType: TextInputType.number,
                    cursorColor: Theme.of(context).buttonColor,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: decoratorInputWidget(context, 'Savings'),
                  ),
                ),
                submit,
                SizedBox(height: size.height * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration decoratorInputWidget(BuildContext context, String text) {
    return InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: Theme.of(context).buttonColor),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Theme.of(context).buttonColor, width: 1)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Theme.of(context).buttonColor, width: 1)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 1)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 1)),
    );
  }
}
