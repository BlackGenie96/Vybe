import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/OrganizerProfileService.dart';
import 'package:vybe_2/Views/OrganizerProfile/OrganizerRegister.dart';
import 'package:vybe_2/Views/OrganizerProfile/OrganizerMenu.dart';

class OrganizerLogin extends StatefulWidget{
  @override
  _OrganizerLoginState createState() => new _OrganizerLoginState();
}


class _OrganizerLoginState extends State<OrganizerLogin>{

  //controller variables
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  //handles the visibility of password
  bool _passwordVisible = true;
  bool _loading = false;

  OrganizerProfileService service = new OrganizerProfileService();

  void _togglePassword() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context){
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Color(0xff301370),
        cursorColor: Colors.white,
        accentColor: Colors.white,
      ),
      child: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Image.asset('assets/logo.png'),
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Organizer',style:TextStyle(fontFamily:'SF-Pro',fontWeight:FontWeight.w100,fontSize:35,color:Colors.white,)),
                          Text(' Login',style:TextStyle(fontFamily:'SF-Pro',fontWeight:FontWeight.w700,fontSize:35,color:Colors.white,)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top:40),
                      width: MediaQuery.of(context).size.width *0.75,
                      height: 70,
                      child: TextFormField(
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          color: Colors.white,
                        ),
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(
                              fontFamily: 'SF-Pro',
                              color: Colors.white,
                            ),
                            border:OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(color: Colors.white, width:0.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(color: Colors.white, width:0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(color: Colors.white, width:2),
                            ),
                            focusColor: Color(0xffcd5e14)
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top:20),
                      width: MediaQuery.of(context).size.width *0.75,
                      height: 70,
                      child: TextFormField(
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          color: Colors.white,
                        ),
                        controller: _passwordController,
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontFamily: 'SF-Pro',
                            color: Colors.white,
                          ),
                          border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            borderSide: BorderSide(color: Colors.white, width:0.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            borderSide: BorderSide(color: Colors.white, width:0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            borderSide: BorderSide(color: Colors.white, width:2),
                          ),
                          focusColor: Color(0xffcd5e14),
                          suffixIcon: IconButton(
                            icon : Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed:_togglePassword,
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (val) => val.length < 6 ? 'Password too short.' : null,
                      ),
                    ),
                    GestureDetector(
                      onTap:(){
                        print("Organizer login button has been clicked.");
                        setState(()=> _loading = true);
                        service.organizerLogin(_emailController.text.trim(), _passwordController.text.trim()).then((Map<String,dynamic> res){

                          setState(() => _loading = false);
                          if(res["success"] == 1){
                            Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                            goToOrganizerMenu();
                          }else{
                            Toast.show(res["message"], context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                          }
                        }).catchError((err) => Toast.show(err.toString(), context, duration: Toast.LENGTH_LONG, gravity:Toast.BOTTOM));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          color: Color(0xffcd5e14),
                        ),
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 50,
                        margin: const EdgeInsets.only(top: 25),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'SF-Pro',
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height : 12),
                    /*GestureDetector(
                      onTap:(){
                        //TODO : implement forgot password functionality.
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child : Text(
                            'Forgot Password \?',
                            textAlign: TextAlign.center,
                            style:TextStyle(
                              fontFamily: 'SF-Pro',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),*/
                    Container(
                      margin: const EdgeInsets.only(
                          top: 12
                      ),
                      child: GestureDetector(
                        onTap: (){
                          print("Register text view has been tapped.");
                          goToRegister();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Don\'t have an account\? ', textAlign: TextAlign.center,style: TextStyle(fontFamily: 'SF-Pro',color:Colors.white),),
                              Text('Register', textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro',color:Color(0xffcd5e14)),)
                            ],
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
      ),
    );
  }

  //go to the Register Organizer Activity
  void goToRegister() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context){
          return OrganizerRegister();
        }
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
}