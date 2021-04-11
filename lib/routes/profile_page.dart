import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

// * Database packages
import 'package:plutus/data/moor_database.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: getPage(),
    );
  }

  // * renders the body
  Widget getPage() {
    return ListView(
      children: [
        getHeader(),
        // getBody(),
      ],
    );
  }

  // * renders the header
  Widget getHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.01),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile',
                  style: Theme.of(context).textTheme.headline1,
                ),
                Icon(Entypo.info_with_circle),
              ],
            ),
            SizedBox(height: 25),
            getHeaderData(),
          ],
        ),
      ),
    );
  }

  // * gets the profile data from the database
  Widget getHeaderData() {
    // * calling database
    final profileDao = Provider.of<ProfileDao>(context);

    // * StreamBuilder used to build list of all objects
    return StreamBuilder(
      stream: profileDao.watchAllProfile(),
      builder: (context, AsyncSnapshot<List<Profile>> snapshot) {
        final profile = snapshot.data ?? [];
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: profile.length,
          itemBuilder: (_, index) {
            return Column(
              children: [
                getNameData(context, profile[0]),
                SizedBox(height: 25),
                getSavingsData(context, profile[0]),
              ],
            );
          },
        );
      },
    );
  }

  // * renders the name widget
  Widget getNameData(BuildContext context, Profile profile) {
    var size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: (size.width - 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 25),
              ),
              SizedBox(height: 10),
              Text(
                // TODO put somthing useful here
                'Credit score: 73.50',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // * renders the savings widget
  Widget getSavingsData(BuildContext context, Profile profile) {
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
            Container(
              child: InkWell(
                onTap: () {
                  // TODO add option to update balance
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(13),
                    child: Text(
                      'Update',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
