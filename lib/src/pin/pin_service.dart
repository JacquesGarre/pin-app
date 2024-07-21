import 'package:pinz/src/pin/pin.dart';

class PinService {
  Future<List<Pin>> pins() async {
    const List<Pin> pins = [
      Pin(1, 'Home'),
      Pin(2, 'Groceries'),
      Pin(3, 'Start of hike')
    ];
    return pins;
  }
}
