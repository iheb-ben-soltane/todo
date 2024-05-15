import 'package:flutter/material.dart';
import 'package:to_do/screens/home/home.dart';
import 'package:to_do/screens/newTask/newTask.dart';
import 'package:to_do/screens/settings/profile.dart';

class App extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<App> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    DisplayTasksScreen(),
    // Search(),
    NewTask(),
    //ChatsList(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.search),
            //   label: 'Search',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Activity',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.message),
            //   label: 'Messages',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Color.fromARGB(101, 34, 120, 154),
          selectedItemColor: Color.fromARGB(255, 16, 83, 110),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
