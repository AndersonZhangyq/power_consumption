import 'package:flutter/material.dart';

import '../database/db.dart';
import 'charge_order.dart';

class OrderListPage extends StatelessWidget {
  final MyDatabase db;
  final CarData? selectedCar;

  const OrderListPage(this.db, this.selectedCar, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            selectedCar == null
                ? Container()
                : Expanded(
                    child: StreamBuilder<List<ChargeOrderData>>(
                        stream: db.getChargeOrderList(selectedCar!.id),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          List<ChargeOrderData> consumptions = snapshot.data!;
                          if (consumptions.isEmpty) {
                            return const Text('No consumptions');
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: consumptions.length,
                            itemBuilder: (context, index) {
                              ChargeOrderData order = consumptions[index];
                              double powerComsumption;
                              if (index == consumptions.length - 1) {
                                powerComsumption = order.drivingDistance == 0
                                    ? 0
                                    : order.chargeAmount /
                                        order.drivingDistance *
                                        100.00;
                              } else {
                                powerComsumption = order.drivingDistance == 0
                                    ? 0
                                    : (consumptions[index + 1]
                                                .powerAfterCharge -
                                            order.powerBeforeCharge) /
                                        (order.powerAfterCharge -
                                            order.powerBeforeCharge) *
                                        order.chargeAmount /
                                        order.drivingDistance *
                                        100.00;
                              }
                              return InkWell(
                                onTap: () {
                                  // Navigate to createConsumption
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChargeOrderWidget(
                                              db: db,
                                              selectedCar: selectedCar!,
                                              chargeOrder: consumptions[index],
                                            )),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 0.5),
                                        borderRadius: BorderRadius.circular(6)),
                                    padding: const EdgeInsets.all(8),
                                    child: Column(children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            order.createdAt
                                                .toString()
                                                .substring(5, 10),
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                powerComsumption
                                                    .toStringAsFixed(2),
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Text('度/百公里')
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                order.drivingDistance
                                                    .toStringAsFixed(1),
                                                style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Text('公里')
                                            ],
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${order.chargePrice.toStringAsFixed(2)} 元',
                                            ),
                                            Text(
                                              '${(order.chargePrice / order.chargeAmount).toStringAsFixed(2)} 元/度',
                                            ),
                                            Text(
                                              '+${order.chargeAmount} 度',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${order.powerBeforeCharge}%',
                                              style: const TextStyle(
                                                  color: Colors.lightBlue),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward,
                                              size: 16,
                                              color: Colors.lightBlue,
                                            ),
                                            Text(
                                              '${order.powerAfterCharge}%',
                                              style: const TextStyle(
                                                  color: Colors.lightBlue),
                                            )
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  )
          ],
        ),
      ),
    );
  }
}
