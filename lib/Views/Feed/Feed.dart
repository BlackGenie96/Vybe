import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/FeedService.dart';
import 'package:vybe_2/Models/EventItem.dart';
import 'package:vybe_2/Models/FeedData.dart';
import 'package:vybe_2/Models/PlaceItem.dart';
import 'package:vybe_2/Views/Feed/FeedItemClicked.dart';
import 'package:vybe_2/Views/PlaceProfile/PlaceProfile.dart';
import 'package:vybe_2/Views/EventProfile/EventProfile.dart';

class Feed extends StatefulWidget {

  String eventId;
  String locationId;

  Feed({this.eventId, this.locationId});

  @override
  _Feed createState() => new _Feed(eventId: eventId, locationId:locationId);
}

class _Feed extends State<Feed> {

  String eventId;
  String locationId;
  _Feed({this.eventId, this.locationId});

  FeedService service = new FeedService();
  Future<List<FeedData>> feedList;
  SharedPreferences prefs;

  @override
  void initState(){
    super.initState();

    if(eventId != null){
      //function to fetch feed list for events when the event Id is specified
      feedList =  service.fetchEventFeed(eventId);
    }else if(locationId != null){
      //function to fetch feed list for places when the place Id is specified
      feedList = service.fetchPlaceFeed(locationId);
    }else{
      //function to fetch feed when neither the event id or place id are not specified.
      feedList = service.fetchFeed();
    }

  }

  Widget build(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Color(0xff301370),
        accentColor: Colors.white,
        primaryColor: Colors.white,
      ),
      child: new Builder(
        builder: (context) =>Scaffold(
          appBar: AppBar(
            title: Text(
              eventId != null ? 'Event Posts' : locationId != null ? 'Place Posts' : 'Feed',
              style: TextStyle(
                fontFamily: 'SF-Pro',
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xff301370),
            iconTheme : IconTheme.of(context).copyWith(
              color: Colors.white,
            ),
          ),
          body: SafeArea(
            child: FutureBuilder<List<FeedData>>(
              future: feedList,
              builder:(context, snapshot){
                if(snapshot.hasData){
                  List<FeedData> data = snapshot.data;
                  return _feedListView(data);
                }else if(snapshot.hasError){
                  return Center(child:Text('Feed Error${snapshot.error}',style:TextStyle(color: Colors.white)));
                }
                return new Center(
                  child:CircularProgressIndicator(
                    backgroundColor: Color(0xff),
                  ),
                );
              },
            ),
          ),
        )
      )
    );
  }

  ListView _feedListView(data){
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index){
        FeedData temp = data[index];
        temp.toString();
        return _tile(temp);
      }
    );
  }

  ///This is the second function to sort out the feed listview tiles
  Card _tile(FeedData item) => Card(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap:(){
                print("Display Image hero");
                _goToProfileImageHeroClick(context, item);
              },
              child: Hero(
                tag:'${item.postId}',
                child:Container(
                  child:CircleAvatar(
                    backgroundImage: item.posterProfile == null ? AssetImage('assets/logo.png') : MemoryImage(base64Decode(item.posterProfile)),
                  ),
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(
                    top:4,
                    left:6,
                    right: 8
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top:7),
                    alignment:Alignment.centerLeft,
                    child:Text(
                      '${item.posterName} ${item.posterSurname}',
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 20,
                        color : Color(0xff301370),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    item.postTime,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontSize: 15,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 1.5,
          decoration: BoxDecoration(
            color: Color(0xffcd5e14),
          ),
          margin: const EdgeInsets.only(top: 2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                left: 12,
                top: 3,
              ),
              width: MediaQuery.of(context).size.width * 0.27,
              child: Text(
                'Posted About:',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontSize: 14,
                  color: Colors.grey[800],
                ),
              ),
            ),
            GestureDetector(
              onTap:(){
                if(item.tag == 'post_user_event_relation'){
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (context){
                          EventItem event = new EventItem(eventId:item.postedId, eventName: item.postedName);
                          return new EventProfile(item: event);
                        },
                      )
                  );
                }else if(item.tag == 'post_user_location_relation'){
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (context){
                          PlaceItem place = new PlaceItem(placeId:item.postedId, placeName: item.postedName);
                          return new PlaceProfile(item: place);
                        },
                      )
                  );
                }else if(item.tag == 'post_org_event_relation'){
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (context){
                          EventItem event = new EventItem(eventId:item.postedId, eventName: item.postedName);
                          return new EventProfile(item: event);
                        },
                      )
                  );
                }else if(item.tag == 'post_org_location_relation'){
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (context){
                          PlaceItem place = new PlaceItem(placeId:item.postedId, placeName: item.postedName);
                          return new PlaceProfile(item: place);
                        },
                      )
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.only(
                  left: 8,
                ),
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  '${item.postedName}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff301370),
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment : Alignment.centerLeft,
              margin : const EdgeInsets.only(left: 12,top: 7,bottom: 7),
              child:Text(item.status,textAlign:TextAlign.start,style:TextStyle(fontFamily:'SF-Pro',fontSize:18,color:Colors.black)),
            ),
          ],
        ),
        item.imageUrl == null || item.imageUrl == ""
            ? Text('')
            : GestureDetector(
          onTap: (){
            //go to feed item clicked
            print('Go to on feed item clicked activity.');
            goToItemClicked(item);
          },
          child: Container(
            margin: const EdgeInsets.only(
              top: 14,
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: item.imageUrl == null ? Image.asset('assets/logo.png') : Image.memory(
                base64Decode(item.imageUrl),
                width:MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: (){
                try{
                  service.likePost(item).then((Map<String,dynamic> res){
                    if(res["success"] == 1){
                      setState((){
                        item.likes++;
                      });
                      Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }else if(res["success"] == 2){
                      setState(() {
                        item.likes--;
                      });
                      Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }else{
                      Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                  }).catchError((err){
                    Toast.show("Like Error"+err.toString(), context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    print(err);
                  });
                }catch(err){
                  print('ERROR MESSAGE -----> '+err);
                }

              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.48,
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.thumb_up,
                        color: Color(0xff301370),
                      ),
                      Text(
                        '${item.likes}',
                        style: TextStyle(fontFamily:'SF-Pro', color:Color(0xff301370)),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                print('Comment has been clicked.');
                // go to feed item clicked.
                goToItemClicked(item);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.48,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.comment,
                      color: Color(0xff301370),
                    ),
                    Text(
                      '${item.comments}',
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        color:Color(0xff301370),
                      )
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );

  //function to handle the profile image hero click
  void _goToProfileImageHeroClick(context,FeedData item){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) => Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Color(0xaa000000)
          ),
          child: new Builder(
            builder:(context) => Scaffold(
              appBar: AppBar(
                title: Text('${item.posterName} ${item.posterSurname}',style:TextStyle(fontFamily:'SF-Pro', color:Colors.white)),
                backgroundColor: Colors.black,
                iconTheme: IconTheme.of(context).copyWith(
                  color: Colors.white,
                )
              ),
              body: Center(
                child: Hero(
                  tag: '${item.postId}',
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: item.posterProfile == null ? Image.asset('assets/logo.png') : Image.memory(base64Decode(item.posterProfile)),
                  ),
                  transitionOnUserGestures: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goToItemClicked(item){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context){
          return FeedItemClicked(item: item, org: false);
        }
      ),
    );
  }
}

