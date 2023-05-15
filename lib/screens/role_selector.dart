import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/snackbar.dart';
import 'driver/add_car.dart';
import 'login_page.dart';

class RoleSelect extends StatefulWidget {
  @override
  _RoleSelectState createState() => _RoleSelectState();
}

class _RoleSelectState extends State<RoleSelect> {
  final _auth = FirebaseAuth.instance;
  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      //backgroundColor: Colors.red,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Select your Role"),
        centerTitle: true,
        leading: null,
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout_rounded),
              onPressed: () {
                _auth.signOut();
                CustomSnackBar(context, const Text('Logged Out Succesfully!'));
                Timer(Duration(seconds: 1), () { // <-- Delay here
                  setState(() {
                      Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),);
                  });
                });
              })
         
        ],
      ),
      body: 
      Container(
              child: Align(
              alignment: Alignment.center,
              child: Column(children: [
                
                const SizedBox(
                        height: 30.0,
                        ),
                CircleAvatar(
                  radius:150 ,
                  backgroundColor: Colors.blue,
                  child: CircleAvatar(
                    radius:140,
                    backgroundColor: Colors.white,
                    child: InkWell(
                      onTap: () =>  Navigator.pushNamed(context, 'car_info'), // needed
                      child: Image.asset(
                        "assets/img/driver.png",
                        width: 350,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
          
                const SizedBox(
                        height: 30.0,
                        ),
                CircleAvatar(
                  radius:150 ,
                  backgroundColor: Colors.blue,
                  child: CircleAvatar(
                    radius:140,
                    backgroundColor: Colors.white,
                    child: InkWell(
                      onTap: () =>  {}, // needed
                      child: Image.asset(
                        "assets/img/passenger.png",
                        width: 500,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ]
              ),
            ),
          )
        );
  }
}