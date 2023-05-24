import 'package:flutter/material.dart';
import 'package:not_a_taxi/screens/passenger/passenger_menu.dart';

class ThankYouPassenger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                'assets/img/thanks_p.png', // Replace with your image path
                width: 400,
                height: 250,
                fit: BoxFit.cover,
              ),
            Text(
              'Thank You for Riding with Us!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height:70),
            ElevatedButton(
                onPressed: () {
                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => passengerHome(),
                                  ),
                 );
                },
                child: Text('Go Home', style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                fixedSize: Size(150, 50),
                                textStyle: TextStyle(fontFamily: 'DM Sans', fontSize: 19),
                              ),
              ),
          ],
        ),
      ),
    );
  }
}
