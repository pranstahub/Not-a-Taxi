import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoleSelect extends StatefulWidget {
  @override
  _RoleSelectState createState() => _RoleSelectState();
}

class _RoleSelectState extends State<RoleSelect> {
  final _auth = FirebaseAuth.instance;
  
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      //backgroundColor: Colors.red,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        backgroundColor: Color(0x44000000),
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout_rounded),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              })
         
        ],
      ),
      body: 
      Container(
              child: Align(
              alignment: Alignment.center,
              child: Column(children: [
                const Padding(
                padding: const EdgeInsets.only(top:150.0, bottom:50),
                child: Text("Select Role",
                  style: TextStyle(
                      color: Color.fromARGB(255, 28, 90, 47),
                      fontSize: 40.0,
                      fontFamily: 'WorkSansSemiBold')
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                  onTap: () => {}, // needed
                  child: Image.asset(
                    "assets/img/driver.png",
                    width: 220,
                    fit: BoxFit.fill,
                  ),
                  ),
                ), 
          
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => {}, // needed
                    child: Image.asset(
                      "assets/img/user.png",
                      width: 220,
                      fit: BoxFit.fill,
                    ),
                  ),
                ), 
              ]
              ),
            ),
          )
        );
  }
}