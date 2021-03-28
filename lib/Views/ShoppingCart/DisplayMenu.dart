import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Data/ShoppingCartService.dart';
import 'package:vybe_2/Models/MenuItem.dart';
import 'package:vybe_2/Models/PlaceProfileItem.dart';
import 'package:vybe_2/Views/ShoppingCart/ViewCart.dart';

class DisplayMenuList extends StatefulWidget{

  final PlaceProfileItem item;
  DisplayMenuList({this.item});
  @override
  _DisplayMenuState createState() => new _DisplayMenuState(item: this.item);
}

class _DisplayMenuState extends State<DisplayMenuList>{

  PlaceProfileItem item;
  _DisplayMenuState({this.item});

  ShoppingCartService service = new ShoppingCartService();
  List<MenuItem> _shoppingCart = [];


  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        accentColor: Color(0xff301370),
      ),
      child: new Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('${item.placeName} Menu',style:TextStyle(color:Colors.white,fontFamily:'SF-Pro')),
            backgroundColor:Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color:Colors.white,
            ),
            actions:<Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart, ),
                color:Colors.white,
                onPressed: (){
                  //_viewShoppingCart();
                  Toast.show("View Shopping Cart coming soon.",context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder<List<MenuItem>>(
                  future: service.getMenuItems(item),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      List<MenuItem> data = snapshot.data;
                      return buildLocationMenuListView(data);
                    }else if(snapshot.hasError){
                      return Center(child: Text('${snapshot.error}'));
                    }

                    return Center(child: CircularProgressIndicator(backgroundColor: Colors.white,));
                  }
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLocationMenuListView(List<MenuItem> data) => ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index){
      MenuItem item = data[index];
      return Card(
          color: Colors.white,
          elevation: 0.0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                new Container(
                  //height: 124.0,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 46.0),
                  decoration: new BoxDecoration(
                    color: new Color(0xff301370),
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.grey[700],
                        blurRadius: 5.0,
                        spreadRadius: 2,
                        offset: new Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left:10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          margin : EdgeInsets.only(left: 30,top: 15.0),
                          child: Text('${item.name}',style:TextStyle(fontSize: 25,fontFamily:'SF-Pro',fontWeight:FontWeight.w700,color:Colors.white),),
                        ),
                        new Container(
                          margin: EdgeInsets.only(
                            left: 33.0,
                            top: 10.0,
                          ),
                          child: Text('${item.desc}',style:TextStyle(fontSize: 15,fontFamily:'SF-Pro',color:Colors.white,)),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              margin: EdgeInsets.only(
                                  left: 30.0,
                                  top: 10.0,
                                  bottom: 5.0
                              ),
                              child: Text('E ${item.price}',style:TextStyle(fontSize:18,fontFamily:'SF-Pro',color:Colors.white,fontWeight:FontWeight.w700),),
                            ),
                            new Container(
                              margin: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                color: Color(0xff301370),
                                onPressed: (){
                                  Toast.show("Add to Shopping Cart coming soon.",context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                },
                              ),
                            ),
                          ]
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap:() => openSecondMenuItemHero(item),
                  child: new Hero(
                    tag: 'tag_${item.name}_${item.price}',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      margin: EdgeInsets.only(
                        left: 10.0,
                        top: 25.0,
                      ),
                      alignment: FractionalOffset.centerLeft,
                      child: CircleAvatar(
                        backgroundImage: item.imageUrl != null && item.imageUrl !="" ? MemoryImage(base64Decode(item.imageUrl)) : AssetImage('assets/logo.png'),
                        radius: 35.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      );
    }
  );

  void _viewShoppingCart(){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ViewCart(shoppingCart: _shoppingCart),
    ));
  }

  void openSecondMenuItemHero(MenuItem item){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) => Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.black,
          ),
          child: Builder(
              builder: (context) => Scaffold(
                appBar:AppBar(
                  title: Text('${item.name}',style:TextStyle(color:Colors.white,fontFamily:'Raleway')),
                  backgroundColor:Colors.black,
                  iconTheme:IconTheme.of(context).copyWith(
                    color:Colors.white,
                  ),
                ),
                body: SafeArea(
                  child : Center(
                    child: Hero(
                      tag:'tag_${item.name}_${item.price}',
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height : MediaQuery.of(context).size.height * 0.8,
                        child: item.imageUrl != null && item.imageUrl !="" ? Image.memory(base64Decode(item.imageUrl)) : Image.asset('assets/logo.png'),
                      ),
                    ),
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }
}