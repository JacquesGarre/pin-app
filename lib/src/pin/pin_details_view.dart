import 'package:flutter/material.dart';

/// Displays detailed information about a Pin.
class PinDetailsView extends StatelessWidget {
  const PinDetailsView({super.key});

  static const routeName = '/pin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pin location'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
