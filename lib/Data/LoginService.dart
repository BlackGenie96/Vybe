import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vybe_2/Models/UserData.dart';

abstract class LoginServiceAbstract{
  Future<Map<String,dynamic>> loginRequest(String email, String password);
  Future<UserData> getUserData();
  void saveToPreferences(String id, String name, String surname, String phone, String email, String chosen);
  Future<bool> logoutUser({String userId});
}

class LoginService extends LoginServiceAbstract{

  SharedPreferences prefs;
  final domain = "http://192.168.43.56:8080";

  //login request
  Future<Map<String,dynamic>> loginRequest(String email, String password) async{

    final url = domain+"/user/login";

    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> data = {
      "email" : email,
      "password" : password
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //response from server
    print(response.body);
    Map<String,dynamic> res = jsonDecode(response.body);
    var success = res["success"];

    if(success == 1){
      var _responseId = res["_id"];
      var _responseName = res["name"];
      var _responseSurname = res["surname"];
      var _responsePhone = res["phone"];
      var _responseEmail = res["email"];
      var _responseCategory = res["current_category"];

      //save user details int shared preferences.
      saveToPreferences(_responseId, _responseName, _responseSurname, _responsePhone, _responseEmail, _responseCategory);

    }else{
      throw Exception('Error logging in from server.');
    }
    return res;
  }

  void saveToPreferences(String id, String name, String surname, String phone, String email, String chosen) async{
    //get shared preferences instances
    prefs = await SharedPreferences.getInstance();

    //save user details from the response API.
    prefs.setBool('loggedIn', true);
    prefs.setString('userId', id);
    prefs.setString('userName', name);
    prefs.setString('userSurname', surname);
    prefs.setString('userPhone', phone);
    prefs.setString('userEmail', email);
    prefs.setString('chosenCategory', chosen);

    print("Saved in sharedPreferences.");
  }

  Future<UserData> getUserData() async{
    prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId");
    String userName = prefs.getString("userName");
    String surname = prefs.getString("userSurname");
    String phone = prefs.getString("userPhone");
    String email = prefs.getString("userEmail");

    return new UserData(userId: userId,username: userName, surname:surname,phone:phone,email:email);
  }

  //clear out shared preferences is use chooses to log out. Also delete user from database.
  Future<bool> logoutUser({String userId}) async{
    await SharedPreferences.getInstance().then((SharedPreferences res){
      prefs = res;
    }).whenComplete((){
      prefs.clear();
    });
    String prefId = prefs.getString('userId');

    if(prefId == null){
      print("Deleted from database.");
      print("Deleted from preferences.");

      return true;
    }else{
      return false;
    }
  }
}