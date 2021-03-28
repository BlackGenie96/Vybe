class PlaceItem{
  var categoryId;
  var categoryName;
  var placeId;
  var placeName;
  var likes;
  var comments;
  var posts;

  PlaceItem({this.placeId, this.placeName, this.likes, this.comments, this.posts, this.categoryId, this.categoryName});

  factory PlaceItem.fromJson(Map<String, dynamic> json){
    return PlaceItem(
        categoryId : json["categoryId"],
        categoryName : json["categoryName"],
        placeId : json["locationId"],
        placeName : json["locationName"],
        likes : json["likesNum"],
        comments : json['commentsNum'],
        posts : json['postsNum']
    );
  }
}