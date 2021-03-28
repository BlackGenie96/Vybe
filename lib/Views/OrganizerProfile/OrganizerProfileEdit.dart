import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/OrganizerProfileService.dart';
import 'package:vybe_2/Models/OrgData.dart';

class OrgProfileEdit extends StatefulWidget{
  final OrgData data;
  OrgProfileEdit({@required this.data});

  @override
  _OrgProfileEditState createState() => new _OrgProfileEditState(data: data);
}

class _OrgProfileEditState extends State<OrgProfileEdit>{

  File _pickedImage;
  var ext;
  OrganizerProfileService service = new OrganizerProfileService();

  final OrgData data;
  _OrgProfileEditState({@required this.data});

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _surnameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  void initialize(OrgData data){
    _nameController.text = data.orgName;
    _surnameController.text = data.orgSurname;
    _emailController.text = data.orgEmail;
    _phoneController.text = data.orgPhoneNum;
  }

  @override
  void initState(){
    super.initState();
    initialize(data);
  }

  void _pickImage(context) async{
    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Change Profile Picture:'),
            actions:<Widget>[
              MaterialButton(
                child: Text('Camera'),
                onPressed: ()=> Navigator.pop(context, ImageSource.camera)
              ),
              MaterialButton(
                child: Text('Gallery'),
                onPressed: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
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

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: new Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Profile Edit: ${data.orgName} ${data.orgSurname}', style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,)),
            backgroundColor: Color(0xff301370),
            iconTheme:IconTheme.of(context).copyWith(
              color: Colors.white,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child:Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap:(){
                        openOrgHero();
                      },
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xff301370), width: 3),
                        ),
                        child: Hero(
                          tag : 'org_profile_edit_hero',
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: _pickedImage == null ? data.profileUrl == null ? AssetImage('assets/logo.png') : MemoryImage(base64Decode(data.profileUrl)) : FileImage(_pickedImage),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    RaisedButton(
                      color: Colors.white,
                      textColor:Colors.black,
                      shape : RoundedRectangleBorder(borderRadius: BorderRadius.circular(70.0)),
                      padding: const EdgeInsets.all(16.0),
                      onPressed: () => _pickImage(context),
                      child: Text('Change Profile Picture',style:TextStyle(fontFamily:'SF-Pro'),textAlign:TextAlign.center),
                    ),
                    SizedBox(height: 17.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 70,
                      child : TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            borderSide : BorderSide(color:Color(0xff301370),width: 1)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide : BorderSide(color:Color(0xff301370),width: 1)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide : BorderSide(color:Color(0xff301370),width: 1.5)
                          ),
                          labelStyle: TextStyle(
                            fontFamily: 'SF-Pro',
                            color: Color(0xff301370)
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          color: Color(0xff301370),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    SizedBox(height: 17.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 70,
                      child : TextFormField(
                        controller: _surnameController,
                        decoration: InputDecoration(
                          labelText: 'Surname',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide : BorderSide(color:Color(0xff301370),width: 1)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide : BorderSide(color:Color(0xff301370),width: 1)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide : BorderSide(color:Color(0xff301370),width: 1.5)
                          ),
                          labelStyle: TextStyle(
                              fontFamily: 'SF-Pro',
                              color: Color(0xff301370)
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          color: Color(0xff301370),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    SizedBox(height: 17.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 70,
                      child : TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide : BorderSide(color:Color(0xff301370),width: 1)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide : BorderSide(color:Color(0xff301370),width: 1)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide : BorderSide(color:Color(0xff301370),width: 1.5)
                          ),
                          labelStyle: TextStyle(
                              fontFamily: 'SF-Pro',
                              color: Color(0xff301370)
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          color: Color(0xff301370),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 17.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 70,
                      child : TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide : BorderSide(color:Color(0xff301370),width: 1)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide : BorderSide(color:Color(0xff301370),width: 1)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7.0),
                              borderSide : BorderSide(color:Color(0xff301370),width: 1.5)
                          ),
                          labelStyle: TextStyle(
                              fontFamily: 'SF-Pro',
                              color: Color(0xff301370)
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          color: Color(0xff301370),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(height: 27.0),
                    GestureDetector(
                      onTap:(){
                        print('Update org profile');
                        Map<String,dynamic> data;
                        if(_pickedImage == null){
                          data = {
                            "org_name" : _nameController.text,
                            "org_surname": _surnameController.text,
                            "org_email" : _emailController.text,
                            "org_phone_num" : _phoneController.text
                          };
                        }else{
                          data = {
                            "org_name" : _nameController.text,
                            "org_surname": _surnameController.text,
                            "org_email" : _emailController.text,
                            "org_phone_num" : _phoneController.text,
                            "org_image" : base64Encode(_pickedImage.readAsBytesSync()),
                            "ext" : ext.toString()
                          };
                        }

                        service.updateProfileInfo(data).then((Map<String,dynamic> res){
                          print(res);
                          if(res["success"] == 1){
                            Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                            Navigator.pop(context);
                          }else{
                            Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                          }
                        }).catchError((err){
                          Toast.show(err.toString(), context, duration:Toast.LENGTH_LONG, gravity:Toast.BOTTOM);
                        });
                      },
                      child:Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
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
                                fontFamily: 'SF-Pro',
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),
            ),
          ),
        ),
      )
    );
  }

  void openOrgHero(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.black,
          ),
          child: new Builder(
            builder: (context) => new Scaffold(
              appBar: AppBar(
                title: Text('Profile Picture',style:TextStyle(fontFamily: 'SF-Pro',color:Colors.white,)),
                backgroundColor: Colors.black,
                iconTheme: IconTheme.of(context).copyWith(
                  color: Colors.white,
                ),
              ),
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 5.0),
                        Hero(
                          tag: 'org_profile_edit_hero',
                          child: Container(
                            width : MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: _pickedImage == null ? data.profileUrl == null ? Image.asset('assets/logo.png') : Image.memory(base64Decode(data.profileUrl)) : Image.file(_pickedImage),
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ),
        ),
      )
    );
  }
}