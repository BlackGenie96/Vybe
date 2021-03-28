import 'package:flutter/material.dart';
import 'package:vybe_2/Data/OrganizerProfileService.dart';
import 'package:vybe_2/Views/OrganizerProfile/OrganizerLogin.dart';
import 'OrganizerMenu.dart';
import 'package:toast/toast.dart';


class OrganizerRegister extends StatefulWidget{
  @override
  _OrganizerRegisterState createState() => new _OrganizerRegisterState();
}

class _OrganizerRegisterState extends State<OrganizerRegister>{

  //controllers for textFields
  var _nameController = TextEditingController();
  var _surnameController = TextEditingController();
  var _emailController = TextEditingController();
  var _phoneNumberController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmController = TextEditingController();

  //handle the visibility of passwords
  bool _passwordVisible = true;
  bool _confirmVisible = true;
  bool _loading = false;

  OrganizerProfileService service = new OrganizerProfileService();

  void _togglePassword(){
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _toggleConfirm(){
    setState(() {
      _confirmVisible = !_confirmVisible;
    });
  }

  Widget build(BuildContext context){
    return new Theme(
      data : Theme.of(context).copyWith(
        scaffoldBackgroundColor: Color(0xff301370),
        cursorColor: Colors.white,
        accentColor : Colors.white,
        primaryColor: Colors.white,
      ),
      child : new Builder(
        builder : (context) => Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child:Container(
                decoration: BoxDecoration(
                  color: Color(0xff301370),
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only( top: 10),
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height* 0.35,
                      child: Image.asset('assets/logo.png'),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Organizer ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SF-Pro',
                                fontWeight: FontWeight.w100,
                                color: Colors.white,
                                fontSize: 35,
                              ),
                            ),
                            Text(
                              'Register',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'SF-Pro',
                                fontWeight: FontWeight.w700,
                                fontSize: 35,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 40,
                      ),
                      width: MediaQuery.of(context).size.width *0.75,
                      height: 70,
                      child : TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF-Pro',
                        ),
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
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
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      width: MediaQuery.of(context).size.width *0.75,
                      height: 70,
                      child : TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF-Pro',
                        ),
                        controller: _surnameController,
                        decoration: InputDecoration(
                          labelText: 'Surname',
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
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      width: MediaQuery.of(context).size.width *0.75,
                      height: 70,
                      child : TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF-Pro',
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
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      width: MediaQuery.of(context).size.width *0.75,
                      height: 70,
                      child : TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF-Pro',
                        ),
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
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
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      width: MediaQuery.of(context).size.width *0.75,
                      height: 70,
                      child : TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF-Pro',
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
                          suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: _togglePassword
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      width: MediaQuery.of(context).size.width *0.75,
                      height: 70,
                      child : TextField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF-Pro',
                        ),
                        controller: _confirmController,
                        obscureText: _confirmVisible,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: _toggleConfirm,
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        color: Color(0xffcd5e14),
                      ),
                      margin: const EdgeInsets.only(top: 30,),
                      width: MediaQuery.of(context).size.width * 0.55,
                      height: 50,
                      child: Padding(
                        padding : const EdgeInsets.only(top: 15,),
                        child: GestureDetector(
                          onTap: (){
                            setState(() => _loading = true);
                            service.registerRequest(_nameController.text, _surnameController.text, _emailController.text, _phoneNumberController.text,_passwordController.text, _confirmController.text).then(
                                (int res){
                                  setState(() => _loading = false);

                                  if(res == 0){
                                    Toast.show('Passwords do not match',context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                  }else if(res == 1){
                                    Toast.show("Registration Successful.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                    goToOrganizerHome();
                                  }else{
                                    Toast.show("Registration not successful.",context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                  }
                                }
                            );
                          },
                          child: Text(
                            'Register',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'SF-Pro',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top : 12,),
                      child: GestureDetector(
                        onTap: (){
                          goToOrganizerLogin();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Already have an account\?', textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro',color: Colors.white),),
                              Text('Login',textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro',color: Color(0xffcd5e14))),
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

  void goToOrganizerHome(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context){
          return new MaterialApp(
            home: OrganizerMenu(),
            theme: ThemeData(
              scaffoldBackgroundColor: Color(0xff301370),
              accentColor: Colors.white,
              primaryColor: Colors.white,
            ),
          );
        }
      )
    );
  }

  void goToOrganizerLogin(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context){
          return OrganizerLogin();
        }
      )
    );
  }
}