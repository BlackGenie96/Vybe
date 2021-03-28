class Notify{

  final int notId;
  final String type;
  final int entityId;
  final int checked;
  final String text;
  final time;

  Notify({this.notId, this.type, this.entityId, this.checked, this.text, this.time});

  factory Notify.fromJson(Map<String,dynamic> json){
    return Notify(
        notId: int.parse(json["notificationId"]),
        type: json["type"],
        entityId: int.parse(json["entityId"]),
        checked : int.parse(json["checked"]),
        text : json["text"],
        time : json["time"]
    );
  }
}