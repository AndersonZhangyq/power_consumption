// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $CarTable extends Car with TableInfo<$CarTable, CarData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _batterySizeMeta =
      const VerificationMeta('batterySize');
  @override
  late final GeneratedColumn<double> batterySize = GeneratedColumn<double>(
      'battery_size', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, batterySize];
  @override
  String get aliasedName => _alias ?? 'car';
  @override
  String get actualTableName => 'car';
  @override
  VerificationContext validateIntegrity(Insertable<CarData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('battery_size')) {
      context.handle(
          _batterySizeMeta,
          batterySize.isAcceptableOrUnknown(
              data['battery_size']!, _batterySizeMeta));
    } else if (isInserting) {
      context.missing(_batterySizeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CarData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      batterySize: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}battery_size'])!,
    );
  }

  @override
  $CarTable createAlias(String alias) {
    return $CarTable(attachedDatabase, alias);
  }
}

class CarData extends DataClass implements Insertable<CarData> {
  final int id;
  final String name;
  final double batterySize;
  const CarData(
      {required this.id, required this.name, required this.batterySize});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['battery_size'] = Variable<double>(batterySize);
    return map;
  }

  CarCompanion toCompanion(bool nullToAbsent) {
    return CarCompanion(
      id: Value(id),
      name: Value(name),
      batterySize: Value(batterySize),
    );
  }

  factory CarData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      batterySize: serializer.fromJson<double>(json['batterySize']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'batterySize': serializer.toJson<double>(batterySize),
    };
  }

  CarData copyWith({int? id, String? name, double? batterySize}) => CarData(
        id: id ?? this.id,
        name: name ?? this.name,
        batterySize: batterySize ?? this.batterySize,
      );
  @override
  String toString() {
    return (StringBuffer('CarData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('batterySize: $batterySize')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, batterySize);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarData &&
          other.id == this.id &&
          other.name == this.name &&
          other.batterySize == this.batterySize);
}

class CarCompanion extends UpdateCompanion<CarData> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> batterySize;
  const CarCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.batterySize = const Value.absent(),
  });
  CarCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double batterySize,
  })  : name = Value(name),
        batterySize = Value(batterySize);
  static Insertable<CarData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? batterySize,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (batterySize != null) 'battery_size': batterySize,
    });
  }

  CarCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<double>? batterySize}) {
    return CarCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      batterySize: batterySize ?? this.batterySize,
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
    if (batterySize.present) {
      map['battery_size'] = Variable<double>(batterySize.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('batterySize: $batterySize')
          ..write(')'))
        .toString();
  }
}

class $ChargeOrderTable extends ChargeOrder
    with TableInfo<$ChargeOrderTable, ChargeOrderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChargeOrderTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _carIdMeta = const VerificationMeta('carId');
  @override
  late final GeneratedColumn<int> carId = GeneratedColumn<int>(
      'car_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES car (id)'));
  static const VerificationMeta _drivingDistanceMeta =
      const VerificationMeta('drivingDistance');
  @override
  late final GeneratedColumn<int> drivingDistance = GeneratedColumn<int>(
      'driving_distance', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _powerRemainMeta =
      const VerificationMeta('powerRemain');
  @override
  late final GeneratedColumn<int> powerRemain = GeneratedColumn<int>(
      'power_remain', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chargeAmountMeta =
      const VerificationMeta('chargeAmount');
  @override
  late final GeneratedColumn<double> chargeAmount = GeneratedColumn<double>(
      'charge_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _chargePriceMeta =
      const VerificationMeta('chargePrice');
  @override
  late final GeneratedColumn<double> chargePrice = GeneratedColumn<double>(
      'charge_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _steelConsumptionMeta =
      const VerificationMeta('steelConsumption');
  @override
  late final GeneratedColumn<double> steelConsumption = GeneratedColumn<double>(
      'steel_consumption', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        carId,
        drivingDistance,
        powerRemain,
        chargeAmount,
        chargePrice,
        steelConsumption,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? 'charge_order';
  @override
  String get actualTableName => 'charge_order';
  @override
  VerificationContext validateIntegrity(Insertable<ChargeOrderData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('car_id')) {
      context.handle(
          _carIdMeta, carId.isAcceptableOrUnknown(data['car_id']!, _carIdMeta));
    } else if (isInserting) {
      context.missing(_carIdMeta);
    }
    if (data.containsKey('driving_distance')) {
      context.handle(
          _drivingDistanceMeta,
          drivingDistance.isAcceptableOrUnknown(
              data['driving_distance']!, _drivingDistanceMeta));
    } else if (isInserting) {
      context.missing(_drivingDistanceMeta);
    }
    if (data.containsKey('power_remain')) {
      context.handle(
          _powerRemainMeta,
          powerRemain.isAcceptableOrUnknown(
              data['power_remain']!, _powerRemainMeta));
    } else if (isInserting) {
      context.missing(_powerRemainMeta);
    }
    if (data.containsKey('charge_amount')) {
      context.handle(
          _chargeAmountMeta,
          chargeAmount.isAcceptableOrUnknown(
              data['charge_amount']!, _chargeAmountMeta));
    } else if (isInserting) {
      context.missing(_chargeAmountMeta);
    }
    if (data.containsKey('charge_price')) {
      context.handle(
          _chargePriceMeta,
          chargePrice.isAcceptableOrUnknown(
              data['charge_price']!, _chargePriceMeta));
    } else if (isInserting) {
      context.missing(_chargePriceMeta);
    }
    if (data.containsKey('steel_consumption')) {
      context.handle(
          _steelConsumptionMeta,
          steelConsumption.isAcceptableOrUnknown(
              data['steel_consumption']!, _steelConsumptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChargeOrderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChargeOrderData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      carId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}car_id'])!,
      drivingDistance: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}driving_distance'])!,
      powerRemain: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}power_remain'])!,
      chargeAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}charge_amount'])!,
      chargePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}charge_price'])!,
      steelConsumption: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}steel_consumption']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ChargeOrderTable createAlias(String alias) {
    return $ChargeOrderTable(attachedDatabase, alias);
  }
}

class ChargeOrderData extends DataClass implements Insertable<ChargeOrderData> {
  final int id;
  final int carId;
  final int drivingDistance;
  final int powerRemain;
  final double chargeAmount;
  final double chargePrice;
  final double? steelConsumption;
  final DateTime createdAt;
  const ChargeOrderData(
      {required this.id,
      required this.carId,
      required this.drivingDistance,
      required this.powerRemain,
      required this.chargeAmount,
      required this.chargePrice,
      this.steelConsumption,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['car_id'] = Variable<int>(carId);
    map['driving_distance'] = Variable<int>(drivingDistance);
    map['power_remain'] = Variable<int>(powerRemain);
    map['charge_amount'] = Variable<double>(chargeAmount);
    map['charge_price'] = Variable<double>(chargePrice);
    if (!nullToAbsent || steelConsumption != null) {
      map['steel_consumption'] = Variable<double>(steelConsumption);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChargeOrderCompanion toCompanion(bool nullToAbsent) {
    return ChargeOrderCompanion(
      id: Value(id),
      carId: Value(carId),
      drivingDistance: Value(drivingDistance),
      powerRemain: Value(powerRemain),
      chargeAmount: Value(chargeAmount),
      chargePrice: Value(chargePrice),
      steelConsumption: steelConsumption == null && nullToAbsent
          ? const Value.absent()
          : Value(steelConsumption),
      createdAt: Value(createdAt),
    );
  }

  factory ChargeOrderData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChargeOrderData(
      id: serializer.fromJson<int>(json['id']),
      carId: serializer.fromJson<int>(json['carId']),
      drivingDistance: serializer.fromJson<int>(json['drivingDistance']),
      powerRemain: serializer.fromJson<int>(json['powerRemain']),
      chargeAmount: serializer.fromJson<double>(json['chargeAmount']),
      chargePrice: serializer.fromJson<double>(json['chargePrice']),
      steelConsumption: serializer.fromJson<double?>(json['steelConsumption']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'carId': serializer.toJson<int>(carId),
      'drivingDistance': serializer.toJson<int>(drivingDistance),
      'powerRemain': serializer.toJson<int>(powerRemain),
      'chargeAmount': serializer.toJson<double>(chargeAmount),
      'chargePrice': serializer.toJson<double>(chargePrice),
      'steelConsumption': serializer.toJson<double?>(steelConsumption),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChargeOrderData copyWith(
          {int? id,
          int? carId,
          int? drivingDistance,
          int? powerRemain,
          double? chargeAmount,
          double? chargePrice,
          Value<double?> steelConsumption = const Value.absent(),
          DateTime? createdAt}) =>
      ChargeOrderData(
        id: id ?? this.id,
        carId: carId ?? this.carId,
        drivingDistance: drivingDistance ?? this.drivingDistance,
        powerRemain: powerRemain ?? this.powerRemain,
        chargeAmount: chargeAmount ?? this.chargeAmount,
        chargePrice: chargePrice ?? this.chargePrice,
        steelConsumption: steelConsumption.present
            ? steelConsumption.value
            : this.steelConsumption,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('ChargeOrderData(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('drivingDistance: $drivingDistance, ')
          ..write('powerRemain: $powerRemain, ')
          ..write('chargeAmount: $chargeAmount, ')
          ..write('chargePrice: $chargePrice, ')
          ..write('steelConsumption: $steelConsumption, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, carId, drivingDistance, powerRemain,
      chargeAmount, chargePrice, steelConsumption, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChargeOrderData &&
          other.id == this.id &&
          other.carId == this.carId &&
          other.drivingDistance == this.drivingDistance &&
          other.powerRemain == this.powerRemain &&
          other.chargeAmount == this.chargeAmount &&
          other.chargePrice == this.chargePrice &&
          other.steelConsumption == this.steelConsumption &&
          other.createdAt == this.createdAt);
}

class ChargeOrderCompanion extends UpdateCompanion<ChargeOrderData> {
  final Value<int> id;
  final Value<int> carId;
  final Value<int> drivingDistance;
  final Value<int> powerRemain;
  final Value<double> chargeAmount;
  final Value<double> chargePrice;
  final Value<double?> steelConsumption;
  final Value<DateTime> createdAt;
  const ChargeOrderCompanion({
    this.id = const Value.absent(),
    this.carId = const Value.absent(),
    this.drivingDistance = const Value.absent(),
    this.powerRemain = const Value.absent(),
    this.chargeAmount = const Value.absent(),
    this.chargePrice = const Value.absent(),
    this.steelConsumption = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ChargeOrderCompanion.insert({
    this.id = const Value.absent(),
    required int carId,
    required int drivingDistance,
    required int powerRemain,
    required double chargeAmount,
    required double chargePrice,
    this.steelConsumption = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : carId = Value(carId),
        drivingDistance = Value(drivingDistance),
        powerRemain = Value(powerRemain),
        chargeAmount = Value(chargeAmount),
        chargePrice = Value(chargePrice);
  static Insertable<ChargeOrderData> custom({
    Expression<int>? id,
    Expression<int>? carId,
    Expression<int>? drivingDistance,
    Expression<int>? powerRemain,
    Expression<double>? chargeAmount,
    Expression<double>? chargePrice,
    Expression<double>? steelConsumption,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (carId != null) 'car_id': carId,
      if (drivingDistance != null) 'driving_distance': drivingDistance,
      if (powerRemain != null) 'power_remain': powerRemain,
      if (chargeAmount != null) 'charge_amount': chargeAmount,
      if (chargePrice != null) 'charge_price': chargePrice,
      if (steelConsumption != null) 'steel_consumption': steelConsumption,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ChargeOrderCompanion copyWith(
      {Value<int>? id,
      Value<int>? carId,
      Value<int>? drivingDistance,
      Value<int>? powerRemain,
      Value<double>? chargeAmount,
      Value<double>? chargePrice,
      Value<double?>? steelConsumption,
      Value<DateTime>? createdAt}) {
    return ChargeOrderCompanion(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      drivingDistance: drivingDistance ?? this.drivingDistance,
      powerRemain: powerRemain ?? this.powerRemain,
      chargeAmount: chargeAmount ?? this.chargeAmount,
      chargePrice: chargePrice ?? this.chargePrice,
      steelConsumption: steelConsumption ?? this.steelConsumption,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (carId.present) {
      map['car_id'] = Variable<int>(carId.value);
    }
    if (drivingDistance.present) {
      map['driving_distance'] = Variable<int>(drivingDistance.value);
    }
    if (powerRemain.present) {
      map['power_remain'] = Variable<int>(powerRemain.value);
    }
    if (chargeAmount.present) {
      map['charge_amount'] = Variable<double>(chargeAmount.value);
    }
    if (chargePrice.present) {
      map['charge_price'] = Variable<double>(chargePrice.value);
    }
    if (steelConsumption.present) {
      map['steel_consumption'] = Variable<double>(steelConsumption.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChargeOrderCompanion(')
          ..write('id: $id, ')
          ..write('carId: $carId, ')
          ..write('drivingDistance: $drivingDistance, ')
          ..write('powerRemain: $powerRemain, ')
          ..write('chargeAmount: $chargeAmount, ')
          ..write('chargePrice: $chargePrice, ')
          ..write('steelConsumption: $steelConsumption, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  late final $CarTable car = $CarTable(this);
  late final $ChargeOrderTable chargeOrder = $ChargeOrderTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [car, chargeOrder];
}
