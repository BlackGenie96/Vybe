import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vybe_2/Models/Category.dart';

abstract class LocationServiceAbstract{

  Future<Map<String,dynamic>> getPlaceLocation(String locationId);
  //Future<List<Category>> fetchCategories();
  Future<Map<String,dynamic>> updatePlace(Map<String,dynamic> data);
  Future<Map<String,dynamic>> createPlace(Map<String,dynamic> data);
}

class LocationService extends LocationServiceAbstract{
  final domain = "http://192.168.43.56:8080";
  SharedPreferences prefs;

  Future<Map<String,dynamic>> getPlaceLocation(String locationId) async{
    final url = domain+"/business/profile/$locationId";
    final Map<String,String> headers = {"Content-Type": "application/json"};

    Map<String,dynamic> res;
    http.Response response = await http.get(
        url,
        headers: headers
    );

    //handle response
    print(response.body);
    try{

      if(response.statusCode == 200){
        res = json.decode(response.body);
      }else{
        throw Exception('Could not get location information');
      }
    }catch(err){
      print(err);
    }
    return res;
  }

  /*Future<List<Category>> fetchCategories() async{
    final url = domain+"/flutter_api/Category/getCategories.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      "categories" : '1',
      "user_id" : null
    };
    http.Response response = await http.post(
        url,
        headers: headers,
      body: json.encode(data)
    ).catchError((err) => print(err.toString()));

    print(response.body);

    List<Category> list = [];
    if(response.statusCode == 200){
       List jsonResponse = json.decode(response.body);
       list = jsonResponse.map((item) => Category.fromJson(item)).toList();
    }else{
      throw Exception('Error from api getting Categories');
    }

    return list;
  }*/

  Future<Map<String,dynamic>> updatePlace(Map<String,dynamic> data) async{

    prefs = await SharedPreferences.getInstance();
    var orgId = prefs.getString("orgId");
    data["created_by"] = orgId;

    final url = domain+"/business/update/profile/${data['created_by']}";
    Map<String,String> headers = {"Content-Type":"application/json"};


    Map<String,dynamic> jsonRes;
    await http.put(
        url,
        headers: headers,
        body: json.encode(data)
    ).then((response){
      print(response.body);
      if(response.statusCode == 200){
        jsonRes = json.decode(response.body);
      }
    }).catchError((error){
      print(error.toString());
    });

    return jsonRes;
  }

  Future<Map<String,dynamic>> createPlace(Map<String,dynamic> data) async{

    prefs = await SharedPreferences.getInstance();
    var orgId = prefs.getString("orgId");
    data["created_by"] = orgId;
    final url = domain+"/business/create";

    Map<String,dynamic> jsonRes;
    Map<String,String> headers = {"Content-Type":"application/json"};

    await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    ).then((response){
      print(response.body);

      if(response.statusCode == 200 || response.statusCode == 400){
        jsonRes = json.decode(response.body);
      }
    }).catchError((error){
      print(error.toString());
    });

    return jsonRes;
  }

}