class Car {
  late String? brand;
  late String? model;
  late String? color;
  late String? seatCap;
  late String? fuel;
  late String? date;
  late String? plate;

  Car({
    required this.brand,
    required this.model,
    required this.color,
    required this.seatCap,
    required this.fuel,
    required this.date,
    required this.plate,
  });

  Car.fromJson(Map<String, dynamic> json) {
    brand = json["manufacturer"];
    model = json["manufacturer_model"];
    color = json["colour"];
    seatCap = json["seating_capacity"];
    fuel = json["fuel_type"];
    date = json["m_y_manufacturing"];
    plate = json["registration_number"];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data["manufacturer"] = brand;
    _data["manufacturer_model"] = model;
    _data["colour"] = color;
    _data["seating_capacity"] = seatCap;
    _data["m_y_manufacturing"] = date;
    _data["fuel_type"] = fuel;
    _data["registration_number"] = plate;

    return _data;
  }

// Get data from backend
  Map<String, dynamic> toMap(void Function(dynamic e) param0) {
    return {
      'manufacturer': brand,
      'manufacturer_model': model,
      'colour': color,
      'seating_capacity': seatCap,
      'fuel_type': fuel,
      'm_y_manufacturing' : date,
      'regsitration_number': plate
    };
  }

}