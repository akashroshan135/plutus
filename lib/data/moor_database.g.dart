// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String name;
  final double balance;
  Profile({@required this.id, @required this.name, @required this.balance});
  factory Profile.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Profile(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      balance:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}balance']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || balance != null) {
      map['balance'] = Variable<double>(balance);
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      balance: balance == null && nullToAbsent
          ? const Value.absent()
          : Value(balance),
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      balance: serializer.fromJson<double>(json['balance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'balance': serializer.toJson<double>(balance),
    };
  }

  Profile copyWith({int id, String name, double balance}) => Profile(
        id: id ?? this.id,
        name: name ?? this.name,
        balance: balance ?? this.balance,
      );
  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balance: $balance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, balance.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.name == this.name &&
          other.balance == this.balance);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> balance;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.balance = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required double balance,
  })  : name = Value(name),
        balance = Value(balance);
  static Insertable<Profile> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<double> balance,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (balance != null) 'balance': balance,
    });
  }

  ProfilesCompanion copyWith(
      {Value<int> id, Value<String> name, Value<double> balance}) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('balance: $balance')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  final GeneratedDatabase _db;
  final String _alias;
  $ProfilesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false,
        minTextLength: 1, maxTextLength: 50);
  }

  final VerificationMeta _balanceMeta = const VerificationMeta('balance');
  GeneratedRealColumn _balance;
  @override
  GeneratedRealColumn get balance => _balance ??= _constructBalance();
  GeneratedRealColumn _constructBalance() {
    return GeneratedRealColumn(
      'balance',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, balance];
  @override
  $ProfilesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'profiles';
  @override
  final String actualTableName = 'profiles';
  @override
  VerificationContext validateIntegrity(Insertable<Profile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance'], _balanceMeta));
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Profile.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(_db, alias);
  }
}

class Income extends DataClass implements Insertable<Income> {
  final int id;
  final String tags;
  final DateTime date;
  final double amount;
  final int categoryIndex;
  Income(
      {@required this.id,
      @required this.tags,
      @required this.date,
      @required this.amount,
      @required this.categoryIndex});
  factory Income.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Income(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      tags: stringType.mapFromDatabaseResponse(data['${effectivePrefix}tags']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      amount:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}amount']),
      categoryIndex: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_index']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || categoryIndex != null) {
      map['category_index'] = Variable<int>(categoryIndex);
    }
    return map;
  }

  IncomesCompanion toCompanion(bool nullToAbsent) {
    return IncomesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      categoryIndex: categoryIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryIndex),
    );
  }

  factory Income.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Income(
      id: serializer.fromJson<int>(json['id']),
      tags: serializer.fromJson<String>(json['tags']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<double>(json['amount']),
      categoryIndex: serializer.fromJson<int>(json['categoryIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tags': serializer.toJson<String>(tags),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<double>(amount),
      'categoryIndex': serializer.toJson<int>(categoryIndex),
    };
  }

  Income copyWith(
          {int id,
          String tags,
          DateTime date,
          double amount,
          int categoryIndex}) =>
      Income(
        id: id ?? this.id,
        tags: tags ?? this.tags,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        categoryIndex: categoryIndex ?? this.categoryIndex,
      );
  @override
  String toString() {
    return (StringBuffer('Income(')
          ..write('id: $id, ')
          ..write('tags: $tags, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('categoryIndex: $categoryIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          tags.hashCode,
          $mrjc(
              date.hashCode, $mrjc(amount.hashCode, categoryIndex.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Income &&
          other.id == this.id &&
          other.tags == this.tags &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.categoryIndex == this.categoryIndex);
}

class IncomesCompanion extends UpdateCompanion<Income> {
  final Value<int> id;
  final Value<String> tags;
  final Value<DateTime> date;
  final Value<double> amount;
  final Value<int> categoryIndex;
  const IncomesCompanion({
    this.id = const Value.absent(),
    this.tags = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.categoryIndex = const Value.absent(),
  });
  IncomesCompanion.insert({
    this.id = const Value.absent(),
    @required String tags,
    @required DateTime date,
    @required double amount,
    @required int categoryIndex,
  })  : tags = Value(tags),
        date = Value(date),
        amount = Value(amount),
        categoryIndex = Value(categoryIndex);
  static Insertable<Income> custom({
    Expression<int> id,
    Expression<String> tags,
    Expression<DateTime> date,
    Expression<double> amount,
    Expression<int> categoryIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tags != null) 'tags': tags,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (categoryIndex != null) 'category_index': categoryIndex,
    });
  }

  IncomesCompanion copyWith(
      {Value<int> id,
      Value<String> tags,
      Value<DateTime> date,
      Value<double> amount,
      Value<int> categoryIndex}) {
    return IncomesCompanion(
      id: id ?? this.id,
      tags: tags ?? this.tags,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      categoryIndex: categoryIndex ?? this.categoryIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (categoryIndex.present) {
      map['category_index'] = Variable<int>(categoryIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomesCompanion(')
          ..write('id: $id, ')
          ..write('tags: $tags, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('categoryIndex: $categoryIndex')
          ..write(')'))
        .toString();
  }
}

class $IncomesTable extends Incomes with TableInfo<$IncomesTable, Income> {
  final GeneratedDatabase _db;
  final String _alias;
  $IncomesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _tagsMeta = const VerificationMeta('tags');
  GeneratedTextColumn _tags;
  @override
  GeneratedTextColumn get tags => _tags ??= _constructTags();
  GeneratedTextColumn _constructTags() {
    return GeneratedTextColumn('tags', $tableName, false,
        minTextLength: 1, maxTextLength: 50);
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  GeneratedRealColumn _amount;
  @override
  GeneratedRealColumn get amount => _amount ??= _constructAmount();
  GeneratedRealColumn _constructAmount() {
    return GeneratedRealColumn(
      'amount',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryIndexMeta =
      const VerificationMeta('categoryIndex');
  GeneratedIntColumn _categoryIndex;
  @override
  GeneratedIntColumn get categoryIndex =>
      _categoryIndex ??= _constructCategoryIndex();
  GeneratedIntColumn _constructCategoryIndex() {
    return GeneratedIntColumn(
      'category_index',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, tags, date, amount, categoryIndex];
  @override
  $IncomesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'incomes';
  @override
  final String actualTableName = 'incomes';
  @override
  VerificationContext validateIntegrity(Insertable<Income> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags'], _tagsMeta));
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount'], _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category_index')) {
      context.handle(
          _categoryIndexMeta,
          categoryIndex.isAcceptableOrUnknown(
              data['category_index'], _categoryIndexMeta));
    } else if (isInserting) {
      context.missing(_categoryIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Income map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Income.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $IncomesTable createAlias(String alias) {
    return $IncomesTable(_db, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final String tags;
  final DateTime date;
  final double amount;
  final int categoryIndex;
  Expense(
      {@required this.id,
      @required this.tags,
      @required this.date,
      @required this.amount,
      @required this.categoryIndex});
  factory Expense.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Expense(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      tags: stringType.mapFromDatabaseResponse(data['${effectivePrefix}tags']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      amount:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}amount']),
      categoryIndex: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_index']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || categoryIndex != null) {
      map['category_index'] = Variable<int>(categoryIndex);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      categoryIndex: categoryIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryIndex),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      tags: serializer.fromJson<String>(json['tags']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<double>(json['amount']),
      categoryIndex: serializer.fromJson<int>(json['categoryIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tags': serializer.toJson<String>(tags),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<double>(amount),
      'categoryIndex': serializer.toJson<int>(categoryIndex),
    };
  }

  Expense copyWith(
          {int id,
          String tags,
          DateTime date,
          double amount,
          int categoryIndex}) =>
      Expense(
        id: id ?? this.id,
        tags: tags ?? this.tags,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        categoryIndex: categoryIndex ?? this.categoryIndex,
      );
  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('tags: $tags, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('categoryIndex: $categoryIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          tags.hashCode,
          $mrjc(
              date.hashCode, $mrjc(amount.hashCode, categoryIndex.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.tags == this.tags &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.categoryIndex == this.categoryIndex);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<String> tags;
  final Value<DateTime> date;
  final Value<double> amount;
  final Value<int> categoryIndex;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.tags = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.categoryIndex = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    @required String tags,
    @required DateTime date,
    @required double amount,
    @required int categoryIndex,
  })  : tags = Value(tags),
        date = Value(date),
        amount = Value(amount),
        categoryIndex = Value(categoryIndex);
  static Insertable<Expense> custom({
    Expression<int> id,
    Expression<String> tags,
    Expression<DateTime> date,
    Expression<double> amount,
    Expression<int> categoryIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tags != null) 'tags': tags,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (categoryIndex != null) 'category_index': categoryIndex,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int> id,
      Value<String> tags,
      Value<DateTime> date,
      Value<double> amount,
      Value<int> categoryIndex}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      tags: tags ?? this.tags,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      categoryIndex: categoryIndex ?? this.categoryIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (categoryIndex.present) {
      map['category_index'] = Variable<int>(categoryIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('tags: $tags, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('categoryIndex: $categoryIndex')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  final GeneratedDatabase _db;
  final String _alias;
  $ExpensesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _tagsMeta = const VerificationMeta('tags');
  GeneratedTextColumn _tags;
  @override
  GeneratedTextColumn get tags => _tags ??= _constructTags();
  GeneratedTextColumn _constructTags() {
    return GeneratedTextColumn('tags', $tableName, false,
        minTextLength: 1, maxTextLength: 50);
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  GeneratedRealColumn _amount;
  @override
  GeneratedRealColumn get amount => _amount ??= _constructAmount();
  GeneratedRealColumn _constructAmount() {
    return GeneratedRealColumn(
      'amount',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryIndexMeta =
      const VerificationMeta('categoryIndex');
  GeneratedIntColumn _categoryIndex;
  @override
  GeneratedIntColumn get categoryIndex =>
      _categoryIndex ??= _constructCategoryIndex();
  GeneratedIntColumn _constructCategoryIndex() {
    return GeneratedIntColumn(
      'category_index',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, tags, date, amount, categoryIndex];
  @override
  $ExpensesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'expenses';
  @override
  final String actualTableName = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags'], _tagsMeta));
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount'], _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category_index')) {
      context.handle(
          _categoryIndexMeta,
          categoryIndex.isAcceptableOrUnknown(
              data['category_index'], _categoryIndexMeta));
    } else if (isInserting) {
      context.missing(_categoryIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Expense.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(_db, alias);
  }
}

class Upcoming extends DataClass implements Insertable<Upcoming> {
  final int id;
  final String tags;
  final DateTime date;
  final double amount;
  final int categoryIndex;
  final String type;
  Upcoming(
      {@required this.id,
      @required this.tags,
      @required this.date,
      @required this.amount,
      @required this.categoryIndex,
      @required this.type});
  factory Upcoming.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final doubleType = db.typeSystem.forDartType<double>();
    return Upcoming(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      tags: stringType.mapFromDatabaseResponse(data['${effectivePrefix}tags']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      amount:
          doubleType.mapFromDatabaseResponse(data['${effectivePrefix}amount']),
      categoryIndex: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}category_index']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || categoryIndex != null) {
      map['category_index'] = Variable<int>(categoryIndex);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    return map;
  }

  UpcomingsCompanion toCompanion(bool nullToAbsent) {
    return UpcomingsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      categoryIndex: categoryIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryIndex),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
    );
  }

  factory Upcoming.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Upcoming(
      id: serializer.fromJson<int>(json['id']),
      tags: serializer.fromJson<String>(json['tags']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<double>(json['amount']),
      categoryIndex: serializer.fromJson<int>(json['categoryIndex']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tags': serializer.toJson<String>(tags),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<double>(amount),
      'categoryIndex': serializer.toJson<int>(categoryIndex),
      'type': serializer.toJson<String>(type),
    };
  }

  Upcoming copyWith(
          {int id,
          String tags,
          DateTime date,
          double amount,
          int categoryIndex,
          String type}) =>
      Upcoming(
        id: id ?? this.id,
        tags: tags ?? this.tags,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        categoryIndex: categoryIndex ?? this.categoryIndex,
        type: type ?? this.type,
      );
  @override
  String toString() {
    return (StringBuffer('Upcoming(')
          ..write('id: $id, ')
          ..write('tags: $tags, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('categoryIndex: $categoryIndex, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          tags.hashCode,
          $mrjc(
              date.hashCode,
              $mrjc(amount.hashCode,
                  $mrjc(categoryIndex.hashCode, type.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Upcoming &&
          other.id == this.id &&
          other.tags == this.tags &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.categoryIndex == this.categoryIndex &&
          other.type == this.type);
}

class UpcomingsCompanion extends UpdateCompanion<Upcoming> {
  final Value<int> id;
  final Value<String> tags;
  final Value<DateTime> date;
  final Value<double> amount;
  final Value<int> categoryIndex;
  final Value<String> type;
  const UpcomingsCompanion({
    this.id = const Value.absent(),
    this.tags = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.categoryIndex = const Value.absent(),
    this.type = const Value.absent(),
  });
  UpcomingsCompanion.insert({
    this.id = const Value.absent(),
    @required String tags,
    @required DateTime date,
    @required double amount,
    @required int categoryIndex,
    @required String type,
  })  : tags = Value(tags),
        date = Value(date),
        amount = Value(amount),
        categoryIndex = Value(categoryIndex),
        type = Value(type);
  static Insertable<Upcoming> custom({
    Expression<int> id,
    Expression<String> tags,
    Expression<DateTime> date,
    Expression<double> amount,
    Expression<int> categoryIndex,
    Expression<String> type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tags != null) 'tags': tags,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (categoryIndex != null) 'category_index': categoryIndex,
      if (type != null) 'type': type,
    });
  }

  UpcomingsCompanion copyWith(
      {Value<int> id,
      Value<String> tags,
      Value<DateTime> date,
      Value<double> amount,
      Value<int> categoryIndex,
      Value<String> type}) {
    return UpcomingsCompanion(
      id: id ?? this.id,
      tags: tags ?? this.tags,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      categoryIndex: categoryIndex ?? this.categoryIndex,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (categoryIndex.present) {
      map['category_index'] = Variable<int>(categoryIndex.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UpcomingsCompanion(')
          ..write('id: $id, ')
          ..write('tags: $tags, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('categoryIndex: $categoryIndex, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $UpcomingsTable extends Upcomings
    with TableInfo<$UpcomingsTable, Upcoming> {
  final GeneratedDatabase _db;
  final String _alias;
  $UpcomingsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _tagsMeta = const VerificationMeta('tags');
  GeneratedTextColumn _tags;
  @override
  GeneratedTextColumn get tags => _tags ??= _constructTags();
  GeneratedTextColumn _constructTags() {
    return GeneratedTextColumn('tags', $tableName, false,
        minTextLength: 1, maxTextLength: 50);
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  GeneratedRealColumn _amount;
  @override
  GeneratedRealColumn get amount => _amount ??= _constructAmount();
  GeneratedRealColumn _constructAmount() {
    return GeneratedRealColumn(
      'amount',
      $tableName,
      false,
    );
  }

  final VerificationMeta _categoryIndexMeta =
      const VerificationMeta('categoryIndex');
  GeneratedIntColumn _categoryIndex;
  @override
  GeneratedIntColumn get categoryIndex =>
      _categoryIndex ??= _constructCategoryIndex();
  GeneratedIntColumn _constructCategoryIndex() {
    return GeneratedIntColumn(
      'category_index',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn('type', $tableName, false,
        minTextLength: 1, maxTextLength: 10);
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, tags, date, amount, categoryIndex, type];
  @override
  $UpcomingsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'upcomings';
  @override
  final String actualTableName = 'upcomings';
  @override
  VerificationContext validateIntegrity(Insertable<Upcoming> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags'], _tagsMeta));
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount'], _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category_index')) {
      context.handle(
          _categoryIndexMeta,
          categoryIndex.isAcceptableOrUnknown(
              data['category_index'], _categoryIndexMeta));
    } else if (isInserting) {
      context.missing(_categoryIndexMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type'], _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Upcoming map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Upcoming.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $UpcomingsTable createAlias(String alias) {
    return $UpcomingsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $ProfilesTable _profiles;
  $ProfilesTable get profiles => _profiles ??= $ProfilesTable(this);
  $IncomesTable _incomes;
  $IncomesTable get incomes => _incomes ??= $IncomesTable(this);
  $ExpensesTable _expenses;
  $ExpensesTable get expenses => _expenses ??= $ExpensesTable(this);
  $UpcomingsTable _upcomings;
  $UpcomingsTable get upcomings => _upcomings ??= $UpcomingsTable(this);
  ProfileDao _profileDao;
  ProfileDao get profileDao => _profileDao ??= ProfileDao(this as AppDatabase);
  IncomeDao _incomeDao;
  IncomeDao get incomeDao => _incomeDao ??= IncomeDao(this as AppDatabase);
  ExpenseDao _expenseDao;
  ExpenseDao get expenseDao => _expenseDao ??= ExpenseDao(this as AppDatabase);
  UpcomingDao _upcomingDao;
  UpcomingDao get upcomingDao =>
      _upcomingDao ??= UpcomingDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [profiles, incomes, expenses, upcomings];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProfilesTable get profiles => attachedDatabase.profiles;
}
mixin _$IncomeDaoMixin on DatabaseAccessor<AppDatabase> {
  $IncomesTable get incomes => attachedDatabase.incomes;
}
mixin _$ExpenseDaoMixin on DatabaseAccessor<AppDatabase> {
  $ExpensesTable get expenses => attachedDatabase.expenses;
}
mixin _$UpcomingDaoMixin on DatabaseAccessor<AppDatabase> {
  $UpcomingsTable get upcomings => attachedDatabase.upcomings;
}
