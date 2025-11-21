import 'package:flutter/material.dart';
import 'package:rivu_v1/widget/togglebar.dart';
import 'package:rivu_v1/widget/filtertab3.dart';
import 'package:rivu_v1/widget/listitem.dart';
class HistoryView extends StatefulWidget {
  const HistoryView({super.key});
  @override
  State<HistoryView> createState() => _HistoryViewState();
}
class _HistoryViewState extends State<HistoryView> {
  bool _isTanamanView = true;
  int _subFilterIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          ToggleBar(
            title: "History",
            isTanamanView: _isTanamanView,
            onTanamanPressed: () {
              setState(() {
                _isTanamanView = true;
              });
            },
            onPompaPressed: () {
              setState(() {
                _isTanamanView = false;
              });
            },
          ),
          SizedBox(height: 16),
          SubFilterBar(
            activeIndex: _subFilterIndex,
            onFilterPressed: (index) {
              setState(() {
                _subFilterIndex = index;
              });
            },
          ),
          SizedBox(height: 10),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _isTanamanView
                ? _buildTanamanList() 
                : _buildPompaList(),
          ),
        ],
      ),
    );
  }
  Widget _buildTanamanList() {
    final List<Map<String, String>> tanamanHistory = [
      {
        "title": "Kerusakan Tanaman",
        "status": "Tanaman mengalami perubahan...",
      },
      {
        "title": "Kerusakan Tanaman",
        "status": "Tanaman mengalami perubahan...",
      },
      {
        "title": "Kerusakan Tanaman",
        "status": "Tanaman mengalami perubahan...",
      },
      {
        "title": "Kerusakan Tanaman",
        "status": "Tanaman mengalami perubahan...",
      },
      {
        "title": "Kerusakan Tanaman",
        "status": "Tanaman mengalami perubahan...",
      },
    ];
    return ListView.builder(
      key: ValueKey('tanaman_list'), 
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tanamanHistory.length,
      itemBuilder: (context, index) {
        return ListItem(
          title: tanamanHistory[index]['title']!,
          date: "27/10/2025",
          statusText: tanamanHistory[index]['status']!,
          isStatusActive: null,
        );
      },
    );
  }
  Widget _buildPompaList() {
    final List<Map<String, dynamic>> pompaHistory = [
      {"title": "Pompa Kolam", "status": "Non Aktif", "active": false},
      {"title": "Pompa Kolam", "status": "Aktif", "active": true},
      {"title": "Pompa Nutrisi", "status": "Non Aktif", "active": false},
      {"title": "Pompa Nutrisi", "status": "Aktif", "active": true},
      {"title": "Pompa Kolam", "status": "Aktif", "active": true},
      {"title": "Pompa Nutrisi", "status": "Non Aktif", "active": false},
    ];
    return ListView.builder(
      key: ValueKey('pompa_list'), 
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemCount: pompaHistory.length,
      itemBuilder: (context, index) {
        return ListItem(
          title: pompaHistory[index]['title']!,
          date: "27/10/2025",
          statusText: pompaHistory[index]['status']!,
          isStatusActive:
              pompaHistory[index]['active']!, 
        );
      },
    );
  }
}
