import 'package:flutter/material.dart';
import 'package:vybe_2/Data/OrganizerProfileService.dart';
import 'package:vybe_2/Models/FeedData.dart';
import 'package:vybe_2/Models/OrganizerNotification.dart';
import 'package:vybe_2/Views/Feed/FeedItemClicked.dart';

class OrgNotification extends StatefulWidget{
  final int orgId;
  OrgNotification({this.orgId});

  @override
  OrgNotificationState createState() => new OrgNotificationState(orgId: orgId);
}

class OrgNotificationState extends State<OrgNotification>{

  final int orgId;
  OrgNotificationState({this.orgId});
  OrganizerProfileService service = new OrganizerProfileService();

  Widget build(BuildContext context){
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Color(0xff301370),
        primaryColor:Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Builder(
        builder: (context) => new Scaffold(
          appBar: AppBar(
            title: Text(
              'Notifications',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: 'SF-Pro',
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            ),
          ),
          body: SafeArea(
            child:FutureBuilder<List<OrgNotItem>>(
                future: service.getNotifications(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List<OrgNotItem> data = snapshot.data;
                    return buildList(data);
                  }else if(snapshot.hasError){
                    return Text("${snapshot.error}");
                  }

                  return Center(child : CircularProgressIndicator(backgroundColor: Colors.white));
                }
            ),
          ),
        ),
      ),
    );
  }


  Widget buildList(data) => ListView.builder(
    itemCount : data.length,
    itemBuilder: (context, index){
      OrgNotItem item = data[index];
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
              child: Text('${item.text}', style:TextStyle(fontFamily: 'SF-Pro')),
              width: MediaQuery.of(context).size.width * 0.8,
            )
          ],
        )
            : Text('${item.text}',style:TextStyle(fontFamily: 'SF-Pro')),
        subtitle: Text('${item.time.toString()}',style:TextStyle(fontFamily: 'SF-Pro')),
        onTap:(){
          service.getEvent(item).then((FeedData res){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return FeedItemClicked(item : res, org: true,);
                }
              )
            );
          });
        },
      );
    },
    shrinkWrap: true,
  );
}