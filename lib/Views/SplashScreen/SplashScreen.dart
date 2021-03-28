import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vybe_2/Views/logging/Login.dart';
import 'package:vybe_2/Views/Navigation/Navigation.dart';
import 'package:vybe_2/Views/settings/controller.dart';

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  //shared preferences singleton instance
  SharedPreferences sharedPreferences;

  @override
  void initState(){
    super.initState();

    var set = new SettingsController();

    Timer(Duration(seconds:5),(){
      //check for login details
      set.checkIfEmpty();
      checkLogin();
      print("Go to the next screen");

    });
  }

  @override
  Widget build(BuildContext context){
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Color(0xff301370),
      ),
      child: new Builder(
        builder : (context) => Scaffold(
          body: SafeArea(
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                width: 160,
                height: 160,
              ),
            ),
          ),
        )
      ),
    );
  }

  //function to check if user had logged in before
  checkLogin() async{

    sharedPreferences = await SharedPreferences.getInstance();

    if(sharedPreferences.getBool('loggedIn') == true && sharedPreferences.getBool('loggedIn') != null){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context){
            return new MaterialApp(
              home: Navigation(),
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                accentColor: Colors.white,
                primaryColor: Color(0xff301370),
              ),
            );
          }
        )
      );
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context){
            return new MaterialApp(
              home: Login(),
              theme: ThemeData(
                accentColor: Colors.white,
                scaffoldBackgroundColor: Color(0xff301370),
                primaryColor: Colors.white,
              ),
            );
          }
        )
      );
    }
  }
}