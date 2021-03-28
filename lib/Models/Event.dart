class Event{
  var eventId;
  var eventPoster;
  var eventAbout;
  var eventName;
  var eventDate;
  var eventTime;
  var maxAllowed;
  var theme;
  var orgId;
  var orgName;
  var orgSurname;
  var orgEmail;
  var orgPhone;
  var salesPoints;
  var rating;
  var tickets;
  var location;

  Event({
    this.eventId,
    this.eventPoster,
    this.eventName,
    this.eventDate,
    this.eventTime,
    this.maxAllowed,
    this.theme,
    this.orgId,
    this.orgName,
    this.orgSurname,
    this.orgEmail,
    this.orgPhone,
    this.salesPoints,
    this.rating,
    this.eventAbout,
    this.tickets,
    this.location
  });

  factory Event.fromJson(Map<String,dynamic> json){
    return Event(
        eventId: json['_id'],
        eventPoster: json['poster'],
        eventName: json['name'],
        eventDate: json['date'],
        eventTime: json['time'],
        maxAllowed: json['max_allowed'],
        theme: json['theme'],
        orgId : json['manager']['_id'],
        orgName : json['manager']['name'],
        orgSurname: json['manager']['surname'],
        orgEmail : json['manager']['email'],
        orgPhone: json['manager']['phone'],
        salesPoints: json['sales_points'],
        rating: json['rating'],
        eventAbout : json['about'],
        tickets: json['tickets'],
        location: json['location']
    );
  }
}
