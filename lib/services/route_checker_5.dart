/*import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
//import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart' ;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

getLatLngFromAddress(String address) async {
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
      return mp.LatLng(lat,lng);
    }
  }
  return "null";

}

bool isPointOnPathWithinRadius(String dStart, String dEnd, String pStart, String pEnd) {
  final mp.LatLng start = getLatLngFromAddress(dStart);
  final mp.LatLng end = getLatLngFromAddress(dEnd);
  final LatLng point = getLatLngFromAddress(pEnd);
  const double radius = 1000; // Radius in meters

  final drivingPath = [start, point, end];

  // Calculate the bounds of the driving path
  double minLat = double.infinity;
  double maxLat = -double.infinity;
  double minLng = double.infinity;
  double maxLng = -double.infinity;

  for (final latLng in drivingPath) {
    minLat = latLng.latitude < minLat ? latLng.latitude : minLat;
    maxLat = latLng.latitude > maxLat ? latLng.latitude : maxLat;
    minLng = latLng.longitude < minLng ? latLng.longitude : minLng;
    maxLng = latLng.longitude > maxLng ? latLng.longitude : maxLng;
  }

  final bounds = LatLngBounds(
    southwest: mp.LatLng(minLat, minLng),
    northeast: mp.LatLng(maxLat, maxLng),
  );

  if (!PolygonUtil.containsLocation(point, bounds.toList(), false)) {
    // Point is not within the bounds of the driving path
    return false;
  }

  for (int i = 0; i < drivingPath.length - 1; i++) {
    final mp.LatLng segmentStart = drivingPath[i];
    final mp.LatLng segmentEnd = drivingPath[i + 1];
    final double distance = SphericalUtil.computeDistanceBetween(
      segmentStart,
      segmentEnd,
    );

    if (distance < radius) {
      // Point lies within the radius of the driving path
      return true;
    }
  }

  return false;
}*/
