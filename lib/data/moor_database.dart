import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

// * used to change the name of the database
// @DataClassName('Incomes')
class Incomes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tags => text().withLength(min: 1, max: 50)();
  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();

  // * used to set primary keys. Not required as autoIncrement() sets key as primary
  // @override
  // Set<Column> get primaryKey => {id};
}

@UseMoor(tables: [Incomes])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
          path: 'db.sqlite',
          logStatements: true,
        ));

  @override
  int get schemaVersion => 1;

  Future<List<Income>> getAllIncome() => select(incomes).get();
  Stream<List<Income>> watchAllIncome() => select(incomes).watch();

  // * add an income transaction
  Future<int> addIncome(IncomesCompanion entry) => into(incomes).insert(entry);

  // * updates an income transaction with a matching primary key
  // Future updateIncome(Income entry) => update(incomes).replace(entry);

  // * deletes an income transaction with a matching primary key
  Future deleteIncome(Income entry) => delete(incomes).delete(entry);
}
