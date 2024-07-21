import 'package:flutter/material.dart';
import 'package:pinz/src/pin/pin_add_view.dart';
import 'package:pinz/src/pin/pin_controller.dart';
import 'package:pinz/src/pin/pin_edit_view.dart';
import 'package:provider/provider.dart';
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
      body: Consumer<PinController>(
        builder: (context, controller, child) {
          return ListView.builder(
            restorationId: 'PinListView',
            itemCount: controller.pins.length,
            itemBuilder: (BuildContext context, int index) {
              final pin = controller.pins[index];
              return ListTile(
                title: Text(pin.title),
                                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PinEditView(pin: pin),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        controller.deletePin(pin);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PinDetailsView(pin: pin),
                    ),
                  );
                },
              );
            },
          );
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
