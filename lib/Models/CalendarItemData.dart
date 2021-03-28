class CalendarItemData{
  String eventId;
  String eventName;
  String eventDate;

  CalendarItemData({this.eventId, this.eventName, this.eventDate});

  factory CalendarItemData.fromJson(Map<String,dynamic> json){
    return CalendarItemData(
        eventId: json['_id'],
        eventName: json['name'],
        eventDate : json['date']
    );
  }
}