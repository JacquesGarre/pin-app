import 'package:flutter/material.dart';
import 'package:pinz/src/pin/pin.dart';

class PinForm extends StatefulWidget {
  final Pin? pin;

  const PinForm({super.key, this.pin});

  @override
  PinFormState createState() => PinFormState();
}

class PinFormState extends State<PinForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pin != null) {
      _titleController.text = widget.pin!.title;
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
      );
      // Handle the form submission (e.g., save the pin)
      print('Pin saved: ${newPin.title}');
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
          ElevatedButton(
            onPressed: _submit,
            child: Text(widget.pin == null ? 'Add Pin' : 'Update Pin'),
          ),
        ],
      ),
    );
  }
}