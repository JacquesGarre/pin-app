import 'package:flutter/material.dart';
import 'package:pinz/src/pin/pin.dart';

class PinDetailsView extends StatelessWidget {
  const PinDetailsView({super.key, required this.pin});

  static const routeName = '/pin-details';
  final Pin pin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pin.title),
      ),
      body: Center(
        child: Text(pin.title),
      ),
    );
  }
}
