import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {

  final CollectionReference profileList = FirebaseFirestore.instance.collection('profileInfo');
  final CollectionReference carData = FirebaseFirestore.instance.collection('carInfo');

  final CollectionReference rideMap = FirebaseFirestore.instance.collection('ridePassengers');


  Future getAllocatedPassenegerData(String driverID, String key) async {
    print("okay? $driverID");
  final response = await rideMap.doc(driverID).get();
  if (key == "Count"){
    try{
      final result = response.get(key);
      return result;
    }
    catch (ex) {
      print(ex);
      return "0";
    }
  }
  else{
    final result = response.get(key);
      return result;
  }
    
  }

  Future<void> allocatePassenegerToRide(String driverID, String passID) async {
    final response = await rideMap.doc(driverID).get();
    if(response.exists) {
      // Document already exists, update the existing array
      List<String> arrayData = response.get('Passengers');
      int limit = response.get('Count');
      arrayData.add(passID);
      rideMap.doc(driverID).update({'Passengers': arrayData, 'Count': limit+1})
        .then((_) {
          print('Array updated successfully.');
        }).catchError((error) {
          print('Error updating array: $error');
        });
    } else {
    // Document doesn't exist, create it with the array
      List<String> arrayData = [passID];
      rideMap.doc(driverID).set({'Passengers': arrayData, 'Count': 1}).then((_) {
        print('New Array created successfully.');
      }).catchError((error) {
        print('Error creating array: $error');
      });
    }
  }


  Future<void> createCarData(String brand, String model, String color, String seatCap,
  String fuel, String year, String plate, String mileage, String uid) async {
    return await carData
      .doc(uid)
        .set({'Brand': brand,
              'Model': model,
              'Color': color,
              'Seating Capacity': seatCap,
              'Fuel Type': fuel,
              'Year of Manufacture' : year,
              'Registration Number': plate,
              "Mileage" : mileage,
              'Car ID': uid,
            });
  }

  Future<void> createUserData(String firstName, String secondName,
  String fullName, String upi, String imgURL, String uid) async {
    return await profileList
      .doc(uid)
        .set({'First Name': firstName, 'Second Name': secondName, 
        'Full Name': fullName, 'UPI ID': upi,'PFP URL': imgURL});
  }

  Future updateUserList(String firstName, String secondName, String imgURL, String uid) async {
    return await profileList.doc(uid).update({
      'First Name': firstName, 'Second Name': secondName, 'PFP URL': imgURL
    });
  }

  Future userDataExists(String userid) async {
    try{
      final snapshot = await profileList.doc(userid).get();
      if (snapshot.exists) {
        return 1;
      }
    }
    catch (E) {
      print(E);
      return 0;
    }
  }

  Future<List> carDataExists(String userid) async {
    try{
      final snapshot = await carData.doc(userid).get();
      if (snapshot.exists) {
        return [1];}
      else{ return [];}
    }
    catch (E) {
      print(E);
      return [];
    }
  }


  /*String capitalize(String value) {
  var result = value[0].toUpperCase();
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " ") {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
    }
  }
  return result;
}*/

  stringReducer(String string){
    List splitted = string.split(" ");
    if(splitted.length == 1)
      {
        return string.substring(0,12);
      }
    List smaller = splitted.sublist(0,2);
    String returnString = smaller.join(" ");
    return returnString;
  }

  Future getCarDetail(String userid, String key) async {
    final response = await carData.doc(userid).get();
    final result = response.get(key);
    if(key == "Brand" || key =="Model") {
      return stringReducer(result);
    }
    return result;
  }

  Future getUserData(String userid, String key) async {
  final response = await profileList.doc(userid).get();
    final result = response.get(key);
    return result;
  }


}