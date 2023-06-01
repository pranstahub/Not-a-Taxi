import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:not_a_taxi/database_manager.dart';
import 'package:not_a_taxi/screens/passenger/pass_metamask.dart';
import 'package:not_a_taxi/screens/passenger/pass_payment.dart';
import 'package:not_a_taxi/screens/passenger/upi.dart';
import 'package:not_a_taxi/services/functions.dart';
import 'package:not_a_taxi/utils/globals.dart' as global;
import 'package:web3dart/web3dart.dart';
import '../../utils/constants.dart';
import '/screens/passenger/ride_confirmed.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConfirmRideScreen extends StatefulWidget {
  final String idCar;
  final String start;
  final String end;
  final String date;
  final String time;
  final String limit;
  const ConfirmRideScreen({Key? key, required this.idCar,
    required this.start,
    required this.end,
    required this.date,
    required this.time,
    required this.limit
  }) : super(key: key);



  @override
  State<ConfirmRideScreen> createState() => _ConfirmRideScreenState();
}

class _ConfirmRideScreenState extends State<ConfirmRideScreen> {
  String id = "";
  String start = "";
  String end = "";
  String date = "";
  String time = "";
  String limit = "";
  String fare = "100.00";
  
  http.Client? httpClient;
  late Web3Client ethClient;

  @override
  void initState() {
    super.initState();
    httpClient = http.Client();
    ethClient = Web3Client(infura_url, httpClient!);
    setState(() {
      id = (widget.idCar);
      start = (widget.start);
      end = (widget.end);
      date = (widget.date);
      time = (widget.time);
      limit = (widget.limit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Confirm Ride' ),
        leadingWidth: 100,
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async { Navigator.pop(context);},
          icon: const Icon(FontAwesomeIcons.arrowLeft),
        ),
      ),
      
      body: Container(
        width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height,
                                          decoration: const BoxDecoration(
                                          image: DecorationImage(
                                          image: AssetImage("assets/img/COMMONSCREEN.jpg"),
                                          fit: BoxFit.fill,
                                        )),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.96,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 3,
                                  color: Color(0x49000000),
                                  offset: Offset(0, 1),
                                )
                              ],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 8, 8, 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: /*Image.network(
                                      'https://images.unsplash.com/photo-1626806592005-7e371149356e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',*/
                                      Image.asset("assets/img/confirm.png",
                                      width:
                                          MediaQuery.of(context).size.width *
                                              0.9,
                                      height: 220,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                
                
                                //DRIVER NAME
                                          FutureBuilder(
                                            future: DatabaseManager().getUserData(id, "Full Name"),
                                            builder: (context, snapshot) {
                                              return Padding(
                                                padding: const EdgeInsets.all(9),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text('Driver: ',
                                                      style: TextStyle(fontSize: 18, color: Color(0xFF008CFF)),),
                                                    Text(snapshot.data.toString(),style: const TextStyle(fontSize: 20,
                                                    fontWeight: FontWeight.w600),),
                                                  ],
                                                ),
                                              );
                                            }
                                          ),
                                          //Brand
                                          FutureBuilder(
                                            future: DatabaseManager().getCarDetail(id, "Brand"),
                                            builder: (context, snapshot) {
                                              return Padding(
                                                padding: const EdgeInsets.all(9),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Text('Car: ',
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
                                            future: DatabaseManager().getCarDetail(id, "Model"),
                                            builder: (context, snapshot) {
                                              //model = stringReducer(snapshot.data.toString());
                                              return Padding(
                                                padding: const EdgeInsets.all(9),
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
                                          /*FutureBuilder(
                                            future: DatabaseManager().getCarDetail(id, "Color"),
                                            builder: (context, snapshot) {
                                              return Padding(
                                                padding: const EdgeInsets.all(7),
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
                                          ),*/
      
                                Divider(
                                  height: 4,
                                  thickness: 1,
                                  //   color: FlutterFlowTheme.of(context).primaryBackground,
                                ),
      
                                Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'From: ', style: TextStyle(fontSize: 17, color:Colors.blue),
                                        //   style: FlutterFlowTheme.of(context).subtitle2,
                                      ),
                                      Flexible(child: Text(start, 
                                      style: TextStyle(fontSize: 18),textAlign: TextAlign.end)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'To: ', style: TextStyle(fontSize: 17, color:Colors.blue),
                                        //   style: FlutterFlowTheme.of(context).subtitle2,
                                      ),
                                      Flexible(child: Text(end, 
                                      style: TextStyle(fontSize: 18),textAlign: TextAlign.end)),
                                    ],
                                  ),
                                ),
      
                                Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Your Stop: ', style: TextStyle(fontSize: 17, color:Colors.blue),
                                        //   style: FlutterFlowTheme.of(context).subtitle2,
                                      ),
                                      Flexible(fit: FlexFit.values.first,
                                        child: Text(global.globalDestination,
                                         style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.end,)),
                                    ],
                                  ),
                                ),
      
      
                                Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Date: ', style: TextStyle(fontSize: 17, color:Colors.blue),
                                        //   style: FlutterFlowTheme.of(context).subtitle2,
                                      ),
                                      Text(date, style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Time (24h): ', style: TextStyle(fontSize: 17, color:Colors.blue),
                                        //   style: FlutterFlowTheme.of(context).subtitle2,
                                      ),
                                      Text(time, style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ),
      
                                const Divider(
                                  height: 4,
                                  thickness: 1,
                                  //   color: FlutterFlowTheme.of(context).primaryBackground,
                                ),
                                
                                Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Fare : ', style: TextStyle(fontSize: 18,color: Colors.blue)),
                                      
                                      Text('\u{20B9}${global.globalFare}', style: TextStyle(fontSize: 22 ,color: Colors.green)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: ElevatedButton(
                            onPressed: () {
                              global.driverID = id;
                              global.start = start;
                              global.end = end;
                              global.date = date;
                              global.time = time;

                              /*DatabaseManager().allocatePassenegerToRide(id, global.userID);
                              bookRide(global.userID, id, start, global.globalDestination,
                                 end, date, time, global.globalFare.toString(), ethClient);*/
      
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => metaMaskPass(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Colors.orange,
                              onPrimary: Colors.white,
                              fixedSize: Size(150, 50),
                              textStyle: TextStyle(fontFamily: 'DM Sans', fontSize: 19),
                            ),
                            child: const Text("Confirm Ride"),
                          ),
      
                        ),
                        ],
                    ),
                  ),
                ),
              ),
            );
            
                },
              ),
      )
          
    );
  }
}