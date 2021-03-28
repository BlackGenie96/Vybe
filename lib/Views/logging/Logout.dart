import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/LoginService.dart';
import 'package:vybe_2/Models/UserData.dart';
import 'package:vybe_2/Views/logging/Login.dart';

class Logout extends StatefulWidget{
  @override
  _LogoutState createState() => new _LogoutState();
}

class _LogoutState extends State<Logout>{

  LoginService service = new LoginService();
  UserData _user;

  @override
  void initState(){
    super.initState();
    service.getUserData().then((UserData data){
      setState(() {
        _user = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Logout', style:TextStyle(fontFamily:'SF-Pro',color:Colors.white)),
        backgroundColor: Color(0xff301370),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child:Container(
              width: MediaQuery.of(context).size.width,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize : MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top:20),
                    child:Padding(
                      padding: const EdgeInsets.all(12.0),
                      child:Text(
                        '${_user.username} ${_user.surname}, are you sure you want to logout ?',
                        textAlign: TextAlign.center,
                        style:TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      var res;
                      service.logoutUser(userId: _user.userId).then((bool _loggedOut){
                        res = _loggedOut;
                      });

                      if(res){
                        Toast.show('Please exit the app to login again.',context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => MaterialApp(
                                  home: Login(),
                                )
                            )
                        );
                      }else{
                        Toast.show('There was a problem logging out. Please try again.', context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      }

                    },
                    child:Container(
                      decoration: BoxDecoration(
                          color: Color(0xffcd5e14),
                          borderRadius: BorderRadius.all(Radius.circular(50.0))
                      ),
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.4,
                      height : 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      print('back to home menu');
                      Navigator.of(context).pop();
                    },
                    child:Container(
                      decoration: BoxDecoration(
                          color: Color(0xff000000),
                          borderRadius: BorderRadius.all(Radius.circular(50.0))
                      ),
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.4,
                      height : 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontSize: 20,
                            color: Colors.white,
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
      ),
    );
  }
}