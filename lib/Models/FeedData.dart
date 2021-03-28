class FeedData{
  String postId;
  String postTime;
  int likes;
  int comments;
  String status;
  dynamic imageUrl;

  String posterId;
  String posterName;
  String posterSurname;
  dynamic posterProfile;

  String postedId;
  String postedName;
  String tag;

  FeedData({
    this.postId,
    this.postTime,
    this.likes,
    this.comments,
    this.status,
    this.imageUrl,
    this.posterId,
    this.posterName,
    this.posterSurname,
    this.posterProfile,
    this.postedId,
    this.postedName,
    this.tag
  });

  factory FeedData.fromJson(Map<String,dynamic> json){
    return new FeedData(
        postId    : json["postId"],
        postTime  : json["postTime"],
        likes     : int.parse(json["postLikes"].toString()),
        comments  : int.parse(json["postComments"].toString()),
        status    : json["postStatus"],
        imageUrl  : json["postImageUrl"],
        posterId  : json["posterId"],
        posterName: json["posterName"],
        posterSurname: json["posterSurname"],
        posterProfile: json["posterProfile"],
        postedId  : json["postedId"],
        postedName: json["postedName"],
        tag       : json["tag"]
    );
  }

  @override
  String toString(){
    print("$postId \n $postTime \n $likes \n $comments \n $status \n $imageUrl \n $posterId \n $posterName \n $posterSurname \n $posterProfile \n $postedId \n $postedName \n $tag");
  }
}