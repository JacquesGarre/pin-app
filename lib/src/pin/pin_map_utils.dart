import 'dart:math';

import 'package:latlong2/latlong.dart';

class PinMapUtils {


  static double calculateBearing(LatLng from, LatLng to) {
    final double lat1 = from.latitude * pi / 180.0;
    final double lon1 = from.longitude * pi / 180.0;
    final double lat2 = to.latitude * pi / 180.0;
    final double lon2 = to.longitude * pi / 180.0;
    final double dLon = lon2 - lon1;
    final double y = sin(dLon) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    final double bearing = atan2(y, x);
    return (bearing * 180.0 / pi + 360.0) % 360.0;
  }

  static double calculateDistance(LatLng from, LatLng to) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, from, to);
  }

}