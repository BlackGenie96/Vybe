import 'package:flutter/material.dart';
import 'package:vybe_2/Views/Categories/Categories.dart';
import 'package:vybe_2/Views/Home/Home.dart';
import 'package:vybe_2/Views/Notifications/Notifications.dart';
import 'package:vybe_2/Views/Post/Post.dart';
import 'package:vybe_2/Views/settings/Settings.dart';

class Navigation extends StatefulWidget{
  @override
  _NavigationState createState() => new _NavigationState();
}

class _NavigationState extends State<Navigation>{

  int _selectedPage = 0;
  List<Widget> pageList = List<Widget>();

  @override
  void initState() {

    super.initState();

    pageList.add(Home());
    pageList.add(Categories());
    pageList.add(Post());
    pageList.add(Notifications());
    pageList.add(Settings());
  }

  void _selectTab(int index){
    setState((){
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: IndexedStack(
        index: _selectedPage,
        children: pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xff301370)),
            title: Text('Home', style: TextStyle(fontFamily:'SF-Pro',color: Color(0xff301370))),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, color: Color(0xff301370)),
            title: Text('Category', style: TextStyle(fontFamily: 'SF-Pro', color: Color(0xff301370))),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add, color: Color(0xff301370)),
            title: Text('Post', style:TextStyle(fontFamily:'SF-Pro', color: Color(0xff301370))),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color:Color(0xff301370)),
            title: Text('Notifications',style: TextStyle(fontFamily: 'SF-Pro', color: Color(0xff301370))),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Color(0xff301370)),
            title: Text('Settings', style:TextStyle(fontFamily: 'SF-Pro', color:Color(0xff301370))),
          ),
        ],
        currentIndex: _selectedPage,
        onTap: _selectTab,
      ),
    );
  }
}