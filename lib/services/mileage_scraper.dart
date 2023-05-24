import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

Future<String> scrapeMileage(String brand, String model, String fuelType, String year) async {
  // Format the search query
  String query = 'What is the mileage of $brand $model $fuelType $year in kmpl?';

  // Send a GET request to the Google search engine
  String searchUrl = 'https://www.google.com/search?q=$query';
  var response = await http.get(Uri.parse(searchUrl));
  //print(response);
  
  // Parse the HTML content of the search results page
  dom.Document document = parser.parse(response.body);

  // Find the relevant information on the page
  List resultElement = document.querySelectorAll('.wDYxhc span b');
  print("ola");
  print(resultElement);
  try {
    String mileage = resultElement.single;//.first.text;//resultElement.innerHtml.trim();
    print(mileage);
    return mileage;
  } 
  catch (ex)  {
    print("avg only");
    return "20";
  }
}
//document.querySelector("#rso > div:nth-child(2) > div > block-component > div > div.dG2XIf.XzTjhb > div > div > div > div > div.ifM9O > div > div > div.yp1CPe.wDYxhc.NFQFxe.viOShc.LKPcQc > div > div.wDYxhc > div > span > span > b")