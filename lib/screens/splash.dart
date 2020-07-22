import 'dart:async';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';
import 'package:gstdetail/screens/HomeScreen.dart';
import 'package:gstdetail/screens/LoginScreen.dart';
import 'package:gstdetail/screens/firstscreen.dart';
import 'package:gstdetail/user/coginitopool.dart';
import 'package:gstdetail/user/userservice.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  bool exist=false;
  UserService service;
  getUser()async
  {
     service = new UserService(userPool);

    await service.init();
    exist= await service.checkAuthenticated();
    if(exist==true)
      {
        return new Timer(Duration(seconds: 2), navigatehome);
      }
    else if(exist==false)
      return new Timer(Duration(seconds: 2), navigatechoice);


  }
  void navigatehome()
  {
    print("home");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage(service: service,)),(route)=>false);

  }
  void navigatechoice()
  {
    print("userchice");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>UserChoice()),(route)=>false);
  }
  @override
  void initState() {
    getUser();
   super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow,
      ),
    );
  }
}
