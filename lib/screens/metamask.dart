import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:not_a_taxi/database_manager.dart';
import 'package:not_a_taxi/screens/role_selector.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slider_button/slider_button.dart';
import '../../utils/globals.dart' as global;

import '../utils/snackbar.dart';
import 'login_page.dart';


late User loggedinUser;
late final walletAddress;

class metaMask extends StatefulWidget {
  @override
  _metaMaskState createState() => _metaMaskState();
}

class _metaMaskState extends State<metaMask> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  // ignore: prefer_typing_uninitialized_variables
  final TextEditingController _controller = TextEditingController();
  


  void initState() {
    super.initState();
    getCurrentUser();
    getUserId();
  }

   String userID = "";

   getUserId() async {
      User? getUser = await FirebaseAuth.instance.currentUser;
      userID = getUser!.uid;  
      global.userID = userID;
  }
  
  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  var connector = WalletConnect(
  bridge: 'https://bridge.walletconnect.org',
  clientMeta: const PeerMeta(
    name: 'Not A Taxi',
    description: 'An app for carpooling',
    url: 'https://walletconnect.org',
    icons: [
      'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
    ]));

  var _session, _uri;

  loginUsingMetamask(BuildContext context) async {
  if (!connector.connected) {
    try {
      var session = await connector.createSession(onDisplayUri: (uri) async {
        _uri = uri;
        await launchUrlString(uri, mode: LaunchMode.externalApplication);
       });
             print(session.accounts[0]);
             print(session.chainId);
       setState(() {
         _session = session;
         walletAddress = session.accounts[0];
       });
    } catch (exp) {
      print(exp);
    }
  }
}

  getNetworkName(chainId) {
  switch (chainId) {
    case 1:
      return 'Ethereum Mainnet';
    case 3:
      return 'Ropsten Testnet';
    case 4:
      return 'Rinkeby Testnet';
    case 5:
      return 'Goreli Testnet';
    case 42:
      return 'Kovan Testnet';
    case 137:
      return 'Polygon Mainnet';
    case 11155111:
      return 'Sepolia Testnet';
    case 80001:
      return 'Mumbai Testnet';
    default:
      return 'Unknown Chain';
  }
}
  @override
  Widget build(BuildContext context) {
    connector.on(
        'connect',
        (session) => setState(
              () {
                _session = _session;
              },
            ));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;
                           // print(payload.accounts[0]);
                            //print(payload.chainId);
            }));
    connector.on(
        'disconnect',
        (payload) => setState(() {
              _session = null;
            }));

    return Scaffold(
      extendBodyBehindAppBar: false,
      //backgroundColor: Colors.red,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: 
          IconButton(
              icon: Icon(Icons.wallet_rounded),
              onPressed:() {
                
              },),
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text("Payment Method"),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout_rounded),
              onPressed: () {
                _auth.signOut();
                CustomSnackBar(context, const Text('Logged Out Succesfully!'));
                Timer(Duration(seconds: 1), () { // <-- Delay here
                  setState(() {
                      Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),);
                  });
                });
                


                //Implement logout functionality
              })
         
        ],
        /*title: Text('Metamask Login'),
        backgroundColor: Color.fromARGB(255, 52, 163, 85),*/
      ),
      body: 
      
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/COMMONSCREEN.jpg"),
              fit: BoxFit.fill,
            ),
          ),
               child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Container(
                    margin: const EdgeInsets.only(left: 32, right:32, top:40, bottom:0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text('Have a Metamask wallet?',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20)),
                      ],
                    ),
                  ),
              Image.asset(
                'assets/img/meta.png',
                
                fit: BoxFit.fill,
              ),
        
              (_session != null) ? Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account:',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    '${_session.accounts[0]}',
                      style: GoogleFonts.inconsolata(fontSize: 16, color: Color.fromARGB(255, 131, 130, 130)),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Chain: ',
                        style:  TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          getNetworkName(_session.chainId),
                          style: GoogleFonts.inconsolata(fontSize: 16, color: Color.fromARGB(255, 131, 130, 130)),
                        ),
                        
                    ],
                    
                  ),
                  
                  (_session.chainId != 1)
                    ? Row(
                        children: const [
                          Icon(Icons.warning,
                            color: Colors.redAccent, size: 15),
                          Text('Network not supported. Switch to ', style: TextStyle(color: Color.fromARGB(0, 146, 146, 146))),
                          Text(
                            'Ethernet Testnet',
                            style:
                              TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : Container(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      alignment: Alignment.center,
                      child: SliderButton(
                        action: () async {
                          setState(() {
                        showSpinner = true;
                        });
                        Navigator.pushNamed(context, 'role_selector');
                        
                        setState(() {
                        showSpinner = false;
                        });
                        },
                      label: const Text('Slide to Continue',style: TextStyle(fontSize: 18)),
                      backgroundColor: Colors.orange,
                      highlightedColor: Color.fromARGB(255, 212, 109, 12),
                      baseColor: Colors.white,
                      icon: const Icon(Icons.check),
                      ),
                    )
                  ]
                )
              ) 
              : Column(
                children: [
                  Padding(padding: EdgeInsets.all(30)),
                  Container(
                    child: Align(
                  alignment: Alignment.center,
                    child: ElevatedButton(
                        onPressed: () =>  loginUsingMetamask(context), child: const Text("Connect your Metamask Wallet"),
                        style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white), // set the background color
                              foregroundColor: MaterialStateProperty.all(Colors.orange),
                              elevation: MaterialStateProperty.all(4.0),                
                          ),),
                  ),
                  ),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                Colors.white10,
                                Colors.white,
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        width: 100.0,
                        height: 1.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Text(
                          "Or",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: "WorkSansMedium"),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white10,
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        width: 100.0,
                        height: 1.0,
                      ),
        
        
                    ],
                  ),
        
                  Container(
                    child: Align(
                  alignment: Alignment.center,
                    child: ElevatedButton(
                        onPressed: () =>  {showAlertDialog(context)
                        },
                        child: const Text("Continue with UPI"),
                        style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.orange), // set the background color
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              elevation: MaterialStateProperty.all(4.0),                
                          ),),
                  ),
                  ),
                ],
              )
            ],
          ), 
          
            ),
        ),
    );
  }

showAlertDialog(BuildContext context) {

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();  
      },
    );

    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        if (_controller.text.isEmpty)
          {
            CustomSnackBar(context, const Text('Enter Valid UPI ID!'));
          }
        else {

          DatabaseManager().addUPI(_controller.text, global.userID);
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => 
              RoleSelect())); 
        }
        // dismiss dialog
      },
    );

    Widget textField = TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'example@oksbi',
                  labelStyle: TextStyle(color: Colors.blueGrey, 
                              fontSize:18,  )
                  
                ),
              );

    AlertDialog alert = AlertDialog(
      title: const Text("Enter your UPI ID", style: TextStyle(fontSize: 20, color: Colors.blue),),
      
      //content: const Text("Are you at your Drop Off Point?"),
      actions: [textField, cancelButton,continueButton ],
    );
 
    showDialog(
      context: context,
      builder: (BuildContext context) {
      return alert;
      },
    );
}
}