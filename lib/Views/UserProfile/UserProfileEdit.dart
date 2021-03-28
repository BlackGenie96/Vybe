import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:vybe_2/Data/UserProfileService.dart';
import 'package:vybe_2/Models/UserData.dart';

class UserProfileEdit extends StatefulWidget{
  final UserData data;
  UserProfileEdit({this.data});

  @override
  _UserProfileEditState createState() => new _UserProfileEditState(data:data);
}

class _UserProfileEditState extends State<UserProfileEdit>{

  final UserData data;
  _UserProfileEditState({this.data});

  TextEditingController nameController = new TextEditingController();
  TextEditingController surnameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();

  File _pickedImage;
  var ext;
  UserProfileService service = new UserProfileService();

  //creates a dialog view for selecting an image resource.
  void _pickImage() async{
    final imageSource = await showDialog<ImageSource>(
        context: context  ,
        builder: (context) =>
            AlertDialog(
              title: Text('Change Profile Picture:'),
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

  void populateTextController({UserData data}){
    nameController.text = data.username;
    surnameController.text = data.surname;
    emailController.text = data.email;
    numberController.text = data.phone;
  }

  @override
  void initState(){
    super.initState();
    populateTextController(data: data);
  }

  @override
  Widget build(BuildContext context){
    return Theme(
      data : Theme.of(context).copyWith(
        cursorColor:Color(0xff301370),
        scaffoldBackgroundColor: Colors.white,
      ),
      child: new Builder(
        builder : (context) => new Scaffold(
          appBar: AppBar(
            title: Text('Edit: ${data.username} ${data.surname}', style:TextStyle(fontFamily:'Raleway',color:Colors.white)),
            backgroundColor: Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color:Colors.white,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff301370),
                          width: 3
                        ),
                        shape: BoxShape.circle,
                      ),
                      margin: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: GestureDetector(
                        onTap:() => _goToProfilePic(context:context, data:data),
                        child:Hero(
                          tag: 'user_profile_hero',
                          child: CircleAvatar(
                              backgroundImage: _pickedImage == null ? data.profile == null ? AssetImage('assets/logo.png') : MemoryImage(base64Decode(data.profile)) : FileImage(_pickedImage),
                              backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      width: 140,
                      height: 140,
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: (){
                        _pickImage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Change Profile Picture',style:TextStyle(color: Colors.white,fontSize: 20))
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15,),
                        width: MediaQuery.of(context).size.width* 0.65,
                        height: 70,
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(color: Color(0xff301370),width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:BorderSide(color:Color(0xff301370))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:BorderSide(color:Color(0xff301370))
                            ),
                            labelStyle: TextStyle(
                              fontFamily: 'Raleway',
                              color:Color(0xff301370),
                            ),
                            hintStyle: TextStyle(
                              fontFamily: 'Raleway',
                              color: Color(0xff301370),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Color(0xff301370),
                          ),
                          keyboardType: TextInputType.text,
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15,),
                        width: MediaQuery.of(context).size.width* 0.65,
                        height: 70,
                        child: TextFormField(
                          controller: surnameController,
                          decoration: InputDecoration(
                            labelText: 'Surname',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(color: Color(0xff301370),width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide:BorderSide(color:Color(0xff301370))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:BorderSide(color:Color(0xff301370))
                            ),
                            labelStyle: TextStyle(
                              fontFamily: 'Raleway',
                              color:Color(0xff301370),
                            ),
                            hintStyle: TextStyle(
                              fontFamily: 'Raleway',
                              color: Color(0xff301370),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Color(0xff301370),
                          ),
                          keyboardType: TextInputType.text,
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15,),
                        width: MediaQuery.of(context).size.width* 0.65,
                        height: 70,
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(color: Color(0xff301370),width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide:BorderSide(color:Color(0xff301370))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:BorderSide(color:Color(0xff301370))
                            ),
                            labelStyle: TextStyle(
                              fontFamily: 'Raleway',
                              color:Color(0xff301370),
                            ),
                            hintStyle: TextStyle(
                              fontFamily: 'Raleway',
                              color: Color(0xff301370),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Color(0xff301370),
                          ),
                          keyboardType: TextInputType.text,
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15,),
                        width: MediaQuery.of(context).size.width* 0.65,
                        height: 70,
                        child: TextFormField(
                          controller: numberController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(color: Color(0xff301370),width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide:BorderSide(color:Color(0xff301370))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:BorderSide(color:Color(0xff301370))
                            ),
                            labelStyle: TextStyle(
                              fontFamily: 'Raleway',
                              color:Color(0xff301370),
                            ),
                            hintStyle: TextStyle(
                              fontFamily: 'Raleway',
                              color: Color(0xff301370),
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Color(0xff301370),
                          ),
                          keyboardType: TextInputType.text,
                        )
                    ),
                    GestureDetector(
                      onTap:(){
                        print('Update user profile');
                        service.updateProfileInfo(
                            name: nameController.text.trim(),
                            surname: surnameController.text.trim(),
                            email:emailController.text.trim(),
                            phone: numberController.text.trim(),
                            image:_pickedImage,
                            ext:ext).then((res){
                              print(res);
                          goToHome();
                        });
                      },
                      child:Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        height: MediaQuery.of(context).size.height * 0.09,
                        width: MediaQuery.of(context).size.width *0.65,
                        margin: const EdgeInsets.only(top:15, bottom: 15.0),
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
                              'Update Profile',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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

  void goToHome(){
    Navigator.of(context).pop();
  }

  //handle hero image click
  void _goToProfilePic({BuildContext context, UserData data}){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) => Theme(
            data: Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.black,
              primaryColor:Colors.white,
              accentColor: Colors.white,
            ),
            child: new Builder(
              builder: (context) => new Scaffold(
                appBar: AppBar(
                  title: Text('Profile Picture',style:TextStyle(fontFamily:'Raleway',color:Colors.white)),
                  backgroundColor:Colors.black,
                ),
                body: Center(
                    child: Hero(
                      tag: 'user_profile_hero',
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child : _pickedImage == null ? data.profile == null ? Image.asset('assets/logo.png') : Image.memory(base64Decode(data.profile)) : Image.file(_pickedImage)

            ),
                    )
                ),
              ),
            )
        ),
      ),
    );
  }
}