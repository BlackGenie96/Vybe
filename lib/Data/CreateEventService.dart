import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vybe_2/Models/Category.dart';
import 'package:vybe_2/Models/LocationInformation.dart';
import 'package:vybe_2/Models/PlaceItem.dart';

abstract class CreateEventServiceAbstract{
  Future<Map<String,dynamic>> getEventInformation(String eventId);
  Future<String> getOrganizerName();
  Future<List<Category>> fetchCategories(String parent);
  //<List<PlaceItem>> placeList(Category categoryData);

  Future<Map<String,dynamic>> createEvent(Map<String,dynamic> data);
  Future<void> updateEvent(Map<String,dynamic> data);
}

class CreateEventService extends CreateEventServiceAbstract{
  SharedPreferences prefs;
  var domain = "http://192.168.43.56:8080";

  Future<Map<String,dynamic>> getEventInformation(String eventId) async{
    prefs = await SharedPreferences.getInstance();
    final orgId = prefs.getString('orgId');

    final url = domain+"/profile";
    final Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> res;
    Map<String, dynamic> data = {
      "event_id" : eventId,
      "manager_id" : orgId
    };

    await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    ).then((http.Response response) {
      print(response.body);
      if (response.statusCode == 200) {
        res = json.decode(response.body);
      } else {
        print(json.decode(response.body));
        throw Exception('Error getting event information from server.');
      }
    }).catchError((error){
      throw Exception(error);
    });

    return res;
  }

  Future<String> getOrganizerName() async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('orgName');
  }

  Future<List<Category>> fetchCategories(String parent) async{
    final url = domain+"/categories/$parent";
    Map<String, String> headers = {"Content-Type": "application/json"};
    final response = await http.get(
        url,
        headers: headers
    );

    print(response.body);
    List<Category> res = [];
    if(response.statusCode == 200){
      if(response.body.contains('success')){
        throw Exception('Failed to load categories from API....');
      }else{
        List jsonResponse = jsonDecode(response.body);
        res = jsonResponse.map((category) => new Category.fromJson(category)).toList();
      }
    }else{
      throw Exception('Failed to load categories from API.');
    }

    return res;
  }

  /*Future<List<PlaceItem>> placeList(Category categoryData) async{
    final url = domain+"/flutter_api/Place/getPlaceName.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "category_id" : categoryData.catId
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    List<PlaceItem> res = [];

    print(response.body);
    //handle json response
    if(response.statusCode == 200){
      List jsonResponse = jsonDecode(response.body);
      res = jsonResponse.map((item)=> PlaceItem.fromJson(item)).toList();
    }else{
      throw Exception('Failed to load place items from API');
    }

    return res;
  }*/

  Future<Map<String,dynamic>> createEvent(Map<String,dynamic> data) async{

    //get organizer id from shared preferences instance
    prefs = await SharedPreferences.getInstance();
    String orgId = prefs.getString('orgId');
    data["manager"] = orgId;

    final url = domain+"/event/create";
    Map<String,String> headers = {"Content-Type":"application/json"};

    Map<String,dynamic> res;

    await http.post(
      url,
      headers: headers,
      body: json.encode(data),
    ).then((response){
      //handle response from API call
      print(response.body);
      if(response.statusCode == 200){
        res = json.decode(response.body);
      }else if(response.statusCode == 400){
          res = json.decode(response.body);
      }else if(response.statusCode == 404){
        res = json.decode(response.body);
      }
    }).catchError((err){
      print(err.toString());
    });

    return res;
  }

  Future<Map<String,dynamic>> updateEvent(Map<String,dynamic> data) async{
    prefs = await SharedPreferences.getInstance();
    final orgId = prefs.getInt('orgId');
    data["manager"] = orgId;

    final url = domain+"/event/update/${data['_id']}";
    final Map<String,String> headers = {"Content-Type":"application/json"};
    http.Response response = await http.post(
        url,
        headers : headers,
        body: json.encode(data)
    );

    //handle response from api.
    print(response.body);
    Map<String,dynamic> res;
    if(response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404){
      res = json.decode(response.body);
    }else{
      throw Exception('Error updating the event.');
    }

    return res;
  }

  /*Future<List<LocationInformation>> search(String search) async{
    await Future.delayed(Duration(seconds: 2));

    if(search == 'empty') return [];

    final url = domain+"/flutter_api/Place/searchForLocation.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "search_text" : search
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle response from API
    List<LocationInformation> res = [];
    if(response.statusCode == 200){
      //decode json response
      print(response.body);
      List jsonResponse = json.decode(response.body);
      res = jsonResponse.map((loc) => LocationInformation.fromJson(loc)).toList();
    }else{
      throw Exception('Error in response');
    }

    return res;
  }*/

}