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
import 'add_car.dart';
import '../login_page.dart';

class driverHome extends StatefulWidget {
  @override
  _driverHomeState createState() => _driverHomeState();
}

class _driverHomeState extends State<driverHome > {
  
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: const Text('Driver Home'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        elevation: 2,
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () { Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CarInformationScreen(),
                              ),
                            );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                
                          fixedSize: Size(200, 100),),
                child: Text('Post A Ride', style: TextStyle(fontSize: 20),),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Handle button 2 press
                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RidesPublishedScreen(),
                              ),
                            );
                },
                style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                
                          fixedSize: Size(200, 100),),
                child: Text('View Your Rides',style: TextStyle(fontSize: 20) ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* {
                         Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CarInformationScreen(),
                              ),
                            );
                        },

                        {
                         Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RidesPublishedScreen(),
                              ),
                            );
                        },*/