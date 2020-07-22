import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gstdetail/screens/Confirmation.dart';
import 'package:gstdetail/screens/GSTverfictaion.dart';
import 'package:gstdetail/screens/LoginScreen.dart';
import 'package:gstdetail/screens/signup.dart';
class UserChoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hSize=MediaQuery.of(context).size.height;
    var wSize=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: wSize,
       color: Colors.blue,
       padding: EdgeInsets.all(10),
       // color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text("Login"),),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GSTVERFIFY()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text("Signup"),),
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Confirmation()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text("Confirm Account"),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
