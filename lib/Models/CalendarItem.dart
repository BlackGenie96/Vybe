import 'package:vybe_2/Models/CalendarItemData.dart';

class CalendarItem{
  int success;
  String message;
  List<CalendarItemData> data;

  CalendarItem({this.success, this.message, this.data});

  factory CalendarItem.fromJson(Map<String,dynamic> json){
    return CalendarItem(
        success: json['success'],
        message: json['message'],
        data   : json['data']
    );
  }
}