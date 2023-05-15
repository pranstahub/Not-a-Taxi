import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:not_a_taxi/screens/home_screen.dart';
import 'dart:io';
import 'package:path/path.dart';
import '/utils/snackbar.dart';
import '../database_manager.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  String imgURL = "https://cdn.pixabay.com/photo/2016/03/21/23/25/link-1271843_1280.png";

  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _snameController = TextEditingController();

  final FocusNode focusNodeFirstName = FocusNode();
  final FocusNode focusNodeSecondName = FocusNode();
  


  @override
  void dispose() {
    focusNodeFirstName.dispose();
    focusNodeSecondName.dispose();
    super.dispose();
  }
 
 // List userProfilesList = [];

  String userID = "";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    //fetchDatabaseList();
  }

  fetchUserInfo() async {
    User? getUser = await FirebaseAuth.instance.currentUser;
    userID = getUser!.uid;
    //return userID;
  }

  /*fetchDatabaseList() async {
    dynamic resultant = await DatabaseManager().getUsersList();

    if (resultant == null) {
      print('Unable to retrieve');
    } else {
      setState(() {
        userProfilesList = resultant;
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    
    File? pickedImageFile;

    UploadTask? uploadTask;
    Future uploadPic(BuildContext context) async{
      final path = 'profilePictures/${fetchUserInfo()}';
      final fileName = File(_image!.path);
      FirebaseStorage firebaseStorageRef = FirebaseStorage.instance;
      Reference ref = firebaseStorageRef.ref().child(path);
      UploadTask uploadTask = ref.putFile(fileName);
      uploadTask.then((res) {
         res.ref.getDownloadURL();
         imgURL = res.toString();
         return imgURL;
      }
      );
      
      setState(() {  
        print("Profile Picture uploaded");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
       });
    }

    
    Future _pickImage() async {
      PickedFile? pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.gallery, imageQuality: 50);

      if (pickedImage == null){return;}

      setState(() {
        pickedImageFile = File(pickedImage.path);
        print("In the function: $pickedImageFile");
      });

    //uploadPic(context);
    }

    

    return Scaffold(
       //resizeToAvoidBottomInset : false,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('Add your Profile to Register!'),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child:  GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
              child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 20.0,
                ),
                
                Container(
                  margin: EdgeInsets.only(left: 32, right:32, top:20, bottom:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text('Please Upload your Profile Picture! ',style: TextStyle(color: Colors.blueGrey, fontSize: 18.0)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _pickImage(),
                      child:  CircleAvatar( 
                        backgroundColor: Colors.blue,
                        radius: 110,
                        child: CircleAvatar(
                          radius: 100,
                          foregroundImage: (pickedImageFile != null)
                            ? FileImage(pickedImageFile!) as ImageProvider
                            : const AssetImage('assets/img/pfp2.png') /*Image.network(imgURL!) as ImageProvider;*/,
                        ), 
                      ),
                    ),
                  
                  ],
                ),
                
                //EMAIL
               Container(
                  margin: const EdgeInsets.only(left: 32, right:32, top:30, bottom:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text('Let us know what to call you...',style: TextStyle(color: Colors.blueGrey, fontSize: 18.0)),
                    ],
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.only( left:32, right:32),
                    child: Column(
                      children: [
                        TextFormField(
                          focusNode: focusNodeFirstName,
                          controller: _fnameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              CustomSnackBar(
                      context, const Text('Your First Name is required!'));
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                              labelText: 'First Name',
                              labelStyle: TextStyle(color: Colors.blueGrey, 
                              fontSize:18,  )),
                          style: const TextStyle(color: Colors.black, fontSize: 20),
                          
                          onFieldSubmitted: (_) {
                              focusNodeSecondName.requestFocus();
                            },
                        ),
                        
                        const SizedBox(
                        height: 30.0,
                        ),
                        TextFormField(
                          focusNode: focusNodeSecondName,
                          controller: _snameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Your Second Name is missing!';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Second Name',
                              labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 18),
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ])),
                
              


                SizedBox(
                  height: 80.0,
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 16.0),),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue), // set the background color
                          foregroundColor: MaterialStateProperty.all(Colors.blueGrey),
                          elevation: MaterialStateProperty.all(4.0),                
                      ),
                    ),

                    ElevatedButton(
                      child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 16.0),),
                      onPressed: () {
                        //uploadPic(context);
                        submitAction(context);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue), // set the background color
                          foregroundColor: MaterialStateProperty.all(Colors.blueGrey),
                          elevation: MaterialStateProperty.all(4.0),                
                      ),
                    ),
                
                  ],
                )
              ],
            ),
        )));
        
  }
 submitAction(BuildContext context) {
    if(_fnameController.text.isEmpty)
      {
        CustomSnackBar(context, const Text('Your First Name is required!'));

      }
    else if(_snameController.text.isEmpty)
      {
        CustomSnackBar(context, const Text('Your Second Name is required!'));
      }
    else{
    DatabaseManager().createUserData(_fnameController.text, _snameController.text, imgURL, userID);
    CustomSnackBar(context, const Text('Profile Registered!'));
    Timer(Duration(seconds: 1), () { // <-- Delay here
      setState(() {
        Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),);
    _fnameController.clear();
    _snameController.clear();
      });
    });

    }
  }
}
