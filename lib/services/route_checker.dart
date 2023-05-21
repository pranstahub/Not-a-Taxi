import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:not_a_taxi/config.dart';

Future<String> getLatLngFromAddress(String address) async {
  String apiKey = mapKey;
  String encodedAddress = Uri.encodeComponent(address);
  String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$apiKey';
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data['results'] != null && data['results'].isNotEmpty) {
      var location = data['results'][0]['geometry']['location'];
      double lat = location['lat'];
      double lng = location['lng'];
      return '$lat,$lng';
    }
  }
  return "null";

}

Future<bool> checkPassengerRide(
    String passengerStartingPoint,
    String passengerDestination,
    String driverStartingPoint,
    String driverDestination) async {
    String apiKey = mapKey;

  String driverStartingPointLatLng = await getLatLngFromAddress(driverStartingPoint);
  String driverDestinationLatLng = await getLatLngFromAddress(driverDestination);
  String passengerStartingPointLatLng = await getLatLngFromAddress(passengerStartingPoint);
  String passengerDestinationLatLng = await getLatLngFromAddress(passengerDestination);

  if (driverDestinationLatLng != "null" && driverStartingPointLatLng != "null"
      && passengerStartingPointLatLng != "null"&& passengerDestinationLatLng != "null" ) {
    // Retrieve directions using the Google Maps Directions API
    String url =
    'https://maps.googleapis.com/maps/api/directions/json?origin=$driverStartingPointLatLng&destination=$driverDestinationLatLng&key=$apiKey';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> routes = data['routes'];

      if (routes.isNotEmpty) {
        // Check if passenger's starting point matches driver's starting point
        String driverStartingPointLat =
            routes[0]['legs'][0]['start_location']['lat'].toString();
        String driverStartingPointLng =
            routes[0]['legs'][0]['start_location']['lng'].toString();

        if (driverStartingPointLat == passengerStartingPointLatLng.split(',')[0] &&
            driverStartingPointLng == passengerStartingPointLatLng.split(',')[1]) {
          // Check if passenger's destination lies within the path of the driver's journey
          List<dynamic> steps = routes[0]['legs'][0]['steps'];

          double passengerDestinationLat =
              double.parse(passengerDestinationLatLng.split(',')[0]);
          double passengerDestinationLng =
              double.parse(passengerDestinationLatLng.split(',')[1]);

          for (var step in steps) {
            double startLat = step['start_location']['lat'];
            double startLng = step['start_location']['lng'];
            double endLat = step['end_location']['lat'];
            double endLng = step['end_location']['lng'];

            // Check if passenger's destination lies within the current step
            if ((startLat <= passengerDestinationLat &&
                    passengerDestinationLat <= endLat) &&
                (startLng <= passengerDestinationLng &&
                    passengerDestinationLng <= endLng)) {
              return Future<bool>.value(true); // Passenger's destination is within the path of the driver's journey
            }
          }
        }
      }
    }
  }

  return Future<bool>.value(false); // Passenger's destination is not within the path of the driver's journey
}

