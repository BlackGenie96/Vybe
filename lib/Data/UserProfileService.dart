import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vybe_2/Models/UserData.dart';
import 'package:http/http.dart' as http;

abstract class UserProfileAbstract{
  Future<UserData> getUserProfile();
  Future updateProfileInfo({String name, String surname, String email, String phone, File image, dynamic ext});
}

class UserProfileService extends UserProfileAbstract{
  SharedPreferences prefs;
  final domain = "https://vybe-296303.uc.r.appspot.com";

  Future<UserData> getUserProfile() async{
    prefs = await SharedPreferences.getInstance();
    final categoryId = prefs.getInt("chosenCategory");
    final userId = prefs.getInt("userId");

    final url = domain+"/flutter_api/Profile/getUserProfile.php";
    final Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      'user_id' : userId,
      'category_id' : categoryId
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle response from api
    print(response.body);
    if(response.body.contains("success")){
      //send back a null object of UserData
      return UserData();
    }else{
      Map<String,dynamic> jsonResponse = json.decode(response.body);
      return new UserData.fromJson(jsonResponse);
    }
  }

  Future updateProfileInfo({String name, String surname, String email, String phone, File image, dynamic ext}) async{
    prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId');

    final url = domain+"/flutter_api/Registration/register_user.php";
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      'userId' : userId,
      'name' : name,
      'surname' : surname,
      'email' : email,
      'phone' : phone,
      'ext' : ext.toString(),
      'image' : base64Encode(image.readAsBytesSync())
    };

    print(json.encode(data));

    try{
      http.Response response = await http.post(
          url,
          headers: headers,
          body: json.encode(data)
      );

      if(response.body.isNotEmpty){
        print(response.body);
      }

      //handle response from api
      if(response.statusCode == 200){
        Map<String, dynamic> result = json.decode(response.body);
        var success = result["success"];
        var message = result["message"];

        if(success == 1){
          var username = result["username"];
          var surname = result["surname"];
          var email = result["email"];
          var phone = result["phoneNum"];

          print(message);
          updatePrefs(username, surname, email, phone);
        }
      }
    }catch(e){
      print("Error"+e.toString());
    }
  }

  void updatePrefs(username, surname, email, phone) async{
    prefs = await SharedPreferences.getInstance();

    prefs.setString('userName', username);
    prefs.setString('userSurname', surname);
    prefs.setString('userEmail',email);
    prefs.setString('userPhone', phone.toString());

    print("Preferences updated.");
  }
}