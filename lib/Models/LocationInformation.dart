class LocationInformation{
  final String name;
  final String town;
  final String phoneNum;
  int index;

  LocationInformation(this.name, this.town, this.phoneNum);

  LocationInformation.fromJson(Map<String,dynamic> json)
      : name = json['name'],
        town = json['town'],
        phoneNum = json['phone'];


  Map<String,dynamic> toJson(){
    return {
      'name' : this.name,
      'town' : this.town,
      'phone' : this.phoneNum
    };
  }
}