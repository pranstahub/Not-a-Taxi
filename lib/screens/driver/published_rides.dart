import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:not_a_taxi/screens/driver/driver_menu.dart';
import 'package:not_a_taxi/services/functions.dart';
import 'package:web3dart/web3dart.dart';

import '../../apis/contract.dart';
import '../../utils/buffering_animation.dart';
import '../../utils/constants.dart';
import '../role_selector.dart';
import '/models/rides.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/rides.dart';
import '/apis/rides_api.dart';
import '/apis/google_api.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(RidesPublishedScreen());
}

class RidesPublishedScreen extends StatefulWidget {
  @override
  State<RidesPublishedScreen> createState() => _RidesPublishedScreenState();
}

class _RidesPublishedScreenState extends State<RidesPublishedScreen> {
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
    //ethClient = Web3Client(infura_url, httpClient!);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      
      body:               
        RefreshIndicator(
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
                  print("in 1.1");
                        return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [const SizedBox(height: 300.0),
            BufferingAnimation(), 
            const SizedBox(height: 25.0),// Add the buffering animation widget here
            Text('Fetching your Rides...', 
            style:TextStyle(fontSize: 18)),
          ],
        ),
      );
                      } 
                else if (!snapshot.data!.isNotEmpty) {
                  print("in 1.2");
                  return Column(
                    children: [
                            for (int i = 0; i < snapshot.data![0].toInt(); i++)
                              FutureBuilder<List>(
                                  future: getRide(i, ethClient),
                                  builder: (context, ridesnapshot) {
                                    k = i;
                                    if (ridesnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                          print("in 2.1");
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } 
                                    else {
                                      print("in 2.2");
                                      
                      return ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ridesnapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
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
                                                    ' To: ',
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
                                                    ' Pick Up Date: ',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'DM Sans',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    ridesnapshot.data![0][4].toString(),
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
                                                    ' Pick Up Time: ',
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
                                                    ' Passenger Limit: ',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'DM Sans',
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),/*
                                                  Text(
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
                            ); //SizedBox
                                        },);
                                    }})
                     ] );
               } /*else if (snapshot.hasError) {
                 print("shit");
                  return Text('${snapshot.error}');
                }*/
                else {
                 print("in 3");
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
                  /*const Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'Oops!',
                        style: TextStyle(
                           color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),*/
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "Looks like you don't have an active ride!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top:20, right: 20, left:20),
                    child: Center(
                      child: Text(
                        "Please add one!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Text(
                        "(only if you're going somewhere)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  
                ],
              ),
            );
                }
               // return Text("false");
                return const CircularProgressIndicator();
              },
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                         Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => driverHome(),
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
                ),
              )
            ],
          ),
        ),

      
    );
  }

}
