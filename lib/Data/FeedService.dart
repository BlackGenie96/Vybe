import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vybe_2/Models/Comments.dart';
import 'package:vybe_2/Models/FeedData.dart';

abstract class FeedServiceAbstract{

  //functions for handling feed data
  Future<List<FeedData>> fetchEventFeed(int eventId);
  Future<List<FeedData>> fetchPlaceFeed(int locationId);
  Future<List<FeedData>> fetchFeed();
  Future<Map<String,dynamic>> likePost(FeedData item);

  //functions for handling feed item clicked.
  Future<int> getUserId();
  Future<String> getUserName();
  void likePostItemClicked(FeedData item);
  Future<List<Comment>> fetchComments(FeedData item);
  Future<FeedData> sendUserComment(FeedData item, String message);
  Future<FeedData> sendOrgComment(FeedData item, String message);

}

class FeedService extends FeedServiceAbstract{

  SharedPreferences prefs;
  final domain = "https://vybe-296303.uc.r.appspot.com";

  Future<List<FeedData>> fetchEventFeed(int eventId) async{
    final url = domain+"/flutter_api/feed/get_event_feed.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "event_id" : eventId
    };

    List<FeedData> res = [];

    await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    ).then((http.Response response){
      //handle response from json
      print(response.body);

      if(response.statusCode == 200){
        List jsonResponse = json.decode(response.body);
        res = jsonResponse.map((item) => new FeedData.fromJson(item)).toList();
      }else{
        throw Exception('Error retrieving event posts.');
      }
    }).catchError((error){
      throw Exception('Error fetching feed posts.');
    });

    return res;
  }

  Future<List<FeedData>> fetchPlaceFeed(int locationId) async{
    final url = domain+"/flutter_api/feed/get_place_feed.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "location_id" : locationId
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    List<FeedData> res = [];
    //handle response from json
    print(response.body);

    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      res = jsonResponse.map((item) => new FeedData.fromJson(item)).toList();
    }else{
      throw Exception('Error retrieving location posts.');
    }

    return res;
  }

  Future<List<FeedData>> fetchFeed() async{
    prefs = await SharedPreferences.getInstance();
    int catId = prefs.getInt("chosenCategory");
    final url = domain+"/flutter_api/feed/getPosts.php";

    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "posts": 1,
      "category_id": catId
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    List<FeedData> res = [];
    print(response.body);
    //handle response from the server
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      for(var i=0; i < jsonResponse.length; i++){
        print(jsonResponse[i]);
      }
      res = jsonResponse.map((item) => new FeedData.fromJson(item)).toList();
    }else{
      throw Exception('Error getting data from api');
    }

    return res;
  }

  Future<Map<String,dynamic>> likePost(FeedData item) async{

    prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("userId");
    final url = domain+"/flutter_api/feed/addUserLike.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      'post_id' : item.postId,
      'user_id' : userId,
      'tags' : item.tag
    };

    Map<String,dynamic> res;

    await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    ).then((response){
      //handle json response from api.
      print(response.body);
      if(response.statusCode == 200){
        res = json.decode(response.body);
      }else{
        //there was an error return from the server
        throw Exception("Error in liking post in server.");
      }
    }).catchError((error){
      print("ERROR 1: "+error);
    });

    return res;
  }

  Future<int> getUserId() async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<String> getUserName() async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  Future<List<Comment>> fetchComments(FeedData item) async{
    final url = domain+"/flutter_api/feed/getPostComments.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      'post_id' : item.postId,
      'comments' : 1
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    List<Comment> res = [];
    print(jsonDecode(response.body));
    //handle response from server
    if(response.statusCode == 200){
      List jsonResponse = jsonDecode(response.body);
      res = jsonResponse.map((item) => new Comment.fromJson(item)).toList();
    }else{
      throw Exception('Failed to load comments from the API');
    }

    return res;
  }

  Future<FeedData> likePostItemClicked(FeedData item) async{

    prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt("userId");

    final url = domain+"/flutter_api/feed/addUserLike.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      'post_id' : item.postId,
      'user_id' : userId,
      'tags' : item.tag
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle json response from api.
    print(response.body);

    if(response.statusCode == 200){
      var son = json.decode(response.body);
      var success = son['success'];
      var message = son['message'];

      if(success == 1){
        //like has been added. increment the number of likes.
        item.likes = item.likes + 1;
      }else if(success == 2){
        //like has been removed successfully. Decrement the number of likes by 1.
        item.likes = item.likes - 1;
      }
    }else{
      throw Exception('Could not like post in server.');
    }

    return item;
  }

  Future<FeedData> sendUserComment(FeedData item, String message) async{
    prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');

    final url = domain+"/flutter_api/feed/addUserComment.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "user_id" : userId,
      "post_id" : item.postId,
      "comment_message" : message,
      "tags" : item.tag
    };

    http.Response response = await http.post(
        url,
        headers : headers,
        body: json.encode(data)
    );

    //handle response from api.
    print(response.body);

    if(response.statusCode == 200){
      var jsonResponse = json.decode(response.body);
      final success = jsonResponse["success"];

      if(success == 1){
        print(message);
        item.comments = item.comments + 1;
      }else {
        print(message);
      }
    }

    return item;
  }

  Future<FeedData> sendOrgComment(FeedData item, String message) async{
    prefs = await SharedPreferences.getInstance();
    int orgId = prefs.getInt('orgId');

    final url = domain+"/flutter_api/feed/addOrgComment.php?org_id=$orgId&post_id=${item.postId}&comment_message=$message&tags=${item.tag}";
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      'org_id' : orgId,
      'post_id' : item.postId,
      'comment_message' : message,
      'tags' : item.tag
    };

    http.Response response = await http.post(
        url,
        headers : headers,
        body: json.encode(data)
    );

    //handle response from api.
    print(response.body);

    if(response.statusCode == 200){
      var jsonResponse = json.decode(response.body);
      final success = jsonResponse["success"];
      final message = jsonResponse["message"];

      if(success == 1){
        print(message);
        item.comments = item.comments + 1;
      }else{
        print(message);
      }
    }else{
      throw Exception('Could not send comment to server.');
    }

    return item;
  }
}