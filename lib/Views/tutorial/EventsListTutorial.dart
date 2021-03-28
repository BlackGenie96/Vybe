import 'package:flutter/material.dart';

class EventListTutorial extends ModalRoute<void>{
  var state = "show";   //TODO : handle later and make sure that the settings handle this functionality

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
        child: _buildListOverlayContent(context)
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child
      ),
    );
  }

  Widget _buildListOverlayContent(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.new_releases,
        color: Colors.white,
        size: 80,
      ),
      SizedBox(height: 15.0),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xff301370),
        ),
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text('Events Profile : Events listed from top to bottom based on its rating',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,)),
      ),
      SizedBox(height: 15.0),
      RaisedButton(
        child: Text('Close'),
        onPressed:()=> Navigator.pop(context),
      ),
    ]
  );
}

class EventProfileTutorial extends ModalRoute<void>{
  var state = "";

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
        child: _buildRatingsOverlayContent(context),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation ,
      child: ScaleTransition(
        scale: animation,
        child: child
      ),
    );
  }

  Widget _buildRatingsOverlayContent(BuildContext context) => Stack(
    children: <Widget>[
      Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        left: MediaQuery.of(context).size.width * 0.45,
        child: Icon(
          Icons.new_releases,
          color: Colors.white,
          size: 80,
        ),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height * 0.55,
        left: MediaQuery.of(context).size.width * 0.45,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xff301370)
          ),
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text('Rating: To add a rating click on the Add Icon on the right of the stars.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,))
        ),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height * 0.65,
        left: MediaQuery.of(context).size.width * 0.45,
        child: RaisedButton(
          child:Text('Close'),
          onPressed: ()=> Navigator.pop(context)
        ),
      ),
    ],
  );
}