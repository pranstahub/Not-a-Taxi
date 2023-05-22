// ignore_for_file: non_constant_identifier_names

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:not_a_taxi/screens/passenger/passenger_menu.dart';
import 'package:web3dart/web3dart.dart';
import '../../services/functions.dart';
import '../../services/route_checker.dart' as route;
import '../../utils/buffering_animation.dart';
import '../../utils/constants.dart';
import '/screens/passenger/confirm_ride.dart';
import '/screens/passenger/search_rides.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/apis/rides_api.dart';
import '/models/rides.dart';
import 'package:http/http.dart' as http;

class AvailableRidesPerSearchScreen extends StatefulWidget {
  final String Destination;
  final String Departure;
  final String Date;
  const AvailableRidesPerSearchScreen(
      {Key? key, required this.Destination, required this.Departure, required this.Date})
      : super(key: key);

  @override
  State<AvailableRidesPerSearchScreen> createState() =>
      _AvailableRidesPerSearchScreenState();
}

class _AvailableRidesPerSearchScreenState extends State<AvailableRidesPerSearchScreen> {

  late final DateFormat formatter;
  late Web3Client ethClient;
  http.Client? httpClient;
  late int k;
  late String destination;
  late String departure;
  late String date;
  
  
  @override
  void initState() {
    super.initState();
    httpClient = http.Client();
    ethClient = Web3Client(infura_url, httpClient!);
    destination = widget.Destination;
    departure = widget.Departure;
    date = widget.Date;
  }
  
  Future refresh() async {
    getRide(k+1, ethClient);
      return Future.delayed(const Duration(seconds: 1));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Available Rides'),
        leadingWidth: 100,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async { Navigator.pop(context);},
          icon: const Icon(FontAwesomeIcons.arrowLeft),
        ),
      ),

      body: SingleChildScrollView(
        child: RefreshIndicator(
            onRefresh: refresh,
            child: Column(
              children: [
                FutureBuilder<List>(
                  future: getRidesNum(ethClient),
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print("Waitesh");
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(height: 300.0),
                            BufferingAnimation(), 
                            SizedBox(height: 25.0), // Add the buffering animation widget here
                            Text('Fetching Rides...', 
                            style:TextStyle(fontSize: 18)),
                          ],
                        ),
                      );
                    }

                  else if (snapshot.data!.isNotEmpty) { 
                    print("oi");
                    return Column(
                      children: [
                        for (int i = 0; i < snapshot.data![0].toInt(); i++)
                                FutureBuilder<List>(
                                    future: getRide(i, ethClient),
                                    builder: (context, ridesnapshot) {
                                      k = i;
                                      Future<bool> matched = route.checkPassengerRide(
                                        ridesnapshot.data![0][1].toString(), //driver start
                                        ridesnapshot.data![0][2].toString(), //driver end
                                        destination, //passenger start
                                        departure //passenger end
                                      );

                                     /* if(matched == true) /*|| ridesnapshot.data![0][4].toString() != date)*/{
                                        print("Matched?");*/
                                        if (ridesnapshot.connectionState == ConnectionState.waiting) {
                                          print("Vattam but in Matched");
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } 
                                        
                                        else {
                                        print("MATCHED!");
                                        return ListView.builder(
                                          physics: const AlwaysScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Flexible(child: GestureDetector(
                                                  onTap: () async{
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => 
                                                          ConfirmRideScreen(idCar: ridesnapshot.data![0][4].toString(),
                                                            start: ridesnapshot.data![0][1].toString(),
                                                            end: ridesnapshot.data![0][2].toString(),
                                                            time: ridesnapshot.data![0][3].toString()
                                                          ),
                                                      ),
                                                    );
                                                  },
                                                  child: Card(
                                                    shape: RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                          color: Color(0xFF008CFF),
                                                        ),
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    elevation: 10,
                                                    shadowColor: Colors.black,
                                                    color: const Color(0xffF8F8F8),
                                                    child: SizedBox(
                                                      //width: 400,
                                                      //height: 210,
                                                      child: Padding(
                                                        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(5),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    const Icon(Icons.my_location,
                                                                        color: Color(0xFF008CFF)),
                                                                    const Text(
                                                                      ' From: ',
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontFamily: 'DM Sans',
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      child: Text(
                                                                        ridesnapshot.data![0][1].toString(),
                                                                        style: const TextStyle(
                                                                          fontSize: 15,
                                                                          fontFamily: 'DM Sans',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(5),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.start,
                                                                  children: [
                                                                    const Icon(Icons.location_on_outlined,
                                                                        color: Color(0xFF008CFF)),
                                                                    const Text(
                                                                      ' To: ',
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontFamily: 'DM Sans',
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ridesnapshot.data![0][2].toString(),
                                                                      style: const TextStyle(
                                                                        fontSize: 15,
                                                                        fontFamily: 'DM Sans',
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(5),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.start,
                                                                  children: const [
                                                                    Icon(Icons.date_range,
                                                                        color: Color(0xFF008CFF)),
                                                                    Text(
                                                                      ' Date: ',
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontFamily: 'DM Sans',
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    /*Text(
                                                                      ridesnapshot.data![0][4].toString(),
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontFamily: 'DM Sans',
                                                                      ),
                                                                    ),*/
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(5),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.start,
                                                                  children: [
                                                                    Icon(Icons.timer,
                                                                        color: Color(0xFF008CFF)),
                                                                    const Text(
                                                                      ' Departure Time: ',
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontFamily: 'DM Sans',
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ridesnapshot.data![0][3].toString(),
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontFamily: 'DM Sans',
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(5),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.start,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.money,
                                                                      color: Color(0xFF008CFF),
                                                                    ),
                                                                    const Text(
                                                                      ' Seats Available: ',
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontFamily: 'DM Sans',
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    /*Text(
                                                                      ridesnapshot.data![0][5].toString(),
                                                                      style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontFamily: 'DM Sans',
                                                                      ),
                                                                    ),*/
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),//COLUMN
                                                        ),
                                                      )//sizedbox
                                                    ),
                                                ),
                                              )); //SizedBox
                                                          },);
                                      }//}
                                      return const CircularProgressIndicator();
                                      })
                       ] );
                       
                 } 
       
             else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } 
            
            else {
              // No data found in the snapshot which means no rides!
              return Padding(
                padding: const EdgeInsetsDirectional.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/img/wait.png',
                            width: 360,
                            height: 360,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          'Uh Oh!',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            color: Colors.red,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          'It seems like there are no rides here!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          'Please try again later.',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                             Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => passengerHome(),
                                  ),
                                );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Colors.blue,
                              //onPrimary: Colors.black,
                              fixedSize: Size(150, 50),
                              textStyle: TextStyle(fontFamily: 'DM Sans', fontSize: 19),
                            ),
                            child: const Text("Go Home"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
      
            //return const CircularProgressIndicator();
          },
        ),
          ],)),
      ));
  }
}