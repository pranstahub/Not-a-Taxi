import 'dart:convert';

import '/models/rides.dart';
import '/config.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RidesApi {
  
  Future<List<Rides>> getRides() async {
    final response = await http.get(Uri.parse('$API_URL/ride'));
    final List decodedJson = json.decode(response.body);
    final List<Rides> audits =
        decodedJson.map((e) => Rides.fromJson(e)).toList();
    return audits;
  }

  static Future<List<Rides>>? fetchRidesPerUser() async {
    final response = await http.get(Uri.parse('$API_URL/ride'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      final jsonResponse = json.decode(response.body);
      final RideObject = jsonResponse["RideList"];
      final List result = jsonResponse["RideList"];
      print("not sure");
      // print(result);
      final test = result.map((e) => {Rides.fromJson(e), print(e)}).toList();
      // print(test);
      return result.map((e) => Rides.fromJson(e)).toList();
      // print(jsonResponse["RideList"].toString());
      // //print(jsonResponse["RideList"]);
      // List<Rides> listRides = [];
      // jsonResponse.forEach((element) {
      //   listRides.add(Rides.fromJson(element));
      // });
      // print("listRides");
      // print(listRides);
      // jsonResponse.forEach((element) {
      //   print("element");
      //   print(element);
      //   // result.add(element);
      //   //result.add(Rides.fromJson(element));
      // });

      // return Rides.fromJson(jsonResponse["RideList"]);
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  static Future<dynamic> postRide(String Destination, String Departure_Location,
      String Departure_Date, String Departure_Time, String Ride_Fees) async {
    print('****************');
    var data = {
      "carId": "63590d96cf8cb5f009c5331a",
      "Destination": Destination,
      "Departure_Location": Departure_Location,
      "Departure_Date": Departure_Date,
      "Departure_Time": Departure_Time,
      "Ride_Fees": Ride_Fees,
    };
    // print("Destination: " + Destination);
    // print("Departure_Date: " + Departure_Date);
    // print("Departure_Location: " + Departure_Location);
    // print("Departure_Time: " + Departure_Time);
    // print("Ride_Fees: " + Ride_Fees);
    var response = await http.post(
      '$API_URL/ride' as Uri,
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    var message = jsonDecode(response.body);
    print("Post ride message from back end");
    print(message[0]);
  }

  static Future<List<Rides>>? fetchRidesPerSearch(String destination, String departure) async {
    print('**************** RIDES API');
    print("destination: " + "Ariana");
    print("departure: " + "Rades");
    var data = {
      "destination": destination,
      "departure": departure,
    };
    var response = await http.post(
      '$API_URL/ridesPerSearch' as Uri,
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      final jsonResponse = json.decode(response.body);
      final RideObject = jsonResponse["RideList"];
      final List result = jsonResponse["RideList"];
      print("response.body@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(response.body);
      final test = result.map((e) => {Rides.fromJson(e), print(e)}).toList();
      // print(test);
      return result.map((e) => Rides.fromJson(e)).toList();
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<List<Rides>>? getRideById(id) async {
    print("################" +id);
    final response = await http.get(Uri.parse('$API_URL/rideById/'+id));
    final jsonResponse = json.decode(response.body);
    final List decodedJson = jsonResponse["RideById"];
    print(response.body);
    final List<Rides> rideById =
    decodedJson.map(
            (e) => Rides.fromJson(e) ).toList();
    return rideById;
  }

}