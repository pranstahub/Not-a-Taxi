import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:not_a_taxi/screens/role_selector.dart';
import '../database_manager.dart';
import '../utils/theme.dart';
import '../utils/snackbar.dart';
import 'add_user_profile.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

final _auth = FirebaseAuth.instance;

class _SignInState extends State<SignIn> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;

  

  late String email;
  late String password;
  bool showSpinner = false;

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }
   /*@override
  void initState() {
    super.initState();
    userProfileExists();
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),

                //EMAIL
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: focusNodeEmail,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value;
                          },
                          style: const TextStyle(
                              //fontFamily: 'WorkSansSemiBold',
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: 'Email Address',
                            hintStyle: TextStyle(
                                //fontFamily: 'WorkSansSemiBold', 
                                fontSize: 17.0),
                          ),
                          onSubmitted: (_) {
                            focusNodePassword.requestFocus();
                          },
                        ),
                      ),

                      //Password
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: focusNodePassword,
                          controller: loginPasswordController,
                          obscureText: _obscureTextPassword,
                          onChanged: (value) {
                            password = value;
                          },
                          style: const TextStyle(
                              //fontFamily: 'WorkSansSemiBold',
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: const Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                                //fontFamily: 'WorkSansSemiBold', 
                                fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextPassword
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onSubmitted: (_) {
                            _toggleSignInButton();
                          },
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 230.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  /*boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color.fromARGB(255, 143, 214, 247),
                      offset: Offset(1.0, 6.0),
                      blurRadius: 5.0,
                    ),
                    BoxShadow(
                      color: Color.fromARGB(255, 143, 214, 247),
                      offset: Offset(1.0, 6.0),
                      blurRadius: 5.0,
                    ),
                  ],*/
                  gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xfff9b966),
                        Color(0xfff9b966),
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                
                child: MaterialButton(
                  highlightColor: CustomTheme.loginGradientEnd,
                  splashColor: CustomTheme.loginGradientEnd,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: 'WorkSansBold'
                          ),
                    ),
                  ),
                  onPressed: () => _toggleSignInButton(),
                ),
              )
            ],
          ),
          
          //FORGOT PASSWORD
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextButton(
                onPressed: () => CustomSnackBar(
                      context, const Text('Forgot Already?  :(')),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      //fontFamily: 'WorkSansMedium'
                      ),
                )),
          ),
            ],
          ),
        
      );

  }

  late int userExists;
  String userID = "";
  List userProfilesList = [];


   userProfileExists() async {
      User? getUser = await FirebaseAuth.instance.currentUser;
      userID = getUser!.uid;
      userExists = await DatabaseManager().userDataExists(userID);
      //print("OLAOLAOLAOLA $userExists");
      
      return userExists;
   
  }

  void _toggleSignInButton() async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      int existence = await userProfileExists();
                      if(existence == 1) {
                        CustomSnackBar(context, const Text('Signed In Succesfully!'));
                        Timer(Duration(seconds: 1), () { // <-- Delay here
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RoleSelect(),),
                            );
                          });
                        });
                      }
                        
                      else {
                        CustomSnackBar(context, const Text('Add your Profile!'));
                        Timer(Duration(seconds: 1), () { // <-- Delay here
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage(),),
                            );
                          });
                        });
                        
                      }
                      
          
                    } catch (e) {
                      print(e);
                      CustomSnackBar(context, const Text('No Such User Found!'));
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
}