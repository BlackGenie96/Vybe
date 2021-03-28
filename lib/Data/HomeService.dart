import 'package:shared_preferences/shared_preferences.dart';

abstract class HomeServiceAbstract{
  Future<bool> getOrganizerLoginState();
  Future<String> tutorialState();
}

class HomeService extends HomeServiceAbstract{
  SharedPreferences prefs;

  Future<bool> getOrganizerLoginState() async{
    prefs = await SharedPreferences.getInstance();

    return prefs.getBool('orgLogged');
  }

  Future<String> tutorialState() async{
    prefs = await SharedPreferences.getInstance();

    var current = prefs.getString('showTutorial');
    var result;

    if(current == null){
      //show tutorial and set prefs to first indicating this is the first time the tutorial is running
      prefs.setString('showTutorial',"first");
      result = "first";
    }else{
      if(current == "first"){
        //tutorial has been shown once. set it to false
        prefs.setString('showTutorial', "first ended");
        result = "first ended";
      }else if(current == "first ended"){

        //this is from the settings activity. first ended is telling the system that this time tutorial was invoked from settings
        prefs.setString('showTutorial', "settings");
        result = "settings";
      }else if(current == "settings"){
        //this is indicating that the settings invoked tutorial has to end now.
        prefs.setString('showTutorial', "settings ended");
        result = "settings ended";
      }else if(current == "settings ended"){
        prefs.setString('showTutorial', "settings");
        result = "settings";
      }
    }

    return result;
  }




}