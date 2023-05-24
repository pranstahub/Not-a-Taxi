import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:not_a_taxi/database_manager.dart';
import 'package:not_a_taxi/screens/passenger/passenger_menu.dart';
import 'package:not_a_taxi/screens/passenger/ride_started.dart';
import 'package:not_a_taxi/utils/globals.dart' as global;
import 'package:web3dart/web3dart.dart';
import '../../services/functions.dart';
import '../../utils/buffering_animation.dart';
import '../../utils/constants.dart';
import '/screens/passenger/ride_confirmed.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class BookedRide extends StatefulWidget {
  @override
  State<BookedRide> createState() => _BookedRideState();
}

class _BookedRideState extends State<BookedRide> {

  late Web3Client ethClient;
  http.Client? httpClient;

  String id ="";
  
  @override
  void initState() {
    super.initState();
    httpClient = http.Client();
    ethClient = Web3Client(infura_url, httpClient!);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Booked Ride(s)' ),
        leadingWidth: 100,
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async { Navigator.pop(context);},
          icon: const Icon(FontAwesomeIcons.arrowLeft),
        ),
      ),
      
      body: SingleChildScrollView(
        child: FutureBuilder<List>(
          future: getBookedRidesNum(ethClient),
          builder: (context, snapshot) {
        
            if (snapshot.connectionState == ConnectionState.waiting) {
              print("Arnold");
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(height: 300.0),
                    BufferingAnimation(), 
                    SizedBox(height: 25.0), // Add the buffering animation widget here
                    Text('Fetching Booked Rides...', 
                      style:TextStyle(fontSize: 18)),
                  ],
                ),
              );
            }
        
            else if (snapshot.data![0].toInt() > 0) { 
              print("Barry");
              return Column(
                children: [
                  for (int i = 0; i < snapshot.data![0].toInt(); i++)
                  FutureBuilder<List>(
                    future: getBookedRide(i, ethClient),
                    builder: (context, ridesnapshot) {
        
                        if (ridesnapshot.connectionState == ConnectionState.waiting) {
                          print("Charlie");
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                SizedBox(height: 300.0),
                                BufferingAnimation(), 
                                SizedBox(height: 25.0), 
                                Text('Still Fetching...', 
                                style:TextStyle(fontSize: 18)),
                              ],
                            ),
                          );
                        }
        
                        else { 
                          id = ridesnapshot.data![0][1].toString();
                          if(global.userID == ridesnapshot.data![0][0].toString()) {
                            print("Dennis?");
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height,
                                          decoration: const BoxDecoration(
                                          image: DecorationImage(
                                          image: AssetImage("assets/img/COMMONSCREEN.jpg"),
                                          fit: BoxFit.fill,
                                        )),
                                child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 1,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),  
                                        child: Flexible(child: GestureDetector(
                                                    onTap: () async{ showAlertDialog(context);} ,                                   
                                            child: SafeArea(
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
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
                                                                  child: Image.asset(
                                                                    /*'https://static.blog.bolt.eu/LIVE/wp-content/uploads/2022/06/30134551/ride-booker-book-rides-for-your-team-1024x536.jpg',*/
                                                                    'assets/img/pass_wait.jpg',
                                                                    width:
                                                                        MediaQuery.of(context).size.width *
                                                                            0.9,
                                                                    height: 150,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              ),
                                                
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
                                          
                                              FutureBuilder(
                                                future: DatabaseManager().getUserData(id, "Mobile"),
                                                builder: (context, snapshot) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(9),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text('Mobile: ',
                                                        style: TextStyle(fontSize: 18, color: Color(0xFF008CFF)),),
                                                        
                                                      Text(snapshot.data.toString(),style: const TextStyle(fontSize: 19),),
                                                      //Text(stringReducer(snapshot.data.toString()),style: const TextStyle(fontSize: 20),),
                                                    ],
                                                  ),
                                                );
                                                }
                                              ),
                                                
                                              //RegNo
                                              FutureBuilder(
                                                future: DatabaseManager().getCarDetail(id, "Registration Number"),
                                                builder: (context, snapshot) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(9),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Text('Registration Number: ',
                                                        style: TextStyle(fontSize: 17, color: Color(0xFF008CFF)),),
                                                        
                                                      Text(snapshot.data.toString(),style: const TextStyle(fontSize: 18),),
                                                      //Text(stringReducer(snapshot.data.toString()),style: const TextStyle(fontSize: 20),),
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
                                              FutureBuilder(
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
                                              ),
                                                
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
                                                                            Flexible(child: Text(ridesnapshot.data![0][2], style: TextStyle(fontSize: 18))),
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
                                                                            Flexible(child: Text(ridesnapshot.data![0][4], style: TextStyle(fontSize: 18))),
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
                                            child: Text(ridesnapshot.data![0][3], style: TextStyle(fontSize: 18),
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
                                                                            Text(ridesnapshot.data![0][5], style: TextStyle(fontSize: 18)),
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
                                                                            Text(ridesnapshot.data![0][6], style: TextStyle(fontSize: 18)),
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
                                                                            
                                                                            Text('\u{20B9}${ridesnapshot.data![0][7]}', style: TextStyle(fontSize: 22 ,color: Colors.green)),
                                                                          ],
                                                                        ),
                                                                      ),             
                                                             
                                                                            ],
                                                                          ),//COLUMN
                                                                        ),
                                                                      )
                                                                      ]//sizedbox
                                                                    ),
                                                                ))),
                                          ) ));//SizedBox
                                                                          },),
                              );
                                                                        
                                                    }
else {
                                                print("Komalan1");
                              return Padding(
                    padding: const EdgeInsetsDirectional.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height:80),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/img/QQQ.png',
                                width: 360,
                                height: 360,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40,),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Looks like you don't have any rides booked!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:80),
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

                                              
                                              }
                                                /*else {
                              print("Komalan2");
                              return Padding(
                    padding: const EdgeInsetsDirectional.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/img/QQQ.png',
                                width: 360,
                                height: 360,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40,),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Looks like you don't have any rides booked!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ); } *///here
                                              } ) ] );
                            }

                            else {
                              print("Komalan3");
                              return Padding(
                    padding: const EdgeInsetsDirectional.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height:70),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/img/QQQ.png',
                                width: 360,
                                height: 360,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40,),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              "Looks like you don't have any rides booked!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:80),
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
                              primary: Colors.orange,
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
                            
                    }
        
        
                                  ),
      ),
                              
              
                                        
                            
                  
                  );
          
          
              }
           
          
  showAlertDialog(BuildContext context) {

    Widget cancelButton = TextButton(
      child: const Text("Cancel",style: TextStyle(color: Colors.red),),
      onPressed: () {
        Navigator.of(context).pop();  
      },
    );

    Widget continueButton = TextButton(
      child: const Text("Let's Ride!",style: TextStyle(color: Colors.green),),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => 
              RideStartedScreen())); // dismiss dialog
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Looks like your Ride's here!", style: TextStyle(color: Colors.blue),),
      content: const Text("Are you sure you want to Start this Ride?"),
      actions: [cancelButton, continueButton ],
    );
 
    showDialog(
      context: context,
      builder: (BuildContext context) {
      return alert;
      },
    );
  }
  
}