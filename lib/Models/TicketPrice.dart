class TicketPrice{
  int ticketId;
  String preSaleGeneralPrice;
  String preSaleVIPPrice;
  String preSaleVVIPPRice;
  String gateGeneralPrice;
  String gateVIPPrice;
  String gateVVIPPrice;

  TicketPrice({this.ticketId, this.preSaleGeneralPrice, this.preSaleVIPPrice, this.preSaleVVIPPRice, this.gateGeneralPrice, this.gateVIPPrice, this.gateVVIPPrice});

  factory TicketPrice.fromJson(Map<String, dynamic> json){
    return TicketPrice(
        ticketId: int.parse(json['ticketId']),
        preSaleGeneralPrice: json['presaleGeneral'],
        preSaleVIPPrice: json['presaleVIP'],
        preSaleVVIPPRice: json['presaleVVIP'],
        gateGeneralPrice : json['gateGeneral'],
        gateVIPPrice: json['gateVIP'],
        gateVVIPPrice: json['gateVVIP']
    );
  }
}
