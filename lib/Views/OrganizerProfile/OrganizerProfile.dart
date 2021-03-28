import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vybe_2/Data/OrganizerProfileService.dart';
import 'package:vybe_2/Models/OrgData.dart';
import 'package:vybe_2/Views/OrganizerProfile/OrganizerProfileEdit.dart';

class OrgProfile extends StatefulWidget{
  @override
  _OrgProfileState createState() => new _OrgProfileState();
}

class _OrgProfileState extends State<OrgProfile>{
  OrgData orgData;
  OrganizerProfileService service = new OrganizerProfileService();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data :Theme.of(context).copyWith(
        accentColor: Color(0xff301370),
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Builder(
        builder : (context) => Scaffold(
          appBar: AppBar(
            title : Text('Profile',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white),),
            backgroundColor: Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: (){
                  print("Editing organizer profile.");
                  goToOrgEdit(orgData);
                },
                child : Padding(
                  padding : const EdgeInsets.all(15.0),
                  child : Text(
                    'Edit',
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontSize : 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                  child: FutureBuilder<OrgData>(
                    future: service.getOrganizerProfile(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        this.orgData = snapshot.data;
                        return buildBody(orgData);
                      }else if(snapshot.hasError){
                        return Text("${snapshot.error}");
                      }

                      return CircularProgressIndicator(backgroundColor: Colors.white);
                    },
                  )
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget buildBody(OrgData data) => Container(
    width : MediaQuery.of(context).size.width,
    child : Column(
      mainAxisAlignment : MainAxisAlignment.center,
      crossAxisAlignment : CrossAxisAlignment.center,
      children : <Widget>[
        SizedBox(height: 20.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color:Color(0xff301370), width : 3),
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            //go to organizer profile image hero
            onTap: (){
              heroClick(context, data);
            },
            child: Hero(
              tag : 'org_profile_hero',
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage : data.profileUrl != null ? MemoryImage(base64Decode(data.profileUrl)) : AssetImage('assets/logo.png'),
              ),
            ),
          ),
          width: 150,
          height: 150
        ),
        SizedBox(height: 20.0),
        Container(
          child: Text(
            '${data.orgName}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SF-Pro',
              color: Color(0xffcd5e14),
              fontSize : 18,
              fontWeight: FontWeight.w700
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          child: Text(
            "${data.orgSurname}",
            textAlign: TextAlign.center,
            style:TextStyle(
              fontFamily:'SF-Pro',
              color: Color(0xffcd5e14),
              fontSize: 18,
              fontWeight:FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          width: MediaQuery.of(context).size.width,
          child : Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.email, color: Color(0xffcd5e14)),
                Text('${data.orgEmail}', textAlign: TextAlign.center, style:TextStyle(fontFamily:'SF-Pro', color: Color(0xffcd5e14))),
              ]
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(Icons.phone, color: Color(0xffcd5e14)),
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child:Text('${data.orgPhoneNum}', textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro', color: Color(0xffcd5e14)),),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  //handle hero click
  void heroClick(BuildContext context, OrgData orgData){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context){
          return new Theme(
            data: Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.black,
              iconTheme: IconTheme.of(context).copyWith(
                color: Colors.white,
              ),
            ),
            child: new Builder(
              builder : (context) => Scaffold(
                appBar: AppBar(
                  title : Text(
                    'Profile Picture',
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      color:Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.black,
                ),
                body:Center(
                  child: Hero(
                    tag: 'org_profile_hero',
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: orgData.profileUrl == null ? Image.asset('assets/logo.png') : Image.memory(base64Decode(orgData.profileUrl)),
                    ),
                  ),
                ),
              ),
            )
          );
        }
      )
    );
  }

  //go to handle profile edit
  void goToOrgEdit(OrgData data){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context){
          return OrgProfileEdit(data: data);
        }
      )
    );
  }
}

