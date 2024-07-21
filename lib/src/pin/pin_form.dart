import 'package:flutter/material.dart';
import 'package:pinz/src/pin/pin.dart';
import 'package:pinz/src/pin/pin_controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PinForm extends StatefulWidget {
  final Pin? pin;
  final PinController controller;

  const PinForm({super.key, this.pin, required this.controller});

  @override
  PinFormState createState() => PinFormState();
}

class PinFormState extends State<PinForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  LatLng? _markerPosition;

  @override
  void initState() {
    super.initState();
    if (widget.pin != null) {
      _titleController.text = widget.pin!.title;
      if (widget.pin!.latitude != null && widget.pin!.longitude != null) {
        _markerPosition = LatLng(widget.pin!.latitude!, widget.pin!.longitude!);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newPin = Pin(
        widget.pin?.id ?? DateTime.now().millisecondsSinceEpoch,
        _titleController.text,
        _markerPosition?.latitude,
        _markerPosition?.longitude,
      );
      if (widget.pin == null) {
        widget.controller.addPin(newPin);
      } else {
        widget.controller.updatePin(newPin);
      }
      Navigator.of(context).pop(newPin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _markerPosition ?? const LatLng(45.521563, -122.677433),
                initialZoom: 13.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _markerPosition = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
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
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            child: Text(widget.pin == null ? 'Add Pin' : 'Update Pin'),
          ),
        ],
      ),
    );
  }
}