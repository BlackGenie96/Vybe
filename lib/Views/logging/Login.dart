import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/LoginService.dart';
import 'package:vybe_2/Views/Categories/Categories.dart';
import 'Register.dart';

class Login extends StatefulWidget{
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login>{
  //for saving data
  var _emailController = TextEditingController();
  var _password = TextEditingController();

  //for obscuring and showing the password
  bool _obscureText = true;

  //for showing circular indicator
  bool _loading = false;

  //declaration of login service variable
  LoginService service = new LoginService();

  //Toggles the password show status
  void _toggle(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data : Theme.of(context).copyWith(
        scaffoldBackgroundColor : Color(0xff301370),
        accentColor: Colors.white,
        cursorColor: Colors.white,
      ),
      child: new Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(

                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Image.asset(
                        'assets/logo.png',
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 40,
                      ),
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 70,
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF-Pro',
                        ),
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email Address",
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
                          focusColor: Color(0xffCD5E14),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      width: MediaQuery.of(context).size.width * 0.65,
                      height: 70,
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'SF-Pro',
                        ),
                        controller: _password,
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
                          focusColor: Color(0xffCD5E14),
                          suffixIcon: IconButton(
                            icon: Icon(
                              //Based on the _obscureText choose icon
                              _obscureText ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed:_toggle,
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscureText,
                      ),
                    ),
                    GestureDetector(
                      onTap:(){
                        setState(() => _loading = true);
                        
                        print("Login button has been tapped");
                        service.loginRequest(_emailController.text.trim(), _password.text.trim()).then((Map<String,dynamic> res){
                          
                          setState(() => _loading = false);
                          if(res["success"] == 1){
                            Toast.show(res["message"], context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                            goToCategories();
                          }else{
                            Toast.show(res["message"], context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                          }
                        }).catchError((err){
                          Toast.show(err.toString(), context, duration:Toast.LENGTH_LONG, gravity:Toast.BOTTOM);
                          setState(()=> _loading = false);
                        });
                      },
                      child:Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          color: Color(0xffCD5E14),
                        ),
                        margin: const EdgeInsets.only(
                          top: 30,
                        ),
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: _loading ? CircularProgressIndicator() : Text(
                            'LOGIN',
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
                    SizedBox(height: 10.0),
                    /*GestureDetector(
                      onTap:(){
                        //TODO : implement forgot password for the user.
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Forgot Password \?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'SF-Pro',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),*/
                    GestureDetector(
                      onTap: (){
                        print("Register text view has been tapped.");
                        goToRegister();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 12
                        ),
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
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Functions to handle navigation
  void goToCategories(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context){
          return new MaterialApp(
            home: Scaffold(
              body: Center(
                child: Categories(),
              ),
            ),
          );
        }
      ),
    );
  }

  void goToRegister(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context){
          return new MaterialApp(
            home: Register(),
            theme: ThemeData(
              scaffoldBackgroundColor: Color(0xff301370),
              primaryColor: Colors.white,
              accentColor: Colors.white,
            )
          );
        },
      ),
    );
  }
}