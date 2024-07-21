import 'package:flutter/material.dart';
import 'package:pinz/src/location/location_controller.dart';
import 'package:pinz/src/location/location_service.dart';
import 'package:pinz/src/pin/pin_controller.dart';
import 'package:pinz/src/pin/pin_service.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final settingsController = SettingsController(SettingsService());
  final pinController = PinController(PinService());
  final locationController = LocationController(LocationService());

  await settingsController.loadSettings();
  await pinController.loadPins();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingsController),
        ChangeNotifierProvider(create: (_) => pinController),
        ChangeNotifierProvider(create: (_) => locationController),
      ],
      child: PinApp(
        settingsController: settingsController,
        pinController: pinController,
        locationController: locationController,
      ),
    ),
  );
}
