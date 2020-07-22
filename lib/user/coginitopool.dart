import 'package:amazon_cognito_identity_dart/cognito.dart';
 class Awspool
{
  static const _awsUserPoolId = "ap-south-1_DBpv2Ytea";
  static const _awsClientId = "6lec1vuh22oj5ojv1oubikc35n";
  static const _region = 'ap-south-1';
  final  userPool = new CognitoUserPool(_awsUserPoolId, _awsClientId);
}

