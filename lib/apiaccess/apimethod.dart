import 'dart:convert';

import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:gstdetail/apiaccess/alluser.dart';
import 'package:gstdetail/user/UserDeatils.dart';
import 'package:gstdetail/user/userservice.dart';
import 'package:http/http.dart' as http;
const _awsUserPoolId = "ap-south-1_DBpv2Ytea";
const _awsClientId = "6lec1vuh22oj5ojv1oubikc35n";
final  userPool = new CognitoUserPool(_awsUserPoolId, _awsClientId);
class ApiMethod
{

  final UserService _userService= UserService(userPool);
  User user;
  Alluser alluser;

  void postdata(double rating,String gst) async{
    print("object");
    await _userService.init();
    user=await _userService.getCurrentUser();
    final credentials=  await _userService.getCredentials();
    const endpoint="https://g6m2akpy3m.execute-api.ap-south-1.amazonaws.com/dev";
    final awsSigV4Client = new AwsSigV4Client(
        credentials.accessKeyId, credentials.secretAccessKey, endpoint,
        sessionToken: credentials.sessionToken,
        region: 'ap-south-1');
    final signedRequest = new SigV4Request(awsSigV4Client,
      method: 'POST',
      path: '/add',
      headers: new Map<String, String>.from(
          {'Content-Type': 'application/json','Authorization':_userService.session.getIdToken().getJwtToken()}),
      //   queryParams: new Map<String, String>.from({'id': 'akak+aj'}),
       body: new Map<String, dynamic>.from({'userid': user.gstno,'gst':gst,'rating':rating})
    );
    http.Response response;
    try {
      response = await http.post(
        signedRequest.url,
        headers: {'Authorization':_userService.session.getIdToken().jwtToken,'Content-Type': 'application/json'},
          body: signedRequest.body);
    } catch (e) {
      print(e);
    }
    print(response.body);
      print(_userService.session.getIdToken().jwtToken);
  }

  void Getdata()async
  {
    print("getadata");
    await _userService.init();
//    final credentials=  await _userService.getCredentials();
//    const endpoint="https://g6m2akpy3m.execute-api.ap-south-1.amazonaws.com/dev";
//    final awsSigV4Client = new AwsSigV4Client(
//        credentials.accessKeyId, credentials.secretAccessKey, endpoint,
//        sessionToken: credentials.sessionToken,
//        region: 'ap-south-1');
//    final signedRequest = new SigV4Request(awsSigV4Client,
//        method: 'POST',
//        path: '/add',
//        headers: new Map<String, String>.from(
//            {'Content-Type': 'application/json','Authorization':_userService.session.getIdToken().getJwtToken()}),
//        //   queryParams: new Map<String, String>.from({'id': 'akak+aj'}),
//        body: new Map<String, dynamic>.from({'userid': user.gstno,'gst':gst,'rating':rating})
//    );
    http.Response response;
    try {
      response = await http.get(
         // signedRequest.url,
          "https://g6m2akpy3m.execute-api.ap-south-1.amazonaws.com/dev/all",
        //  headers: {'Authorization':_userService.session.getIdToken().jwtToken,'Content-Type': 'application/json'},
            );
      final json=jsonDecode(response.body);
      alluser=new Alluser.fromJson(json);
      print(alluser.items[0].info[0].rating+11.75);
    } catch (e) {
      print(e);
    }
    print(response.body);
   // print(_userService.session.getIdToken().jwtToken);
  }

}