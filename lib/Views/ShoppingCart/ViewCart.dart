import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Models/MenuItem.dart';

class ViewCart extends StatefulWidget{

  final List<MenuItem> shoppingCart;
  ViewCart({this.shoppingCart});
  @override
  _ViewCartState createState() => new _ViewCartState(shoppingCart: this.shoppingCart);
}

class _ViewCartState extends State<ViewCart>{

  final List<MenuItem> shoppingCart;
  _ViewCartState({this.shoppingCart});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Shopping Cart',style:TextStyle(color:Colors.white,fontFamily:'SF-Pro',)),
              backgroundColor: Color(0xff301370),
              iconTheme:IconTheme.of(context).copyWith(
                color: Colors.white,
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width:MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: shoppingCart.length,
                          itemBuilder: (context, index){
                            MenuItem item = shoppingCart[index];
                            return Card(
                              color: Color(0xff301370),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height : MediaQuery.of(context).size.height * 0.15,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children : <Widget>[
                                      GestureDetector(
                                        onTap: (){
                                          openSecondMenuItemHero(item);
                                        },
                                        child: Hero(
                                          tag: 'tag_${item.name}_${item.price}',
                                          child: Container(
                                            child: CircleAvatar(
                                              backgroundImage: FileImage(item.itemImage),
                                            ),
                                            width: MediaQuery.of(context).size.width * 0.1,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width : MediaQuery.of(context).size.width * 0.65,
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(height: 12),
                                              Text('${item.name}',style:TextStyle(color:Colors.white,fontFamily:'SF-Pro')),
                                              SizedBox(height: 12),
                                              Text('${item.desc}',style:TextStyle(color:Colors.white,fontFamily:'SF-Pro')),
                                            ]
                                        ),
                                      ),
                                      Container(
                                        width : MediaQuery.of(context).size.width * 0.125,
                                        child: Text(
                                          'E ${item.price}',
                                          style:TextStyle(
                                            color: Colors.white,
                                            fontFamily:'SF-Pro',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.125,
                                        child: IconButton(
                                          icon: Icon(Icons.remove),
                                          color: Colors.green[700],
                                          onPressed:(){
                                            shoppingCart.remove(item);
                                            Toast.show('Removed item to trolley', context,gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
                                          },
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                    SizedBox(height: 15.0),
                    GestureDetector(
                      onTap:(){
                        //TODO: place order, ask for user to pay first,send confirmation and then, they will be able to place the order.
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child:Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Place Order',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,fontFamily:'SF-Pro',fontWeight:FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
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
                  title: Text('${item.name}',style:TextStyle(color:Colors.white,fontFamily:'SF-Pro')),
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
                        child: Image.file(item.itemImage),
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