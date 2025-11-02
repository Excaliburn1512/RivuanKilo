import 'package:flutter/material.dart';
import 'package:rivu_v1/pages/controlsensor/view/controlview.dart';
import 'package:rivu_v1/pages/dashboard/view/dashboardview.dart';
import 'package:rivu_v1/pages/detect/view/detectview.dart';
import 'package:rivu_v1/pages/history/view/historyview.dart';
import 'package:rivu_v1/pages/profile/view/profileview.dart';
import 'package:rivu_v1/usermodel.dart';
import 'package:rivu_v1/widget/bottomnavbar.dart';

class Home extends StatefulWidget {
  final Usermodel user;
  const Home({Key? key, required this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;
@override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      Dashboard(),
      DetectPage(),
      ControlSensor(),
      HistoryView(),
      ProfileView(),
    ];
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }
}
