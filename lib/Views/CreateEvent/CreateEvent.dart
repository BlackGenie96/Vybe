import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
//import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:vybe_2/Data/CategoriesService.dart';
import 'package:vybe_2/Data/CreateEventService.dart';
import 'package:vybe_2/Models/Category.dart';
import 'package:vybe_2/Models/LocationInformation.dart';
import 'package:vybe_2/Views/OrganizerProfile/OrganizerMenu.dart';

class CreateEvent extends StatefulWidget{
  final String eventId;
  CreateEvent({this.eventId});

  @override
  _CreateEventState createState() => new _CreateEventState(eventId : eventId == null ? null : eventId);
}

class _CreateEventState extends State<CreateEvent>{

  final String eventId;
  _CreateEventState({this.eventId});

  var provider;

  //state handling and management variables
  bool _categoryChosen = false;
  Category _categoryData;
  bool _dateChosen = false;
  DateTime _selectedDate = DateTime.now();
  bool _imageChosen = false;
  File _pickedImage;
  //edit event variables
  String _date;
  String _eventImageUrl;

  var _eventNameController = TextEditingController();
  var _eventLocationController = TextEditingController();
  var _startTimeController = TextEditingController();
  var _maxAllowedController = TextEditingController();
  var _themeController = TextEditingController();
  var _statusController = TextEditingController();
  var _aboutController = TextEditingController();
  var _salePointNameController = TextEditingController();
  var _salePointTownController = TextEditingController();
  var _salePointPhoneController = TextEditingController();

  //text editing controllers for tickets activity
  var _presaleGeneralController = TextEditingController();
  var _presaleVIPController = TextEditingController();
  var _presaleVVIPController = TextEditingController();
  var _gateGeneralController = TextEditingController();
  var _gateVIPController = TextEditingController();
  var _gateVVIPController = TextEditingController();

  //list to hold selected locations in the search activity
  List<LocationInformation> _saved = List<LocationInformation>();
  Future<List<Category>> catList;
  int count = 0;
  CreateEventService service = new CreateEventService();
  CategoriesService categoryService = new CategoriesService();
  String parent;

  @override
  void initState(){
    super.initState();

    if(eventId != null){

      print("***********************____GETTING EVENT DATA___ *******************");
      service.getEventInformation(eventId).then((res){
        _categoryData = new Category(catId:res['category']['_id'], catName: res['category']['name'], parent:res['category']['parent'],hasChildren: res['category']['has_children']);

        //assign retrieved values to widget text
        _eventLocationController.text = res["location"] == null ? "" : res["location"];
        _eventNameController.text = res["name"] == null ? "" : res["name"];
        _startTimeController.text = res["time"] == null ? "" : res["time"];
        _maxAllowedController.text = res["max_allowed"] == null ? "" : res["max_allowed"];
        _themeController.text = res["theme"] == null ? "" : res["theme"];
        _presaleGeneralController.text = res["tickets"]["preSaleGeneral"] == null ? "" : res["tickets"]["preSaleGeneral"];
        _presaleVIPController.text = res["tickets"]["preSaleVIP"] == null ? "" : res["tickets"]["preSaleVIP"];
        _presaleVVIPController.text = res["tickets"]["preSaleVVIP"] == null ? "" : res["tickets"]["preSaleVVIP"];
        _gateGeneralController.text = res["tickets"]["gateGeneral"] == null ? "" : res["tickets"]["gateGeneral"];
        _gateVIPController.text = res["tickets"]["gateVIP"] == null ? "" : res["tickets"]["gateVIP"];
        _gateVVIPController.text = res["tickets"]["gateVVIP"] == null ? "" : res["tickets"]["gateVVIP"];
        _date = res["date"];
        _eventImageUrl = res["poster"];
        _aboutController.text = res["about"];
        print("*********************************************************** 1");
        _saved = res["salesPoints"] == null ? [] : List<LocationInformation>.from(res["salesPoints"].map((item) => LocationInformation.fromJson(item)));
        print("*********************************************************** 2");

        print(_saved.length);
        if(_eventImageUrl != null){
          setState(() {
            _categoryChosen = true;
          });
        }else{
          setState(() {
            _categoryChosen = true;
          });
        }
      }).catchError((err) => Toast.show(err.toString(), context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
    }

    catList = categoryService.fetchCategories(parent);


  }

  @override
  Widget build(BuildContext context){
    return new Theme(
      data:Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        cursorColor : Colors.white,
      ),
      child:new Builder(
        builder: (context) =>Scaffold(
            appBar: AppBar(
              title: eventId != null
                  ? Text('Edit Event',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,))
                  : Text('Create Event',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white)),
              backgroundColor: Color(0xff301370),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              print('Show dialog to choose category');
                              createCategoryDialog();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                color: Colors.white,
                                border: Border.all(color:Color(0xffcd5e14), width:1),
                              ),
                              height: MediaQuery.of(context).size.height * 0.09,
                              width: MediaQuery.of(context).size.width * 0.65,
                              margin: const EdgeInsets.only(top: 15),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                    color: Color(0xffcd5e14),
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.075,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    _categoryChosen ? _categoryData.catName :'Choose Category',
                                    textAlign: TextAlign.center,
                                    style:TextStyle(
                                      fontFamily: 'SF-Pro',
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 15, left: 12),
                              height: MediaQuery.of(context).size.height * 0.09,
                              alignment: Alignment.center,
                              child: _categoryChosen
                                  ? Icon(Icons.check_circle, color:Colors.green[800])
                                  : Icon(Icons.check_circle,color:Colors.grey[500])
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Theme(
                            data: Theme.of(context).copyWith(
                              primaryColor: Color(0xffffffff),
                              accentColor:Color(0xff301370),
                              buttonColor: Colors.white,
                            ),
                            child: new Builder(
                              builder: (context) => GestureDetector(
                                onTap: (){
                                  print('Show dialog to choose date');
                                  _selectDate(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                    color: Colors.white,
                                    border: Border.all(color:Color(0xff301370), width:1),
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.09,
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  margin: const EdgeInsets.only(top: 15),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                        color: Color(0xff301370),
                                      ),
                                      height: MediaQuery.of(context).size.height * 0.075,
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: Text(
                                        _dateChosen
                                            ? '${_selectedDate.toLocal()}'.split(' ')[0]
                                            : _date == null
                                              ? 'Choose Date'
                                              : '$_date'.split(' ')[0],
                                        textAlign: TextAlign.center,
                                        style:TextStyle(
                                          fontFamily: 'SF-Pro',
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 15, left: 12),
                              height: MediaQuery.of(context).size.height * 0.09,
                              alignment: Alignment.center,
                              child: _dateChosen
                                  ? Icon(Icons.check_circle, color:Colors.green[800])
                                  : _date == null
                                    ? Icon(Icons.check_circle,color:Colors.grey[500])
                                    : Icon(Icons.check_circle,color:Colors.green[800]),
                          ),
                        ],
                      ),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Theme(
                            data: Theme.of(context).copyWith(
                              primaryColor: Color(0xffffffff),
                              accentColor:Color(0xff301370),
                              buttonColor: Colors.white,
                            ),
                            child: new Builder(
                              builder: (context) => GestureDetector(
                                onTap: (){
                                  print('Show dialog to choose place');
                                  createPlacesDialog();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                    color: Colors.white,
                                    border: Border.all(color:Color(0xff000000), width:1),
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.09,
                                  width: MediaQuery.of(context).size.width * 0.65,
                                  margin: const EdgeInsets.only(top: 15),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                        color: Color(0xff000000),
                                      ),
                                      height: MediaQuery.of(context).size.height * 0.075,
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: Text(
                                        _locationChosen ? _locationDialogData.placeName :'Choose Location',
                                        textAlign: TextAlign.center,
                                        style:TextStyle(
                                          fontFamily: 'SF-Pro',
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 15, left: 12),
                              height: MediaQuery.of(context).size.height * 0.09,
                              alignment: Alignment.center,
                              child: _locationChosen
                                  ? Icon(Icons.check_circle, color:Colors.green[800])
                                  : Icon(Icons.check_circle,color:Colors.grey[500])
                          ),
                        ],
                      ),*/
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Color(0xff301370),
                          accentColor: Color(0xff301370),
                        ),
                        child: new Builder(
                          builder: (context) => Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 70,
                            margin: const EdgeInsets.only(top: 15),
                            child: TextField(
                              controller: _eventNameController,
                              style: TextStyle(
                                color: Color(0xff301370),
                                fontFamily: 'SF-Pro',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Event Name',
                                labelStyle: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                  borderSide: BorderSide(color:Color(0xff301370), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff301370)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff301370)),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Color(0xff301370),
                          accentColor: Color(0xff301370),
                        ),
                        child: new Builder(
                          builder: (context) => Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 70,
                            margin: const EdgeInsets.only(top: 15),
                            child: TextField(
                              controller: _eventLocationController,
                              style: TextStyle(
                                color: Color(0xff301370),
                                fontFamily: 'SF-Pro',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Event Location',
                                labelStyle: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                  borderSide: BorderSide(color:Color(0xff301370), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff301370)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff301370)),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Color(0xff301370),
                          accentColor: Color(0xff301370),
                        ),
                        child: new Builder(
                          builder: (context) => Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 70,
                            margin: const EdgeInsets.only(top: 15),
                            child: TextField(
                              controller: _startTimeController,
                              style: TextStyle(
                                color: Color(0xff301370),
                                fontFamily: 'SF-Pro',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Start Time',
                                labelStyle: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                  borderSide: BorderSide(color:Color(0xff301370), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff301370)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff301370)),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ),
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
                                        : _eventImageUrl == null
                                          ? AssetImage('assets/logo.png')
                                          : MemoryImage(base64Decode(_eventImageUrl)),
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
                                child: _imageChosen ? Icon(Icons.check_circle, color:Colors.green[800]) : _eventImageUrl == null ? Icon(Icons.check_circle,color:Colors.grey[500]) : Icon(Icons.check_circle,color:Colors.green[800])
                            ),
                          ],
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Color(0xff301370),
                          accentColor: Color(0xff301370),
                        ),
                        child: new Builder(
                          builder: (context) => Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 70,
                            margin: const EdgeInsets.only(top: 15),
                            child: TextField(
                              controller: _maxAllowedController,
                              style: TextStyle(
                                color: Color(0xff301370),
                                fontFamily: 'SF-Pro',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Max People Allowed',
                                labelStyle: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                  borderSide: BorderSide(color:Color(0xff301370), width: 1),
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
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Color(0xff301370),
                          accentColor: Color(0xff301370),
                        ),
                        child: new Builder(
                          builder: (context) => Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 70,
                            margin: const EdgeInsets.only(top: 15),
                            child: TextField(
                              controller: _themeController,
                              style: TextStyle(
                                color: Color(0xff301370),
                                fontFamily: 'SF-Pro',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Theme',
                                labelStyle: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                  borderSide: BorderSide(color:Color(0xff301370), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff301370)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff301370)),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Color(0xff301370),
                          accentColor: Color(0xff301370),
                        ),
                        child: new Builder(
                          builder: (context) => Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 70,
                            margin: const EdgeInsets.only(top: 15),
                            child: TextField(
                              controller: _statusController,
                              style: TextStyle(
                                color: Color(0xff301370),
                                fontFamily: 'SF-Pro',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Write status for event post',
                                labelStyle: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                  borderSide: BorderSide(color:Color(0xff301370), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff301370)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff301370)),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              maxLines: 10,
                              minLines: 1,
                            ),
                          ),
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          primaryColor: Color(0xff301370),
                          accentColor: Color(0xff301370)
                        ),
                        child: new Builder(
                          builder: (context) => Container(
                            width : MediaQuery.of(context).size.width * 0.75,
                            height : 150,
                            margin: const EdgeInsets.only(top: 15.0),
                            child: TextField(
                              controller: _aboutController,
                              style: TextStyle(
                                color: Color(0xff301370),
                                fontFamily: 'SF-Pro',
                              ),
                              decoration: InputDecoration(
                                labelText: 'What is your event about ?',
                                labelStyle: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                  borderSide: BorderSide(color:Color(0xff301370), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff301370)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff301370)),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              maxLines: 10,
                              minLines: 1,
                              maxLengthEnforced: true,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      GestureDetector(
                        onTap:(){
                          print('Proceed with event creation.');
                          proceedToTickets();
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
      )
    );
  }

  //methods to build alert dialog for selecting category
  void createCategoryDialog() async{
    await showDialog<Category>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Category'),
        actions: <Widget>[
          MaterialButton(
            child:Text('Cancel'),
            onPressed:() {
              setState(() {
                _categoryChosen = false;
              });
              Navigator.of(context).pop();
            },
          )
        ],
        content: Center(
          child: FutureBuilder<List<Category>>(
            future: catList,
            builder: (context, snapshot){
              //TODO: use connection variable to change widget views while reloading data
              if(snapshot.hasData){
                List<Category> data = snapshot.data;
                return _buildCategoryList(data);
              }else if(snapshot.hasError){
                return Center(child:Text('Error ${snapshot.error}'));
              }

              return Center(child: CircularProgressIndicator(backgroundColor: Colors.white,));
            }
          ),
        ),
      )
    );
  }

  Widget _buildCategoryList(data) => Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.6,
    child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index){
          Category item = data[index];
          return GestureDetector(
            onTap:(){
              if(item.hasChildren){
                setState(() {
                  catList = categoryService.fetchCategories(item.catId);
                });
              }else {
                setState(() {
                  _categoryData = item;
                  _categoryChosen = true;
                  Navigator.of(context).pop();
                });
              }
            },
            child: Card(
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${item.catName}', textAlign: TextAlign.center),
              ),
            ),
          );
        }
    )
  );

  //methods to handle datePicker builder
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000,1,1),
        lastDate: DateTime(2050,12,1),);
    if(picked != null && picked != _selectedDate){
      setState(() {
        _selectedDate = picked;
        _dateChosen = true;
      });
    }
  }

  //creates a dialog view with the places list
  /*void createPlacesDialog() async{
    await showDialog<PlaceItem>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Choose Place to Post About:'),
              actions: <Widget>[
                MaterialButton(
                  child: Text('Cancel'),
                  onPressed:(){
                    setState(() {
                      _locationChosen = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
              content: Center(
                child: FutureBuilder<List<PlaceItem>>(
                  future: service.placeList(_categoryData),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      List<PlaceItem> data = snapshot.data;
                      return _placeDialogListView(data);
                    }else if(snapshot.hasError){
                      return Center(child:Text('${snapshot.error}'));
                    }

                    return Center(child:CircularProgressIndicator(backgroundColor: Colors.white));
                  },
                ),
              ),
            )
    );
  }

  //creates list view for places dialog
  Widget _placeDialogListView(data){
    return Container(
      width : MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index){
          PlaceItem item = data[index];
          return GestureDetector(
            onTap: (){
              setState(() {
                _locationChosen = true;
                _locationDialogData = item;
              });
              Navigator.of(context).pop();
            },
            child: Card(
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${item.placeName}', textAlign: TextAlign.center),
              ),
            ),
          );
        },
      )
    );
  }*/

  //method to select event image
  void _pickImage(context) async{
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        actions: <Widget>[
          MaterialButton(
            child: Text('Camera'),
            onPressed: ()=> Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: Text('Gallery'),
            onPressed: ()=> Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      )
    );

    if( imageSource  != null){
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
        builder: (context) =>Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Color(0xaa000000),
          ),
          child: new Builder(
              builder: (context) =>Scaffold(
                appBar:AppBar(
                  title: Text('Event Poster', style:TextStyle(fontFamily:'SF-Pro', color:Colors.white,)),
                  backgroundColor: Color(0xff000000),
                  iconTheme: IconThemeData(
                    color: Colors.white,
                  ),
                ),
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25.0),
                        MaterialButton(
                            color: Colors.white,
                            textColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                            padding : const EdgeInsets.all(16.0),
                            child: Text('Choose Image',style:TextStyle(fontFamily:'SF-Pro',fontWeight:FontWeight.w700)),
                            onPressed: () => _pickImage(context)
                        ),
                        SizedBox(height: 15.0),
                        Hero(
                          tag: 'create_event_poster',
                          child: Container(
                            width: MediaQuery.of(context).size.width ,
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: _imageChosen
                                ? Image(image:FileImage(_pickedImage))
                                : _eventImageUrl == null
                                ? Image.asset('assets/logo.png')
                                : Image.memory(base64Decode(_eventImageUrl)),
                          ),
                          transitionOnUserGestures: true,
                        ),
                        SizedBox(height: 15.0),
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

  void proceedToTickets(){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context){
          return Theme(
            data: Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.white,
              cursorColor: Colors.white,
            ),
            child: new Builder(
              builder: (context) => Scaffold(
                appBar:AppBar(
                  title: Text('Add Ticket Information:', style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,)),
                  backgroundColor: Color(0xff301370),
                  iconTheme: IconThemeData(
                    color:Colors.white,
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize:MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 12,),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top:12.0,left: 8.0),
                            child: Text('Ticket Prices:', style:TextStyle(fontSize: 18))
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Color(0xff301370),
                            accentColor: Color(0xff301370),
                          ),
                          child: new Builder(
                            builder: (context) => Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 70,
                              margin: const EdgeInsets.only(top: 15),
                              child: TextField(
                                controller: _presaleGeneralController,
                                style: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                decoration: InputDecoration(
                                  labelText: 'PreSale General',
                                  labelStyle: TextStyle(
                                    color: Color(0xff301370),
                                    fontFamily: 'SF-Pro',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                    borderSide: BorderSide(color:Color(0xff301370), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff301370)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff301370))
                                  )
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal:true,signed: false),
                              ),
                            ),
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Color(0xff301370),
                            accentColor: Color(0xff301370),
                          ),
                          child: new Builder(
                            builder: (context) => Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 70,
                              margin: const EdgeInsets.only(top: 15),
                              child: TextField(
                                controller: _presaleVIPController,
                                style: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                decoration: InputDecoration(
                                  labelText: 'PreSale VIP',
                                  labelStyle: TextStyle(
                                    color: Color(0xff301370),
                                    fontFamily: 'SF-Pro',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                    borderSide: BorderSide(color:Color(0xff301370), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff301370)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff301370)),
                                  ),
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                              ),
                            ),
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Color(0xff301370),
                            accentColor: Color(0xff301370),
                          ),
                          child: new Builder(
                            builder: (context) => Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 70,
                              margin: const EdgeInsets.only(top: 15),
                              child: TextField(
                                controller: _presaleVVIPController,
                                style: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                decoration: InputDecoration(
                                  labelText: 'PreSale VVIP',
                                  labelStyle: TextStyle(
                                    color: Color(0xff301370),
                                    fontFamily: 'SF-Pro',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                    borderSide: BorderSide(color:Color(0xff301370), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff301370)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff301370)),
                                  ),
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal:true),
                              ),
                            ),
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Color(0xff301370),
                            accentColor: Color(0xff301370),
                          ),
                          child: new Builder(
                            builder: (context) => Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 70,
                              margin: const EdgeInsets.only(top: 15),
                              child: TextField(
                                controller: _gateGeneralController,
                                style: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Gate General',
                                  labelStyle: TextStyle(
                                    color: Color(0xff301370),
                                    fontFamily: 'SF-Pro',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                    borderSide: BorderSide(color:Color(0xff301370), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff301370)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff301370)),
                                  ),
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal:true),
                              ),
                            ),
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Color(0xff301370),
                            accentColor: Color(0xff301370),
                          ),
                          child: new Builder(
                            builder: (context) => Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 70,
                              margin: const EdgeInsets.only(top: 15),
                              child: TextField(
                                controller: _gateVIPController,
                                style: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Gate VIP',
                                  labelStyle: TextStyle(
                                    color: Color(0xff301370),
                                    fontFamily: 'SF-Pro',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                    borderSide: BorderSide(color:Color(0xff301370), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff301370)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff301370)),
                                  ),
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                              ),
                            ),
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Color(0xff301370),
                            accentColor: Color(0xff301370),
                          ),
                          child: new Builder(
                            builder: (context) => Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              height: 70,
                              margin: const EdgeInsets.only(top: 15),
                              child: TextField(
                                controller: _gateVVIPController,
                                style: TextStyle(
                                  color: Color(0xff301370),
                                  fontFamily: 'SF-Pro',
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Gate VVIP',
                                  labelStyle: TextStyle(
                                    color: Color(0xff301370),
                                    fontFamily: 'SF-Pro',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                    borderSide: BorderSide(color:Color(0xff301370), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff301370)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff301370)),
                                  ),
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal:true),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12,),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: const EdgeInsets.only(top:12.0,left: 8.0),
                              child: Text('Ticket Sale Locations:', style:TextStyle(fontSize: 18))
                          ),
                        ),
                        MaterialButton(
                          child: Text('Search'),
                          onPressed: (){
                            //go to search
                            //searchForLocation();
                            addSalesPoints();
                          },
                          color: Colors.black,
                          textColor: Colors.white,
                          elevation: 2
                        ),
                        SizedBox(height: 12.0),
                        _saved.length != 0 ? _createSalesList() : Text('No Locations Chosen',textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro')),
                        SizedBox(height: 8.0),
                        GestureDetector(
                          onTap:(){
                            print('Send data to API and show response');
                            Map<String, dynamic> data;
                            if(eventId == null){

                              data = {
                                "category" : _categoryData.catId,
                                "date" : _selectedDate.toIso8601String(),
                                "name" : _eventNameController.text,
                                "time" : _startTimeController.text,
                                "max_allowed" : _maxAllowedController.text,
                                "about" : _aboutController.text,
                                "theme" : _themeController.text,
                                "tickets": {
                                    "presaleGeneral" : _presaleGeneralController.text,
                                    "presaleVIP" : _presaleVIPController.text,
                                    "presaleVVIP" : _presaleVVIPController.text,
                                    "gateGeneral ": _gateGeneralController.text,
                                    "gateVIP" : _gateVIPController.text,
                                    "gateVVIP" : _gateVVIPController.text,
                                },
                                "sales_points" : _saved.map((item) => item.toJson()).toList(),
                                "location" :  _eventLocationController.text,
                                "poster": _pickedImage == null ? null : base64Encode(_pickedImage.readAsBytesSync())
                              };
                              service.createEvent(data).then((Map<String,dynamic> res){
                                if(res["success"] == 1){
                                  Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                  goToOrganizerMenu();
                                }else{
                                  Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                }
                              }).catchError((err) {
                                  Toast.show(err.toString(), context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                              });
                            }else{

                              data = {
                                "_id" : eventId,
                                "name" : _eventNameController.text,
                                "date" : _dateChosen == null ? _date : _selectedDate.toIso8601String(),
                                "time" : _startTimeController.text,
                                "max_allowed" : _maxAllowedController.text,
                                "about" : _aboutController.text,
                                "theme" : _themeController.text,
                                "category" : _categoryData.catId,
                                "tickets"  : {
                                  "presale_general" : _presaleGeneralController.text,
                                  "presale_vip" : _presaleVIPController.text,
                                  "presale_vvip" : _presaleVVIPController.text,
                                  "gatesale_general" : _gateGeneralController.text,
                                  "gatesale_vip" : _gateVIPController.text,
                                  "gatesale_vvip" : _gateVVIPController.text,
                                },
                                "sales_points" : _saved.map((item) => item.toJson()).toList(),
                                "location" : _eventLocationController.text,
                                "poster" : _pickedImage == null ? null : base64Encode(_pickedImage.readAsBytesSync())
                              };
                              service.updateEvent(data).then((Map<String,dynamic> res){
                                if(res["success"] == 1){
                                  goToOrganizerMenu();
                                  Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                }else if(res["success"] == 0){
                                  Toast.show(res["message"], context, duration : Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                }
                              }).catchError((err) {
                                  Toast.show(err.toString(), context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                            });}
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
          );
        }
      )
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

  Widget _createSalesList(){
    final Iterable<Dismissible> tiles = _saved.map(
        (LocationInformation info){
          return Dismissible(key: Key(info.name),
            onDismissed: (direction){
              setState(() {
                _saved.remove(info);
              });
            },
            child: ListTile(
              title: Text(info.name),
            ),
          );
        }
    );

    final List<Widget> divided = ListTile.divideTiles(tiles: tiles,context:context).toList();
    return ListView(
      children: divided,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );

  }

  /*void searchForLocation(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(BuildContext context){
          return Theme(
            data:Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.white,
              cursorColor: Color(0xff301370)
            ),
            child: new Builder(
              builder: (context) => Scaffold(
                appBar:AppBar(
                  title: Text('Add Ticket Sales Points', style:TextStyle(color:Colors.white,fontFamily:'SF-Pro')),
                  backgroundColor: Color(0xff301370),
                  iconTheme: IconThemeData(
                    color:Colors.white,
                  ),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SearchBar<LocationInformation>(
                      onSearch: service.search,
                      onItemFound: (LocationInformation info, int index){
                        print(info);
                        return ListTile(
                          title: Text(
                            '${info.name}',
                            style:TextStyle(
                              color:info.index == null ? Colors.black : Colors.red[900],
                            ),
                          ),
                          onTap: (){
                            //add item that has been clicked to list
                            setState(() {
                              if(_saved.contains(info.id)){
                                _saved.remove(info);
                              }else{
                                info.index = count;
                                count++;
                                _saved.add(info);
                              }
                            });
                          },
                        );
                      },
                      minimumChars: 2,
                      loader: Center(
                          child:CircularProgressIndicator()
                      ),
                      debounceDuration: Duration(milliseconds: 1000),
                      placeHolder:Center(child:Text('Type a location to search')) ,
                      onError: (error){
                        print(error);
                        return Center(child: Text('Error occured: $error'));
                      },
                      emptyWidget: Center(child: Text('Empty')),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      )
    );
  }*/

  void addSalesPoints(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Color(0xff301370),
            accentColor: Color(0xff301370),
            scaffoldBackgroundColor: Colors.white,
          ),
          child: new Builder(
            builder: (context)=> Scaffold(
              appBar:AppBar(
                title: Text('Add Ticket Sales Points', style:TextStyle(color:Colors.white,fontFamily:'SF-Pro')),
                backgroundColor: Color(0xff301370),
                iconTheme: IconThemeData(
                  color:Colors.white,
                ),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: 70,
                      margin: const EdgeInsets.only(top:15),
                      child: TextField(
                        controller: _salePointNameController,
                        style: TextStyle(
                          color: Color(0xff301370),
                          fontFamily: 'SF-Pro',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Sale Point Name',
                          labelStyle: TextStyle(
                            color: Color(0xff301370),
                            fontFamily: 'SF-Pro',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            borderSide: BorderSide(color: Color(0xff301370), width:1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff301370)),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff301370), width: 2.0)
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      )
                  ),
                  SizedBox(height:10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 70,
                    child: TextField(
                      controller: _salePointTownController,
                      style: TextStyle(
                        color: Color(0xff301370),
                        fontFamily: 'SF-Pro',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Town',
                        labelStyle: TextStyle(
                          color: Color(0xff301370),
                          fontFamily: 'SF-Pro',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          borderSide: BorderSide(color: Color(0xff301370), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff301370)),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color:Color(0xff301370), width: 2.0)
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 70,
                    child: TextField(
                      controller: _salePointPhoneController,
                      style: TextStyle(
                        color: Color(0xff303170),
                        fontFamily: 'SF-Pro',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        labelStyle: TextStyle(
                          color: Color(0xff301370),
                          fontFamily: 'SF-Pro',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          borderSide: BorderSide(color: Color(0xff303170), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff301370)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff301370),width: 2.0),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  RaisedButton(
                      textColor: Colors.white,
                      color: Color(0xffcd5e14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Add'),
                      onPressed: () {

                        //create new location information object and add to _list
                        var loc = new LocationInformation(_salePointNameController.text, _salePointTownController.text, _salePointPhoneController.text);
                        _saved.contains(loc) ? Toast.show('Already added',context,duration:Toast.LENGTH_LONG,gravity:Toast.BOTTOM) : _saved.add(loc);

                        //empty the controllers
                        _salePointNameController.clear();
                        _salePointTownController.clear();
                        _salePointPhoneController.clear();
                      }
                  ),
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}