import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vybe_2/Models/SearchItem.dart';

abstract class MainSearchServiceAbstract{

  Future<List<SearchItem>> search(String search);
}

class MainSearchService extends MainSearchServiceAbstract{

  final domain = "https://vybe-296303.uc.r.appspot.com";
  SharedPreferences prefs;

  Future<List<SearchItem>> search(String search) async{

    final url = domain+"/flutter_api/main_search.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      "text" : search
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    List<SearchItem> res = [];
    //handle response from api
    print(response.body);
    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      res = jsonResponse.map((item) => SearchItem.fromJson(item)).toList();
    }else{
      throw Exception('Error in search.');
    }

    return res;
  }

}