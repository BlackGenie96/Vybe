import 'package:flutter/material.dart';
import 'package:vybe_2/Views/Suggestions/AddUserSuggestion.dart';
import 'package:vybe_2/Views/settings/controller.dart';

class Settings extends StatefulWidget{
  @override
  _SettingsState createState() => new _SettingsState();
}

class _SettingsState extends State<Settings>{

  bool notifications;
  bool _tutorials;
  SettingsController settings = new SettingsController();

  void initVariables() async{
    settings.getTutorialValue().then((bool val){
      setState(() {
        _tutorials = val;
      });
    });

    print("Tutorials $_tutorials");

    settings.getLocationNotificationValue().then((bool val){
      setState(() {
        notifications = val;
      });

    });
  }

  @override
  void initState(){
    super.initState();

    initVariables();
    print("tutorials $_tutorials");
  }

  @override
  Widget build(BuildContext context){
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        accentColor: Color(0xff301370),
      ),
      child: new Builder(
        builder: (context) => new Scaffold(
          appBar: AppBar(
            title: Text('Settings', style: TextStyle(fontFamily: 'SF-Pro', color: Colors.white)),
            backgroundColor: Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color:Colors.white,
            ),
          ),
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    title: Text('Enable app tutorials'),
                    trailing: _tutorials ? Icon(Icons.check_box,color:Colors.green[800]) : Icon(Icons.check_box_outline_blank,color:Colors.green[800]),
                    onTap: (){
                      setState(() {
                        if(_tutorials){
                          settings.turnOffTutorial().then((dynamic res){
                            setState(() {
                              _tutorials = !_tutorials;
                            });
                          });
                        }else{
                          settings.turnOnTutorial().then((dynamic res){
                            _tutorials = !_tutorials;
                          });
                        }
                      });
                    },
                  ),
                  /*ListTile(
                    title: notifications ? Text('Disable nearby place notification') : Text('Enable nearby place notification'),
                    trailing : notifications ? Icon(Icons.check_box,color:Colors.green[800]) : Icon(Icons.check_box_outline_blank,color:Colors.green[800]),
                    onTap: (){
                      setState(() {
                        if(notifications){
                          settings.turnOffLocationNotification();
                        }else{
                          settings.turnOnLocationNotification();
                        }

                        notifications = !notifications;
                      });
                    },
                  ),
                  ListTile(
                title: Text('About App'),
                onTap: (){
                  //TODO: go to the about app page and have a summary of the purpose vybe was built for.
                }
              ),*/
              ListTile(
                title: Text('Add Suggestion'),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context){
                        return AddUserSuggestion();
                      }
                    )
                  );
                },
              ),
                ],
              ),

            ),
          ),
        ),
      )
    );
  }
}