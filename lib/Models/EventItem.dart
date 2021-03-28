class EventItem{
  var categoryId;
  var categoryName;
  var eventName;
  var eventId;
  var likes;
  var posts;
  var comments;

  EventItem({this.eventId, this.eventName, this.likes, this.comments, this.posts,this.categoryId, this.categoryName});

  factory EventItem.fromJson(Map<String,dynamic> json){
    return EventItem(
        eventId : json['eventId'],
        eventName : json['eventName'],
        likes : json['postLikes'],
        comments : json['postComments'],
        posts: json['postNum'],
        categoryId : json['categoryId'],
        categoryName: json['categoryName']
    );
  }
}