import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

/* --------------------------------------------------------------
  Main App Database
-------------------------------------------------------------- */
@UseMoor(tables: [Incomes], daos: [IncomeDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
          path: 'db.sqlite',
          logStatements: true,
        ));

  @override
  int get schemaVersion => 1;
}

/* --------------------------------------------------------------
  Tables
-------------------------------------------------------------- */
// * used to change the name of the database
// @DataClassName('Incomes')
class Incomes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tags => text().withLength(min: 1, max: 50)();
  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();
  IntColumn get categoryIndex => integer()();

  // * used to set primary keys. Not required as autoIncrement() sets key as primary
  // @override
  // Set<Column> get primaryKey => {id};
}

/* --------------------------------------------------------------
  DAOs
-------------------------------------------------------------- */
// TODO learn how to use with multiple tables
@UseDao(tables: [Incomes])
class IncomeDao extends DatabaseAccessor<AppDatabase> with _$IncomeDaoMixin {
  final AppDatabase db;

  // * Called by the AppDatabase class
  IncomeDao(this.db) : super(db);

  /* --------------------------------------------------------------
    Income Table queries
  -------------------------------------------------------------- */
  Future<List<Income>> getAllIncome() => select(incomes).get();
  // * streams all income rows
  Stream<List<Income>> watchAllIncome() => select(incomes).watch();
  // * streams income rows filtered by seleted date
  Stream<List<Income>> watchDayIncome(DateTime searchDate) {
    return (select(incomes)
          ..where((row) =>
              row.date.day.equals(searchDate.day) &
              row.date.month.equals(searchDate.month) &
              row.date.year.equals(searchDate.year)))
        .watch();
  }

  // * add an income transaction
  Future<int> addIncome(Insertable<Income> entry) =>
      into(incomes).insert(entry);

  // * updates an income transaction with a matching primary key
  // Future updateIncome(Income entry) => update(incomes).replace(entry);

  // * deletes an income transaction with a matching primary key
  Future deleteIncome(Insertable<Income> entry) =>
      delete(incomes).delete(entry);
}
