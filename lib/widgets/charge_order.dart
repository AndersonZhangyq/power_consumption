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
  final TextEditingController powerRemainController = TextEditingController();
  final TextEditingController chargeAmountController = TextEditingController();
  final TextEditingController chargePriceController = TextEditingController();

  final _addChargeOrderFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (chargeOrder != null) {
      drivingDistanceController.text = chargeOrder!.drivingDistance.toString();
      powerRemainController.text = chargeOrder!.powerRemain.toString();
      chargeAmountController.text = chargeOrder!.chargeAmount.toString();
      chargePriceController.text = chargeOrder!.chargePrice.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            chargeOrder == null ? 'Create ChargeOrder' : 'Modify ChargeOrder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_addChargeOrderFormKey.currentState!.validate()) {
                int drivingDistance = int.parse(drivingDistanceController.text);
                int powerRemain = int.parse(powerRemainController.text);
                double chargeAmount = double.parse(chargeAmountController.text);
                double chargePrice = double.parse(chargePriceController.text);
                if (chargeOrder == null) {
                  db.into(db.chargeOrder).insert(ChargeOrderCompanion.insert(
                      carId: selectedCar.id,
                      drivingDistance: drivingDistance,
                      powerRemain: powerRemain,
                      chargeAmount: chargeAmount,
                      chargePrice: chargePrice,
                      steelConsumption: drift.Value(chargeAmount -
                          selectedCar.batterySize * powerRemain / 100)));
                } else {
                  db.update(db.chargeOrder).replace(
                        ChargeOrderCompanion(
                            id: drift.Value(chargeOrder!.id),
                            carId: drift.Value(selectedCar.id),
                            drivingDistance: drift.Value(drivingDistance),
                            powerRemain: drift.Value(powerRemain),
                            chargeAmount: drift.Value(chargeAmount),
                            chargePrice: drift.Value(chargePrice),
                            steelConsumption: drift.Value(chargeAmount -
                                selectedCar.batterySize * powerRemain / 100)),
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
                    controller: powerRemainController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a power remain';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Power remain',
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
