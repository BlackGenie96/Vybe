import 'package:flutter/material.dart';

class Utils{

  //cross platform dialog for when awaiting.
  void showLoadingDialog(context){
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: <Widget>[
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left:5),child:Text('Loading')),
        ],
      ),
    );

    showDialog(
      barrierDismissible: false,
      context : context,
      builder: (context){
        return alert;
      }
    );

  }
}