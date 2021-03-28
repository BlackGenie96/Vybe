class Category {
  String catId;
  String catName;
  Map<String,dynamic> parent;
  bool hasChildren;

  Category({this.catId,this.catName, this.parent, this.hasChildren});

  Map<String, dynamic> toJson(){
    return{
      '_id': catId,
      'name': catName,
      'parent': parent,
      'has_children': hasChildren
    };
  }

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
        catId: json['_id'],
        catName: json['name'],
        parent: json['parent'],
        hasChildren: json['has_children']
    );
  }
}