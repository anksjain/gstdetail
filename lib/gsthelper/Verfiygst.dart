import 'dart:convert';
import 'package:http/http.dart' as http;
class VerifyGst
{
  String _url="https://appyflow.in/api/verfyGST";
  String _key="070svRHTuWUHHrKmoXg4EJJlYk32";
  String message;
  model m= new model();
  Future<model> getGst(String gst) async{
    var Response= await http.get(_url+"?gstNo="+gst+"&key_secret="+_key);
    try{
      if(Response.statusCode==200)
        {
          final json= jsonDecode(Response.body);
//          print(json["error"]);
          if(json["error"]!=true) {
            message="Successful";
            print(json);
            m.PAN_NO = json["taxpayerInfo"]["panNo"];
            m.ctjCd = json["taxpayerInfo"]["ctjCd"];
            m.CompanyName = json["taxpayerInfo"]["tradeNam"];
            m.gstin = json["taxpayerInfo"]["gstin"];
          }
          else{
            this.message="Inavlid GSTNO";
          }
          return m;
        }
      else
        {
          print(Response.statusCode);
          this.message="Error Occur Try again later";
          return m;
          //throw Exception();
        }
    }catch(e) {
      print("object");
      this.message="Try again later";
      return m;
      throw Exception(e.toString());
    }

  }
}
class model
{
  String CompanyName;
  String PAN_NO;
  String ctjCd;
  String gstin;
  model({this.CompanyName,this.ctjCd,this.PAN_NO});

}