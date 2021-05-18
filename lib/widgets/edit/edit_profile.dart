import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// * Database packages
import 'package:moor_flutter/moor_flutter.dart';
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final Profile profile;
  EditProfileScreen({Key key, this.profile}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _padding = EdgeInsets.all(16);

  final controllerName = TextEditingController();
  final controllerAmount = TextEditingController();

  final accentColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    controllerName.text = widget.profile.name;
    controllerAmount.text = widget.profile.balance.toString();
  }

  @override
  Widget build(BuildContext context) {
    return _getBody();
  }

  Widget _getBody() {
    // * calling profile and expense database dao
    final profileDao = Provider.of<ProfileDao>(context);

    // * input field for Name
    final inputName = Padding(
      padding: _padding,
      child: TextField(
        controller: controllerName,
        cursorColor: accentColor,
        maxLength: 50,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: _decoratorInputWidget('Name'),
      ),
    );

    // * submit button. Submits data to db and goes to previous page
    final submit = Padding(
      padding: EdgeInsets.only(top: 16, left: 100, right: 100, bottom: 50),
      child: Container(
        height: 50,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: accentColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            highlightColor: Colors.red,
            splashColor: Colors.red,
            onTap: () async {
              if (controllerName.text == '') {
                return _getWarning('Please enter all the fields');
              } else {
                final profiles = await profileDao.getAllProfile();
                final profile = profiles[0];
                profileDao.updateProfile(
                  ProfilesCompanion(
                    id: Value(profile.id),
                    name: Value(controllerName.text),
                    balance: Value(profile.balance),
                  ),
                );
                Navigator.pop(context);
                Fluttertoast.showToast(msg: 'Profile has been edited');
              }
            },
            child: Center(
              child: Text(
                'Update',
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

    return ListView(
      children: [
        Center(
          child: Text(
            'Update Profile',
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: accentColor),
          ),
        ),
        SizedBox(height: 10),
        inputName,
        submit,
      ],
    );
  }

  InputDecoration _decoratorInputWidget(String text) {
    return InputDecoration(
      labelText: text,
      counterStyle:
          TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
      labelStyle: TextStyle(color: accentColor),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: accentColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: accentColor, width: 1),
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
}
