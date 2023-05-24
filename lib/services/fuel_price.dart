import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

Future<double> scrapePetrolAndDieselPrices(String fuel) async {
  
  late String fuelRL;

  if(fuel == "PETROL") {
    fuelRL = "https://www.petroldieselprice.com/Kerala-petrol-price";
  }
  else if(fuel == "DIESEL") {
    fuelRL = "https://www.petroldieselprice.com/Kerala-diesel-price";
  }
  else {
    return 50;
  }
  
  final response = await http.get(Uri.parse(fuelRL));

  if (response.statusCode == 200) {
    final document = parser.parse(response.body);
    final fuelElement = document.querySelector('#order_review > table > tfoot > tr:nth-child(1) > td:nth-child(1)');
    
    if (fuelElement != null ) {
      final fuelPrice = fuelElement.text;
      List splitted = fuelPrice.split(" ");
      double price = double.parse(splitted[1]);
      print("Fuel Price: $price");
      return price;
    } 
    else {
      print('Unable to find petrol and diesel prices on the website');
      return 100;
    }
  } 
  else {
    print('Failed to fetch the website data. Status code: ${response.statusCode}');
    return 100;
  }
}
