class SearchItem{
  final int id;
  final String name;
  final String tag;

  SearchItem({this.id, this.name, this.tag});

  factory SearchItem.fromJson(Map<String, dynamic> json){
    return SearchItem(
        id: json["id"],
        name : json["name"],
        tag : json["tag"]
    );
  }
}