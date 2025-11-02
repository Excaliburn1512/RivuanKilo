import 'package:flutter/material.dart';
import 'package:rivu_v1/pages/controlsensor/view/controlview.dart';
import 'package:rivu_v1/pages/dashboard/view/dashboardview.dart';
import 'package:rivu_v1/pages/detect/view/detectview.dart';
import 'package:rivu_v1/pages/history/view/historyview.dart';
import 'package:rivu_v1/pages/profile/view/profileview.dart';
import 'package:rivu_v1/widget/bottomnavbar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    DetectPage(),
    ControlSensor(),
    HistoryView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }
}
