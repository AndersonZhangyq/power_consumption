import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'db.g.dart';

class Car extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  RealColumn get batterySize => real()();
}

class ChargeOrder extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get carId => integer().references(Car, #id)();

  RealColumn get drivingDistance => real()();

  IntColumn get powerBeforeCharge => integer()();

  IntColumn get powerAfterCharge => integer()();

  RealColumn get chargeAmount => real()();

  RealColumn get chargePrice => real()();

  RealColumn get steelConsumption => real().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'powerconsumption.db'));
    return NativeDatabase(file, logStatements: true);
  });
}

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [ChargeOrder, Car])
class MyDatabase extends _$MyDatabase {
  // we tell the database where to store the data with this constructor
  MyDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    });
  }

  Stream<List<CarData>>? getCarList() {
    return select(car).watch();
  }

  Stream<List<ChargeOrderData>>? getChargeOrderList(int carId) {
    return (select(chargeOrder)
          ..where((tbl) => tbl.carId.equals(carId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .watch();
  }
}
