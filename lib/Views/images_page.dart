import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Images extends StatefulWidget{
  int eventId;
  int locationId;

  Images({this.eventId,this.locationId});

  @override
  _ImagesState createState() => new _ImagesState(eventId: eventId, locationId: locationId);
}


class _ImagesState extends State<Images>{

  int eventId;
  int locationId;
  List<GridImage> imagesList = [];
  final domain = "https://vybe-296303.uc.r.appspot.com";

  _ImagesState({this.eventId, this.locationId});

  @override
  void initState(){
    super.initState();
    _getImages();
  }

  @override
  Widget build(BuildContext context) {

    if(imagesList.isEmpty || imagesList == null){
      return Center(child:CircularProgressIndicator(backgroundColor: Colors.transparent,));
    }
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: new Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: eventId != null
                ? Text('Event Images',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,))
                : locationId != null
                ? Text('Location Images',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,))
                : Text('No event or location chosen.',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,)),
            backgroundColor:Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color:Colors.white,
            ),
          ),
          body: SafeArea(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: imagesList.length,
              itemBuilder: (context, index){
                GridImage image = imagesList[index];
                print(image.url);
                return _tile(image);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 0,mainAxisSpacing: 0),
            ),
          ),
        ),
      ),
    );
  }

  void _getImages() async{
    Map<String,dynamic> data;
    var url = domain;
    if(eventId != null){
      data = {'event_id': eventId};
      url += "/flutter_api/images/get_event_images.php";
    }else if(locationId != null){
      data = {"location_id": locationId};
      url += "/flutter_api/images/get_place_images.php";
    }

    Map<String,String> headers = {"Content-Type":"application/json"};

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    //handle response from api.
    print(response.body);

    if(response.statusCode == 200){
      List res = json.decode(response.body);
      setState(() {
        imagesList = res.map((item) => GridImage.fromJson(item)).toList();
      });

      if(imagesList.isNotEmpty){
        print('Something good.');
      }else{
        print('Nothing good.');
      }
    }else{
      throw Exception('Error getting images.');
    }
  }

  Widget _tile(GridImage image) => Card(
    child: GestureDetector(
      onTap:(){
        imageHero(image);
        print("Opening hero !!");
      },
      child: Hero(
        tag: '${image.id}_${image.url}',
        child: Image.memory(base64Decode(image.url)),
      ),
    ),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
    color: Colors.black,
  );

  void imageHero(image){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context)=> Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor:Colors.black,
          ),
          child: new Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                iconTheme: IconTheme.of(context).copyWith(
                  color:Colors.white,
                ),
                backgroundColor:Colors.black,
              ),
              body: SafeArea(
                child: Center(
                  child: Hero(
                    tag:'${image.id}_${image.url}',
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.memory(base64Decode(image.url)),
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

class GridImage{
  final int id;
  final String url;

  GridImage({this.id, this.url});

  factory GridImage.fromJson(Map<String,dynamic> json){
    return GridImage(
      id: int.parse(json["locationId"]),
      url: json["imageUrl"]
    );
  }
}