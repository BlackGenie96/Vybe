import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vybe_2/Models/CalendarItemData.dart';

abstract class CalendarServiceAbstract{
  Future<List<CalendarItemData>> fetchCalendarItems();
}

class CalendarService extends CalendarServiceAbstract{

  SharedPreferences prefs;
  var domain = "http://192.168.43.56:8080";

  Future<List<CalendarItemData>> fetchCalendarItems() async{
    prefs = await SharedPreferences.getInstance();
    var chosenCategory = prefs.getString('chosenCategory');

    final url = domain+"/event/calendar/$chosenCategory";
    Map<String,String> headers = {"Content-Type":"application/json"};

    http.Response response = await http.get(
        url,
        headers: headers
    );

    print(response.body);

    List<CalendarItemData> res = [];
    //handle response from the server
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      res = jsonResponse.map((item) => CalendarItemData.fromJson(item)).toList();
    }else{
      Map<String,dynamic> res = json.decode(response.body);
      print(res['message']);
    }

    return res;
  }

  Future<bool> tutorialState() async{
    prefs = await SharedPreferences.getInstance();
    var current = prefs.getBool('calendarTutorial');
    var result;

    if(current == null){
      prefs.setBool('calendarTutorial', true);
      result = true;
    }else{
      if(current == true){
        prefs.setBool('calendarTutorial', false);
        result = false;
      }
    }

    return result;
  }
}