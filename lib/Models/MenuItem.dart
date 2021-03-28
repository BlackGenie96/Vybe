import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

class MenuItem{
  String id;
  String name;
  String desc;
  String price;
  File itemImage;
  String imageUrl;

  MenuItem({this.id, this.name, this.desc, this.price, this.itemImage, this.imageUrl});

  factory MenuItem.fromJson(Map<String,dynamic> json){
    return MenuItem(
        id : json["itemId"],
        name : json["itemName"],
        desc : json["itemDesc"],
        price: json["itemPrice"],
        imageUrl : json["itemImageUrl"]
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "item_name" : name,
      "item_desc" : desc,
      "item_price": price,
      "image": itemImage == null ? null : base64Encode(itemImage.readAsBytesSync()),
      "ext" : itemImage == null ? null : path.extension(itemImage.path)
    };
  }
}