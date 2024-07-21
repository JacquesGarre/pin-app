import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pinz/src/location/location_controller.dart';
import 'package:pinz/src/pin/pin_map_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_compass/flutter_compass.dart';

class PinMap extends StatefulWidget {
  final LatLng? initialPosition;
  final void Function(LatLng) onMarkerChanged;
  final bool readOnly;


  const PinMap(
      {super.key,
      this.initialPosition,
      required this.onMarkerChanged,
      this.readOnly = false});

  @override
  PinMapState createState() => PinMapState();
}

class PinMapState extends State<PinMap> {
  LatLng? _markerPosition;
  LatLng? _currentLocation;
  final MapController _mapController = MapController();
  bool _isLoading = true;

  double _heading = 0;
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<CompassEvent>? _headingStreamSubscription;
  final Completer<void> _mapReadyCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    _markerPosition = widget.initialPosition;
    _setCurrentLocation();
    _listenForHeadingUpdates();
    _listenForLocationUpdates();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _headingStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _setCurrentLocation() async {
    final locationController =
        Provider.of<LocationController>(context, listen: false);
    final position = await locationController.getCurrentLocation();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
  }

  void _listenForLocationUpdates() {
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _updateMap();
      });
    });
  }

  void _listenForHeadingUpdates() {
    _headingStreamSubscription = 
        FlutterCompass.events?.listen((event) {
      setState(() {
        _heading = event.heading ?? 0;
        _updateMap();
      });
    });
  }

  void _updateMap() {
    _mapReadyCompleter.future.then((_) {
      bool followLocation = Provider.of<LocationController>(context, listen: false).followLocation;
      if (_currentLocation!=null && widget.readOnly && followLocation) {
        _mapController.moveAndRotate(_currentLocation!, _mapController.camera.zoom, -_heading);
      }
    });
  }

  LatLng _initialCenter() {
    LatLng center = const LatLng(45.521563, -122.677433);
    if (widget.readOnly) {
      center = _currentLocation ?? _markerPosition ?? center;
    } else {
      center = _markerPosition ?? center;
    }
    return center;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final double bearing = _markerPosition != null && _currentLocation != null
        ? PinMapUtils.calculateBearing(_currentLocation!, _markerPosition!)
        : 0.0;
    final double distance = _markerPosition != null && _currentLocation != null
        ? PinMapUtils.calculateDistance(_currentLocation!, _markerPosition!)
        : 0.0;

    return Column(
      children: [
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter(),
              initialZoom: 17.0,
              initialRotation: -_heading,
              onMapReady: () {
                if (!_mapReadyCompleter.isCompleted) {
                  _mapReadyCompleter.complete();
                }
              },
              onPointerDown: (event, point) => {
               setState(() {
                  Provider.of<LocationController>(context, listen: false).setFollowLocation(false);
                })
              },
              onTap: widget.readOnly
                  ? null
                  : (tapPosition, point) {
                      setState(() {
                        _markerPosition = point;
                        widget.onMarkerChanged(point);
                      });
                    },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  if (_currentLocation != null && widget.readOnly)
                    Marker(
                      point: _currentLocation!,
                      width: 40.0,
                      height: 40.0,
                      child: Transform.rotate(
                        angle: bearing * pi / 180,
                        child: const Icon(
                          Icons.swipe_up_alt,
                          size: 50.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  if (_markerPosition != null)
                    Marker(
                      point: _markerPosition!,
                      width: 80.0,
                      height: 80.0,
                      child: const Icon(
                        Icons.push_pin,
                        size: 40.0,
                        color: Colors.red,
                      ),
                      rotate: true
                    ),
                ],
              ),
            ],
          ),
        ),
        if (_markerPosition != null && _currentLocation != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Distance to Pin: ${distance.toStringAsFixed(2)} meters'),
              ],
            ),
          ),
      ],
    );
  }
}
