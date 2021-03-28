class TicketSalesPoints{
  int placeId;
  String placeName;
  int ticketId;
  String placeAddress;
  int placePhone;

  TicketSalesPoints({this.placeId, this.placeName, this.placeAddress, this.placePhone, this.ticketId});

  factory TicketSalesPoints.fromJson(Map<String, dynamic> json){
    return TicketSalesPoints(
        placeId: int.parse(json['placeId']),
        placeName: json['placeName'],
        placeAddress: json['placeAddress'],
        placePhone: int.parse(json['placePhone']),
        ticketId: int.parse(json['ticketId'])
    );
  }
}