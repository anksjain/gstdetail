import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gstdetail/screens/Confirmation.dart';
import 'package:gstdetail/user/UserDeatils.dart';
import 'package:gstdetail/user/coginitopool.dart';
import 'package:gstdetail/user/userservice.dart';

class Signing extends StatefulWidget {
  String username;

  Signing({this.username});

  @override
  _SigningState createState() => _SigningState();
}

class _SigningState extends State<Signing> {
  TextEditingController _phonecontroller = new TextEditingController();
  TextEditingController _passwordcontroller = new TextEditingController();
  TextEditingController _mailcontroller = new TextEditingController();

  User _user = new User();
  Awspool cognito = new Awspool();
  String message;

  onsubmit(BuildContext context) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    UserService userService = new UserService(cognito.userPool);
    print(userService.userPool.getUserPoolId());
    print(_phonecontroller.text);

    try {
      _user = await userService.signUp(_mailcontroller.text,
          _passwordcontroller.text, widget.username,"+91"+ _phonecontroller.text);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Confirmation(
                    GST: widget.username,
                    userService: userService,
                  )));
    } on CognitoClientException catch (e) {
      if (e.code == 'UsernameExistsException' ||
          e.code == 'InvalidParameterException' ||
          e.code == 'ResourceNotFoundException') {
        message = e.message;
        print(e.code);
      } else {
        message = 'Cognito error';
        print(e.message);
      }
    } catch (e) {
      message = 'Unknown error occurred';
      print("5");
    }
    //final toast =
    final snack = new SnackBar(
      content: Text(message),
      backgroundColor: Colors.blue,
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
      duration: Duration(seconds: 2),
    );
    Scaffold.of(context).showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.purple,
        body: SafeArea(
          child: new Builder(builder: (BuildContext cont) {
            return Container(
              child: Column(
                children: <Widget>[
                  
                  Expanded(flex: 2,
                    child: Container(
                      child: Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                  fields(_mailcontroller, "email",Icons.mail,TextInputType.emailAddress),
                  fields(_phonecontroller, "Mobile No",Icons.phone_android,TextInputType.number),
                  fields(_passwordcontroller, "password",Icons.do_not_disturb_off,TextInputType.text),
                  Spacer(flex: 3,),
                  submit(cont)
                ],
              ),
            );
          }),
        ));
  }

  fields(TextEditingController value, String type,IconData iconData,TextInputType inputType) {
    return ListTile(
      title: TextFormField(
        controller: value,
        keyboardType: inputType,
        decoration:
            InputDecoration(
              border: OutlineInputBorder(),
                prefixIcon: Icon(iconData),
                hintText: "Enter your $type", labelText: type),
//        onChanged: (data) {
//          value=data;
//        },
      ),
    );
  }

  submit(BuildContext context) {
    return MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        child: Text("Submit"),
        color: Color.fromRGBO(125, 50, 70, 10),
        onPressed: () {
          onsubmit(context);
        });
  }
}
