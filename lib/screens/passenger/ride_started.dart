import 'package:flutter/material.dart';
import 'package:not_a_taxi/screens/passenger/pass_thank_you.dart';

class RideStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Ride in Progress'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/vrrom2.png', // Replace with your image path
              width: 400,
              height: 500,
            ),
            //SizedBox(height: 20),
            //Text("Ride in Progress", style: TextStyle(fontSize: 40 ,fontWeight: FontWeight.w500, color: Colors.blue),),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                showAlertDialog(context);
              },
              child: Text('Ride Over?', style: TextStyle(fontSize: 20)),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(200, 50), // Set the desired width and height of the button
    ),
  ),
            ),
          ],
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
      child: const Text("Hell Yeah!"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => 
              ThankYouPassenger())); // dismiss dialog
      },
    );

    Widget FlatButton = TextButton(
      child: const Text("Driver Violation"),
      onPressed: () {
       Navigator.of(context).pop();  // dismiss dialog
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Beep Beep", style: TextStyle(fontSize: 20, color: Colors.blue),),
      
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
