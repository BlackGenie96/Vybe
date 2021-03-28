import 'package:flutter/material.dart';

class CategoryOverlay extends ModalRoute<void>{

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildBody(context)
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child
      ),
    );
  }

  Widget _buildBody(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.new_releases,
          color: Colors.white,
          size: 80,
        ),
        SizedBox(height:15.0),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xff301370),
          ),
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.all(16.0),
          child: Text('Choose Category: Select a category that will controll what events and business profiles you will be able to view',textAlign:TextAlign.center,style:TextStyle(color:Colors.white)),
        ),
        SizedBox(height: 15.0),
        RaisedButton(
            child: Text('Close'),
            onPressed: () => Navigator.pop(context)
        ),
      ]
  );
}