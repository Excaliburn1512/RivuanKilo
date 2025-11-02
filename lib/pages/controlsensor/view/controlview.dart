import 'package:flutter/material.dart';

class ControlSensor extends StatefulWidget {
  const ControlSensor({super.key});

  @override
  State<ControlSensor> createState() => _ControlSensorState();
}

class _ControlSensorState extends State<ControlSensor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Control Sensor Page"),
      ),
    );
  }
}