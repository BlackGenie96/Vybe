import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vybe_2/Models/PlaceItem.dart';
import 'package:vybe_2/Models/PlaceProfileItem.dart';

abstract class PlaceProfileAbstract{
  Future<List<PlaceItem>> fetchPlaceList();
  Future<PlaceProfileItem> fetchPlaceProfile(PlaceItem item);
  Future<Map<String, dynamic>> addRatingService(PlaceProfileItem item, rating);
}

class PlaceProfileService extends PlaceProfileAbstract{
  SharedPreferences prefs;
  final domain = "https://vybe-296303.uc.r.appspot.com";

  Future<List<PlaceItem>> fetchPlaceList() async{
    prefs = await SharedPreferences.getInstance();
    int catid = prefs.getInt("chosenCategory");

    final url = domain+"/flutter_api/Place/getPlaceName.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      'category_id' : catid
    };

    List<PlaceItem> res = [];
    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle response from the server
    if(response.statusCode == 200){
      print(response.body);
      List jsonResponse = json.decode(response.body);
      res = jsonResponse.map((item) => new PlaceItem.fromJson(item)).toList();
    }else{
      throw Exception("Failed to load place list from API.");
    }

    return res;
  }

  Future<PlaceProfileItem> fetchPlaceProfile(PlaceItem item) async{
    final url = domain+"/flutter_api/Place/getPlaceProfile.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String, dynamic> data = {
      'location_id' : item.placeId
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    if(response.statusCode == 200){
      print(response.body);
      Map<String, dynamic> jsonRes = json.decode(response.body);
      return PlaceProfileItem.fromJson(jsonRes);
    }else{
      throw Exception('Error getting place profile from API.');
    }
  }

  Future<Map<String,dynamic>> addRatingService(PlaceProfileItem item, rating) async{
    prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    final url = domain+"/flutter_api/Place/add_place_rating.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String, dynamic> data = {
      'user_id' : userId,
      'location_id' : item.placeId,
      'rating' : rating
    };

    http.Response response = await http.post(
        url,
        headers : headers,
        body: json.encode(data)
    );

    print(response.body);
    if(response.statusCode == 200){
      Map<String,dynamic> res = json.decode(response.body);
      return res;
    }else{
      throw Exception('error from add rating api.');
    }
  }
}