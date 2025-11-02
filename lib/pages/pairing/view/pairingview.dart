import 'package:flutter/material.dart';

class PairingView extends StatefulWidget {
  const PairingView({super.key});

  @override
  State<PairingView> createState() => _PairingViewState();
}
class _PairingViewState extends State<PairingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Pairing View Page"),
      ),
    );
  }
}