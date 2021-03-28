import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:vybe_2/Data/MainSearchService.dart';
import 'package:vybe_2/Models/EventItem.dart';
import 'package:vybe_2/Models/PlaceItem.dart';
import 'package:vybe_2/Models/SearchItem.dart';
import 'package:vybe_2/Views/EventProfile/EventProfile.dart';
import 'package:vybe_2/Views/PlaceProfile/PlaceProfile.dart';

class MainSearch extends StatefulWidget{
  @override
  _MainSearchState createState() => new _MainSearchState();
}

class _MainSearchState extends State<MainSearch>{

  MainSearchService service = new MainSearchService();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        accentColor: Color(0xff301370),
      ),
      child: Builder(
        builder: (context) => Scaffold(
          appBar:AppBar(
            title: Text('Search',style:TextStyle(color:Colors.white,fontFamily:'SF-Pro')),
            backgroundColor: Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color:Colors.white,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBar<SearchItem>(
                onSearch: service.search,
                minimumChars: 2,
                loader: const Center(child: CircularProgressIndicator(backgroundColor: Colors.white,)),
                hintText: "Enter event or place name to search",
                onItemFound: (SearchItem item, int index){
                  print(item.name);
                  return ListTile(
                    title: Text(
                      '${item.name}',
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                      ),
                    ),
                    onTap:(){
                      if(item.tag == "event"){
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => EventProfile(item: new EventItem(eventId: item.id, eventName: item.name)),
                          )
                        );
                      }else if(item.tag == "location"){
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => PlaceProfile(item: new PlaceItem(placeId: item.id, placeName: item.name))
                          ),
                        );
                      }
                    }
                  );
                },
              )
            ),
          ),
        ),
      ),
    );
  }
}