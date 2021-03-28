import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vybe_2/Models/MenuItem.dart';
import 'package:vybe_2/Models/PlaceProfileItem.dart';

abstract class ShoppingCartServiceAbstract{

  Future<List<MenuItem>> getMenuItems(PlaceProfileItem item);
  Future<Map<String,dynamic>> placeOrder(int placeId, String totalPrice);

}

class ShoppingCartService extends ShoppingCartServiceAbstract{
  SharedPreferences prefs;
  final domain = "https://vybe-296303.uc.r.appspot.com";

  Future<List<MenuItem>> getMenuItems(PlaceProfileItem item) async{

    List<MenuItem> res = [];
    final url = domain+"/flutter_api/menu_items/get_place_menu_items.php?placeId=${item.placeId}";
    Map<String,String> header = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      'placeId': item.placeId
    };

    await http.post(
        url,
        headers: header,
        body: json.encode(data)
    ).then((response){
      print(response.body);

      if(response.statusCode == 200){
        List items = json.decode(response.body);
        res = items.map((item) => MenuItem.fromJson(item)).toList();
      }else{
        throw Exception('Error getting menu items from server API.');
      }
    }).catchError((onError){
      print(onError);
    });

    return res;
  }

  Future<Map<String,dynamic>> placeOrder(int placeId, String totalPrice) async{

    prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");

    final url = domain+"/flutter_api/shopping_cart/place_order.php?place_id=$placeId&user_id=$userId&total_price=$totalPrice";
    Map<String,String> headers = {"Content-Type" : "application/json"};
    Map<String,dynamic> data = {
      'place_id': placeId,
      'user_id' : userId,
      'total_price' : totalPrice
    };

    Map<String,dynamic> res;

    await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    ).then((response){
      print(response.body);

      if(response.statusCode == 200){
       res = json.decode(response.body);
      }
    }).catchError((e){
      throw new Exception(e.toString());
    });

    return res;
  }

}