// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:not_a_taxi/screens/driver/driver_menu.dart';
import 'package:not_a_taxi/services/mileage_scraper.dart';
import '../../utils/buffering_animation.dart';
import 'post_rides.dart';
import '../../database_manager.dart';
import './add_car.dart';
import '../../utils/globals.dart' as global;

class CarInformationScreen extends StatefulWidget {
  const CarInformationScreen({Key? key}) : super(key: key);

  @override
  State<CarInformationScreen> createState() => _CarInformationScreenState();
}

class _CarInformationScreenState extends State<CarInformationScreen> { 

  @override
  void initState() {
    super .initState();
  }

  late String brand;
  late String model;
  late String fuel;
  late String year;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Car'),
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: true,
        elevation: 2,
        leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                setState(() {
                      Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => driverHome(),
                            ),);
                  });
              }),
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(image:AssetImage("assets/img/COMMONSCREEN.jpg"),
            fit: BoxFit.fill ),
          ),
        child: Center(
            child: Column(
              children: [
                FutureBuilder<List>(
                  future: DatabaseManager().carDataExists(global.userID),
                  builder: (context, snapshot)
                   {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print("in 1.1");
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 300.0),
                            BufferingAnimation(), // Add the buffering animation widget here
                            const SizedBox(height: 25.0),
                            Text('Fetching your Car...', style:TextStyle(fontSize: 18)),
                          ],
                        ),
                      );
                    } 
      
                    else if (snapshot.data!.isNotEmpty) {
                      print("in 1.2");
                          print(snapshot.data);
                          return Column(
                            children: [
                              SafeArea(
                                child: SingleChildScrollView(
                                  child: GestureDetector(
                                    onTap: () => FocusScope.of(context).unfocus(),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const SizedBox(height: 25.0),
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
                                          const SizedBox(height: 25.0),
                                          ElevatedButton(
                                            onPressed: () {                                
                                              setState(() {
                                                Navigator.push(context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ShareRideScreen(),
                                                ),);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.orange,
                                              onPrimary: Colors.white,
                                              fixedSize: Size(150, 50),
                                              textStyle: TextStyle(fontSize: 18),
                                            ),
                                            child: const Text("Post A Ride!"),
                                          ),
                                          const SizedBox(height: 25.0),
      
      
                                        Card(
                                          margin: EdgeInsets.only(right:10, left:10, top:15, bottom:15),
                                          shape: RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            color: Colors.orange,
                                                          ),
                                                        borderRadius: BorderRadius.circular(25.0),
                                                      ),
                                                      elevation: 10,
                                                      shadowColor: Colors.black,
                                                      color: const Color(0xffF8F8F8),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column (children: [
                                            //Registration Number
                                            FutureBuilder(
                                              future: DatabaseManager().getCarDetail(global.userID, "Registration Number"),
                                              builder: (context, snapshot) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text('Registration Number: ',
                                                        style: TextStyle(fontSize: 17, color: Color(0xFF008CFF)),),
                                                      Text(snapshot.data.toString(),style: const TextStyle(fontSize: 18),),
                                                    ],
                                                  ),
                                                );
                                              }
                                            ),
                                            //Brand
                                            FutureBuilder(
                                              future: DatabaseManager().getCarDetail(global.userID, "Brand"),
                                              builder: (context, snapshot) {
                                                brand = snapshot.data.toString();
                                                return Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text('Brand: ',
                                                        style: TextStyle(fontSize: 17, color: Color(0xFF008CFF)),),
                                                      Text(snapshot.data.toString(),style: const TextStyle(fontSize: 18),),
                                                      //Text(stringReducer(snapshot.data.toString()),style: const TextStyle(fontSize: 20),),
                                                    ],
                                                  ),
                                                );
                                              }
                                            ),
                                            //Model
                                            FutureBuilder(
                                              future: DatabaseManager().getCarDetail(global.userID, "Model"),
                                              builder: (context, snapshot) {
                                                model = snapshot.data.toString();
                                                return Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text('Model: ',
                                                        style: TextStyle(fontSize: 17, color: Color(0xFF008CFF)),),
                                                      Text(snapshot.data.toString(),style: const TextStyle(fontSize: 18),),
                                                      //Text(stringReducer(snapshot.data.toString()),style: const TextStyle(fontSize: 20),),
                                                    ],
                                                  ),
                                                );
                                              }
                                            ),
                                            //Color
                                            FutureBuilder(
                                              future: DatabaseManager().getCarDetail(global.userID, "Color"),
                                              builder: (context, snapshot) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text('Color: ',
                                                        style: TextStyle(fontSize: 17, color: Color(0xFF008CFF)),),
                                                      Text(snapshot.data.toString(),style: const TextStyle(fontSize: 18),),
                                                    ],
                                                  ),
                                                );
                                              }
                                            ),
                                            //Fuel Type
                                            FutureBuilder(
                                              future: DatabaseManager().getCarDetail(global.userID, "Fuel Type"),
                                              builder: (context, snapshot) {
                                                fuel = snapshot.data.toString();
                                                return Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text('Fuel Type: ',
                                                        style: TextStyle(fontSize: 17, color: Color(0xFF008CFF)),),
                                                      Text(snapshot.data.toString(),style: const TextStyle(fontSize: 18),),
                                                    ],
                                                  ),
                                                );
                                              }
                                            ),
                                            //Seating Capacity
                                            FutureBuilder(
                                              future: DatabaseManager().getCarDetail(global.userID, "Seating Capacity"),
                                              builder: (context, snapshot) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text('Seating Capacity: ',
                                                        style: TextStyle(fontSize: 17, color: Color(0xFF008CFF)),),
                                                      Text(snapshot.data.toString(),style: const TextStyle(fontSize: 18),),
                                                    ],
                                                  ),
                                                );
                                              }
                                            ),
                                            //Year of Manufacture
                                            FutureBuilder(
                                              future: DatabaseManager().getCarDetail(global.userID, "Year of Manufacture"),
                                              builder: (context, snapshot) {
                                                year = snapshot.data.toString();
                                                //scrapeMileage(brand, model, fuel, year);
                                                return Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text('Year of Manufacture: ',
                                                        style: TextStyle(fontSize: 17, color: Color(0xFF008CFF)),),
                                                      Text(snapshot.data.toString(),style: const TextStyle(fontSize: 18),),
                                                    ],
                                                  ),
                                                );
                                              }
                                            ),
                                            ]
                                            ),
                                          )
                                        ),
                                      
                                          //Change Car and Remove Car
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                              //Change Car
                                                GestureDetector(
  child: OutlinedButton.icon(
    onPressed: () {
      print("In Change Car");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddCarScreen(),
        ),
      );
    },
    icon: const Icon(
      Icons.edit,
      size: 24.0,
    ),
    label: const Text('Change Car'),
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.orange // Add background color here
    ),
  ),
),

                                                //Delete Car
                                                GestureDetector(
  child: OutlinedButton.icon(
    onPressed: () => showAlertDialog(context, global.userID),
    icon: const Icon(
      Icons.delete_forever,
      color: Colors.white,
      size: 24.0,
    ),
    label: const Text(
      'Delete',
      style: TextStyle(color: Colors.white),
    ),
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.red, // Add background color here
    ),
  ),
),
            
                                              ]
                                            )
                                          ) // end of chanher car or delete car
                                        ]
                                      )
                                    )
                                  )
                                )
                              )
                            ]
                          );
                    }
                        
                        
                          else {
                            return Column(
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
                                          style: TextStyle(color: Colors.white, fontSize: 22),
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
                                      primary: Colors.orange,
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
                              ]
                        );
                      }
                      return const BufferingAnimation();
                    }                     
              )
            ]   
          )
        ),
      )
      
    ));   
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