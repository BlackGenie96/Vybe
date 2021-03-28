import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/OrganizerProfileService.dart';
import 'package:vybe_2/Views/OrganizerProfile/ManagementList.dart';
import 'package:vybe_2/Models/OrgData.dart';
import 'package:vybe_2/Views/Navigation/Navigation.dart';
import 'package:vybe_2/Views/CreateEvent/CreateEvent.dart';
import 'package:vybe_2/Views/CreateLocation/CreateLocation.dart';
import 'package:vybe_2/Views/OrganizerProfile/OrgPayments.dart';
import 'package:vybe_2/Views/OrganizerProfile/OrganizerProfile.dart';
import 'package:vybe_2/Views/OrganizerProfile/OrganizerNotifications.dart';

class OrganizerMenu extends StatefulWidget{
  @override
  _OrganizerMenuState createState() => new _OrganizerMenuState();
}

class _OrganizerMenuState extends State<OrganizerMenu>{

  OrgData dat;
  OrganizerProfileService service = new OrganizerProfileService();

  @override
  void initState(){
    super.initState();
    service.getUserId().then((OrgData res){
      dat = res;
    }).catchError((err){
      Toast.show(err.toString(), context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
  }

  @override
  Widget build(BuildContext context){
    return new Theme(
      data:Theme.of(context).copyWith(
        accentColor: Colors.white,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      child: new Builder(
        builder: (context)=> Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back,color:Colors.white,),onPressed:() => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context){
                    return Navigation();
                  }
              ),
            ),),
            title: Text('Manager',style:TextStyle(color:Colors.white, fontFamily:'SF-Pro')),
            backgroundColor: Color(0xff301370),
          ),
          body: _createBody(),
        )
      )
    );
  }

  Widget _createBody() => SafeArea(
    child:SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //create event iconButton and text
            SizedBox(height: 25.0,),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color:Color(0xffcd5e14), width:1),
                ),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.5,
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                      Icons.event,
                      color: Color(0xff301370),
                      size: 50.0
                  ),
                ),
              ),
              onTap: (){
                goToCreateEvent(context);
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: Text(
                'Create Event Profile',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  color: Color(0xff301370),
                  fontSize: 25,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
            SizedBox(height: 25.0,),
            InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color:Color(0xffcd5e14), width:1),
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                        Icons.add_location,
                        color: Color(0xff301370),
                        size: 50.0
                    ),
                  ),
                ),
                onTap: ()=> goToCreateLocation(context)
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: Text(
                'Create Business Profile',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  color: Color(0xff301370),
                  fontSize: 25,
                  fontWeight:FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 25.0),
            InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color:Color(0xffcd5e14), width:1),
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                        Icons.notifications_active,
                        color: Color(0xff301370),
                        size: 50.0
                    ),
                  ),
                ),
                onTap: ()=> goToNotifications(context)
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  color: Color(0xff301370),
                  fontSize: 25,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
            SizedBox(height: 25.0),
            InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color:Color(0xffcd5e14), width:1),
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                        Icons.settings,
                        color: Color(0xff301370),
                        size: 50.0
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context){
                        return Management();
                      }
                    ),
                  );
                }
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: Text(
                'Management',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  color: Color(0xff301370),
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            /*SizedBox(height: 25.0),
            InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color:Color(0xffcd5e14), width:1),
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                        Icons.payment,
                        color: Color(0xff301370),
                        size: 50.0
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context){
                          return Payments();
                        }
                    ),
                  );
                }
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: Text(
                'Payments',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  color: Color(0xff301370),
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),*/
            SizedBox(height: 25.0),
            InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color:Color(0xffcd5e14), width:1),
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                        Icons.person,
                        color: Color(0xff301370),
                        size: 50.0
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context){
                          return OrgProfile();
                        }
                    ),
                  );
                }
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: Text(
                'Manager Profile',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  color: Color(0xff301370),
                  fontSize: 25,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
            SizedBox(height: 25.0),
            InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color:Color(0xffcd5e14), width:1),
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                        Icons.exit_to_app,
                        color: Color(0xff301370),
                        size: 50.0
                    ),
                  ),
                ),
                onTap: (){
                  service.logout().then((dynamic res){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context){
                            return Navigation();
                          }
                      ),
                    );
                  });

                }
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: Text(
                'Manager Logout',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  color: Color(0xff301370),
                  fontSize: 25,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
            SizedBox(height: 12.0)
          ],
        ),
      ),
    ),
  );

  //methods to handle navigation
  void goToCreateEvent(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return CreateEvent();
        }
      )
    );
  }

  void goToCreateLocation(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context){
          return CreateLocation();
        }
      )
    );
  }

  void goToNotifications(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context){
          int orgId;
          service.getOrgId().then((some){
            orgId = some;
          });
          return OrgNotification(orgId:orgId);
        }
      )
    );
  }
}