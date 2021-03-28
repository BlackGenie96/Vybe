import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vybe_2/Models/EventItem.dart';
import 'package:vybe_2/Models/FeedData.dart';
import 'package:vybe_2/Models/OrgData.dart';
import 'package:vybe_2/Models/OrganizerNotification.dart';
import 'package:vybe_2/Models/PlaceItem.dart';

abstract class OrgLoggingAbstract{

  Future<Map<String,dynamic>> organizerLogin(String email, String password);
  Future<OrgData> getUserId();
  Future<int> registerRequest(String name, String surname, String email, String phone, String password, String confirm);
  void saveToPreferences(int id, String name, String surname, String email, String phoneNum);
  Future<int> getOrgId();
  Future<List<OrgNotItem>> getNotifications();
  Future<FeedData> getEvent(OrgNotItem item);
  Future<Map<String,dynamic>> updateProfileInfo(Map<String,dynamic> data);
  Future<int> getDays();

  //function for management list
  Future<Map<String,dynamic>> getOrg();
  Future<List<EventItem>> getOrgEventsCreated();
  Future<List<PlaceItem>> getOrgPlacesCreated();
  Future<Map<String,dynamic>> deleteEventService(EventItem item);
  Future<Map<String,dynamic>> deletePlaceService(PlaceItem item);
  Future<OrgData> getOrganizerProfile();
}

class OrganizerProfileService extends OrgLoggingAbstract{
  SharedPreferences prefs;
  final domain = "https://vybe-296303.uc.r.appspot.com";

  Future<Map<String,dynamic>> organizerLogin(String email, String password) async{

    //url to web api
    final url = domain+"/flutter_api/Authentication/login.php";

    //headers
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      'org_email' : email,
      'org_password' : password
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    Map<String, dynamic> jsonResponse;

    ///handle response from the server
    if(response.statusCode == 200){
      print(response.body);
      jsonResponse = json.decode(response.body);
      var success = jsonResponse['success'];

      if(success == 1){
        //save this data in sharedPreferences
        saveToPreferences(int.parse(jsonResponse['orgId']), jsonResponse['orgName'], jsonResponse['orgSurname'], jsonResponse['orgEmail'], jsonResponse['orgPhone']);
      }
    }else{
      throw Exception('Error logging in for the organizer.');
    }

    return jsonResponse;
  }

  Future<int> registerRequest(String name, String surname, String email, String phone, String password, String confirm) async{

    int obj;
    if(password != confirm){
      print('Passwords do not match');
      return obj = 0;//"Passwords do not match";
    }

    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      'org_name' : name,
      'org_surname' : surname,
      'org_email' : email,
      'org_phone_num': phone,
      'org_password': password
    };

    final url = domain+"/flutter_api/Registration/register_organizer.php";
    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    print(response.body);

    //response from the server
    Map<String, dynamic> res = jsonDecode(response.body);
    var _success = res['success'];
    var _message = res['message'];

    if(_success == 1){
      //Toast.show(_message, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      int id = int.parse(res['orgId']);
      String name = res['orgName'];
      String surname = res['orgSurname'];
      String email = res['orgEmail'];
      String phone = res['orgPhoneNum'];

      //save organizer details in shared preferences
      saveToPreferences(id,name,surname,email,phone);
      obj = 1;//_message;
      //go to organizer menu
    }else{
      print(_message);
      obj = 2;
    }

    return obj;
  }

  Future logout() async{
    prefs = await SharedPreferences.getInstance();

    prefs.setBool('orgLogged', false);
    prefs.remove('orgId');
    prefs.remove('orgName');
    prefs.remove('orgSurname');
    prefs.remove('orgEmail');
    prefs.remove('orgPhoneNum');
  }

  void saveToPreferences(int id, String name, String surname, String email, String phoneNum) async{
    prefs = await SharedPreferences.getInstance();

    prefs.setBool('orgLogged', true);
    prefs.setInt('orgId', id);
    prefs.setString('orgName', name);
    prefs.setString('orgSurname', surname);
    prefs.setString('orgEmail', email);
    prefs.setString('orgPhoneNum', phoneNum);
  }

  Future<OrgData> getUserId() async{
    prefs = await SharedPreferences.getInstance();

    var orgId = prefs.getInt('orgId');
    var orgName = prefs.getString('orgName');
    var orgSurname = prefs.getString('orgSurname');
    var orgEmail = prefs.getString('orgEmail');
    var orgPhone = prefs.getString('orgPhoneNum');
    var orgProfileUrl = prefs.getString('orgProfileUrl');

    return new OrgData(id: orgId, orgName : orgName, orgSurname : orgSurname, orgEmail: orgEmail, orgPhoneNum : orgPhone,profileUrl: orgProfileUrl);
  }

  Future<int> getOrgId() async{
    prefs =  await SharedPreferences.getInstance();
    return prefs.getInt('orgId');
  }

  Future<List<OrgNotItem>> getNotifications() async{
    prefs = await SharedPreferences.getInstance();
    int orgId = prefs.getInt('orgId');

    final url = domain+"/flutter_api/Notifications/getOrgNotifications.php";
    Map<String,String> headers = {"Content-Type" : "application/json"};
    Map<String,dynamic> data = {
      'orgId' : orgId
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle response
    print(response.body);
    List<OrgNotItem> result = [];
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      result = jsonResponse.map((item) => OrgNotItem.fromJson(item)).toList();
    }else{
      throw Exception("Error from server api response");
    }

    return result;
  }

  Future<FeedData> getEvent(OrgNotItem item) async{
    prefs = await SharedPreferences.getInstance();
    int orgId = prefs.getInt('orgId');

    final url = domain+"/flutter_api/feed/getPosts.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      'post_id' : item.entityId,
      'event_id' : item.eventId,
      'place_id' : item.locationId,
      'org_id' : orgId,
      'notification_id': item.notId
    };

    http.Response response = await http.post(
        url,
        headers : headers,
        body: json.encode(data)
    );

    print(response.body);
    //handle response from json
    if(response.statusCode == 200){
      Map<String, dynamic> result = json.decode(response.body);
      return FeedData.fromJson(result);
    }else{
      throw Exception("Error from API in serve.");
    }
  }

  Future<Map<String,dynamic>> updateProfileInfo(Map<String,dynamic> data) async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('orgId');
    data['orgId'] = id;

    final url = domain+"/flutter_api/Registration/register_organizer.php";
    Map<String, String> headers = {"Content-Type": "application/json"};

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle response from api.
    print(response.body);

    if(response.statusCode == 200){
      Map<String,dynamic> res = json.decode(response.body);
      if(res["success"] == 1 || res["success"] == "1"){
        //save new values in shared preferences.
        prefs.setString("orgName", res["name"]);
        prefs.setString("orgSurname", res["surname"]);
        prefs.setString("orgEmail", res["email"]);
        prefs.setString("orgPhone", res["phoneNum"].toString());
      }else{
        print(res["message"]);
      }

      return res;
    }else{
      throw Exception('Error updating organizer profile.');
    }

  }

  Future<int> getDays() async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('orgId');

    final url = domain+"/flutter_api/payments/get_remaining_days.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      'orgId' : id
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    print(response.body);
    if(response.statusCode == 200){
      Map<String,dynamic> res = json.decode(response.body);
      var days = res["days_left"];

      if(days == null){
        return 0;
      }

      return int.parse(days.toString());
    }else{
      throw Exception('Error getting payments.');
    }
  }

  Future<Map<String,dynamic>> getOrg() async{

    prefs = await SharedPreferences.getInstance();
    int orgId = prefs.getInt('orgId');
    String orgName = prefs.getString('orgName');
    String orgSurname = prefs.getString('orgSurname');

    Map<String,dynamic> orgData = {
      "orgId" : orgId,
      "orgName" : orgName,
      "orgSurname" : orgSurname
    };

    return orgData;

  }

  Future<List<EventItem>> getOrgEventsCreated() async{
    prefs = await SharedPreferences.getInstance();
    int orgId = prefs.getInt("orgId");

    final url = domain+"/flutter_api/Event/getCreatedEvents.php";
    Map<String,String> headers = {"Content-Type" : "application/json"};
    Map<String, dynamic> data = {
      'orgId' : orgId
    };

    http.Response response = await http.post(
        url,
        headers : headers,
        body: json.encode(data)
    );

    //handle response.
    print(response.body);
    List<EventItem> res = [];

    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      res = jsonResponse.map((json) => EventItem.fromJson(json)).toList();
    }else{
      throw Exception('Error getting events from server.');
    }

    return res;
  }

  Future<List<PlaceItem>> getOrgPlacesCreated() async{
    prefs = await SharedPreferences.getInstance();
    int orgId = prefs.getInt("orgId");

    final url = domain+"/flutter_api/Place/getCreatedPlaces.php";
    Map<String,String> headers = {"Content-Type" : "application/json"};
    Map<String,dynamic> data = {
      'orgId': orgId
    };

    http.Response response = await http.post(
        url,
        headers : headers,
        body: json.encode(data)
    );

    //handle response.
    print(response.body);
    List<PlaceItem> res = [];
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      res = jsonResponse.map((json) => PlaceItem.fromJson(json)).toList();
    }else{
      throw Exception('error with get places created api.');
    }

    return res;
  }

  Future<Map<String,dynamic>> deleteEventService(EventItem item) async{

    final url = domain+"/flutter_api/Event/delete_event.php";
    final Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      'event_id' : item.eventId
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle response from api
    print(response.body);
    Map<String,dynamic> res;
    try{
      if(response.statusCode == 200){
        res = json.decode(response.body);
      }else{
        throw Exception('Error deleting event from server.');
      }
    }catch(err){
      print(err);
    }

    return res;
  }

  Future<Map<String,dynamic>> deletePlaceService(PlaceItem item) async {

    final url = domain+"/flutter_api/Place/delete_place.php";
    final Map<String,String> headers = {"Content-Type" : "application/json"};
    Map<String,dynamic> data = {
      'place_id' : item.placeId
    };

    http.Response response = await http.post(
        url,
        headers : headers,
        body: json.encode(data)
    );

    Map<String,dynamic> res;
    try{
      if(response.statusCode == 200){
        print(response.body);
        res = json.decode(response.body);
      }else{
        throw Exception('Error deleting place information.');
      }
    }catch(err){
      print(err);
    }

    return res;
  }

  Future<OrgData> getOrganizerProfile() async{
    prefs = await SharedPreferences.getInstance();
    var orgId = prefs.getInt('orgId');

    final url = domain+"/flutter_api/Profile/getOrgProfile.php";
    final Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "organizer_id" : orgId
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    print(response.body);

    if(response.statusCode == 200){
      var result = json.decode(response.body);

      return new OrgData(id: orgId, orgName: result['orgName'], orgSurname: result['orgSurname'],orgEmail: result['orgEmail'],orgPhoneNum: result['orgPhoneNum'],profileUrl: result['orgProfilePic']);
    }else{
      throw Exception('Error getting Manager profile.');
    }
  }

}