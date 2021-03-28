import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:vybe_2/Models/MenuItem.dart';

class AddMenuItem extends StatefulWidget{

  @override
  _AddMenuItemState createState() => new _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem>{

  bool menuImageChosen = false;
  File menuImage;

  TextEditingController _itemName = new TextEditingController();
  TextEditingController _itemDesc = new TextEditingController();
  TextEditingController _itemPrice = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: new Builder(
          builder:(context) => StatefulBuilder(
            builder: (context, setState) => Scaffold(
              appBar: AppBar(
                title: Text('Add Item (Product / Service)',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,)),
                backgroundColor: Color(0xff301370),
                iconTheme: IconTheme.of(context).copyWith(
                  color: Colors.white,
                ),
              ),
              body: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(height: 20),
                          menuImageChosen
                              ? GestureDetector(
                            onTap:()=> openMenuItemHero(_itemName.text),
                            child: Hero(
                              tag: 'tag_menu_item',
                              child: Container(
                                  child: CircleAvatar(
                                    backgroundImage: FileImage(menuImage),
                                    radius: 50.0,
                                  ),
                                  alignment: Alignment.center
                              ),
                            ),
                          )
                              : Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('Add Item Image',textAlign:TextAlign.center,style:TextStyle(color:Colors.black,fontFamily:'SF-Pro',fontSize:18),),
                                SizedBox(width: 15),
                                Container(
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    color: Colors.white,
                                    onPressed: () => chooseMenuItemImage(context).then((File file){
                                      if(file != null){
                                        setState((){
                                          menuImage = file;
                                          menuImageChosen = true;
                                        });
                                      }else{
                                        Toast.show("File is null", context, duration:Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                      }
                                    }),
                                    iconSize: 30.0,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 70,
                            child: TextFormField(
                              controller: _itemName,
                              decoration: InputDecoration(
                                labelText: 'Item Name',
                                labelStyle: TextStyle(color: Colors.black,fontFamily:'SF-Pro'),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.black, width :2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.black, width: 1.2),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 70,
                            child: TextFormField(
                              controller: _itemDesc,
                              decoration: InputDecoration(
                                labelText: 'Item Description',
                                labelStyle: TextStyle(color: Colors.black,fontFamily:'SF-Pro'),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.black, width :2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.black, width: 1.2),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 70,
                            child: TextFormField(
                              controller: _itemPrice,
                              decoration: InputDecoration(
                                labelText: 'Item Price',
                                labelStyle: TextStyle(color: Colors.black,fontFamily:'SF-Pro'),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.black, width :2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: Colors.black, width: 1.2),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(height: 12),
                          MaterialButton(
                              color: Color(0xffcd5e14),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                              padding: const EdgeInsets.all(14.0),
                              child: Text('Add Item',textAlign:TextAlign.center,style:TextStyle(fontFamily:'SF-Pro')),
                              onPressed:() {
                                //create menu item instance
                                MenuItem item;
                                if(menuImageChosen){
                                  item = new MenuItem(name:_itemName.text,desc:_itemDesc.text,price: _itemPrice.text, itemImage:menuImage);
                                }else{
                                  item = new MenuItem(name:_itemName.text, desc: _itemDesc.text, price: _itemPrice.text);
                                }

                                Navigator.pop(context, item);
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
            ),
          )
      ),
    );
  }

  Future<File> chooseMenuItemImage(context) async{
    final imageSource = await showDialog<ImageSource>(
      context : context,
      builder: (context) => AlertDialog(
          title: Text('Select Image Source'),
          actions: <Widget>[
            MaterialButton(
              child: Text('Camera'),
              onPressed: ()=> Navigator.pop(context, ImageSource.camera),
            ),
            MaterialButton(
              child: Text('Gallery'),
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ]
      ),
    );
    File file;
    if(imageSource != null){
      file = await ImagePicker.pickImage(source: imageSource);
    }

    return file;
  }

  void openMenuItemHero(String itemName){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => new Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.black,
          ),
          child: new Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: itemName != "" ? Text(itemName,style:TextStyle(color:Colors.white,fontFamily:'SF-Pro')) : Text('Menu Item Image', style:TextStyle(color:Colors.white,fontFamily:'SF-Pro'),),
                backgroundColor: Colors.black,
                iconTheme: IconTheme.of(context).copyWith(
                  color: Colors.white,
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Hero(
                    tag: 'tag_menu_item',
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(height: 5.0),
                          MaterialButton(
                              color: Color(0xff301370),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                              padding : const EdgeInsets.all(16.0),
                              child: Text('Remove',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,),textAlign: TextAlign.center),
                              onPressed: (){
                                //remove the currently selected file
                                setState((){
                                  menuImageChosen = false;
                                  menuImage = null;
                                });
                                //go back to the menu
                                Navigator.pop(context);
                              }
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Image.file(menuImage),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}