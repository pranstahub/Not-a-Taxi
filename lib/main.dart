import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:not_a_taxi/screens/role_selector.dart';



import 'screens/login_page.dart';
import 'screens/home_screen.dart';
import 'screens/role_selector.dart';
import 'screens/driver/add_car.dart';
import 'screens/driver/car_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
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
        'home_screen': (context) => HomeScreen(),
        'role_selector': (context) => RoleSelect(),
        'car_info': (context) => CarInformationScreen(),
      },
    );
  }

}