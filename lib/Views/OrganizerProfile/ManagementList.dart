import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/OrganizerProfileService.dart';
import 'package:vybe_2/Models/EventItem.dart';
import 'package:vybe_2/Models/PlaceItem.dart';
import 'package:vybe_2/Views/CreateEvent/CreateEvent.dart';
import 'package:vybe_2/Views/CreateLocation/CreateLocation.dart';

class Management extends StatefulWidget{
  @override
  ManagementState createState() => new ManagementState();
}

class ManagementState extends State<Management>{

  Map<String, dynamic> orgData;

  Future<List<EventItem>> _eventList;
  Future<List<PlaceItem>> _placeList;
  OrganizerProfileService service = new OrganizerProfileService();

  @override
  void initState(){
    super.initState();
    service.getOrg().then((Map<String,dynamic> some){
      setState(() {
        orgData = some;
      });
    });
  }

  @override
  Widget build(BuildContext context){

    _eventList = service.getOrgEventsCreated();
    _placeList = service.getOrgPlacesCreated();

    return Theme(
      data : Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        accentColor: Colors.white,
      ),
      child: new Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('${orgData['orgName']} ${orgData['orgSurname']}', style:TextStyle(fontFamily:'SF-Pro',color:Colors.white)),
            backgroundColor: Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                        'Created Events:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 22,
                        )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff301370)
                    ),
                    width: MediaQuery.of(context).size.width ,
                    height: 2,
                  ),
                  Container(
                    child: FutureBuilder<List<EventItem>>(
                      future: _eventList,
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          List<EventItem> data = snapshot.data;
                          return createListViewEvent(data);
                        }else if(snapshot.hasError){
                          return Text('No created events',style:TextStyle(fontSize: 20));
                        }

                        return Center(child : CircularProgressIndicator(backgroundColor: Color(0xff301370),));
                      }
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                        'Created Business Profiles:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 22,
                        )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xffcd5e14)
                    ),
                    width: MediaQuery.of(context).size.width ,
                    height: 2,
                  ),
                  Container(
                    child: FutureBuilder<List<PlaceItem>>(
                        future: _placeList,
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<PlaceItem> data = snapshot.data;
                            return createListViewPlace(data);
                          }else if(snapshot.hasError){
                            return Text('No created Business profiles');
                          }

                          return Center(child : CircularProgressIndicator(backgroundColor: Color(0xff301370),));
                        }
                    ),
                  ),
                ],
              )
            )
          ),
        ),
      ),
    );
  }


  Widget createListViewPlace(data) => ListView.builder(
    itemCount : data.length,
    itemBuilder: (context, index){
      PlaceItem item = data[index];
      return ListTile(
        title: Text('${item.placeName}'+'\nCategory : ${item.categoryName}', style:TextStyle(fontFamily:'SF-Pro',color:Colors.black)),
        subtitle: Text('Posts : ${item.posts} - Comments : ${item.comments} - Likes : ${item.likes}'),
        onTap: (){
          _showPlaceOptionsDialog(item);
        }
      );
    },
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
  );

  Widget createListViewEvent(data) => ListView.builder(
    itemCount : data.length,
    itemBuilder: (context, index){
      EventItem item = data[index];
      return ListTile(
        title: Text('${item.eventName}'+'\nCategory : ${item.categoryName}', style:TextStyle(fontFamily:'SF-Pro',color:Colors.black),),
        subtitle: Text('Posts : ${item.posts} - Comments : ${item.comments} - Likes : ${item.likes}'),
        onTap:(){
          _showEventOptionsDialog(item);
        }
      );
      },
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
  );

  //dialog to delete or edit an event onClick
  _showEventOptionsDialog(EventItem item) async{
    await showDialog(
      context : context,
      builder: (context) =>
          AlertDialog(
            title: Text('Alert',textAlign:TextAlign.center,style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold,)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(50.0)),
                  padding: const EdgeInsets.all(16.0),
                  onPressed: (){
                    Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=> CreateEvent(eventId: int.parse(item.eventId),)
                      ),
                    );
                  },
                  elevation: 2,
                  child: Text('Edit Event'),
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  padding : const EdgeInsets.all(16.0),
                  onPressed: () => service.deleteEventService(item).then((Map<String,dynamic> res){
                    if(res["success"] == 1){
                      _eventList.then((List<EventItem> event){
                        List<EventItem> temp = event;
                        for(var i=0; i < temp.length; i++){
                          if(temp[i].eventId == item.eventId){
                            setState(() {
                              temp.removeAt(i);
                            });
                          }
                        }
                      });
                      Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }else{
                      Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                  }).whenComplete((){
                    Navigator.pop(context);
                  }),
                  child: Text('Delete Edit'),
                ),
              ],
            ),
            actions: <Widget>[
              RaisedButton(
                color: Colors.black,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                padding: const EdgeInsets.all(16.0),
                onPressed: ()=> Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ]
          ),
    );
  }

  //dialog to delete or edit an event onClick
  _showPlaceOptionsDialog(PlaceItem item) async{
    await showDialog(
      context : context,
      builder: (context) =>
          AlertDialog(
              title: Text('Alert',textAlign:TextAlign.center,style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold,)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(50.0)),
                    padding: const EdgeInsets.all(16.0),
                    onPressed: ()=> Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context)=> CreateLocation(locationId: int.parse(item.placeId),)
                      ),
                    ),
                    elevation: 2,
                    child: Text('Edit Place'),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    padding : const EdgeInsets.all(16.0),
                    onPressed: () => service.deletePlaceService(item).then((Map<String,dynamic> res){
                      if(res["success"] == 1){
                        _placeList.then((List<PlaceItem> place){
                          List<PlaceItem> temp = place;
                          for(var j =0 ; j< temp.length; j++){
                            if(temp[j].placeId == item.placeId){
                              setState(() {
                                temp.removeAt(j);
                              });
                            }
                          }
                        }).whenComplete((){
                          Navigator.pop(context);
                        });
                      }else{
                        Toast.show(res["message"], context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      }
                    }),
                    child: Text('Delete Place'),
                    elevation: 2,
                  ),
                ],
              ),
              actions: <Widget>[
                RaisedButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  padding: const EdgeInsets.all(16.0),
                  onPressed: ()=> Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ]
          ),
    );
  }
}