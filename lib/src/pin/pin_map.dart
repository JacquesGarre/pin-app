import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pinz/src/location/location_controller.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _markerPosition = widget.initialPosition;
    _setCurrentLocation();
  }

  Future<void> _setCurrentLocation() async {
    final locationController = Provider.of<LocationController>(context, listen: false);
    await locationController.requestLocationPermission();
    if (locationController.permissionGranted) {
      final position = await locationController.getCurrentLocation();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _markerPosition ??  _currentLocation ?? const LatLng(45.521563, -122.677433),
        initialZoom: 13.0,
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
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            if (_currentLocation != null)
              Marker(
                  point: _currentLocation!,
                  width: 40.0,
                  height: 40.0,
                  child: const Icon(
                    Icons.circle,
                    size: 20.0,
                    color: Colors.blue,
                  ),
                  rotate: true),
            if (_markerPosition != null)
              Marker(
                  point: _markerPosition!,
                  width: 80.0,
                  height: 80.0,
                  child: const Icon(
                    Icons.location_on,
                    size: 40.0,
                    color: Colors.red,
                  ),
                  rotate: true),
          ],
        ),
      ],
    );
  }
}
