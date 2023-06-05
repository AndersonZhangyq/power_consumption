import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../database/db.dart';

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class ChargeTrendPage extends StatelessWidget {
  final MyDatabase db;
  final CarData? selectedCar;

  const ChargeTrendPage(this.db, this.selectedCar, {super.key});

  List<ChartData> getChartData(List<ChargeOrderData> consumptions) {
    List<ChartData> chartData = [];
    for (int i = 0; i < consumptions.length; i++) {
      chartData.add(ChartData(
          consumptions[i].createdAt,
          (consumptions[i].chargeAmount /
              consumptions[i].drivingDistance *
              100)));
    }
    return chartData;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            selectedCar == null
                ? Container()
                : Column(
                    children: [
                      StreamBuilder<List<ChargeOrderData>>(
                          stream: db.getChargeOrderList(selectedCar!.id),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            List<ChargeOrderData> consumptions = snapshot.data!;
                            if (consumptions.isEmpty) {
                              return const Text('No consumptions');
                            }
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text("最近电耗"),
                                              Row(
                                                children: [
                                                  Text(
                                                      (consumptions[0]
                                                                  .chargeAmount /
                                                              consumptions[0]
                                                                  .drivingDistance *
                                                              100)
                                                          .toStringAsFixed(2),
                                                      style: const TextStyle(
                                                          fontSize: 26,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 4),
                                                    child: Text("度/百公里"),
                                                  )
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 300,
                                      child: SfCartesianChart(
                                          title: ChartTitle(
                                              text: '能耗变化曲线',
                                              textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
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
                                                  const InteractiveTooltip(
                                                      enable: true,
                                                      color: Colors.red)),
                                          primaryXAxis: DateTimeAxis(),
                                          primaryYAxis: NumericAxis(
                                              anchorRangeToVisiblePoints:
                                                  false),
                                          series: <ChartSeries>[
                                            // Renders line chart
                                            LineSeries<ChartData, DateTime>(
                                                dataSource:
                                                    getChartData(consumptions),
                                                dataLabelMapper:
                                                    (ChartData data, _) => data
                                                        .y
                                                        .toStringAsFixed(2),
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                        // Renders the data label
                                                        isVisible: true),
                                                markerSettings:
                                                    const MarkerSettings(
                                                        isVisible: true),
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.x,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.y)
                                          ]),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
