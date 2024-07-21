import 'package:flutter/material.dart';
import 'package:pinz/src/pin/pin.dart';
import 'package:pinz/src/pin/pin_service.dart';

class PinController with ChangeNotifier {
  PinController(this._pinService);

  final PinService _pinService;
  late List<Pin> _pins;

  List<Pin> get pins => _pins;

  Future<void> loadPins() async {
    _pins = await _pinService.pins();
    notifyListeners();
  }

  Future<void> addPin(Pin pin) async {
    _pins.add(pin);
    notifyListeners();    
    await _pinService.addPin(pin);
  }

    Future<void> updatePin(Pin pin) async {
    final index = _pins.indexWhere((p) => p.id == pin.id);
    if (index != -1) {
      _pins[index] = pin;
      notifyListeners();
      await _pinService.updatePin(pin);
    }
  }

  Future<void> deletePin(Pin pin) async {
    _pins.removeWhere((p) => p.id == pin.id);
    notifyListeners();
    await _pinService.deletePin(pin);
  }

}
