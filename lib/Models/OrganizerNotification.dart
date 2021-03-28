class OrgNotItem{

  final notId;
  final type;
  final eventId;
  final locationId;
  final entityId;
  final checked;
  final time;
  final text;

  OrgNotItem({this.notId, this.type, this.eventId, this.locationId, this.entityId, this.checked, this.time, this.text});

  factory OrgNotItem.fromJson(Map<String, dynamic> json){
    return OrgNotItem(
        notId: int.parse(json['notificationId'].toString()),
        type :json['type'].toString(),
        eventId : json['eventId'],
        locationId : json['locationId'],
        entityId : json['entityId'],
        checked : json['checked'],
        time : json['time'],
        text : json['text']
    );
  }
}