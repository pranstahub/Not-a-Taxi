import 'package:http/http.dart' as http;
import 'dart:convert';

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);
}

class RouteChecker {
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  Future<bool> isRequesterPathWithinRiderTrajectory(
      Location riderStart,
      Location riderDestination,
      Location requesterStart,
      Location requesterDestination) async {
    final riderRoute = await getRoute(riderStart, riderDestination);
    final requesterRoute = await getRoute(requesterStart, requesterDestination);

    final riderTrajectory = extractTrajectoryFromRoute(riderRoute);
    final requesterPath = extractPathFromRoute(requesterRoute);

    final isWithinTrajectory = checkPathWithinTrajectory(
        riderTrajectory, requesterPath, riderStart, riderDestination);

    return isWithinTrajectory;
  }

  Future<Map<String, dynamic>> getRoute(
      Location start, Location destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleMapsApiKey';

    final response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);

    if (response.statusCode == 200 &&
        responseData['status'] == 'OK' &&
        responseData['routes'] != null &&
        responseData['routes'].isNotEmpty) {
      return responseData['routes'][0];
    } else {
      throw Exception('Failed to retrieve route data.');
    }
  }

  List<Location> extractPathFromRoute(Map<String, dynamic> route) {
    final overviewPolyline = route['overview_polyline']['points'];
    final decodedPoints = decodePolyline(overviewPolyline);
    return decodedPoints.map((point) => Location(point[0], point[1])).toList();
  }

  List<Location> extractTrajectoryFromRoute(Map<String, dynamic> route) {
    final legs = route['legs'];
    final startLocation = Location(
        legs[0]['start_location']['lat'], legs[0]['start_location']['lng']);
    final endLocation = Location(
        legs[legs.length - 1]['end_location']['lat'],
        legs[legs.length - 1]['end_location']['lng']);
    return [startLocation, endLocation];
  }

  List<List<double>> decodePolyline(String polyline) {
    final List<List<double>> polyPoints = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      int byte;
      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        int byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1)
: (result >> 1));
lng += dlng;
  double latitude = lat / 1e5;
  double longitude = lng / 1e5;
  polyPoints.add([latitude, longitude]);
}

return polyPoints;
}

bool checkPathWithinTrajectory(
List<Location> trajectory,
List<Location> path,
Location riderStart,
Location riderDestination) {
// Check if rider's start and destination lie within requester's path
if (!path.contains(riderStart) || !path.contains(riderDestination)) {
return false;
}// Find the indexes of rider's start and destination in the path
final startIndex = path.indexOf(riderStart);
final endIndex = path.indexOf(riderDestination);

// Extract the portion of the path within rider's trajectory
final portionWithinTrajectory = path.sublist(startIndex, endIndex + 1);

// Check if the portion within rider's trajectory matches the trajectory
return portionWithinTrajectory == trajectory;
}
}

void main() async {
final routeChecker = RouteChecker();

// Define rider's start and destination locations
final riderStart = Location(37.7749, -122.4194);
final riderDestination = Location(37.3352, -121.8811);

// Define carpool requester's start and destination locations
final requesterStart = Location(37.7577, -122.4376);
final requesterDestination = Location(37.7749, -122.4194);

final isWithinTrajectory = await routeChecker.isRequesterPathWithinRiderTrajectory(
riderStart, riderDestination, requesterStart, requesterDestination);

print("Is requester's path within rider's trajectory? $isWithinTrajectory");
}