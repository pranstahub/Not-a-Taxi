import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:not_a_taxi/screens/driver/car_info.dart';
import 'package:not_a_taxi/screens/driver/post_rides.dart';
import 'package:not_a_taxi/screens/driver/published_rides.dart';
import 'package:not_a_taxi/screens/passenger/search_rides.dart';
import 'package:not_a_taxi/screens/role_selector.dart';

import '/utils/snackbar.dart';
import '/screens/driver/add_car.dart';
import '../login_page.dart';

class passengerHome extends StatefulWidget {
  @override
  _passengerHomeState createState() => _passengerHomeState();
}

class _passengerHomeState extends State<passengerHome> {
  
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: const Text('Passenger Home'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        //elevation: 2,
        leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                setState(() {
                      Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => RoleSelect(),
                            ),);
                  });
              }),
      ),
        body: Container(
           decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/passenger_bg.jpg"),
            fit: BoxFit.fill,
          )),
        //color: Color.fromRGBO(104, 255, 240, 1),
             
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () { Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchRideScreen(),
                                ),
                              );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                  
                            fixedSize: Size(230, 100),),
                  child: Text('Search for Rides', style: TextStyle(fontSize: 20),),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    // Handle button 2 press
                    /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => {RidesPublishedScreen()},
                                ),
                              );*/
                  },
                  style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                  
                            fixedSize: Size(230, 100),),
                  child: Text('View Confirmed Rides',style: TextStyle(fontSize: 20) ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}