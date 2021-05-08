import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

// * Database packages
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

//* Routes to other pages
import 'package:plutus/routes/about_page.dart';

//* Custom Widgets
import 'package:plutus/widgets/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final controllerAmount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getPage(),
    );
  }

  // * renders the body
  Widget _getPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _getHeader(),
          // _getBody(),
        ],
      ),
    );
  }

  // * renders the header
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile',
                  style: Theme.of(context).textTheme.headline1,
                ),
                InkWell(
                  child: Tooltip(
                    message: 'About',
                    child: Icon(Entypo.info_with_circle),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            _getHeaderData(),
          ],
        ),
      ),
    );
  }

  // * gets the profile data from the database
  Widget _getHeaderData() {
    // * calling database
    final profileDao = Provider.of<ProfileDao>(context);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: profileDao.watchAllProfile(),
      builder: (context, AsyncSnapshot<List<Profile>> snapshot) {
        final profile = snapshot.data ?? [];
        return ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: profile.length,
          itemBuilder: (_, index) {
            return Column(
              children: [
                _getNameData(profile[0]),
                SizedBox(height: 25),
                _getSavingsData(profile[0]),
              ],
            );
          },
        );
      },
    );
  }

  // * renders the name widget
  Widget _getNameData(Profile profile) {
    var size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: (size.width - 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    profile.name,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  InkWell(
                    child: Tooltip(
                      message: 'Edit Profile Name',
                      child: Icon(Icons.edit),
                    ),
                    onTap: () {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Update Profile Name',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            content: Text(
                              'Are you sure you want to update your Profile Name?',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  'No',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _showEditSceen(profile);
                                },
                                child: Text(
                                  'Yes',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              // SizedBox(height: 10),
              // Text(
              //   // TODO put somthing useful here
              //   'Credit score: 73.50',
              //   style: Theme.of(context).textTheme.bodyText2,
              // ),
            ],
          ),
        ),
      ],
    );
  }

  // * renders the savings widget
  Widget _getSavingsData(Profile profile) {
    return Container(
      // width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.01),
            spreadRadius: 10,
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Savings',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 10),
                Text(
                  '₹ ' + profile.balance.toString(),
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditSceen(Profile profile) async {
    return await showSlidingBottomSheet(
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
              height: MediaQuery.of(context).size.height / 2.5,
              child: Center(
                child: Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: EditProfileScreen(profile: profile),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
