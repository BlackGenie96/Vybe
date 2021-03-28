import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController{

  SharedPreferences prefs;

  SettingsController(){}

  checkIfEmpty() async{
    prefs = await SharedPreferences.getInstance();
    bool res = prefs.getBool("tutorial");
    if(res == null || res == false){
      prefs.setBool("tutorial",true);
    }

    bool not = prefs.getBool("location_notification");
    if(not == null || not == false){
      prefs.setBool("location_notification", true);
    }
  }

  ///turn on tutorial
  Future turnOnTutorial() async{
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("tutorial",true);
  }

  ///turn off tutorial
  Future turnOffTutorial() async{
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("tutorial", false);
  }

  ///get tutorial setting
  Future<bool> getTutorialValue() async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool("tutorial");
  }

  ///notification setting for locations for liked places
  void turnOnLocationNotification() async{
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("location_notification", true);
  }

  ///turn off notification setting
  void turnOffLocationNotification() async{
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("location_notification", false);
  }

  Future<bool> getLocationNotificationValue() async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool("location_notification");
  }
}