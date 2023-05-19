import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {

  final CollectionReference profileList = FirebaseFirestore.instance.collection('profileInfo');
  final CollectionReference carData = FirebaseFirestore.instance.collection('carInfo');

  Future<void> createCarData(String brand, String model, String color, String seatCap,
  String fuel, String year, String plate, String uid) async {
    return await carData
      .doc(uid)
        .set({'Brand': brand,
              'Model': model,
              'Color': color,
              'Seating Capacity': seatCap,
              'Fuel Type': fuel,
              'Year of Manufacture' : year,
              'Registration Number': plate,
              'Car ID': uid,
            });
  }

  Future<void> createUserData(String firstName, String secondName,String upi, String imgURL, String uid) async {
    return await profileList
      .doc(uid)
        .set({'First Name': firstName, 'Second Name': secondName, 'UPI ID': upi,'PFP URL': imgURL});
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

  Future carDataExists(String userid) async {
    try{
      final snapshot = await carData.doc(userid).get();
      if (snapshot.exists) {
        return 1;
      }
      else{
        return 0;
      }
    }
    catch (E) {
      print(E);
      return 0;
    }
  }

  Future getCarDetail(String userid, String key) async {
    final response = await carData.doc(userid).get();
    return response.get(key);
  }

  Future getUsersList() async {
    List itemsList = [];

    try {
      await profileList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}