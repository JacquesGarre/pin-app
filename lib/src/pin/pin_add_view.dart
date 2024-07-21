import 'package:flutter/material.dart';
import 'package:pinz/src/pin/pin_form.dart';

class PinAddView extends StatelessWidget {
  const PinAddView({super.key});

  static const routeName = '/pin-add';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New pin"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: PinForm(),
      ),
    );
  }
}
