import 'package:gstdetail/user/UserDeatils.dart';
import 'package:gstdetail/user/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';

const _identityPoolId="ap-south-1:890042c8-cbbc-497c-a9f9-27e6a8ef6a8b";

class UserService {
  CognitoUserPool userPool;
  CognitoUser cognitoUser;
  CognitoUserSession session;

  UserService(this.userPool);

  CognitoCredentials credentials;

  /// Initiate user session from local storage if present
  Future<bool> init() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = new Storage(prefs);
    userPool.storage = storage;
    cognitoUser = await userPool.getCurrentUser();
    if (cognitoUser == null) {
      print("no user");
      return false;
    }
    session = await cognitoUser.getSession();
    print(session.isValid().toString()+"session");
    return session.isValid();
  }

  /// Get existing user from session with his/her attributes
  Future<User> getCurrentUser() async {
    if (cognitoUser == null || session == null) {
      return null;
    }
    if (!session.isValid()) {
      return null;
    }
    final attributes = await cognitoUser.getUserAttributes();
    if (attributes == null) {
      return null;
    }
    final user = new User.fromUserAttributes(attributes);
    user.hasAccess = true;
    return user;
  }

  /// Retrieve user credentials -- for use with other AWS services
  Future<CognitoCredentials> getCredentials() async {
    if (cognitoUser == null || session == null) {
      print("nouser");
      return null;
    }
    credentials = new CognitoCredentials(_identityPoolId, userPool);
    //print(_session.getIdToken().getJwtToken());
    await credentials.getAwsCredentials(session.getIdToken().getJwtToken());
    print(credentials.accessKeyId);
    return credentials;
  }

  /// Login user
  Future<User> login(String email, String password) async {
    cognitoUser =
    new CognitoUser(email, userPool, storage: userPool.storage);
    final authDetails =
    new AuthenticationDetails(username: email, password: password);
    bool isConfirmed;
    try {
      session = await cognitoUser.authenticateUser(authDetails);
      isConfirmed = true;
    } on CognitoClientException catch (e) {
      if (e.code == 'UserNotConfirmedException') {
        isConfirmed = false;
      } else {
        throw e;
      }
    }

    if (!session.isValid()) {
      return null;
    }

    final attributes = await cognitoUser.getUserAttributes();
    final user = new User.fromUserAttributes(attributes);
    user.confirmed = isConfirmed;
    user.hasAccess = true;

    return user;
  }

  /// Confirm user's account with confirmation code sent to email
  Future<bool> confirmAccount(String email, String confirmationCode) async {
    cognitoUser =
    new CognitoUser(email, userPool, storage: userPool.storage);
    bool check = await cognitoUser.confirmRegistration(confirmationCode);
    print(check);
    return check;
  }

  /// Resend confirmation code to user's email
  Future<void> resendConfirmationCode(String email) async {
    cognitoUser =
    new CognitoUser(email, userPool, storage: userPool.storage);
    await cognitoUser.resendConfirmationCode();
  }

  /// Check if user's current session is valid
  Future<bool> checkAuthenticated() async {
    if (cognitoUser == null || session == null) {
      return false;
    }
    return session.isValid();
  }

  /// Sign up new user
  Future<User> signUp(String email, String password, String gst,String number) async {

    CognitoUserPoolData data;
    final userAttributes = [
      new AttributeArg(name: 'phone_number', value: number ),
      new AttributeArg(name: 'email', value: email),
      new AttributeArg(name: 'name', value: gst),
    ];

    data = await userPool.signUp(gst, password, userAttributes: userAttributes);

    final user = new User();
    user.email = email;
    user.gstno = gst;
    user.phoneNo=user.phoneNo;
    user.confirmed = data.userConfirmed;
    return user;
  }

  Future<void> signOut() async {
    if (credentials != null) {
      await credentials.resetAwsCredentials();
    }
    if (cognitoUser != null) {
      return cognitoUser.signOut();
    }
  }
}
