import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:pinz/src/location/location_controller.dart';
import 'package:pinz/src/pin/pin.dart';
import 'package:pinz/src/pin/pin_map.dart';
import 'package:provider/provider.dart';

class PinDetailsView extends StatelessWidget {
  const PinDetailsView({super.key, required this.pin});

  static const routeName = '/pin-details';
  final Pin pin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pin.title),
      ),
      body: Column(
        children: [          
          Expanded(
            child: PinMap(
              initialPosition: LatLng(pin.latitude, pin.longitude),
              onMarkerChanged: (position) {},
              readOnly: true,
            ),
          ),]
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<LocationController>(context, listen: false)
              .setFollowLocation(true);
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
