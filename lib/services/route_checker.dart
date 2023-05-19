import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import "package:not_a_taxi/config.dart";

Future<bool> checkPassengerPathInDriverPath(
  String driverstart,
  String driverend,
  String passengerstart,
  String passengerend,

) async {
  String apiKey = mapKey;

  LatLng driverStart = getLatLngFromAddress(driverstart, apiKey);
  LatLng driverEnd = getLatLngFromAddress(driverend, apiKey);
  LatLng passengerStart = getLatLngFromAddress(passengerstart, apiKey);
  LatLng passengerEnd = getLatLngFromAddress(passengerend, apiKey);

  final driverPath = await _getDirections(
    driverStart,
    driverEnd,
    apiKey,
  );

  

  final passengerPath = await _getDirections(
    passengerStart,
    passengerEnd,
    apiKey,
  );

  if (driverPath != null && passengerPath != null) {
    final driverPolyline = _decodePolyline(driverPath['routes'][0]['overview_polyline']['points']);
    final passengerPolyline = _decodePolyline(passengerPath['routes'][0]['overview_polyline']['points']);

    // Check if the passenger's travel path intersects with the driver's path
    if (_isPathIntersecting(driverPolyline, passengerPolyline)) {
      return true; // Passenger's path intersects with driver's path
    }
  }

  return false; // Passenger's path does not intersect with driver's path
}


getLatLngFromAddress(String address, String apiKey) async {
  final encodedAddress = Uri.encodeQueryComponent(address);
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json'
    '?address=$encodedAddress'
    '&key=$apiKey',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final decodedData = json.decode(response.body);
    if (decodedData['status'] == 'OK') {
      final results = decodedData['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        final location = results[0]['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        return LatLng(lat, lng);
      }
    }
  }

  return null; // Failed to get LatLng from address
}

Future<Map<String, dynamic>?> _getDirections(
  LatLng origin,
  LatLng destination,
  String apiKey,
) async {
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/directions/json'
    '?origin=${origin.latitude},${origin.longitude}'
    '&destination=${destination.latitude},${destination.longitude}'
    '&key=$apiKey',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print('Error: ${response.reasonPhrase}');
    return null;
  }
}

List<LatLng> _decodePolyline(String encodedPolyline) {
  final polylinePoints = PolylinePoints();
  final List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(encodedPolyline);
  return decodedPoints.map((PointLatLng point) => LatLng(point.latitude, point.longitude)).toList();
}

bool _isPathIntersecting(List<LatLng> path1, List<LatLng> path2) {
  for (var i = 0; i < path1.length - 1; i++) {
    final segmentStart1 = path1[i];
    final segmentEnd1 = path1[i + 1];

    for (var j = 0; j < path2.length - 1; j++) {
      final segmentStart2 = path2[j];
      final segmentEnd2 = path2[j + 1];

      if (_doSegmentsIntersect(segmentStart1, segmentEnd1, segmentStart2, segmentEnd2)) {
        return true; // Path segments intersect
      }
    }
  }

  return false; // Paths do not intersect
}

bool _doSegmentsIntersect(LatLng p1, LatLng p2, LatLng p3, LatLng p4) {
  final d1 = _direction(p3, p4, p1);
  final d2 = _direction(p3, p4, p2);
  final d3 = _direction(p1, p2, p3);
  final d4 = _direction(p1, p2, p4);

  // Check if the segments are intersecting
  if ((d1 > 0 && d2 < 0 || d1 < 0 && d2 > 0) && (d3 > 0 && d4 < 0 || d3 < 0 && d4 > 0)) {
    return true;
  } else if (d1 == 0 && _isOnSegment(p3, p4, p1)) {
    return true;
  } else if (d2 == 0 && _isOnSegment(p3, p4, p2)) {
    return true;
  } else if (d3 == 0 && _isOnSegment(p1, p2, p3)) {
    return true;
  } else if (d4 == 0 && _isOnSegment(p1, p2, p4)) {
    return true;
  }

  return false;
}

double _direction(LatLng p1, LatLng p2, LatLng p) {
  return (p.longitude - p1.longitude) * (p2.latitude - p1.latitude) -
      (p.latitude - p1.latitude) * (p2.longitude - p1.longitude);
}

bool _isOnSegment(LatLng p1, LatLng p2, LatLng p) {
  final minX = p1.longitude < p2.longitude ? p1.longitude : p2.longitude;
  final maxX = p1.longitude > p2.longitude ? p1.longitude : p2.longitude;
  final minY = p1.latitude < p2.latitude ? p1.latitude : p2.latitude;
  final maxY = p1.latitude > p2.latitude ? p1.latitude : p2.latitude;

  return p.longitude >= minX &&
      p.longitude <= maxX &&
      p.latitude >= minY &&
      p.latitude <= maxY;
}
