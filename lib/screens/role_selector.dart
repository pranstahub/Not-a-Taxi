import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:not_a_taxi/screens/passenger/passenger_menu.dart';
import '../utils/snackbar.dart';
import 'login_page.dart';
import '../../../utils/globals.dart' as global;

class RoleSelect extends StatefulWidget {
  @override
  _RoleSelectState createState() => _RoleSelectState();
}

class _RoleSelectState extends State<RoleSelect> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super .initState();
    getCurrentUser();
    getUserId();
  }
  late User loggedinUser;
  String userID = "";

   getUserId() async {
      User? getUser = await FirebaseAuth.instance.currentUser;
      userID = getUser!.uid;  
      global.userID = userID;
  }
  
  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  
   @override
  Widget build(BuildContext context) {
    return  WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(
      extendBodyBehindAppBar: false,
      //backgroundColor: Colors.red,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Select Your Role"),
        centerTitle: true,
        leading: null,
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout,),
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/COMMONSCREEN.jpg"),
            fit: BoxFit.fill,
          )),
        //color: Color.fromRGBO(104, 255, 240, 1),
              child: Align(
              alignment: Alignment.center,
              child: Column(children: [
                
                const SizedBox(
                        height: 30.0,
                        ),
                CircleAvatar(
                  radius:150,
                  backgroundColor: Colors.transparent,
                  backgroundImage: const AssetImage("assets/img/driver_copy.png"),
                  child: InkWell(
                    onTap: () =>  Navigator.pushNamed(context, 'driver_home'), // needed
                    /*child: Image.asset(
                      "assets/img/driver.png",
                      width: 900,
                      //fit: BoxFit.fill,
                    ),*/
                  ),
                ),
          
                const SizedBox(
                        height: 30.0,
                        ),
                CircleAvatar(
                  radius:150,
                  backgroundColor: Colors.transparent,
                  backgroundImage: const AssetImage("assets/img/passenger_copy.png"),
                  child: InkWell(
                    onTap: () =>  {Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  passengerHome(),
                        ),
                      )}, // needed
                    /*child: Image.asset(
                      "assets/img/passenger.png",
                      width: 500,
                      fit: BoxFit.fill,
                    ),*/
                  ),
                ),
              ]
              ),
            ),
          )
        ));
  }
}