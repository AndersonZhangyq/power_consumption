import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'database/db.dart';
import 'widgets/charge_order.dart';
import 'widgets/order_list_page.dart';
import 'widgets/charge_trend_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    Provider<MyDatabase>(
      create: (context) => MyDatabase(),
      child: const MyApp(),
      dispose: (context, db) => db.close(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        useMaterial3: false,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MyDatabase db;
  CarData? selectedCar;
  final _addCarFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _batterySizeController = TextEditingController();
  int bottomSelectedIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  List<Widget> pageList = [];

  void leaveAddCarForm() {
    _nameController.clear();
    _batterySizeController.clear();
    Navigator.of(context, rootNavigator: true).pop(context);
  }

  Widget buildAddCarDialog() {
    return WillPopScope(
      onWillPop: () {
        leaveAddCarForm();
        return Future.value(true);
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _addCarFormKey,
              child: Column(
                children: [
                  const Text(
                    "Add a car",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Car Name', prefixIcon: Icon(Icons.badge)),
                  ),
                  TextFormField(
                    controller: _batterySizeController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a battery size';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) <= 0) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Battery size',
                        suffixText: 'kWh',
                        prefixIcon: Icon(Icons.battery_charging_full)),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          leaveAddCarForm();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_addCarFormKey.currentState!.validate()) {
                            var carName = _nameController.text;
                            var batterySize =
                                double.tryParse(_batterySizeController.text)!;
                            int id = await db.into(db.car).insert(
                                CarCompanion.insert(
                                    name: carName, batterySize: batterySize));
                            if (0 == id) {
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Failed to insert a new car information."),
                                ),
                              );
                            } else {
                              leaveAddCarForm();
                            }
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    db = Provider.of<MyDatabase>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StreamBuilder<List<CarData>>(
                          stream: db.getCarList(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            List<CarData> cars = snapshot.data!;
                            if (cars.isEmpty) {
                              return const Text('No cars');
                            }
                            Future.delayed(Duration.zero, () {
                              if (selectedCar == null) {
                                setState(() {
                                  selectedCar = cars[0];
                                  pageList = [
                                    ChargeTrendPage(db, selectedCar),
                                    OrderListPage(db, selectedCar),
                                  ];
                                });
                              }
                            });
                            return DropdownButton<CarData>(
                              items: cars.map<DropdownMenuItem<CarData>>(
                                  (CarData value) {
                                return DropdownMenuItem<CarData>(
                                  value: value,
                                  child: Text(value.name),
                                );
                              }).toList(),
                              value: selectedCar,
                              onChanged: (CarData? newValue) {
                                setState(() {
                                  selectedCar = newValue;
                                  pageList = [
                                    ChargeTrendPage(db, selectedCar),
                                    OrderListPage(db, selectedCar),
                                  ];
                                });
                              },
                            );
                          }),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // Open a dialog for adding a car
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return buildAddCarDialog();
                            },
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
              pageList.isEmpty
                  ? Container()
                  : Expanded(child: pageList[bottomSelectedIndex])
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          setState(() {
            bottomSelectedIndex = index;
            // pageController.animateToPage(index,
            //     duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
        },
        items: const [
          BottomNavigationBarItem(
              label: "trend", icon: Icon(Icons.trending_up)),
          BottomNavigationBarItem(
            label: "detail",
            icon: Icon(Icons.list_alt),
          )
        ],
      ),
      floatingActionButton: selectedCar == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                // Navigate to createConsumption
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChargeOrderWidget(
                            db: db,
                            selectedCar: selectedCar!,
                          )),
                );
              },
              child: const Icon(Icons.electrical_services),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
