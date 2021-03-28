import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RegisterServiceAbstract{

  Future<Map<String,dynamic>> registerRequest(String name, String surname, String phone, String email, String password, String confirm);
  void saveToPreferences(String id, String name, String surname, String phone, String email, String chosenCat);
}

class RegisterService extends RegisterServiceAbstract{

  SharedPreferences prefs;
  var domain = "http://192.168.43.56:8080";

  Future<Map<String,dynamic>>  registerRequest(String name, String surname, String phone, String email, String password, String confirm) async{

    //declare connection variables
    if(password != confirm){
      return {"success" : 2, "message" : "Passwords do not match."};     // 0 represents that the passwords are not similar
    }

    final url = domain+"/user/register";
    Map<String,dynamic> res;
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> data = {
      'name' : name,
      'surname' : surname,
      'phone' : phone,
      'email' : email,
      'password' : password
    };

    try{

      http.Response response = await http.post(
          url,
          headers: headers,
          body: json.encode(data)
      );

      print(response.body);
      res = jsonDecode(response.body);
      if(response.statusCode == 200){
        var success = res["success"];

        if(success == 1){
          saveToPreferences(res["_id"], res["name"], res["surname"], res["phone"], res["email"], res['current_category']);
        }
      }else{

        throw Exception('Error connecting to the server');
      }

    }catch(e){
      print(e.toString());
    }

    return res;

  }

  void saveToPreferences(String id, String name, String surname, String phoneNum, String email, String chosen) async{
    //get shared preferences instances
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', true);
    prefs.setString('userId', id);
    prefs.setString('userName', name);
    prefs.setString('userSurname', surname);
    prefs.setString('userPhoneNum', phoneNum);
    prefs.setString('userEmail', email);
    prefs.setString('chosenCategory', chosen);
  }
}