import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/SuggestionsService.dart';

class AddUserSuggestion extends StatefulWidget{

  @override
  _AddUserSuggestionState createState() => new _AddUserSuggestionState();
}

class _AddUserSuggestionState extends State<AddUserSuggestion>{

  SuggestionsService service = new SuggestionsService();
  TextEditingController message = new TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        accentColor: Color(0xff301370),
      ),
      child: new Builder(
        builder: (context) => new Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff301370),
            title: Text(
              'Add your suggestion',
              style: TextStyle(
                fontFamily: 'SF-Pro',
                color: Colors.white,
              ),
            ),
            iconTheme: IconTheme.of(context).copyWith(
              color:Colors.white,
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            controller: message,
                            decoration: InputDecoration(
                              labelText: 'Suggestion',
                              labelStyle: TextStyle(
                                fontFamily: 'SF-Pro',
                                color:Color(0xff301370),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color:Color(0xff301370), width: 1.5,),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color:Color(0xff301370), width : 2.5,),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        MaterialButton(
                            child: _loading ? CircularProgressIndicator() : Text(
                              'Submit',
                              style: TextStyle(fontFamily:'SF-Pro'),
                              textAlign:TextAlign.center,
                            ),
                            color: Color(0xffcd5e14),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            padding: const EdgeInsets.all(16.0),
                            onPressed: (){
                              setState(() {
                                _loading = true;
                              });
                              service.addSuggestion(message: message.text.trim()).then(
                                      (Map<String,dynamic> res){
                                    setState(() {
                                      _loading = false;
                                    });
                                    if(res["success"] == 1){
                                      message.clear();
                                      Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                    }else{
                                      Toast.show(res["message"], context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                    }
                                  }
                              ).catchError(
                                      (err) => print(err.toString)
                              );
                            }
                        ),
                      ]
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}