import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PinMap extends StatefulWidget {
  final LatLng? initialPosition;
  final void Function(LatLng) onMarkerChanged;
  final bool readOnly;

  const PinMap(
      {super.key, this.initialPosition, required this.onMarkerChanged, this.readOnly = false});

  @override
  PinMapState createState() => PinMapState();
}

class PinMapState extends State<PinMap> {
  LatLng? _markerPosition;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _markerPosition = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _markerPosition ?? const LatLng(45.521563, -122.677433),
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
        if (_markerPosition != null)
          MarkerLayer(
            markers: [
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
