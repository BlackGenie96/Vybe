import 'package:flutter/material.dart';

class CalendarOverlay extends ModalRoute<void>{

  var state = "Date";

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

    print(state);
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child : state == "Date" ? _buildDateOverlayContent(context)
              : state == "List" ? _buildCalendarListOverlayContent(context)
              : state == "Minimize" ? _buildMinimizeMapOverlayContent(context)
              : state == "Maximize" ? _buildMaximizeCalendarOverlayContent(context)
              : RaisedButton(
          child: Text('Dismiss'),
          onPressed: ()=> Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child){
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child
      ),
    );
  }

  ///Defining the tutorial widget configurations.
  Widget _buildDateOverlayContent(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xff301370),
        ),
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.all(16.0),
        child: Text('Date : Click on the date that has events on it and they will be listed below.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,)),
      ),
      SizedBox(height: 15.0),
      RaisedButton(
        child: Text('Next'),
        onPressed: (){
          state = "List";
          changedExternalState();
        },
      ),
      SizedBox(height: 10.0),
      RaisedButton(
        child: Text('Dismiss'),
        onPressed: ()=> Navigator.pop(context),
      ),
      SizedBox(height: MediaQuery.of(context).size.height *0.05),
    ],
  );

  Widget _buildCalendarListOverlayContent(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xff301370),
        ),
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.all(16.0),
        child: Text('Click on a calendar list item and be taken to it\'s profile.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,)),
      ),
      SizedBox(height: 15.0),
      RaisedButton(
          child: Text('Next'),
          onPressed:(){
            state = "Minimize";
            changedExternalState();
          },
      ),
      SizedBox(height: 10.0),
      RaisedButton(
        child: Text('Dismiss'),
        onPressed: ()=> Navigator.pop(context)
      ),
    ],
  );

  Widget _buildMinimizeMapOverlayContent(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment : CrossAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.arrow_upward,
        color: Colors.white,
        size: 60,
      ),
      SizedBox(height: 10.0),
      Icon(
        Icons.touch_app,
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
        child: Text('Swipe up on the calendar to minimize',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,)),
      ),
      SizedBox(height:15),
      RaisedButton(
        child: Text('Next'),
        onPressed:(){
          state = "Maximize";
          changedExternalState();
        },
      ),
      SizedBox(height:10.0),
      RaisedButton(
        child:Text('Dismiss'),
        onPressed: () => Navigator.pop(context)
      ),
    ]
  );

  Widget _buildMaximizeCalendarOverlayContent(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.arrow_downward,
        color: Colors.white,
        size: 60,
      ),
      SizedBox(height: 10.0),
      Icon(
        Icons.touch_app,
        color:Colors.white,
        size : 80
      ),
      SizedBox(height: 15.0),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xff301370),
        ),
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text('Swipe down on the calendar to maximize its view.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,)),
      ),
      SizedBox(height: 15.0),
      RaisedButton(
        child: Text('Finish'),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}