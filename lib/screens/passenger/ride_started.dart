import 'package:flutter/material.dart';
import 'package:not_a_taxi/screens/passenger/pass_thank_you.dart';

class RideStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        automaticallyImplyLeading: false,
        title: Text('Ride in Progress'),
        centerTitle: true,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/vroom.gif', // Replace with your image path
                width: 500,
                height: 600,
              ),
              //SizedBox(height: 20),
              //Text("Ride in Progress", style: TextStyle(fontSize: 40 ,fontWeight: FontWeight.w500, color: Colors.blue),),
              SizedBox(height: 2),
      
              ElevatedButton(
                onPressed: () {
                  showAlertDialog(context);
                },
                child: Text('Ride Over?', style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                primary: Colors.orange,
                                onPrimary: Colors.white,
                                fixedSize: Size(150, 50),
                                textStyle: TextStyle(fontFamily: 'DM Sans', fontSize: 19),
                              ),
              ),
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
      child: const Text("Hell Yeah!", style: TextStyle(color: Colors.green)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => 
              ThankYouPassenger())); // dismiss dialog
      },
    );

    Widget FlatButton = TextButton(
      child: const Text("Driver Violation", style: TextStyle(color: Colors.red)),
      onPressed: () {
       Navigator.of(context).pop();  // dismiss dialog
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Beep Beep!", style: TextStyle(fontSize: 20, color: Colors.blue),),
      
      content: const Text("Are you at your Drop Off Point?"),
      actions: [cancelButton, FlatButton, continueButton ],
    );
 
    showDialog(
      context: context,
      builder: (BuildContext context) {
      return alert;
      },
    );
  }
}
