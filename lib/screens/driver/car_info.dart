import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

import '../../database_manager.dart';
import '/apis/car_api.dart';
import '/models/car.dart';

import '../role_selector.dart';
import './add_car.dart';
//import 'package:carpoolapp/screens/edit_car_information.dart';
//import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import '/apis/rides_api.dart';

class CarInformationScreen extends StatefulWidget {
  const CarInformationScreen({Key? key}) : super(key: key);

  @override
  State<CarInformationScreen> createState() => _CarInformationScreenState();
}

class _CarInformationScreenState extends State<CarInformationScreen> {
  late Future<Car> futureCar;
  

  @override
  void initState() {
    super .initState();
    userCarExists();
  }

  int? carExists;
  String userID = "";

  late String brand;
  late String model;
  late String color;
  late String seatCap;
  late String fuel;
  late String year;
  late String plate;

   userCarExists() async {

      User? getUser = await FirebaseAuth.instance.currentUser;
      userID = getUser!.uid;
      carExists = await DatabaseManager().carDataExists(userID);
      print("OLAOLAOLAOLA $carExists");
   
      if(carExists == 1) {setCarValues();}
   
  }

  setCarValues () async {
    brand = await DatabaseManager().getCarDetail(userID, "Brand") as String;
    print(brand);
    model = await DatabaseManager().getCarDetail(userID, "Model") as String;
    color =await  DatabaseManager().getCarDetail(userID, "Color") as String;
    seatCap =await  DatabaseManager().getCarDetail(userID, "Seating Capacity") as String;
    fuel = await DatabaseManager().getCarDetail(userID, "Fuel Type") as String;
    year = await DatabaseManager().getCarDetail(userID, "Year of Manufacture") as String;
    plate = await DatabaseManager().getCarDetail(userID, "Registration Number") as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Car'),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        elevation: 2,
        leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              }),
      ),

      body: Center(
          child: Column(
            children: [
              if(carExists==1)...[
                SafeArea(
                  child: SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    'assets/img/passengercar2.png',
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                            //Registration Number
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Registration Number: ',style: TextStyle(fontSize: 20, color: Color(0xFF008CFF)),),
                                  Text(plate,style: const TextStyle(fontSize: 20),),
                                ],
                              ),
                            ),
                            //Brand
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Brand: ',style: TextStyle(fontSize: 20, color: Color(0xFF008CFF)),),
                                  Text(brand,style: const TextStyle(fontSize: 20),),
                                ],
                              ),
                            ),
                            //Model
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Model: ',style: TextStyle(fontSize: 20, color: Color(0xFF008CFF)),),
                                  Text(model,style: const TextStyle(fontSize: 20),),
                                ],
                              ),
                            ),
                            //Color
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Color: ',style: TextStyle(fontSize: 20, color: Color(0xFF008CFF)),),
                                  Text(color,style: const TextStyle(fontSize: 20),),
                                ],
                              ),
                            ),
                            //Fuel Type
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Fuel Type: ',style: TextStyle(fontSize: 20, color: Color(0xFF008CFF)),),
                                  Text(fuel,style: const TextStyle(fontSize: 20),),
                                ],
                              ),
                            ),
                            //Seating Capacity
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Seating Capacity: ',style: TextStyle(fontSize: 20, color: Color(0xFF008CFF)),),
                                  Text(seatCap,style: const TextStyle(fontSize: 20),),
                                ],
                              ),
                            ),
                            //Year of Manufacture
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Year of Manufacture: ',style: TextStyle(fontSize: 20, color: Color(0xFF008CFF)),),
                                  Text(year,style: const TextStyle(fontSize: 20),),
                                ],
                              ),
                            ),
                        
                            //Change Car and Remove Car
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                //Change Car
                                  GestureDetector(
                                    child: OutlinedButton.icon(
                                    onPressed: () {
                                      print("IN EDIT");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>AddCarScreen(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 24.0,
                                    ),
                                    label: const Text('Change Car'),
                                    ),
                                  ),
                                //Delete Car
                                  GestureDetector(
                                    child: OutlinedButton.icon(
                                      onPressed: () => showAlertDialog(context, userID),                              
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                        size: 24.0,
                                      ),
                                      label: const Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                    ), ),
                                ]
                              ),
                            ),
                          ]
                        ),
                      )
                    )
                  )
                )               
              ]
              else...[
              //if no car is added yet
                Column(
                  children: [
                    const SizedBox(height: 120.0),
                    Center(
                      child: Image.asset(
                        'assets/img/nocarscreen.png',
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Text(
                            'It seems like you have no car here!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                          child: Text('Please add one to pool your ride',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0), fontSize: 17)),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddCarScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        // side: const BorderSide(color: Color(0xFF008CFF), width: 3),
                        primary: const Color(0xFF008CFF),
                        onPrimary: Colors.white,
                        fixedSize: const Size(150, 50),
                        textStyle: const TextStyle(
                            fontSize: 16,
                            //fontWeight: FontWeight.w500
                        ),
                      ),
                      child: const Text("Add Your Car"),
                    ),
                  ),
                ],
              ) 
            ]
          ]
        )
      )
    );   
} 

//Dialog confirmation delete 

showAlertDialog(BuildContext context, String userID) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         HomeScreen(),
      //   ),
      // );
     // Navigator.of(context).pop(); // dismiss dialog
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Yes, I'm sure!"),
    onPressed: () {
      print("idCar:  $userID");
      //CarApi.deleteCar(idCar);
      Navigator.of(context).pop(); // dismiss dialog
// Function to delete car from DB.
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Action confirmation"),
    content:
        const Text("Are you sure you want to delete your car information?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
}