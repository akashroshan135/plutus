import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

/* --------------------------------------------------------------
  Main App Database
-------------------------------------------------------------- */
@UseMoor(
  tables: [Profiles, Incomes, Expenses, Upcomings],
  daos: [ProfileDao, IncomeDao, ExpenseDao, UpcomingDao],
)
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
  Profile Table and DAO
-------------------------------------------------------------- */
// * used to change the name of the database
// @DataClassName('Profiles')
class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  RealColumn get balance => real()();

  // * used to set primary keys. Not required as autoIncrement() sets key as primary
  // @override
  // Set<Column> get primaryKey => {id};
}

@UseDao(tables: [Profiles])
class ProfileDao extends DatabaseAccessor<AppDatabase> with _$ProfileDaoMixin {
  final AppDatabase db;

  // * gets database object
  ProfileDao(this.db) : super(db);

  // * returns profile rows
  Stream<List<Profile>> watchAllProfile() => select(profiles).watch();
  Future<List<Profile>> getAllProfile() => select(profiles).get();

  // * adds a new profile
  Future<int> addProfile(Insertable<Profile> entry) =>
      into(profiles).insert(entry);

  // * updates profile balance
  Future updateProfile(Insertable<Profile> entry) =>
      update(profiles).replace(entry);
}

/* --------------------------------------------------------------
  Income Table and DAO
-------------------------------------------------------------- */
class Incomes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tags => text().withLength(min: 1, max: 50)();
  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();
  IntColumn get categoryIndex => integer()();
}

@UseDao(tables: [Incomes])
class IncomeDao extends DatabaseAccessor<AppDatabase> with _$IncomeDaoMixin {
  final AppDatabase db;

  // * gets database object
  IncomeDao(this.db) : super(db);

  // * returns income rows
  Future<List<Income>> getAllIncome() => select(incomes).get();
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

  // * gets income rows filtered by seleted date
  Future<List<Income>> getMonthIncome(DateTime searchDate) {
    return (select(incomes)
          ..where((row) => row.date.month.equals(searchDate.month)))
        .get();
  }

  // * add an income transaction
  Future<int> addIncome(Insertable<Income> entry) =>
      into(incomes).insert(entry);

  // * updates an income transaction with a matching primary key
  Future updateIncome(Insertable<Income> entry) =>
      update(incomes).replace(entry);

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

  // * gets database object
  ExpenseDao(this.db) : super(db);

  // * returns expense rows
  Future<List<Expense>> getAllExpense() => select(expenses).get();
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

  // * gets expense rows filtered by seleted month
  Future<List<Expense>> getMonthExpense(DateTime searchDate) {
    return (select(expenses)
          ..where((row) => row.date.month.equals(searchDate.month)))
        .get();
  }

  // * add an expense transaction
  Future<int> addExpense(Insertable<Expense> entry) =>
      into(expenses).insert(entry);

  // * updates an expense transaction with a matching primary key
  Future updateExpense(Insertable<Expense> entry) =>
      update(expenses).replace(entry);

  // * deletes an expense transaction with a matching primary key
  Future deleteExpense(Insertable<Expense> entry) =>
      delete(expenses).delete(entry);
}

/* --------------------------------------------------------------
  Upcomings Table and DAO
-------------------------------------------------------------- */
class Upcomings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tags => text().withLength(min: 1, max: 50)();
  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();
  IntColumn get categoryIndex => integer()();
  TextColumn get type => text().withLength(min: 1, max: 10)();
}

@UseDao(tables: [Upcomings])
class UpcomingDao extends DatabaseAccessor<AppDatabase>
    with _$UpcomingDaoMixin {
  final AppDatabase db;

  // * gets database object
  UpcomingDao(this.db) : super(db);

  // * returns upcoming rows
  Future<List<Upcoming>> getAllUpcoming() => select(upcomings).get();
  Stream<List<Upcoming>> watchAllUpcoming() => select(upcomings).watch();

  // * streams upcoming rows filtered by seleted date
  Stream<List<Upcoming>> watchDayUpcoming(DateTime searchDate) {
    return (select(upcomings)
          ..where((row) =>
              row.date.day.equals(searchDate.day) &
              row.date.month.equals(searchDate.month) &
              row.date.year.equals(searchDate.year)))
        .watch();
  }

  // * add an upcoming transaction
  Future<int> addUpcoming(Insertable<Upcoming> entry) =>
      into(upcomings).insert(entry);

  // * updates an upcoming transaction with a matching primary key
  Future updateUpcoming(Insertable<Upcoming> entry) =>
      update(upcomings).replace(entry);

  // * deletes an upcoming transaction with a matching primary key
  Future deleteUpcoming(Insertable<Upcoming> entry) =>
      delete(upcomings).delete(entry);
}
