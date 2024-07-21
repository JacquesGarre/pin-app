import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      return false;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
