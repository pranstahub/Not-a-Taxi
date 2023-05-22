import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:not_a_taxi/database_manager.dart';
import '/screens/passenger/ride_confirmed.dart';
import 'package:flutter/material.dart';


class ConfirmRideScreen extends StatefulWidget {
  final String idCar;
  final String start;
  final String end;
  final String time;
  const ConfirmRideScreen({Key? key, required this.idCar,
    required this.start,
    required this.end,
    required this.time
  }) : super(key: key);

  @override
  State<ConfirmRideScreen> createState() => _ConfirmRideScreenState();
}

class _ConfirmRideScreenState extends State<ConfirmRideScreen> {
  String id = "";
  String start = "";
  String end = "";
  String time = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      id = (widget.idCar);
      start = (widget.start);
      end = (widget.end);
      time = (widget.time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Confirm Ride' ),
        leadingWidth: 100,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async { Navigator.pop(context);},
          icon: const Icon(FontAwesomeIcons.arrowLeft),
        ),
      ),
      
      body: ListView.builder(
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
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1626806592005-7e371149356e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                                    width:
                                        MediaQuery.of(context).size.width *
                                            0.9,
                                    height: 220,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              
              
                              //Registration Number
                                        FutureBuilder(
                                          future: DatabaseManager().getCarDetail(id, "Registration Number"),
                                          builder: (context, snapshot) {
                                            return Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.start,
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
                                          future: DatabaseManager().getCarDetail(id, "Brand"),
                                          builder: (context, snapshot) {
                                            return Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.start,
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
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Text('Model: ',
                                                    style: TextStyle(fontSize: 17, color: Color(0xFF008CFF)),),
                                                  //Text(model,style: const TextStyle(fontSize: 18),),
                                                  //Text(stringReducer(snapshot.data.toString()),style: const TextStyle(fontSize: 20),),
                                                ],
                                              ),
                                            );
                                          }
                                        ),
                                        //Color
                                        FutureBuilder(
                                          future: DatabaseManager().getCarDetail(id, "Color"),
                                          builder: (context, snapshot) {
                                            return Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const Text('Color: ',
                                                    style: TextStyle(fontSize: 17, color: Color(0xFF008CFF)),),
                                                  Text(snapshot.data.toString(),style: const TextStyle(fontSize: 18),),
                                                ],
                                              ),
                                            );
                                          }
                                        ),

                              Divider(
                                height: 4,
                                thickness: 1,
                                //   color: FlutterFlowTheme.of(context).primaryBackground,
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'From: ', style: TextStyle(fontSize: 17, color:Colors.blue),
                                      //   style: FlutterFlowTheme.of(context).subtitle2,
                                    ),
                                    Text(start, style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'To: ', style: TextStyle(fontSize: 17, color:Colors.blue),
                                      //   style: FlutterFlowTheme.of(context).subtitle2,
                                    ),
                                    Text(end, style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date: ', style: TextStyle(fontSize: 17, color:Colors.blue),
                                      //   style: FlutterFlowTheme.of(context).subtitle2,
                                    ),
                                    //Text(start, style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Time: ', style: TextStyle(fontSize: 17, color:Colors.blue),
                                      //   style: FlutterFlowTheme.of(context).subtitle2,
                                    ),
                                    Text(time, style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),

                              Divider(
                                height: 4,
                                thickness: 1,
                                //   color: FlutterFlowTheme.of(context).primaryBackground,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 0, 16, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Price : ' +
                                          // snapshot.data!.toString() +
                                          "TND",
                                      style: TextStyle(fontSize: 20),
                                      //   style: FlutterFlowTheme.of(context).subtitle2,
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(50),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RideConfirmed(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            primary: Color(0xFF008CFF),
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
            )
          
    );
  }
}