import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pinz/src/location/location_service.dart';

class LocationController with ChangeNotifier {
  LocationController(this._locationService);

  final LocationService _locationService;

  late bool _permissionGranted;
  bool get permissionGranted => _permissionGranted;

  bool _followLocation = false;
  bool get followLocation => _followLocation;

  Future<void> requestLocationPermission() async {
    _permissionGranted = await _locationService.requestLocationPermission();
    notifyListeners();
  }

  Future<Position> getCurrentLocation() async {
    if(!_permissionGranted) {
      requestLocationPermission();
    }
    return await _locationService.getCurrentLocation();
  }

  void setFollowLocation(bool value) {
    _followLocation = value;
    notifyListeners();
  }

}
