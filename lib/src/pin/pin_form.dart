import 'package:flutter/material.dart';
import 'package:pinz/src/location/location_controller.dart';
import 'package:pinz/src/pin/pin.dart';
import 'package:pinz/src/pin/pin_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:pinz/src/pin/pin_map.dart';
import 'package:provider/provider.dart';

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
  String? _markerError;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.pin != null) {
      _titleController.text = widget.pin!.title;
      _markerPosition = LatLng(widget.pin!.latitude, widget.pin!.longitude);
      _isLoading = false;
    } else {
      _setCurrentLocation();
    }
  }

  Future<void> _setCurrentLocation() async {
    final locationController = Provider.of<LocationController>(context, listen: false);
    await locationController.requestLocationPermission();
    if (locationController.permissionGranted) {
      final position = await locationController.getCurrentLocation();
      setState(() {
        _markerPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } else {
      setState(() {
        _markerError = 'Location permission is required to set the default location.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_markerPosition == null) {
        setState(() {
          _markerError = 'Please place a marker on the map';
        });
        return;
      }
      final newPin = Pin(
        widget.pin?.id ?? DateTime.now().millisecondsSinceEpoch,
        _titleController.text,
        _markerPosition!.latitude,
        _markerPosition!.longitude,
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
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Form(
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
            child: PinMap(
              initialPosition: _markerPosition,
              onMarkerChanged: (position) {
                setState(() {
                  _markerPosition = position;
                  _markerError = null;
                });
              },
            ),
          ),
          if (_markerError != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _markerError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
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
