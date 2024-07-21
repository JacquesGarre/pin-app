import 'package:flutter/material.dart';
import 'package:pinz/src/pin/pin_controller.dart';
import 'package:pinz/src/pin/pin_service.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {

  final settingsController = SettingsController(SettingsService());
  final pinController = PinController(PinService());

  await settingsController.loadSettings();
  await pinController.loadPins();

  runApp(PinApp(
    settingsController: settingsController,
    pinController: pinController
  ));
}
