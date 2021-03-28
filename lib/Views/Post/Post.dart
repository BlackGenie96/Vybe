import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:path/path.dart' as path;
import 'package:vybe_2/Views/Navigation/Navigation.dart';
import 'package:vybe_2/Views/tutorial/tutorial.dart';
import 'package:vybe_2/Views/settings/controller.dart';

class Post extends StatefulWidget{
  @override
  _PostState createState() => new _PostState();
}

class _PostState extends State<Post>{

  SharedPreferences prefs;
  File _pickedImage;
  String _status;
  EventItemPost _chosenEvent;
  PlaceItemPost _chosenPlace;
  Future<List<EventItemPost>> listEvents;
  var eventButton ="Choose Event";
  var placeButton ="Choose Place";
  int _currentCategory;
  int _userId;
  int _orgId;

  bool _orgChosen = false;
  bool _eventChosen = false;
  bool _placeChosen = false;
  var ext;
  SettingsController settings = new SettingsController();
  final domain = "https://vybe-296303.uc.r.appspot.com";

  //creates a dialog view for selecting an image resource.
  void _pickImage() async{
    final imageSource = await showDialog<ImageSource>(
      context: context  ,
      builder: (context) =>
          AlertDialog(
           title: Text('Select the image source'),
           actions: <Widget>[
             MaterialButton(
               child: Text('Camera'),
               onPressed: ()=>Navigator.pop(context, ImageSource.camera),
             ),
             MaterialButton(
               child: Text('Gallery'),
               onPressed: ()=>Navigator.pop(context,ImageSource.gallery),
             ),
           ],
          )
    );

    if(imageSource != null){
      final file = await ImagePicker.pickImage(source: imageSource);
      if(file != null){
        setState(() {
          _pickedImage = file;
        });
        ext = path.extension(_pickedImage.path);
      }
    }
  }

  void _chooseAccount() async{

    if(_userId is int && _orgId is int){

      await showDialog<String>(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Choose Account for Post:',textAlign:TextAlign.center,style:TextStyle(color:Colors.black,fontWeight:FontWeight.bold)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.grey,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(50.0)),
                      padding: const EdgeInsets.all(16.0),
                      onPressed: (){
                        //set user id
                        setState((){
                          _orgChosen = false;
                        });

                        Navigator.pop(context);
                      },
                      elevation: 2,
                      child: Text('Personal Account'),
                    ),
                    SizedBox(height: 10.0),
                    RaisedButton(
                      color: Colors.grey,
                      textColor: Colors.white,
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      padding : const EdgeInsets.all(16.0),
                      onPressed: () {

                        //set orgId
                        setState((){
                          _orgChosen = true;
                        });
                        Navigator.pop(context);
                      },
                      child: Text('Business Account'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    padding: const EdgeInsets.all(16.0),
                    onPressed: ()=> Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ],
              )
      );
    }
  }

  //creates a dialog view with the events list
  void createEventsDialog() async{
    await showDialog<EventItemPost>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Choose Event to Post About'),
            actions: <Widget>[
              MaterialButton(
                child: Text('Cancel'),
                onPressed: (){
                  setState((){
                    _eventChosen = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
            content: Center(
              child: FutureBuilder<List<EventItemPost>>(
                  future: _eventList(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      //custom code here
                      List<EventItemPost> data = snapshot.data;
                      return _eventDialogListView(data);
                    }else if(snapshot.hasError){
                      return Text('There are no events listed in this category.',textAlign:TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,color:Colors.black));
                    }
                    return CircularProgressIndicator();
                  }
              ),
            ),
          )
    );
  }

  //function to talk to server: Event list API
  Future<List<EventItemPost>> _eventList() async{
    //variables for http.post
    final url = domain+"/flutter_api/Event/getEventName.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String, dynamic> data = {
      'category_id' : _currentCategory
    };

    //send data to server and upload a post by the user
    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle response from the server
    if(response.statusCode == 200){
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => new EventItemPost.fromJson(item)).toList();
    }else{
      throw Exception('Failed to load event items from API.');
    }
  }

  //function to create event list view after futureBuilder gets the data
  Widget _eventDialogListView(data){
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context,index){
          EventItemPost item = data[index];
          return  GestureDetector(
            onTap: (){
              setState(() {
                if(item.name != null){
                  _chosenEvent = item;
                  _eventChosen = true;
                }else{
                  _eventChosen = false;
                }
              });
              Navigator.of(context).pop();
            },
            child:Card(
              child: Container(
                alignment:Alignment.center,
                child:Padding(
                  padding: const EdgeInsets.all(8),
                  child:Text(item.name),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  //creates a dialog view with the places list
  void createPlacesDialog() async{
    await showDialog<PlaceItemPost>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Choose Business to Post About:'),
            actions: <Widget>[
              MaterialButton(
                child: Text('Cancel'),
                onPressed:(){
                  setState(() {
                    _placeChosen = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
            content: Center(
              child: FutureBuilder<List<PlaceItemPost>>(
                future: _placeList(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    List<PlaceItemPost> data = snapshot.data;
                    if(data.isNotEmpty){
                      return _placeDialogListView(data);
                    }else{
                      return Center(child: Text('There are no locations registered with this category yet'));
                    }

                  }else if(snapshot.hasError){
                    return Text('Error: ${snapshot.error}');
                  }

                  return CircularProgressIndicator();
                },
              ),
            ),
          )
    );
  }

  //fetches json array with places list
  Future<List<PlaceItemPost>> _placeList() async{
    final url = domain+"/flutter_api/Place/getPlaceName.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String, dynamic> data = {
      'category_id' : _currentCategory
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data),
    );

    //handle json response
    if(response.statusCode == 200){
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item)=> PlaceItemPost.fromJson(item)).toList();
    }else{
      throw Exception('Failed to load place items from API');
    }
  }

  //creates list view for places dialog
  Widget _placeDialogListView(data){
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index){
          PlaceItemPost item = data[index];
          return GestureDetector(
            onTap: (){
              setState(() {
                if(item.name.isNotEmpty){
                  _chosenPlace = item;
                  _placeChosen = true;
                }else{
                  _placeChosen = false;
                }
              });
              Navigator.of(context).pop();
            },
            child: Card(
              child: Container(
                alignment:Alignment.center,
                child:Padding(
                  padding: const EdgeInsets.all(8),
                  child:Text(item.name),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOverlay(BuildContext context){
    Navigator.pop(context, PostsTutorial());
  }

  void getPrefs() async{
    prefs = await SharedPreferences.getInstance();

    setState(() {
      _currentCategory = prefs.getInt('chosenCategory');
      _userId = prefs.getInt('userId');
      _orgId = prefs.getInt('orgId');
    });
  }

  @override
  void initState(){
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context){
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        accentColor: Colors.white,
        cursorColor: Color(0xff301370)
      ),
      child: new Builder(
        builder : (context) => new Scaffold(
          appBar: AppBar(
            title: Text('Post', style:TextStyle(fontFamily: 'SF-Pro',color:Colors.white,)),
            backgroundColor: Color(0xff301370),
          ),
          body:SingleChildScrollView(
            child:createBody(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _pickImage,
            child: Icon(Icons.image, color:Color(0xff301370)),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Container createBody() => Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(top: 15,),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Write Something',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(17.0)),
                    borderSide: BorderSide(color: Color(0xff301370),width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide:BorderSide(color:Color(0xff301370))
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:BorderSide(color:Color(0xff301370))
                  ),
                  labelStyle: TextStyle(
                    fontFamily: 'SF-Pro',
                    color:Color(0xff301370),
                  ),
                  hintStyle: TextStyle(
                    fontFamily: 'SF-Pro',
                    color: Color(0xff301370),
                  ),
                ),
                onChanged: (text){
                  //save the data input in the post
                  _status = text;
                },
                maxLines: 6,
                minLines: 1,
                maxLengthEnforced: true,
                maxLength: 250,
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  color: Color(0xff301370),
                ),
                keyboardType: TextInputType.text,
              )
          ),
          GestureDetector(
            onTap:(){
              print('Event Picker Dialog');
              createEventsDialog();
              //createChooseEvent();
            },
            child:Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
                border: Border.all(color: Color(0xffcd5e14), width: 1),
              ),
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width *0.65,
              margin: const EdgeInsets.only(top:15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    color: Color(0xffcd5e14),
                  ),
                  height: MediaQuery.of(context).size.height * 0.075,
                  width: MediaQuery.of(context).size.width *0.5,
                  child: Text(
                    _eventChosen ? _chosenEvent.name : 'Choose Event',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height:8.0),
          Text('or', textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro',fontSize: 18)),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap:(){
              print('Place Picker Dialog');
              createPlacesDialog();
            },
            child:Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
                border: Border.all(color: Color(0xff301370), width: 1),
              ),
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width *0.65,
              margin: const EdgeInsets.only(top:0),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    color: Color(0xff301370),
                  ),
                  height: MediaQuery.of(context).size.height * 0.075,
                  width: MediaQuery.of(context).size.width *0.5,
                  child: Text(
                    _placeChosen ? _chosenPlace.name : 'Choose Business',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap:(){
              print('Post Button clicked.');
              post();
            },
            child:Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
              ),
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width *0.65,
              margin: const EdgeInsets.only(top:15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    color: Colors.black,
                  ),
                  height: MediaQuery.of(context).size.height * 0.075,
                  width: MediaQuery.of(context).size.width *0.5,
                  child: Text(
                    'Post',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 15,),
              width: MediaQuery.of(context).size.width ,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                    child: _pickedImage == null ? Text('No Image Chosen'): Image(image: FileImage(_pickedImage))
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xff301370),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    ),
  );

  //functions to handle serving Post to API
  post() async{
    var url = domain+"/flutter_api/feed/userPost.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data;

    if(_placeChosen == true && _eventChosen == true){
      await showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Alert', style:TextStyle(color:Colors.red[900],fontWeight:FontWeight.bold)),
                actions:<Widget>[
                  MaterialButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop()
                  ),
                ],
                content: Text(
                  'You can only make one post about an event or a place at a time. You cannot make a post about both at the same time. De-select one of your options by clicking on the respective button and clicking on cancel on the dialog. Thank you',
                  textAlign: TextAlign.center,
                ),
              )
      );
      return;
    }else if(_eventChosen == true && _orgChosen == true){
      if(_pickedImage != null){
        data = {
          'org_id' : _orgId,
          'event_id' : _chosenEvent.id,
          'category_id' : _currentCategory,
          'status' : _status,
          'extension' : ext.toString(),
          'image' : base64Encode(_pickedImage.readAsBytesSync())
        };
      }else{
        data = {
          'org_id' : _orgId,
          'event_id' : _chosenEvent.id,
          'category_id' : _currentCategory,
          'status' : _status,
          'image' : _pickedImage
        };
      }
    }else if(_placeChosen == true && _orgChosen == true){
      if(_pickedImage != null){

        data = {
          'org_id' : _orgId,
          'place_id' : _chosenPlace.id,
          'category_id' : _currentCategory,
          'status' : _status,
          'extension' : ext.toString(),
          'image' : base64Encode(_pickedImage.readAsBytesSync())
        };
      }else{
        data = {
          'org_id' : _orgId,
          'place_id': _chosenPlace.id,
          'category_id' : _currentCategory,
          'status' : _status,
          'image' : _pickedImage
        };
      }
    }else if(_eventChosen == true && _orgChosen == false){
      if(_pickedImage != null){

        data = {
          'user_id' : _userId,
          'event_id' : _chosenEvent.id,
          'category_id' : _currentCategory,
          'status' : _status,
          'extension' : ext.toString(),
          'image' : base64Encode(_pickedImage.readAsBytesSync())
        };

      }else{

        data = {
          'user_id' : _userId,
          'event_id' : _chosenEvent.id,
          'category_id' : _currentCategory,
          'status' : _status,
          'image' : _pickedImage
        };

      }
    }else if(_placeChosen == true && _orgChosen == false){
      if(_pickedImage != null){

        data = {
          'user_id' : _userId,
          'place_id' : _chosenPlace.id,
          'category_id' : _currentCategory,
          'status' : _status,
          'extension' : ext.toString(),
          'image' : base64Encode(_pickedImage.readAsBytesSync())
        };
      }else{
        data = {
          'user_id' : _userId,
          'place_id': _chosenPlace.id,
          'category_id' : _currentCategory,
          'status' : _status,
          'image' : _pickedImage
        };
      }
    }else{
      await showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Alert', style:TextStyle(color:Colors.red[900],fontWeight:FontWeight.bold)),
                actions:<Widget>[
                  MaterialButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop()
                  ),
                ],
                content: Text(
                  'You have to add information to the fields before a post can be made',
                  textAlign: TextAlign.center,
                ),
              )
      );
      return;
    }

    http.Response response;

    if(_orgChosen){
      response = await http.post(
          url,//go to organizer post url
          headers: headers,
          body: json.encode(data)
      );
    }else{
      response = await http.post(
          url,
          headers: headers,
          body: json.encode(data)
      );
    }

    print(response.body);
    if(response.statusCode == 200){
      var jsonResponse = json.decode(response.body);
      var message = jsonResponse["message"];
      var success = jsonResponse["success"];
      if(success == 1){
        print(message);
        Toast.show(message, context, duration:Toast.LENGTH_LONG, gravity:Toast.BOTTOM);
        _goToHome();
      }else{
        Toast.show(message, context, duration:Toast.LENGTH_LONG, gravity:Toast.BOTTOM);
      }
    }
  }

  void _goToHome(){
    //after updating the chosen category go to main activity
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (BuildContext context){
            return MaterialApp(
              home: Navigation(),
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                accentColor: Color(0xffffffff),
                primaryColor: Color(0xffffffff),
              ),
            );
          }
      ),
    );
  }
}

//utility classes for event and place item
//both classes hold the name and id
class EventItemPost{
  int id;
  String name;

  EventItemPost({this.id, this.name});

  factory EventItemPost.fromJson(Map<String,dynamic> json){
    return EventItemPost(
      id: int.parse(json['eventId']),
      name: json['eventName']
    );
  }
}

class PlaceItemPost{
  final int id;
  final String name;

  PlaceItemPost({this.id, this.name});

  factory PlaceItemPost.fromJson(Map<String,dynamic> json){
    return PlaceItemPost(
      id: int.parse(json['locationId']),
      name: json['locationName']
    );
  }
}