class OrgData{
  final id;
  final orgName;
  final orgSurname;
  final orgEmail;
  final orgPhoneNum;
  final profileUrl;

  OrgData({this.id, this.orgName, this.orgSurname, this.orgEmail, this.orgPhoneNum, this.profileUrl});

  factory OrgData.fromJson(Map<String,dynamic> json){
    return OrgData(
      id : json['id'],
      orgName : json['orgName'],
      orgSurname : json['orgSurname'],
      orgEmail : json['orgEmail'],
      orgPhoneNum : json['orgPhoneNum'],
      profileUrl : json['orgProfileUrl'] == null || json['orgProfileUrl'] == "" ? null : json['orgProfileUrl']
    );
  }
}