class Car {
  late String? id;
  late String? brand;
  late String? color;
  late String? model;
  late String? energy_type;

  Car({
    required this.id,
    required this.brand,
    required this.color,
    required this.model,
    required this.energy_type,
  });

  Car.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    brand = json["brand"];
    color = json["color"];
    model = json["model"];
    energy_type = json["energy_type"];
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data["id"] = id;
    _data["brand"] = brand;
    _data["color"] = color;
    _data["model"] = model;
    _data["energy_type"] = energy_type;

    return _data;
  }

// Get data from backend
  Map<String, dynamic> toMap(void Function(dynamic e) param0) {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'color': color,
      'energy_type': energy_type,
    };
  }

  /*factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      brand: map['_brand'] ?? '',
      model: map['model'] ?? '',
      color: map['color'] ?? '',
      energy_type: map['energy_type'] ?? '',
    );
  }*/

}