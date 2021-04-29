import 'package:flutter/material.dart';

// * Database packages
import 'package:provider/provider.dart';
import 'package:plutus/data/moor_database.dart';

//* Routes to other pages
import 'package:plutus/routes/spash_screen.dart';

// * renders main app
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // * creating an AppDatabase instance
  final db = AppDatabase();

  @override
  Widget build(BuildContext context) {
    // * settings for dark mode theme data
    final _darkTheme = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // used for selected or active stuff
      primaryColor: Colors.blue,
      // used for unselected or inactive stuff
      accentColor: Colors.black,
      // used for the headers
      secondaryHeaderColor: Colors.black,
      // used for scffold backgroud color
      scaffoldBackgroundColor: Color.fromARGB(255, 18, 18, 18),
      // used for icons
      iconTheme: IconThemeData(color: Colors.white, size: 25),
      // used for footer icons
      primaryIconTheme: IconThemeData(color: Colors.blue, size: 25),
      accentIconTheme: IconThemeData(color: Colors.white, size: 25),
      // used for buttons
      buttonColor: Colors.blue,
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        headline2: TextStyle(
          color: Colors.white,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
        bodyText1: TextStyle(fontSize: 15.0, color: Colors.white),
        bodyText2: TextStyle(fontSize: 13.0, color: Colors.white),
      ),
    );

    // * settings for light mode theme data
    final _lightTheme = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // used for selected or active stuff
      primaryColor: Colors.blue,
      // used for unselected or inactive stuff
      accentColor: Colors.white,
      // used for the headers
      secondaryHeaderColor: Colors.white,
      // used for scffold backgroud color
      scaffoldBackgroundColor: Colors.grey[200],
      // used for icons
      iconTheme: IconThemeData(color: Colors.black, size: 25),
      // used for footer icons
      primaryIconTheme: IconThemeData(color: Colors.blue, size: 25),
      accentIconTheme: IconThemeData(color: Colors.black, size: 25),
      // used for buttons
      buttonColor: Colors.blue,
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        headline2: TextStyle(
          color: Colors.black,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
        bodyText1: TextStyle(fontSize: 15.0, color: Colors.black),
        bodyText2: TextStyle(fontSize: 13.0, color: Colors.black),
      ),
    );

    // * Provider is used to provide DAOs
    return MultiProvider(
      providers: [
        Provider<ProfileDao>(create: (_) => db.profileDao),
        Provider<IncomeDao>(create: (_) => db.incomeDao),
        Provider<ExpenseDao>(create: (_) => db.expenseDao),
      ],
      child: MaterialApp(
        title: 'Plutus',
        theme: _lightTheme,
        darkTheme: _darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}
