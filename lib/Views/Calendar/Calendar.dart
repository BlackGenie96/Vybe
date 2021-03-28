import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:vybe_2/Data/CalendarService.dart';
import 'package:vybe_2/Models/CalendarItemData.dart';
import 'package:vybe_2/Models/EventItem.dart';
import 'package:vybe_2/Views/EventProfile/EventProfile.dart';
import 'package:vybe_2/Views/tutorial/CalendarTutorial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vybe_2/Views/settings/controller.dart';

class Calendar extends StatefulWidget{
  @override
  _CalendarState createState() => new _CalendarState();
}

class _CalendarState extends State<Calendar> with SingleTickerProviderStateMixin{

  //Calendar variables
  List<CalendarItemData> calendarList;
  Map<DateTime,List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  var _selectedDay;
  int chosenCategory;
  SharedPreferences prefs;

  CalendarService service = new CalendarService();

  @override
  void initState(){
    super.initState();

    _selectedDay = DateTime.now();
    _calendarController = CalendarController();
    _animationController = new AnimationController(
      duration: new Duration(milliseconds:400),
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose(){
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events){

    setState((){
      _selectedDay = DateTime(day.year, day.month, day.day);
      _selectedEvents = _events[_selectedDay] ?? [];
    });
  }

  void _onVisibleDayChanged(DateTime first, DateTime last, CalendarFormat format){
    print('CALLBACK: _onVisibleDayChanged');
  }

  void _showOverlay(BuildContext context){
    Navigator.push(context, CalendarOverlay());
  }

  @override
  Widget build(BuildContext context){
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Color(0xff301370),
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
      ),
      child: new Builder(
        builder:(context)=> Scaffold(
          appBar: AppBar(
            title: Text('Calendar',style: TextStyle(fontFamily:'SF-Pro',color:Colors.white,)),
            backgroundColor: Color(0xff301370),
              iconTheme: IconTheme.of(context).copyWith(
                  color: Colors.white
              ),
          ),
          body: Center(
            child: _buildEventList1(),
          ),
        ),
      )
    );
  }

  Widget buildBody(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _buildTableCalendarWithBuilders(),
        const SizedBox(height:8.0),
        const SizedBox(height: 8.0),
        Expanded(child: _buildEventList()),
      ],
    );
  }

  Widget _buildTableCalendarWithBuilders(){
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const{
        CalendarFormat.month: '',
        CalendarFormat.week: ''
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color:Color(0xffcd5e14)),
        holidayStyle: TextStyle().copyWith(color:Color(0xffcd5e14))
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color:Color(0xffcd5e14))
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date,_){
          return FadeTransition(
            opacity: Tween(begin:0.0,end:1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0,left:6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize:16.0),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays){
          final children = <Widget>[];

          if(events.isNotEmpty){
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if(holidays.isNotEmpty){
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date,events){
        _onDaySelected(date,events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDayChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events){
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date) ? Color(0xff301370) : _calendarController.isToday(date) ? Colors.brown[300] : Color(0xff301370),
      ),
      width: 16,
      height: 16,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color:Colors.white,
            fontSize:12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker(){
    return Icon(
      Icons.add_box,
      size:20.0,
      color: Colors.blueGrey[800],
    );
  }


  Widget _buildEventList(){
    print('building listview.');
    return ListView(
      children: _selectedEvents.map((event) => Container(
            decoration: BoxDecoration(
              color: Color(0xff301370),
              borderRadius: BorderRadius.circular(12.0)
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              title: Text('${event.toString()}',style:TextStyle(color:Colors.white,fontFamily:'SF-Pro',fontWeight:FontWeight.w700)),
              onTap: () => Navigator.of(context).push(
               MaterialPageRoute(
                  builder: (context){
                    for(int i=0; i < calendarList.length; i++){
                      CalendarItemData temp = calendarList[i];
                      if(event.toString() == temp.eventName){
                        return EventProfile(item: new EventItem(eventId: int.parse(temp.eventId),eventName:temp.eventName));
                      }
                    }
                  }
               )
              ),
            ),
          ),
      ).toList(),
    );
  }

  Widget _buildEventList1(){
    return FutureBuilder<List<CalendarItemData>>(
      future: service.fetchCalendarItems(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          //parse json array here and input the list of events for the months
          List<CalendarItemData> snapData = snapshot.data;
          calendarList = snapData;
          _events = convertToMap(snapData);
          print(_events.toString());
          _selectedEvents = _events[_selectedDay] ?? [];

          service.tutorialState().then((bool val){
            if(val == true){
              _showOverlay(context);
            }
          });

          return buildBody();
        }else if(snapshot.hasError){
          return Padding(
            padding: const EdgeInsets.all(10),
            child:Text(
              'There are no events in the Calendar for the selected category.',
              style:TextStyle(
                  fontFamily:'SF-Pro',
                  fontWeight:FontWeight.bold,
                  fontSize:18),
              textAlign:TextAlign.center,
            ),
          );
        }

        return CircularProgressIndicator(backgroundColor: Colors.white);
      }
    );
  }
  
  //method to change calendar item to Map<DateTime,List>
  Map<DateTime,List> convertToMap(List<CalendarItemData> item){
    Map<DateTime, List> result;

    for(int i = 0; i < item.length; i++){
      CalendarItemData data = item[i];
      //get the date and convert it to a DateTime variable
      DateTime currentDate = dateFormat.parse(data.eventDate);
      List eventNames = [];
      //add the event name to the the eventNames list for the current date.
      //search for another event with the same date and populate the eventNames List.
      for(int j = 0; j < item.length; j++){
        //create temp calendarItemData object.
        CalendarItemData temp = item[j];
        //establish that the temp date is equal to the current date
        if(data.eventDate == temp.eventDate) {
          //add the event name to the event List.
          eventNames.add(temp.eventName);
        } //else continue
      }

      //add the date and the event to the map if the date is not contained in the map
      if(result == null){
        result = {
          currentDate: eventNames
        };
      }else {
        result[currentDate] = eventNames;
      }
    }

    print(result);
    return result;
  }

  AppBar createToolbar() => AppBar(
    title: Text('Calendar',style:TextStyle(fontFamily:'SF-Pro',color: Colors.white,),),
    backgroundColor: Color(0xff301370),
    iconTheme:IconTheme.of(context).copyWith(
      color:Colors.white,
    ),
  );
}
