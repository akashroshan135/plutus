import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

/* --------------------------------------------------------------
  Main App Database
-------------------------------------------------------------- */
@UseMoor(
  tables: [Profiles, Incomes, Expenses, Pendings],
  daos: [ProfileDao, IncomeDao, ExpenseDao, PendingDao],
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

  // * returns income rows ordered by most recent
  Future<List<Income>> getAllIncome() => select(incomes).get();
  Stream<List<Income>> watchAllIncome() {
    return (select(incomes)
          ..orderBy([
            (row) => OrderingTerm(expression: row.date, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  // * streams income rows filtered by seleted date
  Stream<List<Income>> watchDayIncome(DateTime searchDate) {
    return (select(incomes)
          ..orderBy([
            (row) => OrderingTerm(expression: row.date, mode: OrderingMode.desc)
          ])
          ..where((row) => row.date.dateLocalEquals(searchDate)))
        .watch();
  }

  // * streams income rows filtered by seleted month and year
  Stream<List<Income>> watchMonthIncome(DateTime searchDate) {
    return (select(incomes)
          ..where((row) => row.date.dateYearMonthEquals(searchDate)))
        .watch();
  }

  // * adds an income transaction
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

  // * returns expense rows ordered by most recent
  Future<List<Expense>> getAllExpense() => select(expenses).get();
  Stream<List<Expense>> watchAllExpense() {
    return (select(expenses)
          ..orderBy([
            (row) => OrderingTerm(expression: row.date, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  // * streams expense rows filtered by seleted date
  Stream<List<Expense>> watchDayExpense(DateTime searchDate) {
    return (select(expenses)
          ..orderBy([
            (row) => OrderingTerm(expression: row.date, mode: OrderingMode.desc)
          ])
          ..where((row) => row.date.dateLocalEquals(searchDate)))
        .watch();
  }

  // * streams expense rows filtered by seleted month and year
  Stream<List<Expense>> watchMonthExpense(DateTime searchDate) {
    return (select(expenses)
          ..where((row) => row.date.dateYearMonthEquals(searchDate)))
        .watch();
  }

  // * adds an expense transaction
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
  Pendings Table and DAO
-------------------------------------------------------------- */
class Pendings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tags => text().withLength(min: 1, max: 50)();
  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();
  IntColumn get categoryIndex => integer()();
  TextColumn get type => text().withLength(min: 1, max: 10)();
}

@UseDao(tables: [Pendings])
class PendingDao extends DatabaseAccessor<AppDatabase> with _$PendingDaoMixin {
  final AppDatabase db;

  // * gets database object
  PendingDao(this.db) : super(db);

  // * returns pending rows ordered by most recent
  Future<List<Pending>> getAllPending() => select(pendings).get();
  Stream<List<Pending>> watchAllPending() {
    return (select(pendings)
          ..orderBy([
            (row) => OrderingTerm(expression: row.date, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  // * streams pending rows filtered by seleted date
  Stream<List<Pending>> watchDayPending(DateTime searchDate) {
    return (select(pendings)
          ..orderBy([
            (row) => OrderingTerm(expression: row.date, mode: OrderingMode.desc)
          ])
          ..where((row) => row.date.dateLocalEquals(searchDate)))
        .watch();
  }

  // * gets pending row filtered by id
  Future<Pending> getPending(int id) {
    return (select(pendings)..where((row) => row.id.equals(id))).getSingle();
  }

  // * adds an pending transaction
  Future<int> addPending(Insertable<Pending> entry) =>
      into(pendings).insert(entry);

  // * updates an pending transaction with a matching primary key
  Future updatePending(Insertable<Pending> entry) =>
      update(pendings).replace(entry);

  // * deletes an pending transaction with a matching primary key
  Future deletePending(Insertable<Pending> entry) =>
      delete(pendings).delete(entry);
}

// * converts the datetime in the db from UTC to Local
extension LocalDateTimeExpressions on Expression<DateTime> {
  Expression<String> get dateLocal {
    return FunctionCallExpression(
      'DATE', // or DATETIME for date + time
      [
        this,
        const Constant<String>('unixepoch'),
        const Constant<String>('localtime')
      ],
    );
  }
}

extension LocalCompareDateDB on GeneratedDateTimeColumn {
  // * checks if given date and db local time is equal
  Expression<bool> dateLocalEquals(DateTime value) {
    return this.dateLocal.equals(value.toIso8601String().substring(0, 10));
  }

  // * checks if given date's month and year and db local time is equal
  Expression<bool> dateYearMonthEquals(DateTime value) {
    return this.dateLocal.like('${value.toIso8601String().substring(0, 7)}%');
  }
}
