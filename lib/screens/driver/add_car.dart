import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
// import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database_manager.dart';
import '../../utils/snackbar.dart';

import '/screens/role_selector.dart';
//import 'package:carpoolapp/screens/dialog_screen.dart';
//import 'package:carpoolapp/screens/share_ride.dart';

import 'package:not_a_taxi/screens/role_selector.dart';

import 'car_info.dart';

void main() {
  runApp(AddCarScreen());
}

class AddCarScreen extends StatefulWidget {
//final int carN;
  const AddCarScreen ({ Key? key}): super(key: key);

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}
class _AddCarScreenState extends State<AddCarScreen> {
 
  late String brand;
  late String model;
  late String color;
  late String seatCap;
  late String fuel;
  late String year;
  late String plate;
  
  String userID = "";
  String numberPlate = "";

  final TextEditingController _plate_controller = TextEditingController();

  //late String stringResponse;
  late Map mapResponse;
  late Map dataResponse;
 
@override
  void initState() {
    super.initState();
    fetchUserInfo();
    //fetchDatabaseList();
  }

  fetchUserInfo() async {
    User? getUser = await FirebaseAuth.instance.currentUser;
    userID = getUser!.uid;
    //return userID;
  }
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    //passThePlate();
    //getManufacturer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add your Car'),
        leadingWidth: 100,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              }),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                        height: 30.0,
                        ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Expanded(
                        child: Image.asset(
                          'assets/img/mycar.png',
                          width: 200,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:50, top:50,),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          'Enter your License Plate here:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF008CFF),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

               
                  Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 80.0, right: 80.0),
                        child: 
                  TextFormField(
                    textAlign: TextAlign.center,
                    controller: _plate_controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'example: KL 08 AB 1234', 
                    ),
                    /*validator: (value) {
                      if (value != null || value!.isNotEmpty) {
                        final RegExp regex = RegExp(r'^[A-Z]{2}[ -][0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)? [0-9]{4}$');
                        if (!regex.hasMatch(value)) {
                          CustomSnackBar(context, const Text('Error in Plate Format! Try again!'));
                        }
                        else {
                        return null;
                        }
                      } 
                      else{
                        CustomSnackBar(context, const Text('Enter a Valid Plate!'));
                      }
                    },*/
                    
                  ) ),
                  
                  ElevatedButton(
                    child: Text("Get Car"),
                    onPressed: () => submitAction(context),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF008CFF),
                      onPrimary: Colors.white,
                      fixedSize: Size(150, 50),
                      textStyle: TextStyle(fontSize: 19),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

submitAction(BuildContext context) {
    final RegExp regex = RegExp(r'^[A-Z]{2}[ -][0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)? [0-9]{4}$');
    if (!regex.hasMatch(_plate_controller.text)) {
      CustomSnackBar(context, const Text('Error in Plate Format! Try again!'));
    }
    else {
      CustomSnackBar(context, const Text('Fetching Car Details...'));
      //Timer(Duration(seconds: 1), () {});
      numberPlate = _plate_controller.text;
      //passThePlate();
      getCarDetails();
      }
}
  //API
  getCarDetails() async {
    
    numberPlate = numberPlate.replaceAll(' ', '');
      
    final url = Uri.https('vehicle-rc-information.p.rapidapi.com', '/');

    final payload = { "VehicleNumber": numberPlate};

    final headers = {
    'content-type': 'application/json',
    'X-RapidAPI-Key': '76cce151a4mshed9eac0bf4c0bffp1c97dbjsn5d32b97334c1',
    'X-RapidAPI-Host': 'vehicle-rc-information.p.rapidapi.com',
    };

    final response = await http.post(url, headers: headers, body: jsonEncode(payload));

    if (response.statusCode == 200) {
      setState(() {
        //stringResponse = response.body;
        mapResponse = json.decode(response.body);
        dataResponse = mapResponse["result"];
        //print(stringResponse);
        uploadCarDetailsToFirebase();
      });
        
      } 
    else {
        print('Request failed with status: ${response.statusCode}.');
      }
  }

  uploadCarDetailsToFirebase(){
    brand = dataResponse["manufacturer"];
    model = dataResponse["manufacturer_model"];
    color = dataResponse["colour"];
    seatCap = dataResponse["seating_capacity"];
    fuel = dataResponse["fuel_type"];
    year = dataResponse["m_y_manufacturing"];
    year = year.substring(0,4);
    plate = dataResponse["registration_number"];

     DatabaseManager().createCarData(brand,model,color,seatCap,fuel,year,plate, userID);

     Timer(Duration(seconds: 1), () { // <-- Delay here
       setState(() {
        Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => const CarInformationScreen(),
                            ),);
      });

    });

    

  }

}