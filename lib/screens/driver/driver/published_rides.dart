import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../apis/contract.dart';
import '/models/rides.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/rides.dart';
import '/apis/rides_api.dart';
import '/apis/google_api.dart';

void main() {
  runApp(RidesPublishedScreen());
}

class RidesPublishedScreen extends StatefulWidget {
  @override
  State<RidesPublishedScreen> createState() => _RidesPublishedScreenState();
}

class _RidesPublishedScreenState extends State<RidesPublishedScreen> {
  late Future<List<Rides>>? futureRides;
  late final DateFormat formatter;
  Future<List<Rides>>? ridesFuture;
  
  @override
  void initState() {
    super.initState();
    //ridesFuture = Contract();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Available Rides'),
        leadingWidth: 100,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async { Navigator.pop(context);},
          icon: Icon(FontAwesomeIcons.arrowLeft),
        ),
        ),
      
      body: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Flexible(
                      child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: const Color(0xFF008CFF),
                            ),
                            borderRadius:
                                BorderRadius.circular(10.0), //<-- SEE HERE
                          ),
                          elevation: 10,
                          shadowColor: Colors.black,
                          color: const Color(0xffF8F8F8),
                          child: SizedBox(
                            width: 400,
                            height: 210,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.my_location,
                                            color: Color(0xFF008CFF)),
                                        const Text(
                                          'Departure Location: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            Contract().departureLocation,
                                            style: TextStyle(
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
                                        Icon(Icons.location_on_outlined,
                                            color: Color(0xFF008CFF)),
                                        const Text(
                                          'Destination: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          Contract().destination,
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
                                        Icon(Icons.date_range,
                                            color: Color(0xFF008CFF)),
                                        const Text(
                                          'Date of pick up: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          Contract().departureDate,
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
                                        Icon(Icons.timer,
                                            color: Color(0xFF008CFF)),
                                        const Text(
                                          'Time of Pick Up: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          Contract().departureTime,
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
                                          'Number of Allowed Passengers: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          Contract().passengerLimit,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'DM Sans',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                );/*FutureBuilder<List<Rides>>(
        future: ridesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Flexible(
                      child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: const Color(0xFF008CFF),
                            ),
                            borderRadius:
                                BorderRadius.circular(10.0), //<-- SEE HERE
                          ),
                          elevation: 10,
                          shadowColor: Colors.black,
                          color: const Color(0xffF8F8F8),
                          child: SizedBox(
                            width: 400,
                            height: 210,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.my_location,
                                            color: Color(0xFF008CFF)),
                                        const Text(
                                          'Departure Location: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            snapshot.data![index].Destination
                                                .toString(),
                                            style: TextStyle(
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
                                        Icon(Icons.location_on_outlined,
                                            color: Color(0xFF008CFF)),
                                        const Text(
                                          'Destination: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          snapshot
                                              .data![index].Departure_Location
                                              .toString(),
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
                                        Icon(Icons.date_range,
                                            color: Color(0xFF008CFF)),
                                        const Text(
                                          'Date of pick up: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data![index].Departure_Date
                                              .toString(),
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
                                        Icon(Icons.timer,
                                            color: Color(0xFF008CFF)),
                                        const Text(
                                          'Time of Pick Up: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data![index].Departure_Time
                                              .toString(),
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
                                          'Number of Allowed Passengers: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'DM Sans',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data![index].Ride_Fees
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'DM Sans',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                ); //SizedBox
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
         // return Text("false");
          return const CircularProgressIndicator();*/
        },
      ),
    );
  }
}