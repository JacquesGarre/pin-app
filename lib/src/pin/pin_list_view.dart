import 'package:flutter/material.dart';
import 'package:pinz/src/location/location_controller.dart';
import 'package:pinz/src/pin/pin_add_view.dart';
import 'package:pinz/src/pin/pin_controller.dart';
import 'package:pinz/src/pin/pin_edit_view.dart';
import 'package:provider/provider.dart';
import '../settings/settings_view.dart';
import 'pin_details_view.dart';

class PinListView extends StatefulWidget {
  const PinListView({super.key, required this.controller});
  final PinController controller;
  static const routeName = '/';

  @override
  PinListViewState createState() => PinListViewState();
}

class PinListViewState extends State<PinListView> {
  @override
  void initState() {
    super.initState();
    // Request location permission when the app loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestPermission();
    });
  }

  Future<void> _checkAndRequestPermission() async {
    final locationController = Provider.of<LocationController>(context, listen: false);
    await locationController.requestLocationPermission();
    if (!locationController.permissionGranted) {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text('This app requires location permission to function. Please grant the permission.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Grant Permission'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _checkAndRequestPermission();
              },
            ),
          ],
        );
      },
    );
  }

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
