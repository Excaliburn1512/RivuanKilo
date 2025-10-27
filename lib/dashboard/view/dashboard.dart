import 'package:flutter/material.dart';
import 'package:rivu_v1/widget/grititem.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image(
              image: AssetImage("assets/background/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Icon(Icons.circle, size: 60, color: Colors.grey),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Selamat Datang", style: TextStyle()),
                      Text(
                        "Pajrin",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                height: MediaQuery.of(context).size.height * 0.23,
                width: MediaQuery.of(context).size.width * 0.83,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(33.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    GridItemCard(
                      child: Text(
                        'Menu 1',
                        style: TextStyle(color: Colors.black54),
                      ),
                      onTap: () {
                        print('Menu 1 diklik');
                      },
                    ),
                    GridItemCard(
                      child: Text(
                        'Menu 2',
                        style: TextStyle(color: Colors.black54),
                      ),
                      onTap: () {},
                    ),
                    GridItemCard(
                      child: Text(
                        'Menu 3',
                        style: TextStyle(color: Colors.black54),
                      ),
                      onTap: () {},
                    ),
                    GridItemCard(
                      child: Text(
                        'Menu 4',
                        style: TextStyle(color: Colors.black54),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
