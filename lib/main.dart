import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:not_a_taxi/screens/driver/driver_menu.dart';
import 'package:not_a_taxi/screens/role_selector.dart';
import 'package:not_a_taxi/services/mileage_scraper.dart';
import 'screens/login_page.dart';
import 'screens/metamask.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  //scrapeMileage("toyota", "corolla", "petrol", "2020");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Not A Taxi',
      home: LoginPage(),
      routes: {
        'metaMask': (context) => metaMask(),
        'role_selector': (context) => RoleSelect(),
        'driver_home': (context) => driverHome(),
      },
    );
  }

}