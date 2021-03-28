import 'package:flutter/material.dart';

class TutorialOverlay extends ModalRoute<void>{

  //local variables
  var state = "Search";

  @override
  Duration get transitionDuration => Duration(milliseconds : 500);

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
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ){
    //This makes sure that text and other content follows the material style
    print(state);
    return Material(
      type: MaterialType.transparency,
      child : SafeArea(
        child: state == "Search" ? _buildSearchOverlayContext(context)
            : state == "Feed" ? _buildFeedOverlayContent(context)
            : state == "Calendar" ? _buildCalendarOverlayContent(context)
            : state == "Events" ? _buildEventOverlay(context)
            : state == "Places" ? _buildPlaceOverlayContent(context)
            : state == "User Profile" ? _buildUserProfileOverlayContent(context)
            : state == "Manager" ? _buildManagerOverlayContent(context)
            : state == "Map" ? _buildMapOverlayContent(context)
            : state == "Logout" ? _buildLogoutOverlayContent(context)
            : state == "Category" ? _buildCategoryOverlayContent(context)
            : state == "Post" ? _buildPostOverlayContent(context)
            : state == "Notifications" ? _buildNotificationsOverlayContent(context)
            : RaisedButton(
            child: Text('Dismiss'),
            onPressed : ()=> Navigator.pop(context)
        ),
      ),
    );
  }

  Widget _buildSearchOverlayContext(BuildContext context) => Column(
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
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: Color(0xff301370),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Text('Search: Use an event, business or product name to quickly find the information you are looking for.',textAlign: TextAlign.center,style:TextStyle(color: Colors.white)),
      ),
      SizedBox(height: 15.0),
      RaisedButton(
        child: Text('Next'),
        onPressed: () {
          state = "Feed";
          print("State is now $state");
          changedExternalState();
        }
      ),
      SizedBox(height:10),
      RaisedButton(
        child: Text('Dismiss'),
        onPressed: () => Navigator.pop(context)
      ),
    ],
  );

  Widget _buildFeedOverlayContent(BuildContext context){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:<Widget>[
          Icon(
            Icons.new_releases,
            color: Colors.white,
            size:80,
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Color(0xff301370),
                borderRadius:BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child : Text('Feed : View posts made by the Managers or other Vybe users',style:TextStyle(color:Colors.white,),textAlign: TextAlign.center,)
          ),
          RaisedButton(
              onPressed : (){
                state = "Calendar";
                print("State is now $state");
                changedExternalState();
                //Navigator
              },
              child: Text('Next')
          ),
          RaisedButton(
              onPressed: ()=> Navigator.pop(context),
              child: Text('Dismiss')
          ),
        ],
    );
  }

  Widget _buildCalendarOverlayContent(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.new_releases,
          color: Colors.white,
          size:80,
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
              color: Color(0xff301370),
              borderRadius:BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16.0),
            child : Text('Calendar : View events created by the Managers in calendar view.',style:TextStyle(color:Colors.white,),textAlign: TextAlign.center,)
        ),
        RaisedButton(
            onPressed : (){
              state = "Events";
              print("State is now $state");
              changedExternalState();
              //Navigator
            },
            child: Text('Next')
        ),
        RaisedButton(
            onPressed: ()=> Navigator.pop(context),
            child: Text('Dismiss')
        )
      ],
    );
  }

  Widget _buildEventOverlay(BuildContext context){
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.new_releases,
            color: Colors.white,
            size:80,
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Color(0xff301370),
                borderRadius:BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child : Text('Events Profile : View event profile\'s with events under your chosen category displayed.',style:TextStyle(color:Colors.white,),textAlign: TextAlign.center,)
          ),
          RaisedButton(
              onPressed : (){
                state = "Places";
                print("State is now $state");
                changedExternalState();
                //Navigator
              },
              child: Text('Next')
          ),
          RaisedButton(
              onPressed: ()=> Navigator.pop(context),
              child: Text('Dismiss')
          )
        ]
    );
  }

  Widget _buildPlaceOverlayContent(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.new_releases,
        color: Colors.white,
        size: 80,
      ),
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xff301370)
        ),
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.all(16.0),
        child: Text('Business\'s Profile: View business profiles based on the category you have picked.',style:TextStyle(color:Colors.white),textAlign: TextAlign.center,),
      ),
      RaisedButton(
        child: Text('Next'),
        onPressed: (){
          state = "User Profile";
          changedExternalState();
        },
      ),
      RaisedButton(
        child: Text('Dismiss'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  );

  Widget _buildUserProfileOverlayContent(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.new_releases,
          color:Colors.white,
          size: 80,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xff301370),
          ),
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.all(16.0),
          child: Text('Profile : View and/or edit you contact information for Managers.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,)),
        ),
        RaisedButton(
          child: Text('Next'),
          onPressed: (){
            state = "Manager";
            changedExternalState();
          },
        ),
        RaisedButton(
          child: Text('Dismiss'),
          onPressed: ()=> Navigator.pop(context),
        ),
      ]
  );

  Widget _buildManagerOverlayContent(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.new_releases,
        color: Colors.white,
        size: 80,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xff301370),
        ),
        width :MediaQuery.of(context).size.width * 0.6,
        padding : const EdgeInsets.all(16.0),
        child:Text('Manager Profile : create your own events or add your products as a business, as well as interact with your potential customers.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white)),
      ),
      RaisedButton(
        child: Text('Next'),
        onPressed: (){
          state = "Map";
          changedExternalState();
        },
      ),
      RaisedButton(
        child: Text('Dismiss'),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );

  Widget _buildMapOverlayContent(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.new_releases,
          color: Colors.white,
          size :80,
        ),
        SizedBox(height: 15.0),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xff301370)
          ),
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.all(16.0),
          child: Text('Map : View events or business\'s locations in a map view.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white),),
        ),
        SizedBox(height: 15.0),
        RaisedButton(
          child: Text('Next'),
          onPressed:(){
            state = "Logout";
            changedExternalState();
          },
        ),
        SizedBox(height: 10.0),
        RaisedButton(
          child: Text('Dismiss'),
          onPressed: ()=> Navigator.pop(context),
        ),
      ]
  );

  Widget _buildLogoutOverlayContent(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.new_releases,
        color:Colors.white,
        size: 80,
      ),
      SizedBox(height: 15.0),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xff301370),
        ),
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.all(16.0),
        child: Text('Logout : Leave Vybe or login with different credentials.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,)),
      ),
      SizedBox(height: 15.0),
      RaisedButton(
        child: Text('Next'),
        onPressed: (){
          state = "Category";
          changedExternalState();
        },
      ),
      SizedBox(height: 10.0),
      RaisedButton(
          child: Text('Dismiss'),
          onPressed: () => Navigator.of(context).pop()
      ),
    ],
  );

  Widget _buildCategoryOverlayContent(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Icon(
        Icons.new_releases,
        color:Colors.white,
        size: 80,
      ),
      SizedBox(height: 15.0),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xff301370),
        ),
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.all(16.0),
        child: Text('Category : Change the category chosen to have access to other events and bsuiness information.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,)),
      ),
      SizedBox(height: 15.0),
      RaisedButton(
          child: Text('Next'),
          onPressed: (){
            state = "Post";
            changedExternalState();
          }
      ),
      SizedBox(height: 10.0),
      RaisedButton(
          child: Text('Dismiss'),
          onPressed: () => Navigator.of(context).pop()
      ),
    ],
  );

  Widget _buildPostOverlayContent(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:<Widget>[
        Icon(
          Icons.new_releases,
          color: Colors.white,
          size: 80,
        ),
        SizedBox(height: 15.0),
        Container(
          decoration: BoxDecoration(
            color: Color(0xff301370),
            borderRadius: BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.all(16.0),
          child: Text('Post : You can make posts about any event or place of your choice.',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,)),
        ),
        SizedBox(height: 15.0),
        RaisedButton(
            child: Text('Next'),
            onPressed: (){
              state = "Notifications";
              changedExternalState();
            }
        ),
        SizedBox(height: 10.0),
        RaisedButton(
          child: Text('Dismiss'),
          onPressed: ()=> Navigator.pop(context),
        ),
      ]
  );

  Widget _buildNotificationsOverlayContent(BuildContext context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.new_releases,
          color:Colors.white,
          size: 80,
        ),
        SizedBox(height: 15.0),
        Container(
          decoration: BoxDecoration(
            color: Color(0xff301370),
            borderRadius:BorderRadius.circular(10),
          ),
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.all(16.0),
          child: Text('Notifications : see how other users have been interacting with your events or business posts',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,)),
        ),
        SizedBox(height: 15.0),
        RaisedButton(
            child: Text('Finish'),
            onPressed: (){
              state = "Finished";
              Navigator.pop(context);
              //TODO : handle this the right way. I want the settings to be notified when the user has finished this tutorial.
            }
        ),
      ]
  );

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child
      ){
    // You can add your own animations for the overlay content
    return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale : animation,
          child: child,
        )
    );
  }
}