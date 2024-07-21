import 'package:pinz/src/pin/pin.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PinService {

  static const String _pinsStorageKey = 'pins';

  Future<List<Pin>> pins() async {
    final prefs = await SharedPreferences.getInstance();
    final String? pinsJson = prefs.getString(_pinsStorageKey);
    if (pinsJson != null) {
      List<dynamic> pinsList = jsonDecode(pinsJson);
      return pinsList.map((pin) => Pin.fromJson(pin)).toList();
    } else {
      return [];
    }
  }

  Future<void> addPin(Pin pin) async {
    final prefs = await SharedPreferences.getInstance();
    List<Pin> currentPins = await pins();
    currentPins.add(pin);
    final String pinsJson = jsonEncode(currentPins.map((pin) => pin.toJson()).toList());
    await prefs.setString(_pinsStorageKey, pinsJson);
  }

  Future<void> updatePin(Pin pin) async {
    final prefs = await SharedPreferences.getInstance();
    List<Pin> currentPins = await pins();
    final index = currentPins.indexWhere((pin) => pin.id == pin.id);
    if (index == -1) {
      return;
    }
    currentPins[index] = pin;
    final String pinsJson = jsonEncode(currentPins.map((pin) => pin.toJson()).toList());
    await prefs.setString(_pinsStorageKey, pinsJson);
  }

  Future<void> deletePin(Pin pin) async {
    final prefs = await SharedPreferences.getInstance();
    List<Pin> currentPins = await pins();
    final index = currentPins.indexWhere((pin) => pin.id == pin.id);
    if (index == -1) {
      return;
    }
    currentPins.removeAt(index);
    final String pinsJson = jsonEncode(currentPins.map((pin) => pin.toJson()).toList());
    await prefs.setString(_pinsStorageKey, pinsJson);
  }

}
