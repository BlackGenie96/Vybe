import 'package:flutter/material.dart';

class PostsTutorial extends ModalRoute<void>{

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
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xff301370),
                ),
                padding: const EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text('A post can only be about an event or a business.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,)),
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                child: Text('Close'),
                onPressed: ()=> Navigator.pop(context)
              ),
            ]
          )
        ),
      )
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child
      )
    );
  }
}