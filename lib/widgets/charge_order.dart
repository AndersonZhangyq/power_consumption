import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:power_consumption/moneyNumberTablet.dart';

import '../database/db.dart';

class ChargeOrderWidget extends StatefulWidget {
  const ChargeOrderWidget(
      {super.key,
      required this.selectedCar,
      required this.db,
      this.chargeOrder});
  final CarData selectedCar;
  final ChargeOrderData? chargeOrder;
  final MyDatabase db;

  @override
  State<ChargeOrderWidget> createState() => _ChargeOrderWidgetState();
}

class _ChargeOrderWidgetState extends State<ChargeOrderWidget> {
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
  void initState() {
    super.initState();
    if (widget.chargeOrder != null) {
      drivingDistanceController.text =
          widget.chargeOrder!.drivingDistance.toString();
      powerBeforeChargeController.text =
          widget.chargeOrder!.powerBeforeCharge.toString();
      powerAfterChargeController.text =
          widget.chargeOrder!.powerAfterCharge.toString();
      chargeAmountController.text = widget.chargeOrder!.chargeAmount.toString();
      chargePriceController.text = widget.chargeOrder!.chargePrice.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.chargeOrder == null
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
                                widget.db
                                    .delete(widget.db.chargeOrder)
                                    .delete(widget.chargeOrder!);
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
        title: Text(widget.chargeOrder == null
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
                if (widget.chargeOrder == null) {
                  widget.db.into(widget.db.chargeOrder).insert(
                      ChargeOrderCompanion.insert(
                          carId: widget.selectedCar.id,
                          drivingDistance: drivingDistance,
                          powerBeforeCharge: powerBeforeCharge,
                          powerAfterCharge: powerAfterCharge,
                          chargeAmount: chargeAmount,
                          chargePrice: chargePrice,
                          steelConsumption: drift.Value(100 -
                              widget.selectedCar.batterySize *
                                  (powerAfterCharge - powerBeforeCharge) /
                                  chargeAmount)));
                } else {
                  widget.db.update(widget.db.chargeOrder).replace(
                        ChargeOrderCompanion(
                            id: drift.Value(widget.chargeOrder!.id),
                            carId: drift.Value(widget.selectedCar.id),
                            drivingDistance: drift.Value(drivingDistance),
                            powerBeforeCharge: drift.Value(powerBeforeCharge),
                            powerAfterCharge: drift.Value(powerAfterCharge),
                            chargeAmount: drift.Value(chargeAmount),
                            chargePrice: drift.Value(chargePrice),
                            steelConsumption: drift.Value(100 -
                                widget.selectedCar.batterySize *
                                    (powerAfterCharge - powerBeforeCharge) /
                                    chargeAmount),
                            createdAt:
                                drift.Value(widget.chargeOrder!.createdAt)),
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
                    keyboardType: TextInputType.none,
                    onTap: () {
                      showModalBottomSheet(
                          enableDrag: false,
                          context: context,
                          builder: (context) {
                            ValueNotifier<String> strNotifier =
                                ValueNotifier(chargeAmountController.text);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ValueListenableBuilder(
                                    valueListenable: strNotifier,
                                    builder: (context, data, _) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          data,
                                          style: const TextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
                                      );
                                    }),
                                MoneyNumberTablet(
                                    moneyController: chargeAmountController,
                                    callback: (text) {
                                      setState(() {
                                        chargeAmountController.text = text;
                                        strNotifier.value = text;
                                      });
                                    }),
                              ],
                            );
                          });
                    },
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
                    keyboardType: TextInputType.none,
                    onTap: () {
                      showModalBottomSheet(
                          enableDrag: false,
                          context: context,
                          builder: (context) {
                            ValueNotifier<String> strNotifier =
                                ValueNotifier(chargePriceController.text);
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ValueListenableBuilder(
                                      valueListenable: strNotifier,
                                      builder: (context, data, _) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            data,
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        );
                                      }),
                                  MoneyNumberTablet(
                                      moneyController: chargePriceController,
                                      callback: (text) {
                                        setState(() {
                                          chargePriceController.text = text;
                                          strNotifier.value = text;
                                        });
                                      }),
                                ],
                              ),
                            );
                          });
                    },
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
