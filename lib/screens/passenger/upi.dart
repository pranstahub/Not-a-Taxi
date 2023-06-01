import 'package:flutter/material.dart';
import 'package:not_a_taxi/screens/passenger/ride_confirmed.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import '../../database_manager.dart';
import '../../services/functions.dart';
import '../../utils/constants.dart';
import '../../utils/globals.dart' as global;


class upiPay extends StatefulWidget {
  @override
  State<upiPay> createState() => _upiPayState();
}

class _upiPayState extends State<upiPay> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final driverUPI = DatabaseManager().getUPI(global.driverID);
   http.Client? httpClient;
  late Web3Client ethClient;

  @override
  void initState() {
    super.initState();
    httpClient = http.Client();
    ethClient = Web3Client(infura_url, httpClient!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Gateway"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height,
                                          decoration: const BoxDecoration(
                                          image: DecorationImage(
                                          image: AssetImage("assets/img/COMMONSCREEN.jpg"),
                                          fit: BoxFit.fill,
                                        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            
              ElevatedButton(onPressed: (){
                    Razorpay razorpay = Razorpay();
                    var options = {
                      'key': 'rzp_live_ayeT5AteZWnnYi',
                      'amount': global.globalFare*100,
                      'name': 'Not a Taxi',
                      'description': 'Driver UPI ID: $driverUPI',
                      'currency' : "INR",
                      'retry': {'enabled': true, 'max_count': 1},
                      'send_sms_hash': true,
                      'external': {
                      'wallets': ['paytm']
                    }
                    };
                    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
                    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
                    razorpay.open(options);
                  },
                  child: const Text("Pay with Razorpay"),
                  style:ElevatedButton.styleFrom(
                      //shape: StadiumBorder(),
                      primary: Colors.purple,
                      //onPrimary: Colors.black,
                      fixedSize: Size(200, 60),
                      textStyle: TextStyle(fontFamily: 'DM Sans', fontSize: 19),
                    ),)
                  ,
            ],
          ),
        ),
      ),
      
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response){
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
    DatabaseManager().allocatePassenegerToRide(global.driverID, global.userID);
                              bookRide(global.userID, global.driverID, global.start, global.globalDestination,
                                 global.end, global.date, global.time, global.globalFare.toString(), ethClient);
     Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RideConfirmed(),
                                ),
                              );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
    DatabaseManager().allocatePassenegerToRide(global.driverID, global.userID);
                              bookRide(global.userID, global.driverID, global.start, global.globalDestination,
                                 global.end, global.date, global.time, global.globalFare.toString(), ethClient);
     Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RideConfirmed(),
                                ),
                              );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}





/*import 'dart:async';

import 'package:flutter/material.dart';
import 'package:not_a_taxi/database_manager.dart';
import 'package:not_a_taxi/screens/passenger/ride_confirmed.dart';
import 'package:not_a_taxi/utils/globals.dart' as global;
import 'package:upi_india/upi_india.dart';

class upiPay extends StatefulWidget {
  @override
  _upiPayState createState() => _upiPayState();
}

class _upiPayState extends State<upiPay> {
  int flag = 0;
  Future<UpiResponse>? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    super.initState();
  }
  
  final driverUPI = DatabaseManager().getUPI(global.driverID);
  

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "7043576154@okbizaxis",
      merchantId: "BCR2DN6T26R2ZLZU",
      receiverName: 'NOT A TAXI',
      transactionRefId: 'Ride Payment',
      transactionNote: "Driver UPI ID: $driverUPI",
      amount: global.globalFare.toDouble(),
      flexibleAmount: false
    );
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps!.length == 0)
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');  
        flag =1;        
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
            body,
            style: value,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPI'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: displayUpiApps(),
          ),
          Expanded(
            child: FutureBuilder(
              future: _transaction,
              builder: (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        _upiErrorHandler(snapshot.error.runtimeType),
                        style: header,
                      ), // Print's text message on screen
                    );
                  }

                  // If we have data then definitely we will have UpiResponse.
                  // It cannot be null
                  UpiResponse _upiResponse = snapshot.data!;

                  // Data in UpiResponse can be null. Check before printing
                  String txnId = _upiResponse.transactionId ?? 'N/A';
                  String resCode = _upiResponse.responseCode ?? 'N/A';
                  String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                  String status = _upiResponse.status ?? 'N/A';
                  String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
                  _checkTxnStatus(status);

                  if(flag==1){
    
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        displayTransactionData('Transaction Id', txnId),
                        displayTransactionData('Response Code', resCode),
                        displayTransactionData('Reference Id', txnRef),
                        displayTransactionData('Status', status.toUpperCase()),
                        displayTransactionData('Approval No', approvalRef),

                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: ElevatedButton(
                            onPressed: () {
                            

                              /*DatabaseManager().allocatePassenegerToRide(id, global.userID);
                              bookRide(global.userID, id, start, global.globalDestination,
                                 end, date, time, global.globalFare.toString(), ethClient);*/
      
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RideConfirmed(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Colors.green,
                              onPrimary: Colors.white,
                              fixedSize: Size(150, 50),
                              textStyle: TextStyle(fontFamily: 'DM Sans', fontSize: 19),
                            ),
                            child: const Text("Continue"),
                          ), ),
                      ],
                    ),
                  );}
                else {
                  return Center(
                    child: Text(''),
                  );
                }
                } else
                  return Center(
                    child: Text(''),
                  );
              },
            ),
          )
        ],
      ),
    );
  }


}*/