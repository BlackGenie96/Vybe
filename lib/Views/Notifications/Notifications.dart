import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/NotificationService.dart';
import 'package:vybe_2/Models/FeedData.dart';
import 'package:vybe_2/Models/Notify.dart';
import 'package:vybe_2/Views/Feed/FeedItemClicked.dart';

class Notifications extends StatefulWidget{
  @override
  _NotificationsState createState() => new _NotificationsState();
}

class _NotificationsState extends State<Notifications>{

  NotificationService service = new NotificationService();

  @override
  Widget build(BuildContext context){
    return new Theme(
      data : Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        accentColor: Color(0xff301370),
      ),
      child: Builder(
        builder: (context) =>Scaffold(
          appBar: AppBar(
              title: Text('Notifications',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white)),
              backgroundColor: Color(0xff301370)
          ),
          body: SafeArea(
            child: FutureBuilder<List<Notify>>(
                future: service.getNotifications(),
                builder: (context, snapshot){
                  if(snapshot.hasData){

                    List<Notify> data = snapshot.data;
                    return buildListView(data);
                  }else if(snapshot.hasError){
                    return Center(child:Text('Notifications : ${snapshot.error}'));
                  }

                  return Center(child:CircularProgressIndicator(backgroundColor: Colors.white,));
                }
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListView(data) => ListView.builder(
    itemCount : data.length,
    itemBuilder: (context, index){
      Notify item = data[index];
      return ListTile(
        title: item.checked.toString() == "0"
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Icon(Icons.lens,color: Color(0xffcd5e14)),
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            Container(
              child: Text('${item.text}',style:TextStyle(fontFamily: 'SF-Pro')),
              width: MediaQuery.of(context).size.width * 0.8,
            )
          ],
        )
            : Text('${item.text}',style:TextStyle(fontFamily:'SF-Pro')),
        subtitle: Text('${item.time.toString()}', style:TextStyle(fontFamily:'SF-Pro')),
        onTap:(){
          service.getPost(item).then((FeedData item){

            if(item != null){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) {
                        return FeedItemClicked(item : item);
                      }
                  )
              );
            }
          }).catchError((err) => Toast.show(err.toString(), context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
        },
      );
    },
    shrinkWrap: true,
  );
}