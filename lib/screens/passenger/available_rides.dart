// ignore_for_file: non_constant_identifier_names

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:web3dart/web3dart.dart';

import '../../services/functions.dart';
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
  
  @override
  void initState() {
    super.initState();
    httpClient = http.Client();
    ethClient = Web3Client(infura_url, httpClient!);
  }
  
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Available Rides For You'),
        leadingWidth: 100,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async { Navigator.pop(context);},
          icon: const Icon(FontAwesomeIcons.arrowLeft),
        ),
      ),

      body: RefreshIndicator(
          onRefresh: () { 
            getRide(k+1, ethClient);
            return Future.delayed(Duration(seconds: 1));
           },
          child: Column(
            children: [
              FutureBuilder<List>(
              future: getRidesNum(ethClient),
              builder: (context, snapshot) {
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } 
                else if (snapshot.hasData) {
                  return Column(
                    children: [
                            for (int i = 0; i < snapshot.data![0].toInt(); i++)
                              FutureBuilder<List>(
                                  future: getRide(i, ethClient),
                                  builder: (context, ridesnapshot) {
                                    k = i;
                                    if (ridesnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } 
                                    else {
                                      
                      return ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Flexible(child: GestureDetector(
                        onTap: () async{/*
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConfirmRideScreen(idCar: snapshot.data![index].id.toString()),
                            ),
                          );*/

                          // _loadData(snapshot.data![index].id
                          //     .toString());
                        },
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
                                                    'From: ',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'DM Sans',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      ridesnapshot.data![0][1].toString(),
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
                                                    'To: ',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'DM Sans',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    ridesnapshot.data![0][2].toString(),
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
                                                    'Pick Up Date: ',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'DM Sans',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  /*Text(
                                                    snapshot.data![index].Departure_Date
                                                        .toString(),
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
                                                    '   Pick Up Time: ',
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
                                                    'Passenger Limit: ',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'DM Sans',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  /*Text(
                                                    snapshot.data![index].Ride_Fees
                                                        .toString(),
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
                                    }})
                     ] );
               ;} 
 
           else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            // No data found in the snapshot which means no rides!
            return Padding(
              padding: EdgeInsetsDirectional.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          'images/emptyWindow.png',
                          width: 360,
                          height: 360,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'It seems like there is no rides here!',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Please try another time.',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          color: Color(0xFF0000EE),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const CircularProgressIndicator();
        },
      ),
    ],)));
  }
