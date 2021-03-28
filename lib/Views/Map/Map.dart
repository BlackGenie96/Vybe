import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';

class Map extends StatefulWidget{
  @override
  MapState createState() => new MapState();
}

class MapState extends State<Map>{
  Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = Set<Marker>();
  LocationData currentLocation;
  Location location;
  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  @override
  void initState(){
    location = new Location();
    getMylocation();
    super.initState();
  }

  getMylocation() async{
    currentLocation = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps Sample',style:TextStyle(fontFamily: 'SF-Pro', color:Colors.white,),),
        backgroundColor: Color(0xff301370),
        iconTheme: IconTheme.of(context).copyWith(
          color: Colors.white,
        )
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getLocation,
        tooltip:'Get Location',
        child: Icon(Icons.my_location,color:Colors.white),
        backgroundColor:Color(0xff301370)
      ),
    );
  }

  void getLocation() async{

    var lat = currentLocation.latitude;
    var long = currentLocation.longitude;

    if(lat != null && long != null){
      setState((){
        _markers.clear();
        final marker = Marker(
          markerId: MarkerId('curr_loc'),
          position: LatLng(lat,long ),
          infoWindow: InfoWindow(title: "Your Location")
        );
        _markers.add(marker);
      });
    }else{
      print("Points are null");
    }

  }
}