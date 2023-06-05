import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

import '../database/db.dart';

class ChargeOrderWidget extends StatelessWidget {
  ChargeOrderWidget(
      {super.key,
      required this.selectedCar,
      required this.db,
      this.chargeOrder});
  final CarData selectedCar;
  final ChargeOrderData? chargeOrder;
  final MyDatabase db;
  final TextEditingController drivingDistanceController =
      TextEditingController();
  final TextEditingController powerBeforeChargeController =
      TextEditingController();
  final TextEditingController powerAfterChargeController =
      TextEditingController();
  final TextEditingController chargeAmountController = TextEditingController();
  final TextEditingController chargePriceController = TextEditingController();

  final _addChargeOrderFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (chargeOrder != null) {
      drivingDistanceController.text = chargeOrder!.drivingDistance.toString();
      powerBeforeChargeController.text =
          chargeOrder!.powerBeforeCharge.toString();
      powerAfterChargeController.text =
          chargeOrder!.powerAfterCharge.toString();
      chargeAmountController.text = chargeOrder!.chargeAmount.toString();
      chargePriceController.text = chargeOrder!.chargePrice.toString();
    }
    return Scaffold(
      floatingActionButton: chargeOrder == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text('Delete Charge Order'),
                          content: const Text(
                              'Are you sure you want to delete this charge order?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                db.delete(db.chargeOrder).delete(chargeOrder!);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Delete'),
                            ),
                          ]);
                    });
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete),
            ),
      appBar: AppBar(
        title: Text(chargeOrder == null
            ? 'Create Charge Order'
            : 'Modify Charge Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_addChargeOrderFormKey.currentState!.validate()) {
                double drivingDistance =
                    double.parse(drivingDistanceController.text);
                int powerBeforeCharge =
                    int.parse(powerBeforeChargeController.text);
                int powerAfterCharge =
                    int.parse(powerAfterChargeController.text);
                double chargeAmount = double.parse(chargeAmountController.text);
                double chargePrice = double.parse(chargePriceController.text);
                if (chargeOrder == null) {
                  db.into(db.chargeOrder).insert(ChargeOrderCompanion.insert(
                      carId: selectedCar.id,
                      drivingDistance: drivingDistance,
                      powerBeforeCharge: powerBeforeCharge,
                      powerAfterCharge: powerAfterCharge,
                      chargeAmount: chargeAmount,
                      chargePrice: chargePrice,
                      steelConsumption: drift.Value(100 -
                          selectedCar.batterySize *
                              (powerAfterCharge - powerBeforeCharge) /
                              chargeAmount)));
                } else {
                  db.update(db.chargeOrder).replace(
                        ChargeOrderCompanion(
                            id: drift.Value(chargeOrder!.id),
                            carId: drift.Value(selectedCar.id),
                            drivingDistance: drift.Value(drivingDistance),
                            powerBeforeCharge: drift.Value(powerBeforeCharge),
                            powerAfterCharge: drift.Value(powerAfterCharge),
                            chargeAmount: drift.Value(chargeAmount),
                            chargePrice: drift.Value(chargePrice),
                            steelConsumption: drift.Value(100 -
                                selectedCar.batterySize *
                                    (powerAfterCharge - powerBeforeCharge) /
                                    chargeAmount)),
                      );
                }
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _addChargeOrderFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: drivingDistanceController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a driving distance';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Driving distance',
                        suffixText: "km",
                        prefixIcon: Icon(Icons.cable_rounded)),
                  ),
                  TextFormField(
                    controller: powerBeforeChargeController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a percent of power before charge';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Power before charge',
                        suffixText: "%",
                        prefixIcon: Icon(Icons.battery_4_bar)),
                  ),
                  TextFormField(
                    controller: powerAfterChargeController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a percent of power after charge';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Power after charge',
                        suffixText: "%",
                        prefixIcon: Icon(Icons.battery_4_bar)),
                  ),
                  TextFormField(
                    controller: chargeAmountController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a charge amount';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Charge amount',
                        suffixText: "kWh",
                        prefixIcon: Icon(Icons.ev_station)),
                  ),
                  TextFormField(
                    controller: chargePriceController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a charge price';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Charge price',
                        suffixText: '¥',
                        prefixIcon: Icon(Icons.attach_money)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
