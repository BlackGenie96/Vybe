class Comment{
  int userId;
  String userName;
  String userSurname;
  String commentMessage;
  String commentTime;
  int commentId;



  Comment({this.userId,this.userName,this.userSurname,this.commentId, this.commentMessage, this.commentTime});

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
        userId: int.parse(json['userId']),
        userName: json['userName'],
        userSurname: json['userSurname'],
        commentId: int.parse(json['commentId']),
        commentMessage: json['commentMessage'],
        commentTime: json['commentTime']
    );
  }
}