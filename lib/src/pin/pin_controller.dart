import 'package:flutter/material.dart';
import 'package:pinz/src/pin/pin.dart';
import 'package:pinz/src/pin/pin_service.dart';

class PinController with ChangeNotifier {
  PinController(this._pinService);

  final PinService _pinService;
  late []<Pin> _pins;

  []<Pin> get pins => _pins;

  Future<void> loadPins() async {
    _pins = await _pinService.pins();
    notifyListeners();
  }

}
