import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gstdetail/screens/signup.dart';

class GSTVERFIFY extends StatefulWidget {
  @override
  _GSTVERFIFYState createState() => _GSTVERFIFYState();
}

class _GSTVERFIFYState extends State<GSTVERFIFY> {
  bool seterror = false;
  bool buuton=true;
   String Gst;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet:buuton?null: GestureDetector(
        onTap: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Signing(username: Gst,)));
        },
        child: Container(
          color:  Colors.red ,
          child: Center(child: Text("Sign up")),
          width: MediaQuery.of(context).size.width,
          height: 50,
        ),
      ),
      body: Container(
        color: Colors.lightBlueAccent,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Center(
                  child: Text("Verfiy GST NUMBER",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
            //Spacer(flex: 2,),
            ListTile(
              trailing: Icon(Icons.check),
              title: TextField(
                maxLength: 15,
                onChanged: (value) {
                  if (value == "" || value == null) {
                    seterror = true;
                    buuton = true;
                  }
                  else {
                    seterror = false;
                    buuton = false;
                  }
                  setState(() {
                    this.Gst=value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                    labelText: "GST NO",
                    hintText: "Enter a GST NO",
                    prefixText: "GST-",
                    prefixStyle: TextStyle(color: Colors.black),
                    errorText: seterror ? "Enter correct number" : null),
              ),
            ),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
