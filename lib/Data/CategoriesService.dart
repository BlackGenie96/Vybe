import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Category.dart';

abstract class CategoriesServiceAbstract{

  Future<String> retrieveFromPrefs();
  Future<List<Category>> fetchCategories(String parent);
  Future<String> updateCategory(Category category);
}

class CategoriesService extends CategoriesServiceAbstract{
  SharedPreferences prefs;
  final domain = "http://192.168.43.56:8080";

  Future<String> retrieveFromPrefs() async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('chosenCategory');
  }

  Future<List<Category>> fetchCategories(String parent) async{
    prefs = await SharedPreferences.getInstance();

    final url = domain+'/categories/$parent';
    Map<String, String> headers = {"Content-Type": "application/json"};

    final response = await http.get(
        url,
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200){
      if(response.body.contains('success')){
        throw Exception('Failed to load categories from API....');
      }else{
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((category) => new Category.fromJson(category)).toList();
      }
    }else{
      throw Exception('Failed to load categories from API.');
    }
  }

  //method to update the chosen category on the server.
  Future<String> updateCategory(Category category) async{
    prefs  = await SharedPreferences.getInstance();

    var userId = prefs.getString("userId");
    final url = domain+"/user/update/category/$userId";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "current_category" : category.catId
    };

    http.Response response = await http.post(
        url,
        headers : headers,
        body: json.encode(data)
    );

    //handle response from server
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var success = jsonResponse['success'];

    if(success == 1 || success == "1"){
      updatePrefs(category);
      return category.catId;
    }else{
      return "0";
    }
  }

  void updatePrefs(Category cat) async{
    prefs = await SharedPreferences.getInstance();

    prefs.setString('chosenCategory', cat.catId);
  }
}