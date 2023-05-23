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
            Text(
              'Thank You for Riding with Us!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => 
              passengerHome()));
              },
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
