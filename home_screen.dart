import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slider_button/slider_button.dart';


late User loggedinUser;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;


  void initState() {
    super.initState();
    getCurrentUser();
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
      extendBodyBehindAppBar: true,
      //backgroundColor: Colors.red,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: Color(0x44000000),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout_rounded),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);

                //Implement logout functionality
              })
         
        ],
        /*title: Text('Metamask Login'),
        backgroundColor: Color.fromARGB(255, 52, 163, 85),*/
      ),
      body: 
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/screen.jpg"),
            fit: BoxFit.fill,
          ),
        ),
       child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  'Account',
                    style: GoogleFonts.merriweather(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '${_session.accounts[0]}',
                    style: GoogleFonts.inconsolata(fontSize: 16),
                ),
                Row(
                  children: [
                    Text(
                      'Chain: ',
                      style: GoogleFonts.merriweather(
                        fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        getNetworkName(_session.chainId),
                        style: GoogleFonts.inconsolata(fontSize: 16),
                      )
                  ],
                ),

                (_session.chainId != 1)
                  ? Row(
                      children: const [
                        Icon(Icons.warning,
                          color: Colors.redAccent, size: 15),
                        Text('Network not supported. Switch to '),
                        Text(
                          'Ethernet Testnet',
                          style:
                            TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  : Container(
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
                    label: const Text('Slide to continue'),
                    icon: const Icon(Icons.check),
                    ),
                  )
                ]
              )
            ) 
            : Container(
              child: Align(
            alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () =>  loginUsingMetamask(context), child: const Text("Connect with Metamask")),
            ),
            )
          ],
        ), 
        
    ),
    );
  }

  
}