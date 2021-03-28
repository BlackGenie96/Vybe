import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SuggestionsServiceAbstract{

  Future<Map<String,dynamic>> addSuggestion({String message});
}

class SuggestionsService extends SuggestionsServiceAbstract{

  final domain = "https://vybe-296303.uc.r.appspot.com";
  SharedPreferences prefs;

  Future<Map<String,dynamic>> addSuggestion({String message}) async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');

    final url = domain+"/flutter_api/suggestions/add_suggestion.php";

    Map<String,dynamic> res;
    Map<String,String> headers = {"Content-Type" : "application/json"};
    Map<String, dynamic> data = {
      'user_id' : id,
      'message' : message
    };

    await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    ).then((response){
      print(response.body);
      if(response.statusCode == 200){
        res = json.decode(response.body);
      }
    }).catchError((err) => throw new Exception(err.toString()));

    return res;
  }
}