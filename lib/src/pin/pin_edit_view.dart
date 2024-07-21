import 'package:flutter/material.dart';
import 'package:pinz/src/pin/pin.dart';
import 'package:pinz/src/pin/pin_controller.dart';
import 'package:pinz/src/pin/pin_form.dart';
import 'package:provider/provider.dart';

class PinEditView extends StatelessWidget {
  const PinEditView({super.key, required this.pin});
  static const routeName = '/pin-edit';

  final Pin pin;

  @override
  Widget build(BuildContext context) {
  final controller = Provider.of<PinController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${pin.title} pin"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PinForm(pin: pin, controller: controller),
      ),
    );
  }
}
