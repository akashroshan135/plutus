import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int activeMonth = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      children: [
        getHeader(),
      ],
    );
  }

  // * header consists of date list
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
                  'Monthly Statistics',
                  style: Theme.of(context).textTheme.headline1,
                ),
                // Icon(AntDesign.search1)
              ],
            ),
            SizedBox(height: 25),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _monthItem(),
            ),
          ],
        ),
      ),
    );
  }

  List<GestureDetector> _monthItem() {
    return List.generate(
      6,
      (index) {
        var month = Jiffy().subtract(months: 5);
        return GestureDetector(
          onTap: () {
            setState(() {
              activeMonth = index;
              // selectedMonth = month.datetime;
              print(month.format('MMM yyyy'));
            });
          },
          child: Container(
            width: (MediaQuery.of(context).size.width - 40) / 6,
            child: Column(
              children: [
                Text(
                  month.add(months: index).format('yyyy'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: 10),
                Container(
                  width: 45,
                  height: 35,
                  decoration: BoxDecoration(
                    color: activeMonth == index
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: activeMonth == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey[500]),
                  ),
                  child: Center(
                    child: Text(
                      month.format('MMM'),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
