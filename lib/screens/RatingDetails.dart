import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RatingDetails extends StatefulWidget {
  @override
  _RatingDetailsState createState() => _RatingDetailsState();
}

class _RatingDetailsState extends State<RatingDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
//      appBar: AppBar(
//        title: Text("GST NO"),
//      ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DetailCard(),
             ratinglist()
             // Expanded(child: ratinglist(),)
            ],
          ),
        ),
      ),
    );
  }

  ratinglist() {
    return Container(
      child: ListView.builder(itemCount: 10,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder:(BuildContext context,index)
      {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text("GSTNo"),
              subtitle: Text("hbhjbhbj"),
              trailing: rating(2)
            ),
          ),
        );
      }),
    );
  }
  rating(double a) {
    return Container(
      child: SmoothStarRating(
        starCount: 5,
        rating: 3.5,
        color:Colors.blue,
//          switch(a){
//          case 1:{Colors.blue;}
//          break;
//          default:{ Colors.black;}
//          break;
//      },
        borderColor: Colors.black54,
        isReadOnly: true,
      ),
    );
  }
}

class DetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var hh = MediaQuery.of(context).size.height / 1.8;
    return Container(
      height: hh,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(70),
              bottomRight: Radius.circular(70))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        height: double.infinity,
        margin: EdgeInsets.only(bottom: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: Text("Rating Info",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),

          ],
        ),

      ),
    );
  }
}
