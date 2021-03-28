import 'package:flutter/material.dart';
import 'package:vybe_2/Data/EventProfileService.dart';
import 'package:vybe_2/Models/EventItem.dart';
import 'package:vybe_2/Views/EventProfile/EventProfile.dart';
import 'package:vybe_2/Views/tutorial/tutorial.dart';

class EventsProfileList extends StatefulWidget{
  @override
  _EventsProfileListState createState() => new _EventsProfileListState();
}

class _EventsProfileListState extends State<EventsProfileList>{

  EventProfileService service = new EventProfileService();

  //item to be passed in onclick
  @override
  void initState(){
    super.initState();
  }

  void _showOverlay(BuildContext context){
    Navigator.push(context, EventListTutorial());
  }

  @override
  Widget build(BuildContext context){
    return new Theme(
      data : Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        accentColor :Color(0xff301370),
      ),
      child: new Builder(
        builder : (context) => Scaffold(
          appBar: AppBar(
            title: Text('Events Profile', style: TextStyle(fontFamily:'SF-Pro',color:Colors.white)),
            backgroundColor: Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            ),
          ),
          body: Center(
            child: FutureBuilder<List<EventItem>>(
              future: service.eventList(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  List<EventItem> data = snapshot.data;

                  /*service.tutorialState().then((bool val){
                    if(val == true){
                      _showOverlay(context);
                    }
                  });*/

                  return _eventsListView(data);
                }else if(snapshot.hasError){
                  return Text("No Events for this category",style:TextStyle(fontFamily:'SF-Pro',fontWeight:FontWeight.w700,fontSize:18));
                }
                return new CircularProgressIndicator(
                  backgroundColor: Colors.white,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ListView _eventsListView(data){
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index){
        EventItem temp = data[index];
        return _tile(temp);
      }
    );
  }

  Widget _tile(EventItem item) => InkWell(
    child:ListTile(
        title: Text(
          '${item.eventName}',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: 'SF-Pro',
            fontSize: 21,
          ),
        ),
    ),
    onTap: (){
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context){
              return EventProfile(item:item);
            }
        ),
      );
    },
    splashColor: Color(0xffaaaaaa),
  );
}