import 'package:flutter/material.dart';
import 'package:vybe_2/Data/RegisterService.dart';
import 'package:vybe_2/Views/Categories/Categories.dart';
import 'package:vybe_2/Views/logging/Login.dart';
import 'package:vybe_2/Views/utils.dart';
import 'package:toast/toast.dart';

class Register extends StatefulWidget{
  @override
  _RegisterState createState() => new _RegisterState();
}

class _RegisterState extends State<Register>{

  //controllers for the text field inputs
  var nameController = TextEditingController();
  var surnameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();

  //password obscure text as well as confirm password widget
  bool _passwordVisible = true;
  bool _confirmVisible = true;
  bool loading = false;

  //declare service class
  RegisterService service = new RegisterService();

  //declare utils class to display loading dialog
  Utils utils = new Utils();

  //methods to handle showing and hiding of passwords
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

  @override
  Widget build(BuildContext context){
    return new Theme(
      data : Theme.of(context).copyWith(
        scaffoldBackgroundColor: Color(0xff301370),
        cursorColor: Colors.white,
        accentColor: Colors.white,
        primaryColor: Colors.white,
      ),
      child: new Builder(
        builder: (context) => new Scaffold(
          body:SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                          top: 15,
                        ),
                        //Container to carry the image asset of the avatar
                        //should allow user to select profile picture from tapping on the imageview
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: 150,
                        child: Center(
                          child: Image.asset('assets/logo.png'),
                        )
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Create',textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,fontWeight:FontWeight.w100,fontSize:30)),
                            Text('Account',textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,fontWeight:FontWeight.w700,fontSize:30)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: const EdgeInsets.only(top:6),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15,),
                        width: MediaQuery.of(context).size.width* 0.65,
                        height: 70,
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
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
                            labelStyle: TextStyle(
                              fontFamily: 'SF-Pro',
                              color:Colors.white,
                            ),
                            hintStyle: TextStyle(
                              fontFamily: 'SF-Pro',
                              color: Colors.white,
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            color: Colors.white,
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
                            labelStyle: TextStyle(
                              fontFamily: 'SF-Pro',
                              color:Colors.white,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            color: Colors.white,
                          ),
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15,),
                        width: MediaQuery.of(context).size.width* 0.65,
                        height: 70,
                        child: TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
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
                            labelStyle: TextStyle(
                              fontFamily: 'SF-Pro',
                              color:Colors.white,
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(signed:true),
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            color: Colors.white,
                          ),
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
                            labelStyle: TextStyle(
                              fontFamily: 'SF-Pro',
                              color:Colors.white,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            color: Colors.white,
                          ),
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15,),
                        width: MediaQuery.of(context).size.width* 0.65,
                        height: 70,
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: _passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
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
                            labelStyle: TextStyle(
                              fontFamily: 'SF-Pro',
                              color:Colors.white,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed:_togglePassword,
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            color: Colors.white,
                          ),
                        )
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15,),
                        width: MediaQuery.of(context).size.width* 0.65,
                        height: 70,
                        child: TextFormField(
                          controller: confirmController,
                          obscureText: _confirmVisible,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
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
                            labelStyle: TextStyle(
                              fontFamily: 'SF-Pro',
                              color:Colors.white,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _confirmVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed:_toggleConfirm,
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            color: Colors.white,
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() => loading = true);
                        print("Create Account has been clicked.");

                        service.registerRequest(
                            nameController.text.trim(),
                            surnameController.text.trim(),
                            phoneController.text.trim(),
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            confirmController.text.trim()).then((Map<String,dynamic> res){
                          //check for the result and handle accordingly.
                          setState(() => loading = false);
                          if(res["success"] == 2){
                            Toast.show(res["message"],context, duration: Toast.LENGTH_LONG, gravity:Toast.BOTTOM);
                          }else if(res["success"] == 1){
                            Toast.show(res["message"], context, duration:Toast.LENGTH_LONG, gravity:Toast.BOTTOM);
                            //registration successful. Go to the next screen
                            goToCategories();
                          }else{
                            Toast.show(res["message"], context, duration:Toast.LENGTH_LONG, gravity:Toast.BOTTOM);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                        ),
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffcd5e1f),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 11),
                          child: Text(
                            'Create Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'SF-Pro',
                              color : Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        print('Go to Login has been clicked from user registration.');
                        goToLogin();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 30, bottom:20, ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Already have an account\? ', textAlign: TextAlign.center,style: TextStyle(fontFamily: 'SF-Pro',color:Color(0xffcd5e14))),
                              Text('Login', textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro',color: Colors.white),)
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

  void goToCategories(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context){
          return new MaterialApp(
            home: Categories(),
            theme: ThemeData(
              scaffoldBackgroundColor: Color(0xffeeeeee),
              accentColor: Colors.white,
            )
          );
        }
      ),
    );
  }

  void goToLogin(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context){
          return new MaterialApp(
            home: Login(),
            theme: ThemeData(
              scaffoldBackgroundColor: Color(0xff301370),
              accentColor: Colors.white,
            ),
          );
        }
      )
    );
  }
}