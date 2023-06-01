// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:not_a_taxi/services/functions.dart';
import 'package:not_a_taxi/utils/constants.dart';
import 'package:web3dart/web3dart.dart';
import '../../services/fuel_price.dart';
import '/config.dart';
import 'available_rides.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../utils/globals.dart' as global;

void main() {
  runApp(SearchRideScreen());
}

class SearchRideScreen extends StatefulWidget {
  @override
  State<SearchRideScreen> createState() => _SearchRideScreenState();
}

class _SearchRideScreenState extends State<SearchRideScreen> {
  http.Client? httpClient;
  late Web3Client ethClient;


  final FocusNode _focus = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  var uuid = const Uuid();
  String? _sessionToken;//"1235";
  String _sessionTokenDestination = "12356";
  List<dynamic> _placesList = [];
  List<dynamic> _placesListDestination = [];

  String destination = "";
  String departureDate = "";
  String departureLocation = "";
 
  late bool isShowListTile = true;
  late bool isShowListTileDestination = true;

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
    _controller.addListener(() {
      onChange();
    });
    _destinationController.addListener(() {
      onChangeDestination();
    });
    _focus.addListener(_onFocusChange);
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

  //final LatLng _center = const LatLng(45.521563, -122.677433);
  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Search for a Ride', style: TextStyle(color: Colors.white),),
          leadingWidth: 100,
          backgroundColor: Colors.orange,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
        ),

        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(image:AssetImage("assets/img/COMMONSCREEN.jpg"),
            fit: BoxFit.fill ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 1.2,
                child: Card(
                  margin: EdgeInsets.only(right:15, left:15, top:10, bottom:10),
                    shape: RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                          color: Colors.orange,
                                                        ),
                                                      borderRadius: BorderRadius.circular(25.0),
                                                    ),
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    color: const Color(0xffF8F8F8),
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
                          key: const Key("departure_text_field"),
                          controller: _controller,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Your Departure Location',
                            prefixIcon: Icon(Icons.my_location),
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
                                        onTap: () async {
                                          List<Location> locations =
                                            await locationFromAddress(_placesList[index]['description']);
                                          _controller.text = _placesList[index]['description'];
                                          departureLocation = _placesList[index]['description'];
                                          /** This is the option selected */
                                          print(_placesList[index]['description']);
                                          print(locations.last.longitude);
                                          global.passengerDepartureLongitude = locations.last.longitude;
                                          print(locations.last.latitude);
                                          global.passengerDepartureLatitude = locations.last.latitude;
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
                                          await locationFromAddress(_placesListDestination[index]['description']);
                                          _destinationController.text = _placesListDestination[index]['description'];
                                          destination = _placesListDestination[index]['description'];
                        
                                          /** This is the option selected */
                                          print(_placesListDestination[index]['description']);
                                          global.globalDestination = destination;
                                          print(locationDestination.last.longitude);
                                          global.passengerDestinationLongitude = locationDestination.last.longitude;
                                          print(locationDestination.last.latitude);
                                          global.passengerDestinationLatitude = locationDestination.last.latitude;
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
                        
                      
                      /*Padding(
                        padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom)
                      ),*/
                        
                      const SizedBox(height: 30.0),
                        
                      ElevatedButton(
                        onPressed: () { //here
                          print(destination + departureLocation);
                          //scrapePetrolAndDieselPrices();
                          //createRide(departureLocation, destination, departureTime, ethClient);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AvailableRidesPerSearchScreen( 
                                Destination: _destinationController.text, 
                                Departure: _controller.text,
                                Date: _dateController.text),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary:  Colors.orange,
                          onPrimary: Color(0xffF8F8F8),
                          fixedSize: const Size(150, 50),
                          textStyle:
                          const TextStyle(fontFamily: 'DM Sans', fontSize: 19),
                        ),
                        child: const Text("Search Ride"),
                      ),
                    ],
                  ),
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



              /*Expanded(
                child: GoogleMap(
                  onTap: (point) {
                    setState(() {
                      polygonLatLngs.add(point);
                      _setPolygon();
                    });
                  },
                  polylines: _polyline,
                  markers: _markers,
                  polygons: _polygons,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 8.5,
                  ),
                ),
                
              ),*/
              /*Column(
                  children: [
                    const SizedBox(height: 120.0),
                    Center(
                      child: Image.asset(
                        'assets/img/wantalift.png',
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),],)*/





