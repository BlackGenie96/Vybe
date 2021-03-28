import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vybe_2/Data/UserProfileService.dart';
import 'package:vybe_2/Models/UserData.dart';
import 'package:vybe_2/Views/UserProfile/UserProfileEdit.dart';


class UserProfile extends StatefulWidget{
  @override
  _UserProfileState createState() => new _UserProfileState();
}

class _UserProfileState extends State<UserProfile>{

  UserProfileService service = new UserProfileService();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        accentColor: Colors.white,
      ),
      child: new Builder(
        builder: (context) => new Scaffold(
          appBar: AppBar(
            title: Text('Profile', style: TextStyle(fontFamily: 'SF-Pro',color: Colors.white)),
            backgroundColor: Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            ),
            actions: <Widget>[
              GestureDetector(
                onTap:(){
                  service.getUserProfile().then((info) => goToProfileEdit(info));
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child:FutureBuilder<UserData>(
                    future: service.getUserProfile(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        UserData data = snapshot.data;
                        if(data == null){
                          return Center(child:Text('UserData is null, handle by reloading data from server.'));
                        }else{
                          return _buildBody(data: data);
                        }
                      }else if(snapshot.hasError){
                        return Center(child: Text('${snapshot.error}'));
                      }

                      return Center(child:CircularProgressIndicator(backgroundColor: Color(0xff301370)));
                    }
                ),
              ),
            )
          ),
        ),
      ),
    );
  }

  void goToProfileEdit(UserData data){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context){
          return UserProfileEdit(data:data);
        }
      ),
    );
  }

  Widget _buildBody({UserData data}){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(
              top: 15,
            ),
            child: GestureDetector(
              onTap:() => _goToProfilePic(context:context, data:data),
              child:Hero(
                tag: 'user_profile_hero',
                child: CircleAvatar(
                    backgroundImage: data.profile == null ? AssetImage('assets/logo.png') : MemoryImage(base64Decode(data.profile))
                ),
              ),
            ),
            width: 140,
            height: 140,
          ),
          Container(
            margin:const EdgeInsets.only(top:12,bottom: 12),
            child: Text(
              "${data.username}",
              textAlign: TextAlign.center,
              style:TextStyle(
                fontFamily:'SF-Pro',
                color: Color(0xffcd5e14),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8,bottom: 12),
            child: Text(
              "${data.surname}",
              textAlign: TextAlign.center,
              style:TextStyle(
                fontFamily:'SF-Pro',
                color: Color(0xffcd5e14),
                fontSize: 18,
                fontWeight:FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 20,),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(Icons.email, color: Color(0xffcd5e14)),
                  Text('${data.email}', textAlign: TextAlign.center, style:TextStyle(fontFamily:'SF-Pro', color: Color(0xffcd5e14))),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 12,),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Icon(Icons.phone, color: Color(0xffcd5e14)),
                  Padding(
                    padding: const EdgeInsets.only(left:20),
                    child:Text('${data.phone}', textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro', color: Color(0xffcd5e14)),),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  //handle hero image click
  void _goToProfilePic({BuildContext context, UserData data}){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) => Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.black,
            primaryColor:Colors.white,
            accentColor: Colors.white,
          ),
          child: new Builder(
            builder: (context) => new Scaffold(
              appBar: AppBar(
                title: Text('Profile Picture',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white)),
                backgroundColor:Colors.black,
                iconTheme : IconTheme.of(context).copyWith(
                  color: Colors.white,
                )
              ),
              body: Center(
                child: Hero(
                  tag: 'user_profile_hero',
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child : data.profile == null ? Image.asset('assets/logo.png') : Image.memory(base64Decode(data.profile))
                  ),
                )
              ),
            ),
          )
        ),
      ),
    );
  }
}