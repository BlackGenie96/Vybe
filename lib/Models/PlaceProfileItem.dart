class PlaceProfileItem{
  final int placeId;
  final String placeName;
  final String placePicture;
  final String placeAddress;
  final String placePhone;
  final double rating;
  final double latitude;
  final double longitude;
  final String website;
  String about;
  String directions;

  PlaceProfileItem({this.placeId, this.placeName, this.placePicture, this.placeAddress, this.placePhone, this.rating, this.latitude, this.longitude, this.website, this.about, this.directions});

  factory PlaceProfileItem.fromJson(Map<String, dynamic> json){
    return PlaceProfileItem(
        placeId: int.parse(json["placeId"]),
        placeName : json["placeName"],
        placePicture: json["placePicture"],
        placeAddress: json["placeAddress"],
        placePhone: json["placePhone"],
        rating : double.parse(json["rating"]),
        latitude : json["latitude"] != null ? double.parse(json["latitude"]) : 0,
        longitude: json["longitude"] != null ? double.parse(json["longitude"]) : 0,
        website: json["website"] == null ? null : json["website"],
        about: json["about"],
        directions: json["directions"]
    );
  }
}
