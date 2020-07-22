import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';
import 'package:gstdetail/screens/HomeScreen.dart';
import 'package:gstdetail/user/UserDeatils.dart';
import 'package:gstdetail/user/coginitopool.dart';
import 'package:gstdetail/user/userservice.dart';


const _awsUserPoolId = "ap-south-1_DBpv2Ytea";
const _awsClientId = "6lec1vuh22oj5ojv1oubikc35n";
final  userPool = new CognitoUserPool(_awsUserPoolId, _awsClientId);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User user = new User();
  final service=new UserService(userPool);
  TextEditingController _usernamecontroller = new TextEditingController();
  TextEditingController _passwordcontroller = new TextEditingController();

  @override
  void initState() {

    super.initState();
  }
  String message;
  onsubmit(BuildContext context) async {
    try {
      user = await service.login(
          _usernamecontroller.text, _passwordcontroller.text);
      message="success";
      print(service.cognitoUser.username);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage(service: service,)), (route) => false);
    } on CognitoClientException catch (e) {
      this.message=e.message;
    } catch (e) {
      message="Try again later";
    }
    final Snack= SnackBar(
      content: Text(message),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        textColor: Colors.white,
        onPressed: (){

        },
      ),
    );
    Scaffold.of(context).showSnackBar(Snack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.deepPurple,
        child: Column(
          children: <Widget>[
            Spacer(),
            fieldU(_usernamecontroller, "Enter GST-No or Email", "Username",
                Icons.verified_user),
            fieldP(),
            SizedBox(height: 50,),
            submit(),
            Spacer()
          ],
        ),
      ),
    );
  }

  fieldU(TextEditingController controller, String hint, String label,
      IconData iconData) {
    return ListTile(
      title: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(iconData),
          hintText: hint,
          labelText: label,
        ),
        controller: controller,
      ),
    );
  }

  submit() {
    return Builder(builder: (BuildContext context) {
      return ListTile(
        title: RaisedButton(
          splashColor: Colors.yellow,
          color: Colors.red,
          child: Text("Submit"),
          onPressed: () {
            FocusScopeNode scopeNode= FocusScope.of(context);
            if(!scopeNode.hasPrimaryFocus)
              scopeNode.unfocus();
            onsubmit(context);
          },
        ),
      );
    });
  }

  bool password = true;

  fieldP() {
    return ListTile(
      title: TextField(
        controller: _passwordcontroller,
        obscureText: !password,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Password",
            prefixIcon: Icon(Icons.priority_high),
            hintText: "must a letter",
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: password ? Colors.red : Colors.yellow,
              ),
              onPressed: () {
                setState(() {
                  password = !password;
                });
              },
            )),
      ),
    );
  }
}
