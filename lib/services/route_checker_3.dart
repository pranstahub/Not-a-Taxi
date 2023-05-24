import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/globals.dart' as global;
import 'package:not_a_taxi/config.dart';

Future<bool> checkPassengerRide(
    String driverStartingPoint,
    String driverDestination,
    String passengerStartingPoint,
    String passengerDestination,) async {
  String apiKey = mapKey;

  // Retrieve directions using the Google Maps Directions API
  String url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=$driverStartingPoint&destination=$driverDestination&key=$apiKey';
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    List<dynamic> routes = data['routes'];
    print("DAIVAME!");
    print(routes[0]);

    if (routes.isNotEmpty) {
      // Check if passenger's starting point matches driver's starting point
      String driverStartingPointLat = routes[0]['legs'][0]['start_location']['lat'].toString();
      String driverStartingPointLng = routes[0]['legs'][0]['start_location']['lng'].toString();
      String passengerStartingPointLat = global.passengerDepartureLatitude.toString();
      String passengerStartingPointLng = global.passengerDepartureLongitude.toString();

      if (driverStartingPointLat == passengerStartingPointLat && driverStartingPointLng == passengerStartingPointLng) {
        // Check if passenger's destination lies within the path of the driver's journey
        List<dynamic> steps = routes[0]['legs'][0]['steps'];

        double passengerDestinationLat = global.passengerDestinationLatitude;
        double passengerDestinationLng = global.passengerDestinationLongitude;

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
            return true; // Passenger's destination is within the path of the driver's journey
          }
        }
      }
    }
  }

  return false; // Passenger's destination is not within the path of the driver's journey
}

/*void main() async {
  String passengerStartingPoint = 'Passenger Starting Point Latitude,Passenger Starting Point Longitude';
  String passengerDestination = 'Passenger Destination Latitude,Passenger Destination Longitude';
  String driverStartingPoint = 'Driver Starting Point Latitude,Driver Starting Point Longitude';
  String driverDestination = 'Driver Destination Latitude,Driver Destination Longitude';

  bool isPassengerRideValid = await checkPassengerRide(
      passengerStartingPoint, passengerDestination, driverStartingPoint, driverDestination);

  if (isPassengerRideValid) {
    print('Passenger ride is valid');
  } else {
    print('Passenger ride is not valid');
  }
}*/
