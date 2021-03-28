import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/PlaceProfileService.dart';
import 'package:vybe_2/Models/PlaceItem.dart';
import 'package:vybe_2/Models/PlaceProfileItem.dart';
import 'package:vybe_2/Views/Feed/Feed.dart';
import 'package:vybe_2/Views/ShoppingCart/DisplayMenu.dart';
import 'package:vybe_2/Views/images_page.dart';

class PlaceProfile extends StatefulWidget{
  final PlaceItem item;
  PlaceProfile({this.item});

  @override
  _PlaceProfileState createState() => new _PlaceProfileState(item1: this.item);
}

class _PlaceProfileState extends State<PlaceProfile>{
  PlaceItem item1;
  _PlaceProfileState({this.item1});
  var _rating = 0;

  Future<bool> addRating;
  Future<bool> updateRating;

  PlaceProfileService service = new PlaceProfileService();
  Future<PlaceProfileItem> futureItem;

  @override
  void initState(){
    super.initState();
    futureItem = service.fetchPlaceProfile(item1);
  }

  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: Theme.of(context).copyWith(
          scaffoldBackgroundColor: Colors.white,
          accentColor: Color(0xff301370),
        ),
        child: new Builder(
            builder: (context) =>Scaffold(
              appBar: AppBar(
                title: Text('${item1.placeName}',style:TextStyle(color:Colors.white,fontFamily:'SF-Pro')),
                backgroundColor: Color(0xff301370),
                iconTheme: IconTheme.of(context).copyWith(
                  color: Colors.white,
                ),
              ),
              body: Center(
                  child:FutureBuilder<PlaceProfileItem>(
                      future: futureItem,
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          PlaceProfileItem data = snapshot.data;
                          return _createBody(data);
                        }else if(snapshot.hasError){
                          return Text('${snapshot.error}');
                        }
                        return CircularProgressIndicator(backgroundColor: Colors.white);
                      }
                  )
              ),
            )
        )
    );
  }

  Widget _createBody(PlaceProfileItem item) => SafeArea(
    child: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: ()=> openPlaceProfileHero(context, item),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                margin: const EdgeInsets.only(top: 15),
                child: Center(
                  child: Hero(
                    tag: 'place_picture_tag',
                    child: Image.memory(base64Decode(item.placePicture),fit:BoxFit.contain),
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top:12),
                child: Text(
                  'About',
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top:4),
                child: Text(
                  item.about,
                  style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontSize : 18
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width* 0.95,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.phone, color: Color(0xffcd5e14)),
                  Text('  ${item.placePhone}', style:TextStyle(fontFamily:'SF-Pro',color:Colors.black87,fontSize:18))
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width* 0.95,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.markunread_mailbox, color: Color(0xffcd5e14)),
                  Text('  ${item.placeAddress}', style:TextStyle(fontFamily:'SF-Pro',color:Colors.black87,fontSize:18))
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width* 0.95,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  item.website != null ? Icon(Icons.language, color: Color(0xffcd5e14)): Text(''),
                  item.website != null
                      ? Text('  ${item.website}', style:TextStyle(fontFamily:'SF-Pro',color:Colors.black87,fontSize:18))
                      : Text('')
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top:12),
                child: Text(
                  'Directions',
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Text(
                  '${item.directions}',
                  style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontSize : 18
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 12.0),
            GestureDetector(
              onTap:(){
                _goToPlaceMenu(item);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color:Colors.black, width:1),
                ),
                alignment: Alignment.center,
                width : MediaQuery.of(context).size.width * 0.55,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child : Text(
                    'Menu',
                    textAlign:TextAlign.center,
                    style:TextStyle(
                        color:Colors.black,
                        fontFamily: 'SF-Pro',
                        fontWeight: FontWeight.w700,
                        fontSize: 22
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap:(){
                    print('Go to place images.');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder:(context) => Images(locationId: item.placeId)
                      ),
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
                    print('Go to place posts');
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => Feed(locationId:item.placeId)
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
            /*GestureDetector(
              onTap:(){
                //TODO : go to map and show route to location.
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                height: 60,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  'Locate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      color: Colors.white,
                      fontSize: 22
                  ),
                ),
              ),
            ),*/
            Row(
              crossAxisAlignment : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: item.rating < 1 && item.rating > 0 ? Icon(Icons.star_half,size:30,color:Colors.red) : item.rating >= 1 ? Icon(Icons.star, size:30, color :Colors.red) : Icon(Icons.star_border, size:30, color:Colors.red),
                ),
                Container(
                  child: item.rating < 2 && item.rating > 1 ? Icon(Icons.star_half,size:30,color:Colors.red) : item.rating >=2 ? Icon(Icons.star, size:30,color:Colors.red) : Icon(Icons.star_border, size:30,color:Colors.red),
                ),
                Container(
                  child: item.rating < 3 && item.rating > 2 ? Icon(Icons.star_half,size:30, color:Colors.red) : item.rating >= 3 ? Icon(Icons.star, size:30,color:Colors.red) : Icon(Icons.star_border, size:30,color:Colors.red),
                ),
                Container(
                  child: item.rating < 4 && item.rating > 3 ? Icon(Icons.star_half,size:30, color:Colors.red) : item.rating >= 4 ? Icon(Icons.star, size:30,color:Colors.red) : Icon(Icons.star_border, size:30,color:Colors.red),
                ),
                Container(
                  child: item.rating < 5 && item.rating > 4 ? Icon(Icons.star_half,size:30, color:Colors.red) : item.rating >= 5 ? Icon(Icons.star, size:30,color:Colors.red) : Icon(Icons.star_border, size:30,color:Colors.red),
                ),
                Container(
                  decoration: BoxDecoration(
                    color:Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add,size: 30,),
                    color:Colors.white,
                    onPressed: (){
                      _showRatingOptions(item);
                      setState((){
                        futureItem =  service.fetchPlaceProfile(item1);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0)
          ],
        ),
      ),
    ),
  );

  //Function to handle displaying the place menu item scaffold and list
  void _goToPlaceMenu(PlaceProfileItem item) => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => DisplayMenuList(item:item),
    )
  );

  void _showRatingOptions(PlaceProfileItem item) async{
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
              child: Text('Submit',style:TextStyle(fontFamily:'Raleway')),
              padding: const EdgeInsets.all(16.0),
              onPressed: () {
                service.addRatingService(item,_rating).then((Map<String,dynamic> res){
                  Toast.show(res["message"], context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }).whenComplete((){
                  Navigator.pop(context);
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

  void openPlaceProfileHero(BuildContext context, PlaceProfileItem item){
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => Theme(
            data: Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.black,
            ),
            child: new Builder(
              builder: (context) => new Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  iconTheme: IconTheme.of(context).copyWith(
                    color:Colors.white,
                  ),
                  title: Text('${item.placeName}',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,)),
                ),
                body: SafeArea(
                  child: Center(
                    child: Hero(
                      tag: 'place_picture_tag',
                      child:Container(
                        width : MediaQuery.of(context).size.width,
                        child: Image.memory(base64Decode(item.placePicture)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}