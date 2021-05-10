import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//* Data Classes
import 'package:plutus/data/expenseCat.dart';
import 'package:plutus/data/incomeCat.dart';

class TransactionScreen extends StatefulWidget {
  final transaction;
  final isIncome;

  TransactionScreen({
    Key key,
    this.transaction,
    this.isIncome,
  }) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
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
                  widget.isIncome
                      ? 'Income Transaction Details'
                      : 'Expense Transaction Details',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  widget.isIncome
                      ? IncomeCategory
                          .categoryIcon[widget.transaction.categoryIndex]
                      : ExpenseCategory
                          .categoryIcon[widget.transaction.categoryIndex],
                  height: MediaQuery.of(context).size.height / 4.5,
                  width: MediaQuery.of(context).size.width / 2,
                ),
                Flexible(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.isIncome ? 'Income' : 'Expense',
                          style: widget.isIncome
                              ? Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(color: Colors.green)
                              : Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(color: Colors.red),

                          // style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget.isIncome
                              ? IncomeCategory.categoryNames[
                                  widget.transaction.categoryIndex]
                              : ExpenseCategory.categoryNames[
                                  widget.transaction.categoryIndex],
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBody() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buttonWidget(
            'Tags:',
            widget.transaction.tags,
          ),
          _buttonWidget(
            'Amount:',
            '\₹ ' + widget.transaction.amount.toString(),
          ),
          _buttonWidget(
            'Date and Time:',
            DateFormat('d MMM yyyy, hh:mm a')
                .format(widget.transaction.date)
                .toString(),
          ),
        ],
      ),
    );
  }

  Widget _buttonWidget(mainText, subText) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        height: 80,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).secondaryHeaderColor,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mainText,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18),
                    ),
                    Text(
                      subText,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 15),
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
