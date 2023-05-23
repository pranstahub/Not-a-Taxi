// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:not_a_taxi/services/functions.dart';
import 'package:not_a_taxi/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

import '../../database_manager.dart';
import '/config.dart';
import 'published_rides.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../utils/globals.dart' as global;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(ShareRideScreen());
}

class ShareRideScreen extends StatefulWidget {
  @override
  State<ShareRideScreen> createState() => _ShareRideScreenState();
}

class _ShareRideScreenState extends State<ShareRideScreen> {
  http.Client? httpClient;
  late Web3Client ethClient;


  final FocusNode _focus = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  var uuid = const Uuid();
  String? _sessionToken;//"1235";
  String _sessionTokenDestination = "12356";
  List<dynamic> _placesList = [];
  List<dynamic> _placesListDestination = [];
  TextEditingController timeinput = TextEditingController();
  final _dateController = TextEditingController();
  

  /// TextField controllers */s
  //TextEditingController destinationController = TextEditingController();
  TextEditingController departureLocationController = TextEditingController();
  TextEditingController departureDateController = TextEditingController();
  TextEditingController departureTimeController = TextEditingController();
  TextEditingController passengerLimitController = TextEditingController();

  String destination = "";
  String departureDate = "";
  String departureLocation = "";
  String departureTime = "";
  String passengerLimit = "";
  late bool isShowListTile = true;
  late bool isShowListTileDestination = true;

  String CarID = "";

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    httpClient = http.Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
    setCarValue();
    _controller.addListener(() {
      onChange();
    });
    _destinationController.addListener(() {
      onChangeDestination();
    });
    _focus.addListener(_onFocusChange);
  }


  void setCarValue() async {
    CarID = await DatabaseManager().getCarDetail(global.userID, "Car ID") as String;
    setState(() {
      
    });
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
  }


  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
    //getSuggestion(_DestinationController.text);
  }

  void onChangeDestination() {
    if (_sessionToken == null) {
      setState(() {
        _sessionTokenDestination = uuid.v4();
      });
    }
    getSuggestionDestination(_destinationController.text);
  }

  void getSuggestion(String input) async {
    String kPlaces_Api_Key = Config().mapKey;
    String baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request = '$baseURL?input=$input&key=$kPlaces_Api_Key&sessionToken=$_sessionToken';
    // print('$baseURL?input=$input&key=$kPlaces_Api_Key&sessionToken=$_sessionToken');
    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to Load Data');
    }
  }

  void getSuggestionDestination(String input) async {
    String kPlaces_Api_Key = Config().mapKey;;
    String baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request =  '$baseURL?input=$input&key=$kPlaces_Api_Key&sessionToken=$_sessionTokenDestination';
    // print('$baseURL?input=$input&key=$kPlaces_Api_Key&sessionToken=$_sessionToken');
    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      setState(() {
        _placesListDestination = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  final LatLng _center = const LatLng(45.521563, -122.677433);
  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    /*final googleMapWidget = GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 14.0,
      ),
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      padding: const EdgeInsets.only(top: 300),
    );*/

    
  
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Post a Ride', style: TextStyle(color: Colors.white),),
          leadingWidth: 100,
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SingleChildScrollView(
            
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 1.2,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //FROM WHERE?
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            'From Where?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 18
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        key: Key("departure_text_field"),
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Your Departure Location',
                          prefixIcon: const Icon(Icons.my_location),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isShowListTile,
                      child: Expanded(
                          child: Container(
                            color: Color(0xffF8F8F8),
                            height: 200,
                            child: ListView.builder(
                                itemCount: _placesList.length,
                                itemBuilder: ((context, index) {
                                  return Visibility(
                                    visible: isShowListTile,
                                    child: ListTile(
                                      onTap: () async {//here
                                        List<Location> locations =
                                        await locationFromAddress(
                                            _placesList[index]['description']);
                                        _controller.text =
                                        _placesList[index]['description'];
                                        departureLocation =
                                        _placesList[index]['description'];
                                        /** This is the option selected */
                                        print(_placesList[index]['description']);
                                        print(locations.last.longitude);
                                        print(locations.last.latitude);
                                        isShowListTile = false;
                                      },
                                      title: Text(
                                          _placesList[index]['description']),
                                      leading: Icon(Icons.pin_drop),
                                    ),
                                  );
                                })),
                          )),
                    ),
                    
                    //TO WHERE?
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            'Where To?',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        key: Key("destination_text_field"),
                        controller: _destinationController,
                        decoration: const InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Your Destination',
                          prefixIcon: const Icon(Icons.location_on_outlined),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isShowListTileDestination,
                      child: Expanded(
                          child: Container(
                            color: Color(0xffF8F8F8),
                            height: 200,
                            child: ListView.builder(
                                itemCount: _placesListDestination.length,
                                itemBuilder: ((context, index) {
                                  return Visibility(
                                    visible: isShowListTileDestination,
                                    child: ListTile(
                                      onTap: () async {//here
                                        List<Location> locationDestination =
                                        await locationFromAddress(
                                            _placesListDestination[index]
                                            ['description']);
                                        _destinationController.text =
                                        _placesListDestination[index]
                                        ['description'];
                                        destination =
                                        _placesListDestination[index]
                                        ['description'];

                                        /** This is the option selected */
                                        print(_placesListDestination[index]['description']);
                                        print(locationDestination.last.longitude);
                                        print(locationDestination.last.latitude);
                                        isShowListTileDestination = false;
                                      },
                                      title: Text(_placesListDestination[index]
                                      ['description']),
                                      leading: Icon(Icons.location_on_outlined),
                                    ),
                                  );
                                })),
                          )),
                    ),

                    //DEPARTURE DATE
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Date of Departure:',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: _datePicker(),
                    ),

                    //DEPARTURE TIME
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            'Departure Time:',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        key: Key("time_text_field"),
                        controller: timeinput,
                        //editing controller of this TextField
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.timer),
                          hintText: "Your Departure Time", //icon of text field
                        ),
                        readOnly:
                        true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if (pickedTime != null) {
                            print(pickedTime.format(context)); //output 10:51 PM
                            DateTime parsedTime = DateFormat.Hm()
                                .parse(pickedTime.format(context).toString());
                            //converting to DateTime so that we can further format on different pattern.
                            print(parsedTime); //output 1970-01-01 22:53:00.000
                            String formattedTime =
                            DateFormat('HH:mm').format(parsedTime);
                            print(formattedTime); //output 14:59:00
                            //DateFormat() is from intl package, you can format the time on any pattern you need.
                            
                            setState(() {
                              /** Setting Departure_Time to Time input controller */
                              timeinput.text = formattedTime;
                              departureTime = formattedTime;
                            });
                          } else {
                            print("Time is not selected");
                          }
                        },
                      ),
                    ),

                    

                    //PASSENGER LIMIT
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            'Maximum Number of Passengers Allowed:',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                          key: Key("fees_text_field"),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          keyboardType: TextInputType.number,
                          controller: passengerLimitController,
                          onChanged: (text) {
                            setState(() {
                               passengerLimit= text;
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Passenger Limit',
                            prefixIcon: Icon(Icons.people),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)
                    ),



                    ElevatedButton(
                      onPressed: () { //here
                        print(destination + departureLocation);
              
                        createRide(departureLocation, destination, departureDate, 
                            departureTime, passengerLimit, CarID, ethClient); //SC
                       
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RidesPublishedScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF008CFF),
                        onPrimary: Color(0xffF8F8F8),
                        fixedSize: const Size(150, 50),
                        textStyle:
                        const TextStyle(fontFamily: 'DM Sans', fontSize: 19),
                      ),
                      child: const Text("Post Ride"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }


  Widget _datePicker() {
    bool _decideWhichDayToEnable(DateTime day) {
      if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
          day.isBefore(DateTime.now().add(Duration(days: 30))))) {
        return true;
      }
      return false;
    }

    return TextField(
      key: Key("date_text_field"),
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.event),
        hintText: "Date",
      ),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          // firstDate: DateTime(2000),
          // lastDate: DateTime(2100),
          firstDate: new DateTime(DateTime.now().year),
          lastDate: new DateTime(DateTime.now().year + 1),
          initialDate: DateTime.now(),
          //selectableDayPredicate: (day) => day.isBefore(DateTime.now()),
          // selectableDayPredicate: (day) => day.isAfter(DateTime.now()),
          selectableDayPredicate: _decideWhichDayToEnable,
        );
        if (selectedDate != null) {
          setState(() {
            /** Setting Departure_Date that will be in post function to _dateController.text for date of departure */
            _dateController.text = DateFormat.yMd().format(selectedDate);
            print("####" + _dateController.text);
            departureDate = DateFormat.yMd()
                .format(selectedDate); //set the value of text field.
          });
        }
      },
    );
  }
}

