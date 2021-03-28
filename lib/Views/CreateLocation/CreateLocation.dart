import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/CategoriesService.dart';
import 'package:vybe_2/Data/CreateLocationService.dart';
import 'package:vybe_2/Models/Category.dart';
import 'package:vybe_2/Models/MenuItem.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vybe_2/Views/CreateLocation/AddMenuItem.dart';
import 'package:vybe_2/Views/OrganizerProfile/OrganizerMenu.dart';

class CreateLocation extends StatefulWidget{

  final String locationId;
  CreateLocation({this.locationId});
  @override
  _CreateLocationState createState() => new _CreateLocationState(locationId:locationId ==null ? null : locationId);
}

class _CreateLocationState extends State<CreateLocation>{

  final String locationId;
  _CreateLocationState({this.locationId});

  //controllers for container
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _phoneNumController = new TextEditingController();
  TextEditingController _statusController = new TextEditingController();
  TextEditingController _websiteController = new TextEditingController();
  TextEditingController _aboutController = new TextEditingController();
  TextEditingController _directionsController = new TextEditingController();

  //file to keep selected image
  File _pickedImage;
  bool _imageChosen = false;
  String _placeImageUrl;
  bool _categoryChosen = false;
  Category _categoryData;

  Position _businessPosition;
  Geolocator _geolocator;

  List<MenuItem> _saved = List<MenuItem>();
  Future<List<Category>> catList;
  String parent_id;
  LocationService service = new LocationService();
  CategoriesService categoryService = new CategoriesService();

  void getCurrentLocation(){
    _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((Position cpos){
      setState(() {
        _businessPosition = cpos;
      });
    }).catchError((e){
      print(e);
    });
  }

  //method to pick image
  void _pickImage(context) async{
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source:'),
        actions: <Widget>[
          MaterialButton(
            child: Text('Camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: Text('Gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      )
    );

    if(imageSource != null){
      final file = await ImagePicker.pickImage(source: imageSource);
      if(file != null){
        setState(() {
          _pickedImage = file;
          _imageChosen = true;
        });

        Navigator.pop(context);
      }
    }
  }

  //method to handle hero
  void _goToPoster(context){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Color(0xaa000000),
          ),
          child: new Builder(
            builder: (context) =>Scaffold(
              appBar:AppBar(
                title: Text('Poster', style:TextStyle(fontFamily:'SF-Pro', color:Colors.white,)),
                backgroundColor: Colors.black,
                iconTheme : IconThemeData(
                  color:Colors.white,
                ),
              ),
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      RaisedButton(
                        color: Colors.white,
                        textColor: Colors.black,
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Choose Image',textAlign:TextAlign.center,style:TextStyle(fontFamily: 'SF-Pro')),
                        onPressed: ()=> _pickImage(context),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70.0)),
                      ),
                      SizedBox(height: 15),
                      Hero(
                        tag: 'create_event_poster',
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: _imageChosen ? Image(image:FileImage(_pickedImage)) : locationId == null ? Image.asset('assets/logo.png',width:MediaQuery.of(context).size.width) : Image.memory(base64Decode(_placeImageUrl),width:MediaQuery.of(context).size.width * 0.8),
                        ),
                        transitionOnUserGestures: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }

  @override
  void initState(){
    super.initState();
    _categoryData = new Category();
    _geolocator = new Geolocator();
    if(locationId != null){
      service.getPlaceLocation(locationId).then((Map<String,dynamic> res){
        setState(() {
          _nameController.text = res["name"];
          _addressController.text = res["address"];
          _phoneNumController.text = res["phone_number"];
          _categoryData.catName = res["category"]["name"];
          _categoryData.catId = res["category"]["_id"];
          _placeImageUrl = res["image"];
          _websiteController.text = res["website"];
          _aboutController.text = res["about"];
          _directionsController.text = res["directions"];
          _categoryChosen = true;
          _saved = res["menu"] == null ? [] : List<MenuItem>.from(res["menu"].map((item) => MenuItem.fromJson(item)));
          if(res["location"] == 1){
            _businessPosition = new Position(latitude: double.parse(res["latitude"]), longitude: double.parse(res["longitude"]));
          }
        });
      });
    }

    catList = categoryService.fetchCategories(parent_id == null || parent_id =="" ? "root" : parent_id);
  }

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        cursorColor : Colors.white,
      ),
      child: new Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: locationId == null
                ? Text('Add Business Profile',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,))
                : Text('Edit Business Profile',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,)),
            backgroundColor: Color(0xff301370),
            iconTheme: IconThemeData(
              color:Colors.white,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 70,
                      margin: const EdgeInsets.only(top: 12.0),
                      child: TextField(
                        controller: _nameController,
                        style: TextStyle(
                          color: Color(0xff301370),
                          fontFamily: 'SF-Pro',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Color(0xff301370),
                            fontFamily: 'SF-Pro',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            borderSide: BorderSide(color: Color(0xff301370), width : 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff301370)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff301370)),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: 2,
                        minLines: 1
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 70,
                      margin:const EdgeInsets.only(top: 12,),
                      child: TextField(
                        controller: _addressController,
                        style: TextStyle(
                          color: Color(0xff301370),
                          fontFamily: 'SF-Pro',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(
                            fontFamily: 'SF-Pro',
                            color: Color(0xff301370),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            borderSide: BorderSide(color: Color(0xff301370), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff301370)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff301370)),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        minLines: 1,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 70,
                      margin: const EdgeInsets.only(top:12),
                      child: TextField(
                        controller: _phoneNumController,
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          color: Color(0xff301370),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                            fontFamily: 'SF-Pro',
                            color: Color(0xff301370),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            borderSide: BorderSide(color: Color(0xff301370), width : 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff301370)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff301370)),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 70,
                      margin: const EdgeInsets.only(top:12),
                      child: TextField(
                        controller: _websiteController,
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          color: Color(0xff301370),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Website or Email',
                          labelStyle: TextStyle(
                            fontFamily: 'SF-Pro',
                            color: Color(0xff301370),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            borderSide: BorderSide(color: Color(0xff301370), width : 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff301370)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff301370)),
                          ),
                        ),
                        keyboardType: TextInputType.url,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      margin: const EdgeInsets.only(top: 12.0),
                      child: TextField(
                          controller: _statusController,
                          style: TextStyle(
                            color: Color(0xff301370),
                            fontFamily: 'SF-Pro',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Write status for the first post',
                            labelStyle: TextStyle(
                              color: Color(0xff301370),
                              fontFamily: 'SF-Pro',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(color: Color(0xff301370), width : 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff301370)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff301370)),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          maxLines: 6,
                          minLines: 1,
                        maxLengthEnforced: true,
                        maxLength: 250,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      margin: const EdgeInsets.only(top: 12.0),
                      child: TextField(
                          controller: _aboutController,
                          style: TextStyle(
                            color: Color(0xff301370),
                            fontFamily: 'SF-Pro',
                          ),
                          decoration: InputDecoration(
                            labelText: 'What is your business about ?',
                            labelStyle: TextStyle(
                              color: Color(0xff301370),
                              fontFamily: 'SF-Pro',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(color: Color(0xff301370), width : 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff301370)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff301370)),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          maxLines: 6,
                          minLines: 1,
                          maxLengthEnforced: true,
                          maxLength: 250,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      margin: const EdgeInsets.only(top: 12.0),
                      child: TextField(
                        controller: _directionsController,
                        style: TextStyle(
                          color: Color(0xff301370),
                          fontFamily: 'SF-Pro',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Directions to your place of business',
                          labelStyle: TextStyle(
                            color: Color(0xff301370),
                            fontFamily: 'SF-Pro',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            borderSide: BorderSide(color: Color(0xff301370), width : 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff301370)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff301370)),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: 6,
                        minLines: 1,
                        maxLengthEnforced: true,
                        maxLength: 250,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(top: 12,),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(top:12.0,left: 8.0),
                          child: Text('Add Menu Items: ', style:TextStyle(fontSize: 18,fontFamily:'SF-Pro',fontWeight:FontWeight.w700)),
                      ),
                    ),
                    SizedBox(height: 10),
                    MaterialButton(
                        child: Text('Add'),
                        onPressed: (){
                          //go to search
                          addMenuItem();
                        },
                        color: Colors.black,
                        textColor: Colors.white,
                        elevation: 2
                    ),
                    SizedBox(height: 12.0),
                    _saved.length != 0 ? _createMenuItemList() : Text('No Menu Items Added',textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro')),
                    SizedBox(height: 13.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.98,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:<Widget>[
                          GestureDetector(
                            onTap:() => _goToPoster(context) ,
                            child:Hero(
                              tag: 'create_event_poster',
                              child: Container(
                                child:CircleAvatar(
                                  backgroundImage: _imageChosen
                                      ? FileImage(_pickedImage)
                                      : locationId != null && _placeImageUrl != null
                                        ? MemoryImage(base64Decode(_placeImageUrl))
                                        : AssetImage('assets/logo.png'),
                                ),
                                width: 120,
                                height: 120,
                              ),
                              transitionOnUserGestures: true,
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 15, left: 12),
                              height: MediaQuery.of(context).size.height * 0.09,
                              alignment: Alignment.center,
                              child: _imageChosen
                                  ? Icon(Icons.check_circle, color:Colors.green[800])
                                  : locationId != null && _placeImageUrl != null
                                    ? Icon(Icons.check_circle,color:Colors.green[800])
                                    : Icon(Icons.check_circle,color:Colors.grey[500])
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              chooseCategory();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                color: Colors.black,
                              ),
                              width: MediaQuery.of(context).size.width * 0.65,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child:Text(_categoryChosen
                                    ? _categoryData.catName
                                    : "Choose Category",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'SF-Pro',
                                      fontSize: 18
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                              height: MediaQuery.of(context).size.height * 0.09,
                              alignment: Alignment.center,
                              child: _categoryChosen
                                  ? Icon(Icons.check_circle,color:Colors.green[800])
                                  : Icon(Icons.check_circle,color:Colors.grey[500])
                          ),
                        ],
                      ),
                    ),
                    /*SizedBox(height: 12.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.99,
                      child : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap:(){
                              cautionDialog();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Color(0xffcd5e14),
                              ),
                              width: MediaQuery.of(context).size.width * 0.65,
                              alignment: Alignment.center,
                              child : Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  _userPosition == null ? 'Find Location' : 'Location Found',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.09,
                            alignment: Alignment.center,
                            child: _userPosition == null
                                ? Icon(Icons.check_circle,color:Colors.grey[500])
                                : Icon(Icons.check_circle,color:Colors.green[800])
                          ),
                        ],
                      ),
                    ),*/
                    SizedBox(height: 12.0),
                    GestureDetector(
                      onTap:(){
                        if(locationId != null){
                          assignParametersForUpdate().then((Map<String,dynamic> res){
                            if(res != null){
                              service.updatePlace(res).then((Map<String,dynamic> res){
                                if(res["success"] == 1){
                                  Toast.show(res["message"], context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                  goToOrganizerMenu();
                                }else{
                                  Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                }
                              }).catchError((err) => print(err.toString()));
                            }
                          });
                        }else{
                          assignParametersForCreation().then((Map<String,dynamic> res){
                            if(res != null){
                              service.createPlace(res).then((Map<String,dynamic> res){
                                if(res["success"] == 1){
                                  Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                  goToOrganizerMenu();
                                }else{
                                  Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                }
                              }).catchError((err){
                                print("ERROR: "+err.toString());
                              });
                            }
                          });
                        }
                      },
                      child:Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100.0)),
                          color:Color(0xff301370),
                        ),
                        margin: const EdgeInsets.only(top:15, bottom: 20),
                        child: Icon(Icons.arrow_forward,size:40,color:Colors.white,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String,dynamic>> assignParametersForUpdate() async{
    Map<String,dynamic> data;
    if(_imageChosen == false && _placeImageUrl == ""){
      await showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Alert', style:TextStyle(color:Colors.black, fontWeight:FontWeight.bold)),
                backgroundColor: Colors.orange[500],
                actions: <Widget>[
                  MaterialButton(
                    child: Text("Cancel"),
                    onPressed: ()=> Navigator.of(context).pop(),
                    color: Colors.white,
                    textColor: Colors.black,
                  ),
                ],
                content: Text(
                  'Add an image for the location you are creating',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'SF-Pro',),
                ),
              )
      );
      return null;
    }else{
      if(_addressController.text.isEmpty || _phoneNumController.text.isEmpty || _nameController.text.isEmpty){
        await showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text('Alert', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  backgroundColor: Colors.orange[500],
                  actions: <Widget>[
                    MaterialButton(
                      child: Text('Cancel'),
                      onPressed : () => Navigator.of(context).pop,
                    ),
                  ],
                  content: Text(
                      'Location Name, Address and Phone Number cannot be empty !',
                      textAlign: TextAlign.center,
                      style:TextStyle(fontFamily:'SF-Pro')
                  ),
                )
        );
        return null;
      }else{
        if(_imageChosen == false){

          data = {
            "_id" : locationId,
            "name" : _nameController.text,
            "address" : _addressController.text,
            "phone_number" : _phoneNumController.text,
            "category" : _categoryData.catId,
            "website" : _websiteController.text,
            "status" : _statusController.text,
            "about" : _aboutController.text,
            "directions" : _directionsController.text,
            "latitude" : _businessPosition == null ? 0 : _businessPosition.latitude,
            "longitude" : _businessPosition == null ? 0 : _businessPosition.longitude,
            "menu" : _saved.map((i) => i.toJson()).toList()
          };

        }else{
          data = {
            "_id" : locationId,
            "name" : _nameController.text,
            "address" : _addressController.text,
            "phone_number" : _phoneNumController.text,
            "category" : _categoryData.catId,
            "image" : base64Encode(_pickedImage.readAsBytesSync()),
            "website" : _websiteController.text,
            "status" : _statusController.text,
            "about" : _aboutController.text,
            "directions" : _directionsController.text,
            "latitude" : _businessPosition == null ? 0 : _businessPosition.latitude,
            "longitude" : _businessPosition == null ? 0 : _businessPosition.longitude,
            "menu" : _saved.map((i) => i.toJson()).toList()
          };
        }
      }
    }
    return data;
  }

  Future<Map<String,dynamic>> assignParametersForCreation() async{
    Map<String,dynamic> data;
    if(_imageChosen == false && _placeImageUrl == ""){
      await showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Alert', style:TextStyle(color:Colors.black, fontWeight:FontWeight.bold)),
                backgroundColor: Colors.red[900],
                actions: <Widget>[
                  MaterialButton(
                      child: Text("Cancel"),
                      onPressed: ()=> Navigator.of(context).pop()
                  ),
                ],
                content: Text(
                  'Add an image for the location you are creating',
                ),
              )
      );
      return null;
    }else{
      if(_addressController.text.isEmpty || _phoneNumController.text.isEmpty || _nameController.text.isEmpty){
        await showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text('Alert', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  backgroundColor:Colors.red[900],
                  actions: <Widget>[
                    MaterialButton(
                      child: Text('Cancel'),
                      onPressed : () => Navigator.of(context).pop,
                      color: Colors.white,
                      textColor:Colors.black,
                    ),
                  ],
                  content: Text('Please fill in all the fields !', style:TextStyle(fontFamily:'SF-Pro',color:Colors.white)),
                )
        );
        return null;
      }else{

        if(_imageChosen){
          data = {
            "name" : _nameController.text,
            "address" : _addressController.text,
            "phone_number" : _phoneNumController.text,
            "category" : _categoryData.catId,
            "image" : base64Encode(_pickedImage.readAsBytesSync()),
            "status" : _statusController.text,
            "about" : _aboutController.text,
            "directions": _directionsController.text,
            "website" : _websiteController.text,
            "latitude" : _businessPosition == null ? 0 : _businessPosition.latitude,
            "longitude": _businessPosition == null ? 0 : _businessPosition.longitude,
            "menu" : _saved == null ? null : _saved.map((i) => i.toJson()).toList()
          };
        }else{
          data = {
            "name" : _nameController.text,
            "address" : _addressController.text,
            "phone_number" : _phoneNumController.text,
            "category" : _categoryData.catId,
            "image" : null,
            "status" : _statusController.text,
            "about" : _aboutController.text,
            "directions": _directionsController.text,
            "website" : _websiteController.text,
            "latitude" : _businessPosition == null ? 0 : _businessPosition.latitude,
            "longitude": _businessPosition == null ? 0 : _businessPosition.longitude,
            "menu" : _saved.map((i) => i.toJson()).toList()
          };
        }

      }
    }

    return data;
  }

  Widget _createMenuItemList(){
    final Iterable<Dismissible> tiles = _saved.map(
        (MenuItem item){
          return Dismissible(key:Key(item.name),
            onDismissed: (direction){
              setState((){
                _saved.remove(item);
              });
            },
            child: _createMenuItem(item)
          );
        }
    );

    final List<Widget> divided = ListTile.divideTiles(tiles: tiles, context:context).toList();
    return ListView(
      children: divided,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  Widget _createMenuItem(MenuItem item) => Card(
    color: Colors.white,
    elevation: 0.0,
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          new Container(
            //height: 124.0,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 46.0),
            decoration: new BoxDecoration(
              color: new Color(0xff301370),
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.circular(8.0),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.grey[700],
                  blurRadius: 5.0,
                  spreadRadius: 2,
                  offset: new Offset(0.0, 2.0),
                ),
              ],
            ),
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left:10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                      margin : EdgeInsets.only(left: 30,top: 15.0),
                      child: Text('${item.name}',style:TextStyle(fontSize: 25,fontFamily:'SF-Pro',fontWeight:FontWeight.w700,color:Colors.white),),
                  ),
                  new Container(
                    margin: EdgeInsets.only(
                      left: 33.0,
                      top: 10.0,
                    ),
                    child: Text('${item.desc}',style:TextStyle(fontSize: 15,fontFamily:'SF-Pro',color:Colors.white,)),
                  ),
                  new Container(
                    margin: EdgeInsets.only(
                      left: 30.0,
                      top: 10.0,
                      bottom: 5.0
                    ),
                    child: Text('E ${item.price}',style:TextStyle(fontSize:18,fontFamily:'SF-Pro',color:Colors.white,fontWeight:FontWeight.w700),),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap:() {
              openSecondMenuItemHero(item);
            },
            child: new Hero(
              tag: 'tag_${item.name}_${item.price}',
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                margin: EdgeInsets.only(
                  left: 10.0,
                  top: 20.0,
                ),
                alignment: FractionalOffset.centerLeft,
                child: CircleAvatar(
                  backgroundImage: item.imageUrl == null ? item.itemImage != null ? FileImage(item.itemImage) : AssetImage('assets/logo.png'): MemoryImage(base64Decode(item.imageUrl)),
                  radius: 35.0,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  void addMenuItem() async{
    final res = await Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => AddMenuItem(),
      ),
    );

    if(res != null){
      setState(() {
        _saved.add(res);
      });
    }
  }

  //function to handle the opening of the menu item image if the manager chooses to add one.
  void openSecondMenuItemHero(MenuItem item){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) => Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.black,
          ),
          child: Builder(
            builder: (context) => Scaffold(
              appBar:AppBar(
                title: Text('${item.name}',style:TextStyle(color:Colors.white,fontFamily:'Raleway')),
                backgroundColor:Colors.black,
                iconTheme:IconTheme.of(context).copyWith(
                  color:Colors.white,
                ),
              ),
              body: SafeArea(
                child : Center(
                  child: Hero(
                    tag:'tag_${item.name}_${item.price}',
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height : MediaQuery.of(context).size.height * 0.8,
                      child: item.imageUrl == null ? item.itemImage != null ? Image.file(item.itemImage) : Image.asset('assets/logo.png'): Image.memory(base64Decode(item.imageUrl)),
                    ),
                  ),
                ),
              ),
            )
          ),
        ),
      ),
    );
  }

  //open dialog to ask organizer if they are at the place they are creating physically.
  void cautionDialog() async{
    await showDialog(
      context : context,
      builder: (context) => AlertDialog(
        title : Text('CAUTION !!!',textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,fontWeight:FontWeight.bold)),
        backgroundColor: Colors.red[900],
        content: Container(
          padding: const EdgeInsets.all(16.0),
          child : Text('Make sure that you are currently located in the premises of the place you are creating before you continue. If you are'
              ' not then, you can come back later to update the information about your service location.',textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro',color: Colors.white),),
        ),
        actions: <Widget>[
          RaisedButton(
            color: Colors.white,
            textColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side :BorderSide(color: Colors.black, width:1.5)),
            child: Text('Ok'),
            padding: const EdgeInsets.all(16.0),
            onPressed: (){
              print('getting location.');
              getCurrentLocation();
              Navigator.pop(context);
            }
          ),
          RaisedButton(
            color: Colors.black,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            child: Text('Cancel'),
            padding: const EdgeInsets.all(16.0),
            onPressed: () => Navigator.pop(context)
          ),
        ],
      ),
    );
  }

  void goToOrganizerMenu(){
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context){
              return new MaterialApp(
                home: OrganizerMenu(),
                theme: ThemeData(
                  scaffoldBackgroundColor: Color(0xff301370),
                  primaryColor: Colors.white,
                  accentColor: Colors.white,
                ),
              );
            }
        )
    );
  }

  ///Handle dialog that shows the list of categories.
  void chooseCategory() async{
    await showDialog(
      context : context ,
      builder : (context) =>
          AlertDialog(
            title: Text('Choose Category'),
            actions: <Widget>[
              MaterialButton(
                child: Text('Cancel'),
                onPressed: (){
                  setState(() {
                    _categoryChosen = false;
                  });
                  Navigator.of(context).pop();
                }
              ),
            ],
            content: FutureBuilder<List<Category>>(
              future: catList,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  List<Category> data = snapshot.data;
                  return _buildCategoryList(data);
                }else if(snapshot.hasError){
                  return Text("Error: ${snapshot.error}");
                }

                return Center(child: CircularProgressIndicator(backgroundColor: Colors.white));
              }
            ),
          )
    );
  }

  Widget _buildCategoryList(data) => Container(
    width: MediaQuery.of(context).size.width * 0.5,
    height: MediaQuery.of(context).size.height * 0.6,
    child: ListView.builder(
      itemCount : data.length,
      itemBuilder: (context, index){
        Category item = data[index];
        return GestureDetector(
          onTap:(){
            if(item.hasChildren){
              setState(() {
                catList = categoryService.fetchCategories(item.catId);
              });
            }else{
              setState(() {
                _categoryData = item;
                _categoryChosen = true;
              });
              Navigator.of(context).pop();
            }
          },
          child: Card(
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${item.catName}', textAlign: TextAlign.center),
            ),
          ),
        );
      },
      shrinkWrap: true,
    )
  );
}