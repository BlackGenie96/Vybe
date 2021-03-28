class UserData {
  final int userId;
  final String username;
  final String surname;
  final String phone;
  final String email;
  final String profile;

  UserData({this.userId, this.username, this.surname, this.phone, this.email, this.profile});

  factory UserData.fromJson(Map<String, dynamic> json){
    return new UserData(
        userId : int.parse(json['userId']),
        username : json['username'],
        surname : json['surname'],
        phone : json['phoneNum'],
        email : json['email'],
        profile : json['profileUrl']
    );
  }
}