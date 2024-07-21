import 'package:flutter/material.dart';
import 'package:pinz/src/pin/pin_add_view.dart';
import 'package:pinz/src/pin/pin_controller.dart';
import '../settings/settings_view.dart';
import 'pin_details_view.dart';

class PinListView extends StatelessWidget {
  const PinListView({super.key, required this.controller});

  static const routeName = '/';

  final PinController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My pins'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: ListView.builder(
        restorationId: 'PinListView',
        itemCount: controller.pins.length,
        itemBuilder: (BuildContext context, int index) {
          final pin = controller.pins[index];
          return ListTile(
              title: Text(pin.title),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PinDetailsView(pin: pin),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PinAddView(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
