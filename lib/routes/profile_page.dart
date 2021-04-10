import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

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

  Widget getPage() {
    return ListView(
      children: [
        getHeader(),
        // getBody(),
      ],
    );
  }

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
                  "Profile",
                  style: Theme.of(context).textTheme.headline1,
                ),
                Icon(Entypo.info_with_circle),
              ],
            ),
            SizedBox(height: 25),
            getHeaderData(),
            SizedBox(height: 25),
            getSavingsData(),
          ],
        ),
      ),
    );
  }

  Widget getHeaderData() {
    var size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   width: (size.width - 40) * 0.4,
        //   child: Container(
        //     child: Stack(
        //       children: [
        //         RotatedBox(
        //           quarterTurns: -2,
        //           // child: CircularPercentIndicator(
        //           //     circularStrokeCap: CircularStrokeCap.round,
        //           //     backgroundColor: grey.withOpacity(0.3),
        //           //     radius: 110,
        //           //     lineWidth: 6,
        //           //     percent: 0.53,
        //           //     progressColor: primary),
        //         ),
        //         Positioned(
        //           top: 16,
        //           left: 13,
        //           child: Container(
        //             width: 85,
        //             height: 85,
        //             decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 image: DecorationImage(
        //                     image: NetworkImage(""), fit: BoxFit.cover)),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        Container(
          width: (size.width - 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ratandeep Kaur Sodhi",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 25),
              ),
              SizedBox(height: 10),
              Text(
                "Credit score: 73.50",
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getSavingsData() {
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
                  "Total Savings",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 10),
                Text(
                  "₹12542.00",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
            Container(
              child: InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(13),
                    child: Text(
                      "Update",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
