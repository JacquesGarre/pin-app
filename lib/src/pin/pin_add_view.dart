import 'package:flutter/material.dart';
import 'package:pinz/src/pin/pin_controller.dart';
import 'package:pinz/src/pin/pin_form.dart';
import 'package:provider/provider.dart';

class PinAddView extends StatelessWidget {
  const PinAddView({super.key});
  static const routeName = '/pin-add';

  @override
  Widget build(BuildContext context) {
  final controller = Provider.of<PinController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("New pin"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PinForm(controller: controller),
      ),
    );
  }
}
