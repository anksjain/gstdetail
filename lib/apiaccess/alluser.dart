class Alluser
{
 List<Item> items;
 int count;
 Alluser({this.count,this.items});
 factory Alluser.fromJson(Map<String,dynamic> json)
 {
   return Alluser(count: json["Count"],items:parseUser(json["Items"]) );
 }
 static List<Item> parseUser(json)
 {
   var list= json as List;
   List<Item> lr=list.map((e) => Item.fromJson(e)).toList();
   return lr;
 }
}

class Item {
  String GSTNO;
  String createdBy;
  List<RatingInfo> info;
  Item({this.GSTNO,this.createdBy,this.info});
  factory Item.fromJson(Map<String,dynamic> json)
  {
    return Item(GSTNO:json["GSTNO"],createdBy: json["userId"],info:  parseInfo(json["Ratinginfo"]));
  }
 static List<RatingInfo> parseInfo(json)
 {
   var list= json as List;
   List<RatingInfo> lr=list.map((e)=>RatingInfo.fromJson(e)).toList();
   return lr;
 }
}

class RatingInfo {
  double rating;
  String byuser;
  RatingInfo({this.rating,this.byuser});
  factory RatingInfo.fromJson(Map<String,dynamic> json)
  {
    return RatingInfo(rating:json["rating"],byuser: json["userId"]);
  }
}
//rating:json["rating"],