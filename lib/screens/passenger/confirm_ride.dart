import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/screens/passenger/ride_confirmed.dart';
import 'package:flutter/material.dart';

import '/apis/car_api.dart';
import '/apis/rides_api.dart';
import '/models/car.dart';
import '/models/rides.dart';

class ConfirmRideScreen extends StatefulWidget {
  final String idCar;
  const ConfirmRideScreen({Key? key, required this.idCar}) : super(key: key);

  @override
  State<ConfirmRideScreen> createState() => _ConfirmRideScreenState();
}

class _ConfirmRideScreenState extends State<ConfirmRideScreen> {
  String id = "";
  @override
  void initState() {
    super.initState();
    print(widget.idCar);
    setState(() {
      id = (widget.idCar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Verify Ride' ),
        leadingWidth: 100,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async { Navigator.pop(context);},
          icon: const Icon(FontAwesomeIcons.arrowLeft),
        ),
      ),
      body: FutureBuilder<List>(
        //future: ridesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
            
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.96,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
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
                                      padding: EdgeInsetsDirectional.fromSTEB(
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
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16, 12, 16, 8),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  'Car brand: Ford',
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 0, 4),
                                                  child: Text('Car color: Black',
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                    
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 4, 0, 4),
                                                  child: Text('Energy type: Electric',
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                    
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
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
                                                snapshot.data![index].Ride_Fees
                                                    .toString() +
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
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}