import 'package:amazon_cognito_identity_dart/cognito.dart';
class User {
  String email;
  String gstno;
  String phoneNo;
  bool confirmed = false;
  bool hasAccess = false;

  User({this.email,this.phoneNo,this.gstno});

  /// Decode user from Cognito User Attributes
  factory User.fromUserAttributes(List<CognitoUserAttribute> attributes) {
    final user = User();
    attributes.forEach((attribute) {
      if (attribute.getName() == 'email') {
        user.email = attribute.getValue();
      }
      else if (attribute.getName() == 'name') {
        user.gstno = attribute.getValue();
      }
      else if(attribute.getName()=='phone_number')
        user.phoneNo=attribute.getValue();
    });
    return user;
  }
}