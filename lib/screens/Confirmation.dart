import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gstdetail/screens/LoginScreen.dart';
import 'package:gstdetail/user/userservice.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Confirmation extends StatefulWidget {
  final String GST;
  UserService userService;
  Confirmation({this.GST,this.userService});

  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {

TextEditingController usercontroller= new TextEditingController();
TextEditingController optcontroller= new TextEditingController();
  Confirm()async
  {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    String message;
    try{
      await widget.userService.confirmAccount(usercontroller.text, optcontroller.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    } on CognitoClientException catch(e) {
      message=e.message;
    } catch(e)
    {
      message="Unknown client error";
    }
    print(message);
    Fluttertoast.showToast(msg: message,toastLength: Toast.LENGTH_SHORT);
  }

@override
  void initState() {
    usercontroller.text=widget.GST??"";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet:GestureDetector(
        onTap: (){
          Confirm();
        },
        child: Container(
          height: 50,
          color: Colors.blue,
          width: MediaQuery.of(context).size.width,
          child: Center(child: Text("Confirm"),),
        ),
      ),
      body: Container(
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            field(usercontroller, "GST NO", "Enter gst No",TextInputType.text,Icons.title),
            field(optcontroller, "Confirmation code", "Enter a 6 digit code",TextInputType.number,Icons.confirmation_number)

          ],
        ),
      )
    );
  }
  field(TextEditingController controller,String label,String hint,TextInputType t,IconData iconData) {
    return ListTile(
      title: TextField(
        keyboardType: t,
       controller:controller ,
        decoration: InputDecoration(
          prefixIcon: Icon(iconData),
          border: OutlineInputBorder(),
          labelText: label,
          hintText: hint
        ),
      ),
    );
  }
}

