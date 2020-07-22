import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gstdetail/apiaccess/apimethod.dart';
import 'package:gstdetail/screens/Addshops.dart';
import 'package:gstdetail/screens/RatingDetails.dart';
import 'package:gstdetail/screens/firstscreen.dart';
import 'package:gstdetail/user/UserDeatils.dart';
import 'package:gstdetail/user/coginitopool.dart';
import 'package:gstdetail/user/userservice.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class HomePage extends StatefulWidget {
  UserService service;

  HomePage({this.service, a});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String message = "";
  User user = new User();
  ApiMethod _method = new ApiMethod();

  signout() async {
    try {
      widget.service.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserChoice()),
          (route) => false);
    } on CognitoClientException catch (e) {
      message = e.message;
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    } catch (e) {
      message = "Error occured Try again later";
      Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
    }
  }

  bool _isAuthenticated;

  checkauth() async {
    try {
      print(widget.service.cognitoUser.username);
      await widget.service.init();
      _isAuthenticated = await widget.service.checkAuthenticated();
      print(_isAuthenticated);
      if (_isAuthenticated) {
        user = await widget.service.getCurrentUser();
      }
    } on CognitoClientException catch (e) {
      if (e.code == 'NotAuthorizedException') {
        await widget.service.signOut();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => UserChoice()),
            (route) => false);
      }
      throw e;
    }
  }

  getdata() async {
    await _method.Getdata();
  }

  @override
  void initState() {
    checkauth();
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              SliverAppBar(
                title: Text("Home Scre en"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      signout();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Addshops()));
                    },
                  )
                ],
                bottom: TabBar(
                  tabs: <Widget>[
                    Text("huhu"),
                    Text("huhu"),
                  ],
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  children: <Widget>[
                    Container(
                      child: CustomScrollView(
                        shrinkWrap: true,
                       // physics: NeverScrollableScrollPhysics(),
                        slivers: <Widget>[
                          SliverPersistentHeader(
//            pinned: true,
                            floating: true,
                            delegate: PersistentHeader(
                                widget: Container(

                                  child: TextField(
                                    decoration: InputDecoration(border: OutlineInputBorder()),
                                  ),
                                )),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical:4.0,horizontal: 4.0),
                                child: Showlist(),
                              );
                            }, childCount: 50),
                          ),
                        ],
                      )
                    ),
                    Container(
                      child: Center(
                        child: Text("jhjnj"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// SliverPersistentHeader(
////            pinned: true,
//            floating: true,
//            delegate: PersistentHeader(
//                widget: Container(
//
//                  child: TextField(
//                    decoration: InputDecoration(border: OutlineInputBorder()),
//                  ),
//                )),
//          ),
//          SliverList(
//            delegate: SliverChildBuilderDelegate((context, index) {
//              return Container(
//                margin: const EdgeInsets.symmetric(vertical:4.0,horizontal: 4.0),
//                child: Showlist(),
//              );
//            }, childCount: 50),
//          ),
class Showlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RatingDetails()));
      },
      splashColor: Colors.blue,
      highlightColor: Colors.black87,
//      color: Colors.blue,
//      margin: EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 10,
        child: ListTile(
          title: Text("GSTNO"),
          subtitle: Text("Namen dnnuhwnc uwndwjnj ndjndiwjn "),
          trailing: rating(),
        ),
      ),
    );
  }

  rating() {
    return Container(
      child: SmoothStarRating(
        starCount: 5,
        rating: 3.5,
        color: Colors.yellow,
        borderColor: Colors.black54,
        isReadOnly: true,
      ),
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
//    return Card(color: Colors.blue,child: widget);
    return Container(
      color: Colors.black87,
      width: double.infinity,
      height: double.infinity,
      child: Card(
        margin: EdgeInsets.all(0),
        child: Center(child: widget),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
