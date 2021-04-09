import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

/* --------------------------------------------------------------
  Main App Database
-------------------------------------------------------------- */
@UseMoor(tables: [Incomes, Expenses], daos: [IncomeDao, ExpenseDao])
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
  Income Table and DAO
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

@UseDao(tables: [Incomes])
class IncomeDao extends DatabaseAccessor<AppDatabase> with _$IncomeDaoMixin {
  final AppDatabase db;

  // * Called by the AppDatabase class
  IncomeDao(this.db) : super(db);

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

/* --------------------------------------------------------------
  Expense Table and DAO
-------------------------------------------------------------- */
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tags => text().withLength(min: 1, max: 50)();
  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();
  IntColumn get categoryIndex => integer()();
}

@UseDao(tables: [Expenses])
class ExpenseDao extends DatabaseAccessor<AppDatabase> with _$ExpenseDaoMixin {
  final AppDatabase db;

  // * Called by the AppDatabase class
  ExpenseDao(this.db) : super(db);

  Future<List<Expense>> getAllExpense() => select(expenses).get();
  // * streams all income rows
  Stream<List<Expense>> watchAllExpense() => select(expenses).watch();
  // * streams expense rows filtered by seleted date
  Stream<List<Expense>> watchDayExpense(DateTime searchDate) {
    return (select(expenses)
          ..where((row) =>
              row.date.day.equals(searchDate.day) &
              row.date.month.equals(searchDate.month) &
              row.date.year.equals(searchDate.year)))
        .watch();
  }

  // * add an expense transaction
  Future<int> addExpense(Insertable<Expense> entry) =>
      into(expenses).insert(entry);

  // * updates an expense transaction with a matching primary key
  // Future updateExpense(Expense entry) => update(expenses).replace(entry);

  // * deletes an expense transaction with a matching primary key
  Future deleteExpense(Insertable<Expense> entry) =>
      delete(expenses).delete(entry);
}
