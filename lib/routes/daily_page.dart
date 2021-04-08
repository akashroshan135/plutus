import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:plutus/routes/incomes.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:math';

import 'package:plutus/data/moor_database.dart';

import 'package:plutus/data/incomeCat.dart';
import 'package:plutus/data/colorData.dart';

const _padding = EdgeInsets.all(16.0);
// import 'package:budget_tracker_ui/json/daily_json.dart';
// import 'package:budget_tracker_ui/theme/colors.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  // * selects the 3rd date which will be the current date
  int activeDay = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      children: [
        getHeader(),
        // getMainbody(),
      ],
    );
  }

  // * header consists of date list
  // TODO change colors to use theme data
  Widget getHeader() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          // changes position of shadow
          color: Colors.grey.withOpacity(0.01),
          spreadRadius: 10,
          blurRadius: 3,
        ),
      ]),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Daily Transactions",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                // Icon(AntDesign.search1)
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _dateItem(),
            ),
          ],
        ),
      ),
    );
  }

  // * generates the list of dates. Includes 3 previous days, current day and next 3 days
  // TODO change colors to use theme data
  List<GestureDetector> _dateItem() {
    var date = DateTime.now().subtract(Duration(days: 3));
    return List.generate(
      7,
      (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              activeDay = index;
            });
          },
          child: Container(
            width: (MediaQuery.of(context).size.width - 40) / 7,
            child: Column(
              children: [
                Text(
                  DateFormat('EEEE')
                      .format(date.add(Duration(days: index)))
                      .substring(0, 3),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color:
                          activeDay == index ? Colors.blue : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: activeDay == index
                              ? Colors.blue
                              : Colors.black.withOpacity(0.1))),
                  child: Center(
                    child: Text(
                      DateFormat('d').format(date.add(Duration(days: index))),
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color:
                              activeDay == index ? Colors.white : Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // TODO make main body working
  /*
  Widget getMainbody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
                children: List.generate(daily.length, (index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (size.width - 40) * 0.7,
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: grey.withOpacity(0.1),
                              ),
                              child: Center(
                                child: Image.asset(
                                  daily[index]['icon'],
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              width: (size.width - 90) * 0.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    daily[index]['name'],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: black,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    daily[index]['date'],
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: black.withOpacity(0.5),
                                        fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: (size.width - 40) * 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              daily[index]['price'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 65, top: 8),
                    child: Divider(
                      thickness: 0.8,
                    ),
                  )
                ],
              );
            })),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Text(
                    "Total",
                    style: TextStyle(
                        fontSize: 16,
                        color: black.withOpacity(0.4),
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "\₹3430.00",
                    style: TextStyle(
                        fontSize: 20,
                        color: black,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  */

}
