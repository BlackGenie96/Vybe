import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vybe_2/Models/Event.dart';
import 'package:vybe_2/Models/EventItem.dart';
import 'package:vybe_2/Models/TicketPrice.dart';
import 'package:vybe_2/Models/TicketSalesPoints.dart';

abstract class EventProfileAbstract{

  Future<List<EventItem>> eventList();
  Future<Event> getEventInformation(EventItem item);
  Future<Map<String,dynamic>> addRatingService(Event item, int rating);
  //Future<TicketPrice> getPricesFromAPI(EventItem item);
  //Future<List<TicketSalesPoints>> getSalesPointsFromAPI(EventItem item);
}

class EventProfileService extends EventProfileAbstract{
  SharedPreferences prefs;
  final domain = "http://192.168.43.56:8080";

  Future<List<EventItem>> eventList() async{
    prefs = await SharedPreferences.getInstance();
    var _categoryId = prefs.getString("chosenCategory");

    final url = domain+"/event/list/$_categoryId}";
    Map<String,String> headers = {"Content-Type":"application/json"};

    http.Response response = await http.get(
        url,
        headers: headers
    );

    //handle response
    print(json.decode(response.body));
    List<EventItem> res = [];
    if(response.statusCode == 200){
      List jsonResponse = jsonDecode(response.body);
      res = jsonResponse.map((item) => new EventItem.fromJson(item)).toList();
    }else{
      throw Exception('Failed to load event items API.');
    }

    return res;
  }

  Future<Event> getEventInformation(EventItem item) async{
    prefs = await SharedPreferences.getInstance();
    var managerId = prefs.getString("orgId");

    final url = domain+"/event/profile";
    Map<String, String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "event_id" : item.eventId,
      "manager_id" : managerId
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    //handle json response from the server
    if(response.statusCode == 200){
      Map<String,dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse);
      /*return new Event(
          eventId : jsonResponse['_id'],
          eventName: jsonResponse['name'],
          eventPoster: jsonResponse['poster'],
          eventDate : jsonResponse['date'],
          eventTime : jsonResponse['time'],
          maxAllowed : jsonResponse['max_allowed'],
          theme : jsonResponse['theme'],
          orgId : jsonResponse['manager']['_id'],
          orgName: jsonResponse['manager']['name'],
          orgEmail: jsonResponse['manager']['email'],
          orgPhone: jsonResponse['manager']['phone'],
          salesPoints: jsonResponse['sales_points'],
          rating : jsonResponse['rating'],
          eventAbout: jsonResponse["about"]
      );*/
      //return jsonResponse.map((event) => new Event.fromJson(event));

      return new Event.fromJson(jsonResponse);
    }else{
      throw Exception('Failed to load event information from the server.');
    }
  }

  Future<Map<String,dynamic>> addRatingService(Event item, int rating) async{
    prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    final url = domain+"/event/rate/${item.eventId}/$rating/$userId";
    Map<String,String> headers = {"Content-Type":"application/json"};

    http.Response response = await http.put(
        url,
        headers : headers
    );

    Map<String,dynamic> res;
    print(response.body);
    if(response.statusCode == 200){
      res = json.decode(response.body);
    }else{
      throw Exception('error from add rating api.');
    }

    return res;
  }

  /*Future<TicketPrice> getPricesFromAPI(EventItem item) async{
    prefs = await SharedPreferences.getInstance();
    var catId = prefs.getInt("chosenCategory");
    final url = domain+"/flutter_api/Event/getEventPrices.php";

    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "event_id": item.eventId,
      "event_category_id" : catId
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle json response from the API
    if(response.statusCode == 200){
      print(response.body);
      final jsonResponse = json.decode(response.body);

      return TicketPrice.fromJson(jsonResponse);
    }else{
      throw Exception('Failed to load data from the server API.');
    }
  }*/

  /*Future<List<TicketSalesPoints>> getSalesPointsFromAPI(EventItem item) async{
    prefs = await SharedPreferences.getInstance();
    var catId = prefs.getInt("chosenCategory");

    final url = domain+"/flutter_api/Event/getEventSalesPoints.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "category_id" : catId,
      "event_id" : item.eventId
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    List<TicketSalesPoints> res = [];
    print(response.body);
    //handle response from the server
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      res = jsonResponse.map((item) => TicketSalesPoints.fromJson(item)).toList();
    }else{
      throw Exception('Failed to load data from the server API.');
    }

    return res;
  }*/

  Future<bool> tutorialState() async{
    prefs = await SharedPreferences.getInstance();

    var current = prefs.getBool('eventProfileTutorial');
    var result;

    if(current == null){
      prefs.setBool('eventProfileTutorial', true);
      result = true;
    }else{
      if(current == true){
        prefs.setBool('eventProfileTutorial', false);
        result = false;
      }
    }

    return result;
  }
}