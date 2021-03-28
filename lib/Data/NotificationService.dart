import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vybe_2/Models/FeedData.dart';
import 'package:vybe_2/Models/Notify.dart';

abstract class NotificationAbstract{

  Future<List<Notify>> getNotifications();
  Future<FeedData> getPost(Notify item);
}

class NotificationService extends NotificationAbstract{

  SharedPreferences prefs;
  final domain = "https://vybe-296303.uc.r.appspot.com";

  Future<List<Notify>> getNotifications() async{
    prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId');

    final url = domain+"/flutter_api/Notifications/getNotifications.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      'userId': userId
    };

    http.Response response = await http.post(
        url,
        headers : headers,
        body: json.encode(data)
    );

    List<Notify> result = [];

    //handle response from api
    if(response.statusCode == 200){
      print(response.body);
      List jsonResponse = json.decode(response.body);
      result = jsonResponse.map((item) => Notify.fromJson(item)).toList();
    }else{
      throw Exception("Error retrieving notifications from the server.");
    }

    return result;
  }

  Future<FeedData> getPost(Notify item) async{
    prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId');

    final url = domain+"/flutter_api/feed/getPosts.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      'userId' : userId,
      'postId' : item.entityId,
      'notification_id' : item.notId
    };

    http.Response response = await http.post(
        url,
        headers : headers,
        body: json.encode(data)
    );

    //handle response from server
    print(response.body);

    if(response.statusCode == 200){
      Map<String, dynamic> result = json.decode(response.body);
      return new FeedData.fromJson(result);
    }else{
      throw Exception('Error getting post from server.');
    }
  }
}