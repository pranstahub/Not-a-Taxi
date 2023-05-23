import 'package:not_a_taxi/database_manager.dart';
import 'package:not_a_taxi/utils/globals.dart';
import 'calculate_distance.dart';
import 'fuel_price.dart';

calculateFare(String carId, String start, String end) async {

  final fuelType = await DatabaseManager().getCarDetail(carId, "Fuel Type");
  final mileageResponse = await DatabaseManager().getCarDetail(carId, "Mileage");
  double mileage = double.parse(mileageResponse);

  final fuelPrice = await scrapePetrolAndDieselPrices(fuelType);

  final distance = await calculateDistance();

  double fare = ((distance / mileage) * fuelPrice);
  globalFare = fare.round();

}