import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../database/db.dart';

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class ChargeTrendPage extends StatefulWidget {
  // Changed to StatefulWidget
  final MyDatabase db;
  final CarData? selectedCar;

  const ChargeTrendPage(this.db, this.selectedCar, {super.key});

  @override
  State<ChargeTrendPage> createState() => _ChargeTrendPageState();
}

class _ChargeTrendPageState extends State<ChargeTrendPage> {
  bool isMonthlyView = false;

  List<ChartData> getPowerConsumptionChartData(
      List<ChargeOrderData> consumptions) {
    if (!isMonthlyView) {
      return getDailyPowerConsumptionData(consumptions);
    }
    return getMonthlyPowerConsumptionData(consumptions);
  }

  List<ChartData> getDailyPowerConsumptionData(
      List<ChargeOrderData> consumptions) {
    List<ChartData> chartData = [];
    for (int i = 0; i < consumptions.length; i++) {
      double powerComsumption;
      if (consumptions[i].drivingDistance == 0) continue;
      if (i == consumptions.length - 1) {
        powerComsumption = consumptions[i].chargeAmount /
            consumptions[i].drivingDistance *
            100.00;
      } else {
        powerComsumption = (consumptions[i + 1].powerAfterCharge -
                consumptions[i].powerBeforeCharge) /
            (consumptions[i].powerAfterCharge -
                consumptions[i].powerBeforeCharge) *
            consumptions[i].chargeAmount /
            consumptions[i].drivingDistance *
            100.00;
      }
      chartData.add(ChartData(consumptions[i].createdAt, powerComsumption));
    }
    return chartData;
  }

  List<ChartData> getMonthlyPowerConsumptionData(
      List<ChargeOrderData> consumptions) {
    Map<DateTime, List<double>> monthlyData = {};

    for (int i = 0; i < consumptions.length; i++) {
      if (consumptions[i].drivingDistance == 0) continue;

      double powerConsumption;
      if (i == consumptions.length - 1) {
        powerConsumption = consumptions[i].chargeAmount /
            consumptions[i].drivingDistance *
            100.00;
      } else {
        powerConsumption = (consumptions[i + 1].powerAfterCharge -
                consumptions[i].powerBeforeCharge) /
            (consumptions[i].powerAfterCharge -
                consumptions[i].powerBeforeCharge) *
            consumptions[i].chargeAmount /
            consumptions[i].drivingDistance *
            100.00;
      }

      DateTime monthKey = DateTime(
          consumptions[i].createdAt.year, consumptions[i].createdAt.month, 1);
      monthlyData.putIfAbsent(monthKey, () => []);
      monthlyData[monthKey]!.add(powerConsumption);
    }

    return monthlyData.entries.map((entry) {
      double avgConsumption =
          entry.value.reduce((a, b) => a + b) / entry.value.length;
      return ChartData(entry.key, avgConsumption);
    }).toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }

  List<ChartData> getCostPerKilometerChartData(
      List<ChargeOrderData> consumptions) {
    if (!isMonthlyView) {
      return getDailyCostData(consumptions);
    }
    return getMonthlyCostData(consumptions);
  }

  List<ChartData> getDailyCostData(List<ChargeOrderData> consumptions) {
    List<ChartData> chartData = [];
    for (int i = 0; i < consumptions.length; i++) {
      double powerComsumption;
      if (consumptions[i].drivingDistance == 0) continue;
      if (i == consumptions.length - 1) {
        powerComsumption = consumptions[i].chargeAmount /
            consumptions[i].drivingDistance *
            100.00;
      } else {
        powerComsumption = (consumptions[i + 1].powerAfterCharge -
                consumptions[i].powerBeforeCharge) /
            (consumptions[i].powerAfterCharge -
                consumptions[i].powerBeforeCharge) *
            consumptions[i].chargeAmount /
            consumptions[i].drivingDistance *
            100.00;
      }
      chartData.add(ChartData(
          consumptions[i].createdAt,
          consumptions[i].chargePrice /
              consumptions[i].chargeAmount *
              powerComsumption));
    }
    return chartData;
  }

  List<ChartData> getMonthlyCostData(List<ChargeOrderData> consumptions) {
    Map<DateTime, List<double>> monthlyData = {};

    for (int i = 0; i < consumptions.length; i++) {
      if (consumptions[i].drivingDistance == 0) continue;

      double powerConsumption;
      if (i == consumptions.length - 1) {
        powerConsumption = consumptions[i].chargeAmount /
            consumptions[i].drivingDistance *
            100.00;
      } else {
        powerConsumption = (consumptions[i + 1].powerAfterCharge -
                consumptions[i].powerBeforeCharge) /
            (consumptions[i].powerAfterCharge -
                consumptions[i].powerBeforeCharge) *
            consumptions[i].chargeAmount /
            consumptions[i].drivingDistance *
            100.00;
      }

      double costPerKm = consumptions[i].chargePrice /
          consumptions[i].chargeAmount *
          powerConsumption;

      DateTime monthKey = DateTime(
          consumptions[i].createdAt.year, consumptions[i].createdAt.month, 1);
      monthlyData.putIfAbsent(monthKey, () => []);
      monthlyData[monthKey]!.add(costPerKm);
    }

    return monthlyData.entries.map((entry) {
      double avgCost = entry.value.reduce((a, b) => a + b) / entry.value.length;
      return ChartData(entry.key, avgCost);
    }).toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }

  bool _hasMoreThanOneYearData(List<ChargeOrderData> consumptions) {
    if (consumptions.isEmpty) return false;

    DateTime oldest = consumptions
        .map((c) => c.createdAt)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    DateTime newest = consumptions
        .map((c) => c.createdAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    return newest.difference(oldest).inDays > 365;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              if (widget.selectedCar != null)
                Column(
                  children: [
                    // Add toggle button
                    ToggleButtons(
                      isSelected: [!isMonthlyView, isMonthlyView],
                      onPressed: (int index) {
                        setState(() {
                          isMonthlyView = index == 1;
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor:
                          Theme.of(context).colorScheme.primary,
                      selectedColor: Theme.of(context).colorScheme.onPrimary,
                      fillColor: Theme.of(context).colorScheme.primary,
                      color: Theme.of(context).colorScheme.primary,
                      constraints: const BoxConstraints(
                        minHeight: 30.0,
                        minWidth: 80.0,
                      ),
                      children: const [
                        Text('Daily'),
                        Text('Monthly'),
                      ],
                    ),
                    widget.selectedCar == null
                        ? Container()
                        : Column(
                            children: [
                              StreamBuilder<List<ChargeOrderData>>(
                                  stream: widget.db.getChargeOrderList(
                                      widget.selectedCar!.id),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    }
                                    List<ChargeOrderData> consumptions =
                                        snapshot.data!;
                                    if (consumptions.isEmpty) {
                                      return const Text('No consumptions');
                                    }
                                    double mostRecentPowerConsumption =
                                        ((consumptions.length == 1)
                                            ? consumptions[0].drivingDistance ==
                                                    0
                                                ? 0
                                                : consumptions[0].chargeAmount /
                                                    consumptions[0]
                                                        .drivingDistance *
                                                    100.00
                                            : consumptions[0].drivingDistance ==
                                                    0
                                                ? 0
                                                : (consumptions[1]
                                                            .powerAfterCharge -
                                                        consumptions[0]
                                                            .powerBeforeCharge) /
                                                    (consumptions[0]
                                                            .powerAfterCharge -
                                                        consumptions[0]
                                                            .powerBeforeCharge) *
                                                    consumptions[0]
                                                        .chargeAmount /
                                                    consumptions[0]
                                                        .drivingDistance *
                                                    100.00);
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text("最近电耗"),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              mostRecentPowerConsumption
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style: const TextStyle(
                                                                  fontSize: 26,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4),
                                                            child:
                                                                Text("度/百公里"),
                                                          )
                                                        ],
                                                      ),
                                                    ]),
                                              ),
                                            ],
                                          ),
                                          buildPowerConsumptionChart(
                                              consumptions),
                                          buildCostPerkmChart(consumptions),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildCostPerkmChart(List<ChargeOrderData> consumptions) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 300,
        child: SfCartesianChart(
            title: ChartTitle(
                text: '百公里费用变化曲线',
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            zoomPanBehavior: ZoomPanBehavior(
                // Enables pinch zooming
                enablePinching: true,
                enableMouseWheelZooming: true,
                zoomMode: ZoomMode.x,
                enablePanning: true),
            trackballBehavior: TrackballBehavior(
                // Enables the trackball
                enable: true,
                tooltipSettings:
                    const InteractiveTooltip(enable: true, color: Colors.red)),
            primaryXAxis: DateTimeAxis(
              dateFormat: isMonthlyView
                  ? DateFormat('yyyy-MM')
                  : DateFormat('yyyy-MM-dd'),
              intervalType: isMonthlyView
                  ? DateTimeIntervalType.months
                  : DateTimeIntervalType.days,
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              plotOffset: 20,
            ),
            primaryYAxis: NumericAxis(anchorRangeToVisiblePoints: false),
            series: <ChartSeries>[
              // Renders line chart
              LineSeries<ChartData, DateTime>(
                  dataSource: getCostPerKilometerChartData(consumptions),
                  dataLabelMapper: (ChartData data, _) =>
                      data.y.toStringAsFixed(2),
                  dataLabelSettings: const DataLabelSettings(
                      // Renders the data label
                      isVisible: true),
                  markerSettings: const MarkerSettings(isVisible: true),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y)
            ]),
      ),
    );
  }

  Padding buildPowerConsumptionChart(List<ChargeOrderData> consumptions) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 300,
        child: SfCartesianChart(
            title: ChartTitle(
                text: '能耗变化曲线',
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            zoomPanBehavior: ZoomPanBehavior(
                // Enables pinch zooming
                enablePinching: true,
                enableMouseWheelZooming: true,
                zoomMode: ZoomMode.x,
                enablePanning: true),
            trackballBehavior: TrackballBehavior(
                // Enables the trackball
                enable: true,
                tooltipSettings:
                    const InteractiveTooltip(enable: true, color: Colors.red)),
            primaryXAxis: DateTimeAxis(
              dateFormat: isMonthlyView
                  ? DateFormat('yyyy-MM')
                  : DateFormat('yyyy-MM-dd'),
              intervalType: isMonthlyView
                  ? DateTimeIntervalType.months
                  : DateTimeIntervalType.days,
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              plotOffset: 20,
            ),
            primaryYAxis: NumericAxis(anchorRangeToVisiblePoints: false),
            series: <ChartSeries>[
              // Renders line chart
              LineSeries<ChartData, DateTime>(
                  dataSource: getPowerConsumptionChartData(consumptions),
                  dataLabelMapper: (ChartData data, _) =>
                      data.y.toStringAsFixed(2),
                  dataLabelSettings: const DataLabelSettings(
                      // Renders the data label
                      isVisible: true),
                  markerSettings: const MarkerSettings(isVisible: true),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y)
            ]),
      ),
    );
  }
}
