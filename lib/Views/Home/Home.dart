import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/HomeService.dart';
import 'package:vybe_2/Views/Calendar/Calendar.dart';
import 'package:vybe_2/Views/EventProfile/EventsProfileList.dart';
import 'package:vybe_2/Views/Feed/Feed.dart';
import 'package:vybe_2/Views/OrganizerProfile/OrganizerLogin.dart';
import 'package:vybe_2/Views/OrganizerProfile/OrganizerMenu.dart';
import 'package:vybe_2/Views/PlaceProfile/PlaceProfileList.dart';
import 'package:vybe_2/Views/UserProfile/UserProfile.dart';
import 'package:vybe_2/Views/tutorial/HomeTutorialOverlay.dart';
import 'package:vybe_2/Views/MainSearch/main_search.dart';
import 'package:vybe_2/Views/logging/Logout.dart';
import 'package:vybe_2/Views/Map/Map.dart';
import 'package:vybe_2/Views/settings/controller.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => new _Home();
}

class _Home extends State<Home> {
  List<MenuItem> items = [
    new MenuItem(Image.asset('assets/logo.png'), 'Feed'),
    new MenuItem(Image.asset('assets/logo.png'), 'Calendar'),
    new MenuItem(Image.asset('assets/logo.png'), 'Events Profile'),
    new MenuItem(Image.asset('assets/logo.png'), 'Business Profile'),
    new MenuItem(Image.asset('assets/logo.png'), 'My Profile'),
    new MenuItem(Image.asset('assets/logo.png'), 'Manager Profile'),
    new MenuItem(Image.asset('assets/logo.png', ), 'Map'),
    new MenuItem(Image.asset('assets/logo.png',), 'Logout')
  ];

  SettingsController settings = new SettingsController();
  HomeService service = new HomeService();

  @override
  void initState(){
    super.initState();


  }

  void askAboutTutorial() async => await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Tutorial'),
      content: Text('Do you want to continue with the tutorial ?'),
      actions: <Widget>[
        MaterialButton(
          child: Text("Yes"),
          onPressed:(){
            service.tutorialState().then((String res){

              if(res == "first"){
                _showOverlay(context);
              }else if(res == "settings"){
                _showOverlay(context);
              }
            });
          },
        ),
        MaterialButton(
          child: Text("No"),
          onPressed: (){
            service.tutorialState().then((String res){

              if(res == "first"){
                //_showOverlay(context);
                // Do nothing
              }
            });

            service.tutorialState().then((String res){
              if(res == "first ended"){
                Toast.show('You can view tutorials in the Settings.',context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
            });
          }
        ),
      ],
    ),
  );

  Widget build(BuildContext context){
    return new Theme(
      data: Theme.of(context).copyWith(
        accentColor: Colors.white,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white
      ),
      child: new Builder(
        builder: (context)=>Scaffold(
          appBar: AppBar(
            title: Text(
              'Home',
              style: TextStyle(
                fontFamily: 'SF-Pro',
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xff301370),
            actionsIconTheme: IconTheme.of(context).copyWith(
              color:Colors.white,
            ),
            actions: <Widget>[
              InkWell(
                onTap:(){
                  print("Go to search page.");
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MainSearch()
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.search,color: Colors.white,size: 30)
                ),
                borderRadius: BorderRadius.circular(90),
              ),
            ],
          ),
          body: GridView.count(
            crossAxisCount: 2,
            children:<Widget>[
              createCard(context, items[0]),
              createCard(context, items[1]),
              createCard(context, items[2]),
              createCard(context, items[3]),
              createCard(context, items[4]),
              createCard(context, items[5]),
              createCard(context, items[6]),
              createCard(context, items[7]),
            ],
          ),
        ),
      ),
    );
  }

  ///function to handle the creation of card widgets with
  ///Gesture Detector enabled
  Card createCard(BuildContext context,MenuItem item){
    return new Card(
      child: GestureDetector(
        onTap: (){
          print('I have been clicked: ${item.title}');
          goToItemActivity(context, item);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(flex:10, child: item.image,),
            Expanded(flex:2, child: Text(item.title, style: TextStyle(fontFamily:'SF-Pro',fontSize:22),textAlign: TextAlign.center,)),
          ],
        ),
      ),
    );
  }

  ///function to handle navigation on click
  goToItemActivity(BuildContext context, MenuItem item) {
    switch (item.title) {
      case 'Feed':
        goToFeed(context);
        break;
      case 'Calendar':
        goToCalendar(context);
        break;
      case 'Events Profile':
        goToEventsProfile(context);
        break;
      case 'Business Profile':
        goToPlacesProfile(context);
        break;
      case 'My Profile':
        goToUserProfile(context);
        break;
      case 'Manager Profile':
        goToOrganizer(context);
        break;
      case 'Logout':
        goToLogout(context);
        break;
      case 'Map':
        /*Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context){
              return Map();
            }
          )
        );*/
        Toast.show('Map functionality coming soon',context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        break;
      default:
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) {
                return new MaterialApp(
                  home: OrganizerLogin(),
                  theme: ThemeData(
                    scaffoldBackgroundColor: Color(0xff301370),
                    primaryColor: Colors.white,
                  ),
                );
              }
          ),
        );
    }
  }

  //navigator functions
  goToOrganizer(BuildContext context) async{

    service.getOrganizerLoginState().then((bool val){
      if(val == true && val != null){
        //Toast.show('${prefs.getBool('orgLogged')}', context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).push(
            MaterialPageRoute(
                builder:(BuildContext context){
                  return new MaterialApp(
                    home: OrganizerMenu(),
                  );
                }
            )
        );
      }else{
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context){
                  return new MaterialApp(
                    home: OrganizerLogin(),
                  );
                }
            )
        );
      }
    });
  }

  goToFeed(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return Feed();
        }
      ),
    );
  }

  goToCalendar(BuildContext context){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context){
          return Calendar();
        }
      ),
    );
  }

  goToEventsProfile(BuildContext context){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context){
          return EventsProfileList();
        }
      ),
    );
  }

  goToPlacesProfile(BuildContext context){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context){
          return PlaceList();
        }
      ),
    );
  }

  goToUserProfile(BuildContext context){
    Navigator.of(context).push(
      new MaterialPageRoute(
          builder: (BuildContext context){
            return UserProfile();
          }
      ),
    );
  }

  goToLogout(BuildContext context){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context)=> Logout()
      )
    );
  }

  void _showOverlay(BuildContext context){
    Navigator.of(context).push(TutorialOverlay());
  }

}

class MenuItem{
  var image;
  var title;

  MenuItem(this.image, this.title);
}