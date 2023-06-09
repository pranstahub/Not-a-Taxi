import 'dart:async';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:not_a_taxi/services/mileage_scraper.dart';
import '../../utils/globals.dart' as global;
import '../../database_manager.dart';
import '../../utils/snackbar.dart';
import 'car_info.dart';

void main() {
  runApp(AddCarScreen());
}

class AddCarScreen extends StatefulWidget {

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
  late String mileage;
  
  String numberPlate = "";

  final TextEditingController _plate_controller = TextEditingController();
  late Map mapResponse;
  late Map dataResponse;
 
@override
  void initState() {
    super.initState();
  }


  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Your Car'),
        leadingWidth: 100,
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              }),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(image:AssetImage("assets/img/COMMONSCREEN.jpg"),
            fit: BoxFit.fill ),
          ),
        child: SafeArea(
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

                    Card(

                    margin: EdgeInsets.only(right:5, left:5, top:10, bottom:10),
                    shape: RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                          color: Colors.orange,
                                                        ),
                                                      borderRadius: BorderRadius.circular(25.0),
                                                    ),
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    color: const Color(0xffF8F8F8),
                      child: Column(children: [
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
                              top: 20.0, bottom: 20.0, left: 40.0, right: 40.0),
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
                        primary: Colors.orange,
                        onPrimary: Colors.white,
                        fixedSize: Size(150, 50),
                        textStyle: TextStyle(fontSize: 19),
                      ),
                    ),
                    SizedBox(height: 20,)
                      ]
                      )
                    )
                  ],
                ),
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
    'X-RapidAPI-Key': 'YOUR-API-KEY',
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

  uploadCarDetailsToFirebase() async{
    brand = dataResponse["manufacturer"];
    model = dataResponse["manufacturer_model"];
    color = dataResponse["colour"];
    seatCap = dataResponse["seating_capacity"];
    fuel = dataResponse["fuel_type"];
    year = dataResponse["m_y_manufacturing"];
    year = year.substring(0,4);
    plate = dataResponse["registration_number"];

    mileage = await scrapeMileage(brand, model, fuel, year);

     DatabaseManager().createCarData(brand,model,color,seatCap,fuel,year,plate,mileage, global.userID);

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
