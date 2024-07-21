import 'package:pinz/src/pin/pin.dart';

class PinService {
  Future<Set<List<Pin>>> pins() async => {
        [
          const Pin(1, 'Home'),
          const Pin(2, 'Groceries'),
          const Pin(3, 'Start of hike')
        ]
      };
}
