import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gstdetail/apiaccess/apimethod.dart';
import 'package:gstdetail/gsthelper/Verfiygst.dart';
import 'package:gstdetail/user/UserDeatils.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Addshops extends StatefulWidget {
  @override
  _AddshopsState createState() => _AddshopsState();
}

class _AddshopsState extends State<Addshops> {
  VerifyGst verifyGst = new VerifyGst();
  bool load = false;
  String gst;
//  onverify() async {
//    if (_user.gstno == _controller.text) {
//      print("same person");
//    }
//    FocusScopeNode currentfocus = FocusScope.of(context);
//    if (!currentfocus.hasPrimaryFocus) currentfocus.unfocus();
//
//    if (_controller.text.length != 15) {
//      setState(() {
//        verfiybox = true;
//      });
//    } else {
//      setState(() {
//        load = true;
//        verfiybox = false;
//      });
//      md = await verifyGst.getGst(_controller.text);
//      if (md.CompanyName != null) {
//        setState(() {
//          load = true;
//          verfiybox=false;
//          gst=_controller.text;
//        });
//      }
//      else {
//        setState(() {
//          load = false;
//          verfiybox=false;
//        });
//        Fluttertoast.showToast(msg: verifyGst.message,);
//      }
//    }
//  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentfocus = FocusScope.of(context);
        if (!currentfocus.hasPrimaryFocus) currentfocus.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Add shops"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              field(),
              load?FutureBuilder(
                future: verifyGst.getGst(gst),
                builder: (BuildContext,AsyncSnapshot<model> snapshot)
                {
                  if(snapshot.hasData)
                    {
                      if(snapshot.data.CompanyName!=null)
                        return Expanded(child: gstdata(m: snapshot.data,));
                      else
                        return Expanded(child: Container(child:Center(child: Text(verifyGst.message),),),);
                    }
                  return Expanded(child: Container(child: Center(child: LinearProgressIndicator()),));
                },
              ):Container()
            ],
          ),
        ),
      ),
    );
  }
  field() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListTile(
//      leading: Container(height: 2050,width: 50,child: Center(child: Text("GST",style: TextStyle(fontSize: 20),),),),
        trailing: load
            ? Icon(
                EvaIcons.checkmarkCircle2,
                size: 40,
                color: Colors.green,
              )
            : IconButton(
                icon: Icon(
                  EvaIcons.checkmarkCircle,
                  size: 30,
                ),
                onPressed: () {
//                  onverify();
                },
              ),
        title: TextField(
          onChanged: (v)
          {
            this.gst=v;
            if(v.length==15) {
              setState(() {
                load = true;
              });
            }
            else
              {
                setState(() {
                  load=false;
                });
              }
          },
          maxLength: 15,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
              errorText: !load ? "Please enter 15 Digits GST No" : null,
              prefix: Text("GST-NO  "),
              prefixStyle: TextStyle(color: Colors.black),
              labelText: "Enter GST NO",
              hintText: "Should not be less than 15",
              hintMaxLines: 15,
              border: OutlineInputBorder()),
        ),
      ),
    );
  }
}

class gstdata extends StatefulWidget {
  model m;
  gstdata({this.m});
  @override
  _gstdataState createState() => _gstdataState();
}

class _gstdataState extends State<gstdata> {
  ApiMethod method= ApiMethod();
  double rate;
  bool complete=false;
  String review;
  @override
  Widget build(BuildContext context) {
    var hh = MediaQuery.of(context).size.height;
    var ww = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Divider(),
            comments(),
            showdata(hh, ww),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 40,
        width: ww,
      //  color: Colors.red,
        child: RawMaterialButton(
          fillColor: complete?Colors.blue:Colors.black12,
          onPressed: complete?() {}:null,
          child: Text("Submit"),
        ),
      ),
    );
  }

  comments() {
    return Container(
      decoration: BoxDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        onChanged: (v)
        {
          if(v.length<=3 || rate<=0)
            complete=false;
          else
            complete=true;
          setState(() {
            this.review=v;
          });
        },
        autocorrect: true,
        keyboardType: TextInputType.multiline,
        maxLines: 2,
        decoration: InputDecoration(
            hintText: "Write Your Experience",
            labelText: "Review",
            border: OutlineInputBorder()),
      ),
    );
  }

  showdata(double height, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
          color: Colors.blueAccent,
          elevation: 20,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5,right: 1),
                color: Colors.purple,
                height: height / 2,
                width: 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                    height: height / 2,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        eachdata("Company Name", widget.m.CompanyName),
                        eachdata("Pano No", widget.m.PAN_NO),
                        eachdata("GST", widget.m.gstin),
                        eachdata("CTJCD", widget.m.ctjCd),
                        Center(child: rating(),)
                      ],
                    )),
              ),
            ],
          )),
    );
  }

  rating() {
    return Container(
      child: SmoothStarRating(
        starCount: 5,
        rating: 0,
        color: Colors.yellow,
        borderColor: Colors.black54,
        onRated: (v) {
          if(v==0 || this.review.length<=3)
            complete=false;
          else
            complete=true;
          setState(() {
            this.rate = v;
          });
          print(this.rate);
        },
      ),
    );
  }

  eachdata(String type, String value) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            type,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
//load
//                  ? FutureBuilder(
//                      future: verifyGst.getGst(_controller.text),
//                      builder: (BuildContext, AsyncSnapshot<model> snapshot) {
//                        if (snapshot.hasData) {
//                          print(snapshot.data.CompanyName);
//                          return Container(
//                            color: Colors.black,
//                            height: 50,
//                          );
//                        }
//                        return Center(
//                          child: CircularProgressIndicator(),
//                        );
//                      })
//                  : Container()

//              Expanded(
//                child: Container(
//                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
//                  child: Card(
//                    elevation: 20,
//                    margin: EdgeInsets.only(top: 50),
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                       gstdata(),
//                        Spacer(),
//                        rating(),
//                        SizedBox(height: 20,),
//                        Padding(
//                          padding: EdgeInsets.symmetric(horizontal: 10),
//                          child: MaterialButton(
//                            minWidth: double.infinity,
//                            child: Text("Submit"),
//                            color: Colors.white,
//                            onPressed: ()
//                            {
//                              apiMethod.postdata(this.rate,this.gst);
//                            },
//                          ),
//                        )
//                      ],
//                    ),
//                    color: Colors.blueAccent,
//                  ),
//                ),
//              ):Container()