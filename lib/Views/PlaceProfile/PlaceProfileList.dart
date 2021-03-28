import 'package:flutter/material.dart';
import 'package:vybe_2/Data/PlaceProfileService.dart';
import 'package:vybe_2/Models/PlaceItem.dart';
import 'package:vybe_2/Views/PlaceProfile/PlaceProfile.dart';
import 'package:vybe_2/Views/tutorial/tutorial.dart';

class PlaceList extends StatefulWidget{
  @override
  _PlaceListState createState() => new _PlaceListState();
}

class _PlaceListState extends State<PlaceList>{

  PlaceProfileService service = new PlaceProfileService();

  @override
  void initState(){
    super.initState();
  }

  void _showOverlay(BuildContext context){
    Navigator.push(context, PlaceListTutorial());
  }

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        accentColor: Color(0xff301370),
        primaryColor: Colors.white,
      ),
      child: new Builder(
        builder : (context)=> new Scaffold(
          appBar: AppBar(
            title: Text('Business Profile',style:TextStyle(fontFamily:'SF-Pro',color:Colors.white,)),
            backgroundColor: Color(0xff301370),
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            )
          ),
          body: Center(
              child: createBody()
          ),
        )
      ),
    );
  }

  Widget createBody() => SafeArea(
    child: Center(
      child:FutureBuilder<List<PlaceItem>>(
        future: service.fetchPlaceList(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<PlaceItem> data = snapshot.requireData;
            if(data.length > 0){
              return _buildListView(data);
            }else{
              return Text('No Places listed under the currently selected category',style:TextStyle(fontFamily:'SF-Pro',fontSize:18,fontWeight:FontWeight.bold),textAlign: TextAlign.center);
            }
          }else if(snapshot.hasError){
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator(backgroundColor: Colors.white,);
        },
      ),
    ),
  );

  Widget _buildListView(data) => ListView.builder(
    itemCount: data.length,
    itemBuilder: (context, index){
      PlaceItem item = data[index];
      return _tile(item);
    },
  );

  ListTile _tile(PlaceItem item) => ListTile(
    title: Text(
      '${item.placeName}',
      style: TextStyle(
        fontFamily: 'SF-Pro',
        color: Colors.black,
        fontSize:21
      ),
    ),
    onTap: (){
      //go to place profile
      print('Go to place profile activity');
      goToPlaceProfile(item);
    },
  );

  void goToPlaceProfile(PlaceItem item){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context){
          return PlaceProfile(item: item);
        }
      )
    );
  }
}