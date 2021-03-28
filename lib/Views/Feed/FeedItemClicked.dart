import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vybe_2/Data/FeedService.dart';
import 'package:vybe_2/Models/Comments.dart';
import 'package:vybe_2/Models/EventItem.dart';
import 'package:vybe_2/Models/FeedData.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Models/PlaceItem.dart';
import 'package:vybe_2/Views/EventProfile/EventProfile.dart';
import 'package:vybe_2/Views/PlaceProfile/PlaceProfile.dart';

class FeedItemClicked extends StatefulWidget{

  //variable for constructor
  final FeedData item;
  final bool org;
  FeedItemClicked({this.item, this.org});

  @override
  _FeedItemClickedState createState() => new _FeedItemClickedState(item:item, orgComment: org);
}

class _FeedItemClickedState extends State<FeedItemClicked>{

  int _id;
  String _name;
  final FeedData item;
  var commentController = TextEditingController();
  final bool orgComment;

  //constructor
  _FeedItemClickedState({this.item, this.orgComment});

  //future builder response list
  Future<List<Comment>> commentsList;
  FeedService service = new FeedService();

  @override
  void initState(){
    super.initState();
    commentsList = service.fetchComments(item);

    service.getUserId().then((int id){
      _id = id;
      print('FEED_ITEM_CLICKED: User id set successfully.');
    }).catchError((error){
      print('FEED_ITEM_CLICKED: '+error);
      Toast.show(error, context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });

    service.getUserName().then((String userName){
      _name = userName;
      print('FEED_ITEM_CLICKED: Username set succesfully.');
    }).catchError((error){
      print('FEED_ITEM_CLICKED: '+error);
      Toast.show(error, context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });

  }

  @override
  Widget build(BuildContext context){
    return new Theme(
      data : Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        accentColor : Colors.white,
        primaryColor: Colors.white,
        cursorColor: Color(0xff301370)
      ),
      child: new Builder(
        builder : (context) => Scaffold(
            appBar: AppBar(
              backgroundColor: (item.tag == "post_org_location_relation" || item.tag == "post_org_event_relation") ?
              Color(0xffcd5e14) :
              Color(0xff301370),
              iconTheme: IconTheme.of(context).copyWith(
                color : Colors.white,
              ),
              title: Text(
                '${item.posterName} ${item.posterSurname}',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  color: Colors.white,
                ),
              ),
            ),
            body: _buildBody(item)
        )
      ),
    );
  }

  Widget _buildBody(FeedData item) => SafeArea(
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
                  'posted About',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 15,
                    color: Colors.grey,
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
          item.imageUrl == ""
              ? Text('')
              : GestureDetector(
            onTap: (){
              //show image using heroes
              print('Show image using heroes.');
            },
            child: Container(
              margin: const EdgeInsets.only(
                top: 15,
              ),
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(base64Decode(item.imageUrl)),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment:Alignment.centerLeft,
                child:Text(item.status,textAlign:TextAlign.start,style:TextStyle(fontFamily:'SF-Pro',fontSize:18,color:Colors.black)),
                margin: const EdgeInsets.only(top:7,bottom:7,left: 15),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: (){
                  print('Like has been clicked.');
                  service.likePostItemClicked(item).then((FeedData res){
                    setState((){
                      item = res;
                    });
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.48,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment : CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.thumb_up,
                        color: Color(0xff301370),
                      ),
                      Text(
                        '${item.likes}',
                        style: TextStyle(
                          fontFamily:'SF-Pro',
                          color: Color(0xff301370),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  print('Comment has been clicked.');
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: _commentsBuilder(),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width *0.85,
                  child: TextFormField(
                    controller: commentController,
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      color : Colors.black,
                    ),
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      labelText : "Write a comment",
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'SF-Pro',
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          borderSide : BorderSide(color: Colors.black, width: 1)
                      ),
                      enabledBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          borderSide : BorderSide(color: Colors.black, width: 1)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          borderSide : BorderSide(color: Colors.black, width: 1)
                      )
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                GestureDetector(
                  onTap:(){
                    //send comment message to server.
                    if(orgComment == true){
                      service.sendOrgComment(item, commentController.text).then((FeedData res){
                        setState(() {
                          item = res;
                          commentsList = service.fetchComments(item);
                          commentController.clear();
                        });
                      });
                    }else if(orgComment == false){
                      service.sendUserComment(item, commentController.text).then((FeedData res){
                        setState((){
                          item = res;
                          commentsList = service.fetchComments(item);
                          commentController.clear();
                        });
                      });
                    }else{
                      print("Error in sending comment.");
                      Toast.show("Error in sending comment.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Icon(
                      Icons.send,
                      color: Color(0xff301370),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  _commentsBuilder(){
    return FutureBuilder<List<Comment>>(
      future: commentsList,
      builder: (context, snapshot){
        if(snapshot.hasData){
          //custom code goes here
          List<Comment> data = snapshot.data;

          return _commentsListView(data);
        }else if(snapshot.hasError){
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  ListView _commentsListView(data){
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index){
        Comment temp = data[index];
        if(_id == temp.userId && _name == temp.userName){
          return _myComment(temp);
        }else{
          return _otherComment(temp);
        }
      },
      shrinkWrap: true,
    );
  }

  Container _myComment(Comment item) => Container(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              top: 9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Color(0xffcd5e14),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(item.commentMessage,textAlign:TextAlign.start,style:TextStyle(fontFamily:'SF-Pro',fontSize:18,color:Colors.white)),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              item.commentTime,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'SF-Pro',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Container _otherComment(Comment item) => Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(
      bottom: 12,
    ),
    child: Padding(
      padding: const EdgeInsets.only(left:15),
      child: GestureDetector(
        onTap: (){
          print('vybe on the comment');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${item.userName} ${item.userSurname}',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'SF-Pro',
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              margin: const EdgeInsets.only(right: 90,top:8, bottom: 7),
              decoration: BoxDecoration(
                color : Color(0xff301370),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(item.commentMessage,textAlign:TextAlign.start,style:TextStyle(fontFamily:'SF-Pro',fontSize:18,color:Colors.white)),
              ),
            ),
            Text(
              item.commentTime,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'SF-Pro',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    ),
  );

}