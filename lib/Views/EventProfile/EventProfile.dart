import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/EventProfileService.dart';
import 'package:vybe_2/Models/Event.dart';
import 'package:vybe_2/Models/EventItem.dart';
import 'package:vybe_2/Models/TicketPrice.dart';
import 'package:vybe_2/Models/TicketSalesPoints.dart';
import 'package:vybe_2/Views/Feed/Feed.dart';
import 'package:vybe_2/Views/images_page.dart';


class EventProfile extends StatefulWidget{
  final EventItem item;

  EventProfile({this.item});

  @override
  _EventProfileState createState() => new _EventProfileState(item:item);
}

class _EventProfileState extends State<EventProfile>{
  EventItem item;
  _EventProfileState({this.item});
  EventProfileService service = new EventProfileService();

  //variable to carry the rating of the event
  var _rating = 0;

  //functions to handle state changes in rating
  void _setRatingAsOne(){
    setState((){
      _rating = 1;
    });
  }

  void _setRatingAsTwo(){
    setState((){
      _rating = 2;
    });
  }

  void _setRatingAsThree(){
    setState((){
      _rating = 3;
    });
  }

  void _setRatingAsFour(){
    setState((){
      _rating = 4;
    });
  }

  void _setRatingAsFive(){
    setState((){
      _rating = 5;
    });
  }

  @override
  void initState(){
    super.initState();
    //get event item data here.
  }

  @override
  Widget build(BuildContext context){
    return new Theme(
      data: Theme.of(context).copyWith(
        accentColor: Color(0xff301370),
        scaffoldBackgroundColor: Colors.white,
      ),
      child: new Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(item.eventName,style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,)),
            backgroundColor: Color(0xff301370),
            iconTheme : IconTheme.of(context).copyWith(
              color: Colors.white,
            ),
          ),
          body: Center(
            child: _futureBuilder(),
          ),
        ),
      )
    );
  }

  Widget _futureBuilder() => FutureBuilder<Event>(
      future: service.getEventInformation(item),
      builder: (context, snapshot){
        if(snapshot.hasData){
          //handle the building of display widget to show the information
          Event data = snapshot.data;
          return _createProfile(event:data);
        }else if(snapshot.hasError){
          return Text('${snapshot.error}');
        }
        return new Center(child:CircularProgressIndicator(backgroundColor: Colors.white));
      }
  );

  SafeArea _createProfile({var size = 30.0,Event event}) => SafeArea(
    child: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top:13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Manager Information',
                    style:TextStyle(
                        fontFamily: 'SF-Pro',
                        color: Color(0xff301370),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${event.orgName} ${event.orgSurname}',
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      color: Color(0xff301370),
                      fontSize: 19,
                    ),
                  ),
                  Text(
                    '${event.orgPhone}',
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontSize: 19,
                      color: Color(0xff301370),
                    ),
                  ),
                  Text(
                    '${event.orgEmail}',
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontSize: 19,
                      color: Color(0xff301370),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top:15),
              child: event.eventPoster == null || event.eventPoster == 'No Image'
                  ? Padding(padding:const EdgeInsets.all(18),child:Text('No Poster Uploaded',style:TextStyle(fontFamily: 'SF-Pro',fontWeight:FontWeight.w700,fontSize:22)))
                  : Image.memory(
                base64Decode(event.eventPoster),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.55,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap:(){
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder:(context) => Images(eventId: event.eventId)
                        )
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Color(0xff301370),
                    ),
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child:Text(
                        'Images',
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
                GestureDetector(
                  onTap:(){
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder:(context)=> Feed(eventId: event.eventId)
                        )
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xffcd5e14),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    height: 60,
                    width: MediaQuery.of(context).size.width *0.4,
                    child: Text(
                      'Posts',
                      textAlign:TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top:12),
                child: Text(
                  'About Event',
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top:4),
                child: Text(
                  event.eventAbout,
                  style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontSize : 18
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top:12),
                child: Text(
                  'Event Date',
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top:4),
                child: Text(
                  event.eventDate.toString().substring(0,10),
                  style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontSize : 18
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top:4),
                child: Text(
                  '${event.eventTime}',
                  style:TextStyle(
                      fontFamily: 'SF-Pro',
                      fontSize: 18
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top:25),
              child: Text(
                'Theme',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top:4),
              child: Text(
                '${event.theme}',
                style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 18
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top:25),
              child: Text(
                'Max People Allowed',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top:4),
              child: Text(
                '${event.maxAllowed}',
                style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 18
                ),
              ),
            ),
            InkWell(
              onTap: (){
                //show alert dialog with the prices listed
                createPricesDialog(event);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(color:Colors.black,width:1),
                ),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(top: 25),
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Ticket Prices',
                      style:TextStyle(
                        fontFamily: 'SF-Pro',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    )
                ),
              ),
            ),
            InkWell(
              onTap: (){
                //show alert dialog with pay points for tickets.
                createSalePointsDialog(event);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                margin: const EdgeInsets.only(top:25),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Ticket Sale Points',
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Text(
                'Rating',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  color:Colors.black,
                ),
              ),
            ),
            Row(
              crossAxisAlignment : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: event.rating < 1 && event.rating > 0 ? Icon(Icons.star_half,size:30,color:Colors.red) : event.rating >= 1 ? Icon(Icons.star, size:30, color :Colors.red) : Icon(Icons.star_border, size:30, color:Colors.red),
                ),
                Container(
                  child: event.rating < 2 && event.rating > 1 ? Icon(Icons.star_half,size:30,color:Colors.red) : event.rating >=2 ? Icon(Icons.star, size:30,color:Colors.red) : Icon(Icons.star_border, size:30,color:Colors.red),
                ),
                Container(
                  child: event.rating < 3 && event.rating > 2 ? Icon(Icons.star_half,size:30, color:Colors.red) : event.rating >= 3 ? Icon(Icons.star, size:30,color:Colors.red) : Icon(Icons.star_border, size:30,color:Colors.red),
                ),
                Container(
                  child: event.rating < 4 && event.rating > 3 ? Icon(Icons.star_half,size:30, color:Colors.red) : event.rating >= 4 ? Icon(Icons.star, size:30,color:Colors.red) : Icon(Icons.star_border, size:30,color:Colors.red),
                ),
                Container(
                  child: event.rating < 5 && event.rating > 4 ? Icon(Icons.star_half,size:30, color:Colors.red) : event.rating >= 5 ? Icon(Icons.star, size:30,color:Colors.red) : Icon(Icons.star_border, size:30,color:Colors.red),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green[700],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add,size: 30,),
                    color:Colors.white,
                    onPressed: () => _showRatingOptions(event),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    ),
  );

  void _showRatingOptions(Event item) async{
    final size = 30;
    await showDialog(
      context: context,
      builder:(context) => StatefulBuilder(
        builder:(context, setState) => AlertDialog(
          title: Text('Add Rating',textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro',color:Colors.black,fontWeight:FontWeight.w700)),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize:MainAxisSize.min,
                  children:<Widget>[
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: (_rating >= 1 ? Icon(Icons.star, size:30,): Icon(Icons.star_border)),
                        color: Colors.red[500],
                        onPressed: (){
                          setState(() {
                            _setRatingAsOne();
                          });
                        },
                        iconSize: double.parse(size.toString()),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: (_rating >= 2 ? Icon(Icons.star, size:30,): Icon(Icons.star_border)),
                        color: Colors.red[500],
                        onPressed:(){
                          setState((){
                            _setRatingAsTwo();
                          });
                        },
                        iconSize: double.parse(size.toString()),
                      ),
                    ),
                    Expanded(
                      flex : 1,
                      child: IconButton(
                          icon: (_rating >= 3 ? Icon(Icons.star, size:30,): Icon(Icons.star_border)),
                          color: Colors.red[500],
                          onPressed: (){
                            setState(() {
                              _setRatingAsThree();
                            });
                          },
                          iconSize: double.parse(size.toString())
                      ),
                    ),
                    Expanded(
                      flex:1,
                      child: IconButton(
                          icon: (_rating >= 4 ? Icon(Icons.star, size:30,): Icon(Icons.star_border)),
                          color: Colors.red[500],
                          onPressed: (){
                            setState((){
                              _setRatingAsFour();
                            });
                          },
                          iconSize: double.parse(size.toString())
                      ),
                    ),
                    Expanded(
                      flex:1,
                      child: IconButton(
                          icon: (_rating >= 5 ? Icon(Icons.star, size:30,): Icon(Icons.star_border)),
                          color: Colors.red[500],
                          onPressed: (){
                            setState((){
                              _setRatingAsFive();
                            });
                          },
                          iconSize: double.parse(size.toString())
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            RaisedButton(
              color: Colors.white,
              textColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Text('Submit',style:TextStyle(fontFamily:'SF-Pro')),
              padding: const EdgeInsets.all(16.0),
              onPressed: () {
                service.addRatingService(item, _rating).then((Map<String,dynamic> res){
                  if(res["success"] == 1){
                    Toast.show(res["message"], context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Navigator.pop(context);
                  }else{
                    Toast.show(res["message"], context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                });
              },
            ),
            RaisedButton(
                color:Colors.black,
                textColor: Colors.white,
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                child: Text('Cancel',style:TextStyle(fontFamily:'SF-Pro')),
                padding: const EdgeInsets.all(16.0),
                onPressed: () => Navigator.pop(context)
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
  }


  //methods to create alert dialog base on the input of the function
  void createPricesDialog(Event event) async{
    await showDialog<TicketPrice>(
        context : context,
        builder: (context)=>
            AlertDialog(
              title: Text('Ticket Prices'),
              actions: <Widget>[
                MaterialButton(
                  child: Text('Close'),
                  onPressed:()=> Navigator.of(context).pop(),
                ),
              ],
              content: Center(
                child: _buildPriceListView(event),
              ),
            )
    );
  }

  /*Widget _buildPrice(){
    return FutureBuilder<TicketPrice>(
      future: service.getPricesFromAPI(item),
      builder: (context, snapshot){
        if(snapshot.hasData){
          //custom code being done here
          TicketPrice data = snapshot.data;
          return _buildPriceListView(data);
        }else if(snapshot.hasError){
          return Center(child:Text('${snapshot.error}'));
        }
        return Center(child:CircularProgressIndicator(backgroundColor: Colors.white));
      },
    );
  }*/

  Widget _buildPriceListView(Event event) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Expanded(
        child: event.tickets['presaleGeneral'] != null || event.tickets['presaleGeneral'] != "" ?Container(
            width: MediaQuery.of(context).size.width * 0.7,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pre Sale Gate Ticket: \n\tE ${event.tickets['presaleGeneral']}',
                style:TextStyle(
                  fontFamily: 'SF-Pro'
                ),
              ),
            )
        ) : SizedBox(),
      ),
      Expanded(
        child: event.tickets['presaleVIP'] != null || event.tickets['presaleVIP'] != "" ? Container(
            width: MediaQuery.of(context).size.width * 0.7,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pre Sale VIP Ticket: \n\tE ${event.tickets['presaleVIP']}',
                style:TextStyle(
                    fontFamily: 'SF-Pro'
                ),
              ),
            )
        ) : SizedBox(),
      ),
      Expanded(
        child: event.tickets['presaleVVIP'] != null || event.tickets['presaleVVIP'] != "" ? Container(
            width: MediaQuery.of(context).size.width * 0.7,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Pre Sale VVIP Ticket: \n\tE ${event.tickets['presaleVVIP']}',
              ),
            )
        ) : SizedBox(),
      ),
      Expanded(
        child: event.tickets['gateGeneral'] != null || event.tickets['gateGeneral'] != "" ? Container(
            width: MediaQuery.of(context).size.width * 0.7,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Gate Sale General Ticket: \n\tE ${event.tickets['gateGeneral']}',
                style:TextStyle(
                    fontFamily: 'SF-Pro'
                ),
              ),
            )
        ) : SizedBox(),
      ),
      Expanded(
        child:event.tickets['gateVIP'] != null || event.tickets['gateVIP'] != "" ?Container(
            width: MediaQuery.of(context).size.width * 0.7,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Gate Sale VIP Ticket: \n\tE ${event.tickets['gateVIP']}',
                style:TextStyle(
                    fontFamily: 'SF-Pro'
                ),
              ),
            )
        ) : SizedBox(),
      ),
      Expanded(
        child: event.tickets['gateVVIP'] != null || event.tickets['gateVVIP'] != "" ? Container(
            width: MediaQuery.of(context).size.width * 0.7,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Gate Sale VVIP Ticket: \n\tE ${event.tickets['gateVVIP']}',
                style:TextStyle(
                    fontFamily: 'SF-Pro'
                ),
              ),
            )
        ): SizedBox(),
      ),
    ],
  );

  //methods to handle the ticket sales points alert dialog
  void createSalePointsDialog(Event event) async{
    await showDialog<TicketSalesPoints>(
        context: context,
        builder:(context) =>
            AlertDialog(
              title: Text('Ticket Points of Sale'),
              actions: <Widget>[
                MaterialButton(
                  onPressed: ()=> Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
              content: event.salesPoints.length > 0
                  ? _buildSalesListView(event)
                  : Text('No locations specified.',
                      textAlign:TextAlign.center,
                      style:TextStyle(color:Colors.black,fontFamily:'SF-Pro',fontSize:18)),
            )
    );
  }

  /*Widget _buildSales(){
    return FutureBuilder<List<TicketSalesPoints>>(
        future: service.getSalesPointsFromAPI(item),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<TicketSalesPoints> data = snapshot.data;
            return _buildSalesListView(data);
          }else if(snapshot.hasError){
            return Text('No locations specified.',textAlign:TextAlign.center,style:TextStyle(color:Colors.black,fontFamily:'SF-Pro',fontSize:18));
          }
          return Center(child:CircularProgressIndicator(backgroundColor: Colors.white,));
        }
    );
  }*/

  Widget _buildSalesListView(Event event) => Container(
    width: MediaQuery.of(context).size.width * 0.5,
    height: MediaQuery.of(context).size.height * 0.6,
    child: ListView.builder(
        itemCount: event.salesPoints.length,
        itemBuilder: (context, index){
          Map<String,dynamic> item = event.salesPoints[index];
          return _tile(item);
        }
    ),
  );

  ListTile _tile(Map<String,dynamic> item)=> ListTile(
    title: Text('${item['name']}', style:TextStyle(fontFamily:'SF-Pro',fontSize: 22, fontWeight: FontWeight.w700,)),
    subtitle: Text('${item['town']} \n ${item['phone']}',style:TextStyle(fontFamily:'SF-Pro')),
  );
}